# TopoSmplJAX oracles and the UQpy companion

Verified on **PC-PHILIP-WINDOWS / Ubuntu WSL**, September 14, 2026. This extends
the [repository oracle audit](repo-oracles-2026-09-14.md). TopoSmplJAX was checked
at commit `ab67c2e426f3a95f6b676c8aac72e6ed1bd4ded5`; its tracked source and
existing untracked files were preserved.

## Results

| Check | Result |
| --- | --- |
| Existing geometry and topology comparisons | 30 passed, 2 skipped, 1 expected failure |
| pyFM eigenvalues and Gmsh/native meshing | 5 passed |
| Gephi graph exchange, layout and export | 5 passed |
| GraphRicciCurvature K3 comparison | Passed; fcgraph maximum absolute error `6.22e-15` |
| Geoopt Poincare distance and Stiefel projection | Passed; errors below `4.5e-16` |
| Neutral SMPL and SMPL-X forward evaluations | Passed; maximum vertex error `3.58e-7` |
| Repository oracle coverage check | Passed |
| RF77 UQpy DirectPOD comparisons through its companion setting | 4 passed, zero skips |
| Standalone Debiased Spatial Whittle reference | Finite Matérn likelihood and positive expected periodogram |

The geomstats exclusions are documented in the repository tests: two coefficient
sets need scatter-add operations unavailable in its NumPy backend, and one
expected failure concerns its `d1` term. The Gephi checks include the existing
contract that saving a `.gephi` project reports a failure; PDF, SVG and GEXF
exports passed. These are selected CPU comparisons, not the full project suite.

Receipts contain versions, individual test names and numerical results:
[TopoSmplJAX](../machines/pc-philip-windows-2026-09-14/repo-oracles/toposmpljax.json),
[Gephi/native installation](../machines/pc-philip-windows-2026-09-14/repo-oracles/gephi.json),
and [UQpy/Whittle companion](../machines/pc-philip-windows-2026-09-14/repo-oracles/uqpy312.json).
No Julia runtime requirement, Julia source or Julia project was found in the
audited TopoSmplJAX tree. The broader audit covers the other repositories' Julia
references separately.

## Python packages in py313

All 13 distributions in TopoSmplJAX's `oracles` extra were already installed.
This pass added `pyfmaps==1.3.0` (import `pyFM`), `smplx==0.1.28`, and
`gmsh==4.15.2`. The receipt records all 16 versions. To reconcile another
machine, preserve its before inventory and preview these additions against its
existing pins:

```bash
uv pip install --dry-run --python "$HOME/.virtualenvs/py313/bin/python" \
  pyfmaps==1.3.0 smplx==0.1.28 gmsh==4.15.2
uv pip install --python "$HOME/.virtualenvs/py313/bin/python" \
  pyfmaps==1.3.0 smplx==0.1.28 gmsh==4.15.2
uv pip check --python "$HOME/.virtualenvs/py313/bin/python"
```

This is an addition recipe, not a reconstruction of the shared environment.
Use the complete captured inventory for a fresh environment. TopoSmplJAX itself
must be installed as a package in the interpreter running these checks.

## Native Gephi installation

The APT transaction added 13 packages, with zero upgrades or removals. Direct
requests were `openjdk-21-jdk-headless`, `topcom`, `libginac-dev` and
`ginac-tools`; TOPCOM and GiNaC also support the broader oracle audit. Observed
versions were JDK 21.0.12, TOPCOM `1.1.2+ds-1.1build2` and GiNaC
`1.8.7-1build2`. Compare the target's own signed Ubuntu indexes before applying:

```bash
sudo apt-get --simulate --no-remove install \
  openjdk-21-jdk-headless topcom libginac-dev ginac-tools
sudo apt-get --no-remove install \
  openjdk-21-jdk-headless topcom libginac-dev ginac-tools
```

