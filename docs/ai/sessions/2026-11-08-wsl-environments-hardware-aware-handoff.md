# Other-machine handoff: Windows/WSL defaults and cleanup

Date: 2026-11-08. Source: PC-PHILIP-WINDOWS. Target: verify the hostname first
(usually PhilipSecond). Pulling this repository updates instructions and helpers;
it does not install packages, change drivers, or prove the target works.

## Requested outcome

- WSL `py314`: default general-development environment, with broad oracle coverage.
- WSL `jax314`: production successor to `jax313` for the scientific libraries.
- WSL `jax315`: Python 3.15 research environment; document actual compatibility gaps.
- Keep every old environment. Keep R and its required tools in WSL; do not
  reinstall Windows R, Rtools, RStudio or Radian. Grammarly was removed here.
- Keep only `data77`, `IntegralFunctionsJAX`, `TopoSmplJAX`, `RandomFields77`, and
  `arbPlusJAX` in `~/projects`. Supporting repositories go in `~/.local/src`,
  applications in `~/.local/opt`, and reusable data in `~/.local/share`.
- Remove obsolete production worktrees and migration files after identifying
  them on the target. Preserve the five current checkouts and their local work.
- Use newer releases where available and tested on the target. This is a role
  and behavior migration, not a requirement to reproduce every source pin.

## Source results, not target requirements

| Environment | Python | Distributions |
| --- | --- | --- |
| py314 | 3.14.10 | 458 |
| jax314 | 3.14.10 | 202 |
| jax315 | 3.15.2 | 201 |

The source GPU is an RTX 4070 Laptop. Windows driver 621.14, CUDA toolkit and
bindings 13.5.0, NVCC 13.5.37, JAX/jaxlib 0.12.0.1, NumPy 2.5.4 and SciPy 1.18.1
were tested. Native Windows `py314` uses the same Python/JAX/NumPy/SciPy versions
with JAX on CPU. R 4.6.2 sees 843 installed packages in WSL.

The [portable package inventory](../../../python/wsl/snapshots/2026-11-08-packages.json)
contains observed names and versions, without machine paths or credentials.
Use it as a coverage checklist, not `pip sync` input. Entries marked
`local_source` need their source/build origin reviewed separately.

Source checks passed for JAX GPU, CUDA bindings, compiled CUDA, PyTorch, CuPy,
nvmath/cuDSS, cuTENSOR, Flax, Diffrax, HDF5, local library imports, GPflow,
Dynamax, BayesNF, UQpy, PETSc/SLEPc, CHOLMOD and the existing numerical oracles.
These are focused checks, not full library regression suites.

Known exceptions to re-test against current releases:

- TensorStore 0.1.86 has no Python 3.15 wheel and its source build fails on removed
  `PyWeakref_GET_OBJECT` calls. Current upstream source also had those calls.
  `jax315` runs JAX GPU, Flax layers, Diffrax, HDF5 and local imports, but lacks
  TensorStore-dependent checkpointing. `jax314` Orbax save/restore passed.
  Do not repeatedly rebuild the same failing source or silently change Python.
- UQpy needed setuptools 80.9.0 for `pkg_resources`. Newer setuptools failed
  its import; keep this pin only while the installed UQpy still needs it.
- nvmath 1.0.0 rejected cuDSS 1.0 at runtime. cuDSS 0.8.0.10 passed a sparse solve.
- PETSc/SLEPc bindings use existing native 3.25 libraries. Match bindings to
  the target's native ABI; upgrading native libraries is a separate build.
- GPJax 1.0's Gaussian constructor no longer takes `num_datapoints`.
  scikit-sparse 0.5 uses `cho_factor(A).solve(b)`.
- TensorFlow/TFP nightly distributions were needed in the broad environment.
  Never coinstall stable and nightly distributions sharing an import namespace.
- Some published bounds disagree with successfully tested newer packages.
  Preserve the metadata and record exceptions; do not pretend `pip check` is clean.

## 1. Pull and inventory the target

In each existing checkout, save local changes before reconciliation. Use
`git status --short`, `git fetch origin`, and `git pull --ff-only origin main`
when fast-forwarding is possible. If divergent, preserve both sides and resolve
normally; do not use `reset --hard` or overwrite machine-local files.

In Windows PowerShell:

```powershell
hostname
Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion
Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory
wsl --version
wsl --list --verbose
nvidia-smi  # NVIDIA machines only
Get-Command python,python3,uv -All -ErrorAction SilentlyContinue
```

In the target's native WSL checkout (resolve through `~/.dotrepo` if present):

