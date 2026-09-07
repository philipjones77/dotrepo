# Session Capsule: Source machine maintenance and target replication

[WSL Conda retirement](../../wsl-conda-retirement-2026-09-07.md) records the
user's explicit no-Conda target, the new non-Conda experiment launcher and the
completed Miniforge removal after the user authorized stopping its two jobs.
Do not launch new work with Miniforge; use standard virtualenvs.

Latest software/structure inventory: [WSL matrix and operator comparisons](../../wsl-matrix-comparison-2026-09-07.md).

Latest continuation: [native WSL Python and scientific tools](../../wsl-native-python-2026-09-07.md).
The source now has tested standard CPython replacements (`py313`, `jax-native`),
native Claude/Codex/Gemini/Google Cloud CLIs and updated R packages. Miniforge
base has been removed after stopping its jobs with user authorization. The old Conda
`jax` environment and `jax-wsl` duplicate were removed; the separate legacy
statistics virtualenv is retained.
Use that report and the `wsl-native` inventory before following historical
Conda restore instructions below. FFTLog has been recovered as a local wheel;
it still needs separate transfer when replicating to another machine.
The subsequent [Linux MATLAB installation](../../matlab-wsl-2026-09-07.md)
tracks the user's request for MATLAB and all toolboxes. Source WSL activation
is now verified: a fresh R2026a Update 5 batch launch passed license, arithmetic
and FFT checks and listed 67 products. Individual toolbox workloads remain
untested. License files and account details are not committed.

The [Wolfram WSL update](../../wolfram-wsl-2026-09-07.md) installed 15.0.1
and local documentation. Activation with the user's new key and fresh kernel
calculations passed. Default kernel commands and WolframScript now use 15.0.1;
14.3 remains installed as a fallback. No license secrets were committed.

Date: 2026-09-06–2026-09-07 (America/Chicago)
Repo: dotrepo
Branch: main
Machine: PhilipSecond / Windows 11 / WSL 2 Ubuntu 24.04
Primary tool: Codex

Later September 7 work is recorded in the [updated source setup](../../../machines/source-2026-09-07/README.md):
standard Windows CPython replaces Miniconda as the default, JAX CPU was tested,
native WSL PowerShell was installed, and R/Rtools, TeX collections, SumatraPDF
and editor extensions were verified. Windows Miniconda was subsequently removed;
standard CPython remains the default and WSL Miniforge remains installed. The
user explicitly cancelled the proposed full Windows Anaconda installation;
do not reinstall Anaconda or Miniconda when continuing this setup. Fresh
VS Code viewer and PowerShell 7 execution tests passed with Norton services running.
Read that newer report before using the
earlier environment state below.

## Goal

Maintain Windows and WSL, preserve 24 GB swap, make VS Code PDF/Markdown/image
links work, investigate Norton blocking PowerShell installers, and reproduce
this computer's applications and configuration on the other computer. The user
explicitly clarified: **this machine is the source; the other is the target.**
The user requested that the inventory and this session handoff be pushed to GitHub.

## Current Status

Source inventory and editor fixes were pushed to main in
`724c8d58076c19a4e6a1d77f452c2d824dab753d`. Both source checkouts (Windows and
native WSL) were synchronized to that commit. This source session has not accessed
or changed the target. This is a portable session summary, following the repository's
[session methodology](../../ai-session-methodology.md).

While publishing this capsule, remote commit `2fde13e` arrived with the other
computer's [Windows recovery report](../../recovery-2026-09-06.md). That separate
session restored parts of Windows and preserved the target's Ubuntu disk, but
reported Ubuntu import/boot and remaining applications incomplete. Read that
report before target work: recover its existing disk and environments first.
It records a 16 GB RAM target with an 8 GB WSL memory cap and 4 GB swap, unlike
this source's 24 GB swap. Reconcile that difference with the user's requested
24 GB swap after checking target free disk space. The remote recovery changes
were retained when integrating this capsule.

