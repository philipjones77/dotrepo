# WSL replication on PhilipSecond, September 14–15

Target: **PhilipSecond**, Ubuntu 24.04.4, WSL 2 kernel 6.18.33.2,
GNU Bash 5.2.21. Source: the September 14 PC-PHILIP-WINDOWS capsule,
initially at dotrepo `cf83539`, followed by handoff update `0f68dd7`.
The five requested standard Python environments are selected and tested.
`gpflow312` was excluded by the user and is retired in the newer handoff.

## Active Python environments

| Environment | Python | Distributions | Exact source versions and dependency check |
| --- | --- | --- | --- |
| py313 | 3.13.15 | 338 | Passed |
| jax313 | 3.13.15 | 104 | Passed |
| jax314 | 3.14.7 | 104 | Passed |
| jax-oracles313 | 3.13.15 | 51 | Passed |
| uqpy312 | 3.12.3 | 44 | Passed |

Active names under `~/.virtualenvs` point to Linux-native installations under
`~/.local/share/dotrepo/environments/20260914`. Previous py313/jax313/jax314
directories remain under
`~/.local/state/dotrepo/replication-20260914/previous-environments` for rollback.
A fresh interactive Bash starts in `~` and activates py313; pip and pip3 are 26.2.1.

Four editable distributions use this machine's scientific checkouts. Local
changes and newer commits were preserved; equal distribution versions do not
establish identical source trees. Required RF77, data77, IFJ and Topo fixes are
ancestors of the target checkouts. The GS-LVMOGP wheel was rebuilt using the
committed helper and its recorded module hashes were checked.

Main py313 has JAX/jaxlib 0.11.1, NumPy 2.5.3, SciPy 1.18.1 and GPflow 2.9.2.
The exact main GPU comparison passed, including NVIDIA driver 616.56. This
machine has an RTX 5070 Laptop GPU. The loaded CUDA runtime API is 13.0,
runtime distribution 13.0.96, cuDNN distribution 9.24.0.43 and packaged compiler
tools 13.4.59. Driver capability 13.4 is separate from the loaded runtime.

All 22 main M-tier Python checks, the detailed GPflow CPU check, both reduced
JAX GPU checks, Dynamax/BayesNF, PyGAM and UQpy/Whittle companion checks passed.
Additional IFJ quadrature/NUFFT, RF77 scoring/Whittle, Gephi and existing neutral
SMPL/SMPL-X probes passed. The reduced JAX environments retain the source's
104-package scope; use py313 for the complete numerical reference suite.

JAX GPU followed by GPflow CPU and another JAX GPU calculation passed in one
process. Adding PyTorch GPU initialization after those frameworks failed with
CUDA error 302. A fresh-process PyTorch 2.14.0+cu130 GPU calculation passed.
Follow-up testing resolved this for the tested workloads by importing PyTorch
before TensorFlow. JAX + PyTorch pass without TensorFlow; TensorFlow -> PyTorch
fails even without JAX. PyTorch -> JAX -> TensorFlow/GPflow -> PyTorch -> JAX
passes. Importing PyTorch first, without an initial CUDA calculation, also
passes. This establishes an import-order dependency, not a need for a different
PyTorch installation. The precise conflicting loader symbol was not isolated.

In a fresh script or restarted notebook kernel, use:

```python
import os
os.environ['XLA_PYTHON_CLIENT_PREALLOCATE'] = 'false'
import torch
torch.cuda.init()
import jax
import tensorflow as tf
tf.config.set_visible_devices([], 'GPU')
import gpflow
```

Do this before any indirect TensorFlow/GPflow imports. No global Python startup
hook or package changes were applied. The committed
[`check-gpu-framework-coexistence.py`](../scripts/check-gpu-framework-coexistence.py)
passes GPU matrix multiplication, gradients and convolution in PyTorch, GPU
JIT gradients in JAX, and a GPflow CPU fit, with both GPU frameworks checked
again after the GPflow fit. The [receipt](../machines/philipsecond-2026-09-14/gpu-coexistence.json)
supersedes the earlier separate-process-only guidance. TensorFlow GPU and
arbitrary initialization orders remain outside this validation.

