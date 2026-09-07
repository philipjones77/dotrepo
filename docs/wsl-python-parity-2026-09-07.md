# PC-PHILIP-WINDO WSL Python parity — migration completed

The user requested standard CPython environments matching PhilipSecond, with
Conda removed only after the replacements work. All three replacement builds,
inventory validations and focused project smoke tests have completed successfully,
subject to the inherited dependency conflicts below. All three environments were
promoted, the reviewed Bash/editor settings were updated, and the old Miniforge
installation was removed on September 7, 2026, after fresh process checks and
verified reconstruction backups. New Bash sessions default to `py313`; `jaxenv`
selects `jax313`. Existing editor selections may still need the refresh described
below.
This work makes no changes to Windows Python environments.

The pinned source is commit **`68868db`**, using the
[WSL standard-Python inventories](../machines/source-2026-09-07/wsl-native/standard-python/README.md).
The package JSON files are authoritative; older generated requirements files
can contain stale versions. Counts include recorded editable distributions.

| Replacement | CPython | Matched package count | Final prefix |
| --- | --- | --- | --- |
| `py313` | 3.13.15 | 154 | `/home/phili/.virtualenvs/py313` |
| `jax313` | 3.13.15 | 199 | `/home/phili/.virtualenvs/jax313` |
| `jax314` | 3.14.7 | 193 | `/home/phili/.virtualenvs/jax314` |

The latest `jax313` JSON adds `nodeenv==1.10.0` and `pyright==1.1.411`;
its requirements file still omits both. The `py313` requirements file omits
15 CUDA 12 distributions and gives JAX/jaxlib versions different from its JSON.
The builds therefore used the JSON package sets, not those stale requirements.

The replacements were built beneath
`/home/phili/.local/state/dotrepo/wsl-python-parity-20260907/environments/`.
They now reside at `/home/phili/.virtualenvs/<name>`. These are native CPython
virtual environments, not Conda environments; `py313` is the general/base choice.
Native uv 0.12.10 manages the CPython installations; its release checksum was
verified before installation. Ubuntu's existing compilers were retained, and
`libsuitesparse-dev`/`libopenblas-dev` plus their six APT dependencies were
installed for native scientific builds. No APT packages were upgraded or removed.
The recorded `cmake<4` build constraint was retained for dlib. The completed
`py313` build was exercised through dlib 20.0.1 and scikit-sparse 0.5.0; the
CHOLMOD check uses the 0.5 API, `cho_factor(A).solve(b)`. These checks do not
require replacing the recorded package versions.

The missing canonical checkouts were restored at `~/projects/arbPlusJAX`
(2.2.0, commit `5344375ccff0349052793aa4db9e359169db5536`) and
`~/projects/TopoSMPLJAX` (2.0.0, commit
`3d3305304f155762fd3053048f2ee9caa161f72b`). Existing differently cased working
directories and user edits were retained. IntegralFunctionsJAX 0.2.0 uses the
existing checkout; `jax313` and `jax314` also record the existing RandomFields77
0.0.0 editable metadata.
The earlier [Conda cleanup report](wsl-environment-cleanup-2026-09-07.md)
describes a preceding state; it does not establish completion of this migration.

## Verification and compatibility limits

The [environment checker](../python/wsl/check-recorded-environment.py) compares
normalized package names, exact versions and editable locations, using isolated
Python so `PYTHONPATH` cannot supply missing distributions. It records dependency
checks separately from GPU JAX and applicable scientific runtime probes. GPflow
runs in a separate CPU process. Stable TensorFlow Probability and `tfp-nightly`
share import files, so the recorded nightly is installed last and its imported
payload version is checked separately from distribution metadata.

All final staging checker runs exited zero. Their results distinguish clean
dependency checks from reviewed exceptions:

