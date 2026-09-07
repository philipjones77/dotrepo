# Windows source matching — 2026-09-07

This work applies to **PC-PHILIP-WINDO**, after its Windows 11 reinstall.
The user requested the other computer's Windows Python environments and Windows
software, and then explicitly left WSL unchanged for this follow-up.
The Windows checkout fast-forwarded through source commit `4b6e060`; local terminal-link
edits were preserved. An overlapping VS Code settings change was reconciled to
retain the local `pwsh.exe` profiles and the incoming terminal paste settings.
The source inventory
describes **PhilipSecond**, not this target.

## Windows Python: verified exact recorded versions

| Environment | Python | Packages | Result |
| --- | --- | --- | --- |
| `~/.virtualenvs/py313` | 3.13.15 | 10 | Exact match; dependencies, SSL, SQLite, YAML, JAX JIT/gradient and SciPy solve passed |
| `~/.virtualenvs/py314` | 3.14.7 | 4 | Exact match; dependencies, SSL, SQLite and YAML passed |
| `~/.virtualenvs/py315` | 3.15.0rc2 | 3 | Exact match; dependencies, SSL and SQLite passed |
| `~/.virtualenvs/jax-win` | 3.14.7 | 151 | Exact match; dependencies, JAX JIT/gradient, PyTorch multiplication, VTK mesh, SciPy solve, SSL, SQLite and YAML passed |

All four use uv-managed CPython, independent of Conda. Every recorded package
name and version matches, with no extra or missing distributions. Windows JAX
reports a CPU device. These checks do not make a claim about Windows CUDA JAX
support, every scientific workload, or byte-identical original wheels.
After Visual Studio, Office, .NET and CUDA installation, all four Python versions
and package sets were checked again and still matched exactly. A fresh Windows
PATH resolved `python` to the intended `py313` interpreter.

The Windows user PATH, ignored local VS Code interpreter override and Cloud SDK
interpreter now select `~/.virtualenvs/py313/Scripts/python.exe`, with backups.
A fresh normal PowerShell session verified that interpreter and Google Cloud
SDK 583.0.0. Existing target Anaconda/scientific environments remain preserved;
they are no longer the shared default. The repository `.venv-windows` was created
with the same standard CPython 3.13.15 and `scripts/requirements.txt`; repository
validation and all 17 Windows repository tests passed. Its complete source package inventory was not recorded, so
the exact-package comparison above covers the four inventoried environments.

The new [restore helper and instructions](../python/windows/README.md) reproduce
the recorded package sets. An inherited Conda certificate bundle initially
overrode uv's Windows trust setting. The helper now selects Windows trust for
its own downloads and restores inherited variables afterward. No TLS checks
were disabled and no broad Norton exclusions were added.

## Windows software follow-up

The reviewed Windows app installations and compiler checks have completed.
Armoury Crate's first-run choice and hardware-service verification, account
activation checks and the deferred Docker work remain as described below.
Windows App Runtime 1.5 updated to 1.5.9. Defender intelligence KB2267602
initially updated to 1.459.95.0, then to 1.459.99.0 during the afternoon refresh;
both installations succeeded without requesting a reboot.
All 73 recorded Windows R entries now match or exceed the source versions and
pass a fresh native R check. `translations` is data, rather than a loadable
namespace. `rdtools` 0.1.0 was restored from CRAN. Updated packages include
`rlang` 1.3.0, `stringi` 1.8.9, `xml2` 1.6.0 and `knitr` 1.52. The last was
installed from official CRAN source because the available Windows binary lagged.

Existing VS Code R processes held several older package DLLs open. The updated
versions were installed in the separate user library
`~/AppData/Local/R/win-library/4.6-source-20260907`, preserving the existing
library. A backed-up native R 4.6.1 `etc/Rprofile.site` adds that library for this
R installation only. Fresh R sessions verified its precedence and all 73 source
entries. Existing editor R sessions need restarting to see the updates; no user
R processes were terminated, and no global R environment variable was changed.
The native R `bin` directory was also added to the Windows user PATH with a
backup; `R.exe` and `Rscript.exe` now resolve to R 4.6.1 in new shells.

Visual Studio Community 2022 17.14.39 completed installation, and `vswhere`
verified all 40 reviewed workload/component IDs, including both Windows SDKs.
The setup log confirmed finalization and lock release. Its PowerShell launcher
continued waiting on descendants after setup exited; only that owned waiter was
retired. The installer's numeric exit code was therefore unavailable. A separate
MSVC C++17 program using the STL and Windows SDK compiled and ran successfully.
Visual Studio's optional DirectX Graphics Tools capability finished successfully;
both Windows capability state and its matching CBS servicing session report
`Installed`. The completed orphan DISM client was retired only after its worker
finished. Windows servicing was allowed to complete normally.