NVIDIA documents error 302 as a shared-library symbol resolution failure in its
[CUDA Driver API reference](https://docs.nvidia.com/cuda/cuda-driver-api/group__CUDA__TYPES.html).
The local order tests, rather than the error number alone, establish the workaround.

## R restoration

R 4.6.1 now exposes **517 active packages with ordinary startup**. All 516
source names and versions match. The extra package, V8 8.2.0, is required by
the source-pinned juicyjuice package but absent from the source inventory.
GLPK development headers were also needed to build Rglpk.

The new library, `~/.local/lib/R/replication-20260914`, is first in
`R_LIBS_USER` in `~/.Renviron`. Existing local, legacy and editor libraries
remain available afterward. The previous startup file was backed up under the
private replication state before selection. Fresh ordinary R startup confirms
all source versions and the 517-package total.

All 11 spatial/GP probes passed, including native INLA, inlabru, kriging,
Vecchia and GP predictions. All four RF77 R probes passed: CVXR's constrained
quadratic, autoFRK rank selection, loggle's three fitting modes with positive
definite precision estimates, and deepspat's two-layer fit through py313's
TensorFlow 2.21.0 on CPU.

BMGM 0.1.1 and fasjem 1.2.0 were restored from their official GitHub sources
at recorded commits because the CRAN downloads were unavailable. loggle uses
the source handoff's pinned Git commit and R 4.6 ABI patch. Archive hashes,
Git commits, exact inventories and test results are included in the capsule.

## Other WSL software

- Julia 1.13.0 with `@repo-oracles` and Julia 1.10.12 with
  `@repo-oracles-oilmm` were restored from recorded manifests. All seven
  quadrature/GP/MeijerG/OILMM checks passed.
- ExaGeoStatCPP 2.0.0, with local StarPU 1.3.10, Chameleon 1.1.0 and BLAS++,
  passed a 64-point CPU fit and eight predictions. `exageostat-cpu` is on PATH.
  GPU, MPI and low-rank modes were not enabled or validated.
- `mra-serial` passed two- and three-level likelihood/prediction checks. Its
  separate RF77 bridge retains the source handoff's protocol limitation.
- FLINT 3.4.0 and Boost 1.90 reference headers were installed from verified
  archives. Interval arithmetic and Boost Math gamma checks passed. This does
  not install all compiled Boost libraries.
- Pinned MBConicHulls, PolyLogTools, HPL and Gephi Toolkit assets were restored.
  The licensed Wolfram runtime passed both reference-loader checks. MeijerG
  retains the documented default shifted-Bessel limitation; explicit Slater
  and elementary-identity probes passed.
- Eigen, Armadillo and LAPACKE agreed on a linear solve; Octave's solve passed.
  APT additions include numerical development libraries, Java 21, GLPK tools,
  TeX science/extra packages, fonts and plotting/GUI dependencies.
- Native rclone 1.74.2 is the running Google Drive mount executable after
  restart. Both `~/mnt/gdrive` and Windows Drive `/mnt/g` are mounted read/write.
  The 16 GiB WSL memory cap and 24 GiB swap remain in effect.
  A user `dotrepo-gdrive.service`, enabled with user lingering, now starts the
  existing mount helper when WSL starts and retries it if it exits. This avoids
  depending on the lifetime of a tool-launched shell. The service uses existing
  private mount settings and credentials; its unit is included in the capsule.
  WSL itself can still shut down when idle; the service restarts on WSL startup.
- Shell/editor configuration was reapplied. Missing `tomoki1207.pdf` and
  `doonfrs.wsl-reveal-explorer` extensions were installed; existing extension
  versions were preserved.
- uv 0.12.10, Node 24.20.0, npm 12.0.2, Corepack 0.36.0, Rust 1.94.1,
  PowerShell 7.6.5, Claude 2.1.263, Codex 0.153.4 and Gemini 0.58.0 already
  matched the recorded versions. Licensed MATLAB/Wolfram installations and
  private model assets were preserved.

The APT inventory has 1,603 packages. Every source package identity is present
except `chatgpt` 26.901.51231, unavailable in configured repositories. An official
source installer is still needed for that app. `libinput-bin` and `libinput10`
retain target 1.25.0-1ubuntu3.7, newer than source 1.25.0-1ubuntu3.6.
APT completed without removals; package database and dependency checks passed.

## Restart and portable evidence

WSL became unresponsive during the earlier installation. After the authorized
restart, interrupted builds resumed and the five Python environments were
selected. The earlier memory observation did not establish the cause of the
interruption. An interrupted R HiGHS lock was preserved before retrying its build.

The [target capsule](../machines/philipsecond-2026-09-14/README.md) contains
inventories and numerical receipts. Full logs, archives and rollback data remain
under `~/.local/state/dotrepo/replication-20260914`. Credentials, license files,
private assets and raw conversations are not included in the portable record.
Scientific repository changes from concurrent sessions were preserved.
