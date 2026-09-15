# Handoff: replicate the Python, oracle and WSL setup through GitHub

Date: 2026-09-14 (America/Chicago). Repository: dotrepo, branch `main`.
Inspected host: **PC-PHILIP-WINDOWS**, Ubuntu 24.04.4 under WSL 2.

## Requested outcome and delivery

The user requested the same oracle setup for **IntegralFunctionsJAX (IFJ),
RandomFields77 (RF77), TopoSmplJAX and data77** on the other machines, including
GPflow in **py313**, R and Julia packages, exact JAX/CUDA versions, and the other
WSL installations. IFJ was pulled again to audit its additional references.
The earlier [34-oracle checklist](../../../config/m-tier-oracles.json) is part
of this broader request. Its bibliography Added/Reused labels are citation status.

**Delivery is commit/push to GitHub, followed by pull and installation on each
target.** Pulling dotrepo delivers inventories, configuration and recipes; it
does not install software by itself. This session changed the source host only.
The other machine was previously called PhilipSecond; verify its current
hostname. Preserve machine-local edits and running jobs. Follow the
[session methodology](../../ai-session-methodology.md) when recording target work.

## Current source of truth

Use the [September 14 machine capsule](../../../machines/pc-philip-windows-2026-09-14/README.md)
and [four-repository audit](../../repo-oracles-2026-09-14.md). These supersede
earlier totals, including the intermediate 325-Python/498-R M-tier stage.

| Environment or installation | Captured state |
| --- | --- |
| `py313` | CPython 3.13.15; **338** distributions: 333 ordinary pins, four editable projects and one local GS-LVMOGP wheel |
| `gpflow312` | CPython 3.12.3; 52 packages; GPflow 2.11.1 / TensorFlow 2.18.1 / NumPy 1.26.4 |
| `jax313` / `jax314` | CPython 3.13.15 / 3.14.7; 104 packages each; reduced coverage, missing python-flint and diffrax |
| `jax-oracles313` | CPython 3.13.15; 51 packages; JAX 0.6.2 / Flax 0.10.7 / TFP 0.25.0 / SciPy 1.16.3 for Dynamax, BayesNF and PyGAM |
| `uqpy312` | CPython 3.12.3; 44 packages; NumPy 1.26.4 / CPU PyTorch 2.2.2+cpu for UQpy and Debiased Spatial Whittle |
| R | 4.6.1; **516 active packages** with ordinary startup; 72 with `--vanilla` |
| Julia | 1.13.0 with `@repo-oracles`; 1.10.12 with `@repo-oracles-oilmm` |
| Ubuntu APT | **1,559 installed packages**, 104 manual selections, no holds |

All six Python environments pass dependency checks. This follow-up added
13 packages to main py313 and 18 to R; every previous 325 Python and 498 R
package version was preserved. The smaller JAX environments remain incomplete
for Arb certification despite clean dependency metadata.

### Exact main Python and GPU versions

Main py313 retains NumPy **2.5.3**, SciPy **1.18.1**, JAX/jaxlib/CUDA 13
plugin/PJRT **0.11.1**, Flax **0.12.9**, and PyTorch **2.14.0**.
The [GPU receipt](../../../machines/pc-philip-windows-2026-09-14/gpu-stack.json)
records all 31 selected core/GPU pins, compiler versions and loaded libraries.

- NVIDIA Windows driver: **616.56**; source GPU: RTX 4070 Laptop, SM 8.9.
- Driver-reported CUDA capability: **13.4**.
- Loaded CUDA runtime API: **13.0**; runtime distribution: **13.0.96**.
- Loaded cuDNN API: **9.24.0**; distribution: **9.24.0.43**.
- Bundled `nvcc` and `ptxas`: **13.4.59**, inside py313's `nvidia/cu13/bin`.
  They are absent from the inspected WSL PATH; the executables are installed.

These identify different components. Follow the
[GPU replication guide](../../repo-oracles-gpu-2026-09-14.md), including Windows
driver and target hardware requirements. Preserve exact NVIDIA dependency pins;
installing only `jax[cuda13]` permits a different resolution. The guide links
official JAX/NVIDIA instructions, including using the Windows driver from WSL.
JAX GPU calculations and gradients passed; GPflow checks used CPU.

### GPflow compatibility choice

