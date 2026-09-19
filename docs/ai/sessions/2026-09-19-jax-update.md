# JAX update on PC-PHILIP-WINDOWS

Date: 2026-09-19 (America/Chicago). Host: **PC-PHILIP-WINDOWS**.
The only registered WSL distribution is Ubuntu 24.04.4, x86_64.

## Installed result and remaining scope

The latest stable JAX release checked against official PyPI metadata was
**0.11.2**, released September 17. The three modern environments now have
JAX, jaxlib, `jax-cuda13-plugin` and `jax-cuda13-pjrt` at that version.

| Active environment | Python | JAX before | JAX after | Result |
| --- | --- | --- | --- | --- |
| `py313` | 3.13.15 | 0.11.1 | **0.11.2** | Dependency and CPU numerical checks passed; 338 packages |
| `jax313` | 3.13.15 | 0.11.1 | **0.11.2** | Dependency and CPU numerical checks passed; 104 packages |
| `jax314` | 3.14.7 | 0.11.1 | **0.11.2** | Dependency and CPU numerical checks passed; 104 packages |
| `jax-oracles313` | 3.13.15 | 0.6.2 | **0.6.2** | Preserved pending the compatibility decision described below; 51 packages |
| `uqpy312` | 3.12.3 | Absent | Absent | No JAX installation to upgrade; 44 packages |

Complete before/after package comparisons showed that **only the four JAX
packages changed** in each modern environment. NumPy, SciPy, Flax, the NVIDIA
CUDA libraries, TensorFlow/GPflow and editable project versions were preserved.
Counts above use unique normalized distribution names; matching duplicate
metadata for three editable projects is not counted twice.

Historical `.old` environments, archived environments and temporary candidates
were excluded from active installations. System and managed base interpreters
had no separate JAX installation. The other machine, PhilipSecond, remains
**pending**: this session found no reachable existing remote connection and
could not verify or update its environments. Pulling GitHub records does not
install the update on that machine.

The [machine receipt](../../../machines/pc-philip-windows-2026-09-19/jax-update.json)
records the package changes, checks and remaining limitations.

## Verification and rollback

Before changing active environments, isolated overlays of the four 0.11.2
packages passed checks with both Python 3.13 and 3.14. Resolver dry runs used
constraints for every unrelated installed package and planned only the four
expected replacements. The active environments then passed `uv pip check`
and fresh native Python CPU checks for:

- JIT compilation and automatic differentiation against an analytic matrix gradient.
- A linear solve and FFT roundtrip at float64 precision.
- Flax dense-layer initialization and compiled evaluation.
- An Optax update that reduced the loss, and Equinox compiled evaluation.

The JIT value error was zero and maximum gradient error was approximately
`3.55e-15` in all three environments. These are focused numerical checks, not
an exhaustive test of every scientific package.

Private inventories, constraints, resolver plans, numerical check source and
logs are under `~/.local/state/dotrepo/jax-upgrade-2026-09-19/`.
Four 0.11.1 rollback wheels for each Python ABI are saved there in
`rollback-wheels-cp313` and `rollback-wheels-cp314`. No rollback was needed.

## GPU verification is blocked by an existing driver failure

Before any package change, Windows `nvidia-smi` reported
`Failed to initialize NVML: GPU access blocked by the operating system`.
The native WSL executable reported `Failed to initialize NVML: N/A`, and
JAX 0.11.1 failed GPU initialization with `cuInit(0)` error 100. WSL kernel
logs also recorded GPU adapter initialization errors (`-22`).

The RTX 4070 Laptop GPU was present, with Windows driver **616.56**, and
`/dev/dxg` existed. Updating the Python wheels does not establish that GPU
access works. All successful numerical checks in this update explicitly used
CPU. Existing R jobs were preserved; no driver reset, WSL shutdown or reboot
was performed. GPU validation remains outstanding after host GPU access is
restored.

## Legacy oracle compatibility decision

An isolated copy of `jax-oracles313` with only JAX/jaxlib raised to 0.11.2
passed dependency metadata checks but **failed both Dynamax and BayesNF** at
runtime. TensorFlow Probability 0.25.0 accesses the removed
`jax.interpreters.xla.pytype_aval_mappings` API.

A second isolated candidate used JAX 0.11.2, Flax 0.12.9, Dynamax 1.0.2 and
`tfp-nightly==0.26.0.dev20260919`. Its Dynamax likelihood and BayesNF training
and prediction checks passed. However, BayesNF 0.1.3 declares a dependency on
the separately named `tensorflow-probability[jax]` distribution, so this
candidate has one unresolved dependency. Stable TFP and nightly share an
import namespace and were not coinstalled. This candidate was not promoted.

The user was asked whether to retain the working legacy stack or upgrade it
while preserving a backup. Pending that choice, the active companion remains
unchanged. All 51 package versions match its initial inventory; dependency
checks and both committed oracle workloads passed again. The numerical
likelihood was `-12.187799453735352`; the two-epoch BayesNF fit returned finite
predictions with shapes `[1, 1, 8]` and `[8]`.

## Apply after the September 14 baseline

The September 14 snapshots and `python/wsl/create-venv.sh` deliberately retain
their historical pins. Restore and validate that baseline first, then apply
this update separately to the three modern environments. Inventory each target
first: hardware, installed environment names and running jobs are machine-local.
Use the following inside native WSL for those verified environments:

```bash
set -euo pipefail
state="$HOME/.local/state/dotrepo/jax-update-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$state"
for env in py313 jax313 jax314; do
  py="$HOME/.virtualenvs/$env/bin/python"
  "$py" -I -B - <<'PY' > "$state/$env-preserve.txt"
from importlib import metadata
import re
changing = {"jax", "jaxlib", "jax-cuda13-plugin", "jax-cuda13-pjrt"}
pins = {}
for dist in metadata.distributions():
    name = re.sub(r"[-_.]+", "-", dist.metadata["Name"]).lower()
    if name in pins and pins[name] != dist.version:
        raise RuntimeError(f"Conflicting installed versions for {name}")
    pins[name] = dist.version
for name, version in sorted(pins.items()):
    if name not in changing:
        print(f"{name}=={version}")
PY
  uv pip install --dry-run --python "$py" \
    --constraint "$state/$env-preserve.txt" \
    'jax[cuda13]==0.11.2' jaxlib==0.11.2 \
    jax-cuda13-plugin==0.11.2 jax-cuda13-pjrt==0.11.2
done
```

Review the plans and save rollback packages before repeating the same
installation commands without `--dry-run`. Then run `uv pip check --python
"$py"`, numerical workload checks and a complete before/after package
comparison for each environment. This command block intentionally stops at
the reviewable plan. Do not include the legacy companion in this loop.

When GPU access works, `scripts/check-gpu-stack.py` can capture a fresh receipt.
Do not pass the September 14 receipt as `--expected`: it correctly rejects
the intentional JAX version change.

Official references: [JAX 0.11.2 release](https://pypi.org/project/jax/0.11.2/),
[JAX installation requirements](https://docs.jax.dev/en/latest/installation.html),
[Dynamax dependencies](https://github.com/probml/dynamax/blob/main/pyproject.toml),
and [BayesNF dependencies](https://github.com/google/bayesnf/blob/main/pyproject.toml).
