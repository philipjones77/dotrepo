# 2026-11-08 PhilipSecond: repo reconciliation and Windows upgrade pass

Machine: **PHILIPSECOND** (login `phili`), the *target* of the
[November 8 hardware-aware handoff](2026-11-08-wsl-environments-hardware-aware-handoff.md).
Primary tool: Claude Code. The user asked to re-pull and reconcile the repository,
find out what this PC needs for the upgrade, and do the Windows part first,
including the CUDA toolkit and the GPU.

## Hardware (differs from the source PC)

| Item | PhilipSecond | Source (PC-PHILIP-WINDOWS) |
| --- | --- | --- |
| GPU | NVIDIA GeForce RTX 5070 Laptop (Blackwell, SM 12.0) + AMD Radeon 780M | RTX 4070 Laptop |
| Windows driver | 621.14 (32.0.16.2114) | 621.14 |
| RAM / WSL limits | 31.3 GB; `.wslconfig` 16 GB RAM, 24 GB swap | 16 GB; 8 GB / 8 GB |
| CPU | AMD Ryzen 9 270 | — |
| Windows | 11 Home 10.0.26300.9818, PowerShell 7.6.9, WSL 2.7.14, Ubuntu 24.04.5 | — |
| Windows CUDA toolkits | 12.8, 13.2, 13.3 (`CUDA_PATH` = 13.3); 13.5 available in winget | 13.5 (pip, WSL) |

The RTX 5070 qualifies for the `jax[cuda13]` row of the handoff's backend table.

## Repository reconciliation

- Windows checkout `C:\dev\dotrepo`: fast-forwarded to `fbf1d75` (the handoff), then
  to `d202a62` after the WSL merge below.
- WSL checkout `~/projects/dotrepo` (also `~/.dotrepo`) had three local commits from the
  2026-11-04 PhilipSecond WSL migration (`706fbd0`, `4792f9e`, `cbedd25`) that origin
  never received, and diverged from `fbf1d75`. Merged as `d202a62`; the single conflict
  in `shared/shell/functions.sh` was resolved in favour of the upstream parameterised
  `jaxenv [313|314|315]`. Pushed from WSL with that machine's own key.
- `bootstrap/install.ps1` failed at its SumatraPDF step here because `Get-Command pwsh.exe`
  returns two entries (Store alias and `WindowsApps` shim). Fixed by taking the first match.

## GPU: code 43 after a Norton-installed driver (reboot required)

`Get-PnpDevice` shows the RTX 5070 with `Problem = CM_PROB_FAILED_POST_START` (code 43).
Consequences: Windows `nvidia-smi` says "insufficient permissions", the WSL copy says
"Failed to initialize NVML: N/A", and every JAX environment in WSL sees only `CpuDevice`.

Timeline from the event logs: the PC last booted 2026-10-29 07:40. On 2026-11-07 16:20
several `NortonDriverUpdUI.exe` processes were active under Restart Manager; at 16:24 the
`nvlddmkm` service was (re)added for the GPU and `DEVPKEY_Device_InstallDate` is
16:24:42 with driver 621.14 (release date 10/26). Windows Update history has no NVIDIA
entry and there is no NVIDIA `Installer2` log, so Norton Driver Updater applied the
driver. 621.14 is current and matches the source PC: **no driver upgrade is needed, a
reboot is**. After the reboot check `nvidia-smi` on Windows and in WSL; if code 43 persists,
reinstall 621.14 through the NVIDIA App (clean install) and consider excluding display
drivers from Norton Driver Updater.

## Windows Python baseline applied

- The previous Windows `py314` (CPython 3.14.7, four packages) is preserved as
  `~/.virtualenvs/py314-before-20261108`; its activation scripts were repaired for the new
  path and it starts. `py313`, `py315` (3.15.0rc2) and `jax-win` are untouched.
- `uv` 0.12.10 did not know CPython 3.14.10. `uv self update` failed with
  "invalid peer certificate: UnknownIssuer" until `UV_SYSTEM_CERTS=1` was set (TLS is
  intercepted on this PC); it is now 0.13.7.
- `python\windows\create-standard-environments.ps1` created `py314`: CPython **3.14.10**,
  83 distributions from `requirements-py314.txt`, JAX/jaxlib 0.12.0.1, NumPy 2.5.4,
  SciPy 1.18.1, CPU devices, `uv pip check` clean.
- Repository aliases mirror the source PC: `.venv-py314` and `.venv-windows` are junctions
  to `~/.virtualenvs/py314`; the old real `.venv-windows` (py313) is
  `.venv-py313-backup-20261108`. `scripts/validate.py` and the 24 unit tests pass on py314.
- PowerShell profiles (four copies under OneDrive Documents), user `Path` (py314 `Scripts`
  first, py313 removed), user `CLOUDSDK_PYTHON`, the VS Code override in
  `vscode/windows/settings.local.json` (py314; stale PowerShell 7.6.6 Store path replaced by
  the stable alias; SumatraPDF keys aligned with the installer) and `~/.gitconfig` (now the
  tracked file with the three WSL `safe.directory` entries) were applied through the repo
  bootstrap. `scripts/dotrepo.ps1 -Action doctor -Platform windows` passes.