[Gephi Toolkit](https://gephi.org/toolkit/) supplies the Java reference used by
the repository tests. The installed 0.10.1 JAR came from the official
[Maven artifact](https://repo.maven.apache.org/maven2/org/gephi/gephi-toolkit/0.10.1/gephi-toolkit-0.10.1-all.jar).
Its published SHA-1 matched; the recorded SHA-256 is:

```text
3e4f5fd6c7d1d75c1e0bfbeae42cc58a1d22ae7c5d793a498e6c5842f22bf027
```

The JAR resides at `~/.local/share/gephi/gephi-toolkit-0.10.1-all.jar` and is
symlinked into the repository's ignored `vendor/gephi/` directory. Preserve an
existing target installation and verify its hash before reusing it. No JAR is
committed. From the target TopoSmplJAX checkout, the bounded integration check is:

```bash
JAVA_TOOL_OPTIONS='-Xmx384m -XX:ActiveProcessorCount=2' \
  CUDA_VISIBLE_DEVICES=-1 JAX_PLATFORMS=cpu \
  OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 \
  "$HOME/.virtualenvs/py313/bin/python" -B -m pytest \
  tests/fcgraph/test_gephi_toolkit.py -q
```

Ubuntu names TOPCOM programs with a prefix, such as `topcom-points2triangs`.
The GiNaC shell is `ginsh`; their native installations do not themselves provide
Python repository adapters.

## UQpy and Whittle companion

[UQpy 4.2.1 metadata](https://pypi.org/pypi/UQpy/4.2.1/json) pins NumPy 1.26.4
and PyTorch 2.2. The working installation therefore uses CPython 3.12.3 in
`~/.virtualenvs/uqpy312`. It also includes
[Debiased Spatial Whittle 2.2.0](https://pypi.org/pypi/debiased-spatial-whittle/2.2.0/json).
The main py313 NumPy/JAX/PyTorch versions were preserved.

Use the [companion replication guide](repo-oracles-companions-2026-09-14.md)
to create a new candidate from all 44 exact pins. It supplies a checksum-pinned
official PyTorch CPU wheel URL and keeps other packages on PyPI. Its full
resolution was dry-run successfully. `fire==0.6.0` needs an isolated source
build. UQpy imports `pkg_resources` without declaring setuptools; the observed
runtime failure was resolved by `setuptools==80.9.0`. All 44 installed
distributions passed the dependency check.

From RandomFields77, its existing subprocess integration passed all four tests:

```bash
RF77_UQPY_PYTHON="$HOME/.virtualenvs/uqpy312/bin/python" \
  CUDA_VISIBLE_DEVICES=-1 JAX_PLATFORMS=cpu JAX_ENABLE_X64=1 \
  OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 \
  PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 \
  "$HOME/.virtualenvs/py313/bin/python" -B -m pytest \
  tests/tests_continuous/test_e_tier_oracle_uqpy.py \
  --noconftest -o addopts= -p no:cacheprovider -q
```

The focused invocation excludes unrelated repository runtime-cleanup hooks.
It checks availability, eigenvalue/subspace parity with SciPy, truncated modes
and an actual Matérn-3/2 covariance eigenbasis.

The separate Whittle check evaluated a 4 by 4 Matérn reference with negative
log-likelihood `0.3846677891571325` and a positive expected periodogram. **RF77's
W01 adapter still imports Whittle in-process and has no companion interpreter
setting.** The package is usable in `uqpy312`; W01 remains unavailable directly
inside the NumPy-2 py313 environment until its adapter supports that companion.

## Existing SMPL assets

The installed [official SMPL-X package](https://github.com/vchoutas/smplx)
was compared with `SMPLJAXModel` using existing local neutral SMPL and SMPL-X
assets. These tests used nonzero shape, pose and translation, plus expression
for SMPL-X. They compared 6,890 and 10,475 vertices respectively, as well as
joints; maximum absolute errors were below `3.6e-7`.

The existing standardized NPZ assets use different field names from upstream.
A private compatibility view adds `f` for `faces_tensor`, and upstream hand
component/mean aliases for SMPL-X. SMPL also needs a PKL container. The
conversion preserves the numerical arrays and leaves the original files intact.
The published [SMPL check](../scripts/check-smpl-oracles.py) performs this
conversion and numerical comparison without downloading models:

```bash
# Run from the dotrepo checkout, using a new state directory for each replay.
mkdir -p "$HOME/.local/state/dotrepo"
smpl_check_state="$(mktemp -d "$HOME/.local/state/dotrepo/smpl-check.XXXXXX")"
"$HOME/.virtualenvs/py313/bin/python" -B scripts/check-smpl-oracles.py smpl \
  --models-root "$TOPOSMPLJAX_SMPL_ROOT" --state-dir "$smpl_check_state"
"$HOME/.virtualenvs/py313/bin/python" -B scripts/check-smpl-oracles.py smplx \
  --models-root "$TOPOSMPLJAX_SMPL_ROOT" --state-dir "$smpl_check_state"
```

Set `TOPOSMPLJAX_SMPL_ROOT` to the target's existing standardized model root.
The inspected root was `~/.cache/toposmpljax/private_data/models/validated`.
Omitting `--models-root` uses that environment variable or this default. The
helper refuses to overwrite a compatibility output and keeps outputs private.
On the inspected host, `SMPLX_MODEL_PATH` can select the tested view at
`~/.local/state/dotrepo/repo-oracles-20260914/toposmpljax/private-smplx-compatibility-view`.
These direct checks do not need `SMPLX_REPO_PATH`.

Only neutral SMPL and SMPL-X were numerically checked. Other locally present
genders and model families, and the complete nine-case legacy Layer fixture,
were not exercised. Model files, private hashes and model payloads are excluded
from the committed receipts. The other machine needs its own existing model
assets or its separately authorized model provisioning process.
