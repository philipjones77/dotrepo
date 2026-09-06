"""Run in a Colab cell with %run /content/dotrepo/colab/setup.py.

Mounts Google Drive using Colab's interactive authentication and records the
runtime. Does not install desktop software or replace Colab's Python/CUDA stack.
"""
import json
from pathlib import Path
import platform
import subprocess
import sys

def main():
    try:
        from google.colab import drive
    except ImportError:
        raise SystemExit('Run this script inside Google Colab.')
    drive.mount('/content/drive')
    report = {'environment': 'colab', 'python': sys.version, 'platform': platform.platform(), 'drive': '/content/drive'}
    packages = subprocess.run([sys.executable, '-m', 'pip', 'list', '--format=json'], capture_output=True, text=True, check=True)
    report['packages'] = json.loads(packages.stdout)
    check = subprocess.run([sys.executable, '-m', 'pip', 'check'], capture_output=True, text=True)
    report['dependency_check'] = {'exit_code': check.returncode, 'output': check.stdout + check.stderr}
    path = Path('/content/dotrepo-colab-status.json')
    path.write_text(json.dumps(report, indent=2) + '\n')
    print(f'Saved {path}; download it or copy it to your private Drive for comparison.')
    print('Install the specific project requirements separately and run its tests.')

if __name__ == '__main__':
    main()
