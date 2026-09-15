# IFJ and Julia oracle installation, September 14, 2026

Host: **PC-PHILIP-WINDOWS**, Ubuntu WSL. Python checks use the requested
`~/.virtualenvs/py313` environment. Julia and Mathematica run as external
processes; their packages belong to their own package environments.

## IFJ refresh and Python checks

IntegralFunctionsJAX was fetched and fast-forwarded from
`a35fef0e344d101507108fe014b3e086637951d1` to
`611ac9b595665fb8df204017bf9f0a69185776f8`. Three byte-identical untracked
files that collided with incoming tracked files were retained in a private
backup before the fast-forward. Other machine-local files remain present.
No tracked IFJ source changes were made for this installation.

The repo's oracle-policy, GPL adapter, MB adapter, Quadax, and shipped rational
table checks passed **29 tests**. Separate actual mpmath and Arb/FLINT adapter
calls passed three elementary/Bessel reference cases. SciRS2 passed its supported
rational-power case; the current IFJ adapter does not implement the other two
cases. FFTLog/Hankl additions and their checks are recorded in the
[Python receipt](../machines/pc-philip-windows-2026-09-14/repo-oracles/python.json).

## Mathematica and native references

| Component | Installed source/version | Functional check |
| --- | --- | --- |
| Wolfram | 14.3, existing licensed installation | Gamma, BesselJ and MeijerG values |
| MBConicHulls | upstream `7d75915ba3c2e5f92f89b1cfa2ee4db5fcf1cee8` | MB representation, conic solution and actual TOPCOM triangulation |
| MultivariateResidues | bundled with the pinned MBConicHulls checkout | loaded and used by the MB oracle |
| TOPCOM | Ubuntu `1.1.2+ds-1.1build2` | one regular triangulation through MBConicHulls |
| PolyLogTools | 1.4, upstream `e0284d0cba0299f6d584094a053d3e890d13aebe` | `Ginsh` evaluates Li2(1/3) against Wolfram PolyLog |
| HPL | 2.0, November 2011 archive | 30-digit Li2(1/3) agreement |
| GiNaC | Ubuntu `1.8.7-1build2` | PolyLogTools `Ginsh` numerical call |

The MBConicHulls user-local loader selects one auxiliary kernel and serial
defaults. In headless sessions it adapts only `FindTriangulations` temporary-file
IO: the current directory replaces `NotebookDirectory[]`, and explicit `Text`
exports create TOPCOM input/shell files. The upstream source checkout remains
unchanged. Mathematica may print front-end display warnings during successful
headless numerical work.

