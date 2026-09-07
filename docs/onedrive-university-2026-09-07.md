# University of Arizona OneDrive restoration — September 7, 2026

The University of Arizona account is configured in Microsoft OneDrive using its
default folder, `C:\Users\phili\OneDrive - University of Arizona`. University
sign-in completed interactively. The optional Desktop/Pictures backup step was
skipped so the existing Windows personal-folder locations stayed in place.

OneDrive was restarted in background mode after the account correction. Its
University folder is readable and nonempty, and the same folder is visible from
WSL at `/mnt/c/Users/phili/OneDrive - University of Arizona`. Microsoft OneDrive
was enabled through **Windows Settings → Apps → Startup** at 18:57:29 Central;
the UI toggle and Windows startup approval both confirm it is enabled. Complete
cloud synchronization and offline availability of every file were not asserted.

The mistakenly linked Personal account used
`C:\Users\phili\OneDrive\Documents\thesis\OneDrive`. It was disconnected through
OneDrive's **Account → Unlink this PC → Unlink account** interface. A blank
settings window required a normal OneDrive application restart; no account reset
or authentication-store deletion was used. Opening **Settings** from the exact
Personal folder's Windows shell context menu provided a reliable account-specific
entry point. Microsoft's [account-removal instructions](https://support.microsoft.com/en-us/onedrive/how-to-remove-an-account-in-onedrive)
describe the same unlink operation and its local/cloud-file behavior.

After unlinking, Personal's configured `UserFolder` was empty and its Windows sync
registration was absent. OneDrive retained a cached email address; that alone was
not treated as an active connection. The University registration remained under
`HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\SyncRootManager`.

The user explicitly requested deletion of the mistaken nested folder. Before
deleting it, its resolved absolute path and all parent directories were verified,
and registry checks excluded an active sync root at, above or below the target.
Three OneDrive-specific known-folder paths were backed up and restored through
Windows' `SHSetKnownFolderPath` API:

| Known folder | Restored existing location |
| --- | --- |
| OneDrive | `C:\Users\phili\OneDrive` |
| OneDrivePictures | `C:\Users\phili\OneDrive\EMS Cetificates\Pictures` |
| OneDriveCameraRoll | `C:\Users\phili\OneDrive\EMS Cetificates\Pictures\Camera Roll` |

The ordinary Desktop, Documents and Pictures settings were preserved. The nested
folder was deleted locally at **18:53:12 Central** and verified absent; the outer
thesis directory and University folder were verified present. No cloud deletion
request was made.

## Repeat on another Windows machine

1. Open Microsoft OneDrive and add the university work or school account.
   Complete the university's normal sign-in/MFA prompts.
2. Keep the folder offered by setup:
   `%USERPROFILE%\OneDrive - University of Arizona`. The email belongs on the
   sign-in screen; no custom folder name is needed. If setup finds that existing
   folder, reuse it only for the same university account.
3. Skip optional personal-folder backup unless that additional redirection is
   wanted. Verify the University account and folder in OneDrive's Account page.
4. Enable Microsoft OneDrive in Windows Startup Apps when it should sync after
   signing in to Windows. Check the blue university cloud icon for sync progress;
   configured account records alone do not prove that all files have finished
   syncing.
5. WSL accesses the Windows folder through
   `/mnt/c/Users/<Windows-user>/OneDrive - University of Arizona`. Quote this path
   in Bash. Windows OneDrive manages the account and synchronization; this does
   not require another Linux OneDrive client.

Microsoft documents the [account setup](https://support.microsoft.com/en-us/onedrive/how-to-add-an-account-in-microsoft-onedrive)
and [default folder selection](https://support.microsoft.com/en-us/onedrive/sync-your-computer-s-files-and-folders-with-onedrive).
The explicit cleanup above concerned this machine's mistaken nested directory;
it is not a generic deletion step for other machines.

Private receipts and known-folder backups are under
`C:\dev\dotrepo\.local\wsl-python-parity-20260907\`:

- `personal-onedrive-unlink-result.json` records the account-specific unlink.
- `onedrive-folder-correction\result.json` records the completed local deletion.
- `onedrive-folder-correction\user-shell-folders-before.json` and
  `user-shell-folders-after.json` record the narrow shortcut repair.
- `onedrive-startup-toggle-result.json` and
  `university-onedrive-startup-result.json` record normal background launch,
  readable University storage and the supported Startup Apps toggle.

Authentication data is not copied into this repository.
