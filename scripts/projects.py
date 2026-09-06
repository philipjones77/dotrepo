"""Read-only inventory of native project checkouts; never pulls or moves files."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

def git(path, *args):
    result = subprocess.run(['git', '-C', str(path), *args], capture_output=True, text=True, timeout=20)
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or 'Git command failed')
    return result.stdout.strip()

def inspect(path):
    record = {'name': path.name, 'path': str(path)}
    try:
        record['branch'] = git(path, 'branch', '--show-current') or '(detached)'
        record['revision'] = git(path, 'rev-parse', 'HEAD')
        record['changes'] = git(path, 'status', '--porcelain').splitlines()
        remotes = git(path, 'remote').splitlines()
        record['remotes'] = {name: git(path, 'remote', 'get-url', name) for name in remotes}
        manifest = path / '.dev-environment.json'
        record['platform_contract'] = json.loads(manifest.read_text()) if manifest.is_file() else None
        record['contract_status'] = 'declared; commands not executed' if manifest.is_file() else 'not declared'
    except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as exc:
        record['error'] = str(exc)
    return record

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', default='C:/dev' if os.name == 'nt' else str(Path.home() / 'projects'))
    parser.add_argument('--json', action='store_true')
    args = parser.parse_args()
    root = Path(args.root).expanduser()
    if not root.is_dir():
        parser.error(f'Project root does not exist: {root}')
    # One level only: excludes archives, mounts, dependency trees and linked checkouts.
    projects = [inspect(p) for p in sorted(root.iterdir()) if p.is_dir() and not p.is_symlink()
                and not p.name.startswith(('.', '_')) and (p / '.git').exists()]
    if args.json:
        print(json.dumps({'root': str(root), 'platform': sys.platform, 'projects': projects}, indent=2))
    else:
        print(f'Projects in {root}: {len(projects)}')
        for project in projects:
            if 'error' in project:
                print(f"ERROR {project['name']}: {project['error']}")
            else:
                print(f"{project['name']}: {project['branch']} {project['revision'][:10]}, {len(project['changes'])} local changes; platform contract {project['contract_status']}")
    return any('error' in project for project in projects)

if __name__ == '__main__':
    sys.exit(main())
