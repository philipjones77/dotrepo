#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_root="${HOME}/.dotrepo-backups/$(date +%Y%m%d-%H%M%S)"

log() {
  printf '[dotrepo] %s\n' "$*"
}

backup_user_target() {
  local target="$1"
  local backup_path

  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    return
  fi

  backup_path="${backup_root}/${target#/}"
  mkdir -p "$(dirname "$backup_path")"
  mv "$target" "$backup_path"
  log "Backed up ${target} -> ${backup_path}"
}

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    log "Already linked ${target}"
    return
  fi

  backup_user_target "$target"
  ln -sfn "$source" "$target"
  log "Linked ${target}"
}

install_system_file() {
  local source="$1"
  local target="$2"
  local backup_path

  if ! command -v sudo >/dev/null 2>&1; then
    log "Skipping ${target}; sudo is not available"
    return
  fi

  if sudo test -e "$target"; then
    backup_path="${backup_root}/${target#/}"
    mkdir -p "$(dirname "$backup_path")"
    sudo cp "$target" "$backup_path"
    sudo chown "$(id -u):$(id -g)" "$backup_path"
    log "Backed up ${target} -> ${backup_path}"
  fi

  sudo install -Dm644 "$source" "$target"
  log "Installed ${target}"
}

install_vscode_extensions() {
  local extensions_file="$1"
  local extension

  if ! command -v code >/dev/null 2>&1; then
    log "Skipping WSL VS Code extension install; 'code' is not on PATH"
    return
  fi

  while IFS= read -r extension; do
    if [[ -z "$extension" || "$extension" =~ ^# ]]; then
      continue
    fi

    if ! code --install-extension "$extension" --force >/dev/null 2>&1; then
      log "Extension install failed: ${extension}"
    fi
  done < "$extensions_file"
}

mkdir -p "$HOME/.ssh" "$HOME/.vscode-server/data/Machine"
chmod 700 "$HOME/.ssh"

link_file "${repo_root}/wsl/home/.bashrc" "$HOME/.bashrc"
link_file "${repo_root}/wsl/home/.zshrc" "$HOME/.zshrc"
link_file "${repo_root}/wsl/home/.profile" "$HOME/.profile"
link_file "${repo_root}/git/gitconfig.wsl" "$HOME/.gitconfig"
link_file "${repo_root}/ssh/config" "$HOME/.ssh/config"
link_file "${repo_root}/vscode/wsl/settings.json" "$HOME/.vscode-server/data/Machine/settings.json"

install_system_file "${repo_root}/wsl/etc/wsl.conf" "/etc/wsl.conf"
install_vscode_extensions "${repo_root}/vscode/wsl/extensions.txt"

if [ -x "${repo_root}/node/install-globals.sh" ]; then
  "${repo_root}/node/install-globals.sh"
fi

log "WSL bootstrap complete"
log "Next steps:"
log "  1. Restart the shell so ~/.bashrc and ~/.profile reload"
log "  2. Run ${repo_root}/python/wsl/create-venv.sh for a tracked venv"
log "  3. Run the Windows bootstrap from PowerShell to apply .wslconfig and VS Code local settings"