Main py313 uses **GPflow 2.9.2, TensorFlow 2.21.0, TensorFlow Probability 0.25.0,
tf-keras 2.21.0 and setuptools 80.9.0**. GPflow 2.11.1 declares NumPy below 2
and cannot use the retained py313 stack. GPflow 2.9.2 needs `pkg_resources`,
supplied by the setuptools pin. Preserve GPJax 0.13.6, Flax 0.12.9 and
scikit-sparse 0.4.16 as well. Exact GPR, SVGP, natural-gradient and prediction
checks passed, as did JAX GPU -> GPflow CPU -> JAX GPU in one process.
The [M-tier runbook](../../wsl-m-tier-oracles-2026-09-14.md) records the package
metadata rationale, source links and checks for all 34 original oracles.

## Repository source changes to pull

| Repository | Published state needed for this audit |
| --- | --- |
| IntegralFunctionsJAX | Fast-forwarded to `611ac9b595665fb8df204017bf9f0a69185776f8`; no local tracked edits made |
| RandomFields77 | [`7c44d474f35cf8dfc6bb9d2440e7b2525ad4d48a`](https://github.com/philipjones77/RandomFields77/commit/7c44d474f35cf8dfc6bb9d2440e7b2525ad4d48a): compatible GPflow availability and current observation-noise accessor |
| data77 | [`6e96b3616a25f3605308ff25ab6baeb63b56a7f6`](https://github.com/philipjones77/data77/commit/6e96b3616a25f3605308ff25ab6baeb63b56a7f6): seven oracle import-order fixes and environment initialization fix |
| TopoSmplJAX | Audited `ab67c2e426f3a95f6b676c8aac72e6ed1bd4ded5`; no source edits |

Main py313 also includes editable arbPlusJAX. Its identity and all editable
commits are in the manual-source manifest. Source-host local edits and untracked
assets remain outside these commits. The pre-existing RF77 kernel registry edit
was preserved. Matching package versions or Git commits alone do not reproduce
those local trees; reconcile them through each repository's own workflow.

## WSL installations and build recipes

| Component | Evidence and reproduction instructions |
| --- | --- |
| All six Python environments | `wsl-native/standard-python/` in the machine capsule; [companion guide](../../repo-oracles-companions-2026-09-14.md) |
| Main py313 | [Candidate installer](../../../python/wsl/create-venv.sh), ordinary pins and manual-source manifest |
| All R packages | `wsl-native/r-active-packages.tsv`; [RF77 guide](../../repo-oracles-rf77-2026-09-14.md) includes loggle's R ABI patch and checks |
| Julia and Mathematica references | [IFJ/Julia guide](../../repo-oracles-ifj-2026-09-14.md), both Julia Project/Manifest pairs, verified archives, MeijerG, quadrature and GP references, MBConicHulls, PolyLogTools/HPL, TOPCOM and GiNaC |
| Native ExaGeoStat | [Pinned CPU build](../../exageostat-wsl-2026-09-14.md); private StarPU 1.3.10 and Chameleon 1.1.0; `~/.local/bin/exageostat-cpu` |
| Native MRA and GS-LVMOGP | [RF77 build recipes](../../repo-oracles-rf77-2026-09-14.md), compatibility patches, hashes and wheel builder |
| Gephi, SMPL family, Gmsh and geometry | [Topo guide](../../repo-oracles-topo-2026-09-14.md); Gephi Toolkit 0.10.1, Java 21; existing private model caches |
| Ubuntu packages | Complete `apt-installed.json`, `apt-manual.txt` and holds in the capsule; FLINT, GMP/MPFR, GSL, Eigen, Armadillo, OpenBLAS, LAPACKE, SuiteSparse, FFTW and OpenMPI development libraries |
| User-local FLINT/Boost | FLINT 3.4.0 and Boost 1.90.0 under `~/.local/opt/arbplusjax_refs`; arbPlusJAX `benchmarks/source_reference_env.sh` and pinned build instructions |
| Remaining software | [Native summary](../../../machines/pc-philip-windows-2026-09-14/native-summary.json), [September 8 WSL runbook](../../wsl-software-parity-2026-09-08.md), [LaTeX setup](../../latex-toolchain.md), [MATLAB setup](../../matlab-wsl-2026-09-07.md) |

R's ordinary startup selects `~/.local/lib/R/site-library`. Compare that library
as well as distribution packages; vanilla startup misses most oracles. Use exact
recorded R versions and official source archives when current repositories have
moved on. Build missing packages in a separate library first. The deepspat check
selects existing py313 through `RETICULATE_PYTHON`.

Other observed tools include Octave 8.4.0, GLPK 5.0, Node 24.20.0, npm 12.0.2,
Corepack 0.36.0, Rust/Cargo 1.94.1, uv 0.12.10, PowerShell 7.6.5, rclone 1.74.2,
and 35 WSL VS Code extensions. PETSc/SLEPc 3.25.5/3.25.1 sources exist,
but no configured build or usable libraries were established.

Enumerate every WSL distribution on each target and capture its state. Only
Ubuntu was registered on this host. The [WSL capture tools](../../../wsl/README.md)
record Windows/WSL versions, repositories, services, toolchains and environments
in a private snapshot. Preserve machine-specific mounts, memory/swap settings,
credentials and licensed assets. Public manifests exclude those private payloads,
backup environments and temporary staging directories.

## Target execution order

1. Verify hostname, remotes, branches and `git status` in Windows and native WSL.
   Preserve local changes and pull `main` with `git pull --ff-only` where applicable.
   Pull the four scientific repositories too.
2. Capture the target before state and inspect active Python/R/Julia/GPU jobs.
   Compare Windows driver, WSL release, APT sources and exact inventories.
3. Install missing native prerequisites using the target's signed repositories.
   Simulate APT transactions with `--no-remove`; compare exact versions and
   manual selections. Record unavailable pins instead of silently substituting
   newer packages. Keep hardware-specific configuration.
4. Restore editable checkouts, then create a **new** main candidate:

   ```bash
   cd "$HOME/projects/dotrepo"
   bash python/wsl/create-venv.sh "$HOME/.virtualenvs/py313-candidate"
   ```

   The script requires CPython 3.13.15, resolves 333 ordinary pins with four
   editable sources, rebuilds and verifies GS-LVMOGP, checks all 338 versions
   and dependencies, and runs exact GPU/driver comparison. It refuses an
   existing destination and leaves activation to the target run.
   `PROJECTS_HOME` may select a different native checkout root. Reconcile
   source commits and local changes before selecting this candidate.
5. Restore other Python environments from their own manifests, including the
   CPU PyTorch source in the companion guide. Restore R, both Julia projects,
   native builds, Gephi and other WSL tools using the linked recipes. Keep
   companions' different JAX/NumPy pins. Missing reduced-environment Arb backends
   require a workload decision; main py313 already has those oracles.
6. Run committed numerical probes and repository checks. The WSL shell hook
   `wsl/repo-oracle-env.sh` selects existing local oracle paths and preserves
   explicit overrides. It starts no runtime. Check a fresh shell after applying
   the recipes; retain private licensed assets on each machine.
7. Select validated environments when target jobs can use them, capture after
   inventories and GPU receipts, then commit/push actual results and remaining
   differences. A source-host check is not a target result.

## Validation scope and remaining gaps

The original 34 oracles passed focused numerical checks. The broader audit adds
IFJ FFTLog/integration tests, RF77 UQpy/GS-LVMOGP/GPflow/R/MRA checks, Topo geometry,
Gephi/SMPL checks, data77 imports and small GP fits, and Julia checks. Results are
in the linked runbooks and `repo-oracles/` receipts. The candidate installation
transaction was dry-run successfully against the installed stack; a fresh full
338-package reconstruction has not been tested here.

Remaining documented limits include unavailable `JuliaStats/GraphicalModels.jl`,
MeijerG's incorrect default shifted-Bessel reduction (explicit Slater passed),
RF77 Whittle/BayesNF in-process gates that cannot see companions, and RF77 MRA's
incompatible reference protocol. IFJ has planned or caller-registered adapters
and a trained-artifact requirement. Topo's recorded geomstats skips/expected
failure remain. GPflow is CPU-validated; TensorFlow GPU availability is not
established by the working JAX GPU stack.

## Resume prompt for each other machine

```text
Pull dotrepo main in Windows and native WSL, preserving local changes, then read
docs/ai/sessions/2026-09-14-python-oracle-wsl-handoff.md and the September 14 machine
capsule. Verify hostname. Reproduce the IFJ, RF77, TopoSmplJAX and data77 oracle
setup, including py313's exact JAX/CUDA/driver versions, all six Python envs,
R, both Julia environments, native builds and the other WSL installs. Pull the
documented scientific repo fixes. Use candidate environments and preserve active
jobs/local assets. Apply the recorded pins and recipes, run numerical and exact
GPU checks, then commit/push this machine's after inventory and remaining gaps.
```
