# Exact JAX and CUDA replication

The source is **PC-PHILIP-WINDOWS**, Ubuntu WSL 2, with `py313` using Python
3.13.15. The [GPU receipt](../machines/pc-philip-windows-2026-09-14/gpu-stack.json)
records all 31 selected GPU and core numerical distribution versions. It also
records the libraries actually loaded and a successful JAX GPU calculation.
The other machines still need their own installation and verification.

## Source versions

| Component | Observed version |
| --- | --- |
| JAX, jaxlib, jax-cuda13-plugin, jax-cuda13-pjrt | All `0.11.1` |
| NumPy / SciPy / Flax | `2.5.3` / `1.18.1` / `0.12.9` |
| PyTorch / Triton | `2.14.0` / `3.8.0` |
| `torch.version.cuda` | `13.0` |
| NVIDIA Windows driver | `616.56` |
| GPU / compute capability | RTX 4070 Laptop / `8.9` |
| Driver-reported CUDA capability | `13.4` |
| `nvidia-cuda-runtime` package / loaded CUDA runtime API | `13.0.96` / `13.0` |
| `cuda-toolkit` Python metapackage | `13.0.3.0` |
| `nvidia-cudnn-cu13` package / loaded cuDNN API | `9.24.0.43` / `9.24.0` |
| Packaged `nvcc` and `ptxas` executables | Both `13.4.59` |

These numbers describe different components. The `nvidia-smi` CUDA heading
reports driver capability; it does not establish the installed runtime or
compiler version. NVIDIA's [compatibility guide](https://docs.nvidia.com/deploy/cuda-compatibility/minor-version-compatibility.html)
explains driver/runtime compatibility and its limitations. Preserve the exact
component pins from the receipt when reproducing this tested combination.

`nvcc` and `ptxas` were absent from the inspected WSL `PATH`, but both exist
inside py313 at `lib/python3.13/site-packages/nvidia/cu13/bin/`. Their `--version`
commands passed. A missing `command -v nvcc` result alone does not mean the
compiler package is missing. The JAX workload succeeded with this arrangement.

## Host driver and WSL

Install a GPU-compatible NVIDIA **Windows** driver on a Windows/WSL target.
WSL uses that driver; NVIDIA instructs users to avoid installing a Linux display
driver inside WSL. Follow the official
[CUDA on WSL guide](https://docs.nvidia.com/cuda/wsl-user-guide/index.html).
The source driver's exact version is recorded above, so a target driver
difference can be reviewed explicitly. No driver was changed by this audit.

JAX's [installation guide](https://docs.jax.dev/en/latest/installation.html)
documents Linux CUDA wheels, experimental WSL GPU support, CUDA 13's minimum
SM 7.5 GPU requirement, and driver compatibility. The target must support this
CUDA 13 stack. Matching Python package names on incompatible hardware does not
establish GPU parity. Use the target's actual GPU and Windows driver when
checking compatibility.

The source CUDA libraries come from Python wheels. Inspect `LD_LIBRARY_PATH`
on the target: an unrelated system CUDA installation can override wheel
libraries, as described in the same JAX guide. Record and reconcile an override
before declaring parity. This run did not install a system CUDA toolkit or
change global library paths.

## Reproduce the exact package pins

Use the [full machine inventory](../machines/pc-philip-windows-2026-09-14/README.md)
and [cross-machine handoff](ai/sessions/2026-09-14-python-oracle-wsl-handoff.md)
for the complete Python, R, Julia, native and WSL setup. The following extracts
only the GPU/core pins from the receipt, for comparison or reconciliation inside
the target's Python 3.13.15 environment. Run from the dotrepo checkout:

```bash
gpu_receipt=machines/pc-philip-windows-2026-09-14/gpu-stack.json
gpu_pins="$(mktemp)"
python3 - "$gpu_receipt" "$gpu_pins" <<'PY'
import json
from pathlib import Path
import sys

versions = json.loads(Path(sys.argv[1]).read_text())["packages"]
Path(sys.argv[2]).write_text("".join(
    f"{name}=={version}\n" for name, version in sorted(versions.items())
))
PY
gpu_python="$HOME/.virtualenvs/py313/bin/python"
"$gpu_python" --version
uv pip install --dry-run --python "$gpu_python" -r "$gpu_pins"
# Apply after checking the target transaction against its full preserved inventory.
uv pip install --python "$gpu_python" -r "$gpu_pins"
uv pip check --python "$gpu_python"
```

The exact NVIDIA library pins matter: requesting only `jax[cuda13]==0.11.1`
allows its dependencies to resolve differently. Reconcile in a candidate
environment when the target already contains workloads with conflicting pins.
Keep the oracle companion environments' separate JAX/NumPy versions; these
main-py313 pins are not a blanket update for every environment.

## Verify the target

The portable [GPU checker](../scripts/check-gpu-stack.py) compares exact Python,
package, compiler and loaded runtime versions with the source receipt. It then
runs a JIT-compiled 4 by 4 matrix calculation and its analytic gradient on an
explicitly selected JAX GPU. GPU preallocation is disabled and CPU thread counts
are one. See JAX's [memory allocation settings](https://docs.jax.dev/en/latest/gpu_memory_allocation.html).

```bash
"$HOME/.virtualenvs/py313/bin/python" -I -B scripts/check-gpu-stack.py \
  --expected machines/pc-philip-windows-2026-09-14/gpu-stack.json \
  --output /tmp/target-gpu-stack.json
```

The source calculation and gradient both had zero observed error. PyTorch
reported CUDA availability, build CUDA 13.0 and loaded cuDNN 9.24.0; this focused
checker does not run a PyTorch training workload. It exits nonzero on a failed
GPU calculation or a version mismatch, and lists each mismatch in JSON.

Add `--require-driver-match` to require source driver `616.56` as well. By
default the checker records driver and hardware differences while requiring
the same Python/compiler/runtime stack and successful GPU execution. Add
`--inventory-only` for package/compiler comparison without loading GPU runtimes;
that mode does not establish functional GPU parity. The comparison logic was
verified with deliberate package/runtime differences, including an actual CLI
failure for an incorrect JAX version.

Keep each target's resulting receipt with its machine inventory. Exact WSL,
APT, R and Julia replication requires the additional manifests and checks in
the cross-machine handoff; the GPU receipt covers this component of that setup.
