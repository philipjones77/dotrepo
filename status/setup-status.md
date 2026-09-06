# Setup Status

Last updated: 2026-09-06

This file records the status of standards and verification owned by dotrepo.
Generated machine-specific audit outputs should stay in `.local/status/` unless
they are sanitized before commit.
Current maintenance evidence is in the
[2026-09-06 report](../docs/maintenance-2026-09-06.md); historical version
observations below are not current-version guarantees.

## Repository Setup Standards

| Area | Status | Notes |
| --- | --- | --- |
| Windows bootstrap | ok | Existing installer plus new read-only audit script |
| WSL bootstrap | ok | Existing installer plus new read-only audit script |
| Related repo inventory | planned | Human-readable `docs/related-repos.md` exists; machine-readable `projects/inventory.yml` still needed |
| AI session sharing | ok | Methodology and templates added |
| ChatGPT web project setup | ok | Template added; per-project application pending |
| Claude.ai project setup | ok | Template added; per-project application pending |
| GitHub Copilot instructions | ok | Template added; per-project application pending |
| GitHub PR/CODEOWNERS/workflow standards | ok | Standards documented; templates and audits pending |
| Docker local/WSL verification | ok | Read-only audit scripts added |
| Google Cloud verification | ok | Read-only audit scripts added |
| Antigravity CLI Windows setup | manual-check | Official installer present; July observation was `1.0.16`; current CLI version needs re-inventory |
| Antigravity CLI WSL setup | manual-check | Official installer present; July observation was `1.0.9`; current CLI version needs re-inventory |
| Antigravity desktop app Windows | ok | Both installed Antigravity packages updated in September; use product metadata, not embedded Electron/Node version |
| Gemini CLI verification | legacy | Included in Google tooling audit; individual/free tier should migrate to Antigravity CLI after Google cutoff on 2026-06-18 |
| Gemini CLI Windows setup | legacy | Existing user-local Node/Gemini CLI install is no longer a target for individual/free use |
| Gemini CLI WSL setup | legacy | Existing conda env `gemini-cli` is no longer a target for individual/free use |
| Gemini Code Assist VS Code Windows | deprecated | Removed from tracked extension inventory for individual/free accounts; use Antigravity or a licensed Standard/Enterprise project |
| Gemini Code Assist VS Code WSL | deprecated | Removed from tracked remote extension inventory for individual/free accounts; use Antigravity or a licensed Standard/Enterprise project |
| Google Cloud / Gemini reset plan | ok | Reset plan documented; destructive uninstall not automated |
| Google Cloud / Gemini local backup | ok | Backup scripts added for Windows and WSL |
| Google Drive Windows mount verification | ok | Audit script added; current machine reports `G:\` |
| Google Drive Windows automatic mount | ok | PowerShell profile starts Google Drive for desktop if `G:\My Drive` is missing |
| Google Drive WSL DrvFs verification | not-applicable | `/mnt/g` is optional compatibility; native rclone is the standard |
| Google Drive WSL native rclone mount | ok | Post-restart check verified one writable mount at `~/mnt/gdrive` with bounded `writes` caching |
| Google Colab standard | ok | Standard and `colab/setup.py` present; no Colab runtime provisioned or validated in this session |
| Cross-repo write/commit/push automation | planned | Requires inventory, audit, dry-run, write, commit, and push commands |

## Current Verification Commands

```powershell
.\bootstrap\audit.ps1
.\cloud\docker\audit.ps1
.\cloud\google\audit.ps1
```

```bash
./bootstrap/audit.sh
./cloud/docker/audit.sh
./cloud/google/audit.sh
```

## Required Next Implementation

1. Add `projects/inventory.yml`.
2. Add `projects/scripts/audit-project.*`.
3. Add `.local/status/` output support for all audits.
4. Add Docker, Colab, GitHub, and AI-context templates under `projects/templates/`.
5. Add check-only cross-repo audit first.
6. Add write mode.
7. Add commit mode.
8. Add push mode as an explicit final step.
