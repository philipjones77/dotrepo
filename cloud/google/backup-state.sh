#!/usr/bin/env bash
set -euo pipefail

stamp="$(date +%Y%m%d-%H%M%S)"
backup_root="${HOME}/.local/share/dotrepo/google-reset/${stamp}"
mkdir -p "$backup_root"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

save_command_output() {
  local output_file="$1"
  shift
  if has_cmd "$1"; then
    "$@" >"${backup_root}/${output_file}" 2>&1 || true
  fi
}

save_command_output gcloud-info.txt gcloud info
save_command_output gcloud-configurations.txt gcloud config configurations list
save_command_output gcloud-auth-list.txt gcloud auth list

if [ -d "${HOME}/.gemini" ]; then
  tar -czf "${backup_root}/gemini-state.tgz" -C "$HOME" .gemini
fi

if [ -d "${HOME}/.config/gcloud" ]; then
  tar -czf "${backup_root}/gcloud-config.tgz" -C "$HOME" .config/gcloud
fi

printf '# Google Tooling Backup\n\n'
printf 'Created: %s\n\n' "$backup_root"
printf 'This backup is local-only. Do not commit it.\n'
