# Recover the standard after reinstalling Windows

A Windows reinstall can remove applications and WSL registrations while leaving
user files and an earlier installation under `C:\Windows.old`. Inventory those
locations before installing a fresh Ubuntu distribution or using Windows cleanup.
The [maintenance runbook](windows-wsl-maintenance.md) defines the target setup;
this procedure recovers existing data before applying it.

## Preserve existing environments

Check the current user profile, `C:\dev`, and the corresponding Windows.old user
profile. Look for the native repository, SSH keys, Anaconda environments, portable
Node, VS Code extensions, and application data. Inspect file names and metadata;
keep credentials, package inventories, and raw logs outside Git.

The previous Ubuntu disk may be under either user's
`AppData\Local\wsl\{distribution-guid}\ext4.vhdx`, or an Ubuntu package's
`AppData\Local\Packages\...\LocalState`. Run `wsl --list --verbose` and inspect
existing registrations before choosing a recovery name. Never unregister a
distribution as a repair step: unregistering deletes its managed data.

Copy a recovered VHD to a durable location such as
`C:\WSL\Ubuntu\ext4.vhdx`, with access limited to its owner, SYSTEM, and
Administrators. Verify the destination is absent, enough space remains, the source
is not mounted or changing, and the completed copy has the same size and full
SHA-256 hash. Keep the original until the recovered filesystem and important
workloads have been checked. A VHD header alone does not validate its filesystem.
Do not register an active disk inside Windows.old, which Windows cleanup can remove.

Preserve old DriveFS and Docker disks separately. Do not overwrite a new active
application database with an old database. Google Drive may need a fresh sign-in;
its old offline cache can contain data that still needs recovery.

## Restore Windows tools and configuration

Install missing applications using their verified package-manager manifests.
Restore Git, PowerShell 7, Windows Terminal, and Google Drive early. Use the
existing Anaconda and portable Node installations when they pass version and
workload checks; a full Anaconda installer can overwrite preserved environments.
R packages under the old user's `AppData\Local\R\win-library\4.6` need recovery
separately from reinstalling R itself.

Inspect the repository before pulling. Keep a backup of its local configuration,
preserve any changes, verify the existing SSH identity, then use:

```powershell
git remote set-url origin git@github.com:philipjones77/dotrepo.git
git pull --ff-only origin main
.\bootstrap\install.ps1
```

Recover reviewed VS Code and Terminal preferences from Windows.old before the
bootstrap merge. Apply the editor and viewer settings without importing old
automatic-command-approval settings into a new installation. Bootstrap backs up
replaced files and preserves local Git/SSH identities.

