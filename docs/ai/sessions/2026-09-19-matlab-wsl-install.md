# MATLAB R2026a installation on PC-PHILIP-WINDOWS

Date: 2026-09-19. Verified Windows and WSL host: **PC-PHILIP-WINDOWS**.
Target: **Ubuntu 24.04.4 LTS under WSL 2**, normal Linux user `phili`.

The user requested installing MATLAB from the supplied Linux ZIP, with the
same **64 named toolboxes** as the [PhilipSecond installation](../../matlab-wsl-2026-09-07.md).
That other machine's installation and activation are separate; no credentials
or activation data are copied between machines.

## Installer and product selection

The supplied Windows archive is `matlab_R2026a_Linux (1).zip`, SHA256:

```text
35B8DA331627F7B1F54342DBC8101E6C057D78C9C092163FFBBFEA9ABB119744
```

Its extracted metadata identifies **R2026a Update 5**, version
**26.1.0.3346908**. The ZIP contains the bootstrap installer, so product
payloads require downloading. The archive is retained.

The installation uses official **MathWorks Package Manager 2026.7**, pinned
to the archive's release with `--release=R2026aU5`. The destination is
`~/.local/opt/MATLAB/R2026a`; the older incomplete `~/MATLAB` tree is retained.
The requested products come from the committed
[64-toolbox list](../../../wsl/matlab-toolboxes-r2026a.txt):

```bash
mapfile -t toolboxes < wsl/matlab-toolboxes-r2026a.txt
mpm install --release=R2026aU5 \
  --destination="$HOME/.local/opt/MATLAB/R2026a" \
  --products MATLAB "${toolboxes[@]}"
```

MPM completed with exit 0. Its inventory reports **67 products**: MATLAB,
all 64 requested toolboxes, Simulink and Fixed-Point Designer. Every requested
product was compared with that inventory; none is missing. Installed
products alone do not establish entitlement to each toolbox.

The installation occupies approximately **21 GiB**. The
[sanitized installation receipt](../../../machines/pc-philip-windows-2026-09-19/matlab-install.json)
records the product list and verification status.

## Completed prerequisites

Compared Ubuntu against the official
[R2026a Ubuntu 24.04 amd64 dependency list](https://raw.githubusercontent.com/mathworks-ref-arch/container-images/main/matlab-deps/r2026a/ubuntu24.04/base-dependencies-amd64.txt).
Of its 76 required packages, 59 were present and 17 were missing. A reviewed
APT simulation and installation with `--no-remove --no-upgrade` added
**35 packages**: the 17 requirements and 18 dependencies. APT exited 0.

After installation, all **76 required packages** were present. Complete
before/after package inventories confirmed **no pre-existing packages were
changed or removed**. Package inventories, manual selections, the simulation,
installation log and prerequisite receipt are private under
`~/.local/state/dotrepo/matlab-install-2026-09-19/prerequisites-*`.

WSLg X11 and Wayland sockets were available. No MATLAB, MathWorks or MPM
processes were running at the initial check. No existing local MATLAB
activation was found in the standard locations checked; activation must be
verified independently after installation.

## Launchers and activation

The normal WSL login shell resolves `matlab` and `matlab-activate` through
`~/.local/bin`. The first launches the Linux installation; the second opens
the MathWorks activation client. A **MATLAB R2026a (Ubuntu)** desktop launcher
is registered under `~/.local/share/applications`. Existing editor settings
were not changed.

The initial batch launch returned MathWorks Licensing Error 1 because no
local MATLAB license was available. The WSLg **MathWorks Product Activation**
window was opened for this machine's own sign-in. Activation and runtime
verification are pending the user's completion of that flow. The prepared
runtime checks cover the MATLAB license, arithmetic, a matrix solve, an FFT
roundtrip and the runtime product inventory.

Private logs, credentials, license files, installer payloads and MATLAB
binaries remain outside Git. Installation evidence is distinct from a
successful licensed MATLAB launch.

## WSL connection recovery

During installation, new Ubuntu commands returned `Wsl/Service/0x8007274c`,
while the existing installer continued. Windows could still read its log
through the WSL filesystem share. The kernel recorded an order-7 allocation
failure in `vmbus_alloc_ring`/`hvs_probe`, with available memory concentrated
in file cache. This matched the earlier
[documented installation issue](../../matlab-wsl-2026-09-07.md#wsl-connection-recovery-during-installation).

The same one-time recovery was applied through the WSL system distribution:
`sync`, then writing `1` to `/proc/sys/vm/drop_caches` and
`/proc/sys/vm/compact_memory`. Free guest memory rose to 3.4 GiB, and fresh
Ubuntu command connections worked again. The installer subsequently finished
successfully. No WSL restart, running-process termination or persistent memory
configuration change was performed.

Official references: [MathWorks Package Manager setup](https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html)
and [MATLAB R2026a Linux system requirements](https://www.mathworks.com/support/requirements/matlab-linux.html).
