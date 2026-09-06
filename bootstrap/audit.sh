#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

cmd_status() {
  if has_cmd "$1"; then
    printf 'ok'
  else
    printf '%s' "${2:-missing}"
  fi
}

cmd_version() {
  local cmd="$1"
  shift
  if ! has_cmd "$cmd"; then
    return 0
  fi
  "$cmd" "$@" 2>/dev/null | head -n 1 | tr -d '\r' || printf 'available'
}

path_status() {
  local target="$1"
  if [ -L "$target" ]; then
    printf 'ok symlink'
  elif [ -e "$target" ]; then
    printf 'ok exists'
  else
    printf 'missing'
  fi
}

write_check() {
  local area="$1"
  local name="$2"
  local status="$3"
  local detail="${4:-}"
  printf '| %s | %s | %s | %s |\n' "$area" "$name" "$status" "$detail"
}

printf '# dotrepo WSL/Linux Audit\n\n'
printf 'Generated: %s\n' "$(date -Is)"
printf 'Repo: %s\n\n' "$repo_root"
printf '| Area | Check | Status | Detail |\n'
printf '| --- | --- | --- | --- |\n'

write_check core git "$(cmd_status git)" "$(cmd_version git --version)"
write_check core gh "$(cmd_status gh)" "$(cmd_version gh --version)"
write_check editor code "$(cmd_status code optional-missing)" "$(cmd_version code --version)"
write_check python python3 "$(cmd_status python3)" "$(cmd_version python3 --version)"
write_check python conda "$(cmd_status conda optional-missing)" "$(cmd_version conda --version)"
write_check python mamba "$(cmd_status mamba optional-missing)" "$(cmd_version mamba --version)"
write_check node node "$(cmd_status node optional-missing)" "$(cmd_version node --version)"
write_check node npm "$(cmd_status npm optional-missing)" "$(cmd_version npm --version)"
write_check container docker "$(cmd_status docker optional-missing)" "$(cmd_version docker --version)"
write_check cloud gcloud "$(cmd_status gcloud optional-missing)" "$(cmd_version gcloud --version)"
write_check gpu nvidia-smi "$(cmd_status nvidia-smi optional-missing)" "$(cmd_version nvidia-smi --version)"

write_check dotfiles "$HOME/.gitconfig" "$(path_status "$HOME/.gitconfig")"
write_check dotfiles "$HOME/.ssh/config" "$(path_status "$HOME/.ssh/config")"
write_check dotfiles "$HOME/.bashrc" "$(path_status "$HOME/.bashrc")"
write_check dotfiles "$HOME/.profile" "$(path_status "$HOME/.profile")"
write_check dotfiles "$HOME/.vscode-server/data/Machine/settings.json" "$(path_status "$HOME/.vscode-server/data/Machine/settings.json")"
if [ -e /etc/wsl.conf ]; then
  write_check dotfiles /etc/wsl.conf "ok exists"
else
  write_check dotfiles /etc/wsl.conf "missing"
fi
