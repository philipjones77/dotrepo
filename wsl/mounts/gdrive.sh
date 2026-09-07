#!/usr/bin/env bash
# A single mount helper for WSL shells, Windows dispatch and startup.
set -euo pipefail
action=${1:-start}
state_dir="$HOME/.local/state/dotrepo"
mkdir -p "$state_dir"
if [ -f "$HOME/.config/dotrepo/gdrive.env" ]; then
  # Local shell-format settings, never rclone credentials.
  source "$HOME/.config/dotrepo/gdrive.env"
fi
# Canonical names take precedence over aliases kept for older shell settings.
remote=${DOTREPO_GDRIVE_REMOTE:-${DOTREPO_GDRIVE_RCLONE_REMOTE:-philip.a.jonesmngoogle:}}
mount_dir=${DOTREPO_GDRIVE_PATH:-${DOTREPO_GDRIVE_RCLONE_MOUNT:-$HOME/mnt/gdrive}}
read_only=${DOTREPO_GDRIVE_READ_ONLY:-1}
cache_max_size=${DOTREPO_GDRIVE_CACHE_MAX_SIZE:-2G}
cache_max_age=${DOTREPO_GDRIVE_CACHE_MAX_AGE:-1h}
daemon_wait=${DOTREPO_GDRIVE_DAEMON_WAIT:-90s}
case "$action" in
  status)
    findmnt --mountpoint "$mount_dir" -o TARGET,SOURCE,FSTYPE,OPTIONS
    exit
    ;;
  stop)
    # Wait for a pending start to finish before deciding whether to unmount.
    exec 9>"$state_dir/gdrive.lock"
    flock -w 120 9
    if mountpoint -q "$mount_dir"; then
      fusermount3 -u "$mount_dir"
    fi
    flock -u 9
    exec 9>&-
    exit
    ;;
  start|serve) ;;
  *) echo 'Usage: gdrive.sh {start|status|stop|serve}' >&2; exit 2 ;;
esac
case "$read_only" in
  1) mode_args=(--read-only --vfs-cache-mode minimal) ;;
  0) mode_args=(--vfs-cache-mode writes) ;;
  *) echo 'DOTREPO_GDRIVE_READ_ONLY must be 1 (read-only) or 0 (writable).' >&2; exit 2 ;;
esac
command -v rclone >/dev/null
command -v fusermount3 >/dev/null
exec 9>"$state_dir/gdrive.lock"
flock -w 120 9
if ! mountpoint -q "$mount_dir"; then
  rclone listremotes | grep -Fxq "${remote%%:*}:" || { echo "Configure rclone remote ${remote%%:*} first." >&2; exit 1; }
  mkdir -p "$mount_dir" "$HOME/.cache/rclone"
  if [ -n "$(find "$mount_dir" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
    echo "Refusing to hide existing files at $mount_dir" >&2
    exit 1
  fi
  rclone mount "$remote" "$mount_dir" "${mode_args[@]}" \
    --vfs-cache-max-size "$cache_max_size" --vfs-cache-max-age "$cache_max_age" \
    --vfs-cache-poll-interval 1m \
    --buffer-size 16M --dir-cache-time 5m --cache-dir "$HOME/.cache/rclone" \
    --daemon --daemon-wait "$daemon_wait" --log-file "$state_dir/gdrive.log" --log-level INFO 9>&-
fi
flock -u 9
exec 9>&-
findmnt --mountpoint "$mount_dir" -o TARGET,SOURCE,FSTYPE,OPTIONS
if [ "$action" = serve ]; then
  # An active WSL command keeps the VM available to Windows Explorer.
  # Explicit wsl --shutdown still stops it normally.
  while mountpoint -q "$mount_dir"; do sleep 30; done
fi
