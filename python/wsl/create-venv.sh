#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
env_dir="${1:-$HOME/.virtualenvs/jax-native}"
python_bin="${PYTHON_BIN:-3.12.13}"
projects_home="${PROJECTS_HOME:-$HOME/projects}"

command -v uv >/dev/null || { echo 'Install native uv before running this script.' >&2; exit 1; }
if [ -e "$env_dir" ] && [ ! -f "$env_dir/pyvenv.cfg" ]; then
  echo "Refusing to overwrite a non-virtualenv directory: $env_dir" >&2
  exit 1
fi
for project in arbPlusJAX IntegralFunctionsJAX TopoSMPLJAX; do
  if [ ! -f "$projects_home/$project/pyproject.toml" ]; then
    echo "Restore the scientific checkout first: $projects_home/$project" >&2
    exit 1
  fi
done
if [ ! -f "$env_dir/pyvenv.cfg" ]; then
  uv venv --seed --python "$python_bin" "$env_dir"
fi
uv pip install --python "$env_dir/bin/python" -r "${repo_root}/python/wsl/requirements.txt"
uv pip install --python "$env_dir/bin/python" \
  -e "$projects_home/arbPlusJAX" -e "$projects_home/IntegralFunctionsJAX" \
  -e "$projects_home/TopoSMPLJAX"
fftlog_wheel="${FFTLOG_WHEEL:-$repo_root/.local/linux-python-migration/fftlog_lss-0.1.2-py3-none-any.whl}"
if [ -f "$fftlog_wheel" ]; then
  uv pip install --python "$env_dir/bin/python" "$fftlog_wheel"
else
  echo 'FFTLog wheel not found; transfer it separately and set FFTLOG_WHEEL to install it.' >&2
fi
"$env_dir/bin/python" -m pip check

printf '[dotrepo] Installed native JAX environment: %s\n' "$env_dir"
printf 'Validate GPU workloads: %s/bin/python %s/scripts/check-jax-environment.py --require-gpu\n' "$env_dir" "$repo_root"
