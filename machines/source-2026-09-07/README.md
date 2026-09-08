# Source setup after Python, PowerShell, R and TeX changes

The refreshed [WSL application inventory](wsl-native/APPLICATIONS.md) lists
current applications, command-line tools, APT and R packages, Python environments
and WSL VS Code extensions for this machine.

The later [WSL machine comparison](../../docs/wsl-machine-comparison-2026-09-07.md)
records live source checks against the other computer's recovered setup and
identifies the remaining differences.

This is the newer inventory of **PhilipSecond, the source computer**, captured
after the September 7 follow-up. It supersedes the September 6 package snapshot
for current source state. Use the [earlier target setup guide](../source-2026-09-06/README.md)
for the general procedure, with the changes below. The separate target still
requires its own [recovery and verification](../../docs/recovery-2026-09-06.md).

## WSL platform

Source WSL platform: **Ubuntu 24.04.4 LTS (Noble Numbat)**, registered as
`Ubuntu` and running under **WSL 2**. The chosen terminal is **Ubuntu Bash**
(GNU Bash **5.2.21**),
starting in `/home/phili`. Confirmed from `/etc/os-release` and
`wsl --list --verbose` on September 7, 2026. The machine-readable distribution
record is [wsl-native/distribution.json](wsl-native/distribution.json).

Ubuntu Windows Terminal profiles explicitly launch with `--cd /home/phili`.
WSL VS Code terminals use `terminal.integrated.cwd = ${env:HOME}`. This applies
to new terminals; existing sessions keep their current directory.

Interactive WSL shells also change to `$HOME` through `shared/shell/init.sh`,
covering plain `wsl.exe` launches that inherit a Windows working directory.
Noninteractive scripts and explicit Bash `-c` commands retain their working
directory.

### Google Drive mount

The source's rclone remote **`gdrive:`** is mounted at
**`/home/phili/mnt/gdrive`**, currently **read/write** (`fuse.rclone`). A temporary
file write/read/delete check passed. Windows can access it through
`\\wsl.localhost\Ubuntu\home\phili\mnt\gdrive` while the WSL mount is active.

The marker `~/.config/dotrepo/gdrive.enabled` enables the shared shell's mount
startup hook. Local `~/.config/dotrepo/gdrive.env` explicitly selects `gdrive:`,
`$HOME/mnt/gdrive` and `DOTREPO_GDRIVE_READ_ONLY=0`, matching the live source mount. The
helper is `wsl/mounts/gdrive.sh`; use `bash ~/.dotrepo/wsl/mounts/gdrive.sh status`
to inspect it. This records shell-triggered startup, not an independently
verified Windows-login service.

See [the mount inventory](wsl-native/google-drive-mount.json). The target must
configure its own rclone authorization. Tokens and rclone credentials are not
committed, and the other computer's writable mount is a separate configuration.

Windows Drive for desktop's **G:** drive also mounts read/write in WSL at
`/mnt/g` on access through an `/etc/fstab` systemd automount. Its files are at
`/mnt/g/My Drive`. A temporary file write/read/delete check passed there too.
See [the current mount and environment follow-up](../../docs/wsl-mounts-and-environments-2026-09-07.md)
for the exact source configuration and the removal of `jax-native` and
`matrix-compare`. Their older validation reports describe historical installs.

## Windows Python

The default is now **standard CPython 3.13.15, independent of Anaconda**, managed
by uv 0.12.10 and isolated in `~/.virtualenvs/py313`. PowerShell startup activates
it, user PATH prioritizes its Scripts directory, and the local VS Code interpreter
setting points to it. Its `sys.base_prefix` is a uv CPython installation, not
Miniconda. The repository `.venv-windows` was also recreated with this CPython;
the previous environment was retained in a private backup.

| Environment | Python | State |
| --- | --- | --- |
| `~/.virtualenvs/py313` | 3.13.15 | New Windows default; JAX CPU and repository tools |
| `~/.virtualenvs/py314` | 3.14.7 | Separate standard CPython environment |
| `~/.virtualenvs/py315` | 3.15.0rc2 | Separate standard CPython preview environment |
| `~/.virtualenvs/jax-win` | 3.14.7 | Additional existing scientific environment discovered by the expanded inventory; 151 packages; preserved, not workload-tested here |
| `.venv-windows` in dotrepo | 3.13.15 | Repository validation and test environment |

