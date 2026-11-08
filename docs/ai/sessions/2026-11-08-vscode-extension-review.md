# VS Code extension review — 2026-11-08

Windows: 51 -> 35 extensions. Ubuntu WSL: 39 -> 33.
Both host CLIs returned `No extension to update` after reconciliation.

Removed unused container/Kubernetes, Django/Live Server, tunnels and speech tools;
duplicate Markdown preview/tree and Git helpers; cosmetic extras; the Windows
copy of the WSL Python selector; the WSL C++ pack wrapper/themes; and Auto Reload.
Kept Python, SSH/WSL, AI tools, Lean, LaTeX/Sumatra, Markdown, GitHub and research
language support. Preserved WSL Jupyter/Colab/R and native C++/CMake tooling.
Added the missing WSL MATLAB extension for the installed native MATLAB workflow.

WSL updates: Ruff 2026.86.0 -> 2026.94.0; Antigravity 1.7.0 -> 1.11.0;
LaTeX Workshop 10.19.0 -> 10.20.0; R 3.0.1 -> 3.2.2;
C/C++ 1.34.4 -> 1.35.6. Windows was already current.
Restored Remote Explorer and individual C++/CMake members after pack removal.
Codex startup timeout remains 180 seconds on both hosts.

## Disk changes and editor refresh

Use VS Code's built-in file watching: saved, unmodified text buffers reload
external disk changes automatically. Unsaved changes are retained; save conflicts
explicitly use `files.saveConflictResolution: askUser` on both hosts. Auto Save
is a separate feature and was not enabled as a substitute for disk refresh.
Removed `sebastian-lay.auto-reload`: its implementation polls selected files and
calls `workbench.action.files.revert` without checking whether they have unsaved edits.
Existing workspace exclusions for caches/generated data remain to preserve memory.
No watcher/ENOSPC errors were found in the current Windows/WSL session logs.
WSL inotify limits: 524288 watches and 128 instances. These are configuration and
log checks, not an end-to-end visual test of every currently open buffer.

Reference: https://github.com/microsoft/vscode/wiki/File-Watcher-Internals

## Replication and activation

The two extension manifests now reflect the retained Marketplace extensions.
Locally packaged dotrepo extensions remain managed by their existing installers.
Extension update checking and automatic updates are explicitly enabled in both
live settings and tracked settings. Bundled optional extensions can reappear after
pack installation; review installed IDs after bootstrap or major extension updates.
No active editor/WSL process was restarted. Reload VS Code windows when current
work permits to finish unloading removed extensions and activate updates.

Local rollback/audit evidence (settings backups, before/after inventories, logs):
`C:\Users\phili\.local\state\dotrepo\vscode-audit-2026-11-08`.
## PhilipSecond handoff

On PhilipSecond, preserve local changes first, then fetch and fast-forward main:

```powershell
cd C:\dev\dotrepo
git status --short
git fetch origin
git pull --ff-only origin main
```

If the checkout is dirty or diverged, preserve and reconcile those changes before
pulling; do not reset or overwrite them. Read this review and the sibling
`2026-11-08-wsl-environments-hardware-aware-handoff.md` before applying changes.

Inventory Windows and every WSL VS Code extension host separately. Use the two
tracked extension manifests as the baseline, retain genuinely machine-specific
project requirements, and remove the redundant categories described above.
Installing the manifests alone does not remove old extensions, and packs may
reinstall optional members. Preserve locally packaged dotrepo extensions and
verify required SSH, Python, Jupyter, R, MATLAB, Lean and native build tools after
pack removal. Use the current machine's matching code-server binary for WSL;
Windows `code --update-extensions` alone does not update that server.

Update both hosts to their latest compatible Marketplace versions; do not pin
them to this source machine's recorded versions. Merge the three new settings
from the tracked settings files into existing live settings without replacing
machine-specific paths. Retain built-in disk refresh and unsaved-edit protection.
Run `node scripts/extend-codex-webview-timeout.cjs --apply` after Codex updates.
Verify each host returns `No extension to update`, save final inventories, and
reload editor windows only when active work permits. This extension handoff does
not change CUDA, GPU drivers, Python environments or hardware settings.

Direct notification from PC-PHILIP-WINDOWS was attempted on November 8 but SSH
could not resolve the configured PhilipSecond hostname. Repository publication
is the handoff; receipt/application on the other machine is not yet verified.
