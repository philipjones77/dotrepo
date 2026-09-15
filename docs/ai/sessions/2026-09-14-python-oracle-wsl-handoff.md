# Handoff: update the other machine's Python, oracle packages and WSL tools

Date: 2026-09-14 (America/Chicago)

Repository: dotrepo, branch `main`

Inspected machine: **PC-PHILIP-WINDOWS**, Windows with Ubuntu 24.04.4 on WSL 2

## Requested work and delivery

The user requested committing and pushing the installed numerical oracle package
inventory, and telling the other machine to update `py313`, its oracle packages
and other WSL installations. The other computer was previously called
**PhilipSecond**; verify its hostname before proceeding. This session inspected
PC-PHILIP-WINDOWS only. Target installation and target verification remain pending.

The user subsequently supplied a complete **34-oracle checklist** and requested
installing anything missing locally in `py313`, R or WSL. The
[machine-readable checklist](../../../config/m-tier-oracles.json) preserves the
exact package names and supplied citation identifiers. The bibliography's
Added/Reused labels do not describe package installation status.

**Completed locally:** all 22 Python oracles in `py313`, all 11 R oracles and
native ExaGeoStat passed functional smoke checks. The
[complete results and replication notes](../../wsl-m-tier-oracles-2026-09-14.md)
record each version and check. Final counts are 325 Python packages in `py313`,
498 active R packages and 1,546 APT packages. The other machine still needs to
pull and apply this setup.

This repository is the cross-machine communication channel, following the
[session methodology](../../ai-session-methodology.md). Pull `main` in both
Windows and native WSL checkouts on the other machine and read this handoff.
There is no configured remote provisioning endpoint or automatic delivery to a
running session on that machine. The new `AGENTS.md` link makes this handoff
discoverable when work resumes after pulling.

## Current source of package evidence

Use [the September 14 inventory](../../../machines/pc-philip-windows-2026-09-14/README.md).
It records the current installation on this computer, including changes since
the older September 7/8 reports. Versions here are observed versions, not claims
about the newest available releases.

`py313` uses **CPython 3.13.15**, **NumPy 2.5.3**, **SciPy 1.18.1**,
**JAX 0.11.1 with CUDA 13**, and **PyTorch 2.14.0**. Before the GPflow follow-up,
its inventory grew from 154 to 262 unique packages: 123 additions, 19 version
changes and 15 removals. Use the captured requirements and manual-source records
for the complete set. Adding GPflow and its dependencies below brought that
inventory to **283 packages** before the full 34-oracle installation pass.
The complete Python oracle pass brought `py313` to **325 packages**. Keep the
resolved **Flax 0.12.9** and
**scikit-sparse 0.4.16** versions in view when resolving dependencies; a blanket
upgrade would discard those compatibility choices. GPJax required the Flax
0.12.8 to 0.12.9 change to make Flax NNX work with the existing JAX 0.11.1.

The oracle and comparison packages now include:

| Area | Packages observed in `py313` |
| --- | --- |
| Exact and high precision | python-flint 0.9.0, mpmath 1.3.0, SymPy 1.14.0 |
| Optimization | CVXPY 1.9.2, Clarabel 0.11.1, HiGHS 1.15.1, OSQP 1.1.3, SCS 3.3.1 |
| Gaussian processes | GPy 1.14.2, GPyTorch 1.15.2, GPBoost 1.7.4 |
| Geometry and transport | geomstats 2.8.0, geoopt 0.5.1, geometric-kernels 0.4.1, POT 0.9.7.post1, ott-jax 0.5.2 |
| Meshes and sparse operators | scikit-fem 12.0.2, libigl 2.6.3, robust-laplacian 1.1.0, sparseDiffPy 0.3.0, scikit-sparse 0.4.16 |
| R integration | rpy2 3.6.7 and the native R library |

`jax313` and `jax314` currently have 104 unique packages each, with CPython
3.13.15 and 3.14.7 respectively. Their metadata dependencies pass, but both lack
`python-flint` and `diffrax`. The arbPlusJAX presence checker fails their Arb
certification requirement: five test files would otherwise skip. Treat these
as functional gaps to resolve for workloads needing those backends. Do not
recreate the reduced environments as if they supplied the full oracle stack.

