# PhilipSecond WSL software and matrix/operator comparison setup

This report describes the source machine's Ubuntu 24.04 WSL installation.
It does not establish parity with the other computer; the committed inventory
is the source for reconstructing and checking that target.

## Structures and libraries

| Structure or operation | Available comparison implementations |
| --- | --- |
| Dense real/complex matrices, SPD solves and factorizations | NumPy/SciPy, JAX, PyTorch in jax-native, Eigen, Armadillo, LAPACKE/OpenBLAS, R Matrix, MATLAB, Mathematica |
| CSR, CSC, COO, BSR and diagonal sparse formats | SciPy; JAX sparse in jax-native; SuiteSparse; R Matrix; MATLAB |
| Matrix-free products, adjoints and composed operators | SciPy LinearOperator, PyLops; Lineax, Matfree and Traceax in jax-native |
| Toeplitz and Kronecker structure | SciPy, NumPy, TensorLy, MATLAB and Mathematica |
| Multigrid hierarchies and sparse PDE systems | PyAMG; scikit-fem in jax-native |
| Sparse tensors, matricization and tensor decompositions | PyData/Sparse and TensorLy |
| Exact integer/rational and symbolic matrices | FLINT/python-flint, SymPy, Mathematica |
| Arbitrary precision and interval/ball matrices | mpmath and FLINT/Arb; local arbPlusJAX project in jax-native |
| Partial eigenvalues, matrix exponentials and pseudoinverses | SciPy; R RSpectra, expm and pracma; MATLAB and Mathematica |
| Graphs, topology and geometric operators | PyGSP, TopoNetX, XGI, geometric_kernels and local TopoSMPLJAX in jax-native |

Availability is not a claim of equal precision, algorithms, GPU coverage or
toolbox entitlement. MATLAB's individual toolbox workloads remain untested.
The scripts below check small equivalent calculations; they are not performance
benchmarks. Use matched dimensions, dtype/precision, tolerances, thread counts,
device, warmup and GPU synchronization when doing timing comparisons.

## Software audit and updates

- Refreshed APT indexes: no pending upgrades from configured Ubuntu/CRAN,
  Microsoft, GitHub or Google repositories. No Snap applications were found.
- Added LAPACKE development libraries. Existing Eigen 3.4.0, Armadillo 12.6.7,
  OpenBLAS 0.3.26, SuiteSparse 7.6.1, native FLINT 3.0.1, MPFR 4.2.1 and
  FFTW 3.3.10 are distribution-managed versions; these are not claims of the
  newest upstream release.
- Updated native npm to 12.0.2 and Corepack to 0.36.0, compatible with Node
  24.20.0. Native uv 0.12.10 was already current on PyPI.
- Claude 2.1.263, Codex 0.153.4, Gemini 0.58.0 and Google Cloud CLI 583.0.0
  launch; their checked package sources offered no updates. The remote WSL
  VS Code extension update command reported no extensions to update.
- R 4.6.1's visible installed packages were current. Added RSpectra 0.16.2,
  expm 1.0.1 and pracma 2.4.6. Matrix is 1.7.6, RcppEigen 0.3.4.0.2 and
  RcppArmadillo 15.4.2.1.
- MATLAB R2026a Update 5 and Mathematica 15.0.1 were already installed and
  activated, with their recorded kernel checks passing. TeX Live remains
  Ubuntu's maintained 2023 distribution installation.

## Running experiments and Python environment boundaries

A Miniforge-base experiment was running at audit time. Additional experiments
started in py313 while the upgrade was downloading. The py313 updater was
stopped before package replacement; its full package name/version inventory
was verified unchanged, and pip check still passed in py313 and jax-native.
The updated comparison stack is installed separately in
`~/.virtualenvs/matrix-compare` with ordinary CPython 3.13.15 and 165 packages.
It includes JAX/jaxlib/CUDA plugin 0.11.1, NumPy 2.5.3, SciPy 1.18.1,
python-flint 0.9.0, PyLops 2.8.0, PyAMG 5.3.0, Sparse 0.19.2 and TensorLy
0.9.0. Dependency-compatible versions are captured rather than claiming every
transitive dependency is independently at its newest release.

