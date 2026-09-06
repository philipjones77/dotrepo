# Windows/WSL maintenance results — 2026-09-06

The inspected workstation was reconciled to the shared Bash/SSH/Drive standard,
updated after the user confirmed jobs had finished, and its Ubuntu disk was
compacted. Use the [replication runbook](windows-wsl-maintenance.md) on another
machine. The second physical machine and Colab were not provisioned in this run.

## Repository and configuration

Both native dotrepo clones were fast-forwarded to
`8eb5e57ab13892dec90c607fc06333861c56fd53`, then local changes were reconciled.
The original Windows work is preserved in the local stash
`codex pre-reconcile 2026-09-06`. This record and reconciled configuration are
maintained in main; use `git log` for the published revision. Other project
repositories were inventoried without discarding their work.

Windows uses `C:\dev\dotrepo`; WSL uses `~/projects/dotrepo`; each platform's
`~/.dotrepo` is a compatibility link. The legacy WSL directory and shell settings
were preserved under `~/.dotrepo-backups/20260906-105045-reconcile`. Initial
configuration backups are `20260906-104755` on Windows and `20260906-105045` on
WSL, under each user's `.dotrepo-backups`. Later setting/tool repairs have their
own timestamped backups.

Ubuntu's existing Bash prompt, history, completion, Miniforge behavior and
Linux-first PATH were retained. Windows Terminal defaults to Ubuntu Bash; native
Windows VS Code uses PowerShell and explicit PowerShell 7 automation. Console and
VS Code host profiles were installed in the redirected Documents location.
Execution policy was not changed. Existing editor/terminal preferences were
merged rather than replaced. Hardware-specific WSL limits were preserved.

Both platforms independently authenticated to GitHub over SSH and read the
repository. Their keys and author identities remain platform-specific. Windows
Google Drive for desktop and independently authorized WSL rclone both worked.
After restart, WSL has one writable rclone mount at `~/mnt/gdrive`, using `writes`
caching with 2 GiB/one-hour eviction targets. `/mnt/g` remains optional.

## Installed software and checks

| Area | Verified result |
| --- | --- |
| WSL runtime | 2.7.13.0; `wsl --update` reported latest installed; kernel 6.18.33.2-2 |
| Ubuntu | 24.04.4 LTS; 43 reviewed APT upgrades, zero removals; final `dpkg --audit` clean |
| Selected APT packages | Python 3.12.3-1ubuntu0.16; R 4.6.1-6.2404.0; GitHub CLI 2.100.0; Cloud CLI 583.0.0-0; snapd 2.76.3+ubuntu24.04 |
| Snap | snapd 2.76.3; Cloud CLI 583.0.0; no remaining refreshes |
| WSL standalone tools | Conda 26.7.2; Mamba 2.9.0; Gemini CLI 0.58.0; npm 12.0.2; user Cloud SDK 583.0.0 |
| Retained WSL runtimes | Base Python 3.12.12; dedicated Gemini Node 26.4.0; all six non-base Conda histories unchanged |
| Windows core tools | Git 2.55.0.windows.3; GitHub CLI 2.100.0; 7-Zip 26.02 |
| Windows Anaconda base | Conda 26.7.2; Python 3.13.15; conda-build 26.1.0; JupyterLab 4.5.9; Notebook 7.5.7; Spyder 6.1.5; Navigator 2.7.1 |
| Windows user Python tools | pipx 1.16.7; radian 0.6.16; Store Python dependency check clean |
| Windows R | 4.6.1; Rscript and existing user-library path verified |
| Windows Visual Studio | Community 2022 17.14.39 / build 17.14.37614.0; installer exit 0; C++17 compile/run smoke passed |
| Shared Node LTS | Node 24.20.0 / npm 11.19.0 verified on Windows and fresh WSL Bash; both tracked version files agree |
| Windows standalone Cloud SDK | 583.0.0, bq 2.1.38; TLS validation enabled using a PEM bundle from trusted Windows roots |
| VS Code | Client/server 1.136.1; 91 Windows extensions preserved, two updated; 15 WSL extensions checked and already current |

