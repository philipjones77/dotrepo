# Repository oracle installation audit

This follow-up covers the actual IFJ, RF77, TopoSmplJAX and data77 oracle
registries, extras and comparison tests on **PC-PHILIP-WINDOWS / Ubuntu WSL**.
It extends the [34-package M-tier audit](wsl-m-tier-oracles-2026-09-14.md).
Package installation, successful numerical execution and a working repository
adapter are recorded separately.

Final inventories contain **338 main Python packages, 516 active R packages
and 1,559 Ubuntu packages**. This follow-up added 13 main Python packages and
18 R packages without changing any of the previous 325 Python or 498 R package
versions. All six active Python environments pass dependency checks.

## Environments

| Environment | Purpose |
| --- | --- |
| `~/.virtualenvs/py313` | Shared CPython 3.13.15; existing NumPy 2.5.3, SciPy 1.18.1, JAX 0.11.1, Flax 0.12.9 and GPflow 2.9.2 retained. |
| `~/.virtualenvs/jax-oracles313` | CPython 3.13.15, JAX 0.6.2, Flax 0.10.7, TFP 0.25.0 and SciPy 1.16.3 for Dynamax 1.0.1, BayesNF 0.1.3 and PyGAM 0.12.0. |
| `~/.virtualenvs/uqpy312` | CPython 3.12.3, NumPy 1.26.4, CPU PyTorch 2.2.2 and setuptools 80.9.0 for UQpy 4.2.1 and Debiased Spatial Whittle 2.2.0. |
| Ordinary R startup | Existing configured R user library plus added R oracle packages. |
| User-local Julia | Julia 1.13.0 for `@repo-oracles`, and Julia 1.10.12 for `@repo-oracles-oilmm`; Julia packages use their own environments. |

