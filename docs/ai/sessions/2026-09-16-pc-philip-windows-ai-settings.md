# PC-PHILIP-WINDOWS: match the other machine's AI settings

Date: 2026-09-16 (America/Chicago). Host: **PC-PHILIP-WINDOWS**.

The user requested pulling dotrepo and making Antigravity, Claude and ChatGPT's
local agent settings match the other machine. Windows and native Ubuntu
checkouts were fast-forwarded to `2343f28`, including the
[PhilipSecond access handoff](2026-09-15-philipsecond-ai-access-remote.md).
That handoff supplies the requested local permissions and remote-control defaults.

## Applied settings

| Application | Result |
| --- | --- |
| Codex, Windows and WSL | Root `approval_policy="never"` and `sandbox_mode="danger-full-access"` in each user's `~/.codex/config.toml` |
| Claude Code, Windows and WSL | `permissions.defaultMode="bypassPermissions"`, `sandbox.enabled=false`, `sandbox.allowUnsandboxedCommands=true`, `remoteControlAtStartup=true` |
| Claude Desktop | Existing local account's Allow bypass permissions mode preference enabled |
| Antigravity, Windows Hub/IDE and native WSL Hub | Terminal Always Proceed, artifact review Always Proceed, agent terminal sandbox off, non-workspace/ignored-file and network access allowed, secure mode off, Remote Control on |

Antigravity's Windows settings use `autoExecutionPolicy=3` and
`artifactReviewMode=2`. The installed native WSL Hub also uses
`permissionPreset="AGENT_PERMISSION_PRESET_TURBO"` for its newer permission
system. Each installed language server's schema accepted the corresponding
fields and enums. The Windows IDE shares the default Gemini configuration
directory with the Hub; unrelated IDE profile settings were preserved.
The `googlecloudtools.datacloud_telemetry` plugin registration is explicitly
disabled on both platforms. No plugin payload was present to move.

Full configuration backups stay private under each user's
`~/.local/state/dotrepo/`. Only selected settings and sanitized validation results
are committed. Existing models, plugins, permission lists, unrelated preferences
and authentication were preserved. The desktop Claude change loads on its next
launch; new code-agent sessions load their user defaults. Existing sessions may
retain their own mode or overrides. No active application session was restarted.
Antigravity likewise loads the saved values on its next launch. Windows had no
existing Hub config or machine nickname, so only the selected settings were
created. The existing WSL nickname and both project files were preserved; those
projects had no permission overrides.

These settings concern the local code agents. They do not change ordinary hosted
web-chat permissions, account policies or Windows/UAC permissions.

## Codex remote host

The native WSL CLI **0.153.4** was already signed in. Its user service
`dotrepo-codex-remote-host.service` is now enabled and running. The CLI emitted
`status="connected"`, with this machine's hostname and `timedOut=false`.
The source machine's credentials and device pairing data were not copied.

The [service unit](../../../machines/pc-philip-windows-2026-09-16/dotrepo-codex-remote-host.service)
uses the installed `~/.local/bin/codex remote-control --json` command and restarts
on failure. Read-only checks from WSL:

```bash
systemctl --user is-enabled dotrepo-codex-remote-host.service
systemctl --user is-active dotrepo-codex-remote-host.service
```

WSL and Windows must remain running for this host to be available. Phone pairing
and a second-device session have not been tested. The desktop pairing flow is
separate: ChatGPT Settings > Connections > Control this PC > Set up or Add,
then complete the QR-code/account verification flow on the phone. See
[OpenAI remote connections](https://learn.chatgpt.com/docs/remote-connections).

Claude's new-session auto-connect preference is configured. Its native WSL CLI
accepted the Remote Control help command; no extra Claude session was created
just to test the preference. Existing sessions can use `/remote-control`.
Antigravity Remote Control is enabled in both saved configurations; a second-device
connection has not been tested. Use each application's own account on that device.

## Verification and evidence

- Codex TOML parse/readback and exact preservation of unrelated settings passed
  on both platforms. Both installed CLIs accepted the resulting configuration
  through `codex features list`; no model request was made.
- Claude JSON readback and unrelated-field preservation passed. Installed app
  schemas confirmed all selected keys, including the existing account's desktop
  bypass preference. The desktop toggle was not checked visually.
- Codex remote-host systemd unit verification passed. Its service was enabled,
  active/running, with zero restarts and a connected event at capture.
- Antigravity selected-field readback and protobuf schema checks passed for the
  Windows Hub, Windows IDE and WSL Hub. Existing WSL project-file hashes and
  unrelated settings were preserved. Application UI readback remains untested.
- Final independent reads of the three applications' live configuration files
  passed all 17 Windows and 18 WSL preference checks.

The [machine capsule](../../../machines/pc-philip-windows-2026-09-16/README.md)
links the individual receipts and records the remaining verification limits.
Private backups support restoring the original files after saving active work;
the service can be stopped with
`systemctl --user disable --now dotrepo-codex-remote-host.service`.

References: [OpenAI configuration](https://developers.openai.com/codex/config-reference),
[Claude settings](https://code.claude.com/docs/en/settings),
[Claude Remote Control](https://code.claude.com/docs/en/remote-control), and
[Claude Desktop](https://code.claude.com/docs/en/desktop),
[Antigravity agent settings](https://antigravity.google/docs/agent-settings), and
[Antigravity Remote Control](https://antigravity.google/docs/remote-control/).