## GPflow added to `py313`

The user clarified that GPflow should be installed in **`py313`**. This was
completed locally with the following tested combination:

| Package | Installed version |
| --- | --- |
| GPflow | 2.9.2 |
| TensorFlow | 2.21.0 |
| TensorFlow Probability | 0.25.0 |
| tf-keras | 2.21.0 |
| setuptools | 80.9.0 |

GPflow 2.11.1, the current PyPI release at inspection, declares `numpy<2`.
Its binary-only resolution fails on this CPython 3.13 environment. GPflow 2.9.2
resolves with the existing NumPy 2.5.3, but imports `pkg_resources`, which is
absent from setuptools 84.0.0. Pinning setuptools 80.9.0 supplies that module.
See the [release metadata](https://pypi.org/pypi/gpflow/2.11.1/json) and
[upstream NumPy 2 support discussion](https://github.com/GPflow/GPflow/issues/2119).
This is a locally tested compatibility combination; it is not an upstream
support guarantee for every GPflow feature or a reason to upgrade these pins blindly.

The installation added 21 distributions and changed only one existing version:
setuptools 84.0.0 to 80.9.0. A local backup of the original setuptools payload
and before manifests was retained. NumPy, SciPy, JAX and PyTorch versions stayed
unchanged. `gpflow312` remains available with GPflow 2.11.1, TensorFlow 2.18.1
and NumPy 1.26.4.

The staged candidate and installed `py313` both passed exact GPR optimization,
compiled SVGP training with tf-keras Adam, natural-gradient training, finite
gradient checks and prediction checks. The installed package dependency check
passed. A same-process check ran JAX GPU solves/gradients, GPflow CPU regression,
then another JAX GPU solve successfully. **GPflow was validated on CPU; its
TensorFlow GPU libraries are unavailable in this setup.** JAX GPU availability
does not establish TensorFlow/GPflow GPU availability.

Receipts: [installation changes](../../../machines/pc-philip-windows-2026-09-14/gpflow-install.json),
[GPflow checks](../../../machines/pc-philip-windows-2026-09-14/gpflow-validation.json),
and [JAX coexistence](../../../machines/pc-philip-windows-2026-09-14/gpflow-jax-coexistence.json).
On a reconciled target, preserve its before inventory and inspect the transaction
before applying these explicit pins:

```bash
uv pip install --dry-run --python "$HOME/.virtualenvs/py313/bin/python" \
  gpflow==2.9.2 tensorflow==2.21.0 tensorflow-probability==0.25.0 \
  tf-keras==2.21.0 setuptools==80.9.0
# Apply the reviewed plan, preserving the target's other required package pins.
```

Run the committed model check using the target interpreter after installation:

```bash
CUDA_VISIBLE_DEVICES=-1 JAX_PLATFORMS=cpu \
  OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 \
  "$HOME/.virtualenvs/py313/bin/python" -I -B scripts/check-gpflow-environment.py
uv pip check --python "$HOME/.virtualenvs/py313/bin/python"
```

## Other WSL installations to compare

- **APT before the full oracle pass:** 1,523 installed packages, 97 manual
  selections and no holds. Compare
  the full inventory and manual selections with the target before installing.
  Relevant libraries include FLINT, GMP/MPFR, GSL, Eigen, Armadillo, OpenBLAS,
  LAPACKE, SuiteSparse/CHOLMOD, FFTW and OpenMPI. The
  [September 8 runbook](../../wsl-software-parity-2026-09-08.md) covers previously
  added development, LaTeX, R and editor tools.
- **User-local reference builds:** FLINT 3.4.0 and Boost 1.90.0 under
  `~/.local/opt/arbplusjax_refs`, separate from APT's FLINT 3.0.1 and Boost 1.83.
  Review `benchmarks/source_reference_env.sh` in arbPlusJAX and its build
  instructions to select the intended reference libraries on the target.
  Source archives are retained locally and require separate transfer or retrieval.
- **PETSc/SLEPc:** source checkouts identify 3.25.5/3.25.1; no configured headers,
  built shared libraries or pkg-config files were found in those checkouts.
  Source presence alone does not satisfy an oracle installation requirement.
- **R/Octave:** R 4.6.1, Octave 8.4.0 and GLPK 5.0. Compare ordinary R startup
  and active user libraries as well as distribution packages; `--vanilla` skips
  user startup and therefore sees a smaller package set: before the full oracle
  pass there were 72 vanilla packages versus 490 active packages through ordinary
  startup. Use the final capture summary for post-installation counts.
- **Development tools:** Node 24.20.0, npm 12.0.2, Corepack 0.36.0,
  Rust/Cargo 1.94.1, uv 0.12.10, PowerShell 7.6.5 and rclone 1.74.2.
  The inventory also records 35 active WSL VS Code extensions.
- **WSL itself and other distributions:** enumerate each registered WSL
  distribution on the target. Compare its WSL version, Ubuntu updates, Snap
  packages, native tools and user environments independently. Only one Ubuntu
  distribution was registered on the inspected computer. Preserve hardware,
  licensing, mounts and existing WSL memory/swap choices.

## Target execution order

1. Inspect hostname, `git status` and remotes in both native checkouts; preserve
   local edits, then pull `main` with `git pull --ff-only` where possible.
2. Capture before inventories and check running Python/R jobs. Keep rollback
   records before replacing any package or environment.
3. Compare APT manual selections and installed versions. Refresh the target's
   own signed indexes, simulate proposed installs/upgrades with `--no-remove`,
   then apply compatible changes. Use its existing Ubuntu release and repositories.
4. Reconcile `py313` against this inventory in a separate candidate environment
   first. Restore the four editable repositories from their manual manifests,
   including separately preserved source changes. Install the reviewed ordinary
   pins, then validate and switch only when the target's workloads pass.
   The older `python/wsl/create-venv.sh` still references the September 7 baseline;
   it does not implement this complete reconstruction.
5. Check oracle availability in every environment that needs certification.
   Handle the missing FLINT/diffrax packages in the reduced JAX environments
   explicitly. Check native reference library lookup, R startup, Octave,
   LaTeX/editor tools and any additional WSL distributions.
6. Run dependency checks and real numerical workloads, then capture after
   inventories. Record actual target results and remaining gaps in a new capsule,
   commit and push the authorized updates.

## Verification in this session

All four active Python environments passed dependency checks. `jax313` and
`jax314` have no `pip` module, so their checks used `uv pip check --python`.
Package metadata was captured without installing pip or changing those environments.

`py313` passed CPU checks for SciPy and CHOLMOD solves, FLINT Arb enclosures,
high-precision mpmath, and CVXPY solves with Clarabel, OSQP, SCS and HiGHS.
Its arbPlusJAX backend-presence check passed; optional backends remain absent.
The [oracle receipt](../../../machines/pc-philip-windows-2026-09-14/oracle-checks.json)
records the scope and JAX gaps. The numerical CPU checks passed again after the
GPflow installation.
The native Eigen/Armadillo/LAPACKE comparison, R matrix checks and an Octave
linear solve passed. `dpkg --audit` and the root APT dependency check passed.
These are focused checks, not complete project or target-machine validation.

## Resume prompt for the other machine

```text
Continue dotrepo on the other computer. Pull main in Windows and native WSL,
preserving local changes, then read the September 14 Python/oracle/WSL handoff
and machines/pc-philip-windows-2026-09-14/README.md. Verify the hostname.
Update py313 and numerical oracle coverage against the captured inventory;
review the GPflow compatibility outcome in this handoff before installing it.
Compare other WSL installs, native libraries, R/Octave, development tools and
editor extensions. Preserve active jobs, rollback records, local source edits,
credentials and licensed software. Check missing FLINT/diffrax in JAX envs.
Validate actual workloads and publish the target's resulting inventory and gaps.
```
