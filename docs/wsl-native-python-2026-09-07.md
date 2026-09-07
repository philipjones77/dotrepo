# PhilipSecond: native WSL Python and scientific tools

This is the source computer, Ubuntu 24.04 on WSL2. The other computer was not
changed. Its recovery update through `fdea38d` was pulled before this report.

## Active replacement environments

| Environment | Python | Packages | Intended use |
| --- | --- | --- | --- |
| `~/.virtualenvs/py313` | CPython 3.13.15 | 139 | Default interactive shell; replaces Miniforge base |
| `~/.virtualenvs/jax-native` | CPython 3.12.13 | 293 | Scientific JAX/CUDA environment; VS Code and Jupyter |

Both are ordinary virtualenvs backed by uv-managed CPython, without Conda.
JAX, jaxlib and the CUDA 13 plugin are aligned to 0.10.2 in both environments.
Native `uv` 0.12.10 is installed in `~/.local/bin`.
Open a new WSL terminal for the default Python, then run `jaxenv` to activate
the scientific environment. In VS Code notebooks select
**Python (JAX GPU, non-Conda)**. Existing workspaces can retain an explicit
interpreter selection; select `~/.virtualenvs/jax-native/bin/python` there.

The shared shell prefers `py313` when installed and preserves the old Conda
startup fallback on machines that have not migrated yet. The shared VS Code
default now points to `jax-native`; install that environment on another machine
before applying the new editor default.

## Verification

The replacement passed `pip check` and
`scripts/check-jax-environment.py --require-gpu` on the NVIDIA RTX 5070 Laptop
GPU (driver 616.56). This exercises GPU JIT, gradients, Hessians, batching,
dense solves, FFTs, sparse matrices, Optax updates, Flax execution, Diffrax ODE
integration, PyTorch CUDA/autograd, FLINT/Arb, HDF5 and plotting.
A real Jupyter kernel also executed a JAX GPU calculation successfully.

Local editable projects were installed from the existing checkouts:
arbPlusJAX 2.2.0, IntegralFunctionsJAX 0.2.0 and TopoSMPLJAX 2.0.0.
IntegralFunctionsJAX sampled-integration tests: **14 passed**.
TopoSMPLJAX smoke tests: **6 passed**. Its private Drive data probe timed out;
these smoke checks do not establish availability of private SMPL assets.

arbPlusJAX GPU tests: **12 passed, 1 failed**, identically in the old Conda and
new virtualenv. `test_grad_eval_point_gpu` attempts reverse differentiation
through the incomplete-gamma implementation's dynamic `lax.while_loop`.
This is an existing project-level failure, not a clean all-tests-passing result.
No scientific project code was changed or failing test suppressed.

Python 3.13 separately passed GPU/JIT, gradients, local-project imports, dlib,
SuiteSparse Cholesky and FLINT checks. dlib 20.0.1 needed a `cmake<4` build
constraint; scikit-sparse 0.5.0 was built against Ubuntu SuiteSparse.

## Applications and R

- Native Claude Code 2.1.263, Codex CLI 0.153.4 and Gemini CLI 0.58.0 launch.
  Claude and Codex recognize existing account logins. Claude's Google Drive MCP
  connection passed its health check. Codex has no additional MCP servers;
  Gemini has no extensions and its account authentication remains unverified.
  No paid model prompts were submitted and no arbitrary external tools enabled.
- Native Google Cloud CLI 583.0.0, including `gcloud`, `bq` and `gsutil`, is
  installed from Google's signed Ubuntu repository. Cloud account access was
  not established by the version check.
- R 4.6.1 is the current configured CRAN APT candidate. The normal R wrapper
  uses `~/.local/lib/R/site-library`; 53 package builds completed in the main
  update, after the initial 11-package update. All **280 visible packages**
  loaded without failure. `cluster` 2.1.8.3 and `spatial` 7.3-19 are active
  user-library versions; older APT-managed copies remain shadowed in the system
  library and still appear in an unfiltered `old.packages()` listing.
- Wolfram 14.3 Linux kernel returned its version and evaluated `2+2` to `4`.
  The [15.0.1 update](wolfram-wsl-2026-09-07.md) is now installed with local
  documentation but requires activation; 14.3 remains the working default.
  This verifies the existing licensed kernel, not a new GUI installation.
- Native FLINT 3.0.1 development headers include Arb. A compiled C program
  linked FLINT/MPFR/GMP and computed a 128-bit pi enclosure successfully.
  `python-flint` 0.8.0 is also installed in both new virtualenvs.
