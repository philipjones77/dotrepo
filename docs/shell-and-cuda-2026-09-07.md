# Shell and CUDA versions — 2026-09-07

These observations and decisions apply to **PC-PHILIP-WINDO**, the restored
Windows 11 laptop with an NVIDIA GeForce RTX 4070 Laptop GPU. They do not
replace the separate PhilipSecond source inventory. Versions below were checked
on September 7, 2026; consult the official release pages again before a later
upgrade.

## Which Bash and CUDA are in use?

| Component | Verified version or selection |
| --- | --- |
| Main interactive shell | GNU Bash 5.2.21(1)-release in Ubuntu 24.04.4 LTS on WSL |
| Linux account | `phili`, UID 1000, home `/home/phili`, login shell `/bin/bash` |
| Windows Terminal default | `Ubuntu Bash`, launching `wsl.exe -d Ubuntu --user phili --cd ~ --exec bash --login` |
| Separate Git for Windows Bash | GNU Bash 5.3.15(2)-release, supplied by Git for Windows |
| Windows VS Code terminals and automation | PowerShell 7.6.5 through `pwsh.exe`; this is separate from Windows Terminal's Ubuntu default |
| Windows CUDA Toolkit | **13.3.1**, installed under `C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.3` |
| Windows CUDA compiler | `nvcc` **13.3.73**, reporting CUDA release 13.3 |
| NVIDIA driver, Windows and WSL | **616.56** |
| Windows `nvidia-smi` CUDA UMD field | **13.4**, the driver's supported CUDA level |
| WSL system CUDA compiler | No `nvcc` was found on the inspected default PATH, and no `/usr/local/cuda*` toolkit directory was found |

The toolkit, compiler and driver have separate version numbers. NVIDIA defines
the CUDA UMD field as the newest CUDA version supported by the driver. It does
not establish which toolkit is installed. The installed Windows toolkit was
confirmed independently through its `version.json` and `nvcc` output.
See [NVIDIA's `nvidia-smi` field documentation](https://docs.nvidia.com/deploy/nvidia-smi/index.html#cuda-umd-version).

The WSL compiler observation is limited to the system PATH and conventional
toolkit directories. It does not mean WSL GPU computation is unavailable or
inventory CUDA runtimes bundled inside every Python environment. Earlier WSL
GPU checks passed. The matching Windows Python environments report CPU JAX;
installing the Windows toolkit alone is not evidence of CUDA-enabled JAX.

## CUDA 13.4 assessment and recommendation

At the time of this review, NVIDIA lists **13.3.1 as the latest stable release**
and **13.4.0 as a Developer Preview**. The normal download page also offers
13.3 Update 1. See the [release archive](https://developer.nvidia.com/cuda-toolkit-archive)
and [current downloads](https://developer.nvidia.com/cuda-downloads).

The preview adds compiler and library updates, CUDA Tile and matrix-programming
features, and preparation for RTX Spark, Rubin and Windows Arm64 development.
NVIDIA says it has not completed full validation and should not be used for
production deployment or performance comparisons. See the
[CUDA 13.4 Developer Preview release notes](https://docs.nvidia.com/cuda/developer-preview/13.4/cuda-toolkit-release-notes/index.html).

**Recommendation: retain the verified CUDA 13.3.1 installation for this
machine's normal work.** A newly compiled CUDA program already ran on the RTX
4070 Laptop GPU and verified all 4097 output values. No CUDA 13.4 preview was
installed, and no 13.4 performance measurement was made. An automatic speed
improvement for current projects should not be assumed from the version number.

Reconsider 13.4 when its stable release is available or a specific project needs
one of its features or fixes. Review that project's compiler, framework and
driver requirements, preserve the recorded Python package sets, and repeat a
real CUDA build/run plus the affected project checks before replacing the
working setup. The driver's 13.4 display alone is not an upgrade requirement.

## Maintenance outcome and WSL scope

The [Windows comparison report](windows-parity-2026-09-07.md) records the full
software work: all four recorded Windows Python environments matched their
versions and package sets; Docker Desktop updated to 4.90.0.238679; Defender
intelligence updated to 1.459.99.0; and TeX Live 2026 completed all 1661 package
operations with successful pdfLaTeX, XeLaTeX, LuaLaTeX, Biber and SyncTeX checks.
The afternoon package-manager checks offered no further WinGet, Store or TeX
updates. These are observations from that check, not future version guarantees.

The user explicitly chose **leave WSL for now**, including deferring a restart
of the existing Drive helper after its 15:03 exit. Shell and CUDA commands in
this discussion only read versions; they did not update Ubuntu or its packages.
The Windows login entry for the Drive helper remains configured. Docker engine
startup and original Docker data restoration are also deferred; the existing
Windows restart requirement remains. Armoury Crate first-run setup and account
activation checks remain documented in the [recovery report](recovery-2026-09-06.md).

After this Windows-only work, the user separately requested a
[WSL environment cleanup](wsl-environment-cleanup-2026-09-07.md). Only Miniforge
`base` and `jax` remain on this target, both with Python 3.12.12. A fresh
JAX 0.11.1 JIT computation passed on `cuda:0` after the other seven environments
were removed. Ubuntu upgrades and the Drive helper restart remain deferred.

## Repeat the Windows version checks

Run these read-only commands in PowerShell:

```powershell
$cudaRoot = 'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.3'
(Get-Content (Join-Path $cudaRoot 'version.json') -Raw | ConvertFrom-Json).cuda
& (Join-Path $cudaRoot 'bin\nvcc.exe') --version
& "$env:SystemRoot\System32\nvidia-smi.exe"
& 'C:\Program Files\Git\bin\bash.exe' --version
```

When a WSL version check is wanted, `bash --version` and `getent passwd phili`
inside the existing Ubuntu session report its Bash version and account shell.