The original `C:\rtools45` survived the Windows reinstall. Its build marker is
already 6768, matching the source. A reinstall attempt stopped because the target
directory existed and did not overwrite it. The existing GCC 14.3.0 toolchain
passed `pkgbuild::check_build_tools()` and compiled a C DLL that R loaded and
called successfully. This working installation was preserved; its missing
uninstall registration was not fabricated.

Git 2.55.0.windows.5 installed successfully; version and GitHub SSH push checks
passed. Docker Desktop initially installed as 4.89.0.238018 and updated to
4.90.0.238679 with installer exit code 0 at the afternoon refresh. Its Docker CLI
still reports 29.7.2 and runs successfully. Its Windows prerequisite requires a
later restart. The engine has not been started: the installer-added login
startup entry was backed up and
removed while restoration of the original Docker disk remains deferred.
The update used the signed installer and SHA-256 from the reviewed
[WinGet manifest](https://raw.githubusercontent.com/microsoft/winget-pkgs/master/manifests/d/Docker/DockerDesktop/4.90.0/Docker.DockerDesktop.installer.yaml).
The disabled startup preference was preserved after installation; no Docker
engine process or new Docker VHD was present afterward. Both original Docker
VHDs retained their recorded sizes and modification timestamps.

.NET SDK 9.0.317 is installed, together with the Core, ASP.NET and Windows
Desktop runtimes 8.0.30 and 9.0.19. A .NET 9 console program built and ran
successfully, calculating the expected result 338350.

CUDA 13.3.1 finished installing with exit code 0. The published installer
SHA-256 matched and its NVIDIA publisher signature was valid. Installation
selected 42 reviewed toolkit subpackages with the official no-restart switches;
driver and NVIDIA App packages were excluded. The NVIDIA driver remained 616.56
before and after installation. `nvcc` reports 13.3.73. A newly compiled CUDA
program ran successfully on the RTX 4070 Laptop GPU and checked all 4097 output
values; all 40 Visual Studio component IDs also remained registered.
The [shell and CUDA version record](shell-and-cuda-2026-09-07.md) explains the
driver's separate CUDA UMD 13.4 display and the recommendation to retain stable
toolkit 13.3.1 while 13.4 is a Developer Preview. It also records the Windows/WSL
compiler distinction and the verified Bash defaults.

TeX Live 2026's manager and all 1661 package operations completed successfully,
including format, font and ConTeXt cache rebuilds. At 12:53 CDT, actual
pdfLaTeX, XeLaTeX and LuaLaTeX builds all passed with resolved Biber
bibliographies, verified PDF text and nonempty SyncTeX output. The test used
spaces in both the directory and document names. Latexmk reports 4.88 and Biber
2.22. A fresh environment used the saved native GPG setting to verify the
Illinois CTAN repository, which reported no updates available. The automatic
mirror selector initially chose a lagging MIT mirror; that mirror was not used
to downgrade or replace any installed packages.

PowerShell 7.6.5 and Google Cloud SDK 583.0.0 are working standalone installations,
despite not appearing as ordinary WinGet installations. Node 24.20.0 matches
the repository's version file; npm 11.19.0 and corepack 0.35.0 are present. No
additional global npm packages are declared in the repository.

A read-only inspection of the old Windows registry identified this target's
previous Office installation as 64-bit `O365ProPlusRetail` plus
`OneNoteFreeRetail`, in English. Their current-channel restoration completed
using the official Office deployment tool, with exit code 0 and version
16.0.20326.20132. Word, Excel, PowerPoint and OneNote executables are present;
account activation remains unverified. The Microsoft 365 Copilot Store app also
updated to the recorded 19.2609.33021.0.

The Office installation subsequently replaced the updated per-user OneDrive
with its older 23.038.0219.0001 machine-wide copy. The reviewed production
installer subsequently corrected the machine-wide installation to
26.153.0809.0004, returning exit code 0. The executable under
`C:\Program Files\Microsoft OneDrive` has a valid Microsoft signature and the
registered Store component now reports 26153.809.4.0. The original disabled
login-startup preference was preserved. When repeating this recovery, check
OneDrive again after Office deployment.

The other computer's applicable ASUS apps were restored. This target is a
ROG Zephyrus M16 GU604VI: its ASUS System Control Interface 3.1.70.0 already
matches the current model support download, and its Armoury Crate Control
Interface 1.2.0.2 is newer than the listed 1.2.0.1. MyASUS 4.0.73.0 is installed
and its Store signature and registration status verified. Its first Store
installation failed with a canceled-call error; an ordinary retry completed.
GlideX 4.2.1.0 and NVIDIA Control Panel 8.1.969.0 are also installed with healthy
Store registrations. Armoury Crate 6.5.14.0 is installed; its official loader
reported exit code 0. Its first-run ASUS privacy choice remains pending, so
hardware-service readiness has not yet been verified. Restoration used the
[GU604VI support page](https://www.asus.com/us/supportonly/gu604vi/helpdesk_download/).
The source machine's AMD and ScreenPad components are hardware-specific and are
not a reason to install those drivers or apps on this Intel laptop.
Dolby Access 3.27.11070.0 and Realtek Audio Control 1.1.137.0 remain below the
source inventory versions; the Store package manager offered no newer upgrade
for either on this target. Their current registrations are healthy.
See the [recovery report](recovery-2026-09-06.md) for previously restored apps,
Drive, Norton, editor integration and GPU checks.

No Ubuntu update, environment migration, distro restart or Docker WSL data
restoration is included after the Windows-only instruction. Docker's Windows
installer requested the Windows WSL compatibility feature as a prerequisite;
its engine has not been started. The original Docker disk remains preserved,
with an explicit guard deferring its restoration.

At 15:18 CDT, a fresh WinGet check offered no further application upgrades;
the Store check also offered none. The Windows Update scan offered only the
Defender intelligence update applied above, with no quality, feature or driver
updates. A fresh signed TeX Live check again reported no updates available.
The existing CBS restart flag remains pending. Ubuntu's running session was
not stopped or upgraded by this follow-up.

After installation and compiler checks, four owned installer downloads (CUDA,
Docker Desktop, Rtools and Git) were removed from the private recovery folder,
releasing 3.45 GiB of archive storage. Installed tools, package-manager caches,
the retained Windows.old data and WSL disks were preserved.
The completed 4.90 Docker installer download was also removed after verification,
recovering another 0.56 GiB; approximately 99 GiB was then free on C:.
The temporary installer keep-awake requests ended after the checks, restoring
normal sleep behavior.

The Windows-side Google Drive anchor was found to have exited at 15:03:46,
before the afternoon update task began. Ubuntu was running and the Windows
login entry still selected the existing PowerShell 7 Drive helper. The user
explicitly chose to leave WSL alone when offered a helper restart. The mount
itself was not retested during this follow-up.

A subsequent read-only shell check confirmed GNU Bash 5.2.21 in Ubuntu 24.04.4
LTS, with `/bin/bash` as the `phili` account's login shell. Windows Terminal's
default profile is Ubuntu Bash. Git for Windows separately supplies Bash
5.3.15; Windows VS Code's shared terminal and automation settings use PowerShell
7 through `pwsh.exe`.

## Repeating the TeX Live verifier repair

Git's MSYS GPG executable could report its version successfully but could not
use the native Windows paths supplied by TeX Live. TeX Live's own Windows GPG
package was restored from its documented HTTPS bootstrap repository,
`https://www.texlive.info/tlgpg/`, and the TeX package repository signature
verified successfully. No signature or TLS checks were disabled.

The [repair helper](../windows/repair-texlive-gpg.ps1) creates a dedicated
`~/.local/bin/texlive-gpg.cmd` wrapper and sets the Windows user variable
`TL_GNUPG=texlive-gpg`. The basename is intentional: this TeX Live version's
Windows executable lookup does not accept an absolute path in that variable.
The helper verifies TeX Live's real verifier discovery and public keyring before
saving the setting, backs up existing values, and leaves ordinary `gpg` selection
unchanged. It requires an already installed native `tlgpg` package.

```powershell
.\windows\repair-texlive-gpg.ps1 -TeXRoot C:\texlive\2026
```

Afterward, open PowerShell from Start so it receives the new user environment;
existing VS Code processes require restarting to inherit that change. Use an
administrator PowerShell for updates to a machine-wide TeX Live installation:

```powershell
$texRepository = 'https://ctan.math.illinois.edu/systems/texlive/tlnet'
tlmgr --repository $texRepository --verify-repo=all update --self
tlmgr --repository $texRepository --verify-repo=all update --all
tlmgr --repository $texRepository --verify-repo=all update --list
```

The explicit repository avoids a lagging automatically selected mirror observed
during this recovery. It does not change the saved repository setting. If a
mirror reports that its database is older than the installed release, wait for
it to synchronize or choose another current CTAN mirror; retain signature
verification. Run only one package updater at a time.
