# Source Windows and WSL verification — 2026-09-07

This audit ran on **PhilipSecond, the source computer**. It does not assert that
the separate target recovery is complete. See the [source manifests](../machines/source-2026-09-06/README.md),
[session handoff](ai/sessions/2026-09-07-source-machine-replication.md) and
[target recovery report](recovery-2026-09-06.md).

## Applications and configuration

- A fresh WinGet export contained all 43 recorded package IDs; none were missing.
  Desktop and Store inventory counts remain 298 and 155 component/package records.
  Vendor licensing and account logins are not proven by installation inventory.
- All 91 Windows and 30 WSL extension IDs in the source snapshot remain present.
- All 1,109 Ubuntu APT package records match the snapshot. Strict repository
  refresh succeeded; the actual no-removal upgrade reported zero pending upgrades,
  and dpkg audit was clean. The preceding check reported snaps current.
- WSL 2.7.13 was verified current in the preceding update check. Ubuntu 24.04 uses
  systemd, default user `phili`, 16 GB memory cap and active 24 GB swap.
- `phili` is the only personal Linux account. The inactive `philip` login was
  removed; its files were retained and transferred to `phili`. System accounts remain.
- Ubuntu Terminal profiles explicitly select `phili`, home and login Bash. An old
  local `.bash_profile` bypassed `.profile`; it was backed up and changed to source
  `.profile`. A real new login shell now starts in `/home/phili` with the shared
  colored `user@host:directory$` prompt and `(base)` Conda prefix.
- Windows shell startup previously only detected Anaconda. This audit added
  Miniconda fallback and GitHub CLI discovery to the shared PowerShell profile.
  Bootstrap installed it into console and VS Code profiles with backups. A fresh
  normal PowerShell 7 session resolves Python to Miniconda, activates base and
  reports Python 3.13.13, Conda 26.7.2, Node 24.20.0 and GitHub CLI 2.100.0.
- Repository doctor checks passed on Windows and WSL. Earlier no-profile Windows
  checks saw stale PATH entries; actual normal-profile command checks verified
  the installed tools after the profile correction.

## Python environments

| Platform / environment | Python | Packages | Verification |
| --- | --- | --- | --- |
| Windows Miniconda base | 3.13.13 | 129 | Exact observed package records match; pip check clean; SSL import and SQLite calculation pass |
| WSL Miniforge base | 3.13.13 | 317 | Exact observed package records match; pip check clean; NumPy calculation, SSL and SQLite pass |
| WSL Miniforge jax | 3.12.13 | 444 | Exact observed package records match; pip check clean; NumPy and JAX GPU calculation pass |
| Windows dotrepo `.venv-windows` | 3.13.13 | Repository tooling | Separate local validation environment |
| WSL dotrepo `.venv-wsl` | 3.12.3 | Repository tooling | Separate local validation environment based on Ubuntu Python |

Windows base intentionally matches the minimal source manifest, which has no
NumPy. An exploratory NumPy import failed for that reason; it was not installed
into base just to make that probe pass. Scientific packages are recorded in the
WSL environments: base has NumPy 2.5.2, SciPy 1.17.1 and JAX 0.10.1; jax has
NumPy 2.3.5, SciPy 1.18.0 and JAX 0.10.2.

The jax smoke check found `cuda:0` and computed the dot product of `[1,2,3]` with
itself as 14. Initial GPU preallocation attempts reported insufficient memory,
then allocation fallback succeeded and the calculation completed. This verifies
a small GPU operation, not capacity for full scientific workloads. No running
GPU applications were terminated to free memory.

The three environment manifests and manual-source records are under the source
inventory's platform-specific `conda/` directories. The two repository venvs
can be recreated from their native Python using `python -m venv` and
`python -m pip install -r scripts/requirements.txt`; they are not copied between
Windows and Linux. No blanket update was applied to the scientific environments.

## Remaining limits

- The only versioned WinGet upgrade offer is a Miniconda distribution replacement
  moving to Python 3.14. Keep the captured Python 3.13 environment unless migration
  is deliberately selected and tested. Cloud SDK's Unknown-version offer is the
  already verified installed 583.0.0. Claude now registers 1.44121.2.0.
- Windows Conda reconstruction remains unverified because its dry-run solve
  required Anaconda terms acceptance. Installed-environment checks above passed.
- `fftlog-lss` original source/wheel is still needed for target reconstruction.
  Editable scientific projects have recorded repositories/commits; full project
  workload tests and R source provenance remain separate requirements.
- Earlier file-viewer integration tests passed; this audit did not repeat them.
  Norton blocking is not declared permanently resolved. Licenses, cloud logins,
  target hardware drivers and target data recovery need their own checks.
- Inventories cover the current user's standard installations. Other project-local
  environments outside the documented locations may need separate capture.

The source meets the recorded application/package baseline and the checked shell
and Python behavior. The target must be compared and verified independently.
