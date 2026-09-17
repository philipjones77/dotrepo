# PC-PHILIP-WINDOWS AI settings, September 16

The [session handoff](../../docs/ai/sessions/2026-09-16-pc-philip-windows-ai-settings.md)
records the settings applied to match PhilipSecond after pulling dotrepo.

- [Windows Codex](codex-windows-settings.json) and [WSL Codex](codex-wsl-settings.json):
  full-access defaults, preserved unrelated settings and configuration checks.
- [Codex remote host](codex-remote-host.json) and its
  [systemd user unit](dotrepo-codex-remote-host.service): enabled, running and
  connected using this machine's existing WSL sign-in.
- [Claude](claude-settings.json): Windows/WSL Code permissions and remote-control
  startup, plus the existing desktop account's bypass-mode preference.
- [Antigravity](antigravity-settings.json): Windows Hub/IDE and native WSL Hub
  full-access preferences, remote-control setting, disabled telemetry plugin and
  checks against installed schemas.
- Final reads of the live [Windows](live-settings-check-windows.json) and
  [WSL](live-settings-check-wsl.json) configuration files: all 17 and 18 selected
  preference checks passed respectively.

These receipts omit credentials, account identifiers, pairing codes and raw
configuration. Desktop preferences load on application launch; active sessions
were preserved. Codex phone pairing and second-device control remain untested.
