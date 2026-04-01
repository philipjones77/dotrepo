# dotrepo

Cross-platform dotfiles and reproducible developer environment for this computer: WSL Ubuntu, Windows PowerShell, Anaconda on Windows, Miniforge on WSL, and VS Code on both sides.

## What This Repo Tracks

- WSL shell startup files, aliases, PATH rules, and `/etc/wsl.conf`
- Windows PowerShell profile, Windows Terminal settings, and `.wslconfig`
- Git global config for WSL and Windows, including the current identities on each side
- SSH client config templates only; private keys stay manual
- VS Code settings for Windows and WSL Remote, plus keybindings, snippets, and extension inventories
- Python environment definitions for `jax` on WSL and `jax-win` on Windows
- Node version files and tracked global npm package list
- Bootstrap installers for WSL and Windows

## Layout

```text
dotrepo/
|-- bootstrap/
|-- git/
|-- node/
|-- python/
|   |-- windows/
|   `-- wsl/
|-- shared/shell/
|-- ssh/
|-- vscode/
|   |-- snippets/
|   |-- windows/
|   `-- wsl/
|-- windows/
|   |-- packages/
|   |-- powershell/
|   |-- terminal/
|   `-- wsl/
`-- wsl/
    |-- etc/
    `-- home/
```

## Clone And Install On A New Machine

Clone the repo separately on each side. WSL and Windows have different home directories, so each side should have its own checkout.

### WSL

```bash
git clone https://github.com/philipjones77/dotrepo.git ~/.dotrepo
~/.dotrepo/bootstrap/install.sh
```

### Windows

```powershell
git clone https://github.com/philipjones77/dotrepo.git $HOME\.dotrepo
& $HOME\.dotrepo\bootstrap\install.ps1
```

What the installers do:

- Back up any existing tracked files into `~/.dotrepo-backups/<timestamp>/` or `$HOME\.dotrepo-backups\<timestamp>\`
- Link the tracked shell, Git, SSH, and VS Code files into place
- Install `/etc/wsl.conf` on WSL
- Install `.wslconfig`, PowerShell profile, Windows Terminal settings, and local VS Code files on Windows
- Attempt to install the tracked VS Code extensions for each side

## Python Environment Reproducibility

### WSL

Tracked files:

- `python/wsl/requirements.txt`
- `python/wsl/environment.yml`
- `python/wsl/create-venv.sh`

Create a venv:

```bash
~/.dotrepo/python/wsl/create-venv.sh
```

Create or update the conda or mamba env:

```bash
mamba env create -f ~/.dotrepo/python/wsl/environment.yml
mamba env update -f ~/.dotrepo/python/wsl/environment.yml --prune
```

### Windows

Tracked files:

- `python/windows/requirements.txt`
- `python/windows/environment.yml`
- `python/windows/create-venv.ps1`

Create a venv:

```powershell
& $HOME\.dotrepo\python\windows\create-venv.ps1
```

Create or update the conda env:

```powershell
conda env create -f $HOME\.dotrepo\python\windows\environment.yml
conda env update -f $HOME\.dotrepo\python\windows\environment.yml --prune
```

## VS Code Sync

Tracked files:

- `vscode/windows/settings.json`
- `vscode/wsl/settings.json`
- `vscode/keybindings.json`
- `vscode/snippets/python.code-snippets`
- `vscode/windows/extensions.txt`
- `vscode/wsl/extensions.txt`

Machine-specific interpreter paths currently tracked:

- Windows: `C:/Users/phili/anaconda3/envs/jax-win/python.exe`
- WSL: `/home/phili/miniforge3/envs/jax/bin/python`

Re-running the platform bootstrap script reapplies the tracked settings and extensions.

## Node Reproducibility

This machine currently tracks Node `18.19.1`.

Tracked files:

- `node/.node-version`
- `node/.nvmrc`
- `node/global-packages.txt`

After installing `fnm` or `nvm`, install the tracked version and globals:

```bash
fnm install "$(cat ~/.dotrepo/node/.node-version)"
~/.dotrepo/node/install-globals.sh
```

```powershell
fnm install (Get-Content $HOME\.dotrepo\node\.node-version)
& $HOME\.dotrepo\node\install-globals.ps1
```

## SSH

`ssh/config` is tracked, but private keys are not.

1. Add your private key manually under `~/.ssh/` or `$HOME\.ssh\`.
2. Add the public key to GitHub.
3. Re-run the bootstrap script so the tracked config is linked into place.

The tracked config expects `~/.ssh/id_ed25519_github`.

## Updating The Repo

- Edit the tracked file in the repo, not the symlinked target.
- Re-run the relevant bootstrap script after changes.
- For Python, update `requirements.txt` and `environment.yml` together.
- For VS Code, update the settings file and the extension list together.
- For shell or PowerShell changes, open a fresh terminal after reinstalling.

## Adding New Settings Safely

- Keep secrets out of git. Never commit private keys, tokens, SSH agent sockets, or `.env` files.
- Prefer templates for credentials and machine-only paths when they are likely to vary.
- If a setting only applies to one side, keep it under `windows/` or `wsl/` instead of forcing it into a shared file.
- When changing a tracked target, let the bootstrap script back up the existing live file before replacing it.

## Notes About This Machine

- WSL distro: `Ubuntu`
- WSL default user: `phili`
- WSL conda root: `/home/phili/miniforge3`
- Windows conda root: `C:\Users\phili\anaconda3`
- `.wslconfig` is sized for a 16 GB / 20-thread host
- `winget` was not available in PATH when this repo was generated, so `windows/packages/winget-packages.txt` is tracked as a baseline package list rather than an exported manifest
