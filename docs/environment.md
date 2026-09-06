# Environment contract

`config/environment.json` defines supported platforms, required/optional commands, GitHub transport, and paths to environment/profile definitions. The validator checks the referenced files exist. The doctor checks live machines; it never repairs them silently.

## Shared versus local

Projects belong in `C:\dev` on Windows and `~/projects` in WSL. `PROJECTS_HOME` and the `croot` shell command use those roots. The repository lives at `C:\dev\dotrepo` and `~/projects/dotrepo`; `~/.dotrepo` is only its compatibility link. Do not keep loose project outputs in the home root.

Home folders retain application installations, package environments/caches, R libraries, editor state, credentials, shell configuration, mount points, and standard Windows user folders. Archive loose personal files under the platform project root's `_archive/home-tidy-<timestamp>/` after inspection. Do not broadly delete hidden files or relocate application folders. Record every move so it can be reversed.

- Shared: SSH transport for GitHub Git operations, default branch, Git behavior, shell utilities, editor extension manifests, validation commands and workflow standards.
- Platform-specific: Windows and WSL Git names/emails, Python environment definitions, native paths, shell/editor integration.
- Machine-specific: independent SSH private keys, additional GitHub account aliases, hardware profile, software licenses, GPU drivers, and project-specific environments.

Keep additional SSH host entries in `~/.ssh/config.local`; it is included before tracked entries so first-value OpenSSH precedence allows overrides. Put Git identity exceptions in `~/.gitconfig.local`, included last. Do not copy private keys between machines to make them identical. Register each machine/platform's public key separately.

## Apply and inspect

Run `scripts/dotrepo.ps1 -Action install -Platform windows|wsl` from Windows or `bash scripts/dotrepo.sh install` inside WSL. Use a separate Linux-native checkout for performance, especially when installing Python packages. A canonical `~/.dotrepo` link lets shell and Git includes work regardless of the actual checkout folder. Conflicting existing checkouts require an explicit choice; installers do not move them.

Bootstraps replace tracked settings with backups. They preserve WSL VM settings unless an explicit Windows profile is selected, and preserve existing distro boot/network/user settings. Windows profile selection is opt-in and does not restart WSL. The `memory-32gb` profile has a 16 GB RAM limit and 24 GB swap; the name describes host RAM.

The doctor reports required failures with exit 1. Missing optional applications are informational. `--network` checks actual GitHub SSH read access with existing known-hosts trust and batch authentication. It cannot approve passphrases or add public keys to accounts.

## Software lifecycle

| Layer | Desired definitions | Verification/update |
| --- | --- | --- |
| WSL runtime | Microsoft WSL release | `wsl --version`, `wsl --update` |
| Ubuntu libraries | Ubuntu/APT repositories | `sudo apt update`, reviewed upgrade, `dpkg --audit` |
| Python | `python/<platform>/` | Create environment, `pip check`, project tests |
| Node | `node/.node-version`, `.nvmrc` | Select runtime with fnm/nvm; install global list |
| R/MATLAB | Currently inventory only | Record R packages/MATLAB release; workload and license checks |
| VS Code | `vscode/<platform>/extensions.txt` | Explicit tool installation; compare inventory versions |
| GitHub Actions | `.github/workflows/` | Local validation plus Windows/Ubuntu CI |

These definitions do not yet lock every installed application or every project library. Promote inventory entries to reviewed definitions deliberately. CUDA/JAX, Windows CPU environments, and proprietary software may require different versions. Do not bulk-upgrade scientific environments just to make version numbers match.

## Recovery

Restore individual configuration files from the installer's timestamped backup after reviewing the target. WSL exports are full private backups; inventory captures are not. Keep exports outside Git. See `wsl/README.md` for full migration and offline compaction.
