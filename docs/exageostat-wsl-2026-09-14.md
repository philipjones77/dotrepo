# ExaGeoStat CPU installation in WSL

PC-PHILIP-WINDOWS now has ExaGeoStatCPP 2.0.0 installed and tested in Ubuntu.
The [receipt](../machines/pc-philip-windows-2026-09-14/exageostat-oracle.json)
records source commits, dependencies, the APT transaction and numerical results.
The launcher is `~/.local/bin/exageostat-cpu`. Its 64-point Matérn exact fit and
eight held-out predictions passed with finite likelihood and prediction error.
GPU, MPI, HiCMA low-rank support and the R interface were disabled.

## Version choices and source retention

The build uses the [official ExaGeoStatCPP source](https://github.com/ecrc/ExaGeoStatCPP)
at commit `bd9240a1da5b163f060f310286b37c660785759c`, its requested
[Chameleon 1.1.0](https://gitlab.inria.fr/solverstack/chameleon/-/tree/v1.1.0),
and [StarPU 1.3.10](https://files.inria.fr/starpu/starpu-1.3.10/starpu-1.3.10.tar.gz).
BLAS++ 2023.01.00 is fetched by ExaGeoStat's CMake configuration.

Chameleon 1.1.0 failed to compile with Ubuntu's StarPU 1.4.3 because the
`pointer_is_inside` interface member was removed. Chameleon's package finder
also prefers `starpumpi-1.3.pc` even when MPI is disabled; Ubuntu provides that
name as an alias to 1.4. The build below exposes only the local StarPU metadata
while retaining access to other system dependencies. Scientific source files
were unchanged.

Keep the ExaGeoStat checkout and dependency source directories after installation:
upstream embeds its configuration and kernel-header paths in the library. The
installed `ExaGeoStatCPP.pc` also needed its prefix corrected to the nested
`EXAGEOSTATCPP` directory. The receipt records that metadata-only adjustment.

## Rebuild on the other machine

Verify its hostname and preserve its inventories and running jobs first. Use a
new, empty prefix if these directories already contain an installation. Run the
following commands inside the target's Ubuntu WSL distribution.

Required system tools/libraries include Git, curl, CMake, make, GCC/G++, gfortran,
pkg-config, OpenBLAS, LAPACKE, hwloc, GSL, NLopt C++ and nlohmann JSON. Compare
the target's existing packages, simulate an additive transaction, then install
the missing dependencies. Preserve the before inventory and transaction log.

```bash
apt-get --simulate --no-remove install build-essential gfortran cmake git curl \
  pkg-config libopenblas-dev liblapacke-dev libhwloc-dev libgsl-dev \
  libnlopt-cxx-dev nlohmann-json3-dev
# Apply the reviewed dependency transaction using the target's root mechanism.
```

This machine also received Ubuntu's `libstarpu-dev` and its dependencies before
the version mismatch was identified. Those packages remain installed; this
native build selects its separate StarPU 1.3.10 installation.

### 1. Build local StarPU

```bash
set -euo pipefail
export oracle_state="$HOME/.local/state/dotrepo/m-tier-oracles-20260914/exageostat"
export oracle_prefix="$HOME/.local/opt/exageostat-cpp-20260914"
mkdir -p "$oracle_state" "$oracle_prefix/CHAMELEON"
cd "$oracle_state"
curl --fail --location --retry 2 -o starpu-1.3.10.tar.gz \
  https://files.inria.fr/starpu/starpu-1.3.10/starpu-1.3.10.tar.gz
echo '757cd9a54f53751d37364965ac36102461a85df3a50b776447ac0acc0e1e2612  starpu-1.3.10.tar.gz' | sha256sum --check
tar -xzf starpu-1.3.10.tar.gz
cd starpu-1.3.10
./configure --prefix="$oracle_prefix/STARPU" --disable-cuda --disable-opencl \
  --disable-mpi --disable-fortran --disable-build-tests --disable-build-examples \
  --disable-build-doc --disable-socl --enable-shared --enable-maxcpus=16
make -j2
make install
```

### 2. Isolate StarPU package metadata and build Chameleon

The small directory of symlinks below excludes system StarPU `.pc` files.
It changes lookup only in this shell; it does not alter system metadata.

```bash
python3 - <<'PY'
import os
from pathlib import Path
target = Path(os.environ['oracle_state']) / 'pkgconfig-cpu'
target.mkdir(exist_ok=True)
for source in ['/usr/lib/x86_64-linux-gnu/pkgconfig', '/usr/share/pkgconfig', '/usr/lib/pkgconfig']:
    for package in Path(source).glob('*.pc'):
        if 'starpu' in package.name or package.name.startswith('socl'):
            continue
        destination = target / package.name
        if not destination.exists():
            destination.symlink_to(package)
PY
export PKG_CONFIG_PATH="$oracle_prefix/STARPU/lib/pkgconfig"
export PKG_CONFIG_LIBDIR="$oracle_state/pkgconfig-cpu"
export LD_LIBRARY_PATH="$oracle_prefix/STARPU/lib"
pkg-config --modversion starpu-1.3   # Must report 1.3.10.
git clone --branch v1.1.0 --recursive \
  https://gitlab.inria.fr/solverstack/chameleon.git \
  "$oracle_prefix/CHAMELEON/chameleon-src"
cd "$oracle_prefix/CHAMELEON/chameleon-src"
test "$(git rev-parse HEAD)" = 4db899ca30d29927018d83964b9b6d517269abe1
cmake -S . -B bin -DCMAKE_INSTALL_PREFIX="$oracle_prefix/CHAMELEON" \
  -DCMAKE_C_FLAGS=-fPIC -DCHAMELEON_USE_MPI=OFF -DCHAMELEON_USE_CUDA=OFF \
  -DCHAMELEON_SCHED_STARPU=ON -DCHAMELEON_ENABLE_TESTING=OFF \
  -DCHAMELEON_ENABLE_EXAMPLE=OFF
cmake --build bin -j2
cmake --install bin
```

If resuming a configure that already detected system StarPU, add
`-U '*STARPU*' -U '*starpu*'` to the CMake configure command. Confirm its output
finds only the local `libstarpu-1.3` and headers before compiling.

### 3. Build and install ExaGeoStatCPP

```bash
export PKG_CONFIG_PATH="$oracle_prefix/STARPU/lib/pkgconfig:$oracle_prefix/CHAMELEON/lib/pkgconfig"
git init "$oracle_state/ExaGeoStatCPP"
cd "$oracle_state/ExaGeoStatCPP"
git remote add origin https://github.com/ecrc/ExaGeoStatCPP.git
git fetch --depth 1 origin bd9240a1da5b163f060f310286b37c660785759c
git checkout --detach FETCH_HEAD
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 cmake -S . -B bin \
  -DCMAKE_INSTALL_PREFIX="$oracle_prefix" -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=ON -DBUILD_TESTS=OFF -DBUILD_DOCS=OFF \
  -DUSE_HICMA=OFF -DUSE_CUDA=OFF -DUSE_MPI=OFF -DUSE_R=OFF \
  -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC
cmake --build bin -j2
cmake --install bin
```

Existing dependencies must be detected successfully. Upstream's automatic
dependency installer chooses its own parallel job count; inspect the configure
output if it unexpectedly starts rebuilding a dependency. This session used
two compiler jobs initially and four after other installation jobs finished.

### 4. Install the launcher and correct package metadata

Run this from the same shell, with `oracle_state` and `oracle_prefix` still set.
It refuses to replace an existing launcher. The environment script is sourced
by that launcher and does not need a global shell-startup change.

```bash
python3 - <<'PY'
import os
from pathlib import Path
import shutil
state = Path(os.environ['oracle_state'])
prefix = Path(os.environ['oracle_prefix'])
name = 'Example_Data_Generation_Modeling_and_Prediction'
destination = prefix / 'EXAGEOSTATCPP/bin'
destination.mkdir(exist_ok=True)
shutil.copy2(state / 'ExaGeoStatCPP/bin/examples/end-to-end' / name, destination / name)
libdirs = ':'.join(str(prefix / p) for p in ['EXAGEOSTATCPP/lib', 'lib', 'STARPU/lib', 'CHAMELEON/lib'])
pkgdirs = ':'.join(str(prefix / p) for p in ['EXAGEOSTATCPP/lib/pkgconfig', 'lib/pkgconfig', 'STARPU/lib/pkgconfig', 'CHAMELEON/lib/pkgconfig'])
environment = prefix / 'environment.sh'
environment.write_text(
    f'export EXAGEOSTAT_CPP_ROOT="{prefix}/EXAGEOSTATCPP"\n'
    f'export LD_LIBRARY_PATH="{libdirs}${{LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}}"\n'
    f'export PKG_CONFIG_PATH="{pkgdirs}${{PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}}"\n')
launcher = Path.home() / '.local/bin/exageostat-cpu'
launcher.parent.mkdir(exist_ok=True)
with launcher.open('x') as handle:
    handle.write(f'#!/bin/sh\n. "{environment}"\nexport STARPU_NCUDA=0 STARPU_NOPENCL=0\nexec "{destination / name}" "$@"\n')
launcher.chmod(0o755)
package = prefix / 'EXAGEOSTATCPP/lib/pkgconfig/ExaGeoStatCPP.pc'
shutil.copy2(package, state / 'ExaGeoStatCPP.pc.before-prefix-fix')
package.write_text(package.read_text().replace(f'prefix="{prefix}"', f'prefix="{prefix}/EXAGEOSTATCPP"'))
PY
```

## Verify the installed result

From the target's dotrepo checkout:

```bash
python3 scripts/check-exageostat-environment.py
. "$oracle_prefix/environment.sh"
ldd -r "$oracle_prefix/EXAGEOSTATCPP/lib/libExaGeoStatCPP.so"
pkg-config --modversion ExaGeoStatCPP
```

The check uses a deterministic CSV dataset because the pinned source's current
CPU configuration validation requires a data path. It checks finite likelihood,
finite nonnegative mean-square prediction error and at least one optimization
iteration. This is a small functional check; it does not establish exhaustive
kernel coverage, large-scale performance or accelerator support. Record the
target's actual results separately from PC-PHILIP-WINDOWS.
