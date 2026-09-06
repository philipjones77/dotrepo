#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
command -v rclone >/dev/null
command -v fusermount3 >/dev/null
mkdir -p "$HOME/.config/dotrepo"
# Opt-in marker read by shared/shell/init.sh.
touch "$HOME/.config/dotrepo/gdrive.enabled"
bash "$repo_root/wsl/mounts/gdrive.sh" start
printf 'Google Drive automount enabled for WSL shell startup.\n'
