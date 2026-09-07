# Standard Python inventories

`environments.json` lists currently installed environments on PhilipSecond.
The `jax-native-*` and `matrix-compare-*` files are historical snapshots kept for
reproducibility; the user removed those environments on September 7, 2026.
Do not recreate them automatically. `jax` and `py313` remain installed.

See the [current follow-up](../../../../docs/wsl-mounts-and-environments-2026-09-07.md)
for the earlier removal history. The later
[Python upgrade report](../../../../docs/wsl-python-upgrade-2026-09-07.md)
records JAX 0.11.1 in both retained environments and their validation limits.
Both use NumPy 2.5.3. `jax` now uses Numba 0.67.0 with updated PyTensor/PyMC;
`py313` remains without Numba. This does not establish full other-computer
package parity.

`jax314` is the added standard Python 3.14.7 environment. Its 193 package
versions match `jax`, excluding TensorFlow, TF-Keras and GPflow because the
recorded TensorFlow build has no CPython 3.14 wheel. See the
[jax314 report](../../../../docs/wsl-jax314-2026-09-07.md) for passing validation
and final dependency-constrained maintenance decisions.
