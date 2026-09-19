# PowerShell update: PC-PHILIP-WINDOWS and pending PhilipSecond

Date: 2026-09-19. Repository: dotrepo, branch `main`.

The user requested updating all PowerShell installations on both machines.
The current machine's DNS/WSL hostname is **PC-PHILIP-WINDOWS**; Windows reports
the shortened computer name **PC-PHILIP-WINDO**. Both active PowerShell 7
installations here were upgraded from **7.6.5 to 7.6.6**.

| Environment | Update and verification |
| --- | --- |
| Windows | Official Microsoft x64 ZIP, verified against the release SHA256 and valid Microsoft Authenticode signature. The existing `~/.local/powershell/current` junction now selects `7.6.6`. Fresh ordinary-profile startup through PATH, pipeline arithmetic and JSON conversion passed. |
| Ubuntu WSL | Official Microsoft APT package `powershell` upgraded from `7.6.5-1.deb` to `7.6.6-1.deb`. Fresh native startup as the normal user reports 7.6.6 and .NET 10.0.12; pipeline arithmetic and JSON conversion passed. |
| PhilipSecond | Pending: this session could not establish a remote connection. Its current installed versions were not verified. |

The GitHub latest stable release API and
[Microsoft's 7.6.6 release](https://github.com/PowerShell/PowerShell/releases/tag/v7.6.6)
agreed on the version. The Windows archive SHA256 is
`02FE458BE20493FBDF43F61EA20610B811EE6C738AB1676C61B9CFCD1A33C860`.

## Preservation and validation

Only Ubuntu was registered in WSL. No additional active PowerShell 7 installation
was found in the inspected Windows package registrations, standard installation
directories, user-local locations or native WSL package/local locations.

The Windows 7.6.5 directory remains available for existing processes and rollback.
No running shell was terminated. Open new terminals to load 7.6.6. Windows
Terminal and VS Code already use the stable path, so their configuration did not
need editing. Hashes of all six Windows console/VS Code profile files remained
identical. The normal profile retains a pre-existing suppressed `fnm` discovery
error, reproduced in both 7.6.5 and 7.6.6; it does not prevent startup.

Windows PowerShell **5.1.26100.9444** remains the OS-managed compatibility shell.
PowerShell 7 installs separately; system executables were not redirected.
See [Microsoft's Windows installation guide](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows).

The simulated and applied Ubuntu transaction upgraded only `powershell`, with
no added or removed packages. Complete before/after package versions and manual
package selections confirmed all unrelated packages were preserved. No reboot
or WSL restart was performed.

Selected results are in the [sanitized receipt](../../../machines/pc-philip-windows-2026-09-19/powershell-update.json).
Private download, inventory and validation records remain under
`~/.local/state/dotrepo/powershell-update-2026-09-19/` on each local platform.

## MATLAB in WSL

This inspection preceded the later same-day installation. See the
[MATLAB handoff](2026-09-19-matlab-wsl-install.md) for its current status.

The user also asked whether MATLAB is installed in WSL. This machine's Ubuntu
has no working `matlab` command or installation in the standard locations checked.
An older `~/MATLAB` directory identifies R2026a in `ProductData.json`, but lacks
the `matlab` launcher, the `MATLAB` executable and `VersionInfo.xml`; it is a
partial tree, not a verified runnable installation. No files were removed and no
MATLAB installation or activation was attempted.

The [MATLAB installation guide](../../matlab-wsl-2026-09-07.md) records an
installed and activated **R2026a Update 5 on PhilipSecond**. That is a prior
result on the other machine, not a current local runtime check; its present
state could not be reverified without a connection.

## Finish on PhilipSecond

Windows and WSL SSH configuration contained only GitHub targets. Neither
`PhilipSecond` nor `PhilipSecond.local` resolved, and no saved usable remote
target was found. The earlier account-based remote-host handoff does not provide
an executable transport from this session. No authentication or pairing data
was copied. A reachable existing connection or a session on PhilipSecond is
needed to finish; pulling this commit alone does not upgrade software.

Resume prompt:

```text
Read AGENTS.md and docs/ai/sessions/2026-09-19-powershell-update.md. Verify that
this is PhilipSecond and preserve local changes/jobs. Inventory every Windows
PowerShell 7 installation and every registered WSL distribution. Update installed
stable PowerShell 7 copies to the latest official stable release (7.6.6 as of this
handoff), retaining each installation method and its stable launcher path. For a
portable Windows installation, verify the official archive hash and signature,
validate the new executable, then switch its existing current junction while
retaining the old directory for running sessions. For native Ubuntu APT installs,
simulate a targeted --only-upgrade --no-remove powershell transaction and apply
only the reviewed changes. Keep OS-managed Windows PowerShell 5.1 available.
Verify fresh ordinary-profile launches, pipeline/JSON behavior, unchanged profiles
and unrelated package versions. Record actual results, then commit and push.
```
