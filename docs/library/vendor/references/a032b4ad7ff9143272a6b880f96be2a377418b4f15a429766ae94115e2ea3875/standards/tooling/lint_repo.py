"""Run the maintained Python and Markdown checks with one reproducible entry point.

Default mode is read-only. --fix applies safe Ruff fixes and formatting only.
Library records and historical snapshots are deliberately outside Markdown scope.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MARKDOWN_TREES = ("docs", "src", "tools", "latex")
MARKDOWN_EXCLUDED_PARTS = {
    "archive",
    "status",
    "inbox",
    "papers_cleanup",
    "__pycache__",
    "node_modules",
}
MARKDOWN_ROOT_FILES = (
    "README.md",
    "assets/README.md",
    "bibliography/README.md",
    "definitions/README.md",
    "glossaries/README.md",
    "images/README.md",
    "latex/README.md",
    "notation/README.md",
)


def markdown_paths(root: Path = ROOT) -> list[Path]:
    """Select active prose without touching scientific records or imported material."""
    paths = {root / name for name in MARKDOWN_ROOT_FILES if (root / name).is_file()}
    for tree in MARKDOWN_TREES:
        for path in (root / tree).rglob("*.md"):
            if not MARKDOWN_EXCLUDED_PARTS.intersection(path.relative_to(root).parts):
                paths.add(path)
    return sorted(paths)


def commands(fix: bool, language: str, root: Path = ROOT) -> list[list[str]]:
    """Construct argument lists, never shell strings, for the chosen check mode."""
    result = []
    if language in {"all", "python"}:
        result.append(["ruff", "check", *(["--fix"] if fix else []), "src", "tools"])
        result.append(["ruff", "format", *([] if fix else ["--check"]), "src", "tools"])
    if language in {"all", "markdown"}:
        paths = [path.relative_to(root).as_posix() for path in markdown_paths(root)]
        # Batching also keeps subprocess arguments below Windows command-line limits.
        for offset in range(0, len(paths), 30):
            batch = paths[offset : offset + 30]
            result.append(["mdformat", *([] if fix else ["--check"]), *batch])
            result.append(["pymarkdown", "--config", ".pymarkdown.json", "scan", *batch])
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fix", action="store_true", help="Apply safe fixes and formatting")
    parser.add_argument("--language", choices=("all", "python", "markdown"), default="all")
    parser.add_argument(
        "--list-markdown", action="store_true", help="Print Markdown scope and exit"
    )
    args = parser.parse_args()
    if args.list_markdown:
        for path in markdown_paths():
            print(path.relative_to(ROOT).as_posix())
        return 0
    failed = False
    for arguments in commands(args.fix, args.language):
        print(f"+ {sys.executable} -m {' '.join(arguments)}", flush=True)
        completed = subprocess.run([sys.executable, "-m", *arguments], cwd=ROOT, check=False)
        failed |= completed.returncode != 0
    if failed:
        print("Checks failed. Install tools/requirements-dev.txt if a tool is missing.")
    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())
