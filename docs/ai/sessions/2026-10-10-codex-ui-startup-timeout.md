# 2026-10-10 Codex "could not start its user interface"

Machine: PC-PHILIP-WINDOWS. Primary tool: Claude Code.

## Symptom

The Codex sidebar (`openai.chatgpt`) shows *"Codex could not start — The
extension could not start its user interface"*, in both Windows VS Code and
WSL remote windows, shortly after a window opens or reloads.

## Evidence

`Codex.log` records the same error each time:

```
[CodexWebviewProvider] Webview renderer did not become ready elapsedMs=30010
reason=renderer_ready_timeout role=sidebar timeoutMs=30000
```

| Where | When | Codex version |
| --- | --- | --- |
| WSL server | 2026-10-03 10:33 | 26.930.31730 |
| WSL server | 2026-10-04 05:42 | 26.930.41038 |
| WSL server | 2026-10-10 06:32 | 26.1007.21434 |
| Windows window4 | 2026-10-10 07:02 | 26.1007.21434 |

The Windows window4 timeline (`%APPDATA%\Code\logs\20261010T055525\window4`):
the restored Codex sidebar activated Codex at 07:01:11, then the extension host
was reported unresponsive from 07:01:18 to 07:02:18 while about 40 other
extensions activated (Copilot Chat, Claude Code, Antigravity, Python/Pylance,
Lean, git, markdown and others). The webview missed its deadline.

## Cause

Codex 26.1007.21434 `out/extension.js` gives the webview a hard-coded 30 s
(`3e4`) to report `renderer_ready`. On timeout it replaces the webview HTML
with a static error page and never retries. The views are registered with
`retainContextWhenHidden`, so closing and reopening the sidebar does not
rebuild them. This is a startup race, not a damaged install, and it recurs
across Codex releases. `scripts/repair-chat-file-links.cjs` was ruled out: it
only patches the pinned 26.901.22334 build.

## Fix applied

Local extension [`dotrepo.codex-startup-guard`](../../../vscode/codex-startup-guard/README.md)
is installed into Windows VS Code and the WSL server
(`~/.vscode-server/extensions`) by
`windows/install-codex-startup-guard.ps1`. It runs in the same extension host
as Codex, watches that session's `Codex.log`, and on a new timeout offers
**Restart Extension Host** / **Reload Window**. Set
`dotrepo.codexStartupGuard.recovery` to `restartExtensionHost` for automatic
recovery (at most once per 10 minutes).

Verified: unit tests, VSIX packaging, and installation on both sides. Not yet
seen in a live recovery; check the "Codex Startup Guard" output channel after
the next occurrence.

## Reducing occurrences

- Keep the Codex sidebar closed when closing a window; it then loads on demand
  after startup instead of during the activation burst.
- Fewer startup-activated extensions shorten the burst (104 Windows extension
  folders; `github.remotehub` and `vscode-pull-request-github` require VS Code
  1.141 and fail to load on 1.140).
- WSL has `memory=8GB`; about 5.3 GB was in use during the check (see the
  [September 23 WSL memory handoff](2026-09-23-wsl-memory-disconnects.md)).

## PhilipSecond

Pull, then run `pwsh -File windows\install-codex-startup-guard.ps1` and reload
windows. Open a WSL window once first so the WSL server exists.
