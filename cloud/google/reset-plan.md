# Google Tooling Reset Plan

This plan covers an explicitly requested reset of Google Cloud CLI and Gemini
CLI on Windows and WSL. Routine maintenance uses the
[Windows/WSL runbook](../../docs/windows-wsl-maintenance.md); an update does not
require deleting authentication state.

It is intentionally not an automatic uninstall script. The uninstall step can
delete auth/config state, so it should be run only after inventory and backup.

## Official Source Notes

Google documents Cloud CLI uninstall as install-method specific:

- OS package installs should be removed through the OS package manager.
- Windows installer installs should run `uninstaller.exe` in the Cloud SDK
  directory.
- Manual/archive installs require locating the SDK root and config directory,
  then deleting those directories and shell init snippets.

Gemini CLI documents quick install paths:

- no-install execution with `npx @google/gemini-cli`
- global npm install with `npm install -g @google/gemini-cli`
- Homebrew/MacPorts on supported systems
- a conda environment with Node/npm for restricted environments

## Historical inventory on 2026-06-27

These observations are historical, not the current machine state. The
[2026-09-06 report](../../docs/maintenance-2026-09-06.md) records the later
Windows and WSL installations and updates. Inventory the actual owning package
manager again before using any reset command.

Windows:

- `gcloud`, `gsutil`, `bq`, `gemini`, `node`, and `npm` were not found on PATH.
- Common Google Cloud SDK install directories under Program Files,
  `%LOCALAPPDATA%`, and `%USERPROFILE%` were not found.
- `%USERPROFILE%\.gemini` existed and contained Antigravity/Gemini-related state.
  Treat it as private local state.

WSL Ubuntu:

- `gcloud`, `gsutil`, and `bq` are available under `/usr/bin`.
- `google-cloud-cli` is installed from the Google apt repository.
- An active gcloud account and project were configured. Keep their identifiers
  in private machine configuration; substitute `<your-account>` and
  `<your-project-id>` when following this plan.
- `gemini` CLI binary was not found on PATH.
- `~/.gemini` exists and contains Antigravity/Gemini-related state, including
  token-like files. Treat it as private local state.

## Target State

Windows:

- Google Cloud CLI: optional, installed only if Windows-native cloud workflows
  require it.
- Use Antigravity CLI for consumer/free Google coding accounts. Keep an existing
  Gemini CLI only for an explicitly supported licensed workflow. The shared
  Node LTS baseline is selected under `%USERPROFILE%\.local\nodejs\current`.
- If installed, both must be detected by `cloud/google/audit.ps1`.

WSL:

- Google Cloud CLI installed through apt package `google-cloud-cli`.
- apt source tracked by Google repository.
- Existing supported Gemini CLI workflows use isolated conda env `gemini-cli`;
  new consumer/free workflows use Antigravity CLI.
- `$HOME/.local/bin/gemini` wrapper exposes Gemini CLI in normal WSL shells.
- `GOOGLE_CLOUD_PROJECT` and Gemini/Vertex settings live in shell/profile or
  local env files, not in project source.

## Inventory Commands

Windows:

```powershell
.\cloud\google\audit.ps1
Get-Command gcloud,gsutil,bq,gemini,node,npm -ErrorAction SilentlyContinue
```

WSL:

```bash
./cloud/google/audit.sh
command -v gcloud gsutil bq gemini node npm
dpkg -l | grep -E 'google-cloud-cli|google-cloud-sdk|nodejs|npm'
gcloud info --format='value(installation.sdk_root)'
gcloud info --format='value(config.paths.global_config_dir)'
gcloud config configurations list
find ~/.gemini -maxdepth 2 -type f -printf '%p\t%s bytes\n'
```

## Backup Before Reset

Create a local-only backup under `.local/google-reset/<timestamp>/`.

Do not commit this backup.

Preferred dotrepo commands:

```powershell
.\cloud\google\backup-state.ps1
```

```bash
./cloud/google/backup-state.sh
```

WSL examples:

```bash
mkdir -p ~/.local/share/dotrepo/google-reset/$(date +%Y%m%d-%H%M%S)
gcloud config configurations list > ~/.local/share/dotrepo/google-reset/latest-gcloud-configurations.txt
gcloud info > ~/.local/share/dotrepo/google-reset/latest-gcloud-info.txt
tar -czf ~/.local/share/dotrepo/google-reset/gemini-state.tgz -C "$HOME" .gemini
```

Windows examples:

```powershell
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path $HOME ".local\share\dotrepo\google-reset\$stamp"
New-Item -ItemType Directory -Path $backup -Force | Out-Null
if (Get-Command gcloud -ErrorAction SilentlyContinue) {
    gcloud info | Out-File (Join-Path $backup "gcloud-info.txt")
    gcloud config configurations list | Out-File (Join-Path $backup "gcloud-configurations.txt")
}
if (Test-Path "$HOME\.gemini") {
    Compress-Archive -Path "$HOME\.gemini" -DestinationPath (Join-Path $backup "gemini-state.zip")
}
```

## WSL Uninstall Plan

For a confirmed APT-owned installation, review removal through APT. Standalone
and Snap SDKs have separate owners and are not removed by this command:

```bash
sudo apt remove google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin google-cloud-cli-minikube google-cloud-cli-skaffold
sudo apt autoremove
```

Optional deeper purge, only after backup:

```bash
sudo apt purge google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin google-cloud-cli-minikube google-cloud-cli-skaffold
rm -rf ~/.config/gcloud ~/.cache/gcloud
rm -rf ~/.gemini
```

Review `~/.boto`, `~/.bashrc`, `~/.profile`, and `~/.zshrc` for old Google SDK
path/completion snippets before deleting lines.

## Windows Uninstall Plan

Windows now has a standalone Cloud SDK and Node tooling. Locate its owning
installation and back up its state before selecting an uninstall method:

- If installed by the Google Cloud SDK installer, run the SDK
  `uninstaller.exe`.
- If installed by `winget`, uninstall with `winget uninstall`.
- If Gemini CLI was installed by npm, uninstall with:

```powershell
npm uninstall -g @google/gemini-cli
```

Then inspect `%APPDATA%`, `%LOCALAPPDATA%`, and `%USERPROFILE%` for Google Cloud
or Gemini config/state directories before deleting anything.

## Reinstall Plan

WSL Cloud CLI:

```bash
sudo apt update
sudo apt install google-cloud-cli
gcloud init
gcloud auth application-default login
```

WSL Gemini CLI, only for an explicitly supported licensed workflow:

```bash
./cloud/google/install-gemini.sh
```

Windows Cloud CLI:

Install from the official Google Cloud CLI installer or chosen Windows package
manager, then run:

```powershell
gcloud init
gcloud auth application-default login
```

Windows Gemini CLI, only for an explicitly supported licensed workflow:

```powershell
.\cloud\google\install-gemini.ps1
```

## Verification After Reinstall

Windows:

```powershell
.\cloud\google\audit.ps1
gcloud config configurations list
gemini --version
```

WSL:

```bash
./cloud/google/audit.sh
gcloud config configurations list
gemini --version
```

## Do Not Commit

- `.config/gcloud`
- `.gemini`
- `.boto`
- service-account JSON keys
- OAuth tokens
- API keys
- generated local reset backups
