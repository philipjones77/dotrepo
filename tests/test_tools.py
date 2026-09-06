import importlib.util
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]

class ToolTests(unittest.TestCase):
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
