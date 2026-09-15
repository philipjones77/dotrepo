# RF77 R, GS-LVMOGP, GPflow and native MRA oracles

Verified on **PC-PHILIP-WINDOWS / Ubuntu WSL**, extending the
[repository oracle audit](repo-oracles-2026-09-14.md). These are installation
and bounded runtime checks, not a full statistical validation of every adapter.

## Results

| Component | Result |
| --- | --- |
| R reference packages | All 59 packages found in the RF77 audit load from `py313`-launched R. |
| R additions | 18 new packages; 516 active packages total. All 498 previous package versions were preserved. |
| deepspat 0.3.2 | A 12-point nonstationary GP with two axial-warp layers completed one step per optimization phase through `py313` TensorFlow 2.21.0; finite cost and warped coordinates. |
| autoFRK 1.4.4 | Spatial rank selection completed for 50 observations; finite 50-by-47 basis. |
| CVXR 1.9.2 | Clarabel solved a constrained quadratic with the known solution `(1, 0)`. |
| loggle 1.0 | Likelihood, pseudo-likelihood and sparse partial-correlation modes completed with model refitting; all nine resulting precision matrices were symmetric positive definite. |
| GS-LVMOGP | The existing RF77 adapter completed an eight-row, two-output fit and two held-out predictions in main `py313`. |
| GPflow irregular / W02 | Five bounded RF77 tests passed following the compatibility fix in commit `7c44d474f`. The 200-step optimization case was deselected. |
| Native serial MRA | Installed executable completed likelihood and prediction with both two and three levels, 24 observations and four held-out locations. RF77's adapter protocol still needs reconciliation. |

Receipts: [R](../machines/pc-philip-windows-2026-09-14/repo-oracles/rf77-r.json),
[GS-LVMOGP](../machines/pc-philip-windows-2026-09-14/repo-oracles/rf77-gs-lvmogp.json),
[W02](../machines/pc-philip-windows-2026-09-14/repo-oracles/rf77-w02.json),
and [MRA](../machines/pc-philip-windows-2026-09-14/repo-oracles/rf77-mra.json).

The new R packages are `CVXR`, `SpatialExtremes`, `autoFRK`, `clarabel`,
`config`, `deepspat`, `filehash`, `filehashSQLite`, `filematrix`, `here`,
`keras`, `loggle`, `reticulate`, `tensorflow`, `tfautograph`, `tfprobability`,
`tfruns` and `zeallot`. Their exact versions are in the R receipt.
The R `tensorflow` package is version 2.20.0; the Python TensorFlow runtime
it invokes is version 2.21.0.

## Recheck the active R installation

Run from the dotrepo checkout with ordinary R startup so its configured user
libraries are visible. Selecting the existing Python interpreter prevents
reticulate from creating another Python environment.

```bash
RETICULATE_PYTHON="$HOME/.virtualenvs/py313/bin/python" \
RETICULATE_USE_MANAGED_VENV=no CUDA_VISIBLE_DEVICES=-1 JAX_PLATFORMS=cpu \
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 \
TF_NUM_INTRAOP_THREADS=1 TF_NUM_INTEROP_THREADS=1 \
  Rscript scripts/check-rf77-r-oracles.R --output /tmp/rf77-r-check.json
```

On another machine, first follow the [cross-machine handoff](ai/sessions/2026-09-14-python-oracle-wsl-handoff.md).
Resolve missing `deepspat`, `autoFRK` and `CVXR` dependencies in a separate R
library, compare its transaction with the target's existing versions, and run
the checks with that library first on `.libPaths()`. This machine promoted only
new package directories after the staged checks passed.

### loggle build compatibility

