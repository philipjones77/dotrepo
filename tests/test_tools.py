import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
DOCTOR_SPEC = importlib.util.spec_from_file_location('doctor', ROOT / 'scripts/doctor.py')
doctor = importlib.util.module_from_spec(DOCTOR_SPEC)
DOCTOR_SPEC.loader.exec_module(doctor)

class ToolTests(unittest.TestCase):
    def test_windows_editor_installer_applies_local_override(self):
        self.run_bootstrap_functions('''
$BackupRoot = Join-Path $Fixture 'backups'
Set-MergedJsonSettings -Source (Join-Path $Fixture 'settings.json') -Target (Join-Path $Fixture 'live.json')
$actual = Get-Content -Raw (Join-Path $Fixture 'live.json') | ConvertFrom-Json
if ($actual.automation.path -ne 'powershell' -or $actual.automation.args[0] -ne '-NoLogo' -or $actual.viewer -ne 'pdf' -or $actual.custom -ne 'keep') { throw 'Local override or unrelated settings were lost' }
''', files={
            'settings.json': '{"automation":{"path":"pwsh","args":["-NoLogo"]},"viewer":"pdf"}',
            'settings.local.json': '{"automation":{"path":"powershell"}}',
            'live.json': '{"custom":"keep"}',
        })

    def test_local_editor_override_keeps_unrelated_tracked_checks(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            tracked = root / 'settings.json'
            live = root / 'live.json'
            tracked.write_text('{"automation":{"path":"pwsh","args":["-NoLogo"]},"viewer":"pdf"}')
            (root / 'settings.local.json').write_text('{"automation":{"path":"powershell"}}')
            live.write_text('{"automation":{"path":"powershell","args":["-NoLogo"]},"viewer":"pdf"}')
            self.assertTrue(doctor.check_settings(live, tracked))
            live.write_text('{"automation":{"path":"powershell","args":[]},"viewer":"pdf"}')
            self.assertFalse(doctor.check_settings(live, tracked))
            (root / 'settings.local.json').write_text('{invalid')
            self.assertFalse(doctor.check_settings(live, tracked))

    def run_bootstrap_functions(self, body, files=None):
        """Load function definitions only; never execute the workstation installer."""
        engines = list(dict.fromkeys(filter(None, (shutil.which('pwsh'), shutil.which('powershell')))))
        if not engines:
            self.skipTest('Native PowerShell is not installed')
        for engine in engines:
            with self.subTest(engine=engine), tempfile.TemporaryDirectory(dir=Path.home()) as temp:
                directory = Path(temp)
                for name, content in (files or {}).items():
                    (directory / name).write_text(content, encoding='utf-8')
                script = directory / 'check.ps1'
                script.write_text('''param([string]$Installer, [string]$Fixture)
$ErrorActionPreference = 'Stop'
$tokens = $null
$errors = $null
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Installer, [ref]$tokens, [ref]$errors)
if ($errors.Count) { throw ($errors | Out-String) }
foreach ($definition in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)) {
    . ([ScriptBlock]::Create($definition.Extent.Text))
}
$BackupRoot = Join-Path $Fixture 'backups'
''' + body, encoding='utf-8')
                result = subprocess.run([
                    engine, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(script),
                    '-Installer', str(ROOT / 'bootstrap/install.ps1'), '-Fixture', temp,
                ], capture_output=True, text=True, timeout=30)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_profiles_use_redirected_documents(self):
        self.run_bootstrap_functions('''
$documents = Join-Path $Fixture 'OneDrive/Documents'
$paths = @(Get-PowerShellProfilePaths -DocumentsPath $documents)
if ($paths.Count -ne 4) { throw 'Both PowerShell editions need console and VS Code profiles' }
if ($paths[0] -ne (Join-Path $documents 'PowerShell/Microsoft.PowerShell_profile.ps1')) { throw 'Wrong PowerShell 7 profile' }
if ($paths[1] -ne (Join-Path $documents 'WindowsPowerShell/Microsoft.PowerShell_profile.ps1')) { throw 'Wrong Windows PowerShell profile' }
if ($paths[2] -ne (Join-Path $documents 'PowerShell/Microsoft.VSCode_profile.ps1')) { throw 'Wrong PowerShell 7 VS Code profile' }
if ($paths[3] -ne (Join-Path $documents 'WindowsPowerShell/Microsoft.VSCode_profile.ps1')) { throw 'Wrong Windows PowerShell VS Code profile' }
$actualDocuments = [Environment]::GetFolderPath('MyDocuments')
if ($actualDocuments) {
    $actualPaths = @(Get-PowerShellProfilePaths)
    if ($actualPaths[0] -ne (Join-Path $actualDocuments 'PowerShell/Microsoft.PowerShell_profile.ps1')) { throw 'Known folder ignored' }
    if ($actualPaths[2] -ne (Join-Path $actualDocuments 'PowerShell/Microsoft.VSCode_profile.ps1')) { throw 'VS Code ignored known folder' }
}
''')

    def test_vscode_merge_preserves_custom_settings_and_backs_up_once(self):
        self.run_bootstrap_functions('''
$source = Join-Path $Fixture 'tracked.json'
$target = Join-Path $Fixture 'settings.json'
$original = [IO.File]::ReadAllText($target)
Set-MergedJsonSettings -Source $source -Target $target
$merged = Read-JsonSettings -Path $target
if ($merged.'terminal.integrated.defaultProfile.windows' -ne 'Ubuntu Bash') { throw 'Tracked value missing' }
if ($merged.'workbench.colorCustomizations'.custom -ne 'blue') { throw 'Nested custom preference lost' }
if ($merged.'workbench.colorCustomizations'.tracked -ne 'green') { throw 'Nested tracked preference missing' }
if ($merged.'cloud.project' -ne 'local-project') { throw 'Cloud preference lost' }
if ($merged.url -ne 'https://example.test/a//b/*literal*/') { throw 'JSON string changed' }
if ($merged.'commands'.Count -ne 1 -or $merged.'commands'[0] -ne 'tracked') { throw 'Tracked array not applied' }
$backups = @(Get-ChildItem -LiteralPath $BackupRoot -File -Recurse)
if ($backups.Count -ne 1 -or [IO.File]::ReadAllText($backups[0].FullName) -cne $original) { throw 'Original settings not backed up' }
$backupTime = $backups[0].LastWriteTimeUtc
Set-MergedJsonSettings -Source $source -Target $target
if ($backups[0].LastWriteTimeUtc -ne $backupTime) { throw 'Second install rewrote backup' }
if ([IO.File]::ReadAllText($backups[0].FullName) -cne $original) { throw 'Second install replaced backup' }
''', {
            'tracked.json': json.dumps({
                'terminal.integrated.defaultProfile.windows': 'Ubuntu Bash',
                'workbench.colorCustomizations': {'tracked': 'green'}, 'commands': ['tracked'],
            }),
            'settings.json': '''{ // personal settings
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "workbench.colorCustomizations": {"custom": "blue",},
  "cloud.project": "local-project", /* keep this value */
  "url": "https://example.test/a//b/*literal*/",
  "commands": ["old"],
}''',
        })

    def test_terminal_merge_preserves_profiles_shortcuts_and_colors(self):
        self.run_bootstrap_functions('''
$source = Join-Path $Fixture 'tracked.json'
$target = Join-Path $Fixture 'settings.json'
Set-MergedJsonSettings -Source $source -Target $target -Terminal
$merged = Read-JsonSettings -Path $target
if ($merged.defaultProfile -ne '{bash}') { throw 'Default profile not applied' }
if ($merged.copyOnSelect -ne $true) { throw 'Existing top-level preference changed' }
if ($merged.newSetting -ne 'default') { throw 'Missing top-level default not added' }
if ($merged.actions[0].id -ne 'custom-action') { throw 'Custom action lost' }
if ($merged.keybindings[0].keys -ne 'ctrl+alt+x') { throw 'Custom keybinding lost' }
if ($merged.schemes[0].name -ne 'custom-colors' -or $merged.themes[0].name -ne 'custom-theme') { throw 'Custom colors lost' }
if ($merged.profiles.defaults.font.face -ne 'Personal Font') { throw 'Profile defaults changed' }
if ($merged.profiles.list.Count -ne 3) { throw 'Profile removed or duplicated' }
$shared = $merged.profiles.list | Where-Object guid -eq '{existing}'
if ($shared.commandline -ne 'updated' -or $shared.font.size -ne 15) { throw 'Matching profile did not retain local fields' }
$custom = $merged.profiles.list | Where-Object guid -eq '{custom}'
if ($custom.name -ne 'My Project') { throw 'Untracked profile lost' }
$bash = $merged.profiles.list | Where-Object guid -eq '{bash}'
if ($bash.commandline -ne 'wsl.exe -d Ubuntu -- bash -l') { throw 'Bash profile not added' }
Set-MergedJsonSettings -Source $source -Target $target -Terminal
if ((Read-JsonSettings -Path $target).profiles.list.Count -ne 3) { throw 'Second install duplicated profiles' }
''', {
            'tracked.json': json.dumps({
                'defaultProfile': '{bash}', 'copyOnSelect': False, 'newSetting': 'default',
                'actions': [], 'keybindings': [], 'schemes': [], 'themes': [],
                'profiles': {'defaults': {}, 'list': [
                    {'guid': '{existing}', 'commandline': 'updated'},
                    {'guid': '{bash}', 'commandline': 'wsl.exe -d Ubuntu -- bash -l'},
                ]},
            }),
            'settings.json': json.dumps({
                'defaultProfile': '{existing}', 'copyOnSelect': True,
                'actions': [{'id': 'custom-action'}], 'keybindings': [{'keys': 'ctrl+alt+x'}],
                'schemes': [{'name': 'custom-colors'}], 'themes': [{'name': 'custom-theme'}],
                'profiles': {'defaults': {'font': {'face': 'Personal Font'}}, 'list': [
                    {'guid': '{existing}', 'commandline': 'old', 'font': {'size': 15}},
                    {'guid': '{custom}', 'name': 'My Project'},
                ]},
            }),
        })

    def test_invalid_existing_json_is_not_modified(self):
        self.run_bootstrap_functions('''
$source = Join-Path $Fixture 'tracked.json'
$target = Join-Path $Fixture 'settings.json'
$original = [IO.File]::ReadAllText($target)
$failed = $false
try { Set-MergedJsonSettings -Source $source -Target $target } catch { $failed = $true }
if (-not $failed) { throw 'Invalid JSON was accepted' }
if ([IO.File]::ReadAllText($target) -cne $original) { throw 'Invalid settings were changed' }
if (Test-Path -LiteralPath $BackupRoot) { throw 'Invalid settings were moved' }
''', {'tracked.json': '{"tracked": true}', 'settings.json': '{broken'})

    def test_doctor_accepts_extra_vscode_settings_and_detects_drift(self):
        with tempfile.TemporaryDirectory() as temp:
            live, tracked = Path(temp) / 'live.json', Path(temp) / 'tracked.json'
            tracked.write_text('{"shell":"bash","colors":{"tracked":"green"},"enabled":true}')
            live.write_text('''{ // local preferences are allowed
"shell":"bash", "colors":{"tracked":"green","custom":"blue"},
"enabled":true, "url":"https://example.test/a//b/*literal*/",
}''')
            self.assertTrue(doctor.check_settings(live, tracked))
            self.assertEqual(doctor.read_json_settings(live)['url'], 'https://example.test/a//b/*literal*/')
            live.write_text('{"shell":"bash","colors":{"tracked":"red"},"enabled":true}')
            self.assertFalse(doctor.check_settings(live, tracked))
            live.write_text('{"shell":"bash","colors":{"tracked":"green"},"enabled":1}')
            self.assertFalse(doctor.check_settings(live, tracked))
            live.write_text('{broken')
            self.assertFalse(doctor.check_settings(live, tracked))
            live.unlink()
            self.assertFalse(doctor.check_settings(live, tracked))

    def test_doctor_accepts_existing_effective_ssh_identity(self):
        with tempfile.TemporaryDirectory(prefix='ssh identity ') as temp:
            key = Path(temp) / 'id_ed25519'
            key.touch()
            output = f'user git\nidentityfile {key}\nidentityfile {temp}/missing_default\n'
            with mock.patch.object(doctor, 'run', return_value=(0, output, '')) as run:
                passed, detail = doctor.check_ssh_identity()
            self.assertTrue(passed)
            self.assertIn(str(key), detail)
            run.assert_called_once_with(['ssh', '-G', 'github.com'])
            key.unlink()
            with mock.patch.object(doctor, 'run', return_value=(0, output, '')):
                self.assertFalse(doctor.check_ssh_identity()[0])

    def test_doctor_reports_invalid_ssh_configuration(self):
        with mock.patch.object(doctor, 'run', return_value=(255, '', 'Bad configuration option')):
            passed, detail = doctor.check_ssh_identity()
        self.assertFalse(passed)
        self.assertIn('Bad configuration option', detail)

    def test_powershell_file_list_checks_individual_files(self):
        import json
        import shutil
        ps = shutil.which('pwsh') or shutil.which('powershell')
        if not ps:
            self.skipTest('Native PowerShell is not installed')
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp)
            paths = [directory / 'first.ps1', directory / 'second.ps1']
            for path in paths:
                path.write_text("Write-Output 'valid'\n")
            manifest = directory / 'files.json'
            manifest.write_text(json.dumps([str(p) for p in paths]))
            command = [ps, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(ROOT / 'scripts/validate.ps1'), '-FileList', str(manifest)]
            self.assertEqual(subprocess.run(command, capture_output=True).returncode, 0)
            paths[1].write_text('function Broken {\n')
            self.assertNotEqual(subprocess.run(command, capture_output=True).returncode, 0)

    def test_compare_reports_added_removed_and_changed_packages(self):
        with tempfile.TemporaryDirectory() as temp:
            a, b = Path(temp) / 'a', Path(temp) / 'b'
            a.mkdir(); b.mkdir()
            (a / 'packages.txt').write_text('numpy==1\nremoved==1\n')
            (b / 'packages.txt').write_text('numpy==2\nadded==1\n')
            result = subprocess.run([sys.executable, str(ROOT / 'wsl/compare-status.py'), str(a), str(b)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0)
            self.assertIn('-numpy==1', result.stdout)
            self.assertIn('+numpy==2', result.stdout)
            self.assertIn('-removed==1', result.stdout)
            self.assertIn('+added==1', result.stdout)

    def test_compare_missing_directory_fails(self):
        with tempfile.TemporaryDirectory() as temp:
            result = subprocess.run([sys.executable, str(ROOT / 'wsl/compare-status.py'), temp, str(Path(temp) / 'missing')], capture_output=True)
            self.assertNotEqual(result.returncode, 0)

    def test_powershell_parser_rejects_invalid_script(self):
        import shutil
        ps = shutil.which('pwsh') or shutil.which('powershell')
        if not ps:
            self.skipTest('Native PowerShell is not installed')
        with tempfile.TemporaryDirectory() as temp:
            repo = Path(temp)
            subprocess.run(['git', 'init', '-q', str(repo)], check=True)
            (repo / 'scripts').mkdir()
            shutil.copy(ROOT / 'scripts/validate.ps1', repo / 'scripts/validate.ps1')
            (repo / 'broken.ps1').write_text('function Broken {\n')
            result = subprocess.run([ps, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', str(repo / 'scripts/validate.ps1')], capture_output=True)
            self.assertNotEqual(result.returncode, 0)

if __name__ == '__main__':
    unittest.main()