| Environment | Checker status | Applicable runtime checks |
| --- | --- | --- |
| `py313` | `accepted_with_reviewed_dependency_conflicts`; `accepted: true`, `passed: false` | GPU JAX float64 solve/gradients, Optax, BlackJAX HMC and NumPyro NUTS |
| `jax313` | `accepted_with_reviewed_dependency_conflicts`; `accepted: true`, `passed: false` | The same GPU checks; CPU PyTorch, HDF5 roundtrip, Numba LAPACK, PyTensor NUMBA, compiled PyMC log probability, CPU GPflow and TFP payload validation |
| `jax314` | `passed`; `accepted: true`, `passed: true` | The same applicable checks as `jax313`, with GPflow absent from its recorded package set |

Every environment matched its exact package versions and editable locations.
The checker reports matching source-tree `.egg-info` exposed by a single PEP 610
editable as auxiliary metadata; unrelated or conflicting duplicate installations
still fail. Native CPython, isolated site packages, SSL verification and SQLite
checks also passed.

Two inherited source inconsistencies remain:

- `py313` records Flax 0.12.9, which requires JAX at least 0.11.1, alongside
  JAX/jaxlib and CUDA 12 plugins at 0.10.2. Its CUDA 13 plugins are 0.11.1.
  GPU Flax Dense evaluation and gradients passed in the additional project smoke
  test. The mixed plugin setup still emits an incompatible-plugin warning and
  `PJRT_Api already exists for device type cuda` initialization diagnostics.
  Computation succeeded, but that does not establish compatibility of both
  plugin stacks or a warning-free configuration.
- `jax313` records GPflow 2.11.0 with NumPy 2.5.3, despite GPflow declaring
  `numpy<2`. The separate CPU GPflow regression loss and prediction checks passed;
  no optimizer training run or GPU GPflow support was established. The dependency
  check remains unclean.

Only an exact, reviewed dependency diagnostic may be accepted as inherited from
the source. The checker retains `passed: false` for an accepted dependency
conflict and reports that status explicitly. Other dependency or runtime failures
remain failures; there is no blanket allowance or GPU-to-CPU fallback.

The preserved RandomFields77 working tree contains user changes and declares
`Requires-Python >=3.10,<3.13`. Its editable-install step uses
`--ignore-requires-python` only for that project, without dependencies or build
isolation, limiting the exception to that package without resolving new
dependencies. Runtime compatibility was checked through all four RF77 source
namespaces and a small public output policy assertion under both Python 3.13.15
and 3.14.7. The editable target is metadata-only, so the smoke test explicitly adds
the four existing `src/src_*` directories to its process-local import path. No
project patch removes the Python upper bound. Package inventories and editable
paths do not establish matching project commits or source contents.

The complete private project smoke runs exited zero: `py313` in 47.2 seconds,
`jax313` in 35.9 seconds and `jax314` in 26.4 seconds. All checked GPU Flax
evaluation/gradients and imports from the intended arbPlusJAX, IntegralFunctionsJAX
and TopoSMPLJAX checkouts. Additional results were:

- `py313`: python-flint 0.9.0 gamma/integer determinant and IFJ oracle availability,
  dlib blank-image detection, and a CHOLMOD solve matching NumPy. dlib reports a
  CPU build; its smoke test is not evidence of dlib CUDA support.
- `jax313`: FLINT/IFJ oracle checks, RF77 imports/output policy, and native R 4.6.1
  computation through rpy2-rinterface 3.6.6.
- `jax314`: RF77 imports/output policy and the same native R check. Python-flint
  is absent from its source snapshot and was not added for the smoke test.

No smoke process mapped Conda libraries. The `jax313` and `jax314` smoke stderr
files were empty; `py313` retained the plugin diagnostics described above.
Compared with current `jax313`, `jax314` omits GPflow, TensorFlow, TF-Keras,
python-flint, nodeenv and pyright. All shared recorded package versions match.
The retained PyTorch 2.11.0+cpu build was tested on CPU, not CUDA.

These checks do not establish full project regression coverage, sampler
convergence, large-workload GPU capacity, identical native library builds across
Python versions, or authentication to external services.

## Preserved Python 3.12 user tools

