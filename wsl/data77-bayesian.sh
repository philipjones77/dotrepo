#!/usr/bin/env bash
# Run Approach B with retained non-Conda py313; imports/help were checked.
set -euo pipefail
python_bin="$HOME/.virtualenvs/py313/bin/python"
runner="${PROJECTS_HOME:-$HOME/projects}/data77/experiments/type_ii_noaa_oisst_british_isles_sst/rf77_reference_approach_b/run_bayesian_m1v.py"
if [[ ! -f "$HOME/.virtualenvs/py313/pyvenv.cfg" || ! -x "$python_bin" || ! -f "$runner" ]]; then
  echo 'Restore py313 and the data77 checkout before launching this experiment.' >&2
  exit 1
fi
export XLA_PYTHON_CLIENT_PREALLOCATE=false
exec "$python_bin" "$runner" "$@"
