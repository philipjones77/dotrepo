# Session Capsule: LaTeX Workshop PDF viewer conflict

Date: 2026-09-20 (America/Chicago).
Repo: dotrepo. Branch: `main`.
Machine: **PC-PHILIP-WINDOWS**, Windows and Ubuntu under WSL 2.
Primary tool: Codex.

## Goal and current status

Resolve LaTeX Workshop's warning that it competes with `vscode-pdf` when
opening PDFs from the Explorer sidebar. The conflicting extension
`tomoki1207.pdf` 1.2.2 was uninstalled from both Windows and the native WSL
VS Code server. LaTeX Workshop remains installed: 10.19.0 on Windows and
10.18.0 in WSL. Both installed manifests declare `latex-workshop-pdf-hook`
as their PDF editor.

Windows user settings and WSL server Machine settings now associate `*.pdf`
with `latex-workshop-pdf-hook`. Every unrelated setting was preserved.
Private settings backups remain beside the Windows settings file as
`settings.json.before-latex-pdf-fix-20260920-144807.bak` and under
`~/.local/state/dotrepo/latex-pdf-fix-20260920-150827/` in WSL.

## Repository changes

- `vscode/windows/extensions.txt`: remove `tomoki1207.pdf` so bootstrap no
  longer installs the conflicting viewer.
- `vscode/windows/settings.json` and `vscode/wsl/settings.json`: select
  LaTeX Workshop's PDF editor.
- `docs/windows-wsl-maintenance.md`: replace the old viewer installation
  instruction and explain removal of existing conflicting installations.

Historical inventories and handoffs retain their original records. The native
WSL repository checkout was not modified; its live VS Code settings were fixed
directly. No other machine was changed.

## Commands and verification

- Windows `code --uninstall-extension tomoki1207.pdf` and the installed WSL
  server's `bin/code-server --extensions-dir ~/.vscode-server/extensions
  --uninstall-extension tomoki1207.pdf` both succeeded.
- Both CLIs' `--list-extensions --show-versions` output confirms LaTeX Workshop
  is installed and `tomoki1207.pdf` is absent.
- Windows and WSL settings readback and comparison against backups passed:
  the PDF editor association is the only content change.
- Both repository settings files parse as JSON and select the verified editor.
- `node scripts/repair-chat-file-links.cjs --self-test` passed. The helper uses
  generic `vscode.open`, so no viewer-specific helper change was required.
- `git diff --check` passed for the changed files.

## Remaining steps and target handoff

Run **Developer: Reload Window** in existing Windows and WSL VS Code windows,
then open a PDF from Explorer. No editor session was restarted automatically;
visual PDF rendering and disappearance of the warning remain untested.

On another machine, verify its hostname and preserve local edits. Apply the
updated settings and explicitly disable or uninstall `tomoki1207.pdf` in
Windows and any WSL extension host where it is installed. Bootstrap installs
listed extensions but does not uninstall IDs removed from the list. Pulling
these files alone does not apply settings or remove extensions.

Resume prompt:

```text
Read docs/ai/sessions/2026-09-20-latex-pdf-viewer.md. Verify the target hostname
and inspect its local settings and extensions. Keep LaTeX Workshop, remove or
disable tomoki1207.pdf wherever installed, and set the *.pdf editor association
to latex-workshop-pdf-hook while preserving other settings. Back up live files,
verify both Windows and WSL, and record this machine's actual results.
```
