# Native WSL software additions on PC-PHILIP-WINDO

Reviewed on 2026-09-08 against the **PhilipSecond** native WSL inventory captured
on September 7 and published at commit `68868db`. The target is Ubuntu 24.04 on
**PC-PHILIP-WINDO**, using the existing `phili` account and Bash configuration.
This pass restores gaps against the source inventory and adds selected
development and LaTeX utilities. MATLAB is excluded.

**Status:** Completed and verified, including ordinary R startup. The
[summary record](../machines/pc-philip-windo-2026-09-08/wsl-native/software-parity.json)
collects the changes, checks and scope.

Source evidence is in [the PhilipSecond inventory](../machines/source-2026-09-07/wsl-native/).
Shareable target results are collected in
[the PC-PHILIP-WINDO inventory](../machines/pc-philip-windo-2026-09-08/wsl-native/).
The [added-package list](../machines/pc-philip-windo-2026-09-08/wsl-native/apt-added.tsv)
records the actual installed versions, including dependencies.

## Native packages and replication

Fourteen explicit selections added **30 packages**, taking the installed package
count from **1,493 to 1,523**. No existing packages changed version or were
removed. The APT plan reported approximately 155 MB of downloads and 239 MB of
additional installed space.

On another Ubuntu 24.04 machine, inspect its existing packages and preview the
transaction before applying the same selections. Run these from its native
Ubuntu shell; use its existing APT repositories and release.

```bash
sudo apt-get update
sudo apt-get --simulate --no-install-recommends --no-remove install \
  libeigen3-dev liblapacke-dev desktop-file-utils net-tools ninja-build \
  gdb jq ripgrep htop tree wslu texlive-science texlive-extra-utils chktex

# Apply after reviewing the proposed additions and dependencies.
sudo apt-get --no-install-recommends --no-remove --assume-yes install \
  libeigen3-dev liblapacke-dev desktop-file-utils net-tools ninja-build \
  gdb jq ripgrep htop tree wslu texlive-science texlive-extra-utils chktex

sudo dpkg --audit
sudo apt-get check
```

Both package-health checks passed here; `dpkg --audit` produced no findings.
Six offered APT upgrades remain pending, four of them phased.
After installation, `apt-get clean` reduced the downloaded-package cache from
155 MiB to approximately 40 KiB. Installed software and rollback evidence were
retained.

## Native matrix and LaTeX checks

The existing compiler and Armadillo installation, together with the added Eigen
and LAPACKE development packages, compiled and ran
[`scripts/check-native-matrices.cpp`](../scripts/check-native-matrices.cpp).
Its Eigen, Armadillo and LAPACKE solves agreed within `1e-12`. Reproduce this
small check from the native dotrepo checkout; it does not build a user project.

```bash
g++ -O2 -I/usr/include/eigen3 scripts/check-native-matrices.cpp \
  -larmadillo -llapacke -o /tmp/check-native-matrices
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 /tmp/check-native-matrices
```

The [LaTeX profile](latex-toolchain.md) passed before and after the additions.
Newly available tools are `latexindent` 3.23.6 and ChkTeX 1.7.8; the distro
science and extra-utils packages are `2023.20240207-1`. Native pdfLaTeX,
XeLaTeX, LuaLaTeX, latexmk 4.83, Biber 2.19, Java 21.0.12 and Pygments 2.17.2
all passed their command checks.

All six pinned Fira Code fonts already matched the recorded hashes. Bib2Gls
4.7 and parser `1.6.20251106` already worked from
`~/texmf/scripts/bib2gls`; the existing `~/texmf/tex/latex/siunitx` override
remains selected. These local assets were preserved. No font or glossary asset
reinstallation was needed, and no thesis build was run during this pass.

## VS Code and Node tooling

Installed official `charliermarsh.ruff@2026.78.0` through the existing native
VS Code 1.136.1 server CLI and Marketplace connection. Its declared editor
requirement, `^1.75.0`, is satisfied. The WSL extension manifest grew from
34 to **35** entries; every unrelated extension ID and version stayed the same.
This covers all non-MATLAB entries in the newer source WSL extension inventory,
plus the target's existing viewer, Explorer and Antigravity additions. LaTeX
Workshop remains at 10.18.0. No editor or WSL restart was required for installation.

The existing portable **Node 24.20.0** installation now supplies **npm 12.0.2**
and **Corepack 0.36.0**. Registry SHA512 checks passed. The original `npm`, `npx`
and `corepack` command symlinks were restored to their recorded targets;
Yarn/pnpm shims remain absent.
The Node binary, system Node and installed AI tool files were unchanged.
A fresh Bash session verified these versions and Claude 2.1.263, Codex 0.153.4
and Gemini 0.58.0 at their native paths. Private rollback backups were retained.
The [npm archive records](../machines/pc-philip-windo-2026-09-08/wsl-native/npm-package-sources.json)
include package versions, Node engine requirements and verified hashes.

