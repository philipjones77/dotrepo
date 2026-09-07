"""Check or explicitly install reviewed user-level LaTeX assets (no sudo)."""
from __future__ import annotations

import argparse
import ctypes
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parents[1]
POLICY = json.loads((ROOT / "config/latex-toolchain.json").read_text())
IS_WINDOWS = os.name == "nt"


def digest(data):
    return hashlib.sha256(data).hexdigest()


def read_asset(archive, name):
    """Verify the whole release, then read only explicitly allowed members."""
    policy = POLICY[name]
    if digest(Path(archive).read_bytes()) != policy["sha256"]:
        raise ValueError(f"SHA256 mismatch for {name}; no files installed")
    prefix = "ttf/" if name == "fira_code" else "bib2gls/"
    with zipfile.ZipFile(archive) as bundle:
        files = {filename: bundle.read(prefix + filename) for filename in policy["files"]}
    if name == "fira_code":
        for filename, data in files.items():
            if digest(data) != policy["files"][filename]:
                raise ValueError(f"Font SHA256 mismatch: {filename}")
    return files


def fetch_asset(name, directory):
    archive = directory / f"{name}.zip"
    request = urllib.request.Request(POLICY[name]["url"], headers={"User-Agent": "dotrepo-latex-setup"})
    with urllib.request.urlopen(request, timeout=90) as response, archive.open("wb") as output:
        shutil.copyfileobj(response, output)
    return read_asset(archive, name)


def install_files(files, destination, backups):
    """Back up replaced files and atomically replace only the named assets."""
    destination = destination.resolve()
    changed = []
    for name in files:
        target = destination / name
        if not target.resolve().is_relative_to(destination):
            raise ValueError(f"Asset escapes destination: {name}")
    for name, data in files.items():
        target = destination / name
        if target.is_file() and target.read_bytes() == data:
            continue
        if target.exists():
            backup = backups / name
            backup.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(target, backup)
        target.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as stream:
            temporary = Path(stream.name)
            stream.write(data)
        try:
            temporary.replace(target)
        finally:
            temporary.unlink(missing_ok=True)
        changed.append(name)
    return changed


def font_directory():
    if IS_WINDOWS:
        return Path(os.environ["LOCALAPPDATA"]) / "Microsoft/Windows/Fonts"
    return Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "fonts/fira-code"


def run(command):
    try:
        result = subprocess.run(command, capture_output=True, text=True, timeout=180)
    except subprocess.TimeoutExpired as error:
        raise RuntimeError(f"{command[0]} timed out after {error.timeout} seconds") from error
    if result.returncode:
        raise RuntimeError(f"{' '.join(map(str, command))}: {result.stdout}{result.stderr}")
    return (result.stdout + result.stderr).strip()


def register_fonts(directory, backups):
    if IS_WINDOWS:
        import winreg
        registry_path = r"Software\Microsoft\Windows NT\CurrentVersion\Fonts"
        previous = {}
        gdi = ctypes.WinDLL("gdi32", use_last_error=True)
        gdi.AddFontResourceExW.argtypes = [ctypes.c_wchar_p, ctypes.c_uint, ctypes.c_void_p]
        gdi.AddFontResourceExW.restype = ctypes.c_int
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, registry_path) as key:
            for filename in POLICY["fira_code"]["files"]:
                face = "Fira Code " + Path(filename).stem.split("-", 1)[1] + " (TrueType)"
                try:
                    previous[face] = winreg.QueryValueEx(key, face)
                except FileNotFoundError:
                    previous[face] = None
            backups.mkdir(parents=True, exist_ok=True)
            (backups / "font-registry.json").write_text(json.dumps(previous, indent=2))
            for filename in POLICY["fira_code"]["files"]:
                path = str(directory / filename)
                face = "Fira Code " + Path(filename).stem.split("-", 1)[1] + " (TrueType)"
                winreg.SetValueEx(key, face, 0, winreg.REG_SZ, path)
                if not gdi.AddFontResourceExW(path, 0, None):
                    raise OSError(f"Windows could not load {path}; restart and check the font")
    else:
        run(["fc-cache", "-f", str(directory)])
    if shutil.which("luaotfload-tool"):
        run(["luaotfload-tool", "--update"])


def texmf_home():
    value = run(["kpsewhich", "--var-value=TEXMFHOME"])
    path = Path(value).expanduser()
    if not path.is_absolute() or not path.resolve().is_relative_to(Path.home().resolve()):
        raise ValueError("TEXMFHOME must be one directory under this user's home")
    return path


def install(name, files, backups):
    if name == "fira_code":
        destination = font_directory()
        changed = install_files(files, destination, backups)
        register_fonts(destination, backups)
    else:
        if IS_WINDOWS:
            raise ValueError("Use TeX Live Manager for Windows Bib2Gls; this override is for Linux/WSL")
        home = texmf_home()
        destination = home / "scripts/bib2gls"
        changed = install_files(files, destination, backups)
        run(["mktexlsr", str(home)])
        selected = Path(run(["kpsewhich", "--progname=bib2gls", "--format=texmfscripts", "bib2gls.jar"]))
        if selected.resolve() != (destination / "bib2gls.jar").resolve():
            raise RuntimeError("The existing Bib2Gls launcher does not select the installed user jar")
        print(run(["bib2gls", "--version"]))
    print(f"{name}: {len(changed)} files updated in {destination}; backups: {backups}")


def check():
    failures = []
    directory = font_directory()
    for filename, expected in POLICY["fira_code"]["files"].items():
        path = directory / filename
        if not path.is_file() or digest(path.read_bytes()) != expected:
            failures.append(f"Fira Code file missing or differs: {path}")
    for command in ("lualatex", "biber", "bib2gls", "makeindex", "kpsewhich", "pwsh", "java"):
        executable = shutil.which(command)
        if not executable:
            failures.append(f"Not on PATH: {command} (see docs/latex-toolchain.md)")
        else:
            print(f"{command}: {executable}")
    if shutil.which("bib2gls"):
        try:
            version = run(["bib2gls", "--version"])
            print(version)
            if f"version {POLICY['bib2gls']['version']} " not in version:
                failures.append("Bib2Gls differs from the reviewed version; check compatibility before building")
        except RuntimeError as error:
            failures.append(str(error))
    if shutil.which("kpsewhich"):
        for package in ("siunitx.sty", "l3backend-luatex.def"):
            try:
                print(f"{package}: {run(['kpsewhich', package])}")
            except RuntimeError:
                failures.append(f"TeX package missing: {package}")
    for failure in failures:
        print(f"MISSING: {failure}", file=sys.stderr)
    return bool(failures)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--install", choices=("fira_code", "bib2gls"),
                        help="Explicitly install one reviewed asset for the current user")
    parser.add_argument("--archive", type=Path, help="Use an existing archive; the pinned SHA256 is still required")
    options = parser.parse_args()
    if not options.install:
        if options.archive:
            parser.error("--archive requires --install")
        return check()
    name = options.install
    if name == "bib2gls" and IS_WINDOWS:
        parser.error("The user TEXMF Bib2Gls override is for Linux/WSL only")
    stamp = datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S-%f")
    backups = Path.home() / ".dotrepo-backups" / f"latex-{stamp}" / name
    with tempfile.TemporaryDirectory(prefix="dotrepo-latex-") as temporary:
        files = read_asset(options.archive, name) if options.archive else fetch_asset(name, Path(temporary))
        install(name, files, backups)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, RuntimeError, zipfile.BadZipFile, KeyError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