`~/.local` must be retained, including its packages, tools and recovery records.
The separately authorized user-site setuptools update changed 60.2.0 to 81.0.0
with a backup. The subsequent legacy-tool repair added only:

`beautifulsoup4==4.14.3`, `soupsieve==2.8.4`, `click==8.5.0`, `rich==13.9.4`,
`fsspec==2026.4.0`, `numpy==2.3.5`, and `scipy==1.18.0`.

These additions target `~/.local/lib/python3.12/site-packages`, separately from
the three replacement environments. All 4,371 pre-existing user-site
file/directory records remained unchanged during this dependency repair; the
164 protected package hashes also matched. Existing distribution versions were
preserved, including Pillow 12.2.0, gdown 6.1.0 and setuptools 81.0.0.

Ten regular launchers were backed up and changed only on their first line to
`#!/usr/bin/python3.12`, preserving their bodies and permissions: `tqdm`, `gdown`,
`git-filter-repo`, `huggingface-cli`, `typer`, `httpx`, `hf`, `jp.py`, `openxlab`,
and `tiny-agents`. Core imports, a Pillow image operation, a NumPy/SciPy solve,
and nine direct CLI help checks passed without a Conda interpreter.

`huggingface-cli` deliberately exits with an upstream retirement message; use
the working `hf` command. Chumpy 0.70 remains preserved but incompatible: both
old Conda interpreters already failed on its use of `inspect.getargspec`.
Adding NumPy/SciPy does not repair that code. Openxlab's help works, but its old
requests/Rich/setuptools pins remain inconsistent with other retained tools.
No optional MCP stack was added, and help checks do not prove cloud account or
full application functionality.

The broken Conda-based Gemini launcher was separately restored to native
Gemini CLI 0.58.0, using Node 24.20.0 and npm 11.19.0. Its version check passes;
the original wrapper is backed up, and account/authentication settings were
preserved. `~/.local/bin/gemini` now invokes
`~/.local/nodejs/current/bin/node` explicitly, with the entrypoint at
`~/.local/share/npm/lib/node_modules/@google/gemini-cli/bundle/gemini.js`.
Installation used only that new npm prefix. The staged launcher and final
launcher both passed `--version`; no account sign-in or model request was made.
This creates no additional Python environment.

## Completed switch and retirement

Promotion completed at 23:38:30 UTC. Each final Python prefix, Bash activation,
`pip`/`pip3` launcher and recorded editable location was checked; no launcher
retained its former staging path. Settings cutover completed at 23:39:27 UTC:
16 files were checked and 15 changed, with the already-correct IFJ setting left
alone. Backups are at
`~/.dotrepo-backups/wsl-python-cutover-20260907T233926Z-4ff7df206609/`.

The updates cover local Bash configuration, remote VS Code's machine default,
reviewed Linux project settings/workspaces and the inactive data77 production
resume launcher's interpreter. Windows workspaces and Python installations were
not changed. The production service remains disabled and inactive. Project code,
existing user changes, file viewers, and both differently cased checkouts remain
preserved; project-local interpreter settings are intentionally local changes.

The shared initializer now loads machine PATH adjustments before activating
`py313`. This prevents venv deactivation from restoring retired Conda paths or
discarding the portable Node installation. Fresh actual Bash startup passed with
both clean variables and stale inherited Conda/`VIRTUAL_ENV` values, including
`py313` → `jaxenv`/`jax313` → `deactivate`. The tracked fixes are commits
`006d4bc` and `bd90749`. Drive processes stayed unchanged during these tests;
automatic mount startup was disabled only in the test processes.

VS Code settings are updated, but its currently open windows can retain a cached
interpreter selection. Use **Python: Select Interpreter** to choose
`~/.virtualenvs/jax313/bin/python` for JAX projects, or
`~/.virtualenvs/py313/bin/python` for general work. Reload the window when its
current work permits. No live workspace database was rewritten or editor forced
to restart, and no Jupyter kernel packages were added beyond the source records.

