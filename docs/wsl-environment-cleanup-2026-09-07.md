# PC-PHILIP-WINDO WSL environment cleanup — 2026-09-07

At the user's request, Ubuntu on **PC-PHILIP-WINDO** now retains only the
**base** and **jax** Conda environments. Both are managed by the existing
Miniforge installation. This is separate from the PhilipSecond source
computer's move away from Conda; do not remove this target's Miniforge based
on that source inventory.

## Retained environments

| Environment | Prefix | Python | Verification |
| --- | --- | --- | --- |
| `base` | `/home/phili/miniforge3` | 3.12.12 | Python and Conda, SSL and SQLite imports passed |
| `jax` | `/home/phili/miniforge3/envs/jax` | 3.12.12 | JAX 0.11.1 reported `cuda:0`; a JIT computation matched the NumPy result |

`base` contains Conda itself. `jax` is the separate scientific environment.
The final Conda environment list contains exactly these two prefixes. Their
installed Conda package metadata hashes matched the pre-cleanup hashes.
JAX verification used `XLA_PYTHON_CLIENT_PREALLOCATE=false` and checked 32
float32 results; this is a runtime/GPU smoke test, not full project validation.

## Removed environments

Five additional Conda environments were removed with Conda's environment
removal command after checking each exact prefix and its dry-run plan:

- `/home/phili/miniforge3/envs/bnf-env`
- `/home/phili/miniforge3/envs/uqpy`
- `/home/phili/miniforge3/envs/rqs`
- `/home/phili/miniforge3/envs/glpk`
- `/home/phili/miniforge3/envs/gemini-cli`

Two project virtual environments were also removed:

- `/home/phili/projects/IntegralFunctionsJAX/.venv`
- `/home/phili/projects/RandomFields77/.venv`

Both project parent directories remain. Only their `.venv` directories were
deleted; project source and configuration files were preserved. All seven
removed prefixes were confirmed absent. The previous inventory of nine
environments is now two. Ubuntu's system Python is separate from this count.

No active process references to the removal targets were found in command
arguments, working directories, executables, environment variables, mapped
files or open file descriptors. Exact resolved paths, environment markers
and absence of symlink redirection were checked again before deletion.
No jobs were stopped. Conda removals used the installed local metadata in
offline mode, without upgrading retained environments.

## Recovery records and space

Local reconstruction records were saved before deletion under:

```text
/home/phili/.dotrepo-backups/20260907-154028-removed-wsl-environments
```

They include the original Conda environment list, package metadata and
explicit package specifications for each removed Conda environment, plus
`pyvenv.cfg` and installed-package inventories for the project virtual
environments. These are recipes and metadata, not full environment copies.
Their metadata markers should be excluded from future environment counts.

The private Windows evidence directory is
`.local/wsl-environment-cleanup-20260907/`; `result.json` records completion
at **15:41:48 CDT** with phase `verified`, the exact removals, unchanged
retained metadata and the successful JAX GPU check. Raw records remain
outside Git.

Observed free space inside WSL increased from 830,536,986,624 to
835,114,577,920 bytes, about **4.26 GiB**. This measures guest filesystem
space and can also reflect concurrent activity. The shared Conda package
cache was retained. No VHD compaction or Windows disk-file shrink was performed.

## Scope and using the retained environments

This later cleanup request authorized these WSL environment removals after
the earlier Windows-only update batch. The four restored Windows Python
environments were untouched. Ubuntu upgrades, the deferred Drive helper
restart, Docker startup and disk compaction were not part of this cleanup.

Use these commands inside Ubuntu Bash:

```bash
source /home/phili/miniforge3/etc/profile.d/conda.sh
conda env list
conda activate jax
python --version
# Return to Conda's base environment when needed:
conda activate base
```

A separate read-only SSH check also authenticated successfully to GitHub as
`philipjones77` using WSL's OpenSSH client. This verified outbound GitHub SSH
access, not an inbound SSH server.
