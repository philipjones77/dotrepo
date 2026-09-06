# Google Drive standard

Windows uses Google Drive for desktop, normally at `G:\My Drive`. WSL uses an
independently authenticated rclone/FUSE mount at `~/mnt/gdrive`. The optional
`/mnt/g` DrvFs path is a compatibility view of the Windows drive; it is not
required for the native WSL mount.

## Windows

Run `windows/google-drive.ps1 -Install` to install Drive if needed, enable its
login startup, and launch it. Sign in through the desktop application once.
The canonical helper preserves the application's certificate trust environment.
See [the topology guide](../../docs/topology.md) for diagnosed certificate issues.

The legacy `cloud/google-drive/mount-windows.ps1` delegates to that helper.
It retains `-Quiet`, `-NoWait`, and `-TimeoutSeconds`; the tracked PowerShell
profile uses `-Quiet -NoWait`. `DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE=0` disables that
profile hook. `DOTREPO_GDRIVE_WINDOWS_DRIVE` selects the drive letter used for
its readiness check, but does not change the desktop app's setting.

## WSL

Install `rclone` and `fusermount3`, and authorize a private rclone remote.
Run `bash wsl/mounts/install.sh` to enable automatic mounting. A marker at
`~/.config/dotrepo/gdrive.enabled` enables the single shared shell startup hook.
The helper's lock prevents duplicate launches, and existing mounts stay active.
`shared/shell/env.sh` only configures environment variables; it starts no mounts.

The canonical commands are:

```bash
bash wsl/mounts/gdrive.sh start
bash wsl/mounts/gdrive.sh status
bash wsl/mounts/gdrive.sh stop
```

The legacy `cloud/google-drive/mount-wsl.sh` delegates to this helper and keeps
its `--quiet` option. No helper requires `/mnt/g` or a Windows Drive session.

Set private machine choices in `~/.config/dotrepo/gdrive.env`:

```bash
DOTREPO_GDRIVE_REMOTE='philip.a.jonesmngoogle:'
DOTREPO_GDRIVE_PATH="$HOME/mnt/gdrive"
# The repository default is read-only. This machine preserves writable access.
DOTREPO_GDRIVE_READ_ONLY=0
DOTREPO_GDRIVE_CACHE_MAX_SIZE=2G
DOTREPO_GDRIVE_CACHE_MAX_AGE=1h
```

`DOTREPO_GDRIVE_RCLONE_REMOTE` and `DOTREPO_GDRIVE_RCLONE_MOUNT` remain supported
aliases; canonical names take precedence. `DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE=0`
disables shell startup mounting when set in the shell environment or
`~/.config/dotrepo/shell.local.sh`.

Read-only mode uses minimal caching. Explicit writable mode uses `writes`
caching, with a default 2 GiB size target and one-hour age target. rclone checks
eviction every minute; open files and pending uploads can exceed these targets.
Changes apply when a new mount starts. Applying configuration does not remount
an active Drive or change its current permissions. See the
[rclone mount documentation](https://rclone.org/commands/rclone_mount/#vfs-file-caching)
for cache behavior.

The legacy audit commands remain available as `cloud/google-drive/audit.ps1`
and `cloud/google-drive/audit.sh`. Their DrvFs checks describe optional compatibility.

Keep rclone credentials, OAuth tokens, caches, private Drive contents and mount
logs outside Git.
