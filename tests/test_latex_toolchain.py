"""Exercise asset integrity and installation using isolated temporary trees."""
import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("latex_toolchain", ROOT / "scripts/latex-toolchain.py")
tool = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(tool)


class LatexToolchainTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name).resolve()
        self.addCleanup(self.temp.cleanup)

    def archive(self, members):
        path = self.root / "release.zip"
        with zipfile.ZipFile(path, "w") as bundle:
            for name, data in members.items():
                bundle.writestr(name, data)
        return path

    def test_bad_release_checksum_is_rejected_before_zip_read(self):
        path = self.root / "corrupt.zip"
        path.write_bytes(b"not a zip")
        with self.assertRaisesRegex(ValueError, "SHA256 mismatch"):
            tool.read_asset(path, "fira_code")

    def test_only_reviewed_font_members_are_read_and_individually_verified(self):
        data = b"reviewed font"
        path = self.archive({"ttf/Example.ttf": data, "../outside": b"ignored"})
        policy = {"sha256": tool.digest(path.read_bytes()), "files": {"Example.ttf": tool.digest(data)}}
        with patch.dict(tool.POLICY, {"fira_code": policy}):
            self.assertEqual(tool.read_asset(path, "fira_code"), {"Example.ttf": data})
            policy["files"]["Example.ttf"] = "0" * 64
            with self.assertRaisesRegex(ValueError, "Font SHA256 mismatch"):
                tool.read_asset(path, "fira_code")

    def test_incomplete_bib2gls_bundle_fails_before_install(self):
        path = self.archive({"bib2gls/bib2gls.jar": b"jar"})
        policy = {"sha256": tool.digest(path.read_bytes()),
                  "files": ["bib2gls.jar", "bibglscommon.jar", "resources/bib2gls-en.xml"]}
        with patch.dict(tool.POLICY, {"bib2gls": policy}), self.assertRaises(KeyError):
            tool.read_asset(path, "bib2gls")

    def test_install_backs_up_changes_and_repeat_install_is_idle(self):
        destination = self.root / "assets"
        destination.mkdir()
        (destination / "font.ttf").write_bytes(b"old")
        (destination / "unrelated").write_bytes(b"keep")
        backups = self.root / "backups"
        files = {"font.ttf": b"new", "resources/message.xml": b"message"}
        self.assertEqual(tool.install_files(files, destination, backups), list(files))
        self.assertEqual((backups / "font.ttf").read_bytes(), b"old")
        self.assertEqual((destination / "unrelated").read_bytes(), b"keep")
        self.assertEqual(tool.install_files(files, destination, backups), [])
        self.assertEqual((backups / "font.ttf").read_bytes(), b"old")

    def test_bad_destination_member_prevents_all_writes(self):
        destination = self.root / "assets"
        with self.assertRaisesRegex(ValueError, "escapes destination"):
            tool.install_files({"ok": b"ok", "../escape": b"bad"}, destination, self.root / "backups")
        self.assertFalse(destination.exists())
        self.assertFalse((self.root / "escape").exists())

    def test_linux_launcher_must_select_the_installed_user_jar(self):
        home = self.root / "texmf"
        with patch.object(tool, "IS_WINDOWS", False), patch.object(tool, "texmf_home", return_value=home), \
                patch.object(tool, "run", side_effect=["", str(self.root / "system/bib2gls.jar")]):
            with self.assertRaisesRegex(RuntimeError, "does not select"):
                tool.install("bib2gls", {"bib2gls.jar": b"new"}, self.root / "backups")

    def test_native_tool_timeout_has_a_concise_diagnostic(self):
        error = subprocess.TimeoutExpired(["bib2gls", "--version"], 180)
        with patch.object(tool.subprocess, "run", side_effect=error):
            with self.assertRaisesRegex(RuntimeError, "bib2gls timed out after 180 seconds"):
                tool.run(["bib2gls", "--version"])


if __name__ == "__main__":
    unittest.main()
