# Keep the WSL Google Drive mount available

The shared Bash startup mounts Google Drive when WSL starts. Windows may stop an
idle WSL session after its foreground commands exit, taking the mount with it.
The optional Windows login anchor keeps the canonical Linux helper running so
Explorer can continue accessing `\\wsl.localhost\Ubuntu\home\phili\mnt\gdrive`.

First restore the native Linux clone, `~/.dotrepo`, and the existing user's
separately authenticated rclone configuration. Configure the mount mode in
`~/.config/dotrepo/gdrive.env` as described in the
[maintenance runbook](windows-wsl-maintenance.md). The anchor does not copy
credentials or change the Linux mount's read/write and cache settings.

From Windows PowerShell, substituting the actual distribution and Linux user:

```powershell
.\windows\wsl-google-drive.ps1 -Action EnableAtLogon -Distribution Ubuntu -LinuxUser phili
.\windows\wsl-google-drive.ps1 -Action Status -Distribution Ubuntu -LinuxUser phili
```

`EnableAtLogon` backs up all existing per-user Run values under
`~/.dotrepo-backups`, registers this helper at its current repository path, and
starts it in a hidden window. A named mutex allows only one Windows anchor for
that user and distribution in the current Windows login session; the Linux
helper also locks mount creation and stopping across sessions. Startup
errors are recorded in `%LOCALAPPDATA%\dotrepo\logs\wsl-google-drive.log`.
Keep the repository at that path, or rerun `EnableAtLogon` after moving it.

Use `Start` to launch the anchor without registering it. To remove automatic
startup, use `DisableAtLogon`; to unmount the current Drive and let its anchor
exit, use `Stop`. Stop waits for the previous anchor to release its mutex before
returning, so an immediate subsequent Start can take ownership. This usually
takes at most the Linux helper's 30-second polling interval; a 45-second timeout
reports an error if the anchor has not exited. Normal Windows shutdown and explicit `wsl --shutdown` still
stop WSL. After an explicit WSL shutdown, run `Start` again if needed.

This is separate from Windows Google Drive for desktop and its account sign-in.
