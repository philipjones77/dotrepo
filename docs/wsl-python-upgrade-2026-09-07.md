# WSL Python library upgrade — PhilipSecond, September 7, 2026

## Latest follow-up: Numba restored

The user subsequently requested Numba back. `jax` now has **Numba 0.65.1,
NumPy 2.4.6 and JAX 0.11.1**. The NumPy downgrade is required by this stable
Numba release and satisfies PyTensor's Numba constraint. A compiled Numba
calculation, PyTensor's NUMBA backend, PyMC import and JAX GPU calculation all
passed. The sole remaining dependency-check conflict is GPflow requiring
NumPy below 2. The default `py313` environment remains on NumPy 2.5.3 without
Numba. The sections below describe the preceding upgrade and removal.

The requested default environment is `~/.virtualenvs/py313`, standard CPython
3.13.15. This was the latest 3.13 patch offered by the installed uv manager.
`jax` remains a separate CPython 3.12.3 virtualenv. Neither uses Conda.

The requested common versions are JAX/JAXlib 0.11.1 and NumPy 2.5.3, with Numba
absent. Each environment retains its existing CUDA family: CUDA 13 in `py313`
and CUDA 12 in `jax`. Matching JAX plugins are installed with their CUDA extras.

## Default environment validation

`py313` passed its dependency check, GPU float64 linear solve against SciPy,
automatic differentiation, Optax optimization, ten BlackJAX HMC transitions,
and a NumPyro NUTS run with 20 warmup and 32 retained samples. These are smoke
checks, not convergence or full project regression tests. Flax, Optimistix,
Lineax, Equinox and Diffrax also imported successfully.

The package update includes BlackJAX 1.6.2, SciPy 1.18.1, Flax 0.12.9,
Orbax Checkpoint 0.12.4 and python-flint 0.9.0. NumPyro 0.21.0, Optax 0.2.8
and pip 26.2.1 were already current. Normal interactive Ubuntu Bash resolves
both `python` and `python3` to 3.13.15 and both `pip` and `pip3` to this
environment's pip 26.2.1. Ubuntu's separate system Python/pip remain APT-managed.

The pinned default requirements now reference the current `py313` inventory,
and the restoration helper defaults to Python 3.13.15. It still requires an
explicit destination and does not recreate removed environments automatically.

## Compatibility limits

The existing `jax` environment contains GPflow, which requires NumPy below 2,
and PyTensor, which requires Numba. These conflict with the user's requested
NumPy 2.5.3 / no-Numba setup. Those packages and their dependent projects are
preserved; their workflows are not declared healthy.

TensorFlow 2.21.0, tf-keras 2.21.0, the existing tfp-nightly build, CPU PyTorch
2.11.0+cpu and llvmlite 0.47.0 were held during resolution. The unrestricted
plan would downgrade TensorFlow and replace CPU PyTorch with a CUDA build.
Other library updates were resolved together, retaining compatible versions
where dependencies prevented the newest release.

## Final JAX environment checks

`jax` also passed the GPU float64 solve, gradient, Optax optimization, BlackJAX
HMC, NumPyro NUTS and library-import checks described above. It reports JAX
0.11.1, NumPy 2.5.3, NumPyro 0.21.0, BlackJAX 1.6.2, Optax 0.2.8 and pip
26.2.1. SciPy remains 1.16.3 under this environment's resolved constraints.
Numba 0.65.1 was uninstalled. Cachetools was constrained below 7 to satisfy
the retained PyMC package. The final dependency check reports only the
GPflow/NumPy and PyTensor/Numba conflicts described above. The default
`py313` environment's dependency check is clean.

A fitting process that started under the older default environment was left
running. It is not evidence for the new package set; validate new jobs in a
fresh interpreter. Full data77 inference and all local-project tests were not
rerun as part of this maintenance.
