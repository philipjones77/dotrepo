#!/usr/bin/env bash
# Compatibility entry point; locking, configuration and mounting live in WSL.
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
quiet=0
if [ "${1:-}" = --quiet ]; then
  quiet=1
  shift
fi
if [ $# = 0 ]; then
  set -- start
fi
if [ "$quiet" = 1 ]; then
  exec bash "$repo_root/wsl/mounts/gdrive.sh" "$@" >/dev/null 2>&1
fi
exec bash "$repo_root/wsl/mounts/gdrive.sh" "$@"
