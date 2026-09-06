"""Validate version-controlled configuration; run on Windows and Linux."""
import ast
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]

def validate():
    files = subprocess.check_output(['git', 'ls-files', '--cached', '--others', '--exclude-standard'], cwd=ROOT, text=True).splitlines()
    errors = []
    for name in files:
        path = ROOT / name
        if not path.is_file():
            continue
        try:
            if path.suffix in {'.json', '.code-snippets'}:
                json.loads(path.read_text(encoding='utf-8-sig'))
            elif path.suffix in {'.yml', '.yaml'}:
                doc = yaml.load(path.read_text(), Loader=yaml.BaseLoader)
                if name.startswith('.github/workflows/'):
                    assert doc.get('permissions') == {'contents': 'read'}, 'Set contents: read permissions'
                    assert 'pull_request_target' not in doc['on'], 'Use pull_request for validation'
                    for job in doc['jobs'].values():
                        assert 'timeout-minutes' in job, 'Jobs need a timeout'
                        for step in job.get('steps', []):
                            if 'uses' in step:
                                assert re.fullmatch(r'[\w.-]+/[\w./-]+@[0-9a-f]{40}', step['uses']), 'Pin actions to a commit SHA'
            elif path.suffix == '.py':
                ast.parse(path.read_text(), filename=name)
            elif path.suffix == '.sh' or path.name in {'.bashrc', '.profile'}:
                assert b'\r\n' not in path.read_bytes(), 'Shell scripts must use LF'
                if sys.platform != 'win32':
                    subprocess.run(['bash', '-n', str(path)], check=True)
        except (ValueError, SyntaxError, AssertionError, KeyError, yaml.YAMLError, subprocess.CalledProcessError) as exc:
            errors.append(f'{name}: {exc}')
    policy = json.loads((ROOT / 'config/environment.json').read_text())
    for path in [policy['node_version_file'], *policy['python_environments'].values(), *policy['wsl_profiles'].values()]:
        if not (ROOT / path).is_file():
            errors.append(f'Missing policy file: {path}')
    if (ROOT / 'node/.nvmrc').read_text().strip() != (ROOT / policy['node_version_file']).read_text().strip():
        errors.append('Node version files disagree')
    ps = shutil.which('pwsh') or shutil.which('powershell') or shutil.which('powershell.exe')
    ps_script = str(ROOT / 'scripts/validate.ps1')
    if ps and ps.lower().endswith('.exe') and sys.platform != 'win32':
        ps_script = subprocess.check_output(['wslpath', '-w', ps_script], text=True).strip()
    if ps:
        if subprocess.run([ps, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', ps_script]).returncode:
            errors.append('PowerShell validation failed')
    else:
        errors.append('PowerShell is required for complete repository validation')
    print('\n'.join(errors) if errors else 'Repository validation passed.')
    return bool(errors)

if __name__ == '__main__':
    sys.exit(validate())
