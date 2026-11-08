# Standard Windows Python

The Windows default is uv-managed CPython **3.14.10** in `~/.virtualenvs/py314`,
with JAX and jaxlib **0.12.0.1** (native Windows CPU). PowerShell, Windows VS
Code, repository tools and Cloud SDK use this environment. Its pinned
distributions also cover the reference, thesis and diagram tools.
R and its development tools belong in WSL, not the native Windows baseline.
Python 3.13 and the 3.15 preview are retained only for recovery or
explicit compatibility work; running processes keep their original interpreter.

Create the current Windows baseline on a machine where `py314` is absent:

```powershell
.\python\windows\create-standard-environments.ps1
# Or create an independent Python 3.14 project environment:
.\python\windows\create-venv.ps1 -Path .venv-py314
```

Both helpers use [requirements-py314.txt](requirements-py314.txt) and check
dependencies. They refuse to overwrite existing environments. Current local
repository aliases named `.venv-py314` point to the shared environment; use the
creation helper above when project isolation is needed instead.

The September 7 source inventory is a historical recovery snapshot. It records
four independent environments in `~/.virtualenvs`:

| Name | Python | Recorded distributions |
| --- | --- | --- |
| py313 | 3.13.15 | 10; historical default, including JAX CPU |
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

The shared PowerShell profile activates `py314` when available. After verification,
put its `Scripts` directory first in the user PATH, set the ignored Windows VS
Code `python.defaultInterpreterPath` override to its `python.exe`, and point
`CLOUDSDK_PYTHON` there if Cloud SDK is installed. Back up existing settings first.
Open a new terminal or reload an existing editor to refresh its environment.
Activate another environment with its `Scripts/Activate.ps1` when needed.

VS Code remembers explicitly selected interpreters separately from settings.
The local [migration helper](../../vscode/windows-python-default/extension.js)
uses Microsoft's [Python environment API](https://github.com/microsoft/vscode-python/wiki/Python-Environment-APIs)
to select `py314` once per native `C:\dev` workspace folder whose configured
default already names `py314`. It runs when installed or when a workspace opens,
records readback results under `~/.local/state/dotrepo/windows-python-default`,
and leaves later manual selections alone. Remote/WSL workspaces are excluded.
It does not restart VS Code or running Python jobs. Build and install locally:

```powershell
python vscode/windows-python-default/package.py reports/windows-python-default.vsix
code --install-extension reports/windows-python-default.vsix --force --do-not-sync
```

`create-standard-environments.ps1` reproduces the current Python 3.14 baseline;
`restore-recorded-environments.ps1` reproduces the historical September snapshot.
The older `environment.yml` is a legacy Conda recipe; it is not the current
Windows default. Do not install Anaconda or Miniconda to reproduce this baseline.
Preserve existing recovery environments until their data and project references
have been reviewed. WSL environments are maintained independently.