Retirement finished at 23:48:35 UTC. It removed only
`/home/phili/miniforge3`, `/home/phili/.conda`, and `/home/phili/.condarc`, after
checking live processes and preserving base, jax and oracle-petsc manifests,
configuration and package records. All three targets are absent and the receipt
contains no errors. `~/.local` and project trees remain. The retired tree contained
about 23.6 GiB of unique allocated file blocks; hard links mean this is not a
guaranteed reclaimed-space figure. Offline WSL/VHD compaction was not performed.

After removal, all three final environments again matched their exact inventories
and editable paths and completed float64 GPU solve/gradient checks on `cuda:0`,
without mapping Conda libraries. The first py313 check exceeded its 90-second
limit; its focused retry passed in 55.6 seconds. The other two did not need a
retry. A final actual Bash run also passed default activation, `jaxenv`,
deactivation, portable Node/Gemini version checks and `gdown --help`.

## Reproduction and completion gate

1. Pin the source commit; save inventories, project metadata and settings before
   changes. Preserve dirty projects and all unrelated `~/.local` contents.
2. Create native Linux CPython venvs in staging. Derive exact pins from each JSON,
   install without dependency-driven upgrades, restore recorded CPU PyTorch and
   editables, and install the recorded TFP nightly last where applicable.
3. Compare exact inventories and interpreter versions; run dependency, GPU,
   scientific and project checks. Record every exception and failure explicitly.
4. Promote only accepted replacements to their final paths, repair relocation
   references where necessary, and recheck the final interpreters and editables.
5. Back up and update Bash/VS Code defaults to the reviewed final paths; verify
   fresh shell and editor behavior, including existing interpreter selections.
6. Check processes, open files and mapped libraries before removing any approved
   old prefix. Preserve reconstruction records first, including `oracle-petsc`.
   Remove only the verified obsolete targets; do not delete `~/.local` wholesale.

### Repeat the environment validation

The following Bash commands use the private, pinned JSON copies captured during
step 1. They write new evidence rather than overwriting the accepted receipts.
The commands target the completed installation at `"$HOME/.virtualenvs"`.
Use the tracked checker from the restored dotrepo checkout; the historical source
commit predates this target's checker changes.

```bash
(
  set -e
  repo="$HOME/.dotrepo"
  work="$HOME/.local/state/dotrepo/wsl-python-parity-20260907"
  prefix_root="$HOME/.virtualenvs"
  validation_dir="$(mktemp -d "$work/recheck-XXXXXXXX")"

  for variable in ${!CONDA@} ${!_CONDA@} ${!VIRTUAL_ENV@}; do
    unset "$variable"
  done
  unset _CE_CONDA _CE_M PYTHONPATH PYTHONHOME PYTHONUSERBASE PYTHONSTARTUP
  unset LD_LIBRARY_PATH JAX_PLATFORMS
  export PATH="$HOME/.local/nodejs/current/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/wsl/lib"
  export XLA_PYTHON_CLIENT_PREALLOCATE=false
  export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1
  export R_HOME=/usr/lib/R
  printf 'Validation evidence: %s\n' "$validation_dir"

  "$prefix_root/py313/bin/python" -I -B \
    "$repo/python/wsl/check-recorded-environment.py" \
    --inventory "$work/source/py313-packages.json" \
    --python-version 3.13.15 --jax-platform gpu --timeout 360 \
    --output "$validation_dir/py313-validation.json" \
    --allow-pip-conflict 'flax 0.12.9 has requirement jax>=0.11.1, but you have jax 0.10.2.' \
    >"$validation_dir/py313-validation.log" 2>&1

  "$prefix_root/jax313/bin/python" -I -B \
    "$repo/python/wsl/check-recorded-environment.py" \
    --inventory "$work/source/jax313-packages.json" \
    --python-version 3.13.15 --jax-platform gpu --timeout 360 --include-gpflow \
    --output "$validation_dir/jax313-validation.json" \
    --allow-pip-conflict 'gpflow 2.11.0 has requirement numpy<2, but you have numpy 2.5.3.' \
    >"$validation_dir/jax313-validation.log" 2>&1

  "$prefix_root/jax314/bin/python" -I -B \
    "$repo/python/wsl/check-recorded-environment.py" \
    --inventory "$work/source/jax314-packages.json" \
    --python-version 3.14.7 --jax-platform gpu --timeout 360 \
    --output "$validation_dir/jax314-validation.json" \
    >"$validation_dir/jax314-validation.log" 2>&1
)
```