The new environments passed Python/SSL/SQLite and pip dependency checks. They
have pip 26.2.1; py313/py314 have PyYAML 6.0.3. PyYAML's Python 3.15 Windows wheel
was unavailable and its source build failed for lack of MSVC C++ build tools, so
py315 intentionally contains pip, wheel and packaging only. Rtools is a separate
toolchain and does not satisfy that MSVC requirement.

The initially created Conda py314/py315 environments were removed after the
standard CPython replacements passed verification. At the user's subsequent
request, Windows Miniconda was uninstalled and its remaining installation folder
removed. WinGet no longer lists it. All standard environments, including the
separately discovered jax-win, use uv-managed CPython. VS Code's obsolete Conda
path and Anaconda Terminal entries were removed, and Cloud SDK was verified
using the standard Python interpreter. WSL Miniforge is a separate installation
and remains available for existing scientific environments. The user's final
decision was to cancel full Windows Anaconda: **do not install Anaconda or
Miniconda on Windows as part of this setup**. Keep standard CPython as the default.

Create the three standard environments on a target with uv installed:

```powershell
.\python\windows\create-standard-environments.ps1
. "$HOME\.virtualenvs\py313\Scripts\Activate.ps1"
# Switch when needed:
deactivate
. "$HOME\.virtualenvs\py314\Scripts\Activate.ps1"
```