- `dotrepo.windows-python-default` 1.0.1 was built with the standard-library packager and
  installed; its receipt under `~/.local/state/dotrepo/windows-python-default` shows the
  dotrepo workspace selecting py314. gcloud (Cloud SDK 590.0.1) starts with the new
  `CLOUDSDK_PYTHON`.
- Backups: `~/.dotrepo-backups/20261108-163415-windows-py314-defaults` (profiles, settings,
  PATH, gitconfig) and `~/.dotrepo-backups/20261108-163922` (bootstrap).
- Codex deadline patch still reports `already-extended` (180 s) on both bundles.

## Pending: needs an elevated shell (UAC prompts are cancelled in the agent's shell)

Run from PowerShell **as administrator**. Skipped deliberately: R for Windows 4.6.2 (R
belongs in WSL), Visual Studio 2022 (use its own installer), Google Cloud SDK (own updater).

```powershell
# Pending winget upgrades (Git, GitHub CLI, .NET 8/9 runtimes and SDK, ChatGPT desktop,
# Docker Desktop, Temurin 21 JRE, Nsight Compute)
winget upgrade --id Git.Git --exact
winget upgrade --id GitHub.cli --exact
winget upgrade --id Microsoft.DotNet.Runtime.8 --exact
winget upgrade --id Microsoft.DotNet.DesktopRuntime.8 --exact
winget upgrade --id Microsoft.DotNet.AspNetCore.8 --exact
winget upgrade --id Microsoft.DotNet.Runtime.9 --exact
winget upgrade --id Microsoft.DotNet.AspNetCore.9 --exact
winget upgrade --id Microsoft.DotNet.SDK.9 --exact
winget upgrade --id OpenAI.ChatGPT --exact
winget upgrade --id Docker.DockerDesktop --exact
winget upgrade --id EclipseAdoptium.Temurin.21.JRE --exact
winget upgrade --id Nvidia.Nsight.Compute --exact

# CUDA toolkit 13.5: the winget silent switches (-s) install every component,
# including the bundled display driver (older than 621.14). Install interactively and
# choose Custom, then untick "Driver components" so the Norton-installed 621.14 stays.
winget upgrade --id Nvidia.CUDA --exact --interactive

# LAN firewall posture from the November 7 handoff
pwsh -File C:\dev\dotrepo\ssh\harden-lan-firewall.ps1

# Then reboot (clears GPU code 43) and verify:
nvidia-smi
wsl -d Ubuntu -- nvidia-smi
```

Windows Update itself has only a Defender definition and an audio APO driver pending.
After the CUDA install, set `CUDA_PATH` to `v13.5` only once `nvcc --version` there works;
13.3 stays installed.

## Pending: WSL phase of the handoff (next session)

The 2026-11-04 session already created `py314` (3.14.10, 349 packages), `jax314`
(3.14.10, 145) and `jax315` (3.15.2, 107) with JAX 0.12.0.1, all **CPU** because of the
GPU state above. Still to do, in this order:

1. After the reboot, confirm `nvidia-smi` in WSL, then add `jax[cuda13]` plus
   `cuda-toolkit[all]>=13,<14` and `cuda-bindings` to candidates and run
   `scripts/check-python-core.py --require-gpu` and `check-gpu-stack.py`.
2. Shell: the merged `shared/shell` files already select `py314`; review
   `~/.config/dotrepo/shell.local.sh` for `py313`/CUDA exports and check `jaxenv`,
   `RETICULATE_PYTHON`, `UV_PYTHON`, `IFJ_PYTHON`, `ARBPLUSJAX_PYTHON` in a fresh shell.
3. Install `wsl-python-default.vsix` through the WSL server's `bin/code-server`
   (built copy in the Windows scratchpad; rebuild with `package.py --source vscode/wsl-python-default`).
4. Jupyter kernels: none registered yet; register one per environment.
5. Home layout: `~/projects` also holds `ARSIA_BasisFunctionModels_code`, `_bundles`,
   `dotrepo`, `references`, `scirs`, `scirs2_compare`, `thesis`; `~/.local/src` does not
   exist; `~/.local/opt` holds MATLAB, three Julia versions, rclone and the oracle builds.
   Move supporting repositories to `~/.local/src` (including `dotrepo`, re-pointing
   `~/.dotrepo`) before deleting anything; `scirs` has a local modification and is behind.
6. Lean: `bash ~/.dotrepo/wsl/install-lean.sh` after `sudo apt-get install graphviz libgraphviz-dev`.
7. Windows R 4.6.1 and Rtools 4.5 remain installed; the handoff says not to reinstall
   them, not to remove them. WSL R is 4.6.1 with 764 packages.

No reboot, WSL shutdown or environment deletion was performed in this session.
