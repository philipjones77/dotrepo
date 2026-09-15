# PC-PHILIP-WINDOWS software inventory, September 14

Captured from the running Ubuntu 24.04.4 WSL 2 distribution on
**PC-PHILIP-WINDOWS**. Earlier target reports abbreviated the hostname as
PC-PHILIP-WINDO. The other computer was previously identified as PhilipSecond;
its current state has not been inspected in this session.

Read the [cross-machine handoff](../../docs/ai/sessions/2026-09-14-python-oracle-wsl-handoff.md)
for the requested work and validation limits.

**All 34 requested M-tier oracles are installed and smoke-tested:** 22 in
`py313`, 11 in R, and native ExaGeoStat. See the
[complete package table and target commands](../../docs/wsl-m-tier-oracles-2026-09-14.md).

## Files

- [Environment inventory](wsl-native/standard-python/environments.json): exact
  interpreter versions, unique package counts and dependency checks.
- [Python differences](wsl-native/standard-python/changes-since-2026-09-07.json):
  additions, version changes and removals against the September 7 source records.
- `wsl-native/standard-python/*-packages.json`: installed package identities.
- `wsl-native/standard-python/*-requirements.txt`: exact ordinary package pins.
- `wsl-native/standard-python/*-manual-sources.json`: separately restored
  editable projects with sanitized repository identities and observed commits.
- [APT inventory](wsl-native/apt-installed.json), [manual selections](wsl-native/apt-manual.txt)
  and [capture summary](wsl-native/capture.json): installed distribution packages,
  R capture scope, editor extensions and observation limits.
- [Native commands and checks](native-summary.json): versions, user-local
  FLINT/Boost installations, package health and numerical smoke tests.
- [Oracle checks](oracle-checks.json): Python numerical checks and per-environment
  backend gaps.
- [Python M-tier results](python-m-tier-oracles.json), [R M-tier results](r-m-tier-oracles.json)
  and [ExaGeoStat results](exageostat-oracle.json): the complete user checklist,
  installed versions, package changes, source provenance and functional checks.
- [GPflow installation](gpflow-install.json), [CPU model checks](gpflow-validation.json)
  and [JAX coexistence](gpflow-jax-coexistence.json): GPflow 2.9.2 added to
  `py313`, bringing it to 283 unique packages before the full oracle checklist
  installation. Setuptools 80.9.0 is a required
  compatibility pin for this locally tested combination.

## Reconstruction limits

These files describe installed state. They are not a tested clean-room lockfile.
Review the target's existing packages and workloads before applying the pins.
In particular, the smaller `jax313` and `jax314` environments lack `python-flint`
and `diffrax`; dependency checks pass, but Arb oracle certification cannot pass.

The four editable projects have uncommitted changes. Their recorded Git commits
alone do not reproduce their installed source trees. Preserve and synchronize
those changes through each project's own workflow; their source files and raw
local URLs are excluded here. Retained `*.old` environments are backups and are
excluded from the active inventory. No standard Conda installation was found.

Native APT libraries and user-local reference builds have separate ownership.
APT FLINT 3.0.1 and user-local FLINT 3.4.0 coexist. PETSc/SLEPc source checkouts
are present, but this capture does not establish usable built installations.
Credentials, licensed assets, caches and raw logs are not included.
