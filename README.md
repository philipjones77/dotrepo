# dotrepo

To reproduce the current source computer on the other machine, use the
[Windows and WSL source inventory and target setup steps](machines/source-2026-09-06/README.md).
The [September 7 session handoff](docs/ai/sessions/2026-09-07-source-machine-replication.md)
records completed maintenance, verification results and remaining target work.

This repository defines, installs, and checks the developer environment on Windows and WSL. It is the command center for shared configuration, platform differences, software inventories, and GitHub Actions validation.

The full scope is two Windows/WSL machines plus Colab and GitHub Actions. See [the environment topology](docs/topology.md) for how shell settings, Google Drive, identities and project environments fit together. The inspected Ubuntu Bash setup is the shared terminal baseline; `colab/setup.py` mounts Drive and records a notebook runtime.

The goal is **consistent behavior with explicit platform differences**. Windows and WSL may use separate Git identities and separate SSH keys. Hardware limits, credentials, licensed software, and project dependencies are not forced to be identical.

## Commands from this repository

Run PowerShell commands from the repository root. They work from a checkout such as `C:\dev\dotrepo`.

```powershell
# Read-only machine checks; reports missing configuration with a nonzero exit.
.\scripts\dotrepo.ps1 -Action doctor -Platform all

# Apply tracked configuration with timestamped backups.
.\scripts\dotrepo.ps1 -Action install -Platform windows
.\scripts\dotrepo.ps1 -Action install -Platform wsl

# Explicit hardware profile: 16 GB RAM limit and 24 GB swap on a 32 GB host.
.\scripts\dotrepo.ps1 -Action install -Platform windows -WslProfile memory-32gb

# Generate a separate SSH key on each platform, prompting for a passphrase.
.\scripts\dotrepo.ps1 -Action ssh -Platform windows
.\scripts\dotrepo.ps1 -Action ssh -Platform wsl

# Once public keys are registered and GitHub host keys trusted:
.\scripts\dotrepo.ps1 -Action doctor -Platform all -Network

# Save a Windows health report and a detailed WSL inventory.
.\scripts\dotrepo.ps1 -Action capture -Platform all
```

Choose a distribution with `-Distribution Ubuntu`. WSL commands run from the native `~/projects/dotrepo` clone by default. Use `-WslRepoPath` only for an explicit alternate clone. The dispatcher stops if the native clone is missing or outdated; update it before running commands. Use Linux-native storage for Python environments, builds, datasets, and other heavy workloads. The dispatcher is sequential so installation and capture do not compete for the WSL VM.

From inside WSL:

```bash
bash scripts/dotrepo.sh doctor
bash scripts/dotrepo.sh install
bash scripts/dotrepo.sh ssh
bash scripts/dotrepo.sh doctor --network
```

`install` applies configuration only. Add `-InstallTools` on Windows or `--install-tools` in WSL to install tracked VS Code extensions and global npm packages. Python environments are created separately using `python/windows/create-venv.ps1` or `bash python/wsl/create-venv.sh`; Conda definitions live beside them. R and MATLAB are inventoried, not automatically installed or licensed.

## First setup

Prerequisites: Git, OpenSSH, Python 3.10+, PowerShell on Windows, Bash and Python on WSL. Install WSL/Ubuntu before dispatching WSL commands. Clone separately on each platform for best filesystem performance:

```bash
mkdir -p ~/projects
git clone git@github.com:philipjones77/dotrepo.git ~/projects/dotrepo
cd ~/projects/dotrepo
bash scripts/dotrepo.sh install
```

If SSH is not configured yet, obtain the checkout through HTTPS once, run the SSH setup script, register its public key in the appropriate GitHub account, and verify the host fingerprint. GitHub Git URLs are rewritten to SSH after bootstrap. APIs and Actions use their own authentication; see [SSH](ssh/README.md).

Installers create `~/.dotrepo` as a link/junction to the checkout when absent. They stop if that name already refers to a different checkout. Existing configuration is backed up under `~/.dotrepo-backups/<timestamp>/`. Windows copies files when symlinks are unavailable; rerun installation to refresh those copies. Existing `.wslconfig` is preserved unless a profile is selected. Existing `/etc/wsl.conf` is preserved. Restart WSL manually after changing its configuration, after saving work.

## Structure and ownership

