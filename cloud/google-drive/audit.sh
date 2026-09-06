#!/usr/bin/env bash
set -euo pipefail

windows_drive="${DOTREPO_GDRIVE_WINDOWS_DRIVE:-G}"
wsl_drvfs="${DOTREPO_GDRIVE_WSL_DRVFS:-/mnt/$(printf '%s' "$windows_drive" | tr '[:upper:]' '[:lower:]')}"
rclone_mount="${DOTREPO_GDRIVE_RCLONE_MOUNT:-$HOME/mnt/gdrive}"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

write_check() {
  printf '| google-drive | %s | %s | %s |\n' "$1" "$2" "${3:-}"
}

printf '# Google Drive WSL Audit\n\n'
printf 'Generated: %s\n\n' "$(date -Is)"
printf '| Area | Check | Status | Detail |\n'
printf '| --- | --- | --- | --- |\n'

if mountpoint -q "$wsl_drvfs"; then
  write_check "WSL DrvFs $wsl_drvfs" "ok" "Windows ${windows_drive}:"
elif [ -d "$wsl_drvfs" ]; then
  write_check "WSL DrvFs $wsl_drvfs" "manual-check" "directory exists but is not a mountpoint"
else
  write_check "WSL DrvFs $wsl_drvfs" "missing" "Windows ${windows_drive}: is not visible in WSL"
fi

if [ -d "$wsl_drvfs/My Drive" ]; then
  write_check "WSL DrvFs My Drive" "ok" "$wsl_drvfs/My Drive"
fi

if has_cmd rclone; then
  write_check "rclone" "ok" "$(rclone version 2>/dev/null | head -n 1 || true)"
  remote_count="$(rclone listremotes 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${remote_count:-0}" -gt 0 ]; then
    write_check "rclone remotes" "ok" "${remote_count} configured"
  else
    write_check "rclone remotes" "missing" "run rclone config"
  fi
else
  write_check "rclone" "missing" "required for native WSL Google Drive mount"
fi

if has_cmd fusermount3 || has_cmd fusermount; then
  write_check "fuse helper" "ok" "$(command -v fusermount3 2>/dev/null || command -v fusermount 2>/dev/null)"
else
  write_check "fuse helper" "missing" "install fuse3 or fuse"
fi

if mountpoint -q "$rclone_mount"; then
  source="$(findmnt -T "$rclone_mount" -o SOURCE -n 2>/dev/null || true)"
  write_check "native rclone mount" "ok" "$rclone_mount <= $source"
elif [ -d "$rclone_mount" ]; then
  write_check "native rclone mount" "missing" "$rclone_mount exists but is not mounted"
else
  write_check "native rclone mount" "missing" "$rclone_mount does not exist"
fi
