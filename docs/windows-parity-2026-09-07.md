# Windows source matching — 2026-09-07

This work applies to **PC-PHILIP-WINDO**, after its Windows 11 reinstall.
The user requested the other computer's Windows Python environments and Windows
software, and then explicitly left WSL unchanged for this follow-up.
The Windows checkout fast-forwarded through source commit `61586ef`; local terminal-link
edits were preserved, including both README additions. The source inventory
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

Installation and verification of the remaining Windows applications is still in
progress. Windows App Runtime 1.5 updated to 1.5.9, and Defender intelligence
KB2267602 1.459.95.0 installed successfully without requiring a reboot.
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
Visual Studio's optional DirectX Graphics Tools capability request remains in
Windows servicing after its download reached 100%; Docker's Windows feature
request is waiting behind it. Neither servicing process has been terminated.

The original `C:\rtools45` survived the Windows reinstall. Its build marker is
already 6768, matching the source. A reinstall attempt stopped because the target
directory existed and did not overwrite it. The existing GCC 14.3.0 toolchain
passed `pkgbuild::check_build_tools()` and compiled a C DLL that R loaded and
called successfully. This working installation was preserved; its missing
uninstall registration was not fabricated.

Git 2.55.0.windows.5 installed successfully and its version check passed. Docker
Desktop is still completing its Windows prerequisites without starting its
engine. The CUDA 13.3.1 installer was downloaded, its published SHA-256 value
matched, and its publisher signature was valid. CUDA installation
will select the 42 reviewed toolkit subpackages and retain the already verified
NVIDIA 616.56 driver. TeX Live's native GPG verifier was restored and its repository
signature check passed; the manager/package update is running.

PowerShell 7.6.5 and Google Cloud SDK 583.0.0 are working standalone installations,
despite not appearing as ordinary WinGet installations. Node 24.20.0 matches
the repository's version file; npm 11.19.0 and corepack 0.35.0 are present. No
additional global npm packages are declared in the repository.

A read-only inspection of the old Windows registry identified this target's
previous Office installation as 64-bit `O365ProPlusRetail` plus
`OneNoteFreeRetail`, in English. Their current-channel restoration is prepared
using the official Office deployment tool; account activation remains separate.

The other computer's ASUS app suite also needs restoration. This target is an
ROG Zephyrus M16 GU604VI: its ASUS System Control Interface 3.1.70.0 already
matches the current model support download, and its Armoury Crate Control
Interface 1.2.0.2 is newer than the listed 1.2.0.1. MyASUS, GlideX and Armoury
Crate app restoration is being reviewed using the
[GU604VI support page](https://www.asus.com/us/supportonly/gu604vi/helpdesk_download/).
The source machine's AMD and ScreenPad components are hardware-specific and are
not a reason to install those drivers or apps on this Intel laptop.
See the [recovery report](recovery-2026-09-06.md) for previously restored apps,
Drive, Norton, editor integration and GPU checks.

No Ubuntu update, environment migration, distro restart or Docker WSL data
restoration is included after the Windows-only instruction. Docker's Windows
installer requested the Windows WSL compatibility feature as a prerequisite;
its engine has not been started. The original Docker disk remains preserved,
with an explicit guard deferring its restoration.