The helper refuses existing destination directories. It uses uv-managed CPython,
not whichever Python happens to be on PATH. Review existing target environments
before installation. [Observed package inventories](windows/standard-python/environments.json)
and sibling `*-packages.json` files record the installed state; the creation
helper requests current compatible packages and is not an exact dependency lock.
The source `jax-win` environment is inventoried separately and is not created by
that helper. The [Python 3.15 release notice](https://blog.python.org/2026/09/python-3150-rc2/)
identifies 3.15.0rc2 as a preview, not a final stable release.

For exact recorded-version replication of all four Windows environments, use
the later [Windows Python restore helper](../../python/windows/README.md).
The [target Windows comparison](../../docs/windows-parity-2026-09-07.md) records
the resulting interpreter, complete package-set and representative workload checks.

### JAX verification

Windows py313 has JAX/jaxlib **0.11.1**, NumPy 2.5.3 and SciPy 1.18.1. A real
JIT-compiled dot product returned 14 and automatic differentiation returned
`[2,4,6]`; device discovery reported `cpu:0`. Native Windows CUDA execution is
not provided by this installation. Use the existing WSL jax environment for
NVIDIA GPU work; see the [JAX installation matrix](https://docs.jax.dev/en/latest/installation.html).

WSL environments remain Miniforge base (Python 3.13.13, 317 packages), jax
(Python 3.12.13, 444 packages) and dotrepo `.venv-wsl` (Python 3.12.3). Ubuntu
also has its OS-managed Python. Their scientific dependencies were preserved.
The unresolved original `fftlog-lss` source/wheel remains a target restore gap.

## PowerShell and VS Code

PowerShell **7.6.5**, verified as the latest stable release during this session,
is installed on Windows and natively in Ubuntu through Microsoft's signed APT
repository. `pwsh` runs 7.6.5 on both platforms, including when Python environments
are active. Standard Windows Terminal PowerShell commands use `pwsh.exe`;
Ubuntu's default remains Bash as requested. VS Code Windows automation, its
PowerShell terminal and the PowerShell extension use the installed PowerShell 7.
Host-specific executable locations live in ignored settings overrides.

Windows' built-in `powershell.exe` is the separate OS-owned Windows PowerShell
5.1 executable and remains installed for compatibility. Explicit calls to that
executable still select 5.1; use `pwsh` for the current cross-platform edition.
Vendor-generated developer shells may have their own launch behavior.

All originally recorded extension IDs were present. LaTeX Workshop **10.18.0**
was explicitly confirmed on both Windows and WSL. Python, Pylance, Jupyter and
R extensions are installed. PowerShell extension **2025.4.0** was also installed
into the actual WSL extension directory using the remote server CLI, in addition
to the existing Windows extension. The captured extension files record the full
host-specific lists. Apply the tracked settings and target-specific overrides
with the platform bootstrap; existing tabs/windows need a reload.

A fresh isolated VS Code integration run passed PDF preview, Markdown preview,
image preview, source line navigation and Markdown text diff. Its integrated
PowerShell terminal loaded the normal profile and successfully ran PowerShell
7.6.5, Python 3.13.15, Git 2.55.0.windows.5 and WinGet 1.29.290, then exited zero.
The Codex/Claude file-link repair integrity checks passed on Windows and WSL.
These tests verify viewer routing and supported repair state; they do not claim
every possible AI-generated link is valid.

Norton Antivirus and Firewall services were running during these checks, and the
actual PowerShell 7 executable has a valid Microsoft signature. The tested
commands completed without termination. No blanket PowerShell/Git/WinGet
exclusions were added, and no vendor false-positive report was sent. This does
not guarantee Norton will allow every future command; retain the precise command
and a fresh detection record if a block recurs.

Installing native Linux PowerShell enabled previously skipped helper tests and
exposed a Windows-only path separator in the backup guard. The guard now uses
the native separator and preserves platform-appropriate case comparison, checking
the target before creating backup directories. All **15 tests passed on Windows
and all 15 passed on WSL** after the fix; repository validation passed too.

## R and Rtools

Windows **R 4.6.1** and **Rtools 4.5.6768** were installed from their verified
WinGet/CRAN installers. Rtools is at its standard location. `pkgbuild` compiled
and linked a real C DLL using GCC 14.3.0 and reported the system ready to build
packages. The R language server loaded successfully. R and Rscript resolve in
normal PowerShell sessions, and local VS Code R paths point to this installation.

All **57 Windows-compatible non-base/recommended package names** from the source
R baseline (including the explicit build-check helper) were available and loaded
successfully after installation/update. The Linux-only `littler` package was not
available for Windows and is retained on WSL. See
[Windows R packages](windows/r-packages.tsv) and [WSL R packages](wsl/r-packages.tsv)
for exact observed versions. R base packages are included with R itself. The
scope is the recorded package set and dependencies, not every package on CRAN.
All 72 recorded WSL R package namespaces were also loaded successfully.

## TeX Live and SumatraPDF

- Windows TeX Live **2026** was already installed. Its basic, LaTeX, recommended,
  extra, font, bibliography, XeTeX and LuaTeX collections were verified installed.
  Latexmk is 4.88. A small document using amsmath, graphicx and hyperref compiled
  successfully with latexmk/pdfLaTeX, XeLaTeX and LuaLaTeX.
- WSL uses Ubuntu-managed TeX Live **2023**. Its existing PDF build passed; the
  missing extra LaTeX/font/bibliography, XeTeX and LuaTeX collections plus Biber
  were installed with APT. Separate pdfLaTeX, XeLaTeX and LuaLaTeX builds passed;
  Biber reports 2.19. Use APT for these packages, not upstream tlmgr upgrades of
  the Ubuntu-managed tree.
- Windows **SumatraPDF 3.6.1** was installed and configured as LaTeX Workshop's
  optional external viewer in local settings. The VS Code PDF editor association
  remains available. The generated PDF was passed to Sumatra for a launch check;
  this is not a visual inspection of every rendered page.

The updated [WinGet manifest](windows/winget-source.json) includes the new
Windows applications. The [APT manual list](wsl/apt-manual.txt) and
[complete package inventory](wsl/apt-installed.json) include the new WSL packages.
Installed does not mean every TeX package has been tested; the engine checks
above verify representative document builds.

## Preserve on the target

Keep target data, licenses, credentials and hardware-specific drivers. Preserve
the source's `phili` default user, home-directory terminal launch and requested
24 GB swap while choosing the memory cap for target RAM. Norton is not declared
permanently fixed: later installs completed, but any new behavioral detection
still needs command-specific review. Read the target recovery report before
touching its preserved Ubuntu disk or scientific environments.