## Rust and existing development tools

Added native **Rust and Cargo 1.94.1**, matching the source versions and commit
identifiers, using official rustup 1.29.1 with verified installer and release
manifest checksums. The [minimal profile](https://rust-lang.github.io/rustup/concepts/profiles.html)
installed `rustc`, `cargo` and `rust-std`. The new `~/.cargo` and `~/.rustup`
trees use approximately **589.5 MiB** of unique allocated space.

The existing shared initializer already sources `~/.cargo/env`; `.bashrc` and
`.profile` symlinks and contents were unchanged. Fresh Bash finds the native
tools under `~/.cargo/bin`, and a one-job, offline Cargo compile/run passed.
The [Rust toolchain record](../machines/pc-philip-windo-2026-09-08/wsl-native/rust-toolchain.json)
contains the versions, archive hashes and native build result.
For a machine with rustup already installed, add the pinned toolchain with:

```bash
rustup toolchain install 1.94.1 --profile minimal
rustc +1.94.1 --version
cargo +1.94.1 --version
```

On a machine without rustup, use the [official installation instructions](https://rust-lang.github.io/rustup/installation/index.html),
verify the downloaded installer, and select `--default-toolchain 1.94.1
--profile minimal --no-modify-path`. Dotrepo's existing Cargo initializer
supplies the path. Preserve any other machine's existing toolchains and defaults
when adding this one.

Native Git 2.43.0, GitHub CLI 2.100.0, PowerShell 7.6.5, Google Cloud CLI 583.0.0,
CMake 3.28.3 and uv 0.12.10 already match. The active Google Cloud executable
comes from `~/google-cloud-sdk/bin`. This target's standalone rclone **1.74.2**
was retained; installing the source machine's older Ubuntu rclone package would
downgrade it. Exact paths and version checks are in
[existing-command-checks.json](../machines/pc-philip-windo-2026-09-08/wsl-native/existing-command-checks.json).
The [native library versions](../machines/pc-philip-windo-2026-09-08/wsl-native/native-libraries.tsv)
record the distribution-managed scientific stack used here.

## R restoration and validation

Native **R 4.6.1** now has all **283 reference packages at their recorded
versions**, after **117 additions or version adjustments**. The standard
library lookup grew from 261 to **325 distinct packages**, retaining all
**42 target-only extras** at their original versions and locations. Its
[inventory](../machines/pc-philip-windo-2026-09-08/wsl-native/r-standard-packages.tsv)
has 337 rows because some packages also have preserved system-library copies.

All 283 reference namespaces and all 42 extras loaded successfully. Unchanged
package DESCRIPTION hashes matched, and the repository's R matrix checks passed
for dense and sparse solves, eigenvalues, matrix exponentials and pseudoinverses.
Six spatial runtime checks also passed: sf projection, terra raster, fmesher
basis, inlabru mapper, rSPDE rational operator and an INLA native precision solve.
These are focused runtime checks, not full scientific-model validation. The
[validation receipt](../machines/pc-philip-windo-2026-09-08/wsl-native/r-validation.json)
records the results.

The active user library is `~/.local/lib/R/site-library`. Check the actual R
lookup from a fresh Bash session before installing packages on another machine:

```bash
/usr/bin/Rscript -e \
  'cat("R_LIBS_USER=", Sys.getenv("R_LIBS_USER"), "\n", sep=""); print(.libPaths())'
```

`R_LIBS_USER` must identify the intended existing library; check both shell and
R startup settings. This target also retains `~/R/library` and
`~/R/x86_64-pc-linux-gnu-library/4.6`. The restore built sequentially into the
standard library, backed up each replaced package and preserved older libraries
and unrelated packages.

Ordinary startup previously selected `~/R/library` because `.Renviron` overrode
the shared shell setting. After backing up both startup files, its one setting
was corrected to `R_LIBS_USER="~/.local/lib/R/site-library"`. The native-R block
in `.Rprofile` now appends the legacy and editor libraries after the configured
user and system libraries:

```r
# Native system-R fallbacks; keep configured and system libraries first.
if (identical(normalizePath(R.home()), "/usr/lib/R")) {
  .local_legacy_library <- path.expand("~/R/library")
  if (dir.exists(.local_legacy_library)) .libPaths(c(.libPaths(), .local_legacy_library))
  rm(.local_legacy_library)
  .local_editor_library <- path.expand("~/R/x86_64-pc-linux-gnu-library/4.6")
  if (dir.exists(.local_editor_library)) .libPaths(c(.libPaths(), .local_editor_library))
  rm(.local_editor_library)
}
```

Merge this setting and block with any other startup settings on another machine.
This supersedes the older `.Renviron` preservation choice in the
[September 6 recovery report](recovery-2026-09-06.md), following the subsequent
removal of Conda and restoration of the standard native R library.

Fresh Bash resolves both commands to `/usr/bin/R` and `/usr/bin/Rscript`.
Ordinary R and Rscript agreed on **490 active package names across 791 library
rows**: the 325 checked standard names plus **165 additional fallback-only
names**. All 283 source versions and 42 standard extras still matched, and the
matrix check passed through ordinary startup. The 412 legacy and 42 editor
package DESCRIPTION hashes remained unchanged. The 165 additional fallback
names were inventoried; their namespaces were not tested in this pass.

The [ordinary inventory](../machines/pc-philip-windo-2026-09-08/wsl-native/r-packages.tsv)
includes every visible library copy; the
[active inventory](../machines/pc-philip-windo-2026-09-08/wsl-native/r-active-packages.tsv)
records the version selected for each name. The
[startup validation](../machines/pc-philip-windo-2026-09-08/wsl-native/r-startup-validation.json)
records the library order and startup-file hashes. The smaller standard-library
inventory above was captured with explicit library settings and `--vanilla`,
which skips these user startup files.

The [R change manifest](../machines/pc-philip-windo-2026-09-08/wsl-native/r-package-changes.tsv)
records this target's dependency order, previous and requested versions, exact
CRAN archive URLs and observed SHA-256 hashes. Recalculate the difference on a
different machine against the full source inventory; this target's 117-row delta
is not a complete R environment specification. If a current CRAN URL has moved,
locate the same version in that package's official CRAN archive and verify its
recorded hash. Only required Depends, Imports and LinkingTo dependencies were
included, with no additional versions chosen outside the source inventory.

After checking that no R process uses the library, preserve a full backup of
each package being replaced, then use normal staged installation for each
reviewed archive in dependency order:

```bash
export R_LIBS_USER="$HOME/.local/lib/R/site-library"
MAKEFLAGS=-j1 CMAKE_BUILD_PARALLEL_LEVEL=1 \
  OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 \
  /usr/bin/R CMD INSTALL --library="$R_LIBS_USER" PACKAGE_VERSION.tar.gz
/usr/bin/Rscript --vanilla scripts/check-r-matrices.R
```

Replace the archive placeholder with the reviewed file. Stop on an installation
or validation failure and restore that package's backup before proceeding.
Existing `00LOCK-*` directories require an active-process check; preserve stale
ones in a backup rather than deleting them. This pass archived the unused
June 2 `00LOCK-car` directory after checking open references and verifying its
contents. The user-library cluster/spatial overrides follow the source's first
records; their separate system-library copies remain intact.

The exact source archives total 147,668,960 bytes. Backups retain 54 original
package directories plus the stale lock, totaling 404,678,038 logical file bytes
(approximately 386 MiB). These are retained rollback files; the figure is not
a measurement of allocated disk space. Builds used one job and one numerical
thread at a time; the native compilation in packages such as s2, terra and FRK
accounted for most of the installation time.

## Preserved setup and remaining choices

The existing `py313`, `jax313` and `jax314` environments were left unchanged.
Fresh interactive Bash selected `~/.virtualenvs/py313/bin/python` 3.13.15,
reported the expected `VIRTUAL_ENV` and R library, and found the three standard
environment configurations. Miniforge remains absent after the earlier
[Python migration](wsl-python-parity-2026-09-07.md). Noninteractive `bash -lc`
intentionally does not autoactivate the interactive Python default.

Drive startup was disabled only in the fresh-shell verification process.
This pass did not restart WSL, VS Code or Drive. Existing projects and local
assets were preserved. Wolfram was not included in this open-source tools pass.
MATLAB was not installed.

## Private verification and rollback evidence

These machine-local records are not substitutes for the shareable inventories:

- `~/.local/state/dotrepo/wsl-software-parity-20260908/logs/` contains
  `apt-plan.log`, `apt-install.log`, `apt-check.log`, `dpkg-audit.log`,
  `native-matrix-build.log`, `native-matrix-run.log` and
  `fresh-interactive-bash-layout.log`.
- `C:\dev\dotrepo\.local\wsl-useful-software-20260908\` contains
  `latex-audit.json`, `latex-post-apt-checks.json`, the Ruff installation log,
  `ruff-wsl-install-result.json` and both extension-manifest snapshots.
- `~/.local/state/dotrepo/node-tooling-parity-20260908T074209Z/result.json`
  records the completed Node tooling update and its retained backups.
- `~/.local/state/dotrepo/rust-parity-20260908T075200Z/result.json` records
  Rust installation, checksums, startup preservation and the offline build/run.
- `~/.local/state/dotrepo/wsl-useful-software-20260908/r-parity/` contains the
  R preparation, original inventories, package archives and restoration records.
  `final-validation.json` records the successful installation, inventory,
  namespace, matrix, spatial and package-preservation checks.
- `~/.local/state/dotrepo/wsl-useful-software-20260908/r-startup/` retains the
  original `.Renviron` and `.Rprofile`, exact applied patch, ordinary R/Rscript
  inventories and matrix results. Final root process checks found no remaining
  R or library consumers; all owned installer and test processes finished.
