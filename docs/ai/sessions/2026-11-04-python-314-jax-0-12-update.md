# Python 3.14.10 and JAX 0.12.0.1 on PhilipSecond

Date: 2026-11-04 (America/Chicago). Host: **PhilipSecond** (WSL Ubuntu). PC-PHILIP-WINDOWS was not
reachable from this session and is **not updated**.

## Decision

The owner moved every environment and repository to JAX and jaxlib 0.12.0.1 on the latest Python 3.14
(3.14.10, confirmed against python.org's release feed and uv 0.13.7's CPython list). `py313` was upgraded and
renamed `py314`, which is now the primary test environment. The WSL environments are `py314`, `jax314` and
`jax315`.

| environment | Python | JAX | packages | role |
|---|---|---|---|---|
| `py314` | 3.14.10 | 0.12.0.1 | 349 | primary; activated by new shells; VS Code's default interpreter |
| `jax314` | 3.14.10 | 0.12.0.1 | 107 | minimal JAX stack; `jaxenv` |
| `jax315` | 3.15.2 | 0.12.0.1 | 103 | forward-test lane; arbPlusJAX, IFJ and TopoSMPLJAX only |

All three are new directories under `~/.local/share/dotrepo/environments/20261104/`, linked from
`~/.virtualenvs/`. The four scientific repositories are editable installs.

## How they were built

Each environment started from its predecessor's exact package list (`py313` for `py314`, the old `jax314` for
both minimal ones) with the JAX family set to 0.12.0.1. A package was moved only when the resolver or the build
forced it, and every move is logged in the machine receipt. The repositories were installed editable with
their declared dependencies under each lock, which added `gmsh` and `beartype` that the old `jax314` lacked.

Forced changes:

- `quadax` 0.3.0 → 0.3.1: 0.3.0 requires `jax<0.12`.
- `h5py` 3.15.1 and `networkit` 11.2.2 in `py314`; `pyarrow` in `jax315`: the pinned versions had no wheel
  for the new Python.
- `backports-zstd` dropped: zstd is in the 3.14 standard library.
- **The TensorFlow stack is not in `py314`.** TensorFlow has no stable release for 3.14. The best resolution is
  2.22.0rc0 with Keras nightly and `tf-keras` 2.15, under which GPflow and TensorFlow Probability fail at
  import. TensorFlow Probability's JAX substrate also fails on JAX 0.12, the same removed-API failure the
  September handoff recorded. `tensorflow`, `tf-keras`, `keras-nightly`, `gpflow`, `tensorflow-probability`
  and the GS-LVMOGP oracle wheel were removed after the check.
- **`asdex` is not in `py314`:** its pinned commit `da130b0` declares `jax<0.12`.
- **`jax315` has no Flax:** Flax requires `tensorstore`, which has no 3.15 wheel and does not build, so
  RandomFields77, which depends on Flax, is not installed there.

## Checks

`uv pip check` is clean in all three. A fresh-interpreter CPU check (`validate.py` in the receipt) gave JIT
error 0, gradient error 1.1e-16, solve residual 5.6e-17, FFT round trip 2.8e-16 and a finite Hessian in each.
Flax and Optax steps pass in `py314` and `jax314`, and every repository imports. GPU was not tested.

## What was switched, and how to roll back

- `~/.virtualenvs/py314`, `jax314`, `jax315` now point at the new directories. The previous `jax314` (3.14.7,
  JAX 0.11.1) is still at `environments/20260914/jax314`.
- `shared/shell/init.sh` activates `py314`; `jaxenv` in `shared/shell/functions.sh` activates `jax314`.
- `vscode/wsl/settings.json` and the live `~/.vscode-server/data/Machine/settings.json` name `py314`.
- **Kept unchanged:** `py313` (the TensorFlow, GPflow and GS-LVMOGP oracles, `RETICULATE_PYTHON`,
  `config/m-tier-oracles.json`, `wsl/data77-bayesian.sh`), `jax313`, `jax-oracles313`, `uqpy312`.

To roll back, point `init.sh` and the VS Code setting back at `py313`, and `~/.virtualenvs/jax314` back at
`environments/20260914/jax314`. Nothing was deleted.

## Pending

- PC-PHILIP-WINDOWS: repeat this there; pulling the record does not install anything.
- The Windows-side environments (`python/windows/*.ps1`) were not changed.
- GPU validation.
- Each repository raises its floors and runs its own tests in `py314` (TopoSMPLJAX's broadcast of 2026-11-04).

Receipt, locks and scripts: [`machines/philipsecond-2026-11-04/wsl-native/`](../../../machines/philipsecond-2026-11-04/wsl-native/).