The [source catalog and target instructions](../../../machines/source-2026-09-06/README.md)
contain 43 WinGet package IDs, 298 desktop/component records, 155 current-user
Store packages, 91 Windows and 30 WSL VS Code extensions, 1,109 APT packages
(63 marked manual), three Conda environment inventories and 72 R packages.

The September 7 follow-up checked the same source computer, PhilipSecond:

- All 43 WinGet IDs in the manifest were already installed; none needed installing.
- WSL 2.7.13 was already current. Strict APT index refresh and the actual
  no-removal upgrade completed with zero pending upgrades; dpkg audit was clean.
  Snap reported all snaps current.
- WSL swap was active at 25,769,803,776 bytes (24 GiB); configuration has
  `memory=16GB`, `swap=24GB`, and gradual memory reclaim on this 32 GB RAM source.
- Claude now registers version **1.44121.2.0**, resolving the pending registration
  noted in the September 6 snapshot. Keep the dated snapshot as historical evidence.
- Google Cloud SDK is 583.0.0. WinGet labels its installed version Unknown and
  offers that same version; executable verification confirms it is installed.
- The remaining WinGet offer is the Miniconda Python 3.14 distribution replacement.
  It was not applied: the source uses Python 3.13.13 with an already updated
  Conda base, and a distribution replacement could disrupt that environment.

Earlier source maintenance installed PowerShell 7.6.5, CUDA 13.3 and other Windows
updates, updated the Windows and WSL Conda base environments, and installed Node
24.20.0 with npm 11.19.0 and corepack 0.35.0 on both platforms. The scientific
JAX environment was inventoried rather than blanket-upgraded. See the source
catalog for exact observed versions and installation ownership.

## Files Changed

### Later source account and terminal follow-up

At the user's request, `phili` is now the only personal Ubuntu account (UIDs
1000–65533); root and required system/service accounts remain. The inactive
`philip` login was removed after checking that it had no running processes or
crontab. Its 1.9 GB home directory was preserved in place, with ownership
transferred to `phili`; no home data was deleted. Account database backups are
private and root-only. `/etc/wsl.conf` already selected `phili` as the default.

All Ubuntu entries in the source's Windows Terminal settings now explicitly run
`wsl.exe -d Ubuntu --user phili --cd ~ --exec bash --login`. The same command is
tracked in `windows/terminal/settings.json` for the target. The shared Ubuntu
Bash prompt remains `user@host:directory$` (colored in supported terminals).
A new login-shell check returned user `phili` and directory `/home/phili`.
Existing terminal tabs must be reopened to use the new launch configuration.
The target's accounts must be inspected independently before any account removal.

- `machines/source-2026-09-06/`: source manifests, application lists, target setup
  steps, manual/licensed installers and known reproduction gaps.
- `scripts/capture-software.py`: shareable software capture, excluding credentials
  and local package-source paths; records eligible GitHub repository identities.
- `bootstrap/install.ps1`: merges ignored editor `settings.local.json` overrides.
- `scripts/doctor.py`: checks the effective tracked-plus-local editor settings.
- `tests/test_capture_software.py`, `tests/test_tools.py`: capture and override tests.
- `docs/windows-wsl-maintenance.md`, `README.md`: setup guidance and inventory link.
- This capsule: continuation context and September 7 verification results.

Machine-local editor paths, raw logs, trusted certificate bundles and backups
remain outside Git. Reconstruct local settings for the target's actual paths.

## Commands Run

Representative verification commands (run from the appropriate native checkout):

```text
python scripts/validate.py
python -m unittest discover -s tests -v
conda env create --name <temporary-check-name> --file <captured-environment.yml> --dry-run --json
git diff --cached --check
git push origin main
git ls-remote origin refs/heads/main
winget export --output <private-output.json> --source winget
winget upgrade --include-unknown --disable-interactivity
gcloud version --format=json
wsl --update
apt-get update -o APT::Update::Error-Mode=any
apt-get --simulate --no-remove upgrade
apt-get --no-remove upgrade -y
dpkg --audit
snap refresh
swapon --show --bytes
```

## Tests And Verification

