# Environment contract

`config/environment.json` defines supported platforms, required/optional commands, GitHub transport, and paths to environment/profile definitions. The validator checks the referenced files exist. The doctor checks live machines; it never repairs them silently.

## Shared versus local

Projects belong in `C:\dev` on Windows and `~/projects` in WSL. `PROJECTS_HOME` and the `croot` shell command use those roots. The repository lives at `C:\dev\dotrepo` and `~/projects/dotrepo`; `~/.dotrepo` is only its compatibility link. Do not keep loose project outputs in the home root.

Home folders retain application installations, package environments/caches, R libraries, editor state, credentials, shell configuration, mount points, and standard Windows user folders. Archive loose personal files under the platform project root's `_archive/home-tidy-<timestamp>/` after inspection. Do not broadly delete hidden files or relocate application folders. Record every move so it can be reversed.

- Shared: SSH transport for GitHub Git operations, default branch, Git behavior, shell utilities, editor extension manifests, validation commands and workflow standards.
- Platform-specific: Windows and WSL Git names/emails, Python environment definitions, native paths, shell/editor integration.
- Machine-specific: independent SSH private keys, additional GitHub account aliases, hardware profile, software licenses, GPU drivers, and project-specific environments.

Keep additional SSH host entries in `~/.ssh/config.local`; it is included before tracked entries so first-value OpenSSH precedence allows overrides. Put Git identity exceptions in `~/.gitconfig.local`, included last. Do not copy private keys between machines to make them identical. Register each machine/platform's public key separately.

Bash is the preferred interactive shell. Windows Terminal opens the explicit
Ubuntu Bash profile; native Windows administration and local Windows VS Code
terminals use PowerShell. Windows VS Code automation explicitly uses PowerShell 7.
Both Windows PowerShell 5.1 and PowerShell 7 receive console and VS Code host
profiles in the actual Documents folder. These profiles configure the shell;
they do not change script execution policy or security-product exclusions.
WSL VS Code terminals use Bash. The shared Bash setup
preserves Ubuntu's color prompt, history append behavior, completion, and
Miniforge activation. Machine-specific PATH rules and project data paths live in
`~/.config/dotrepo/shell.local.sh`.

The inspected JAX interpreters are Anaconda `envs/jax-win` on Windows and
Miniforge `envs/jax` on WSL. Editor defaults use home-relative paths to those
existing environments. Project workspace settings can select other interpreters;
configuration installation does not create or upgrade scientific environments.

## Apply and inspect

Run `scripts/dotrepo.ps1 -Action install -Platform windows|wsl` from Windows or `bash scripts/dotrepo.sh install` inside WSL. Use a separate Linux-native checkout for performance, especially when installing Python packages. A canonical `~/.dotrepo` link lets shell and Git includes work regardless of the actual checkout folder. Conflicting existing checkouts require an explicit choice; installers do not move them.

Bootstraps apply tracked settings with backups. VS Code settings are merged so
unrelated local preferences survive. Windows Terminal keeps existing profiles
and customizations while applying the preferred profile, and PowerShell profiles
use the actual Windows Documents location, including folder redirection.
Bootstraps preserve WSL VM settings unless an explicit Windows profile is
selected, and preserve existing distro boot/network/user settings. Windows
profile selection is opt-in and does not restart WSL. The `memory-32gb` profile
has a 16 GB RAM limit and 24 GB swap; the name describes host RAM.

The doctor reports required failures with exit 1. Missing optional applications are informational. `--network` checks actual GitHub SSH read access with existing known-hosts trust and batch authentication. It cannot approve passphrases or add public keys to accounts.

## Software lifecycle

| Layer | Desired definitions | Verification/update |
| --- | --- | --- |
| Windows apps | Installed WinGet/Store inventory | Review `winget upgrade`; update each app and verify its result |
| WSL runtime | Microsoft WSL release | `wsl --version`, `wsl --update` |
| Ubuntu libraries | Ubuntu/APT repositories | `sudo apt update`, reviewed upgrade, `dpkg --audit` |
| Standalone tools | Conda base, npm, pipx, SDK inventories | Update their owning package manager; preserve project environments |
| Python | `python/<platform>/` | Create environment, `pip check`, project tests |
| Node | `node/.node-version`, `.nvmrc` | Select runtime with fnm/nvm; install global list |
| R/MATLAB | Currently inventory only | Record R packages/MATLAB release; workload and license checks |
| VS Code | `vscode/<platform>/extensions.txt` | Explicit tool installation; compare inventory versions |
| GitHub Actions | `.github/workflows/` | Local validation plus Windows/Ubuntu CI |

These definitions do not yet lock every installed application or every project library. Promote inventory entries to reviewed definitions deliberately. CUDA/JAX, Windows CPU environments, and proprietary software may require different versions. Do not bulk-upgrade scientific environments just to make version numbers match.

## Recovery

Restore individual configuration files from the installer's timestamped backup after reviewing the target. WSL exports are full private backups; inventory captures are not. Keep exports outside Git. See `wsl/README.md` for full migration and offline compaction.
