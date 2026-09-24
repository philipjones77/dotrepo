#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
python3 - "$repo_root" <<'PY'
import datetime
import json
from pathlib import Path
import re
import shutil
import sys

repo = Path(sys.argv[1])
home = Path.home()
backup = home / '.dotrepo-backups' / (datetime.datetime.now().strftime('%Y%m%d-%H%M%S') + '-sumatra-pdf')
backup.mkdir(parents=True, exist_ok=True)
def preserve(path):
    if path.exists():
        dest = backup / path.relative_to(home)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, dest)

opener = home / '.local/bin/open-pdf'
preserve(opener)
opener.parent.mkdir(parents=True, exist_ok=True)
shutil.copyfile(repo / 'wsl/open-pdf.sh', opener)
opener.chmod(0o755)
body = (repo / 'agents/pdf-opening.md').read_text().strip()
block = '<!-- dotrepo-pdf-opening:start -->\n' + body + '\n<!-- dotrepo-pdf-opening:end -->'
for relative in ('.codex/AGENTS.md', '.claude/CLAUDE.md', '.gemini/GEMINI.md', '.copilot/copilot-instructions.md'):
    target = home / relative
    if not target.parent.is_dir():
        continue
    preserve(target)
    old = target.read_text() if target.exists() else ''
    pattern = r'(?s)<!-- dotrepo-pdf-opening:start -->.*?<!-- dotrepo-pdf-opening:end -->'
    if re.search(pattern, old):
        new = re.sub(pattern, lambda match: block, old)
    else:
        new = old.rstrip() + '\n\n' + block + '\n'
    target.write_text(new.lstrip())
settings = home / '.vscode-server/data/Machine/settings.json'
if settings.exists():
    value = json.loads(settings.read_text())
    value.setdefault('workbench.editorAssociations', {})['*.pdf'] = 'dotrepo.sumatraPdf'
    preserve(settings)
    settings.write_text(json.dumps(value, indent=2) + '\n')
print('WSL PDF opener and global instructions installed. Backups:', backup)
PY
