# M-tier oracle installation and checks, September 14

Machine: **PC-PHILIP-WINDOWS**, Ubuntu 24.04.4 under WSL 2.

This is the earlier 34-oracle installation stage. The subsequent
[four-repository audit](repo-oracles-2026-09-14.md) extends coverage and brings
the final inventory to 338 py313 packages, 516 active R packages and 1,559
Ubuntu packages. Counts below describe this earlier stage.

**All 34 requested oracles are installed and passed functional smoke checks:**
22 in `py313`, 11 in R, and native ExaGeoStat.

The [requested checklist](../config/m-tier-oracles.json) records all 34 package
names and the citation identifiers supplied by the user. The results below
describe installed software and small functional tests. They do not assess
statistical convergence, production performance, every API, or bibliography metadata.

## Package results

| Oracle | Environment | Version | Action | Functional check |
| --- | --- | --- | --- | --- |
| scikit-learn | py313 | 1.9.0 | Already present | Passed |
| gpytorch | py313 | 1.15.2 | Already present | Passed |
| linear_operator | py313 | 0.6.1 | Already present | Passed |
| gpboost | py313 | 1.7.4 | Already present | Passed |
| pymc | py313 | 6.3.1 | Already present | Passed |
| numpyro | py313 | 0.21.0 | Already present | Passed |
| blackjax | py313 | 1.6.2 | Already present | Passed |
| pyro-ppl | py313 | 1.9.1 | Already present | Passed |
| gpflow | py313 | 2.9.2 | Installed earlier this session | Passed |
| gpjax | py313 | 0.13.6 | Installed | Passed |
| stheno | py313 | 1.4.2 | Installed | Passed |
| tinygp | py313 | 0.3.1 | Already present | Passed |
| GPy | py313 | 1.14.2 | Already present | Passed |
| celerite2 | py313 | 0.3.3 | Installed | Passed |
| george | py313 | 0.4.4 | Installed | Passed |
| PyKrige | py313 | 1.7.3 | Installed | Passed |
| scikit-gstat | py313 | 1.0.23 | Installed | Passed |
| gstools | py313 | 1.7.0 | Installed | Passed |
| verde | py313 | 1.9.0 | Installed | Passed |
| botorch | py313 | 0.18.1 | Installed | Passed |
| emukit | py313 | 0.5.1 | Installed | Passed |
| smt | py313 | 2.15.0 | Installed | Passed |
| gstat | R | 2.1-6 | Already present | Passed |
| spacetime | R | 1.3-4 | Already present | Passed |
| fields | R | 17.3 | Already present | Passed |
| geoR | R | 1.9-6 | Already present | Passed |
| spBayes | R | 0.4-9 | Installed | Passed |
| laGP | R | 1.5-10 | Installed | Passed |
| hetGP | R | 1.1.9 | Installed | Passed |
| GpGp | R | 1.0.0 | Already present | Passed |
| GPvecchia | R | 0.1.8 | Installed | Passed |
| inlabru | R | 2.15.0 | Already present | Passed |
| ExaGeoStat | WSL native | 2.0.0 | Installed | Passed |
| R-INLA | R | 25.10.19 | Already present | Passed |

## Python changes and compatibility

GPflow was added first, bringing `py313` from 262 to 283 packages. The complete
oracle pass added 11 further requested packages and their dependencies: 42 new
distributions, bringing the environment to **325 packages**. Only Flax changed
during that pass, from 0.12.8 to 0.12.9; no packages were removed.

Keep these locally tested combinations together:

- **GPJax 0.13.6 + Flax 0.12.9 + JAX 0.11.1.** The previous Flax version
  failed to import its NNX module with this JAX version. The newer GPJax 0.18
  release declares JAX below 0.11, so it was not selected.
- **GPflow 2.9.2 + TensorFlow 2.21.0 + TFP 0.25.0 + tf-keras 2.21.0 +
  setuptools 80.9.0.** GPflow 2.11.1 requires NumPy below 2; `py313` retains
  NumPy 2.5.3. The older GPflow needs the `pkg_resources` module supplied by
  setuptools 80.9.0. GPflow is CPU-tested; TensorFlow GPU libraries are unavailable.
