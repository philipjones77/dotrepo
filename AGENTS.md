# Agent Instructions

## Current Cross-Machine Handoff

For the latest Antigravity startup repair, read the
[September 22 VS Code handoff](docs/ai/sessions/2026-09-22-antigravity-vscode-startup.md).
For bidirectional Windows/WSL access on the home network, follow the
[September 22 LAN SSH setup](docs/ai/sessions/2026-09-22-philipsecond-lan-ssh.md).
The [September 22 ChatGPT Windows repair](docs/ai/sessions/2026-09-22-chatgpt-windows-repair.md)
records the local reinstall, preserved profile, and remaining stability checks.
Use GitHub push/pull for repository changes and verify software on each machine
independently. SSH private keys and app sign-in data stay on their own machines.

For Python, numerical oracle packages, and WSL replication, read
[the September 14 handoff](docs/ai/sessions/2026-09-14-python-oracle-wsl-handoff.md)
first. It records the current PC-PHILIP-WINDOWS inventory and the work requested
on the other machine. Verify the hostname and preserve machine-local changes.

For PhilipSecond AI permissions and remote connections, read the
[September 15 AI access handoff](docs/ai/sessions/2026-09-15-philipsecond-ai-access-remote.md).
It distinguishes verified WSL connectivity from desktop settings and pending
phone pairing. Do not replicate authentication or pairing data between machines.

The [September 16 PC-PHILIP-WINDOWS settings handoff](docs/ai/sessions/2026-09-16-pc-philip-windows-ai-settings.md)
records the corresponding settings applied here and the verified WSL remote host.

The [September 19 PowerShell handoff](docs/ai/sessions/2026-09-19-powershell-update.md)
records PowerShell 7.6.6 on PC-PHILIP-WINDOWS and the pending PhilipSecond update.
Verify each machine directly; pulling the record does not install the update.

The [September 19 MATLAB handoff](docs/ai/sessions/2026-09-19-matlab-wsl-install.md)
records the subsequent native Ubuntu installation on PC-PHILIP-WINDOWS, including
the toolbox inventory and activation status.

The [September 19 JAX handoff](docs/ai/sessions/2026-09-19-jax-update.md)
records JAX 0.11.2 in the three modern WSL environments, the retained legacy
oracle companion, the pre-existing GPU access failure and pending target work.
Apply it after restoring the September 14 baseline; keep historical pins intact.

## Shared Writing and Reference Assets

Before drafting or reviewing research prose, read
[the pinned writing and asset guide](/docs/standards/references.md) and its complete shared handbook.
Apply documented project and venue requirements within their scope. The Philip Jones thesis profile
is scoped as described in the guide. Keep vendored release files unchanged and preserve local assets;
refresh dependencies only through the explicit pinned workflow.
