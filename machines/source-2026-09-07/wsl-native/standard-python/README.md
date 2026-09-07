# Standard Python inventories

`environments.json` lists currently installed environments on PhilipSecond.
The `jax-native-*` and `matrix-compare-*` files are historical snapshots kept for
reproducibility; the user removed those environments on September 7, 2026.
Do not recreate them automatically. `jax` and `py313` remain installed.

See the [current follow-up](../../../../docs/wsl-mounts-and-environments-2026-09-07.md)
for the earlier removal history. The later
[Python upgrade report](../../../../docs/wsl-python-upgrade-2026-09-07.md)
records JAX 0.11.1 in both retained environments and their validation limits.
After restoring Numba 0.65.1, `jax` uses NumPy 2.4.6; `py313` retains NumPy
2.5.3. This does not establish full other-computer package parity.
