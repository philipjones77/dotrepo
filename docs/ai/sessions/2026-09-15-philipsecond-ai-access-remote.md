# PhilipSecond: AI access and remote-control handoff

The user requested full local access without sandboxing for Antigravity, Claude
and the local OpenAI agent, followed by remote-control enablement and a GitHub
handoff. These are machine-local changes on **PhilipSecond**. Pulling this report
on another machine does not change that machine's permissions or sign it in.

## Access settings applied

| Application | Settings |
| --- | --- |
| Antigravity | Terminal execution Always Proceed (`autoExecutionPolicy=3`); artifact review Always Proceed (`artifactReviewMode=2`); terminal sandbox off; non-workspace and ignored-file access allowed; network access allowed; secure mode off |
| Claude Code, Windows and WSL | `permissions.defaultMode="bypassPermissions"`; `sandbox.enabled=false`; `sandbox.allowUnsandboxedCommands=true` |
| Claude Desktop | Existing account's Allow bypass permissions mode toggle enabled |
| Codex, Windows and WSL | Root `approval_policy="never"` and `sandbox_mode="danger-full-access"` in `~/.codex/config.toml` |

The Claude settings are in `~/.claude/settings.json`. Existing permission lists,
plugins, project settings and runtime configuration were preserved. Antigravity's
existing thesis project has no overrides and inherits its global settings.
New sessions/restarting the applications load these changes; an existing session
may retain its selected mode. Windows/UAC and organization policies still apply.
This record concerns local code agents, not ordinary web-chat permissions or an
attempt to remove a hosted service's isolation.

## Remote control

- **Claude Code:** `remoteControlAtStartup=true` in both Windows and WSL user
  settings. The installed WSL Claude 2.1.263 accepted `remote-control --help`,
  whose startup checks require an eligible signed-in account. New interactive
  sessions auto-connect. For an already-open session, use `/remote-control`;
  connect from `https://claude.ai/code` using the same account. A separate remote
  session was not created just for this configuration change.
- **Antigravity:** `userSettings.remoteControlEnabled=true`, retaining the
  existing machine nickname. Restart the desktop app and use the Remote Control
  Dashboard linked from the official guide with the same Google account.
  Browser-to-host connection was not tested from a second device.
- **Codex:** installed official standalone CLI 0.154.0 using the installer
  recommended by the app-bundled CLI. Its managed package is under
  `~/.codex/packages/standalone/current`; the installer adds its Windows launcher
  directory to user PATH. Native Windows CLI startup failed with Job Object
  detachment and local-socket privacy errors. The attempted Windows scheduled
  task `Dotrepo-Codex-RemoteControl` is disabled.
  WSL CLI 0.153.4 successfully connected as `PhilipSecond`. Its persistent user
  service is `dotrepo-codex-remote-host.service`, enabled for the WSL user manager.
  The [unit](../../../machines/philipsecond-2026-09-14/dotrepo-codex-remote-host.service)
  starts the authenticated CLI in foreground mode and restarts it on failure.
  WSL and the computer must remain running; iPhone pairing is not yet tested.

## Connect from iPhone

- **ChatGPT:** the documented desktop flow is Settings > Connections > Control
  this PC > Set up (or Add). Scan the displayed QR code using the iPhone and
  finish setup with the same ChatGPT account and workspace. The host then
  appears under Remote. This desktop pairing flow is separate from the verified
  WSL CLI connection; phone pairing remains a user step.
- **Claude:** sign into the Claude iPhone app with the same account and open
  Code. An active remote-enabled Claude Code session should appear there;
  existing terminal sessions can enable it with `/remote-control`.
- **Antigravity:** open <https://antigravity.google.com/> in Safari, sign in with
  the desktop Google account, and choose `philipsecond-super-vertex`. Restart
  the desktop app if it has not loaded the new remote-control setting.

On another computer, pull this handoff, verify its own settings, and authenticate
locally. Do not copy this machine's credentials or device pairing data.

## Antigravity telemetry repair

Node.js 24.20.0 was already installed under `~/.local/nodejs/current`, but only
the PowerShell profile exposed it. Its folder was added to persistent Windows
user PATH. The telemetry hook was first corrected and tested with empty input:
exit 0 and `{"decision":"allow"}`. At the user's subsequent request, the
`googlecloudtools.datacloud_telemetry` registration was disabled and its folder
was moved outside the plugins directory to `~/.gemini/disabled-plugins`.
It remains disabled; application restart clears a previously loaded hook.

## Evidence and rollback

The [sanitized receipt](../../../machines/philipsecond-2026-09-14/ai-access-remote.json)
records selected settings only. Full configuration backups are private under
`~/.local/state/dotrepo/antigravity-access-*`, `claude-codex-access-*` and
`remote-control-*`; telemetry backups are also in `~/.gemini/disabled-plugins`.
Do not copy authentication files, raw app configurations, account identifiers,
pairing codes or remote-session URLs into Git.

Sources: [Claude settings](https://code.claude.com/docs/en/settings),
[Claude Remote Control](https://code.claude.com/docs/en/remote-control),
[Antigravity Windows agent settings](https://antigravity.google/docs/agent-settings),
[Antigravity Remote Control](https://antigravity.google/docs/remote-control/), and
[OpenAI configuration reference](https://developers.openai.com/codex/config-reference),
and [OpenAI remote connections](https://learn.chatgpt.com/docs/remote-connections).
Codex remote-control commands were verified against the installed CLI help.
