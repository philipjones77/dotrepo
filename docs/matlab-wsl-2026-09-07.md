# Linux MATLAB on PhilipSecond

MATLAB R2026a Update 5 is installed natively in Ubuntu WSL at
`~/.local/opt/MATLAB/R2026a`. MathWorks Package Manager 2026.6 installed it,
using the official Ubuntu 24.04 dependency list. No Windows MATLAB installation
was made by this continuation.

The core installation completed and `matlab -help` works. The initial batch
calculation stopped with **MathWorks Licensing Error 1: unable to find a
license**. The MathWorks Product Activation and Login windows were confirmed
open through WSLg. Sign in there and select an entitled license; installation
alone does not establish that any product can run.

At the user's request, all **64 named toolboxes** in MathWorks' R2026a product
catalog were installed. The installer also selected Simulink and
Fixed-Point Designer as dependencies. The installer returned exit 0, and
`mpm list` verified **67 products total**, with none of the 64 requested
toolboxes missing. The final batch check still returned Licensing Error 1;
runtime and toolbox entitlement checks remain pending activation.
The [installed product inventory](../machines/source-2026-09-07/wsl-native/matlab.json)
records the exact product list and this limitation.

## Launch and editor integration

- `matlab` launches the Linux installation.
- `matlab-activate` opens the MathWorks activation client.
- A **MATLAB R2026a (Ubuntu)** desktop launcher was created under
  `~/.local/share/applications`.
- WSL VS Code has `mathworks.language-matlab` 1.3.13 installed. Its local
  `MATLAB.installPath` points to the Linux installation, and `MATLAB.signIn`
  is enabled. Machine-specific settings are in the ignored
  `vscode/wsl/settings.local.json` and the live WSL VS Code machine settings.

## Reproduce the installation

Install the [official Linux prerequisites](https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html)
for the selected release and distribution. The exact list used was
[`r2026a/ubuntu24.04/base-dependencies.txt`](https://github.com/mathworks-ref-arch/container-images/blob/main/matlab-deps/r2026a/ubuntu24.04/base-dependencies.txt).
Then, from the native dotrepo checkout:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://www.mathworks.com/mpm/glnxa64/mpm -o ~/.local/bin/mpm
chmod 755 ~/.local/bin/mpm
mapfile -t toolboxes < wsl/matlab-toolboxes-r2026a.txt
~/.local/bin/mpm install --release=R2026a \
  --destination="$HOME/.local/opt/MATLAB/R2026a" \
  --products MATLAB "${toolboxes[@]}"
~/.local/bin/mpm list --matlabroot="$HOME/.local/opt/MATLAB/R2026a"
```

The toolbox list comes from MathWorks' R2026a MPM template. It covers named
toolboxes; hardware support packages and standalone server products are not
part of this request. Required dependencies are added by MPM.

Activate each machine through its own MathWorks account/license flow:

```bash
~/.local/opt/MATLAB/R2026a/bin/glnxa64/MathWorksProductAuthorizer.sh
~/.local/opt/MATLAB/R2026a/bin/matlab -batch 'disp(version); assert(2+2==4); ver'
```

Private installer and activation logs remain under
`~/projects/dotrepo/.local/linux-python-migration/`. Credentials, license files
and MATLAB binaries are not stored in Git.

## WSL connection recovery during installation

New Ubuntu commands briefly failed with `Wsl/Service/0x8007274c` while existing
processes continued. The system distribution remained accessible. `dmesg`
showed an order-7 page allocation failure in `vmbus_alloc_ring`/`hvs_probe`,
with about 11 GiB of file cache and almost all of the 24 GiB swap free.
The following one-time recovery restored new Ubuntu connections:

```powershell
wsl.exe --system --user root --exec sh -c 'sync && echo 1 > /proc/sys/vm/drop_caches && echo 1 > /proc/sys/vm/compact_memory'
```

Afterwards, free Linux memory was about 10.7 GiB, the scientific job was still
running, and MATLAB installation had advanced to 66%. No WSL restart, process
termination or persistent kernel tuning was needed. This is a diagnostic
recovery for the observed allocation failure, not a periodic cache-clearing task.
See the [kernel documentation](https://docs.kernel.org/admin-guide/sysctl/vm.html)
and [matching WSL issue](https://github.com/microsoft/WSL/issues/11612).
