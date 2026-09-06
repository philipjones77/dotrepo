#!/usr/bin/env bash
# A single mount helper for WSL shells, Windows dispatch and startup.
set -euo pipefail
action=${1:-start}
remote=${DOTREPO_GDRIVE_REMOTE:-philip.a.jonesmngoogle:}
mount_dir=${DOTREPO_GDRIVE_PATH:-$HOME/mnt/gdrive}
state_dir="$HOME/.local/state/dotrepo"
mkdir -p "$state_dir"
if [ -f "$HOME/.config/dotrepo/gdrive.env" ]; then
  # Local shell-format settings, never rclone credentials.
  source "$HOME/.config/dotrepo/gdrive.env"
  remote=${DOTREPO_GDRIVE_REMOTE:-$remote}
  mount_dir=${DOTREPO_GDRIVE_PATH:-$mount_dir}
fi
case "$action" in
  status)
    findmnt --mountpoint "$mount_dir" -o TARGET,SOURCE,FSTYPE,OPTIONS
    exit
    ;;
  stop)
    if mountpoint -q "$mount_dir"; then
      fusermount3 -u "$mount_dir"
    fi
    exit
    ;;
  start|serve) ;;
  *) echo 'Usage: gdrive.sh {start|status|stop|serve}' >&2; exit 2 ;;
esac
command -v rclone >/dev/null
command -v fusermount3 >/dev/null
exec 9>"$state_dir/gdrive.lock"
flock -w 40 9
if ! mountpoint -q "$mount_dir"; then
  rclone listremotes | grep -Fxq "${remote%%:*}:" || { echo "Configure rclone remote ${remote%%:*} first." >&2; exit 1; }
  mkdir -p "$mount_dir" "$HOME/.cache/rclone"
  if [ -n "$(find "$mount_dir" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
    echo "Refusing to hide existing files at $mount_dir" >&2
    exit 1
  fi
  rclone mount "$remote" "$mount_dir" --read-only --vfs-cache-mode minimal \
    --buffer-size 16M --dir-cache-time 5m --cache-dir "$HOME/.cache/rclone" \
    --daemon --daemon-wait 30s --log-file "$state_dir/gdrive.log" --log-level INFO 9>&-
fi
flock -u 9
exec 9>&-
findmnt --mountpoint "$mount_dir" -o TARGET,SOURCE,FSTYPE,OPTIONS
if [ "$action" = serve ]; then
  # An active WSL command keeps the VM available to Windows Explorer.
  # Explicit wsl --shutdown still stops it normally.
  while mountpoint -q "$mount_dir"; do sleep 30; done
fi
