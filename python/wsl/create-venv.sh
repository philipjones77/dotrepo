#!/usr/bin/env bash
set -euo pipefail

# Keep build subprocesses, as well as direct checks, inside the candidate.
unset PYTHONHOME PYTHONPATH PYTHONOPTIMIZE

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
env_dir="${1:?Pass a NEW candidate environment directory; existing environments are preserved.}"
python_bin="${PYTHON_BIN:-3.13.15}"
projects_home="${PROJECTS_HOME:-$HOME/projects}"
snapshot="$repo_root/machines/pc-philip-windows-2026-09-14"
pins="$snapshot/wsl-native/standard-python/py313-requirements.txt"

command -v uv >/dev/null || { echo 'Install native uv before running this script.' >&2; exit 1; }
if [ -e "$env_dir" ] || [ -L "$env_dir" ]; then
  echo "Choose a new candidate directory; preserving existing path: $env_dir" >&2
  exit 1
fi
for project in arbPlusJAX IntegralFunctionsJAX TopoSmplJAX RandomFields77; do
  if [ ! -f "$projects_home/$project/pyproject.toml" ]; then
    echo "Restore the scientific checkout first: $projects_home/$project" >&2
    exit 1
  fi
done
uv venv --seed --python "$python_bin" "$env_dir"
"$env_dir/bin/python" -I -B -c 'import sys; assert sys.implementation.name == "cpython" and sys.version_info[:3] == (3, 13, 15), "The snapshot requires CPython 3.13.15"'
uv pip install --python "$env_dir/bin/python" \
  --constraints "$pins" \
  --build-constraints "$repo_root/python/wsl/m-tier-build-constraints.txt" \
  -r "$pins" \
  -e "$projects_home/arbPlusJAX" -e "$projects_home/IntegralFunctionsJAX" \
  -e "$projects_home/TopoSmplJAX" -e "$projects_home/RandomFields77"

if [ -n "${GS_LVMOGP_WHEEL:-}" ]; then
  gs_wheel="$GS_LVMOGP_WHEEL"
else
  gs_wheel="$("$env_dir/bin/python" -I -B "$repo_root/scripts/build-gs-lvmogp-wheel.py" --python "$env_dir/bin/python")"
fi
"$env_dir/bin/python" -I -B - "$gs_wheel" "$snapshot/repo-oracles/rf77-gs-lvmogp.json" <<'PY'
import hashlib
import json
import sys
import zipfile
from pathlib import Path

expected = json.loads(Path(sys.argv[2]).read_text())["source"]["source_sha256"]
with zipfile.ZipFile(sys.argv[1]) as archive:
    for name in ("LVMOGP.py", "IndepMOGP.py"):
        assert hashlib.sha256(archive.read(name)).hexdigest() == expected[name], name
PY
uv pip install --python "$env_dir/bin/python" --constraints "$pins" "$gs_wheel"
uv pip check --python "$env_dir/bin/python"

"$env_dir/bin/python" -I -B - "$snapshot/wsl-native/standard-python/py313-packages.json" <<'PY'
import importlib.metadata as metadata
import json
import re
import sys
from pathlib import Path

canonical = lambda name: re.sub(r"[-_.]+", "-", name).lower()
expected = {canonical(row["name"]): row["version"] for row in json.loads(Path(sys.argv[1]).read_text())}
actual = {}
for distribution in metadata.distributions():
    name = canonical(distribution.metadata["Name"])
    assert name not in actual or actual[name] == distribution.version, f"Conflicting metadata: {name}"
    actual[name] = distribution.version
differences = {name: {"expected": expected.get(name), "actual": actual.get(name)}
               for name in sorted(expected.keys() | actual.keys()) if expected.get(name) != actual.get(name)}
if differences:
    raise SystemExit(json.dumps(differences, indent=2))
print(f"All {len(expected)} package identities and versions match the snapshot.")
PY

"$env_dir/bin/python" -I -B "$repo_root/scripts/check-gpu-stack.py" \
  --expected "$snapshot/gpu-stack.json" --require-driver-match \
  --output "$env_dir/dotrepo-gpu-verification.json"

printf '[dotrepo] Verified candidate environment: %s\n' "$env_dir"
printf 'Run repository workloads before selecting this candidate as the default.\n'
