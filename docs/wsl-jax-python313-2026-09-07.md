# Migrate WSL jax to Python 3.13.15

## Final name: jax313

After migration, the user requested the permanent name `jax313`. Its path is
`~/.virtualenvs/jax313`, and `~/.virtualenvs/jax` no longer exists. The `jaxenv`
shell helper now activates `jax313`. Activate explicitly with:

```bash
source ~/.virtualenvs/jax313/bin/activate
```

All 197 package versions and editable project links matched before switching.
Python 3.13.15 validation passed for GPU JAX, gradients, BlackJAX HMC, NumPyro
NUTS, CPU PyTorch, HDF5, Numba, PyTensor/PyMC and CPU GPflow regression.
Activation and pip/pip3 were verified after relocating the environment.
The old Python 3.12 environment is retained only as a rollback backup at
`~/.local/state/dotrepo/jax-python313/jax-python312-backup-9e442083`.
It is not a normal active environment. The history below describes migration
before the final rename.

The user requested migrating `~/.virtualenvs/jax` from Python 3.12.3 to standard
CPython 3.13.15. The replacement preserves the current package versions and
editable project links, including TensorFlow and GPflow. It is independent of
Conda. The `py313` and `jax314` environments are separate and were not modified
by this migration.

Before installation, the live `jax` package inventory was saved privately under
`~/.local/state/dotrepo/jax-python313`. A relocatable replacement was built in
that directory so the existing environment could remain intact during setup.
The user explicitly authorized stopping all jobs using `jax`; the identified
pytest process was terminated, and subsequent scans found no remaining jobs.

The intended activation command remains:

```bash
source ~/.virtualenvs/jax/bin/activate
```

The previously documented GPflow `numpy<2` metadata conflict is preserved rather
than forcing a NumPy downgrade. GPflow's CPU runtime behavior is checked
separately from dependency metadata. No claim of full project regression or
GPflow GPU support is made.
