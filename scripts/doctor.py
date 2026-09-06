"""Read-only machine checks; exit 1 means required setup is missing."""
import argparse
import configparser
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
policy = json.loads((ROOT / 'config/environment.json').read_text())
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--platform', choices=policy['platforms'], default='windows' if os.name == 'nt' else 'wsl')
parser.add_argument('--network', action='store_true', help='Verify GitHub SSH access using existing trusted host keys')
parser.add_argument('--json', action='store_true')
args = parser.parse_args()
checks = []

def record(name, passed, detail, required=True):
    checks.append(dict(check=name, status='ok' if passed else ('fail' if required else 'info'), detail=detail))

def run(command, env=None):
    try:
        p = subprocess.run(command, capture_output=True, text=True, timeout=20, env=env)
        return p.returncode, p.stdout.strip(), p.stderr.strip()
    except (OSError, subprocess.TimeoutExpired) as exc:
        return 1, '', str(exc)

for command in policy['required_commands'] + policy['optional_commands']:
    actual = 'python3' if command == 'python' and args.platform == 'wsl' else command
    path = shutil.which(actual)
    record(command, bool(path), path or 'Not on PATH', command in policy['required_commands'])
canonical = Path.home() / '.dotrepo'
record('checkout', canonical.resolve() == ROOT, f'Expected {canonical} to resolve to {ROOT}')
mapping = {'.gitconfig': f'git/gitconfig.{args.platform}', '.ssh/config': 'ssh/config'}
if args.platform == 'wsl':
    mapping.update({'.bashrc': 'wsl/home/.bashrc', '.zshrc': 'wsl/home/.zshrc', '.profile': 'wsl/home/.profile'})
    mapping['.vscode-server/data/Machine/settings.json'] = 'vscode/wsl/settings.json'
elif os.environ.get('APPDATA'):
    mapping[str(Path(os.environ['APPDATA']) / 'Code/User/settings.json')] = 'vscode/windows/settings.json'
for target, source in mapping.items():
    live, tracked = Path.home() / target, ROOT / source
    record(target, live.is_file() and live.read_bytes().replace(b'\r\n', b'\n') == tracked.read_bytes().replace(b'\r\n', b'\n'), f'Compare with {source}')
key = Path(policy['ssh_key']).expanduser()
record('SSH key', key.is_file(), str(key))
for field in ('user.name', 'user.email'):
    code, output, error = run(['git', 'config', '--global', '--get', field])
    record(field, code == 0 and bool(output), output or error or 'Not configured')
code, output, error = run(['git', 'ls-remote', '--get-url', 'https://github.com/' + policy['repository'] + '.git'])
record('GitHub transport', code == 0 and output.startswith('git@github.com:'), output or error)
if args.platform == 'windows':
    live = Path.home() / '.wslconfig'
    def ini(path):
        config = configparser.ConfigParser()
        try:
            config.read(path)
            return {section: dict(config[section]) for section in config.sections()}
        except configparser.Error:
            return None
    matches = [name for name, path in policy['wsl_profiles'].items() if live.is_file() and ini(live) == ini(ROOT / path)]
    record('WSL profile', bool(matches), ', '.join(matches) or 'Custom/missing profile: review memory and swap', False)
if args.network:
    env = dict(os.environ, GIT_SSH_COMMAND='ssh -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=10')
    code, output, error = run(['git', 'ls-remote', f"git@github.com:{policy['repository']}.git", 'HEAD'], env)
    record('GitHub SSH access', code == 0, output or error)
if args.json:
    print(json.dumps({'platform': args.platform, 'checks': checks}, indent=2))
else:
    for check in checks:
        print(f"{check['status'].upper():4} {check['check']}: {check['detail']}")
sys.exit(any(c['status'] == 'fail' for c in checks))