Some published dependencies cannot share the retained main stack. UQpy pins
NumPy 1.26.4 and PyTorch 2.2; Whittle requires NumPy below 2; PyGAM requires
SciPy below 1.17. Dynamax 1.0.1 and BayesNF fail with the main environment's
JAX because stable TFP accesses a removed JAX API. Dynamax 1.0.2 instead
requires `tfp-nightly`, which shares module files with GPflow's stable TFP.
The companion environments avoid conflicting installations. See the official
[Dynamax dependencies](https://github.com/probml/dynamax/blob/main/pyproject.toml),
[UQpy release](https://pypi.org/project/UQpy/), and
[PyGAM release](https://pypi.org/project/pygam/).

## Additional packages in the main py313 environment

| Package | Version | Repository use |
| --- | --- | --- |
| fftlog-lss | 0.1.2 | IFJ's external spherical FFTLog parity suite |
| hankl | 1.1.0 | Independent Hankel / cosmology Fourier transforms |
| finufft | 2.5.1 | RF77 nonuniform Fourier reference |
| pynufft | 2025.2.1 | RF77 nonuniform Fourier reference |
| torchquad | 0.6.0 | IFJ quadrature comparison reference |
| cubature | 0.18.8 | IFJ cubature comparison reference |
| scoringrules | 0.11.0 | RF77 independent scoring-rule reference |
| pyfmaps | 1.3.0 | Topo functional maps; import name `pyFM` |
| smplx | 0.1.28 | Topo upstream SMPL family reference |
| gmsh | 4.15.2 | Topo mesher reference; Python bindings and executable |
| gs-lvmogp-oracle | 0.0.0+541d49aaf019 | Locally packaged, unchanged GS-LVMOGP reference modules |
| autoray / loguru | 0.11.0 / 0.7.3 | Dependencies of the added quadrature packages |

GS-LVMOGP upstream has no package metadata. The local wheel contains its
unchanged `LVMOGP.py` and `IndepMOGP.py`, license and source provenance, from
[upstream commit 541d49a](https://github.com/XiaoyuJiang17/GS-LVMOGP/commit/541d49aaf0191a705441109371e5650c5a1c88c3).
It must be rebuilt from that source on another machine; its local package name
is not a PyPI package. The receipt records module and wheel hashes.

## Repository checks and fixes

### IntegralFunctionsJAX

Fast-forwarded `main` from `a35fef0` to `611ac9b` at the user's request. Three
untracked communication files collided with incoming tracked files; they were
backed up and proved byte-identical before the pull. Other local assets were
preserved. The new quadrature tests do not add mandatory Python dependencies.

The existing lightweight registry, GPL, MB adapter-contract, Quadax and BRASIL
checks passed (29 tests). After installing FFTLog, all six external FFTLog
parity tests passed. Independent Gaussian transforms, Simpson integration and
two-dimensional polynomial cubature also passed. Wolfram's Gamma, BesselJ and
MeijerG evaluations passed on a bounded retry; the first availability probe
returned false without preserving its underlying exception.

The `boost_math` registry entry is a future Python harness, even though native
Boost is installed. The GiNaC / PolyLogTools slot needs a caller-registered
evaluator. A learned-contour oracle needs a trained, validated artifact.
Installing libraries alone does not complete those integrations.
The [IFJ/Julia runbook](repo-oracles-ifj-2026-09-14.md) includes Mathematica,
GiNaC, PolyLogTools, TOPCOM and pinned Julia projects.

### RandomFields77

The existing GS-LVMOGP adapter passed an eight-row, two-output fit and held-out
prediction against the staged wheel. All four existing UQpy DirectPOD tests
passed through `RF77_UQPY_PYTHON`, including exact eigendecomposition parity and
the canonical Matérn covariance case.

The GPflow irregular oracle had an obsolete blanket NumPy 2 rejection and
read the removed `ObservationSpec.variance` attribute. The adapter now checks
actual GPflow/TensorFlow availability and uses the current observation-noise
accessor. Its test fixtures use the current `noise_params` interface.
Five bounded GPflow tests passed; the long optimization case was deselected.
The fix was committed and pushed as
[`7c44d474`](https://github.com/philipjones77/RandomFields77/commit/7c44d474f).
The user's pre-existing kernel registry changes were preserved outside that commit.

Whittle and BayesNF currently have in-process import gates; installing a
companion environment does not make those gates true in main `py313`.
RF77's MRA bridge also has a protocol mismatch with the official serial
reference's configuration and combined binary prediction output. A working
standalone binary does not imply a working RF77 MRA adapter.
All 59 R packages referenced by RF77 load; deepspat, autoFRK, CVXR and loggle
passed numerical checks. Native MRA passed likelihood and prediction at two
and three levels. The [RF77 runbook](repo-oracles-rf77-2026-09-14.md) records
the exact sources, build patches, checks and replication commands.

### TopoSmplJAX

All 13 declared oracle-extra distributions were already present. The audit
added pyFM, SMPL-X and Gmsh. Selected geometry/topology tests produced 30 passes,
two skips and one expected failure for documented geomstats limitations.
Gephi Toolkit 0.10.1 and a JDK were installed; all five Gephi integration tests
passed, including layout and PDF/SVG/GEXF export.

Existing licensed model assets were located locally. Asset content is excluded
from this repository and from the shared inventory.
Five added pyFM/Gmsh checks passed. Neutral SMPL and SMPL-X forward evaluations
matched the official `smplx` package: maximum vertex errors were below
`3.6e-7` for 6,890 and 10,475 vertices respectively. These checks used a private
reversible format view of the existing assets, preserving the originals.
See the [Topo runbook](repo-oracles-topo-2026-09-14.md) for Gephi installation,
checks and local model-path setup.

### data77

All four declared oracle-extra dependencies were already installed. Seven
oracle modules placed the oracle marker before a `__future__` import, causing
SyntaxError. The marker now follows that import. A comparison dependency also
used `os.environ` before importing `os`; initialization now follows standard
library imports and still precedes JAX initialization.

The seven oracle modules import successfully. Real bounded GPyTorch exact-GP,
GPBoost Vecchia and Pyro variational fits, plus scikit-learn held-out prediction,
passed. No production datasets were downloaded or production fits launched.
The import fixes were committed and pushed as
[`6e96b361`](https://github.com/philipjones77/data77/commit/6e96b361).

## Julia references and limits

Julia 1.13.0 was downloaded from the official
[Julia release service](https://julialang.org/downloads/manual-downloads/).
The Linux x86-64 archive SHA256 was verified as
`8975da61c128a5e5ded3e719e868da8c8781deb7ad7913d37fb99be02a81904b`.

IFJ has a real MeijerG subprocess adapter. FastGaussQuadrature, Integrals and
Cuba are reference packages mentioned in quadrature plans. RF77 mentions
TemporalGPs, Vecchia and OILMMs as reference or planned integrations, with no
Julia runtime adapter in the audited tree. Those distinctions remain relevant
even when the Julia packages are installed.

RF77's cited `JuliaStats/GraphicalModels.jl` repository and project metadata
return 404, and no matching General registry package was found. A different,
unmaintained repository with the same short name was not substituted.

MeijerG's default shifted-Bessel reduction failed an independent identity;
the explicit Slater route passed. The [IFJ/Julia runbook](repo-oracles-ifj-2026-09-14.md)
records the failing values, usable checks and complete environment manifests.

## Replication

The [GPU guide](repo-oracles-gpu-2026-09-14.md) records exact JAX 0.11.1,
CUDA wheel/runtime/compiler versions and Windows driver 616.56. JAX GPU values
and gradients passed. The [companion guide](repo-oracles-companions-2026-09-14.md)
covers the separate compatibility environments and their exact pins.

Use the final machine inventory and receipts accompanying this report. Pull
the documented repository fixes as well as dotrepo: package installation does
not deliver source fixes in another repository. Keep manual-source packages,
Julia project manifests, native binary recipes and licensed model paths separate
from ordinary PyPI pins. Run the numerical probes after restoring each environment.

The other machine was not remotely modified. The cross-machine handoff is the
committed [session document](ai/sessions/2026-09-14-python-oracle-wsl-handoff.md).
