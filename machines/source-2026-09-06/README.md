# Source computer → target computer

Captured on 2026-09-06 after maintenance. **This computer is the source; the other
computer is the target.** This directory records the source's applications and
environments so the target can be rebuilt. It is an application/configuration
baseline, not a disk image: personal files, credentials, licenses, project data,
and project-local virtual environments need separate migration.

## What to install

| Platform | Inventory | Coverage |
| --- | --- | --- |
| Windows | [WinGet app list](windows/apps.md) and [import manifest](windows/winget-source.json) | 43 package IDs with observed versions |
| Windows | [Desktop inventory](windows/installed-desktop-apps.json) | 298 application/component records, including vendor installers |
| Windows | [Store inventory](windows/installed-store-apps.json) | 155 current-user packages, including frameworks |
| Windows | [VS Code extensions](windows/vscode-extensions.json) | 91 extensions |
| Ubuntu 24.04, x86-64 | [Requested APT packages](wsl/apt-manual.txt) | 63 manually marked packages, including OS components |
| Ubuntu | [All APT packages](wsl/apt-installed.json) | 1,109 installed packages with versions |
| WSL | [VS Code extensions](wsl/vscode-extensions.json) | 30 remote extensions |
| Python | [Windows base](windows/conda/base.yml), [WSL base](wsl/conda/base.yml), [WSL jax](wsl/conda/jax.yml) | 129, 317, and 444 observed packages respectively; manual sources are listed separately |
| R | [Package versions](wsl/r-packages.tsv) | 72 packages observed through WSL Rscript |

Registry and Store counts include dependencies and duplicate components; they
are not counts of independent apps to install. Start with the WinGet manifest
and the manual applications below. Do not reinstall every registry entry.

## Windows target

1. Install Git, PowerShell 7, WinGet/App Installer, VS Code and WSL with Ubuntu
   24.04. Clone this repository on Windows and independently inside Ubuntu as
   described in the [main README](../../README.md).
2. Review [the app list](windows/apps.md), especially CUDA and Visual Studio.
   From the repository root, import the list:

   ```powershell
   winget import --import-file machines/source-2026-09-06/windows/winget-source.json --ignore-versions
   ```

   This requests available versions and leaves installer/license prompts visible.
   Remove `--ignore-versions` to request recorded versions, but some are no longer
   available in the catalog. Source Git reports `2.55.0.5`; Cloud SDK reports
   `Unknown` to WinGet (the executable is 583.0.0). The recorded Claude version
   is 1.8555.2.0; its 1.44121.2 installer completed but registration had not
   changed at capture, so restart/recheck Claude. Miniconda's registered installer
   version differs from its updated base environment (Conda 26.7.2, Python 3.13.13).
3. Install the manual applications listed below through their vendors/accounts.
4. Create ignored `vscode/windows/settings.local.json` with the target's actual
   Python, Conda and PowerShell paths. Follow the
   [maintenance runbook](../../docs/windows-wsl-maintenance.md), then apply:

   ```powershell
   .\scripts\dotrepo.ps1 -Action install -Platform windows
   $extensions = Get-Content machines/source-2026-09-06/windows/vscode-extensions.json -Raw | ConvertFrom-Json
   foreach ($extension in $extensions) {
       code --install-extension "$($extension.id)@$($extension.version)"
       if ($LASTEXITCODE -ne 0) { throw "Extension failed: $($extension.id)" }
   }
   ```

   Extension versions may also require a compatible VS Code version or vendor
   access. Record failures rather than silently substituting versions.

## Ubuntu target

