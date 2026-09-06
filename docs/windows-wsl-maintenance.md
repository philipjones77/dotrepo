# Windows and WSL setup and maintenance

Use this runbook to bring another workstation into agreement with dotrepo. The
[2026-09-06 results](maintenance-2026-09-06.md) record one inspected machine;
installed versions and hardware limits there are evidence, not universal pins.
Substitute the distribution, usernames, repository owner, environment names and
Drive remote for the target machine. Keep raw inventories and backups private.

## Standard and first application

| Area | Standard |
| --- | --- |
| Checkouts | Windows `C:\dev\dotrepo`; WSL `~/projects/dotrepo`; each has its own Git metadata |
| Shell | Ubuntu Bash for Windows Terminal and WSL; PowerShell for native Windows administration and VS Code terminals |
| GitHub | SSH transport; separate private keys per machine and platform; register each public key independently |
| Drive | Windows Google Drive for desktop; separately authorized WSL rclone at `~/mnt/gdrive` |
| Configuration | Back up existing files, merge editor/terminal settings, keep host exceptions in local override files |
| Environments | Native platform storage; upgrade scientific environments only with their workload validation |

Inspect both clones before pulling: `git status --short`, `git remote -v`,
`git fetch --prune origin`, and `git log --oneline --left-right HEAD...origin/main`.
Preserve and reconcile local changes first; then use `git pull --ff-only` in each
clone. Do not replace a dirty clone with a reset. Capture initial state with
`scripts/dotrepo.ps1 -Action capture -Platform all` and save configuration backups
outside Git. The private `.local/` directory is available for working reports.

Create missing clones independently. If SSH is not ready, an initial HTTPS clone
is sufficient to run the SSH setup. From the Windows checkout:

```powershell
.\scripts\dotrepo.ps1 -Action ssh -Platform windows
.\scripts\dotrepo.ps1 -Action ssh -Platform wsl -Distribution Ubuntu
.\scripts\dotrepo.ps1 -Action install -Platform windows
.\scripts\dotrepo.ps1 -Action install -Platform wsl -Distribution Ubuntu
.\scripts\dotrepo.ps1 -Action doctor -Platform all -Distribution Ubuntu -Network
```

Register the generated public keys and verify GitHub's host fingerprint before
the network doctor. Git author identities may intentionally differ. Keep extra
SSH entries in `~/.ssh/config.local` and Git identity overrides in
`~/.gitconfig.local`; see [SSH setup](../ssh/README.md). Never copy another
machine's private keys or Google tokens.

The installers register `~/.dotrepo` as a compatibility link to the chosen
checkout. If it is an old directory or points elsewhere, inspect and back it up
before explicitly reconciling it. Bootstrap preserves `.wslconfig` and
`/etc/wsl.conf` by default. Select a hardware profile only after measuring the
other host's RAM; do not copy this workstation's limits blindly.

Bash preserves Ubuntu's prompt, history, completion and Miniforge setup. Put
host PATH/data exceptions in `~/.config/dotrepo/shell.local.sh`. If needed, select
Bash with `chsh -s /bin/bash` inside that user's WSL session. PowerShell console
and VS Code host profiles use the actual Windows Documents location, including
redirection. Installation does not change execution policy. Add `-InstallTools`
only when the tracked extension/npm manifests have been reviewed for that host.

## Google Drive on both platforms

Run `windows/google-drive.ps1 -Install`, sign in through Google Drive for desktop,
and verify its chosen drive letter. Windows normally uses `G:\My Drive`.
In WSL, install `rclone` and `fuse3`, run `rclone config`, and authorize that
platform separately. Create local `~/.config/dotrepo/gdrive.env`, for example:

```bash
DOTREPO_GDRIVE_REMOTE='your-drive:'
DOTREPO_GDRIVE_PATH="$HOME/mnt/gdrive"
DOTREPO_GDRIVE_READ_ONLY=0
DOTREPO_GDRIVE_CACHE_MAX_SIZE=2G
DOTREPO_GDRIVE_CACHE_MAX_AGE=1h
```

`0` explicitly selects the writable access used on the inspected machine; the
repository default is read-only. Then run:

```bash
bash wsl/mounts/install.sh
bash wsl/mounts/gdrive.sh status
```

