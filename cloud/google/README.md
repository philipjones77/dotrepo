# Google Tooling Standard

This folder owns the dotrepo standard for Google Cloud CLI, Antigravity CLI,
legacy Gemini CLI state, Google Cloud authentication, and project-level Google
execution.

The reset goal is a boring, reproducible setup:

- Windows and WSL are independent installs.
- WSL is the primary Linux development target.
- Windows may have Google tooling only when Windows-native workflows need it.
- Google Cloud CLI is installed through the platform package manager or official
  installer.
- Gemini CLI is legacy for individual/free accounts after Google's 2026-06-18
  cutoff; use Antigravity CLI for that tier.
- Antigravity CLI is the target terminal coding tool for individual/free,
  Google AI Pro, and Google AI Ultra accounts.
- Auth state is backed up or intentionally discarded before reset.
- Secrets and tokens are never committed to dotrepo.

The consumer-tier transition is described in
[Google's Gemini CLI notice](https://github.com/google-gemini/gemini-cli/discussions/28017).
Updating an existing CLI binary does not establish account/service eligibility.

## Current Commands

```powershell
.\cloud\google\audit.ps1
.\cloud\google\install-antigravity.ps1
# Legacy only: .\cloud\google\install-gemini.ps1
```

```bash
./cloud/google/audit.sh
./cloud/google/install-antigravity.sh
# Legacy only: ./cloud/google/install-gemini.sh
```

Local-only backup before reset:

```powershell
.\cloud\google\backup-state.ps1
```

```bash
./cloud/google/backup-state.sh
```

## Target Install Methods

Windows:

- Google Cloud CLI: official Windows installer, or `winget` if we decide to
  manage it that way.
- Gemini CLI: legacy individual/free path; do not install for new setups unless
  a licensed workflow explicitly requires it.
- Antigravity CLI: official installer to `%LOCALAPPDATA%\agy\bin`.
- Antigravity desktop app: official installer under
  `%LOCALAPPDATA%\Programs\antigravity` when desktop workflows are used.
- Reviewed shared Node baseline: `v24.20.0` LTS, verified on Windows and WSL.

WSL Ubuntu:

- Google Cloud CLI: Google `apt` repository package `google-cloud-cli`.
- Gemini CLI: legacy individual/free path; do not install for new setups unless
  a licensed workflow explicitly requires it.
- Antigravity CLI: official installer to `$HOME/.local/bin`.
- The isolated WSL Gemini environment retains Node `v26.4.0`, independently of
  the shared Node LTS selection and the APT Node installation.

The July inventory observed Antigravity CLI `1.0.16` on Windows and `1.0.9`
on WSL. Re-inventory them before treating those observations as current.
An Electron/Node version printed by a GUI executable is not the application's
product version; use its installed package metadata or About screen.
The September WSL maintenance verified Gemini CLI `0.58.0`, npm `12.0.2` and
all three WSL Cloud SDK installations at `583.0.0`. See the
[dated maintenance report](../../docs/maintenance-2026-09-06.md) for Windows
SDK update results and other software scopes.

## Auth Rules

- Prefer user OAuth for local development.
- Prefer Application Default Credentials for local client-library work.
- Prefer service account impersonation, Workload Identity, or Secret Manager for
  cloud/container workflows.
- Do not commit service-account JSON keys.
- Do not commit `.gemini`, `.config/gcloud`, `.boto`, API keys, OAuth tokens, or
  generated auth files.

## Reset Rule

Reset is a four-step process:

1. Inventory.
2. Backup.
3. Uninstall/purge.
4. Reinstall and re-authenticate.

The uninstall step is destructive and must be explicit. Do not run it as part of
a normal audit.

See `reset-plan.md`.