Use Ubuntu 24.04 x86-64, matching the source. Configure the GitHub CLI and CRAN
repositories using the official [GitHub CLI instructions](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
and [CRAN Ubuntu instructions](https://cran.r-project.org/bin/linux/ubuntu/). The source
uses `https://cli.github.com/packages` (stable/main) and
`https://cloud.r-project.org/bin/linux/ubuntu` (noble-cran40), with signed keyrings.
Install WolframScript separately using the licensed vendor installer.

From the native Ubuntu checkout:

```bash
sudo apt-get update
mapfile -t packages < machines/source-2026-09-06/wsl/apt-install.txt
sudo apt-get install "${packages[@]}"
bash scripts/dotrepo.sh install
python3 - <<'PY'
import json, subprocess
from pathlib import Path
for extension in json.loads(Path('machines/source-2026-09-06/wsl/vscode-extensions.json').read_text()):
    subprocess.run(['code', '--install-extension', extension['id'] + '@' + extension['version']], check=True)
PY
```

Run the extension command from a VS Code **WSL remote terminal**, with its remote
`code` command available, so these extensions install on the WSL host. The
practical APT list omits OS bootstrap components and WolframScript and explicitly
includes fuse3 for the Drive mount. It installs current repository versions;
`apt-installed.json` preserves the source's observed versions for comparison.

Install Miniforge in WSL and Miniconda on Windows. Create separate environments
first so an existing target base environment is not overwritten:

```bash
conda env create --name source-base --file machines/source-2026-09-06/wsl/conda/base.yml
conda env create --name jax --file machines/source-2026-09-06/wsl/conda/jax.yml
```

```powershell
conda env create --name source-base --file machines/source-2026-09-06/windows/conda/base.yml
```

The `.yml` files use JSON syntax, which Conda accepts as YAML. Conda packages pin
versions/builds; ordinary pip packages pin versions. Both WSL manifests passed
`conda env create --dry-run`. This checks the Conda solve, not subsequent pip
downloads or GPU execution. The Windows dry run stopped at Anaconda's terms
prompt; review and accept the applicable terms on the target before proceeding.
Its solve remains unverified. Existing environments with these names must be
reviewed before choosing a new name; do not delete them automatically.

Reinstall the editable scientific projects from the repositories and commits in
[base-manual.json](wsl/conda/base-manual.json) and
[jax-manual.json](wsl/conda/jax-manual.json), then run `python -m pip install
--no-deps -e /path/to/checkout` in the corresponding environment. Source checkouts
were clean. TopoSmplJAX and arbPlusJAX report different installed metadata versions
between environments despite sharing checkout commits; validate their workloads
after installation. `fftlog-lss==0.1.2` came from a temporary local directory whose
repository cannot be recovered from installed metadata. Recover its original
source/wheel before considering the jax environment fully reproduced.

Use `wsl/r-packages.tsv` to compare R libraries after Conda and system R setup.
It records versions, not source repositories or a complete R restore lockfile;
recover remaining non-base packages from their original sources. Source system
R is 4.6.1. Do not assume every listed R package came from CRAN.

## Manual applications, tools and machine configuration

| Item | Source state / target action |
| --- | --- |
| Norton 360 | 26.8.11125.2681; install from the Norton account, activate, run LiveUpdate and reboot when requested |
| Norton Driver Updater / Utilities Ultimate | 26.9.6768.8210 / 26.9.18896.9446; licensed account installers |
| Microsoft 365 / OneNote | 16.0.19929.20172; install and activate through the Microsoft account |
| Codex desktop | Store/MSIX package OpenAI.Codex 26.901.5280.0; install through the vendor/Store and sign in |
| Node.js | 24.20.0 on both platforms, npm 11.19.0, global corepack 0.35.0; source uses separate native portable installations |
| WSL additional tools | agy 1.1.27, fnm 1.39.0, WolframScript 1.13.0; vendor/project installation, Wolfram licensing as needed |
| Cloud SDK | 583.0.0; configure its Python interpreter and trusted certificates for the target |
| Google Drive / rclone | Reauthorize separately on Windows and WSL; restore the mount configuration without copying authentication tokens |
| GPU / OEM software | Source has an RTX 5070 Laptop GPU, NVIDIA driver 616.56, CUDA 13.3, and ASUS utilities; install drivers/OEM utilities for the target's actual hardware |
| WSL limits | Source has 32 GB physical RAM, a 16 GB WSL memory cap and **24 GB swap**; select the memory-32gb profile only for a suitable target |

After installing Node, reproduce the global package with `npm install --global
corepack@0.35.0`. Capture additional project-specific environments separately.
The complete Store/desktop lists remain available to identify other vendor or
hardware components during target review.

Norton previously terminated a PowerShell/Git/WinGet process tree with an
`IDP.Generic - Command line detection` alert. Signed executables were checked and
later maintenance completed, but that does not establish that the detection is
permanently resolved. Keep Behavioral Protection enabled; do not copy blanket
PowerShell, Git or installer exclusions to the target. Update Norton and review
any new detection's exact command before rerunning the affected installer.

The source's PDF, Markdown and image opening tests passed in an isolated VS Code
window. Follow the runbook's supported chat file-link repair and reload VS Code
on the target; verify these clicks again with its installed extension versions.

After saving work, reboot as required by installers, then run the repository
doctor on both platforms. Re-capture the target with `scripts/capture-software.py
--platform windows|wsl --output <private-output-directory>` and compare package
IDs, versions and extensions against this directory. Recheck scientific/GPU
workloads, application logins, Drive mounts and file opening before calling the
target complete. No target installation has been performed by this capture.
