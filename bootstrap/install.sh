#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_root="${HOME}/.dotrepo-backups/$(date +%Y%m%d-%H%M%S)"
if [ -e "$HOME/.dotrepo" ] || [ -L "$HOME/.dotrepo" ]; then
  if [ "$(readlink -f "$HOME/.dotrepo")" != "$repo_root" ]; then
    printf 'Another checkout exists at ~/.dotrepo; run its bootstrap or relocate it explicitly.\n' >&2
    exit 1
  fi
else
  ln -s "$repo_root" "$HOME/.dotrepo"
fi

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

merge_vscode_settings() {
  local source="$1" target="$2" merged
  merged=$(mktemp)
  if ! python3 - "$source" "$target" > "$merged" <<'PY'
import json
from pathlib import Path
import sys

def merge(current, tracked):
    for key, value in tracked.items():
        if isinstance(value, dict) and isinstance(current.get(key), dict):
            merge(current[key], value)
        else:
            current[key] = value
    return current

source, target = map(Path, sys.argv[1:])
current = json.loads(target.read_text(encoding='utf-8-sig')) if target.exists() else {}
tracked = json.loads(source.read_text(encoding='utf-8-sig'))
if not isinstance(current, dict) or not isinstance(tracked, dict):
    raise ValueError('VS Code settings must be JSON objects')
print(json.dumps(merge(current, tracked), indent=2))
PY
  then
    rm -- "$merged"
    return 1
  fi
  backup_user_target "$target"
  install -m 644 "$merged" "$target"
  rm -- "$merged"
  log "Merged tracked settings into ${target}"
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
      return 1
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
merge_vscode_settings "${repo_root}/vscode/wsl/settings.json" "$HOME/.vscode-server/data/Machine/settings.json"

# Use the Windows client without importing Windows tool directories into PATH.
# A copy has reliable executable permissions even from a Windows checkout.
code_target="$HOME/.local/bin/code"
if [ -f "$code_target" ] && [ ! -L "$code_target" ] \
  && cmp -s "${repo_root}/wsl/code.sh" "$code_target"; then
  chmod 755 "$code_target"
  log "Already installed ${code_target}"
else
  backup_user_target "$code_target"
  install -Dm755 "${repo_root}/wsl/code.sh" "$code_target"
  log "Installed ${code_target}"
fi
ide_target="$HOME/.local/bin/antigravity-ide"
if [ -f "$ide_target" ] && [ ! -L "$ide_target" ] \
  && cmp -s "${repo_root}/wsl/antigravity-ide.sh" "$ide_target"; then
  chmod 755 "$ide_target"
  log "Already installed ${ide_target}"
else
  backup_user_target "$ide_target"
  install -Dm755 "${repo_root}/wsl/antigravity-ide.sh" "$ide_target"
  log "Installed ${ide_target}"
fi
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Preserve existing distro-specific boot/network/user settings.
if [ ! -f /etc/wsl.conf ]; then
  temp_config=$(mktemp)
  trap 'rm -f "$temp_config"' EXIT
  printf '[boot]\nsystemd=true\n\n[user]\ndefault=%s\n' "$(id -un)" > "$temp_config"
  install_system_file "$temp_config" /etc/wsl.conf
fi
if [ "${1:-}" = '--install-tools' ]; then
install_vscode_extensions "${repo_root}/vscode/wsl/extensions.txt"

if [ -f "${repo_root}/node/install-globals.sh" ]; then
  bash "${repo_root}/node/install-globals.sh"
fi
fi

log "WSL bootstrap complete"
log "Next steps:"
log "  1. Restart the shell so ~/.bashrc and ~/.profile reload"
log "  2. Run ${repo_root}/python/wsl/create-venv.sh for a tracked venv"
log "  3. Run the Windows bootstrap from PowerShell to apply .wslconfig and VS Code local settings"
