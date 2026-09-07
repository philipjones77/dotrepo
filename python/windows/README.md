# Standard Windows Python

The Windows baseline is standard CPython managed by uv. The September 7 source
inventory records four independent environments in `~/.virtualenvs`:

| Name | Python | Recorded distributions |
| --- | --- | --- |
| py313 | 3.13.15 | 10; default shell/editor environment, including JAX CPU |
| py314 | 3.14.7 | 4 |
| py315 | 3.15.0rc2 | 3; separate preview interpreter |
| jax-win | 3.14.7 | 151; scientific and notebook tools |

With uv installed, reproduce the recorded interpreter and package versions:

```powershell
.\python\windows\restore-recorded-environments.ps1
# Check existing environments without changing their packages:
.\python\windows\restore-recorded-environments.ps1 -VerifyOnly
# Select a subset, or choose a different root explicitly:
.\python\windows\restore-recorded-environments.ps1 -EnvironmentName py313,py314
```

The helper reads the [source inventories](../../machines/source-2026-09-07/windows/standard-python/environments.json)
and sibling package JSON files. It validates names/counts, resolves exact pins
in an empty preflight environment, creates each actual venv at its final path,
and installs only the recorded distributions. It never syncs, replaces, moves
or deletes an existing environment. A rerun verifies existing directories;
review a failed partial installation before repairing it. Reports and preflight
directories stay under `~/.local/share/dotrepo/windows-python` by default.

Verification compares all package names/versions, the Python patch version and
the non-Conda base interpreter. It checks dependencies, SSL configuration and
SQLite, then applicable YAML, JAX JIT/gradient, SciPy solve, PyTorch matrix and
VTK mesh operations. These are representative checks, not every project workload.
Inventories contain no artifact hashes or original wheel provenance, so an exact
version/package match is not a claim of byte-for-byte environment identity.

Downloads use Windows certificate verification. For each uv subprocess, the
helper temporarily clears inherited `SSL_CERT_FILE`/`SSL_CERT_DIR` overrides
that would otherwise supersede its explicit system-trust setting; it restores
the caller's variables afterward. It does not disable TLS verification or
change Norton exclusions. See [uv's certificate behavior](https://docs.astral.sh/uv/concepts/authentication/certificates/).

The shared PowerShell profile activates `py313` when available. After verification,
put its `Scripts` directory first in the user PATH, set the ignored Windows VS
Code `python.defaultInterpreterPath` override to its `python.exe`, and point
`CLOUDSDK_PYTHON` there if Cloud SDK is installed. Back up existing settings first.
Open a new terminal or reload an existing editor to refresh its environment.
Activate another environment with its `Scripts/Activate.ps1` when needed.

`create-standard-environments.ps1` remains a convenience helper that requests
current compatible packages, rather than the exact captured package set.
The older `environment.yml` is a legacy Conda recipe; it is not the current
Windows default. Do not install Anaconda or Miniconda to reproduce this baseline.
Preserve existing recovery environments until their data and project references
have been reviewed. WSL environments are maintained independently.
