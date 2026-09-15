# PhilipSecond WSL replication, September 14–15, 2026

Target machine: **PhilipSecond**. This capsule records application of the
[PC-PHILIP-WINDOWS source capsule](../pc-philip-windows-2026-09-14/README.md).
See the [installation report](../../docs/wsl-replication-philipsecond-2026-09-14.md)
for scope, rollback paths and remaining differences.

| Evidence | Scope |
| --- | --- |
| [Five environments](five-environments.json) | Exact distribution inventories and dependency checks for py313, jax313, jax314, jax-oracles313 and uqpy312 |
| [GPU stack](gpu-stack.json) | Main Python, NVIDIA package/compiler/runtime and driver comparison; target RTX 5070 Laptop |
| [Python checks](python-checks.json) | 22 main numerical references and GPflow CPU |
| [Companion checks](companion-checks.json) | JAX GPU, Dynamax/BayesNF, PyGAM and UQpy/Whittle |
| [Repository checks](repository-checks.json) | Quadrature, NUFFT, scoring, RF77 Whittle, Gephi and existing SMPL assets |
| [Julia checks](julia-checks.json) | Seven numerical references using the two restored projects |
| [R comparison](r-snapshot-check.json), [ordinary startup](r-promotion.json), [inventory](r-active-after.tsv) | All 516 source versions matched; 517 active packages including required V8 |
| [R spatial checks](r-m-tier-check.json), [RF77 R checks](rf77-r-check.json) | All 11 spatial/GP and four RF77 numerical probes passed |
| [R source receipts](r-restoration-sources.json), [additional dependency](r-additional-dependency.json) | Archive hashes and Git source commits; V8 source and hash |
| [Runtime integration](runtime-integration.json) | Framework coexistence scope and Wolfram reference checks |
| [ExaGeoStat](exageostat-verification.json), [MRA](mra-verification.json), [native checks](native-checks.json) | CPU likelihood/prediction, native matrix libraries, FLINT/Boost and Octave |
| [Target status](target-status.json) | Selected environment paths, software versions, repository commits and APT changes |
| [APT inventory](apt-after.tsv), [source differences](apt-snapshot-differences.json) | 1,603 installed packages; unavailable source chatgpt package and two newer target versions |
| [Required commits](source-commit-checks.json) | Presence of source repository fixes; local changes retained |
| [Home startup](home-start-check.json) | Fresh interactive Bash begins in home with Python 3.13.15 |
| [Drive user service](gdrive.service) | Installed as `~/.config/systemd/user/dotrepo-gdrive.service`, enabled with user lingering; uses existing private settings |
| [Editor additions](vscode-additions.json), [extensions](vscode-after.txt) | WSL editor extension inventory |

Source archives/build logs and old environment backups remain private under
`~/.local/state/dotrepo/replication-20260914`. Equal package versions do not mean
identical editable source trees. No separate gpflow312 environment was created.
GPflow uses CPU; PyTorch GPU passed in a separate process, but initializing it
after JAX and TensorFlow in one process failed with CUDA error 302.

These are functional smoke checks and captured inventories, not a claim that
every application feature or every possible numerical workload was validated.