- WSL TeX Live 2023 has the previously tested PDFLaTeX, XeLaTeX, LuaLaTeX,
  latexmk and biber stack. LaTeX Workshop remains installed in WSL VS Code.

## Cleanup boundaries and remaining work

The unused duplicate `~/.virtualenvs/jax-wsl` and the old Conda
`~/miniforge3/envs/jax` were removed after inventory, validation and process
checks. Ubuntu's system Python is retained for operating-system tools.

**Miniforge is not yet removed.** An active `data77` experiment used its base
interpreter, then another experiment started from the same installation.
Do not remove that tree while these workloads or their launchers still use it.
Move job launch commands to the tested standard environment and verify the
actual workload before final removal. Existing shell sessions can also retain
old activation state; open new terminals after applying dotrepo.

The older non-Conda `~/.virtualenvs/jax` is retained because it has additional
PyMC, TensorFlow, GPflow and randomfields77 packages. It is **not the validated
default**: its existing `pip check` reports JAX 0.9.2 versus lineax >=0.10, and
NumPy 2.4.6 versus GPflow's NumPy <2 requirement. Migrate these workloads into
compatible separate virtualenvs before deleting it; do not merge incompatible
requirements into the working JAX environment.

FFTLog's missing temporary source was recovered from installed files into a
local wheel (`fftlog_lss-0.1.2-py3-none-any.whl`) and installed in `jax-native`.
It remains in `~/projects/dotrepo/.local/linux-python-migration/`, along with
private logs, prior inventories and configuration backups. Transfer that wheel
separately when cloning; the remote does not contain it or account credentials.

Current shareable inventory is under
[`machines/source-2026-09-07/wsl-native`](../machines/source-2026-09-07/wsl-native/).
The earlier `wsl/` snapshot is historical. The new snapshot deliberately still
records the retained Conda base installation and the legacy virtualenv.

## Reconstructing the standard environments

Install native uv and Ubuntu build dependencies first (`build-essential`,
`libsuitesparse-dev`, `libopenblas-dev`, `pkg-config`, plus the native packages
listed in the snapshot). Restore the three scientific repositories under
`~/projects` at the revisions in the manual-source inventories before installing
their editable packages. Preserve existing environments until their workloads
pass; these commands describe creating the new named environments.

```bash
uv python install 3.13.15 3.12.13
uv venv --seed --python 3.13.15 ~/.virtualenvs/py313
uv venv --seed --python 3.12.13 ~/.virtualenvs/jax-native
pins="$HOME/projects/dotrepo/machines/source-2026-09-07/wsl-native/standard-python"
uv pip install --python ~/.virtualenvs/jax-native/bin/python -r "$pins/jax-native-requirements.txt"
uv pip install --python ~/.virtualenvs/py313/bin/python -r "$pins/py313-requirements.txt" --build-constraints "$pins/build-constraints.txt"
for name in py313 jax-native; do
  uv pip install --python "$HOME/.virtualenvs/$name/bin/python" \
    -e "$HOME/projects/arbPlusJAX" -e "$HOME/projects/IntegralFunctionsJAX" \
    -e "$HOME/projects/TopoSMPLJAX"
done
# Also install the separately transferred FFTLog wheel into jax-native.
~/.virtualenvs/jax-native/bin/python -m ipykernel install --user \
  --name jax-native --display-name 'Python (JAX GPU, non-Conda)'
~/.virtualenvs/jax-native/bin/python scripts/check-jax-environment.py --require-gpu
```

Install the environments sequentially: simultaneous large CUDA downloads can
time out waiting for uv's shared cache lock. The captured package JSON files
record the final editable versions; requirements files cover ordinary packages.
`bash python/wsl/create-venv.sh` is the maintained convenience installer for
`jax-native`; it now uses this tested package set and the local scientific
checkouts, rather than recreating the older `jax-wsl` environment.

The follow-up [Linux MATLAB installation](matlab-wsl-2026-09-07.md) records
MATLAB R2026a, its toolbox installation and successful activation and batch tests.

## Installation references

- [Codex CLI](https://learn.chatgpt.com/docs/codex/cli)
- [Claude Code installation](https://code.claude.com/docs/en/installation)
- [Gemini CLI installation](https://geminicli.com/docs/get-started/installation/)
- [Google Cloud CLI](https://docs.cloud.google.com/sdk/docs/install-sdk)
- [FLINT build documentation](https://flintlib.org/doc/building.html)
