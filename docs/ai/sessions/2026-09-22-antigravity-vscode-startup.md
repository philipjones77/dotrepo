# Antigravity backend reuse in VS Code

Date: 2026-09-22 (America/Chicago). Host: **PC-PHILIP-WINDOWS**.
Scope: the Google Antigravity extension in VS Code, including Remote WSL / Ubuntu.

## Finding and repair

The WSL backend was persistent and executable. Most retained September 20–21
activation logs explicitly skipped downloading it. One September 21 16:06
session instead failed to execute `~/.gemini/bin/agy --version` and downloaded
the same **1.2.7** release again. A subsequent activation reused it successfully.
The log did not record an exit code or signal, so the exact cause of that failed
probe is unconfirmed.

Extension **1.2.0** treated any failed version probe as a reason to download the
backend. Its version subprocess had a five-second timeout and the version cache
lasted only for the extension process. This explains how a transient validation
failure can produce a redundant download without a persistence problem; it
does not prove the recorded failure was a timeout.

The WSL installation was updated through the official installation mechanisms:

| Component | Before | After | Method |
| --- | --- | --- | --- |
| WSL VS Code extension `google.google-antigravity` | 1.2.0 | **1.4.0** | VS Code server CLI extension installation |
| WSL backend `~/.gemini/bin/agy` | 1.2.7 | **1.2.8** | Official `agy update`; verification succeeded |
| Windows VS Code extension | 1.4.0 | **1.4.0** | Already logged successful backend reuse; unchanged |
| Windows backend | 1.2.7 | **1.2.7** | Unchanged during this repair |

Extension 1.4.0 checks the existing backend before checking for updates. When an
existing backend meets the minimum version, its update check has a three-second
budget and can fall back to that backend if the release service is unavailable.
It also isolates archive extraction and promotes the resulting binary. The
five-second version subprocess timeout remains, so this is an official update
with verified reuse, not proof that every possible startup failure is resolved.

No vendor source patches or update-disable settings were applied. Active WSL
VS Code windows still need **Developer: Reload Window** to load extension 1.4.0.
They were not reloaded during the repair, and WSL was not shut down.

## Verification and rollback

Two independent, fresh Node processes evaluated the installed extension's
original downloader module against the real installed Linux binary and the
official production manifest. The probe permitted manifest reads and the exact
`agy --version` invocation, while blocking backend downloads and writes.
Both checks returned **REUSED** and logged
`Installed binary is valid (actual version 1.2.8 >= target 1.2.8). Skipping download.`

| Fresh process | Total time | Backend version probe | Manifest | Download or write attempts |
| --- | --- | --- | --- | --- |
| 1 | 2.283 s | 202 ms | 1.2.8 | None |
| 2 | 2.671 s | 180 ms | 1.2.8 | None |

These checks exercised acquisition decisions with fresh in-memory caches. They
were not a full VS Code window restart, WSL cold boot, or Windows reboot test.
The extension's persisted release marker was read from the actual Windows
VS Code `User/globalStorage/state.vscdb`; no corresponding WSL state database
was present. No authentication state was copied or changed.

The [sanitized machine receipt](../../../machines/pc-philip-windows-2026-09-22/antigravity-vscode-startup.json)
records the versions, backend checksum and checks. Private local evidence and
rollback files are in WSL at
`~/.local/state/dotrepo/antigravity-vscode-startup-2026-09-22/`:

- `receipt.json`, `extension-update.log` and `backend-update.log` record the repair.
- `probe.cjs` repeats the guarded acquisition check with `node probe.cjs`.
- `google.google-antigravity-1.2.0.tar.gz` and `agy-1.2.7` preserve the previous installation.

Those backups support local rollback if required; they do not contain a portable
authentication or pairing setup. Stop affected extension/backend processes
before restoring binaries. No rollback was needed.

## Resume on PhilipSecond

PhilipSecond is a separate verification and update task. This receipt does not
establish its installed versions, current reachability, or update status. Pulling
this repository does not install software on that machine.

1. Read the current `AGENTS.md` and linked cross-machine handoffs. Verify the
   hostname, installed Windows/WSL environments and existing local changes.
2. Inventory each relevant app, VS Code extension and backend independently on
   each operating system: Antigravity Hub/IDE and CLI, the Antigravity extension
   in Windows and WSL VS Code, and the installed ChatGPT desktop app. Identify
   which surface displays a download message;
   the standalone Antigravity app and its VS Code extension have different
   installation paths and update mechanisms.
3. Check the current official releases and compatibility for that machine.
   Select applicable stable updates from current vendor metadata; the versions
   above describe this repair and are not permanent latest-version pins.
4. Preserve local rollback material, authentication, pairing data and working
   environments. Use official installers or updaters. Do not copy credentials
   between machines or replace compatibility-specific Python environments.
5. Verify each resulting installation and repeat a fresh-process acquisition
   check. Record actual download/reuse behavior and any required window reload
   separately from package/version checks and network reachability.

Official release evidence used by the WSL acquisition check:
[production Linux manifest](https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests/linux_amd64.json).
The extension is published as
[`google.google-antigravity`](https://marketplace.visualstudio.com/items?itemName=Google.google-antigravity).