`loggle` was built from
[upstream commit bf3cf905](https://github.com/jlyang1990/loggle/commit/bf3cf9052f1fb762ac07f1ffd899f5ed7137cf55).
Its older C source required explicit R `FCONE` character-length arguments at
eight BLAS/LAPACK calls to compile with the installed R 4.6.1 headers.
The [recorded patch](../wsl/oracle-builds/loggle-r46.patch) changes those call
signatures; the numerical formulas stay the same.

From a dotrepo checkout, using a new staging directory:

```bash
set -euo pipefail
dotrepo_root="$PWD"
rf77_stage="$HOME/.local/state/dotrepo/rf77-r-rebuild"
mkdir -p "$rf77_stage/library"
git clone https://github.com/jlyang1990/loggle.git "$rf77_stage/loggle-source"
git -C "$rf77_stage/loggle-source" checkout --detach bf3cf9052f1fb762ac07f1ffd899f5ed7137cf55
git -C "$rf77_stage/loggle-source" apply "$dotrepo_root/wsl/oracle-builds/loggle-r46.patch"
R CMD INSTALL --library="$rf77_stage/library" "$rf77_stage/loggle-source"
```

The existing R dependencies must be visible to that R process. Run the portable
check with the stage added to `.libPaths()` before promotion; `--packages loggle`
selects the three loggle modes alone.

## Rebuild the GS-LVMOGP wheel

The [official source](https://github.com/XiaoyuJiang17/GS-LVMOGP/commit/541d49aaf0191a705441109371e5650c5a1c88c3)
contains two Python modules without packaging metadata. The local distribution
`gs-lvmogp-oracle` packages unchanged `LVMOGP.py` and `IndepMOGP.py`, together
with the upstream license. It is not a package to request from PyPI.

The [rebuild helper](../scripts/build-gs-lvmogp-wheel.py) checks the pinned source
commit, clean checkout and all source file hashes. It also checks both module
hashes inside the resulting wheel. Wheel archive hashes can vary between builds
because of archive metadata; the receipt's wheel hash identifies the originally
installed artifact.

```bash
GS_LVMOGP_WHEEL="$(python3 scripts/build-gs-lvmogp-wheel.py \
  --python "$HOME/.virtualenvs/py313/bin/python" \
  --workdir "$HOME/.local/state/dotrepo/gs-lvmogp-rebuild")"
export GS_LVMOGP_WHEEL
uv pip install --dry-run --python "$HOME/.virtualenvs/py313/bin/python" "$GS_LVMOGP_WHEEL"
# Apply the resolved local wheel alongside the target's preserved package pins.
```

The build uses the selected interpreter's existing setuptools and wheel. It
does not install dependencies or install its output. The distribution declares
`torch`, `gpytorch` and `linear_operator` as runtime dependencies. On this
machine, the functional check used PyTorch 2.14.0 and GPyTorch 1.15.2.

## Native serial MRA

The installed command is `~/.local/bin/mra-serial`, linked to
`~/.local/opt/mra-serial-20260914/bin/MRA`. Its template is stored under that
prefix's `share/user_parameters.template`. `ldd -r` found no missing libraries
or unresolved symbols.

The source is
[hhuang90/MRA_For_NCAR_Technical_Note, commit 438ef95e](https://github.com/hhuang90/MRA_For_NCAR_Technical_Note/commit/438ef95ea30b68bb3750814faa5b3e5e6a78c64b).
The build uses the installed Armadillo, dlib, OpenBLAS and LAPACKE development
libraries, with two explicit compatibility adjustments:

- A [small header](../wsl/oracle-builds/mra-openblas-mkl.h) maps the upstream MKL
  calls to standard CBLAS and column-major LAPACKE.
- A [one-line patch](../wsl/oracle-builds/mra-armadillo-copy.patch) uses an owned
  work-vector copy instead of moving an Armadillo borrowed view. The original
  source computed a finite likelihood but threw during cleanup with the current
  Armadillo version. The patch preserves numerical formulas and keeps Armadillo
  checks enabled.

Rebuild in a new directory, from the dotrepo checkout:

```bash
set -euo pipefail
dotrepo_root="$PWD"
mra_stage="$HOME/.local/state/dotrepo/mra-serial-rebuild"
mkdir -p "$mra_stage/include"
git clone https://github.com/hhuang90/MRA_For_NCAR_Technical_Note.git "$mra_stage/source"
git -C "$mra_stage/source" checkout --detach 438ef95ea30b68bb3750814faa5b3e5e6a78c64b
git -C "$mra_stage/source" apply "$dotrepo_root/wsl/oracle-builds/mra-armadillo-copy.patch"
cp "$dotrepo_root/wsl/oracle-builds/mra-openblas-mkl.h" "$mra_stage/include/mkl.h"
mkdir -p "$mra_stage/source/serial_MRA/obj"
make -j1 -C "$mra_stage/source/serial_MRA" CXX=g++ \
  "mklIncPath=$mra_stage/include" 'mklLib=lapacke -lopenblas' MRA
"$HOME/.virtualenvs/py313/bin/python" scripts/check-mra-environment.py \
  --binary "$mra_stage/source/serial_MRA/MRA" \
  --template "$mra_stage/source/serial_MRA/user_parameters"
```

For the installed executable:

```bash
"$HOME/.virtualenvs/py313/bin/python" scripts/check-mra-environment.py \
  --binary "$HOME/.local/bin/mra-serial" --output /tmp/mra-check.json
```

**Remaining RF77 adapter limitation:** its bridge writes different prediction
configuration keys, expects separate mean/variance files, and defaults to
optimization mode. The official program uses a combined count-prefixed
x/y/mean/variance output and a separate prediction mode. Installing the binary
does not resolve that bridge protocol. The standalone command is usable from
`py313` through a subprocess; the checker exercises that path.
