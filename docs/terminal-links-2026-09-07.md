# Terminal links and PowerShell

## Shared policy

Use the latest supported stable PowerShell 7 for maintained Windows automation:
`pwsh.exe`, not the OS-owned Windows PowerShell 5.1 `powershell.exe`.
Keep Windows PowerShell, its ISE and vendor-specific legacy tools available for
compatibility. Do not redirect or replace Windows system executables.

The tracked Windows VS Code profile and automation profile resolve `pwsh.exe`
through PATH. Put machine-specific absolute paths in local overrides, not shared
repository settings. Portable installations should expose a stable `current`
path; MSI installations use their stable installation directory. Resolve an
absolute executable path when registering scheduled or logon actions, whose
environment may differ from an interactive terminal. Refresh registrations if
the installation location changes. Never silently fall back to 5.1.

Retain Bash defaults in Linux/WSL workspaces. Terminal application updates,
PowerShell updates, shell profiles and repository launchers are separate things.
Check installed versions against the stable release before upgrading; do not
install a second PowerShell merely because WinGet does not list a portable copy.
See [Microsoft's installation guide](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows)
and [Windows Terminal documentation](https://learn.microsoft.com/en-us/windows/terminal/install).

## Verified on PC-PHILIP-WINDO, 2026-09-07

This is the current machine, not the separate PhilipSecond source inventory.

- Windows PowerShell 7.6.5 uses
  `C:\Users\phili\.local\powershell\current\pwsh.exe`; `current` is a junction
  to the 7.6.5 installation. Native Ubuntu `/usr/bin/pwsh` also reports 7.6.5.
- WinGet offered PowerShell 7.6.5.0 and Windows Terminal 1.24.11911.0, matching
  the installed versions. No application reinstall was necessary.
- Inspected `C:\dev\data77`, `dotrepo`, `references`, `thesis`, and the
  `diagrams-and-figures` workspace folder (the latter is not a Git checkout).
  Data77 and diagrams had no shell-launcher changes to make.
- Updated thesis task, build-recipe, clean, PDF viewer and inverse-search
  launchers to `pwsh.exe`. Its six fake-TeX build integration tests passed under
  PowerShell 7, including failure propagation and cleanup boundaries.
- Updated the shared VS Code profile, Drive helper and references scheduled-task
  registration helper. No existing `References Unblock Files` task was found;
  none was created or run during this audit.
- The active user VS Code profile already used the stable PowerShell path.
  Updated the desktop administrator shortcut, Anaconda PowerShell shortcut and
  Anaconda Terminal profile. Anaconda activation under PowerShell 7 succeeded
  and reported Conda 26.7.2. Its explicit launcher uses `-NoProfile` to avoid
  activating a different Python environment through the general shell profile.
- Updated the existing Drive logon command without restarting its running
  process. The change applies on its next launch. Ubuntu remains the Terminal
  default; Cmd, ArcGIS and vendor-generated Visual Studio shells are preserved.
- Inspected Windows desktop, Start Menu and Quick Launch shortcuts. OS-owned
  PowerShell/ISE and vendor compatibility shortcuts deliberately remain legacy.
- Inspected WSL workspace/editor settings under `/home/phili/projects`, including
  production workspace copies. No matching legacy Windows shell override was
  found there; Bash defaults remain. The remote PowerShell extension selects
  `/usr/bin/pwsh`. This is not an audit of every script or third-party dependency
  in every WSL project, nor of repositories on other machines.
- Six relevant PowerShell scripts parsed without errors; five edited/active
  JSON or JSONC configurations parsed successfully. A refreshed machine/user
  PATH resolves PowerShell 7.6.5 and Java 21.0.12.1.

User-setting, shortcut and Drive logon-value backups are in
`C:\Users\phili\.dotrepo-backups\20260907-092006-terminal-links`.
Restore individual backups only after comparing subsequent changes. No user
terminals, editors, drive mounts or builds were stopped. Existing processes
must be closed/reopened normally to inherit updated PATH values. Actual GUI
click-through, elevated launches, a new logon and full thesis compilation were
not exercised by these checks.

Some workspace folder references still point to absent or platform-specific
locations (for example Windows `../RandomFields77`). They were not guessed or
rewritten as part of the shell update.