The twelve successful ordinary Windows app updates covered 7-Zip, Git, GitHub
CLI, GitHub Desktop, Kindle, Grammarly, RStudio, both installed Antigravity
packages, Box, PhysX and PowerToys. Windows extension updates were Markdown
Preview Enhanced 0.8.34 and CodeLLDB 1.12.3. WSL includes Claude Code 2.1.263 and
the Codex extension 26.901.22334. Existing unavailable/manifest differences were
preserved instead of uninstalling extensions.

| Additional updated Windows apps | Final installed versions |
| --- | --- |
| GitHub Desktop, Kindle, Grammarly | 3.6.5; 2.9.1.71006; 1.2.292.1950 |
| RStudio, Antigravity, Antigravity IDE | 2026.08.2+200; 2.12.2; 2.5.5 |
| Box, PhysX, Store PowerToys | 2.53.223; 9.26.0703; 0.101.2362.0 |

Publisher downloads and WinGet installer hashes were verified. Installer success
and the final runtime/workload checks are recorded separately where they differ.

Windows Anaconda was updated through a reviewed Conda transaction, not a full
distribution installer. The transaction matched its plan and retained the
Python 3.13 series and both scientific project histories. Imports, Qt6 and a
NumPy/SciPy solve passed. One pre-existing SymPy/development-mpmath dependency
constraint remains; no new conflicts were introduced. pipx was constrained to a
compatible release to preserve the existing Store Python environment.

GitHub CLI/Microsoft APT signing-key configuration was repaired using the official
vendor endpoints, verified fingerprints/checksum and backed-up keyrings. Strict
APT metadata refresh and a fresh dry-run preceded installation. Added
`libsecret-1-0`/`libsecret-common`; Gemini keytar and node-pty checks now pass.
The existing APT, Snap and user-directory Cloud SDK installations all reached
583.0.0; they remain separately owned installations.

## Norton and certificate repairs

The Store's `0x8a15005e` pinning failure was traced to Norton's intercepted
certificate. A Safe Web exclusion for only
`storeedgefd.dsx.mp.microsoft.com` restored the Microsoft-issued certificate and
successful Store access. TLS verification and Store certificate pinning remain
enabled; no global Norton/HTTPS exclusion was added.

Windows Conda uses `ssl_verify: truststore` for its existing Windows-trusted CA.
Windows user scope now has `NODE_USE_SYSTEM_CA=1`; Node and VS Code Marketplace
HTTPS checks returned HTTP 200 with certificate authorization true. Fully exit
and reopen affected apps/terminals to inherit that environment. Certificate
bundles and prior values remain private in local backups.

The Windows standalone Cloud SDK had an existing setting disabling certificate
validation. That setting was removed; validation now succeeds with a private PEM
bundle exported from already trusted Windows roots. The SDK reached 583.0.0.

PowerShell/VS Code profile checks passed without changing execution policy.
Norton's historical alert details dialog still failed; the exact historical
caller was not recovered from that dialog. No blanket PowerShell, VS Code or
repository exception was added, and that old detection is not declared resolved.

## File viewers

Tracked and live settings explicitly route PDFs to the installed `pdf.preview`,
supported images to the built-in image viewer, and `.md` to Markdown Preview.
Markdown diffs and source-code editors stay textual. Existing unrelated settings
were verified unchanged. Windows default-app choices were not changed.

Known Codex 26.901.22334 and Claude Code 2.1.263 link handlers incorrectly opened
all files as text. A backed-up, version/content-guarded temporary repair switches
ordinary file links to VS Code's viewer dispatch while preserving source-line
selection. The replication command is
`node scripts/repair-chat-file-links.cjs --check`; see the runbook before apply.
Vendor updates may replace the repair, and future versions require fresh review.

Five real isolated VS Code integration tests passed: PDF, PNG and Markdown
selected the expected custom-editor IDs; a JavaScript file retained its line
selection; a Markdown diff used the text diff editor. Fixtures included spaces
in their filenames. The isolated test process exited successfully without closing
the user's editor windows. This validates editor routing, not every possible
attachment/path or future vendor chat implementation.

## Disk space and restart

