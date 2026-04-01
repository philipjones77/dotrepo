#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
env_dir="${1:-$HOME/.virtualenvs/jax-wsl}"
python_bin="${PYTHON_BIN:-python3}"

"$python_bin" -m venv "$env_dir"
source "$env_dir/bin/activate"
python -m pip install --upgrade pip wheel
python -m pip install -r "${repo_root}/python/wsl/requirements.txt"

printf '[dotrepo] Created %s and installed python/wsl/requirements.txt\n' "$env_dir"
