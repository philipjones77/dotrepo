"""Usage: python compare-status.py SNAPSHOT_A SNAPSHOT_B > comparison.diff"""
import difflib
from pathlib import Path
import sys

left, right = map(Path, sys.argv[1:3])
if not left.is_dir() or not right.is_dir():
    sys.exit('Both snapshot directories must exist.')
names = sorted({p.name for root in (left, right) for p in root.iterdir()
                if p.suffix in {'.txt', '.tsv', '.json', '.yml'} or p.name in {'.wslconfig', 'wsl.conf', 'os-release'}})
for name in names:
    a, b = left / name, right / name
    before = a.read_text(encoding='utf-8-sig', errors='replace').splitlines(True) if a.exists() else []
    after = b.read_text(encoding='utf-8-sig', errors='replace').splitlines(True) if b.exists() else []
    sys.stdout.writelines(difflib.unified_diff(before, after, fromfile=str(a), tofile=str(b)))