Select **Python (Matrix comparisons, JAX GPU)** in Jupyter/VS Code or activate
with `source ~/.virtualenvs/matrix-compare/bin/activate`. The kernel executed
a GPU calculation successfully. This does not change existing shell defaults.

| Location | Contents and purpose |
| --- | --- |
| `~/.virtualenvs/matrix-compare` | CPython 3.13.15; 165 packages; updated matrix/operator comparison stack |
| `~/.virtualenvs/py313` | CPython 3.13.15; 139 packages; existing default and active experiments |
| `~/.virtualenvs/jax-native` | CPython 3.12.13; 293 packages; established JAX/PyTorch, geometry and local scientific projects |
| `~/.virtualenvs/jax` | CPython 3.12.3; 179 packages; legacy statistics environment with documented conflicts |
| `~/miniforge3` | Retained Conda base, 317 packages; active experiment |
| `~/.local/lib/R/site-library` | User R libraries; 283 unique packages visible across R library paths |
| `/usr/include` and `/usr/lib/x86_64-linux-gnu` | Distribution-managed native matrix libraries and headers |
| `~/.local/opt/MATLAB/R2026a` | Licensed MATLAB and installed toolbox suite |
| `/usr/local/Wolfram/Wolfram/15.0` | Licensed Mathematica 15.0.1; 14.3 retained separately |
| `/usr/share/Wolfram/Documentation/15.0` | Local Mathematica documentation |
| `~/.local/nodejs/current`, `~/.local/bin` | Native Node/npm, AI CLI tools and application launchers |
| `~/.local/share/jupyter/kernels/matrix-compare` | New comparison notebook kernel |

The existing py313 and jax-native environments retain their validated package
sets rather than being modified under running experiments. Miniforge base and
the older statistics virtualenv remain subject to the migration limitations in
[the native Python report](wsl-native-python-2026-09-07.md). Their updates and
removal are deferred, not reported as completed.

## Checks and reproduction

- `scripts/check-native-matrices.cpp`: compiled Eigen/Armadillo/LAPACKE solves
  agree to a 1e-12 tolerance.
- `scripts/check-r-matrices.R`: dense/sparse solve, partial eigenspectrum,
  matrix exponential and pseudoinverse checks passed.
- MATLAB: dense/sparse solve and matrix-free conjugate gradient passed.
- Mathematica 15.0.1: exact dense/sparse solve and Kronecker structure passed.
- `scripts/check-matrix-operators.py`: all 13 groups passed, including GPU
  float64 solve/gradient, Lineax GPU solve and SuiteSparse CHOLMOD.
  [Machine-readable results](../machines/source-2026-09-07/wsl-native/matrix-comparison-checks.json).

```bash
g++ -O2 -I/usr/include/eigen3 scripts/check-native-matrices.cpp \
  -larmadillo -llapacke -o /tmp/check-native-matrices
/tmp/check-native-matrices
Rscript scripts/check-r-matrices.R
~/.virtualenvs/matrix-compare/bin/python scripts/check-matrix-operators.py
```

Recreate the new environment on the target after installing the native
dependencies from the refreshed `wsl-native/apt-manual.txt` inventory:

```bash
uv python install 3.13.15
uv venv --seed --python 3.13.15 ~/.virtualenvs/matrix-compare
uv pip install --python ~/.virtualenvs/matrix-compare/bin/python \
  -r machines/source-2026-09-07/wsl-native/standard-python/matrix-compare-requirements.txt \
  --build-constraints machines/source-2026-09-07/wsl-native/standard-python/build-constraints.txt
~/.virtualenvs/matrix-compare/bin/python -m ipykernel install --user \
  --name matrix-compare --display-name 'Python (Matrix comparisons, JAX GPU)'
```

The capture now records 1,356 installed Ubuntu packages, 156 manually selected
APT packages, four standard virtualenvs and the retained Conda base. Raw package
versions, structures and checks are committed; installers, caches, credentials
and license files are excluded. The existing arbPlusJAX reverse-differentiation
failure and legacy statistics environment conflicts remain as previously
documented; no scientific project source was changed in this update.

References: [SciPy LinearOperator](https://docs.scipy.org/doc/scipy/reference/generated/scipy.sparse.linalg.LinearOperator.html),
[PyLops](https://github.com/PyLops/pylops), [PyAMG](https://github.com/pyamg/pyamg).