One locked startup helper owns the mount. Writable mode uses `writes` caching,
with 2 GiB/one-hour eviction targets; open files and pending uploads may exceed
them. Settings apply to the next mount, not an existing one. Verify one rclone
mount process after restarting WSL. `/mnt/g` is optional Windows-drive
compatibility, not a prerequisite for native rclone access. See the
[Drive guide](../cloud/google-drive/README.md) for startup and stop commands.

## Certificate and Norton repairs, only for matching symptoms

**WinGet Store pin mismatch:** the diagnosed `0x8a15005e` failure was Norton HTTPS
inspection replacing Microsoft's certificate. In Norton, open Security >
Advanced Security > Web > Safe Web gear > Exclusions and add only
`storeedgefd.dsx.mp.microsoft.com`. Retry a Store query such as
`winget search --id 9N0DX20HK701 --source msstore` and verify the endpoint presents
a Microsoft-issued certificate. Retain TLS verification and Store certificate
pinning. Do not disable Safe Web/HTTPS scanning globally or exclude all Microsoft
domains. Menu labels can vary by Norton release; see
[Norton's Safe Web domain exclusion guidance](https://support.norton.com/sp/en/gb/home/current/solutions/v20240108181826513).

**Conda behind an already trusted inspecting proxy:** back up `.condarc`, then
use `conda config --set ssl_verify truststore` and verify the actual configured
channel. This requires Conda 23.9+ and Python 3.10+. It uses the OS trust store;
it does not disable verification. [Conda documentation](https://docs.conda.io/projects/conda/en/stable/user-guide/configuration/settings.html#ssl-verify-ssl-verification).

**Node/VS Code Marketplace trust:** after confirming the inspecting CA is
trusted by Windows, record the previous user value and set:

```powershell
[Environment]::GetEnvironmentVariable('NODE_USE_SYSTEM_CA', 'User')
[Environment]::SetEnvironmentVariable('NODE_USE_SYSTEM_CA', '1', 'User')
```

Fully exit and reopen affected apps and terminals to inherit this value; reloading
a VS Code window can retain the old process environment. Verify HTTPS succeeds
with certificate authorization still true. The setting requires a supporting
Node runtime (introduced in 22.19/24.6). Do not use
`NODE_TLS_REJECT_UNAUTHORIZED=0`. [Node documentation](https://nodejs.org/api/cli.html#node_use_system_ca1).

**Drive desktop trust:** if its specific certificate-chain error recurs, use the
diagnosis and administrator helper in [the topology guide](topology.md).
Select a root already trusted on that machine; do not copy this host's root.

**Standalone Windows Cloud SDK trust:** for a matching certificate failure,
Google supports `core/custom_ca_certs_file`. Locate the actual standalone SDK;
this example uses the inspected layout. First record and reconcile any existing
`CLOUDSDK_AUTH_DISABLE_SSL_VALIDATION` or `CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE`
environment overrides, which take precedence over stored properties. Back up
the two properties and any existing bundle, then export public certificates from
the already trusted Windows root stores, excluding explicit distrust entries:

```powershell
$ErrorActionPreference = 'Stop'
$gcloud = Join-Path $env:LOCALAPPDATA 'Google\CloudSDKArchive\google-cloud-sdk\bin\gcloud.cmd'
$bundle = Join-Path $env:USERPROFILE '.local\share\certs\windows-root-ca.pem'
$backup = Join-Path $env:USERPROFILE ('.dotrepo-backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-gcloud-trust')
New-Item -ItemType Directory -Path $backup | Out-Null
$before = [ordered]@{}
foreach ($property in @('auth/disable_ssl_validation', 'core/custom_ca_certs_file')) {
    $before[$property] = ((& $gcloud config get $property | Out-String).Trim())
    if ($LASTEXITCODE) { throw "Cannot record $property; stop before changes." }
}
$before | ConvertTo-Json | Set-Content (Join-Path $backup 'properties.json')
if (Test-Path -LiteralPath $bundle) { Copy-Item -LiteralPath $bundle -Destination $backup }
$certificates = @(Get-ChildItem Cert:\CurrentUser\Root,Cert:\LocalMachine\Root | Sort-Object Thumbprint -Unique)
$blocked = @(Get-ChildItem Cert:\CurrentUser\Disallowed,Cert:\LocalMachine\Disallowed -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Thumbprint)
$certificates = @($certificates | Where-Object { $_.Thumbprint -notin $blocked })
if (-not $certificates.Count) { throw 'No trusted roots found.' }
$pem = foreach ($certificate in $certificates) {
    '-----BEGIN CERTIFICATE-----'
    [Convert]::ToBase64String($certificate.RawData, [Base64FormattingOptions]::InsertLineBreaks)
    '-----END CERTIFICATE-----'
}
New-Item -ItemType Directory -Path (Split-Path -Parent $bundle) -Force | Out-Null
[IO.File]::WriteAllText($bundle, ($pem -join "`n") + "`n", [Text.Encoding]::ASCII)
```

Test the bundle with certificate validation enabled before persisting settings.
The process overrides are restored even if verification fails:

```powershell
$priorDisable = $env:CLOUDSDK_AUTH_DISABLE_SSL_VALIDATION
$priorBundle = $env:CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE
try {
    $env:CLOUDSDK_AUTH_DISABLE_SSL_VALIDATION = 'false'
    $env:CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE = $bundle
    & $gcloud components list --format=json
    if ($LASTEXITCODE) { throw 'Trust verification failed; do not persist or update.' }
} finally {
    $env:CLOUDSDK_AUTH_DISABLE_SSL_VALIDATION = $priorDisable
    $env:CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE = $priorBundle
}
& $gcloud config set core/custom_ca_certs_file $bundle
if ($LASTEXITCODE) { throw 'Could not save the verified bundle path.' }
& $gcloud config set auth/disable_ssl_validation false
if ($LASTEXITCODE) { throw 'Could not enable certificate validation.' }
& $gcloud components list --format=json
if ($LASTEXITCODE) { throw 'Persisted trust verification failed.' }
# Only after the verified inventory and update review:
& $gcloud components update
if ($LASTEXITCODE) { throw 'Cloud SDK update failed.' }
```

This exports no private keys and installs no new root certificate. Keep the PEM
and property backup private. It is a snapshot: regenerate from the current Root
and Disallowed stores and repeat verification when Windows/Norton trust changes.
Restore specific prior properties and the prior bundle from the backup when
rolling back; do not assume another machine had the same initial settings.
[Google's supported custom-CA configuration](https://docs.cloud.google.com/sdk/docs/proxy-settings).

**PowerShell alerts:** verify the installed console/VS Code profiles and the
actual command that triggered detection. A historical Norton details-dialog
failure does not establish that an alert was a false positive. No blanket
PowerShell, VS Code, repository or execution-policy exception is part of this
standard. Use a reproducible detection and Norton's supported review process if
an alert recurs.

## Update each owning package manager

The following are separate update scopes. Run commands in the indicated native
shell, and replace IDs/prefixes with the installation found on that machine.

| Software scope | Inventory/review | Owning update command |
| --- | --- | --- |
| Windows WinGet applications | `winget upgrade --source winget` | `winget upgrade --id <ID> --exact --source winget` |
| Windows Store applications | `winget upgrade --source msstore` | `winget upgrade --id <Store-ID> --exact --source msstore` |
| Windows VS Code extensions | `code --list-extensions --show-versions` | `code --update-extensions` |
| WSL remote extensions | `<server>/bin/code-server --list-extensions --show-versions` | Same server CLI with `--update-extensions` and the explicit WSL extension directory |
| Windows Anaconda base apps | `conda list -n base --explicit`, `conda list -n base --revisions` | Review `conda update -n base conda conda-build jupyterlab notebook spyder --dry-run`, then apply with the Python series retained |
| WSL Conda/Mamba base | `~/miniforge3/bin/conda list -n base --explicit` | `~/miniforge3/bin/conda update -n base conda mamba` after its dry-run |
| WSL Gemini/npm | Dedicated environment's `npm list -g --depth=0`, `npm outdated -g` | Dedicated environment's `npm install -g --engine-strict npm@<reviewed-version> @google/gemini-cli@<reviewed-version>` |
| Other Windows npm globals | Owning prefix's `npm outdated -g` | Owning prefix's `npm install -g <package>@<reviewed-version>` after engine checks |
| Shared Node runtime | Compare `node --version` with `node/.node-version` and `node/.nvmrc` | Select the reviewed 24.20.0 LTS baseline through the existing runtime manager, or a verified official portable installation |
| Standalone Cloud SDK, each OS | Explicit installation's `gcloud version` and `gcloud components list` | That installation's `gcloud components update` (`gcloud.cmd` on Windows) |
| Windows pipx manager | Owning Python's `python -m pip show pipx`, `python -m pip check` | Owning Python's `python -m pip install --user --upgrade pipx`, subject to reviewed constraints |
| pipx-managed radian | `python -m pipx list` | `python -m pipx upgrade radian` |
| Ubuntu APT / Snap | Strict metadata refresh, APT dry-run, `snap refresh --list` | Reviewed `apt-get --no-remove upgrade`; `snap refresh` |
| Windows OS / WSL runtime | Windows Update plus release-support audit; `wsl --version` | OS feature update reviewed separately; `wsl --update` for WSL |

Wait for jobs and uploads to finish. Record versions, Conda explicit package
lists/revisions and relevant project history before changes. Review Windows
`winget upgrade` results per application; inspect native installers and verify
their exit codes and selected runtime afterward. Keep major CUDA/Julia/Perl
changes separate when they would alter project toolchains. Update existing
Anaconda through Conda rather than overlaying a full distribution installer.
The shared Node baseline is 24.20.0 LTS. Preserve separately owned APT Node 18,
dedicated Gemini Node 26.4.0 and project-specific runtime selections; verify
`node --version` and the executable path in each intended shell after selection.

In Windows, run `wsl --version` and `wsl --update`. Inside WSL:

```bash
sudo apt-get -o APT::Update::Error-Mode=any update
apt-get --simulate --no-remove upgrade
# Apply only after reviewing that plan:
sudo apt-get --no-remove upgrade
sudo snap refresh
sudo dpkg --audit
snap refresh --list
```

If an existing vendor repository fails signature verification, inspect its
`signed-by` configuration and back up the source/keyring files first. Download
keys to a temporary directory, inspect fingerprints, and compare with the current
vendor documentation before installing. For the existing Ubuntu 24.04 sources:

| Vendor | Official key endpoint | Existing keyring destination |
| --- | --- | --- |
| GitHub CLI | `https://cli.github.com/packages/githubcli-archive-keyring.gpg` | `/etc/apt/keyrings/githubcli-archive-keyring.gpg` |
| Microsoft | `https://packages.microsoft.com/keys/microsoft.asc` | `/usr/share/keyrings/microsoft.gpg` after `gpg --dearmor` |

Use `curl --fail --location --proto '=https' --tlsv1.2 --output <staged-file>
<official-url>`, `gpg --show-keys --with-fingerprint <staged-file>`, and
`sudo install -o root -g root -m 0644 <verified-keyring> <signed-by-path>`.
GitHub publishes current keyring checksums and fingerprints in its
[installation instructions](https://github.com/cli/cli/blob/trunk/docs/install_linux.md).
Microsoft uses different keys for newer repositories; select the key for the
actual repository using its [Linux repository documentation](https://learn.microsoft.com/en-us/linux/packages).
Rerun strict `apt-get update` and the dry-run after repair. Do not use
`trusted=yes`, allow-unauthenticated packages or expired-key bypasses.

Use explicit environment/installation paths for standalone tools. Examples for
an already inspected Miniforge layout:

```bash
~/miniforge3/bin/conda list -n base --explicit > /path/to/private/base-before.txt
~/miniforge3/bin/conda list -n base --revisions > /path/to/private/base-revisions.txt
~/miniforge3/bin/conda update -n base conda mamba --dry-run
# Apply the reviewed transaction, then verify CLI imports and project histories.
~/miniforge3/bin/conda update -n base conda mamba
~/google-cloud-sdk/bin/gcloud components update
```

For Gemini/npm, activate the dedicated CLI environment, verify `command -v node`,
`npm prefix -g` and candidate `npm view <package>@<version> engines`, then install
the reviewed versions. Do not run a blanket upgrade in JAX or shared user Python
packages. APT, Snap and user-directory Cloud SDK copies have different owners;
`gcloud components update` belongs only to the standalone SDK.

The dated Gemini transaction was `npm install -g --engine-strict npm@12.0.2
@google/gemini-cli@0.58.0` with Node 26.4.0 in its dedicated environment. On
Windows, pipx 1.17.2 conflicted with an existing application's packaging bound;
the reviewed compatible install was `python -m pip install --user --upgrade
"pipx==1.16.7" "packaging<26"`, followed by `python -m pipx upgrade radian` and
`python -m pip check`. Treat those as dated compatibility decisions, not an
instruction to impose the same versions on a different Python environment.

Run `code --update-extensions` on Windows. Inventory WSL remote extensions
separately; use the matching installed server's `bin/code-server --help`, then
`--extensions-dir "$HOME/.vscode-server/extensions" --update-extensions` if
supported. Save before/after ID/version lists and preserve unavailable extensions.
The server commit must match the selected VS Code client; the WSL extension
normally manages server installation. [VS Code CLI documentation](https://code.visualstudio.com/docs/configure/command-line).

## Correct viewers and temporary chat-link repair

Bootstrap merges explicit PDF/image/Markdown preview associations from
`vscode/windows/settings.json` and `vscode/wsl/settings.json`. Markdown diffs
remain text; source links retain text editing and line selection. Install the
existing `tomoki1207.pdf` viewer on the Windows UI side. Images and Markdown use
built-in viewers. Use **Reopen Editor With** to select another view for one file.

The known Codex/Claude extension builds forced ordinary links through a text-only
opening API. The repository's guarded repair is temporary and applies only to
recognized Codex 26.901.22334 / Claude Code 2.1.263 bundles:

```powershell
node .\scripts\repair-chat-file-links.cjs --check
node .\scripts\repair-chat-file-links.cjs --apply
node .\scripts\repair-chat-file-links.cjs --self-test
```

Run the same helper **inside WSL** for remote-installed extensions:

```bash
cd ~/projects/dotrepo
node scripts/repair-chat-file-links.cjs --check --wsl-distro Ubuntu
node scripts/repair-chat-file-links.cjs --apply --wsl-distro Ubuntu
```

Check mode is the default. The native OS selects `.vscode/extensions` or
`.vscode-server/extensions`; `--extensions-dir <path>` overrides that choice.
`--wsl-distro` selects path translation, not remote execution. Apply mode backs
up recognized bundles and verifies the original version/SHA-256 before changes;
unknown versions/builds are refused. Restart the affected extension host after applying.
Extension updates can overwrite this repair; check the new version before doing
anything further. Restore the saved original or reinstall that extension to
undo. This is not a promise about all future links: wrong/missing paths, cloud-only
attachments and unrelated app handlers require separate diagnosis. Windows
default apps are independent of VS Code's internal editor associations.

## Reclaim space and validate

After packages/jobs finish, review cache sizes and run only disposable cleanup:

```bash
conda clean --tarballs --index-cache --dry-run
conda clean --tarballs --index-cache
python -m pip cache info
python -m pip cache purge
npm cache clean --force
sync
sudo fstrim -v /
```

Use the intended environment's manager paths. Keep extracted Conda package
entries, project/JAX build caches and rclone upload caches. These commands trade
download cache reuse for disk space; they do not remove installed environments.
Save work and have current data backups before offline compaction. Close WSL
editor connections and stop writers; from administrator PowerShell run:

```powershell
.\wsl\compact-ubuntu.ps1 -Distribution Ubuntu
```

The helper stops **all** WSL distributions. Read the DiskPart completion message
and compare VHD bytes; a successful shell exit alone is insufficient. Restart
Ubuntu, then verify Bash/user identity, GitHub repository SSH access, Drive mode
and one mount process, `dpkg --audit`, and relevant CLI/project smoke tests.
Run `scripts/dotrepo.ps1 -Action doctor -Platform all -Network`, repository
validation, and capture inventories. Keep Windows Update/OS checks distinct from
WinGet application updates. See [WSL operations](../wsl/README.md).

Restore specific files from timestamped backups after checking their targets.
Private keys, OAuth configuration, certificate bundles, package-source credentials,
raw reports and WSL exports stay outside version control. Commit reviewed scripts
and sanitized results; pull/apply them independently on the other machine.
