# Two machines, Colab, and GitHub

The environment has six execution targets: machine 1 Windows, machine 1 WSL, machine 2 Windows, machine 2 WSL, Colab, and GitHub Actions. The second machine has not yet been inspected. `config/machines.example.json` is a template, not a claim that both machines have been provisioned.

`dotrepo` is the management repository. Each physical machine has two native clones: `C:\dev\dotrepo` for Windows and `~/projects/dotrepo` for WSL. Windows dispatches WSL operations to the native WSL clone, so both clones must be updated to the desired revision. Their Git metadata, Python environments and caches are independent. `~/.dotrepo` is the compatibility link installed on each side, not another working copy.

| Target | Shell/config | Google Drive | Authentication |
| --- | --- | --- | --- |
| Each Windows host | PowerShell plus shared repository policy | Google Drive for desktop; automatic login launch | Independent Git SSH key and Google sign-in |
| Each WSL Ubuntu | Bash baseline through `shared/shell/init.sh` | rclone at `~/mnt/gdrive`; read-only default, local writable opt-in | Independent SSH key and rclone authorization |
| Colab | Notebook runtime and project requirements | `google.colab.drive.mount('/content/drive')` | Interactive Google authorization; temporary runtime |
| GitHub Actions | Defined Windows/Ubuntu validation jobs | No personal Drive mount | Scoped GitHub token; project secrets only if required |

Git is the source of truth for scripts and reviewed environment definitions. Google Drive is for user data, not synchronizing live Python environments, `.git` directories, credentials or package caches. Updating GitHub does not update every machine automatically: each checkout must pull and apply the reviewed configuration.

## Bring a second machine into agreement

1. Capture its existing Bash configuration and Windows/WSL inventories before changes.
2. Compare its preferred Bash setup with this repository; merge useful behavior into `shared/shell/init.sh` and keep host exceptions in `~/.config/dotrepo/shell.local.sh`.
3. Pull the same repository revision into separate Windows and Linux-native checkouts.
4. Apply each platform's bootstrap and choose the hardware profile based on that host's RAM.
5. Register independent SSH public keys, sign in to Google Drive desktop, and configure rclone privately in WSL.
6. Run doctor, repository validation, and the actual project workloads. Compare inventories and document intentional package differences.

## Colab

Clone this repository into `/content/dotrepo`, then execute `%run /content/dotrepo/colab/setup.py` in a notebook cell. Approve Google authorization interactively. The script mounts Drive and saves `/content/dotrepo-colab-status.json`; it does not install WSL/Windows tools or downgrade Colab's managed CUDA stack. Install the project's Colab-compatible requirements and run its tests separately. No Colab runtime has been connected or validated from this session.

## Drive automation and shell baseline

On Windows, run `windows/google-drive.ps1 -Install` once, sign in, and use its Explorer drive. The script enables Google's supported `AutoStartOnLogin` user preference.

If Drive sign-in fails with `schannel: the certificate chain is incomplete`, check whether antivirus HTTPS inspection uses a root already trusted by Windows. For this diagnosed case, run `windows/repair-google-drive-trust.ps1 -RootThumbprint <machine-trusted-root-thumbprint>` from an administrator PowerShell, then restart Drive as the normal user. Select the certificate on each machine; do not copy a different machine's antivirus certificate. The script combines that root with Google's shipped roots, verifies TLS before applying settings, backs up the previous configuration, and uses Google's **machine-wide** `TrustedRootCertsFile` setting. TLS validation and revocation checks stay enabled. The bundle is stored under `%ProgramData%\dotrepo\google-drive-trust` with administrator-only write access. Regenerate it after root rotation or a Drive update that changes Google's bundled roots. To undo, restore the saved registry export (remove newly added values if they were absent before) and previous bundle, then restart Drive. Do not delete Drive's cache to fix this certificate error; it can contain files awaiting upload.

From the command center, run `scripts/dotrepo.ps1 -Action drive -Platform all` to start/configure both sides; add `-InstallTools` to install the Windows desktop app if missing. This does not sign in for you.

On WSL, run `bash wsl/mounts/install.sh`. The shared shell initializer starts `wsl/mounts/gdrive.sh` asynchronously; a lock prevents duplicate starts. A WSL session can have a different mount namespace from systemd, so this runs in the interactive session rather than assuming a systemd mount is visible. `start`, `status`, and `stop` are available on the helper. Existing mounts are preserved. Credentials stay in the user's private rclone configuration.

The remote can be selected in `~/.config/dotrepo/gdrive.env` with `DOTREPO_GDRIVE_REMOTE='remote-name:'` and the path with `DOTREPO_GDRIVE_PATH="$HOME/mnt/gdrive"`. The existing local convention is `philip.a.jonesmngoogle:`. The default is read-only. This machine preserves writable access through the explicit local setting `DOTREPO_GDRIVE_READ_ONLY=0`; new writable mounts use `writes` caching with 2 GiB and one-hour eviction targets. Open files and pending uploads can exceed those targets. Existing mounts keep their current settings until restarted. Mounts require a network connection.

Windows Google Drive for desktop and WSL rclone are the two standard access paths. `/mnt/g` is optional compatibility for projects that use the Windows view; WSL rclone works independently. Legacy scripts under `cloud/google-drive` delegate to the canonical platform helpers. Environment setup starts no mounts; the shared initializer owns the single opted-in WSL hook. See [Drive configuration](../cloud/google-drive/README.md).

This machine's existing Bash has been inspected and is the standard: Ubuntu's colored user/path prompt, appended history, window-size checks, completion, and Miniforge activation. Machine-specific Linux-first PATH handling, scientific project paths, R libraries, and gcloud integration belong in `~/.config/dotrepo/shell.local.sh`. Existing local shell files are backed up before applying the baseline. The second machine still needs inspection before its local exceptions are reconciled.

This machine's WSL login shell is now `/bin/bash`. On another machine, select Bash explicitly with `chsh -s /bin/bash` after inspecting its current setup. Existing Zsh users can still source the same shared initialization through the tracked `.zshrc`.

Sources: [rclone mount](https://rclone.org/commands/rclone_mount/), [Google Drive desktop settings](https://knowledge.workspace.google.com/admin/drive/advanced-drive-for-desktop-configuration).
