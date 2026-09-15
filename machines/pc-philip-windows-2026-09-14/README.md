# PC-PHILIP-WINDOWS software inventory, September 14

Captured from Ubuntu 24.04.4 under WSL 2 on **PC-PHILIP-WINDOWS**. Earlier
reports shortened the hostname to PC-PHILIP-WINDO. Other machines have not
been inspected or changed in this session.

The final source inventory contains **338 py313 packages, 516 active R packages,
1,559 APT packages**, five active Python environments and two Julia oracle environments.
The five remaining Python environments passed dependency checks in the recorded
audit. GPflow remains in `py313`; the separate `gpflow312` environment was retired
at the user's request; see the [retirement receipt](repo-oracles/gpflow312-retirement.json).
Earlier GPflow312 receipts describe its historical state. Its former package pins
and source inventory remain available in Git history.
Read the
[cross-machine handoff](../../docs/ai/sessions/2026-09-14-python-oracle-wsl-handoff.md)
for exact reproduction steps after pulling GitHub.

## Current results and recipes

- [Four-repository audit](../../docs/repo-oracles-2026-09-14.md): IFJ, RF77,
  TopoSmplJAX and data77 packages, source fixes, numerical checks and limits.
- [GPU stack](gpu-stack.json) and [GPU guide](../../docs/repo-oracles-gpu-2026-09-14.md):
  exact JAX 0.11.1 / CUDA library and compiler pins, driver 616.56, loaded runtime
  evidence and GPU calculation/gradient check.
- [IFJ and Julia](../../docs/repo-oracles-ifj-2026-09-14.md): both Julia runtimes,
  Project/Manifest pairs, Mathematica sources, TOPCOM and GiNaC/PolyLogTools.
- [RF77](../../docs/repo-oracles-rf77-2026-09-14.md): R packages, GS-LVMOGP build,
  GPflow compatibility fix and native serial MRA build.
- [Topo](../../docs/repo-oracles-topo-2026-09-14.md): geometry, Gephi, Gmsh and
  SMPL reference checks using existing private assets.
- [Python companions](../../docs/repo-oracles-companions-2026-09-14.md): exact
  restoration commands for dependencies that need separate environments.
- [Original M-tier results](../../docs/wsl-m-tier-oracles-2026-09-14.md): all 34
  requested references passed at the earlier stage, including native ExaGeoStat.

## Inventory files

- [Environments](wsl-native/standard-python/environments.json): exact interpreter
  versions, unique package counts, metadata duplicates and dependency checks.
- `wsl-native/standard-python/*-packages.json`: installed package identities.
- `wsl-native/standard-python/*-requirements.txt`: exact ordinary package pins.
- `wsl-native/standard-python/*-manual-sources.json`: editable projects and the
  locally packaged GS-LVMOGP source, with sanitized identities and observed commits.
- [Python changes since September 7](wsl-native/standard-python/changes-since-2026-09-07.json).
- [APT inventory](wsl-native/apt-installed.json), [manual selections](wsl-native/apt-manual.txt),
  [active R packages](wsl-native/r-active-packages.tsv), and
  [capture summary](wsl-native/capture.json). No APT holds were present.
- [Native summary](native-summary.json): observed tools and reference builds;
  later additions are recorded by the repository receipts below.
- [Expanded Python checks](repo-oracles/python.json) and [data77](repo-oracles/data77.json).
- Fresh main-stack checks for [Dynamax/BayesNF/PyGAM](repo-oracles/jax-companion-main-compatibility.json)
  and [UQpy/Whittle](repo-oracles/uqpy-companion-main-compatibility.json) distinguish
  runtime failures from dependency constraints without changing installed packages.
- [Replication checks](repo-oracles/replication-validation.json): main resolver
  dry run, candidate preflight, shell compatibility and repository validation.
- `repo-oracles/`: IFJ/Julia, RF77, Topo, Gephi and companion receipts, with
  exact sources, checks, build patches and limitations.

Earlier stage receipts remain as evidence at their recorded capture time:
[general oracle checks](oracle-checks.json),
[Python M-tier](python-m-tier-oracles.json), [R M-tier](r-m-tier-oracles.json),
[ExaGeoStat](exageostat-oracle.json), [GPflow installation](gpflow-install.json),
[GPflow CPU checks](gpflow-validation.json) and [JAX coexistence](gpflow-jax-coexistence.json).
Their intermediate totals do not replace the final inventory above.

## Reconstruction and validation limits

The [main candidate installer](../../python/wsl/create-venv.sh) restores exact
Python pins and verifies package/GPU versions without replacing an existing
environment. Its transaction was dry-run against this installed stack; these
inventories are not a tested clean-room lockfile. Native dependencies, R, Julia,
source checkouts and private assets use the linked recipes and their own checks.

The four editable projects have local changes or untracked files. Their recorded
commits do not reproduce all installed source content. Preserve and reconcile
those trees through each project's workflow. The RF77 and data77 fixes made for
this task were committed and pushed separately. Raw local URLs, credentials,
licensed assets, backup environments and private staging directories are excluded.

`jax313` and `jax314` lack python-flint and diffrax despite passing dependency
checks. Several planned/upstream adapters have limitations detailed in the audit;
installed packages do not establish every adapter's correctness. APT and user-local
FLINT/Boost builds coexist. PETSc/SLEPc sources were found, but usable builds were
not established. Each target needs its own passing checks.
