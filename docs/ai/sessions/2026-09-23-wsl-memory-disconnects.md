# WSL memory exhaustion and VS Code disconnects

Date: 2026-09-23 (America/Chicago). Host: **PC-PHILIP-WINDOWS**.
Scope: repeated Remote WSL disconnects and window reloads in VS Code, including
idle AI chat panels, plus related disk cleanup.

## Finding

The disconnects were caused by memory exhaustion inside the WSL VM, not by
corruption in WSL or VS Code.

- `.wslconfig` limits WSL to `memory=6GB` and `swap=2GB`. In the WSL boot that
  ended at 18:15, the kernel logged repeated `page allocation failure` events
  from `python` processes and their `cuda-EvtHandlr` threads, with about 5 GB
  of anonymous memory in use and free swap at 0 kB.
- The kernel then failed to allocate Hyper-V vsock ring buffers
  (`vmbus_alloc_ring`), and WSL logged `UtilAcceptVsock() failed ... 110`.
  VS Code's WSL connection runs over vsock, so every window logged socket
  timeouts and failed reconnects. The same pattern occurred at 07:22, 08:10,
  13:33, 14:00, 14:28, 16:40 and 18:09. The WSL VM restarted at 18:15.
- AI chats (Claude Code, Codex, Copilot, Antigravity) were affected because
  they use the same connection; they did not cause the failure.

## Why it recurred after every WSL restart

The VS Code Python extension discovers tests automatically when a WSL window
opens or reconnects. The multi-root workspace includes TopoSmplJAX, arbPlusJAX,
IntegralFunctionsJAX, RandomFields77 and data77. arbPlusJAX and RandomFields77
had `"python.testing.pytestEnabled": true`, so about ten seconds after each
connection the extension started a `pytest` collection subprocess for each of
them (logged at 17:43:22 and 18:10:11).

Collection does not run test bodies, but it imports `conftest.py` and every test
module (1,252 files in arbPlusJAX). Module-level JAX code initializes the
default backend, and `py313` had gained a CUDA-enabled JAX stack. Several
concurrent CUDA-initializing collection processes exceeded the 6 GB limit. Each
reload restarted discovery, so the failure repeated.

Excluded causes:

- The self-hosted GitHub Actions runner (`~/actions-runner`, `wsl-4070`) is not
  installed as a service. Its last job ran on 2026-08-15.
- The only user service enabled at boot is `dotrepo-codex-remote-host`. It
  does not start Python processes.
- The Claude Code sessions in TopoSmplJAX that were active at 18:13 only read
  to-do files. They did not start the CUDA processes, which were already
  running at 18:10.

## Changes applied

### Test discovery disabled

`"python.testing.pytestEnabled"` was changed from `true` to `false` in:

- `~/projects/arbPlusJAX/.vscode/settings.json`
- `~/projects/arbPlusJAX/arbPlusJAX-linux.code-workspace`
- `~/projects/arbPlusJAX/arbPlusJAX-windows.code-workspace`
- `~/projects/RandomFields77/.vscode/settings.json`
- `~/projects/RandomFields77/RandomFields77.linux.code-workspace`
- `~/projects/RandomFields77/RandomFields77.windows.code-workspace`

No other WSL project or `C:\dev` project enabled pytest or unittest discovery.
These files are tracked in their project repositories and are uncommitted there.
Tests can still be run explicitly from a terminal.

### CUDA install from 10:04–10:05 backed out

The install added cuDSS and nvmath for an arbPlusJAX oracle (commit `6dba09c3`,
"add cuDSS as an independent oracle"). The owner does not want CUDA oracle
tests on this machine.

| Environment | Removed | Result |
| --- | --- | --- |
| `jax-oracles313` | The 16 CUDA packages added at 10:04:45: `cuda-bindings`, `cuda-core`, `cuda-pathfinder`, `cuda-toolkit`, `cutensor-cu13`, `nvidia-cublas`, `nvidia-cuda-nvrtc`, `nvidia-cuda-runtime`, `nvidia-cufft`, `nvidia-cufile`, `nvidia-curand`, `nvidia-cusolver`, `nvidia-cusparse`, `nvidia-nvfatbin`, `nvidia-nvjitlink`, `nvidia-nvvm` | 67 → **51** packages, matching the September 19 record. JAX **0.6.2** on CPU; `uv pip check` is clean. |
| `py313` (kept) | `jax-cuda13-plugin`, `jax-cuda13-pjrt`, `nvidia-cudss-cu13`, `nvmath-python`, `cutensor-cu13`, `cuda-core`, `nvidia-nvfatbin` | JAX **0.11.2** reports only `CpuDevice`. `pip check` is clean. |

In `py313`, the NVIDIA libraries required by `torch 2.14.0+cu130` and `xgboost`
remain installed. Removing them would break `import torch`. They are unused
unless torch explicitly selects the GPU. `nvidia-nvvm` also remains because
`nvidia-cuda-nvcc` requires it.

Package snapshots from before and after the change are kept locally for
rollback in WSL at `~/.local/state/dotrepo/py313-cuda-removal-2026-09-23/`.

The arbPlusJAX cuDSS oracle code remains in that repository. Its tests will
skip or fail without cuDSS; that repository has not been changed.

### Disk cleanup

C: had 98 GB free of 927 GB before cleanup.