- **scikit-sparse 0.4.16** remains installed. Algebra 1.2.1 needed an isolated
  source build using setuptools 80.9.0; other additions used package wheels.

The [build constraint](../python/wsl/m-tier-build-constraints.txt) preserves the
setuptools version used for Algebra's source build. Pass it with uv's
`--build-constraints` option when reconstructing the captured requirements.

The [Python receipt](../machines/pc-philip-windows-2026-09-14/python-m-tier-oracles.json)
records each operation, dependency checks, the full package delta, compatibility
sources and rollback evidence. Tests cover likelihoods, conditioned predictions,
gradients, kriging, variograms and small sampler transitions as appropriate.
Flax Linen and NNX values/gradients passed. The
[same-process JAX GPU / GPflow CPU check](../machines/pc-philip-windows-2026-09-14/gpflow-jax-coexistence.json)
also passed after the final Flax update.

## R changes

Installed **spBayes, laGP, hetGP and GPvecchia**, plus maptree, tgp, DiceDesign
and mco. Active packages increased from **490 to 498**. Every preexisting
package version was preserved. Ordinary startup selects the intended user
library; the separate vanilla-startup inventory sees only 72 packages.

The [R receipt](../machines/pc-philip-windows-2026-09-14/r-m-tier-oracles.json)
includes source archive URLs/hashes and exact checks. Tests compare kriging
and Vecchia likelihoods against dense calculations, exercise GP fitting and
prediction, and run actual INLA/inlabru native regression models.

## Native ExaGeoStat

Installed **ExaGeoStatCPP 2.0.0** with an exact CPU backend and a launcher at
`~/.local/bin/exageostat-cpu`. Its native library and headers are under
`~/.local/opt/exageostat-cpp-20260914/EXAGEOSTATCPP`.

The build required **Chameleon 1.1.0 and StarPU 1.3.10** in the user-local
prefix. Ubuntu's StarPU 1.4.3 did not compile with the required Chameleon version;
the matching local build preserves the system installation. APT gained 23
dependencies with no upgrades/removals, bringing the total to 1,546 installed
packages and 100 manual selections. The source checkout remains necessary for
upstream's embedded configuration/kernel paths.

The smoke test fit an exact Matérn model to 64 deterministic points and predicted
eight held-out values. Eight optimizer iterations completed with log likelihood
**-14.453839** and mean squared prediction error **0.0209**. These finite fit and
prediction checks cover the CPU installation; GPU, MPI and low-rank backends
were not validated. The [native receipt](../machines/pc-philip-windows-2026-09-14/exageostat-oracle.json)
records source revisions, dependencies, build details and linked-library checks.
Use the [pinned CPU build recipe](exageostat-wsl-2026-09-14.md) on the other
machine; it includes the pkg-config isolation and launcher setup needed to
reconstruct this installation.

## Reproduce and check on the other machine

Pull `main` in both native checkouts and follow the
[cross-machine handoff](ai/sessions/2026-09-14-python-oracle-wsl-handoff.md).
Preserve active jobs and before inventories. Reconcile a candidate environment
against the [current exact requirements and manual-source manifests](../machines/pc-philip-windows-2026-09-14/README.md)
before switching the target default. The four editable projects contain local
changes that a recorded commit alone cannot reproduce.

Run the committed checks from the native WSL checkout:

```bash
# One fresh CPU process per Python oracle; replace gpytorch with each Python
# install_name from config/m-tier-oracles.json.
CUDA_VISIBLE_DEVICES=-1 JAX_PLATFORMS=cpu \
  OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 \
  TF_NUM_INTRAOP_THREADS=1 TF_NUM_INTEROP_THREADS=1 \
  "$HOME/.virtualenvs/py313/bin/python" -I -B scripts/check-m-tier-python.py gpytorch
uv pip check --python "$HOME/.virtualenvs/py313/bin/python"

# Ordinary R startup uses the configured native user library.
Rscript scripts/check-r-m-tier-oracles.R

# Native ExaGeoStat CPU fit and held-out prediction.
python3 scripts/check-exageostat-environment.py
```

Package presence and dependency checks are distinct from the numerical checks.
The separate `jax313` and `jax314` environments still lack python-flint/diffrax;
the complete Python checklist was installed and tested in **py313**.
