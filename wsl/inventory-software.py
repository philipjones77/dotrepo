"""Record software metadata without importing projects or running MATLAB."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

out = Path(sys.argv[1])
home = Path.home()
report = {"commands": {}, "matlab_installations": [], "vscode_extensions": [], "virtualenvs": []}
for tool in ("python", "python3", "R", "Rscript", "matlab", "octave", "node", "npm", "code", "gcc", "g++", "cmake", "git", "julia", "rustc", "cargo"):
    report["commands"][tool] = shutil.which(tool)
for root in (Path('/usr/local/MATLAB'), Path('/opt/MATLAB'), home / 'MATLAB'):
    if root.is_dir():
        for release in sorted(root.iterdir()):
            if release.is_dir():
                info = {"path": str(release)}
                version = release / 'VersionInfo.xml'
                if version.is_file():
                    info['version_info'] = version.read_text(errors='replace')
                report['matlab_installations'].append(info)
for root in (home / '.vscode-server/extensions', home / '.vscode-server-insiders/extensions'):
    for manifest in root.glob('*/package.json'):
        try:
            p = json.loads(manifest.read_text())
            report['vscode_extensions'].append({"id": p.get('publisher', '') + '.' + p.get('name', ''), "version": p.get('version'), "path": str(manifest.parent)})
        except (OSError, ValueError):
            pass
skip = {'.git', 'node_modules', '.cache', 'miniforge3', 'miniconda3', '.vscode-server', '.vscode-server-insiders', 'mnt'}
for root, dirs, files in os.walk(home):
    dirs[:] = [d for d in dirs if d not in skip and not os.path.ismount(Path(root) / d)]
    if len(Path(root).relative_to(home).parts) >= 6:
        dirs[:] = []
    if 'pyvenv.cfg' in files:
        prefix = Path(root)
        item = {'path': str(prefix), 'configuration': (prefix / 'pyvenv.cfg').read_text(errors='replace')}
        try:
            result = subprocess.run([str(prefix / 'bin/python'), '-m', 'pip', 'freeze', '--all'], capture_output=True, text=True, timeout=30)
            item.update(packages=result.stdout.splitlines(), error=result.stderr, exit_code=result.returncode)
        except (OSError, subprocess.TimeoutExpired) as exc:
            item['error'] = str(exc)
        report['virtualenvs'].append(item)
        dirs[:] = []
report['coverage'] = 'Current user: Conda, home virtualenvs to depth 6, VS Code server extensions; MATLAB standard install paths; R default library paths. Project-local libraries outside this scope require separate inventories.'
(out / 'software.json').write_text(json.dumps(report, indent=2) + '\n')
