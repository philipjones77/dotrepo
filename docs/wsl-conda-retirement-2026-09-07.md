# WSL Conda retirement: source machine

The user's required final state is **no Conda installation in WSL**. This is
not yet fully achieved: the old named Conda environments were removed, but
`~/miniforge3` base is still used by running data77 experiments. At the latest
check, Python process IDs 115063 and 237504 used that installation directly.
These IDs are diagnostic history, not instructions to terminate those PIDs later.

The standard environments `py313`, `jax-native` and `matrix-compare` are already
ordinary CPython virtualenvs. The retained legacy `~/.virtualenvs/jax` is also
non-Conda, although it has separately documented dependency conflicts.

## Changes now applied

- Removed dotrepo's automatic Conda shell fallback. New interactive shells
  activate py313 when available; they do not initialize Conda.
- Removed `python/wsl/environment.yml`, so the supported WSL setup no longer
  provides a recipe that recreates Conda.
- Added `wsl/data77-bayesian.sh`, which uses
  `~/.virtualenvs/jax-native/bin/python` explicitly. The source has the local
  `data77-bayesian` command pointing to this launcher.

Use `data77-bayesian` with the same experiment options, or invoke the non-Conda
Python explicitly. Shell activation cannot override a command that names
`~/miniforge3/bin/python` directly; those launch commands must change.

## Validation and remaining work

The Approach B runner's `--help` completed under jax-native, loading its
RandomFields77 imports. A separate n=2000 NumPyro check reached GPU compilation
and the sampling path. That backend did not honor the intended preflight-only
boundary, so only the validation process was terminated. This is not a claim
that a complete inference run or numerical equivalence test finished.

The user's existing experiments were not terminated, and Miniforge was not
deleted underneath them. Completion requires letting these runs finish or
explicit authorization to stop them. Before removal, recheck all process
executables, arguments and loaded-library references to the Miniforge tree,
including newly launched jobs; verify the absolute directory is precisely
`/home/phili/miniforge3`. Then remove the installation, refresh inventories and
verify new shell and experiment commands use standard CPython.

Historical Conda inventories remain evidence of the old machine state, not a
recommendation to recreate Conda on another machine.
