import importlib.util
import json
from pathlib import Path
import tempfile
from types import SimpleNamespace
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('capture_software', ROOT / 'scripts/capture-software.py')
capture = importlib.util.module_from_spec(spec)
spec.loader.exec_module(capture)


class CaptureTests(unittest.TestCase):
    def test_repository_identity_drops_secrets_and_rejects_unknown_hosts(self):
        self.assertEqual(capture.safe_repo_url('https://user:secret@github.com/owner/repo.git?token=secret'),
                         'https://github.com/owner/repo.git')
        self.assertIsNone(capture.safe_repo_url('https://private.example/secret/archive.whl'))
        self.assertIsNone(capture.safe_repo_url('file:///private/source'))

    def test_conda_build_metadata_is_not_mistaken_for_a_manual_pip_source(self):
        records = [
            {'name': 'packaging', 'version': '26.3', 'channel': 'conda-forge', 'build_string': 'py_0'},
            {'name': 'local-project', 'version': '1.0', 'channel': 'pypi', 'build_string': 'pypi_0'},
        ]
        def dist(name):
            return SimpleNamespace(metadata={'Name': name}, version='1.0',
                read_text=lambda _: '{"url":"https://user:secret@private.example/private.whl"}')
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            with mock.patch.object(capture, 'command', return_value=json.dumps(records)), \
                 mock.patch.object(capture.importlib.metadata, 'distributions', return_value=[dist('packaging'), dist('local-project')]):
                result = capture.environment(root, root / 'conda', root, 'test')
            manifest = json.loads((root / 'test.yml').read_text())
            self.assertIn('packaging=26.3=py_0', manifest['dependencies'])
            self.assertEqual(result['manual_sources'], 1)
            manual = (root / 'test-manual.json').read_text()
            self.assertNotIn('secret', manual)
            self.assertNotIn('private.example', manual)


if __name__ == '__main__':
    unittest.main()
