# WSL Conda retirement: source machine

**Conda removal is complete on this WSL source installation.** At the user's
explicit request, stopped the two data77 experiments using Miniforge and their
timeout wrappers (115063/115061 and 237504/237502). Verified no remaining
process executable or loaded-library mapping used Miniforge, then removed
`/home/phili/miniforge3` and `/home/phili/.conda`. No other Conda installation
was found in the searched native home, opt and usr/local installation locations.
Mounted external data is outside this installation audit.

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

After the user explicitly authorized stopping the experiments, the two Conda
runs were stopped before removal. They were not restarted automatically.
Their source and scientific output files were preserved.

After removal, pip check passed in py313, jax-native and matrix-compare.
The full jax-native GPU validation passed: JIT, differentiation, dense/sparse
operations, FFT, Optax, Flax, Diffrax, PyTorch CUDA, FLINT/Arb, HDF5 and plotting.
The current machine capture now reports `conda: []`; obsolete current Conda
inventory files were removed. Existing shells can retain stale environment
variables and should be reopened.

Historical Conda inventories remain evidence of the old machine state, not a
recommendation to recreate Conda on another machine.
