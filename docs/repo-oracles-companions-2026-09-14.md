# Recreate the companion oracle environments

These are the **PC-PHILIP-WINDOWS, Ubuntu WSL, Linux x86-64** snapshots. Read the
[cross-machine handoff](ai/sessions/2026-09-14-python-oracle-wsl-handoff.md) first
and preserve the target's current environments and checkout changes.

| Environment | Python | Packages | Main compatibility pins |
| --- | --- | --- | --- |
| `jax-oracles313` | 3.13.15 | 51 | JAX/jaxlib 0.6.2, Flax 0.10.7, TFP 0.25.0, SciPy 1.16.3; Dynamax 1.0.1, BayesNF 0.1.3, PyGAM 0.12.0 |
| `uqpy312` | 3.12.3 | 44 | NumPy 1.26.4, PyTorch 2.2.2+cpu, setuptools 80.9.0; UQpy 4.2.1, Debiased Spatial Whittle 2.2.0 |
| `gpflow312` | 3.12.3 | 52 | GPflow 2.11.1, TensorFlow 2.18.1, tf-keras 2.18.0, NumPy 1.26.4 |
| `jax313` / `jax314` | 3.13.15 / 3.14.7 | 104 each | Reduced JAX 0.11.1 / CUDA 13 snapshots with four editable scientific repos |

The complete pins and source records are in
[standard-python](../machines/pc-philip-windows-2026-09-14/wsl-native/standard-python/).
All five inventories matched their existing environments exactly. Fresh
dependency resolution using `uv pip install --dry-run --reinstall` succeeded
for 51, 44, 52, 104 and 104 packages respectively; no packages were installed
or replaced during these replay checks.

## Create new candidates

Run from the dotrepo checkout in native WSL, with `uv` on PATH. The Python
selectors below request the captured patch versions; verify those interpreters
are available on the target. Here, Ubuntu supplies `/usr/bin/python3.12` as
3.12.3. No candidate is automatically selected as the active environment.

```bash
set -euo pipefail
pins="$PWD/machines/pc-philip-windows-2026-09-14/wsl-native/standard-python"
build_pins="$PWD/python/wsl/m-tier-build-constraints.txt"
mkdir -p "$HOME/.virtualenvs"
candidate_root="$(mktemp -d "$HOME/.virtualenvs/oracle-replay-20260914.XXXXXX")"

restore_candidate() {
  local name="$1" python_version="$2"
  shift 2
  local candidate_python="$candidate_root/$name/bin/python"
  uv venv --python "$python_version" "$candidate_root/$name"
  "$candidate_python" -I -B -c 'import sys; assert sys.version.split()[0] == sys.argv[1]' "$python_version"
  uv pip install --dry-run --python "$candidate_python" \
    --default-index https://pypi.org/simple --build-constraints "$build_pins" \
    --constraints "$pins/$name-requirements.txt" -r "$pins/$name-requirements.txt" "$@"
  uv pip install --python "$candidate_python" \
    --default-index https://pypi.org/simple --build-constraints "$build_pins" \
    --constraints "$pins/$name-requirements.txt" -r "$pins/$name-requirements.txt" "$@"
  uv pip check --python "$candidate_python"
  "$candidate_python" -I -B - "$pins/$name-packages.json" <<'PY'
import importlib.metadata as metadata
import json
import re
import sys
from pathlib import Path

canonical = lambda name: re.sub(r"[-_.]+", "-", name).lower()
expected = {canonical(row["name"]): row["version"]
            for row in json.loads(Path(sys.argv[1]).read_text())}
actual = {}
for distribution in metadata.distributions():
    name = canonical(distribution.metadata["Name"])
    assert name not in actual or actual[name] == distribution.version, name
    actual[name] = distribution.version
differences = {name: (expected.get(name), actual.get(name))
               for name in expected.keys() | actual.keys()
               if expected.get(name) != actual.get(name)}
assert not differences, differences
print(f"All {len(expected)} package identities and versions match.")
PY
}

restore_candidate jax-oracles313 3.13.15
torch_cpu='https://download-r2.pytorch.org/whl/cpu/torch-2.2.2%2Bcpu-cp312-cp312-linux_x86_64.whl#sha256=431a747b5a880cf8e1fb6d58db6bfafa6768cbec76517d046854537c03323edf'
restore_candidate uqpy312 3.12.3 "torch @ $torch_cpu"
restore_candidate gpflow312 3.12.3
```

