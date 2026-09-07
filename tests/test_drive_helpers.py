import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import unittest
import uuid


ROOT = Path(__file__).resolve().parents[1]


class DriveStartupTests(unittest.TestCase):
    @unittest.skipUnless(os.name == "nt", "Windows process and mutex integration")
    def test_immediate_restart_waits_for_previous_anchor(self):
        powershell = shutil.which("powershell.exe")
        if not powershell:
            self.skipTest("Windows PowerShell is unavailable")
        source = (ROOT / "windows/wsl-google-drive.ps1").read_text()
        wsl_assignment = "$wsl = Join-Path $env:SystemRoot 'System32\\wsl.exe'"
        log_assignment = "$logDir = Join-Path $env:LOCALAPPDATA 'dotrepo\\logs'"
        self.assertEqual(source.count(wsl_assignment), 1)
        self.assertEqual(source.count(log_assignment), 1)
        source = source.replace(wsl_assignment, "$wsl = Join-Path $env:DOTREPO_TEST_HOME 'wsl.ps1'")
        source = source.replace(log_assignment, "$logDir = Join-Path $env:DOTREPO_TEST_HOME 'logs'")
        distro = "TestDistro-" + uuid.uuid4().hex
        with tempfile.TemporaryDirectory(prefix="dotrepo-drive-restart-") as folder:
            fixture = Path(folder)
            helper = fixture / "helper.ps1"
            helper.write_text(source)
            (fixture / "wsl.ps1").write_text(r"""
$fixture = $env:DOTREPO_TEST_HOME
$mounted = Join-Path $fixture 'mounted'
$action = $args[-1]
if ($action -eq 'HOME') {
    Write-Output '/home/testuser'
} elseif ($action -eq 'serve') {
    Set-Content -LiteralPath $mounted -Value $PID
    Add-Content -LiteralPath (Join-Path $fixture 'starts') -Value $PID
    while ((Test-Path -LiteralPath $mounted) -and !(Test-Path -LiteralPath (Join-Path $fixture 'cleanup'))) { Start-Sleep -Milliseconds 50 }
    Set-Content -LiteralPath (Join-Path $fixture 'retiring') -Value $PID
    while (!(Test-Path -LiteralPath (Join-Path $fixture 'release')) -and !(Test-Path -LiteralPath (Join-Path $fixture 'cleanup'))) { Start-Sleep -Milliseconds 50 }
} elseif ($action -eq 'stop') {
    Remove-Item -LiteralPath $mounted -ErrorAction SilentlyContinue
} else { throw "Unexpected fixture action: $action" }
$global:LASTEXITCODE = 0
""")
            env = dict(os.environ, DOTREPO_TEST_HOME=str(fixture))
            processes = []

            def launch(action, script=helper):
                process = subprocess.Popen(
                    [powershell, "-NoLogo", "-NoProfile", "-File", str(script),
                     "-Action", action, "-Distribution", distro, "-LinuxUser", "testuser"],
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, env=env,
                    creationflags=subprocess.CREATE_NO_WINDOW,
                )
                processes.append(process)
                return process

            def wait_for(predicate, message):
                deadline = time.monotonic() + 15
                while not predicate() and time.monotonic() < deadline:
                    time.sleep(0.05)
                self.assertTrue(predicate(), message)

            def check_success(process):
                stdout, stderr = process.communicate(timeout=15)
                self.assertEqual(process.returncode, 0, stdout + stderr)

            try:
                check_success(launch("Stop"))  # No existing anchor also works.
                old = launch("Serve")
                wait_for(lambda: (fixture / "mounted").exists(), "Initial anchor did not mount")
                stop = launch("Stop")
                wait_for(lambda: (fixture / "retiring").exists(), "Old anchor did not observe unmount")
                time.sleep(0.4)
                self.assertIsNone(stop.poll(), "Stop returned while the old anchor still held its mutex")
                (fixture / "release").touch()
                check_success(stop)
                check_success(launch("Start"))  # Immediately after Stop completes.
                wait_for(lambda: (fixture / "mounted").exists(), "Immediate restart was lost")
                check_success(old)
                starts = (fixture / "starts").read_text().splitlines()
                self.assertEqual(len(starts), 2, "Expected one old and one replacement mount")
                self.assertNotEqual(starts[0], starts[1], "Replacement anchor was not a new process")
                check_success(launch("Stop"))
                self.assertFalse((fixture / "mounted").exists())

                # A stuck old anchor must produce a failure, not a false successful Stop.
                (fixture / "release").unlink()
                (fixture / "retiring").unlink(missing_ok=True)
                held = launch("Serve")
                wait_for(lambda: (fixture / "mounted").exists(), "Timeout fixture did not mount")
                shortened = fixture / "short-timeout.ps1"
                self.assertEqual(source.count("$mutex.WaitOne(45000)"), 1)
                shortened.write_text(source.replace("$mutex.WaitOne(45000)", "$mutex.WaitOne(250)"))
                failed = launch("Stop", shortened)
                stdout, stderr = failed.communicate(timeout=15)
                self.assertNotEqual(failed.returncode, 0, "Stop silently accepted a stuck old anchor")
                self.assertIn("anchor did not exit", stdout + stderr)
                (fixture / "release").touch()
                check_success(held)
            finally:
                (fixture / "cleanup").touch()
                (fixture / "release").touch()
                # Wait for a child created by the real Start-Process path as well.
                cleanup = launch("Stop")
                cleanup.communicate(timeout=15)
                for process in processes:
                    if process.poll() is None:
                        process.terminate()
                        process.communicate(timeout=10)

    @unittest.skipUnless(os.name == "nt", "Windows registry integration")
    def test_logon_configuration_preserves_unrelated_registry_values(self):
        powershell = shutil.which("powershell.exe")
        if not powershell:
            self.skipTest("Windows PowerShell is unavailable")
        source = (ROOT / "windows/wsl-google-drive.ps1").read_text()
        run_assignment = "$runKey = 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Run'"
        self.assertEqual(source.count(run_assignment), 1)
        source = source.replace(run_assignment, "$runKey = $env:DOTREPO_TEST_RUN_KEY")
        backup_root = "Join-Path $env:USERPROFILE ('.dotrepo-backups"
        self.assertEqual(source.count(backup_root), 1)
        source = source.replace(backup_root, "Join-Path $env:DOTREPO_TEST_HOME ('.dotrepo-backups")
        key = "HKCU:\\Software\\DotrepoTests-" + uuid.uuid4().hex
        with tempfile.TemporaryDirectory(prefix="dotrepo-drive-test-") as folder:
            fixture = Path(folder)
            helper = fixture / "helper.ps1"
            helper.write_text(source)
            script = fixture / "test.ps1"
            script.write_text(r"""
$ErrorActionPreference = 'Stop'
$key = $env:DOTREPO_TEST_RUN_KEY
if (!$key.StartsWith('HKCU:\Software\DotrepoTests-')) { throw 'Unexpected fixture registry path' }
if (Test-Path -LiteralPath $key) { throw 'Fixture registry key already exists' }
function Start-Process {
    param($FilePath, $ArgumentList, $WindowStyle)
    $global:DotrepoTestLaunchCount++
}
$global:DotrepoTestLaunchCount = 0
try {
    New-Item -Path $key | Out-Null
    New-ItemProperty -LiteralPath $key -Name OtherApplication -Value '"C:\Program Files\Example\app.exe" --background' -PropertyType String | Out-Null
    New-ItemProperty -LiteralPath $key -Name ExpandedPath -Value '%LOCALAPPDATA%\Example\app.exe' -PropertyType ExpandString | Out-Null
    & (Join-Path $env:DOTREPO_TEST_HOME 'helper.ps1') -Action EnableAtLogon -Distribution TestDistro -LinuxUser testuser
    $item = Get-Item -LiteralPath $key
    if ($item.GetValue('OtherApplication') -ne '"C:\Program Files\Example\app.exe" --background') { throw 'Unrelated startup value changed' }
    if ($item.GetValueKind('ExpandedPath') -ne [Microsoft.Win32.RegistryValueKind]::ExpandString) { throw 'Unrelated value kind changed' }
    $raw = $item.GetValue('ExpandedPath', $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
    if ($raw -ne '%LOCALAPPDATA%\Example\app.exe') { throw 'Unrelated raw value changed' }
    if (!$item.GetValue('DotrepoWslGoogleDrive-TestDistro-testuser')) { throw 'Anchor entry missing' }
    if ($global:DotrepoTestLaunchCount -ne 1) { throw 'Expected one hidden launch request' }
    $backup = Get-ChildItem -LiteralPath (Join-Path $env:DOTREPO_TEST_HOME '.dotrepo-backups') -Filter run-entry.json -Recurse | Select-Object -First 1
    $saved = Get-Content -LiteralPath $backup.FullName -Raw | ConvertFrom-Json
    if (@($saved.AllValues | Where-Object Name -eq OtherApplication).Count -ne 1) { throw 'Full Run-value backup missing' }
    & (Join-Path $env:DOTREPO_TEST_HOME 'helper.ps1') -Action DisableAtLogon -Distribution TestDistro -LinuxUser testuser
    $item = Get-Item -LiteralPath $key
    if ($item.GetValue('DotrepoWslGoogleDrive-TestDistro-testuser')) { throw 'Anchor entry not removed' }
    if ($item.GetValue('OtherApplication') -ne '"C:\Program Files\Example\app.exe" --background') { throw 'Disable changed unrelated startup entry' }
    Write-Output 'Startup registry preservation passed'
} finally {
    if (Test-Path -LiteralPath $key) { Remove-Item -LiteralPath $key -Recurse }
}
""")
            env = dict(os.environ, DOTREPO_TEST_RUN_KEY=key, DOTREPO_TEST_HOME=str(fixture))
            result = subprocess.run(
                [powershell, "-NoLogo", "-NoProfile", "-File", str(script)],
                capture_output=True,
                text=True,
                timeout=45,
                env=env,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn("Startup registry preservation passed", result.stdout)


if __name__ == "__main__":
    unittest.main()
