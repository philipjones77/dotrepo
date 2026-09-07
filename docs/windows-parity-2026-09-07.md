# Windows source matching — 2026-09-07

This work applies to **PC-PHILIP-WINDO**, after its Windows 11 reinstall.
The user requested the other computer's Windows Python environments and Windows
software, and then explicitly left WSL unchanged for this follow-up.
The Windows checkout fast-forwarded through source commit `5a7905f`; local terminal-link
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
The Windows R package comparison identified `rdtools` 0.1.0 as missing; its
official CRAN Windows binary is now installed. R's `translations` entry is data,
not a loadable package namespace.

Visual Studio 2022 is restoring the reviewed 40 workload/component IDs; Rtools
and Docker Desktop follow in the prepared Windows installer sequence. Git
2.55.0.windows.5 and CUDA 13.3.1 installers were downloaded, their published
SHA-256 values matched, and publisher signatures were valid. CUDA installation
will select the 42 reviewed toolkit subpackages and retain the already verified
NVIDIA 616.56 driver. TeX Live's native GPG verifier was restored and its repository
signature check passed; the manager/package update is running.

PowerShell 7.6.5 and Google Cloud SDK 583.0.0 are working standalone installations,
despite not appearing as ordinary WinGet installations. Account-dependent Office
installation still needs its prior edition/subscription identified.
See the [recovery report](recovery-2026-09-06.md) for previously restored apps,
Drive, Norton, editor integration and GPU checks.

No WSL update, environment migration, distro restart or Docker WSL data restoration
is included after the Windows-only instruction. The original Docker disk remains
preserved, with an explicit guard deferring its restoration.
