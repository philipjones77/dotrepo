#!/usr/bin/env bash
# Run the Approach B experiment with the validated non-Conda environment.
set -euo pipefail
python_bin="$HOME/.virtualenvs/jax-native/bin/python"
runner="${PROJECTS_HOME:-$HOME/projects}/data77/experiments/type_ii_noaa_oisst_british_isles_sst/rf77_reference_approach_b/run_bayesian_m1v.py"
if [[ ! -f "$HOME/.virtualenvs/jax-native/pyvenv.cfg" || ! -x "$python_bin" || ! -f "$runner" ]]; then
  echo 'Restore jax-native and the data77 checkout before launching this experiment.' >&2
  exit 1
fi
export XLA_PYTHON_CLIENT_PREALLOCATE=false
exec "$python_bin" "$runner" "$@"