The Torch URL and SHA256 were verified against the
[official PyTorch CPU wheel index](https://download.pytorch.org/whl/cpu/torch/).
It selects only the CPython 3.12 Linux x86-64 CPU Torch wheel. All other packages
continue to resolve against PyPI with their complete snapshot pins. The first
three environments have no manual-source packages. Do not add `--seed` to the
creation commands: the snapshots already specify any pip/setuptools packages
they contain.

## Numerical checks

The portable JAX check runs an eight-step state-space likelihood and a two-epoch
BayesNF fit/prediction; the Whittle check evaluates a 4-by-4 spatial likelihood.
Both helpers and the PyGAM fit passed in the existing companion environments.
The GPflow312 check also passed exact GPR, SVGP training and natural-gradient
training. Use the candidate interpreters for the corresponding checks:

```bash
export CUDA_VISIBLE_DEVICES=-1 JAX_PLATFORMS=cpu
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1
"$candidate_root/jax-oracles313/bin/python" -I -B scripts/check-jax-oracle-companion.py
"$candidate_root/jax-oracles313/bin/python" -I -B scripts/check-repo-python-oracles.py pygam
"$candidate_root/uqpy312/bin/python" -I -B scripts/check-whittle-oracle-companion.py
"$candidate_root/gpflow312/bin/python" -I -B scripts/check-gpflow-environment.py
```

For RF77's existing UQpy subprocess bridge, point the main `py313` test runner
at the companion. The [UQpy receipt](../machines/pc-philip-windows-2026-09-14/repo-oracles/uqpy312.json)
records four passing DirectPOD tests, including eigendecomposition parity:

```bash
export RF77_UQPY_PYTHON="$candidate_root/uqpy312/bin/python"
projects_root="${PROJECTS_HOME:-$HOME/projects}"
(cd "$projects_root/RandomFields77"
  PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 "$HOME/.virtualenvs/py313/bin/python" -I -B -m pytest \
    tests/tests_continuous/test_e_tier_oracle_uqpy.py \
    --noconftest -o addopts= -p no:cacheprovider -q)
```

## Restore the reduced JAX snapshots when needed

Reconcile `arbPlusJAX`, `IntegralFunctionsJAX`, `RandomFields77` and
`TopoSmplJAX` with the commits and local changes in the
[jax313 source record](../machines/pc-philip-windows-2026-09-14/wsl-native/standard-python/jax313-manual-sources.json)
or corresponding `jax314-manual-sources.json`. All four records flag local
changes, so their Git commits alone do not fully reconstruct the source state.
Preserve the target's changes separately. The directory spelling is
`TopoSmplJAX`; its distribution name is `TopoSMPLJAX`.

Then use the same function and still-new candidate root above:

```bash
projects_root="${PROJECTS_HOME:-$HOME/projects}"
editable_sources=(-e "$projects_root/arbPlusJAX" -e "$projects_root/IntegralFunctionsJAX"
                  -e "$projects_root/RandomFields77" -e "$projects_root/TopoSmplJAX")
restore_candidate jax313 3.13.15 "${editable_sources[@]}"
restore_candidate jax314 3.14.7 "${editable_sources[@]}"
```

These snapshots **lack `python-flint` and `diffrax`**. Restoring their 104
packages reproduces that limited coverage. Use the main `py313` environment
for the complete Python oracle set, and validate GPU operation against the
target's actual NVIDIA driver separately.

## Integration limits

The companion stacks preserve dependencies incompatible with main `py313`:
UQpy and Whittle need NumPy 1; PyGAM needs the older SciPy range; the captured
Dynamax/BayesNF stack needs its older JAX/TFP combination. Do not merge these
pins into the main environment. `gpflow312` is also a separate snapshot;
main `py313` intentionally uses GPflow 2.9.2 with TensorFlow 2.21.0 instead.

RF77 supports the `RF77_UQPY_PYTHON` subprocess setting. Its Whittle and BayesNF
gates currently import in-process, so companion installation does not make
those gates pass in main `py313`. The standalone companion checks verify the
installed references; the remaining adapter work is recorded in the
[main audit](repo-oracles-2026-09-14.md).