PolyLogTools loads with legacy Combinatorica symbol warnings on Wolfram 14.3.
Its `Ginsh` path passed the numerical check. Its older
`LiNumericalValueFromGiNaC` C++ emitter uses removed `lst(...)` constructors and
does not compile against installed GiNaC; use the tested `Ginsh` interface.
The source package is [PolyLogTools upstream](https://gitlab.com/pltteam/plt);
HPL comes from its [author's distribution](https://www.physik.uzh.ch/data/HPL/).

## Julia environments

The complete resolved manifests and checks are in the
[Julia receipt](../machines/pc-philip-windows-2026-09-14/repo-oracles/julia.json).

| Environment | Runtime | Direct oracle packages |
| --- | --- | --- |
| `@repo-oracles` | Julia 1.13.0 | MeijerG, FastGaussQuadrature, Integrals, Cuba, TemporalGPs, Vecchia; AbstractGPs, KernelFunctions and StaticArrays helpers |
| `@repo-oracles-oilmm` | Julia 1.10.12 through `julia-oilmm` | OILMMs 0.2.5; AbstractGPs and KernelFunctions helpers |

FastGaussQuadrature, Integrals and Cuba passed small integral checks.
TemporalGPs matched a dense GP likelihood to `2.3e-16` and produced posterior
means. Vecchia evaluated an eight-point likelihood, and OILMMs sampled a small
two-output model, evaluated its likelihood and produced posterior means.

OILMMs needs the second runtime because its declared FillArrays 0.11/0.12
dependency is restricted to Julia through 1.10 in the
[official registry](https://raw.githubusercontent.com/JuliaRegistries/General/master/F/FillArrays/Compat.toml).
The pinned [OILMMs source](https://github.com/willtebbutt/OILMMs.jl) is commit
`c860fd6f9266331b4877921ce8147d962bcbd72a`. Package compatibility was preserved.

**MeijerG 0.1.1 has a known local validation failure.** At `z=0.3`, lower
parameters `(0.25, 0.75)`, its default Bessel reduction returns
`1.462137536562182`; the independent identity gives `0.4386412609686546`.
The installed source multiplies by the wrong sign of the parameter-shift power,
contrary to [DLMF 16.19.2](https://dlmf.nist.gov/16.19.E2).
The explicit `meijerg_slater` route returns `0.43864126096865586` and passes.
Two elementary identities also pass with 192-bit BigFloat inputs. BigFloat
Bessel reduction is separately unsupported by the underlying SpecialFunctions
method. Keep these limits visible when selecting an oracle; source installation
does not establish general numerical correctness.

RF77's cited `JuliaStats/GraphicalModels.jl` URL returns HTTP 404 and the package
is absent from Julia's General registry. A historical unmaintained namesake was
not substituted. This remains an unavailable cited source.

## Activate and reproduce

Shared WSL shell setup sources `~/.local/opt/repo-oracles/ifj-env.sh` when present.
The file supplies defaults while preserving explicit user environment variables.
Sourcing it starts no runtime or worker. In an existing shell:

```bash
. "$HOME/.local/opt/repo-oracles/ifj-env.sh"
julia --project=@repo-oracles -e 'using Pkg; Pkg.status()'
julia-oilmm -e 'using Pkg; Pkg.status()'
```

To replay on another machine, first verify its hostname and preserve its local
environments. Install the two official Julia archives identified by URL and
SHA-256 in the [Julia receipt](../machines/pc-philip-windows-2026-09-14/repo-oracles/julia.json),
under `~/.local/opt/julia-VERSION`.
Point `~/.local/bin/julia` at Julia 1.13.0. Make `julia-oilmm` execute
`~/.local/opt/julia-1.10.12/bin/julia --project=@repo-oracles-oilmm "$@"`.
Copy each captured `Project.toml` and `Manifest.toml` pair into the matching
`~/.julia/environments/NAME` directory after preserving any existing environment.
From the dotrepo checkout, the source files are under
`machines/pc-philip-windows-2026-09-14/repo-oracles/julia/`.

```bash
export JULIA_NUM_THREADS=1 JULIA_NUM_PRECOMPILE_TASKS=1
export JULIA_PKG_PRECOMPILE_AUTO=0 JULIA_PKG_USE_CLI_GIT=true
julia --project=@repo-oracles -e 'using Pkg; Pkg.instantiate()'
julia-oilmm -e 'using Pkg; Pkg.instantiate()'
```

Install Ubuntu `topcom`, `libginac-dev`, and `ginac-tools`, then prepare the
external Mathematica source tree. Run these clone commands only when the target
directories do not already exist:

```bash
oracle_root="$HOME/.local/opt/repo-oracles"
mkdir -p "$oracle_root"
git clone https://github.com/SumitBanikGit/MBConicHulls "$oracle_root/MBConicHulls"
git -C "$oracle_root/MBConicHulls" checkout 7d75915ba3c2e5f92f89b1cfa2ee4db5fcf1cee8
git clone https://gitlab.com/pltteam/plt.git "$oracle_root/PolyLogTools"
git -C "$oracle_root/PolyLogTools" checkout e0284d0cba0299f6d584094a053d3e890d13aebe
```

Download `https://www.physik.uzh.ch/data/HPL/HPL-2.0.tar.gz`, verify SHA-256
`ca965edb320c735f31433daf11b099ef11d2fbd1a8108b11293d18a6674136ee`, and extract
its `HPL-2.0` directory under `oracle_root`. Copy `ifj-env.sh`,
`MBConicHulls-ifj.wl`, and `PolyLogTools-ifj.wl` from
`machines/pc-philip-windows-2026-09-14/repo-oracles/ifj/` in the dotrepo checkout
into `oracle_root`. Under `oracle_root/topcom-bin`, create symlinks
`points2alltriangs`, `points2placingtriang`, and `points2triangs` to
`/usr/bin/topcom-points2alltriangs`, `/usr/bin/topcom-points2placingtriang`, and
`/usr/bin/topcom-points2triangs`, respectively. A working licensed Wolfram
installation is required on that machine.

Start the following replay commands in the dotrepo checkout. They locate the
included checks before entering a writable scratch directory. The Mathematica
checks create their own per-user directory under
`~/.local/state/dotrepo/repo-oracles-20260914/ifj/`. Julia checks accept one
package name; use `julia-oilmm` for OILMMs. Cold Julia loading can take minutes.
Local checks limited Julia/BLAS/Cuba worker counts to one.

```bash
oracle_checks="$PWD/machines/pc-philip-windows-2026-09-14/repo-oracles/ifj"
test -f "$oracle_checks/check-julia-reference.jl"
oracle_scratch="$(mktemp -d "${TMPDIR:-/tmp}/repo-oracle-smoke.XXXXXX")"
cd "$oracle_scratch"
. "$HOME/.local/opt/repo-oracles/ifj-env.sh"
export OPENBLAS_NUM_THREADS=1 CUBACORES=0
julia --project=@repo-oracles "$oracle_checks/check-julia-reference.jl" FastGaussQuadrature
julia-oilmm "$oracle_checks/check-julia-reference.jl" OILMMs
wolframscript -file "$oracle_checks/check-mbconichulls-headless-export.wls"
wolframscript -file "$oracle_checks/check-polylogtools.wls"
```

IFJ's Boost registry entry describes a future external harness: native Boost
headers exist, but a `boost_math` Python adapter is not supplied. PolyLogTools
still needs an evaluator registered by an IFJ caller for its GPL adapter.
The experimental neural-contour backend requires a separately supplied trained
artifact. No flags were set to misrepresent these integration boundaries.