If the previous user policy was `RemoteSigned` and the reinstall reset it to
`Restricted`, restore that specific user policy with
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`. This is separate from
bootstrap and does not override organization policies. Verify all four console
and VS Code PowerShell profiles using the actual Windows Documents location.

Measure physical RAM again. On a 16 GiB host, the September recovery selected
8 GiB WSL memory and 4 GiB swap; the previous 24 GiB memory setting did not fit
that host. Preserve unrelated settings and choose limits for the actual machine.

The standalone Cloud SDK can be recovered from its old user-directory install
along with its private configuration. Set `CLOUDSDK_PYTHON` to a tested surviving
Python executable if the old Store Python alias is gone. Verify TLS with the
current trust configuration before retaining an old custom CA bundle. Norton
repairs from an earlier installation apply only when the same fault is observed;
a Store pinning failure with a valid Microsoft certificate also warrants checking
the installed App Installer version.

Check Windows and Ubuntu clocks against an independent time source before
diagnosing authentication failures. If Windows Time is stopped and the host
clock is wrong, start that service and request `w32tm /resync /rediscover` in
administrator PowerShell, then verify its source/status and the resulting time.
Do not make a correctly synchronized guest match an incorrect host clock.

## Restore the existing Ubuntu disk

In administrator PowerShell, install the runtime without creating another Linux
filesystem:

```powershell
wsl --install --no-distribution
```

If Windows requests a restart, finish all copy/verification and installer jobs,
save work, then restart. Only after the disk copy is verified and the recovery
name is confirmed unused:

```powershell
wsl --import-in-place Ubuntu C:\WSL\Ubuntu\ext4.vhdx
wsl -d Ubuntu --user root --exec getent passwd phili
wsl --manage Ubuntu --set-default-user phili
wsl --set-default Ubuntu
wsl -d Ubuntu --exec id
```

Use the recovered account's actual name. An imported distribution may otherwise
start as root; inspect its existing `/etc/wsl.conf` too. Do not recreate the user,
home directory, or scientific environments when they survived in the disk.
Microsoft documents [installation without a distribution and importing a VHD](https://learn.microsoft.com/en-us/windows/wsl/basic-commands)
and the [Windows feature/restart requirements](https://learn.microsoft.com/en-us/windows/wsl/install).

From the recovered user's Bash session, inspect and fast-forward the independent
native `~/projects/dotrepo` clone, then apply its bootstrap. Verify Bash and the
expected UID, project directories, scientific environments, GitHub SSH, one rclone
Drive mount, and VS Code remote access. A successful Windows runtime installation
does not by itself prove Ubuntu recovery.

Use the Windows VS Code client with Remote WSL. The native bootstrap installs
`~/.local/bin/code`, which discovers that client while keeping Linux tools first
on PATH. Restore extensions separately on Windows and the WSL remote host, then
test a real remote terminal, Python/Jupyter and PDF/image/Markdown viewers.
See the [maintenance runbook](windows-wsl-maintenance.md) for the launcher and
[persistent WSL Drive procedure](wsl-google-drive.md) for the optional Windows
login anchor. A background Linux mount alone may disappear when WSL becomes idle.

## Finish and record

Restore Norton from the existing subscription in [My Norton](https://my.norton.com/),
using a fresh download and a valid Norton/Gen Digital executable signature.
Run LiveUpdate until no updates remain, and record both the installed product
version and the update result. A downloader's file version alone does not prove
the installed protection is current. Norton documents the
[account download procedure](https://support.norton.com/sp/en/us/norton-download-install/current/solutions/kb20090708112600EN).
Restore separately licensed AntiTrack, Utilities Ultimate and Driver Updater
only when the account includes them; do not start a new paid trial to recover an
existing license. Complete required account and browser-extension setup.

After Norton is active, repeat PowerShell 5/7, VS Code automation, GitHub SSH,
Store, Conda/Node HTTPS and both Drive checks. Diagnose a reproduced block using
the current protection history and certificate chain. Keep protection enabled
and retain the conditional [certificate repair guidance](windows-wsl-maintenance.md#certificate-and-norton-repairs-only-for-matching-symptoms).
Review utility cleanup and driver changes separately, preserving the recovered
Windows.old application data and the GPU driver that passed computation tests.

Restore recorded applications sequentially, accounting for both installer working
space and any unfinished disk copy. Keep reboot requirements and disk-space
deferrals explicit. Test real tool execution rather than relying only on an
installer's exit code. Recheck the Store after updating App Installer; do not
disable TLS validation or certificate pinning to make an update succeed.

Retain Windows.old until the required application data has been recovered. Record
the recovered disk location, hashes in private logs, installed versions, tests,
remaining sign-ins, and any reboot requirement in the repository's sanitized
maintenance report. Reopen VS Code and terminals after environment changes.

If space prevents the remaining installations, review the old Ubuntu VHD
separately from the rest of Windows.old. Before deleting that rollback copy,
verify its unchanged full hash against the copy receipt, the active registration
in the durable location, original project history and environment/runtime checks,
and obtain explicit approval for that exact file. Keep the other old application
data and backups until their own recovery checks are complete. Recheck actual
free space before resuming installers.
