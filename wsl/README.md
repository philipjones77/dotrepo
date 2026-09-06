# WSL status, comparison, and migration

From Windows PowerShell in this repository:

```powershell
.\wsl\capture-status.ps1
```

The timestamped output under `wsl/snapshots/` is ignored by Git. It records WSL/Windows versions, RAM, live configuration, Ubuntu packages and APT sources/keys, enabled services, kernel logs, Conda exports and explicit package locks, pip versions and dependency checks, R libraries, standard MATLAB installation locations, VS Code server extensions, and local virtualenvs under the current user's home (depth 6). Mounted storage is excluded. Missing tools are recorded; this does not install MATLAB or other absent software. Other users and project libraries outside the scan need separate captures.

Run the same capture on the other machine, copy its snapshot alongside this one, then compare with Python:

```powershell
python .\wsl\compare-status.py .\wsl\snapshots\MACHINE_A .\wsl\snapshots\MACHINE_B > comparison.diff
```

Reports contain local paths and may include private package URLs; keep them private. Conda explicit locks target the same Linux architecture; the YAML exports also include pip packages. Local editable packages require their original source checkouts. Review YAML `prefix` paths before recreating an environment. An inventory is not a full backup.

For a complete mirror including files and installed applications, save Linux work, then export to a private backup location with enough space:

```powershell
wsl --shutdown
wsl --export Ubuntu D:\Backups\Ubuntu.tar
```

On the destination, install/update WSL, copy the archive, and import under an unused name/location:

```powershell
wsl --update
wsl --import Ubuntu-Mirror C:\WSL\Ubuntu-Mirror D:\Backups\Ubuntu.tar --version 2
wsl -d Ubuntu-Mirror
```

The archive includes private files and credentials; transfer it securely. Windows-side tools and GPU drivers require separate installation. Review `.wslconfig` for destination RAM and CPU capacity. This machine uses `windows/wsl/memory-32gb.wslconfig` (16 GB RAM limit, 24 GB swap, default networking); the older bootstrap profile differs. The imported `/etc/wsl.conf` preserves the default user.

To compact after saving work, run `wsl/compact-ubuntu.ps1` in Administrator PowerShell. Clean package caches and run `sudo fstrim -v /` first. Compaction stops all WSL distributions and records disk sizes and DiskPart output under snapshots. Read the log to verify success.

References: [Microsoft WSL configuration](https://learn.microsoft.com/en-us/windows/wsl/wsl-config), [DiskPart compaction](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/compact-vdisk), [GitHub CLI repository keys](https://github.com/cli/cli/blob/trunk/docs/install_linux.md).