These exact conflict allowances apply only to this source snapshot. A changed
diagnostic, a new conflict or a failed runtime check requires investigation, not
another automatic exception. Each runtime subprocess has a 360-second limit;
the complete sequential run can take longer. Run one environment's GPU checks
at a time to avoid contention.

Private Linux evidence lives at
`/home/phili/.local/state/dotrepo/wsl-python-parity-20260907/` (`WORK`):

- `source/` and `source-commit.txt`: pinned input records;
  `package-install-status.json`, `finish-status.json` and per-environment logs:
  installation history, not completion by themselves.
- `py313-validation.json`, `jax313-validation.json`, `jax314-validation.json`:
  accepted staging results with exact counts, editable checks, dependency policy
  and applicable runtime evidence. The final staging checks completed by
  September 7, 2026, 23:35:45 UTC.
- `<name>-project-smoke.json` and `<name>-project-smoke.stderr`: successful
  complete project checks. `project-smoke-rerun-status.json` and
  `jax314-project-smoke-result.json` record timings and helper hashes. Initial
  failed py313 evidence was retained separately before correcting the private
  CHOLMOD test's outdated callable-factor assumption.
- `before/`: prior environment and project records;
  `before/user-setuptools-60.2.0/`: setuptools backup;
  `before/protected-user-package-hashes.json`: protected package hashes.
- `before/legacy-user-tools/`: original launchers and user-site inventory/hash
  records; `legacy-user-tools-repair-result.json` and
  `legacy-user-tools-*.log`: completed scoped repair and its remaining limits.
- `gemini-native-20260907T230021Z/result.json` and adjacent logs: native Gemini
  package/Node/npm/entrypoint hashes and successful launcher checks;
  `before/gemini-wrapper-20260907T230021Z/gemini`: original wrapper.
- `before/oracle-petsc/`: 105 exact Conda package specifications, 7 Python
  distributions, full YAML, configuration and original package records.
- `pre-promotion-retirement-gates-20260907T233651Z.json`: root's read-only scan
  found no Conda executable, mapped-file, working-directory, open-file or direct
  argument references among 44 processes, with no inspection errors. At that
  check all environments remained staged, so promotion/cutover gates correctly
  prevented retirement. The removal receipt records the later fresh scans.
- `promotion-result.json`, `cutover-result.json` and
  `fresh-bash-final-native-tests.json`: completed promotion, applied settings,
  and successful actual Bash startup/switching after the initializer fix.
- `post-cutover-local-cli-probes.json`: nine current CLI help checks and Gemini
  version passed; `huggingface-cli` retained its expected retirement message.
- `post-retirement-environment-tests.json`, `post-retirement-py313-retry.json`
  and `post-retirement-fresh-bash-tests.json`: final inventory/GPU/library checks
  and working Bash/tools after the old installation was absent. The first file
  retains the initial py313 timeout; the retry supplies its passing result.
- `retirement-apply-05259c828f8142db9bdd4aa5757a4a53/result.json` and adjacent
  reconstruction backups: completed deletion, precise targets and fresh process
  audits. Earlier dry-run and failed-test receipts remain as history, including
  the first py313 validation exit recorded by the installation controller; use
  the corrected individual validation receipts and final switch receipts.

Windows-side orchestration files are private under
`C:\dev\dotrepo\.local\wsl-python-parity-20260907\`. Those scripts include
machine-specific target hashes and deletion guards and are not generic setup
commands for another machine. Reproduce the inventory/build/validation sequence
above with that machine's reviewed paths and fresh backups.
