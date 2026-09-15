#!/usr/bin/env python3
"""Build pinned, unchanged GS-LVMOGP modules as a local oracle wheel."""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path


def main() -> None:
    repo = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--python", type=Path, default=Path.home() / ".virtualenvs/py313/bin/python"
    )
    parser.add_argument(
        "--workdir",
        type=Path,
        default=Path.home() / ".local/state/dotrepo/rf77-oracles-20260914",
    )
    parser.add_argument("--output-dir", type=Path)
    args = parser.parse_args()
    receipt = json.loads(
        (
            repo
            / "machines/pc-philip-windows-2026-09-14/repo-oracles/rf77-gs-lvmogp.json"
        ).read_text()
    )["source"]
    source = args.workdir / "gs-lvmogp-source"
    build = args.workdir / "gs-lvmogp-wheel-source"
    wheels = args.output_dir or args.workdir / "wheels"
    args.workdir.mkdir(parents=True, exist_ok=True)
    if not source.exists():
        subprocess.run(
            [
                "git",
                "clone",
                "--no-checkout",
                receipt["upstream"] + ".git",
                str(source),
            ],
            check=True,
            stdout=sys.stderr,
        )
        subprocess.run(
            ["git", "-C", str(source), "checkout", "--detach", receipt["commit"]],
            check=True,
            stdout=sys.stderr,
        )
    commit = subprocess.check_output(
        ["git", "-C", str(source), "rev-parse", "HEAD"], text=True
    ).strip()
    dirty = subprocess.check_output(
        ["git", "-C", str(source), "status", "--porcelain"], text=True
    ).strip()
    if commit != receipt["commit"] or dirty:
        raise SystemExit(
            "Existing source differs from the pinned clean checkout; choose another --workdir."
        )
    build.mkdir(parents=True, exist_ok=True)
    wheels.mkdir(parents=True, exist_ok=True)
    for name, expected in receipt["source_sha256"].items():
        payload = (source / name).read_bytes()
        if hashlib.sha256(payload).hexdigest() != expected:
            raise SystemExit(f"Pinned source checksum failed: {name}")
        shutil.copy2(source / name, build / name)
    shutil.copy2(
        repo / "wsl/oracle-builds/gs-lvmogp-pyproject.toml", build / "pyproject.toml"
    )
    subprocess.run(
        [
            str(args.python),
            "-B",
            "-m",
            "pip",
            "wheel",
            "--no-deps",
            "--no-build-isolation",
            "--wheel-dir",
            str(wheels),
            str(build),
        ],
        check=True,
        stdout=sys.stderr,
    )
    wheel = wheels / ("gs_lvmogp_oracle-" + receipt["version"] + "-py3-none-any.whl")
    with zipfile.ZipFile(wheel) as archive:
        for name in ("LVMOGP.py", "IndepMOGP.py"):
            if (
                hashlib.sha256(archive.read(name)).hexdigest()
                != receipt["source_sha256"][name]
            ):
                raise SystemExit(f"Wheel source checksum failed: {name}")
    print(wheel.resolve())


if __name__ == "__main__":
    main()