- Repository validation passed on Windows and WSL.
- Windows: 15 unit tests passed. WSL: eight passed, seven native-PowerShell
  tests skipped because native Linux PowerShell was unavailable.
- WSL base and jax Conda dry-run solves passed. These do not validate subsequent
  pip downloads, editable package restoration or scientific/GPU workloads.
- Windows Conda dry run stopped at Anaconda's terms acceptance requirement;
  its solve remains unverified. The user must review the applicable terms.
- Source VS Code file-opening integration checks passed for PDF, image,
  Markdown preview, source-file line navigation and Markdown text diff in an
  isolated window. Recheck with the target's installed extensions.
- Standalone Windows PowerShell and an isolated VS Code PowerShell terminal
  ran successfully after the reported Norton event. This is not proof that
  Norton will allow every future command.

## Decisions

- Use the current source inventory, not the other machine's older app list.
- Preserve platform-native Python/Node installations and scientific environments.
- Record exact observed versions, but explain that unavailable catalog versions,
  hardware, account licensing and manual sources prevent a guaranteed disk clone.
- Keep separate SSH keys and cloud logins on each platform and machine.
- Do not copy blanket PowerShell/Git/WinGet exclusions into Norton.
- No automatic reboot or target operation was performed in the final follow-up.

## Blockers And Remaining Work

- Target access from this session is still needed. Verify its hostname before applying installation
  steps; the source session remained on PhilipSecond when asked to install again.
- Norton Behavioral Protection reported `IDP.Generic - Command line detection`
  at September 6, 5:15 PM, terminating a PowerShell/Git/WinGet process tree and
  deleting a PowerShell policy-test temporary file. Executable signatures were
  checked; Norton definitions/program were updated and later installers completed.
  A false positive is suspected, not established. No vendor report was submitted
  and no blanket exclusions were added. Review a fresh event's exact command if
  blocking recurs. Norton had requested a reboot; reboot completion is unverified.
- `fftlog-lss==0.1.2` was installed from a temporary local directory; its original
  source/wheel is still needed. Other editable scientific repositories and commits
  are in the Conda manual manifests. Their installed metadata differs between
  environments, so workload validation is required after reconstruction.
- Restore personal/project data separately, install licensed apps through the
  user's accounts and choose GPU/OEM drivers for the target hardware.
- Review R package provenance; the observed R list is not a complete restore lockfile.

## Next Steps

1. On the target, inspect hostname, git status and remotes; preserve local edits,
   then pull main in Windows. Follow the separate recovery report to restore
   Ubuntu before inspecting and updating its native WSL checkout.
2. Read the source catalog, compare target inventories, and install missing Windows
   apps and Ubuntu packages using its instructions. Recheck current updates.
3. Restore the Conda environments and manual sources, configure target-local
   editor paths, apply dotrepo settings and install the captured extensions.
4. Check RAM before applying WSL limits; preserve the requested 24 GB swap.
5. Reauthorize licensed/cloud apps, verify Norton behavior and file links, and run
   doctor plus relevant scientific/GPU workload checks. Record actual target results.

## Resume Prompt

```text
Continue dotrepo on main. Read docs/ai/sessions/2026-09-07-source-machine-replication.md
and machines/source-2026-09-06/README.md first. PhilipSecond was the source;
the other computer is the target. Verify which machine this session controls.
The source inventory and maintenance are recorded. A separate target session
reported partial Windows recovery in docs/recovery-2026-09-06.md; read it and
recover the preserved Ubuntu disk before attempting Linux installation work.
Compare the target with the source manifests, install missing apps,
update WSL/Ubuntu, restore native environments and editor settings, and verify
24 GB swap, Norton behavior and PDF/Markdown/image links. Preserve existing data,
credentials and scientific environments. Record gaps and update this capsule
with the actual results, then push the authorized repository changes.
```

## Links

- [Source inventory commit](https://github.com/philipjones77/dotrepo/commit/724c8d58076c19a4e6a1d77f452c2d824dab753d)
- [Maintenance runbook](../../windows-wsl-maintenance.md)
- No issue, PR or shareable chat snapshot was created in this session.
