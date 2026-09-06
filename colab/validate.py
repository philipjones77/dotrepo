"""Run inside Colab after setup.py; produce an explicit pass/fail report."""
import importlib.metadata
import json
from pathlib import Path
import platform
import shutil
import subprocess
import sys
import tempfile

def main():
    try:
        import google.colab  # noqa: F401
    except ImportError:
        raise SystemExit('Live validation must run inside Google Colab.')
    report = {'environment': 'colab', 'python': sys.version, 'platform': platform.platform(), 'checks': [], 'packages': {}}
    def check(name, passed, detail):
        report['checks'].append({'name': name, 'passed': bool(passed), 'detail': detail})
    drive = Path('/content/drive/MyDrive')
    check('Google Drive mounted', drive.is_dir(), str(drive))
    with tempfile.TemporaryDirectory(dir='/content') as directory:
        sample = Path(directory) / 'check.txt'
        sample.write_text('dotrepo validation\n')
        check('Runtime file read/write', sample.read_text() == 'dotrepo validation\n', 'Temporary local file; user Drive files unchanged')
    for name in ('numpy', 'scipy', 'pandas', 'jax', 'jaxlib', 'torch', 'google-colab'):
        try:
            report['packages'][name] = importlib.metadata.version(name)
        except importlib.metadata.PackageNotFoundError:
            report['packages'][name] = None
    try:
        import numpy as np
        check('NumPy calculation', np.array_equal(np.array([[1, 2]]) @ np.array([[3], [4]]), [[11]]), 'Small CPU matrix multiplication')
    except Exception as exc:
        check('NumPy calculation', False, str(exc))
    deps = subprocess.run([sys.executable, '-m', 'pip', 'check'], capture_output=True, text=True)
    check('Python dependencies', deps.returncode == 0, deps.stdout + deps.stderr)
    if shutil.which('nvidia-smi'):
        gpu = subprocess.run(['nvidia-smi', '--query-gpu=name,memory.total', '--format=csv,noheader'], capture_output=True, text=True)
        report['gpu'] = gpu.stdout.strip() or gpu.stderr.strip()
    else:
        report['gpu'] = 'CPU runtime (valid for this check)'
    report['repository_revision'] = subprocess.check_output(['git', '-C', str(Path(__file__).resolve().parents[1]), 'rev-parse', 'HEAD'], text=True).strip()
    report['passed'] = all(check['passed'] for check in report['checks'])
    output = Path('/content/dotrepo-colab-validation.json')
    output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    print(f'Saved {output}. Project-specific workloads still need their own tests.')
    if not report['passed']:
        raise RuntimeError('Colab checks found issues; inspect the saved report before changing packages.')

if __name__ == '__main__':
    main()