| Directory | Purpose |
| --- | --- |
| `config/` | Shared environment policy and platform/profile references |
| `scripts/` | Cross-platform entry points, repository validation, machine doctor |
| `bootstrap/` | Native installers, backups, canonical checkout registration |
| `git/`, `ssh/` | Git behavior, separate platform identities, SSH client policy |
| `shared/`, `windows/`, `wsl/home/` | Shared shell behavior and platform configuration |
| `python/`, `node/` | Reviewed environment definitions and install helpers |
| `vscode/` | Editor settings and extension manifests |
| `wsl/` | Software inventories, snapshot comparison, migration and compaction |
| `.github/` | Windows/Linux CI and dependency-update configuration |
| `tests/` | Behavioral regression tests for the management tools |
| `docs/` | Environment contract and operational procedures |

Start with [the environment contract](docs/environment.md), [GitHub workflow standards](docs/github.md), and [WSL migration](wsl/README.md).

Projects may run on both platforms. See [Windows/WSL project conventions](docs/projects.md), and run `scripts/dotrepo.ps1 -Action projects -Platform all` to inspect both sets of checkouts without changing them.

## Roadmap and local audits

The implementation plan in [docs/usefulness-plan.md](docs/usefulness-plan.md)
covers machine audits, project templates, Codex/Claude/ChatGPT setup, GitHub
standards, optional-tool detection, and drift checks across Windows and WSL.

The repo purpose and operating model are defined in
[docs/project-overview.md](docs/project-overview.md). AI session-sharing and
web-tool guidance live in
[docs/ai-session-methodology.md](docs/ai-session-methodology.md), with shared
AI/GitHub standards in
[docs/ai-github-standards.md](docs/ai-github-standards.md).
Cloud, Colab, Google Cloud, Docker, and container standards live in
[docs/cloud-container-standards.md](docs/cloud-container-standards.md).
The setup matrix and status model are in
[docs/machine-environment-setup.md](docs/machine-environment-setup.md) and
[status/setup-status.md](status/setup-status.md).

Current read-only audits:

```powershell
.\bootstrap\audit.ps1
.\cloud\docker\audit.ps1
.\cloud\google\audit.ps1
.\cloud\google-drive\audit.ps1
```

```bash
./bootstrap/audit.sh
./cloud/docker/audit.sh
./cloud/google/audit.sh
./cloud/google-drive/audit.sh
```

## Validation and CI

Create isolated validation environments once:

```powershell
python -m venv .venv-windows
.\.venv-windows\Scripts\python -m pip install -r scripts/requirements.txt
.\scripts\dotrepo.ps1 -Action validate
.\.venv-windows\Scripts\python -m unittest discover -s tests -v
```

```bash
python3 -m venv .venv-wsl
.venv-wsl/bin/python -m pip install -r scripts/requirements.txt
bash scripts/dotrepo.sh validate
.venv-wsl/bin/python -m unittest discover -s tests -v
```

Complete repository validation requires PowerShell (`pwsh` on Linux, or Windows PowerShell interop in WSL). CI runs the same validator and tests on Windows and Ubuntu. It checks configuration syntax, policy references, Node version agreement, shell syntax on Linux, PowerShell parser errors, and workflow permissions/pins/timeouts. It does not provision a workstation, validate proprietary licenses, or prove every scientific workload works.

The doctor separately checks this machine's tools, canonical checkout, installed Git/SSH/shell configuration and optional SSH access. A green CI run does not mean a machine is configured correctly. Doctor is read-only and does not install missing applications.

## Change and update procedure

Use the [Windows/WSL maintenance runbook](docs/windows-wsl-maintenance.md) to
replicate setup and repairs on another machine. The
[2026-09-06 maintenance report](docs/maintenance-2026-09-06.md) records verified
updates, disk savings, remaining checks and recovery information without private
machine logs or credentials.
For a Windows reinstall, start with [recovering the existing environment](docs/windows11-recovery.md)
before creating a new Ubuntu distribution or removing Windows.old.
The [Windows reinstall recovery report](docs/recovery-2026-09-06.md) records the
target's restored files and tools, verification results, and remaining work.

1. Edit the shared policy, platform configuration, or package definitions in this repo.
2. Validate locally and run tests. Explain intentional Windows/WSL differences.
3. Review through GitHub and require both CI jobs before merging.
4. Pull on each machine, rerun bootstrap, then doctor. Restart affected applications.
5. Capture inventories before and after larger package upgrades; compare machine snapshots.

Installed inventories are evidence, not desired-state lock files. The reviewed shared Node baseline is 24.20.0 LTS; scientific package definitions remain workload-specific baselines. Ubuntu APT updates do not update Conda, pip environments, extensions, Snap packages, or MATLAB. Upgrade each package manager deliberately and test the relevant workloads.

Private keys, local overrides, raw machine reports, and inventory snapshots stay outside version control. Reviewed, sanitized maintenance summaries belong in `docs/`. No automatic cloud synchronization or background machine management is installed.
