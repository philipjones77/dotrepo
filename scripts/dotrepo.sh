#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
action=${1:-doctor}
python_command=python3
if [ -x "$repo_root/.venv-wsl/bin/python" ]; then
  python_command="$repo_root/.venv-wsl/bin/python"
fi
shift || true
case "$action" in
  validate) "$python_command" "$repo_root/scripts/validate.py" "$@" ;;
  doctor) "$python_command" "$repo_root/scripts/doctor.py" --platform wsl "$@" ;;
  install) bash "$repo_root/bootstrap/install.sh" "$@" ;;
  ssh) bash "$repo_root/ssh/setup.sh" "$@" ;;
  drive) bash "$repo_root/wsl/mounts/install.sh" ;;
  projects) "$python_command" "$repo_root/scripts/projects.py" --root "${PROJECTS_HOME:-$HOME/projects}" "$@" ;;
  capture) bash "$repo_root/wsl/capture-status.sh" "${1:-$repo_root/wsl/snapshots/$(date +%Y%m%d-%H%M%S)}" ;;
  *) printf 'Usage: bash scripts/dotrepo.sh {validate|doctor|install|ssh|capture|drive|projects} [arguments]\n' >&2; exit 2 ;;
esac
