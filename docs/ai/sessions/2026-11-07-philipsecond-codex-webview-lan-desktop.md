# 2026-11-07 PhilipSecond: Codex webview deadline, LAN SSH/VNC check

Machine: **PHILIPSECOND** (login `phili`). Primary tool: Claude Code. The user
reported that SSH and VNC "do not work" on this PC and asked for a fundamental
fix for *"Codex could not start — The extension could not start its user
interface"*.

## LAN SSH and desktop: what was actually broken

Verified working, no changes made:

- `sshd` (Win32-OpenSSH 10.0p2 MSI in `C:\Program Files\OpenSSH`) is Automatic
  and running and accepts connections on 127.0.0.1, ::1 and the LAN address.
  `netstat` shows the IPv4 listener as `CLOSED` while IPv6 shows `LISTENING`;
  this is a display quirk of that build, connections succeed.
- `ssh pc-philip-lan hostname` returns `PC-PHILIP-WINDOWS`, and the reverse
  check run from that PC (`ssh philipsecond-lan hostname`) returns
  `PhilipSecond`. Keys, `known_hosts` and `config.local` are unchanged.
- An SSH local forward to the peer's `127.0.0.1:5900` answers `RFB 003.008`,
  so the TightVNC path through the tunnel is intact. TightVNC here still
  listens on loopback only.

Broken and fixed:

- The OneDrive desktop shortcut **Other PC Desktop** had been repointed to an
  untracked `ssh/start-vnc-tunnel.ps1` with a fixed local port 5901, the
  Program Files SSH client, no strict host checking and a hidden window that
  swallowed every error. The shortcut now runs the deployed launcher again
  (`%LOCALAPPDATA%\dotrepo\lan-desktop\open-lan-desktop.ps1`, SHA-256
  `141318D1…9411`, identical to `windows/open-lan-desktop.ps1`). The old
  shortcut and script were moved to `%LOCALAPPDATA%\dotrepo\lan-desktop\backup`.

Pending, needs an elevated shell (the UAC prompt was declined during the
session):

- The firewall drifted from the agreed posture: the MSI-created rule
  *OpenSSH SSH Server Preview (sshd)* allows TCP 22 from **Any** remote address
  (Private profile), and the installer-created *TightVNC* rule is **enabled**
  for any profile and port (harmless only because `tvnserver` is loopback-only).
  Run once from PowerShell **as administrator**:

  ```powershell
  pwsh -File C:\dev\dotrepo\ssh\harden-lan-firewall.ps1
  ```

  It saves the previous rule state under `C:\ProgramData\dotrepo\backups`,
  limits the Preview rule to `LocalSubnet`, and disables the TightVNC rule.
- This PC now has two OpenSSH installations: the MSI build runs the service;
  the Windows capability build (9.5p2) remains in `System32\OpenSSH` and is
  still the client the launcher uses. Both work; do not remove either without
  re-checking the service binary path.

## Codex "could not start its user interface": cause

Codex 26.1021.22027 is installed on both the Windows side and the WSL server.
Both bundles carry the `repair-chat-file-links` edit (expected hash). Today's
Windows window logged four `renderer_ready_timeout` errors (17:15–17:21) with
`receivedWebviewMessage=false`, including attempts made minutes after the
extension-activation burst and after extension-host restarts, so the October
explanation (busy extension host) did not cover this machine. The WSL logs
show the same pattern since 10-26: the first extension host of a session times
out, a later one succeeds.

To see the webview itself, an isolated VS Code 1.145.2 instance was started
with its own `--user-data-dir` and an `--extensions-dir` containing **only**
Codex, driven over the Chrome DevTools protocol. The webview loaded and
rendered without errors, but slowly even in that ideal case:

| Event (isolated profile, warm disk cache) | Time after the view opened |
| --- | --- |
| Codex app-server initialised | immediate |
| first React render requested | 11.5 s |
| `app routes mounted` (renderer ready) | 13.9 s |

Codex ships an unbundled webview (17 596 JavaScript modules, 1.5 GB), each
loaded through VS Code's webview service worker. The extension's deadline for
the first renderer message is a hard-coded 30 s with no retry. With a 14 s
best case, any contention (startup burst, extension-host restart, cold cache,
Norton 360 on-access scanning of thousands of module files, several VS Code
windows) exceeds it. That one slow path explains all observations on both PCs.

VS Code has no "load this extension first" setting; activation order is not
configurable, and ordering would not change the webview's own load time.

## Fix applied

`scripts/extend-codex-webview-timeout.cjs` raises the deadline to 180 s. It is
version-agnostic but exact: the minified fragment must occur once, the result
is re-parsed, and a backup is written under `~/.dotrepo-backups`. It patched
both bundles here (backup `2026-11-07T23-57-48-483Z-codex-webview-timeout`):

```powershell
node .\scripts\extend-codex-webview-timeout.cjs --check     # Windows + \\wsl.localhost server
node .\scripts\extend-codex-webview-timeout.cjs --apply
node .\scripts\extend-codex-webview-timeout.cjs --self-test
```

`repair-chat-file-links.cjs` now hashes bundles with that edit normalised
away, so both repairs coexist (self-tests pass; the Codex bundle still reports
`already-repaired`). Reload every VS Code window (or restart the extension
host) once; the running hosts still use the old code. The
[startup guard](2026-10-10-codex-ui-startup-timeout.md) stays installed as the
fallback and still recognises the log line.

Expect to re-run the apply step after every Codex update; `--check` reports
`repair-available` when the new build contains the same fragment and
`unknown-build-review-required` when it does not. The marketplace listed
26.51021.22027 (23 Oct) while VS Code kept 26.1021.22027 installed; treat that
as the pre-release channel and do not force it.

Reducing the load time itself is outside the repository's control. On this PC
a Norton 360 Auto-Protect exclusion for `%USERPROFILE%\.vscode\extensions`
would remove on-access scanning of the module files; that is a user decision in
the Norton UI, not something these scripts change.

## PC-PHILIP-WINDOWS

Pull, then run the check/apply commands above once for its Windows and WSL
bundles and reload windows. The firewall script is specific to this PC's
rule names; inspect before using it there.
