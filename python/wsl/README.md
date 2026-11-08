# WSL Python environments

For another machine, follow the [hardware-aware handoff](../../docs/ai/sessions/2026-11-08-wsl-environments-hardware-aware-handoff.md).
Refresh versions and select its backend; the source inventory is not a lockfile.

The November 8, 2026 environment layout is:

| Name | Role | Interpreter |
| --- | --- | --- |
| `py314` | General development and broad oracle/reference package coverage | Python 3.14 |
| `jax314` | Production development for the scientific libraries | Python 3.14 |
| `jax315` | Research and Python 3.15 compatibility work | Python 3.15 |

Fresh WSL shells select `py314`. Use `jaxenv` for production and `jaxenv 315`
for research. Explicitly activated environments remain selected. The three
environments have separately named Jupyter kernels. R and its development
tools remain native WSL installations; `py314` supplies the Python/R bridges.

The new core uses JAX/jaxlib 0.12.0.1, NumPy 2.5.4, SciPy 1.18.1,
CUDA toolkit 13.5.0 and CUDA bindings 13.5.0. CUDA's native Linux compiler is
provided by the toolkit's Python distributions, under
`py314/lib/python3.14/site-packages/nvidia/cu13`. This does not install a Linux
display driver. WSL continues to use the Windows NVIDIA driver.

Old environments are retained. On PC-PHILIP-WINDOWS the previous `jax314` is
named `jax314-before-20261108`; the new `jax314` points to
`jax314-20261108`. `py313`, `jax313`, the oracle companions, and existing `.old`
directories remain available.

The broad environment deliberately tests newer core versions against packages
whose published bounds are older. A successful resolver check and a successful
runtime probe are different evidence. Inspect the actual compatibility results
before assuming an untested workload is supported. Do not rewrite installed
package metadata to hide conflicts. TensorFlow/TFP nightly distributions use
the same import namespaces as their stable distributions and must not be
coinstalled with them.

Python 3.15 currently lacks TensorStore: 0.1.86 fails to compile against its
removed weak-reference API. JAX GPU, Flax layers, Diffrax, HDF5 and local library
imports passed in `jax315`; TensorStore-dependent checkpointing is unavailable.
Production `jax314` passed an Orbax checkpoint save/restore roundtrip.

The broad stack passed focused GPU checks for JAX, PyTorch, CuPy and nvmath,
plus numerical checks for GPflow, Dynamax, BayesNF and the reference packages.
These are smoke checks, not full project test suites. Two runtime-tested
compatibility pins are intentional: setuptools 80.9.0 supplies `pkg_resources`
for UQpy, and cuDSS 0.8.0.10 supports nvmath 1.0.0 (which rejects cuDSS 1.0).
Neither pin downgrades the CUDA toolkit or the NumPy/SciPy/JAX core.
PETSc/SLEPc bindings use the existing native 3.25 libraries. New scikit-sparse
0.5 uses `cho_factor(A).solve(b)`; older CHOLMOD call patterns need migration.
The obsolete `backports.zstd` refuses Python 3.14; use its standard-library
replacement `compression.zstd` there.

Machine-local inventories, installation logs, compatibility checks, and rollback
records live in `~/.local/state/dotrepo/env-refresh-2026-11-08/`.
The older `create-venv.sh` reproduces a historical snapshot; it is not the recipe
for this newer layout. Retain historical pins and existing project lockfiles.

VS Code's `vscode/wsl-python-default` extension applies the requested interpreter
through Microsoft's Python environment API once per opened workspace folder.
It chooses `jax314` for the scientific library workspaces and `py314` for general
work, records the readback, and permits subsequent manual selection. Automatic
pytest discovery remains disabled where it was previously disabled.

On this machine, `~/projects` contains only `data77`, `IntegralFunctionsJAX`,
`TopoSmplJAX`, `RandomFields77`, and `arbPlusJAX`. Supporting source repositories
live under `~/.local/src`, installed applications under `~/.local/opt`, and
reusable data under `~/.local/share`. Resolve the configuration repository
through `~/.dotrepo`; its current target is `~/.local/src/dotrepo`.
R's fallback libraries are retained under `~/.local/lib/R/legacy-home-R`, with
the corresponding paths in `~/.Rprofile`. Old production worktrees and migration
files were removed at the owner's request. Cleanup receipts are under
`~/.local/state/dotrepo/home-cleanup-2026-11-08/`.