| Item | Action | Space |
| --- | --- | --- |
| `%TEMP%\wsl-crashes` | Deleted | 9.7 GB on C: |
| `~/.cache/uv` | `uv cache clean` | 2.9 GiB unique; the rest was hardlinked into environments |
| `~/Wolfram_14.3.0_LIN_Bndl.sh` | Deleted after confirming that Wolfram 14.3 is installed | 6.9 GB |

WSL root usage fell from 228 GB to 218 GB. `C:\WSL\Ubuntu\ext4.vhdx` does not
shrink automatically, so this space has not yet returned to C:.

## Pending owner actions

The Claude Code auto-mode permission classifier blocked these actions. They are
left for the owner to run.

1. Delete the pre-reinstall backup (150 GB). It contains `Users` (87 GB),
   `Program Files`, `ProgramData` and `Windows` material moved from
   `Windows.old` on 9/8. Run in an elevated PowerShell:
   `Remove-Item C:\Recovery\pre-reinstall-20260908 -Recurse -Force`
2. Return WSL free space to C:. Close WSL windows first, optionally back up
   with `wsl --export`, then run:
   `wsl --shutdown` and `wsl --manage Ubuntu --set-sparse true --allow-unsafe`
3. Trim journald logs (0.8 GB) with
   `sudo journalctl --vacuum-size=100M`.
4. Review the remaining `%TEMP%` contents (about 6 GB) before deleting them.
5. Reload the WSL VS Code windows so they pick up the discovery settings.

## Follow-up: crashes at 20:34 and 20:36

WSL crashed twice more after test discovery and CUDA were removed. This time
the kernel OOM killer ran instead of only reporting page allocation failures.
Both times it killed PID 4407, a VS Code server Node process (`MainThread`) with
3.86 GB resident and 28.5 GB virtual memory. Pylance's foreground and
background analysis both logged PID 4069, so the killed process was not
Pylance. The retained logs do not identify it; a second extension host is
possible. The user observed Pylance at 2.2 GB in the same period, with about
7,000 source files across the five-folder workspace.

`.wslconfig` had been raised before the second crash, but the WSL utility VM
(`vmmemWSL` PID 26828) had not restarted, so the old 6 GB limit remained. A
`wsl --shutdown` applied the new limits.

Changes applied:

| Change | Location |
| --- | --- |
| `memory=8GB`, `swap=8GB` (previous file saved as `.wslconfig.bak-20260923`) | `%USERPROFILE%\.wslconfig` |
| `python.analysis.indexing: false`, `diagnosticMode: openFilesOnly`, build/cache `exclude` list | Windows VS Code user settings, WSL `~/.vscode-server/data/Machine/settings.json`, and this repo's `vscode/windows/settings.json` and `vscode/wsl/settings.json` |
| `diagnosticMode` changed from `workspace` to `openFilesOnly` | `TopoSmplJAX/TopoSMPLJAX.code-workspace` (that commit also removes the four sibling folders from the workspace; this edit was already in the working tree) |
| Memory logger: top eight processes by RSS every 30 s, labelled by VS Code role or extension | `wsl/memlog.sh` installed as `~/.local/bin/dotrepo-memlog`; `wsl/dotrepo-memlog.service` enabled as a systemd user service; logs in `~/.local/state/dotrepo/memlog/` (seven days kept) |

After the restart and reconnection, WSL showed 7.8 GB of memory and 8 GB of
swap. Usage held at about 2.6–2.9 GB, with the extension host near 760 MB,
Pylance at 540–700 MB and the Claude Code process near 300 MB.

If WSL crashes again, read the last entries of the previous day's or current
memlog to identify the growing process:
`tail -n 60 ~/.local/state/dotrepo/memlog/$(date +%F).log`

To install the logger on another machine:

```bash
tr -d '\r' < wsl/memlog.sh > ~/.local/bin/dotrepo-memlog && chmod +x ~/.local/bin/dotrepo-memlog
tr -d '\r' < wsl/dotrepo-memlog.service > ~/.config/systemd/user/dotrepo-memlog.service
systemctl --user daemon-reload && systemctl --user enable --now dotrepo-memlog.service
```

## Other observations

- On 2026-09-22 at 18:32, Windows bugchecked with `0x10E`
  (VIDEO_MEMORY_MANAGEMENT_INTERNAL). The minidump is
  `C:\WINDOWS\Minidump\092226-24875-01.dmp`. The repeated `BlueScreen` and
  `LiveKernelEvent` Windows Error Reporting entries on 9/23 appear to be
  resubmissions; no other Kernel-Power 41 events occurred. Consider updating
  the NVIDIA driver.
- Windows had 2.6–3.1 GB of physical memory free of 15.6 GB when checked, so
  do not raise the WSL memory limit above 8 GB.
- Two `rclone mount` processes for the same Google Drive remote were running
  after boot. This did not cause the disconnects; check whether the duplicate
  is intentional.
- `dotrepo-codex-remote-host` failed once after boot ("connection is errored")
  and succeeded on its systemd restart.

## Resume on PhilipSecond

These findings do not establish PhilipSecond's state. If it shows the same
symptoms, check `journalctl -b -1 -k` for `page allocation failure` and
`UtilAcceptVsock` errors. Also check VS Code's `Python.log` for test discovery
at connection time, and look in each Python environment for CUDA packages added
since the September 19 JAX record. Preserve compatibility pins as described in
the [September 19 JAX handoff](2026-09-19-jax-update.md).