```bash
hostname
uname -m
cat /etc/os-release
free -h
df -h "$HOME"
ls -la ~/.virtualenvs
nvidia-smi --query-gpu=name,driver_version,compute_cap --format=csv  # NVIDIA only
```

Capture each environment's package inventory, Python version, editable source
origins, active jobs, current shell/editor selections and R library paths.
Keep credentials, SSH keys, licenses and sign-ins on their own machine.
Check Windows Update, WinGet, Store and vendor updaters separately. Update drivers
for the actual target GPU/OEM; do not reuse the source laptop's installer.
Do not reboot, shut down WSL or compact its disk while jobs are active.

## 2. Select the backend before installing GPU packages

As documented by [JAX](https://docs.jax.dev/en/latest/installation.html) on this date:

| Target hardware | Starting choice |
| --- | --- |
| NVIDIA SM 7.5 or newer, compatible driver | Latest supported `jax[cuda13]` and CUDA 13 toolkit/bindings |
| NVIDIA SM 5.2 through 7.4 | CUDA 12 JAX build while supported; CUDA 13 dropped these GPUs |
| No compatible NVIDIA GPU | CPU JAX; no CUDA packages needed for CPU execution |
| AMD GPU | Check AMD's exact GPU/WSL support matrix and JAX ROCm instructions; otherwise use CPU |
| Intel GPU under WSL | CPU baseline; the current JAX table does not list Intel GPU support in WSL |

Re-read the current compatibility tables when executing this handoff. JAX lists
Linux driver minima of 525 for CUDA 12 and 580 for CUDA 13; WSL needs the correct
Windows driver supporting the selected toolkit, not a Linux driver installation.
NVIDIA's [WSL guide](https://docs.nvidia.com/cuda/wsl-user-guide/index.html) says to
use the Windows display driver and **not install Linux display-driver packages
inside WSL**. Use toolkit-only packages/wheels. Check current toolkit release
notes for its Windows driver requirements. `nvidia-smi`'s CUDA version is a driver
capability, not proof that NVCC or a matching toolkit is installed.

Size WSL RAM, swap, compilation concurrency and GPU memory behavior for this
machine. The source has 16 GB physical RAM and WSL limits of 8 GB RAM/8 GB swap;
those are observations, not settings to copy blindly. Use bounded native builds,
keep `XLA_PYTHON_CLIENT_PREALLOCATE=false`, and avoid parallel GPU test discovery.

## 3. Build fresh candidates with current packages

Update `uv` by its original installation method. Inspect `uv python list
--all-versions` and select the latest verified patch releases of 3.14 and 3.15.
Install explicit patch versions so existing interpreter paths remain intact.
For example, substitute newer values where available:

```bash
PY314=3.14.10
PY315=3.15.2
uv python install "$PY314" "$PY315"
JAX_SPEC='jax[cuda13]'  # Change to jax[cuda12] or jax after the hardware check.
stamp=$(date +%Y%m%d)
for name in py314 jax314 jax315; do
  version=$PY314
  [ "$name" != jax315 ] || version=$PY315
  candidate="$HOME/.virtualenvs/$name-candidate-$stamp"
  [ ! -e "$candidate" ] || { echo "Already exists: $candidate" >&2; exit 1; }
  uv venv --python "$version" --seed "$candidate"
  uv pip install --python "$candidate/bin/python" --upgrade "$JAX_SPEC" numpy scipy
 done
```

Add the full selected toolkit/compiler and bindings, not only JAX's runtime.
For a verified CUDA 13 target, the pip route is `cuda-toolkit[all]>=13,<14` plus
`cuda-bindings>=13,<14`; select a compatible minor and recheck JAX afterwards.
For CUDA 12, use the current NVIDIA toolkit-only installation route and matching
bindings. Native Windows JAX remains CPU; GPU validation belongs in WSL.

Populate `jax314` from the target's `jax313` inventory plus the production package
checklist. Populate `py314` from the union of general and oracle inventories,
including the source checklist above. Add NumPy/SciPy/JAX ecosystem, notebooks,
R bridges and development tools. Keep `jax315` as a distinct research candidate.
Install the local arbPlusJAX, IntegralFunctionsJAX, RandomFields77 and TopoSmplJAX
checkouts as editable packages using target-local paths.

Try current releases and real operations before concluding that an old metadata
bound means a package cannot run. In a disposable candidate, a deliberate
`--no-deps` install can test a bound without downgrading the scientific core;
then inventory missing dependencies and test them explicitly. Use
`--ignore-requires-python` only for reviewed source/pure-Python candidates, never
to disguise an incompatible compiled wheel. Do not run a blanket no-dependency
install and assume the result is usable. Save each failed build once with its
error; do not keep repeating TensorStore's known Python 3.15 failure.

Retain native R/toolchains in WSL. Build PETSc/SLEPc, CHOLMOD and other native
bindings against the target's actual libraries. Source builds may need compilers,
headers and development packages. Do not copy virtualenv directories or native
binaries from the source machine.

## 4. Validate, then make the candidates default

Record `uv pip check --python ...` separately from runtime results. The new
core probe does not stop at old package metadata bounds:

```bash
# Activate one candidate at a time. Use project resource guards when applicable.
python ~/.dotrepo/scripts/check-python-core.py --require-gpu --output /tmp/core.json
python ~/.dotrepo/scripts/check-gpu-stack.py --output /tmp/gpu.json
# For a CPU target, omit --require-gpu and skip the NVIDIA GPU-stack probe.
```

Run JAX JIT/gradients, CUDA bindings, NVCC compilation, NumPy/SciPy, Flax/Diffrax,
local library imports and a checkpoint save/restore. In `py314`, also test PyTorch,
CuPy, nvmath, GPflow, UQpy and the numerical oracle suites. Existing helpers include
`check-gpflow-environment.py`, `check-m-tier-python.py PACKAGE`, and the R probes.
Do not treat the older `check-jax-environment.py` as authoritative for this pass:
it stops on metadata conflicts and contains an old `common` import name.

Do not rename a prefix used by active jobs. Once idle, preserve any previous
canonical environment under a dated name, repair its absolute activation/launcher
paths if moved, verify it still starts, and promote the candidate to the requested
canonical name. Symlinks to versioned new environments are acceptable. Never
remove old environments as part of this handoff.

Apply the shared shell and VS Code settings after promotion. Fresh shells should
select `py314`; `jaxenv` selects production and `jaxenv 315` selects research.
Set `DOTREPO_CUDA_HOME` in `~/.config/dotrepo/shell.local.sh` for a CUDA 12 or system
toolkit path; the shared helper otherwise detects pip CUDA 13. Review old local
exports/functions that might still force `py313` or the previous CUDA root.
Verify `UV_PYTHON`, `IFJ_PYTHON`, `ARBPLUSJAX_PYTHON`, and `RETICULATE_PYTHON`.
Register separate Jupyter kernels using each environment's `python -m ipykernel
install --user --name NAME --display-name LABEL`.

VS Code's remembered interpreter needs API readback, not just a settings edit.
The migration extensions select the new environment once per workspace, then
allow manual choices. Build both with the standard-library packager:

```powershell
python vscode/windows-python-default/package.py reports/windows-python-default.vsix
python vscode/windows-python-default/package.py reports/wsl-python-default.vsix --source vscode/wsl-python-default
```

Install the Windows VSIX in native VS Code. Install the WSL VSIX using the running
WSL server's `bin/code-server --install-extension /path/to/wsl-python-default.vsix
--force`, then check the remote extension inventory and receipt under
`~/.local/state/dotrepo/wsl-python-default`. A Windows `code --remote ...
--install-extension` invocation alone did not prove a remote install here.

For native Windows, the Python helpers currently reproduce the pinned source
baseline. Review/update `requirements-py314.txt` and its Python patch selection
for a newer target baseline before using them; preserve existing `py314` first.
Do not replay the historical September inventory's Windows R installations.

## 5. Tidy the target and return evidence

Move supporting software before deleting anything. Repair `~/.dotrepo`, shell,
SSH and Git symlinks, editor folders, editable-package paths, service units and
R fallback paths. Keep compatibility links where running/native tools require
old absolute paths. Use Git worktree removal for recognized old production
worktrees; disable obsolete services that reference them. Inspect target-local
contents instead of replaying this machine's deletion list.

Remove identified stale installers, disposable build caches and obsolete migration
files. Preserve research outputs, credentials, current source trees and all old
environments. Check R's complete library visibility after moves. Never delete
registered WSL distributions merely because they appear in an inventory; Ubuntu
and Docker's distribution are both needed on this source machine.

On the source, bulk Windows Temp deletion was blocked by automatic review even
after user approval. Only fixed, identified installer copies were removed. Do not
claim that blocked cleanup succeeded or bypass the restriction. Offline WSL VHD
compaction remains deferred until jobs can close; trimming inside WSL is distinct
from shrinking the Windows virtual-disk file.

Return the target hostname, GPU/driver, chosen backend and toolkit, Python/package
versions, default interpreter readbacks, numerical/GPU/checkpoint results,
remaining metadata/runtime exceptions, retained environment list, cleanup receipt
and pending reboot status. Explicitly distinguish target results from this source
baseline. No automatic reboot, unrelated repository push, or credential copying.