| Measurement | Bytes |
| --- | ---: |
| Disposable Conda archive/index cache reclaimed | 2,228,301,824 |
| pip cache reclaimed | 5,195,538,432 |
| npm download cache reclaimed | 82,931,712 |
| Total disposable cache reclaimed | 7,506,771,968 (6.99 GiB) |
| Ubuntu VHD before compaction | 304,028,319,744 |
| Ubuntu VHD after compaction | 200,632,434,688 |
| Host space reclaimed by compaction | 103,395,885,056 (96.2949 GiB) |

Cache removal and VHD shrink measure different stages; do not add them as two
independent host-space savings. Extracted Conda packages, project/JAX build
caches, rclone caches and installed scientific environments were preserved.
No compilation-cache deletion or mass project rebuild was performed.

After filesystem trim, DiskPart reported successful offline compaction and exit
0. Ubuntu restarted as the expected non-root Bash user. Repository SSH access,
Conda 26.7.2 and the single writable Drive mount passed post-restart checks.
Both platform doctors and repository validation passed earlier in the session;
all 11 Windows behavioral tests and five applicable native WSL tests passed.
Six PowerShell-specific tests were covered on Windows rather than native WSL.

Windows R 4.6.1 passed its Rscript smoke check with the existing 4.6 user library.
The installer removed the old R directory; exactly one matching old user-PATH
entry was replaced with the new `R-4.6.1/bin` path, preserving the remaining PATH.

Visual Studio upgraded from 17.10.34928.147 to 17.14.37614.0. Its installer exited
0; final inventory reports complete and launchable, with no reboot required.
MSVC compiled and ran the C++17 smoke program successfully. All four workloads
(Core Editor, Python, Native Desktop and Native Cross Platform) were preserved.
The old `Microsoft.VisualStudio.Component.SecurityIssueAnalysis` component ID
was absent after vendor servicing; no manual component removal was performed.
No tracked installer or maintenance processes remain running.

## Windows OS audit and remaining verification

The machine runs Windows 11 Professional 23H2, build 22631.6199, corresponding to
[KB5068865, November 11, 2025](https://support.microsoft.com/en-us/servicing/os/windows-11/2025/11/november-11-2025-kb5068865-os-build-22631-6199).
Microsoft ended Home/Pro 23H2 servicing on November 11, 2025; this is a separate
OS issue from successful application updates. A read-only Windows Update COM scan
completed successfully (ResultCode 2); visible and hidden update scans both
returned zero offers, with no warnings.
That result does not establish feature-update eligibility or rule out a hold.
An OS feature upgrade needs separate review and was not installed in this run.
[Microsoft's servicing notice](https://learn.microsoft.com/en-us/lifecycle/announcements/windows-11-23h2-end-of-updates-home-pro).

Visual Studio 2022 17.14.39 completed and passed final workload/compiler checks.
SumatraPDF and Claude Desktop updates are deferred at the user's request, with
no retry queued. Windows standalone
Cloud SDK 575.0.0 to 583.0.0 completed with TLS validation restored. The reviewed
shared Node baseline is now 24.20.0 LTS in both
`node/.node-version` and `node/.nvmrc`; portable installation on Windows and WSL
passed version checks. APT Node 18 and the isolated Gemini Node 26.4.0 remain separately
owned runtimes. Chrome 152.0.7977.83 is staged; the running browser remains
152.0.7977.77 until a normal browser restart.

The Node update retained both previous portable versions for rollback and removed
69,378,655 bytes of verified download archives after installation.

Major CUDA, Julia and Strawberry Perl changes were held to preserve existing
project/toolchain selection. The final WinGet list retains six offers: full
Anaconda 2025.12-2 (base apps were updated through Conda), Claude 1.44121.2,
Julia 1.12.7, CUDA 13.3, Strawberry Perl 5.42.2.1 and SumatraPDF 3.6.1.
The Store-only query offered no further updates. Shared user Python packages tied to JAX were not
bulk-upgraded. Raw package lists, command logs, screenshots, certificate material,
private paths and rollback records remain ignored under `.local/`,
`wsl/snapshots/` and user backup directories; only this sanitized summary is
intended for version control.
