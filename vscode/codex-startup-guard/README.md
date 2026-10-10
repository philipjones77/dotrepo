# Codex startup guard

Local, dependency-free VS Code extension (`dotrepo.codex-startup-guard`) for the
recurring Codex error *"Codex could not start — The extension could not start
its user interface."*

## Cause

The Codex extension (`openai.chatgpt`) gives its sidebar webview a fixed 30 s
to report `renderer_ready`. When the sidebar is restored at window start, Codex
activates first and then waits behind ~40 other extensions that activate at the
same time; the extension host is repeatedly "unresponsive" for 20–30 s. The
deadline expires, Codex writes `renderer_ready_timeout` to its `Codex.log`,
replaces the webview with a static error page and never retries. Because the
view uses `retainContextWhenHidden`, hiding and reopening it does not help;
only a new extension host (or window reload) rebuilds it.

Seen on Windows and in WSL remote windows across Codex 26.930.x and
26.1007.21434 (see `docs/ai/sessions/2026-10-10-codex-ui-startup-timeout.md`).

## Behaviour

The guard runs in the same extension host as Codex (`extensionKind`
`workspace` first, so WSL windows load it on the WSL server). It polls the
current session's `openai.chatgpt/Codex.log` and, on a new timeout line, offers
**Restart Extension Host** or **Reload Window**. Handled lines are remembered so
a restart that appends to the same log does not trigger again.

Setting `dotrepo.codexStartupGuard.recovery`: `prompt` (default),
`restartExtensionHost` (automatic, at most once per 10 minutes; interrupts
running chats in other extensions), or `off`.

## Install

```powershell
pwsh -File C:\dev\dotrepo\windows\install-codex-startup-guard.ps1
```

This packages the VSIX, installs it into Windows VS Code and into the WSL VS
Code server. Reload open windows afterwards. Test: `node test-timeouts.cjs`.
