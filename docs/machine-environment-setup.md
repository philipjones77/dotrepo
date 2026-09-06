# Machine And Environment Setup Matrix

This is the standard setup matrix dotrepo should verify.

The rule is: every machine or execution environment must have a documented
profile, a read-only audit command, and a status entry.

## Status Sources

- Human-readable current status: `status/setup-status.md`
- Status vocabulary: `status/README.md`
- Generated local audit output: `.local/status/`
- Future machine-readable inventory: `projects/inventory.yml`

## Windows Host Profile

Purpose:

- Windows desktop shell and UI
- VS Code local settings
- Windows Terminal
- PowerShell profile
- Git/GitHub CLI
- Docker Desktop control plane
- WSL management

Required:

- Git
- GitHub CLI
- WSL
- PowerShell 7 or compatible PowerShell
- VS Code
- Windows Terminal
- tracked `.gitconfig`, `.ssh/config`, `.wslconfig`, VS Code settings

Optional:

- Docker Desktop
- Google Cloud CLI
- Antigravity CLI for individual/free Gemini coding workflows
- Antigravity desktop app when desktop agent workflows are used
- Google Drive for desktop
- conda
- Node/npm
- Mathematica/Wolfram Engine

Verify:

```powershell
.\bootstrap\audit.ps1
.\cloud\docker\audit.ps1
.\cloud\google\audit.ps1
.\cloud\google-drive\audit.ps1
```

Status should show Windows tools as `ok` or explain why optional tools are
`optional-missing`.

## WSL Ubuntu Profile

Purpose:

- primary Linux development environment
- Python/JAX work
- CUDA-backed JAX when available
- Git/GitHub CLI
- Linux shell tooling
- Docker CLI integration when Docker is used

Required:

- Git
- GitHub CLI
- Python 3
- conda or mamba for shared scientific environments
- tracked `.gitconfig`, shell startup files, VS Code Server settings, and
  `/etc/wsl.conf`

Optional:

- Docker CLI
- Google Cloud CLI
- Antigravity CLI for individual/free Gemini coding workflows
- Google Drive DrvFs mount
- native rclone Google Drive mount
- NVIDIA tools
- Node/npm
- Mathematica/Wolfram Engine
- TeX

Verify:

```bash
./bootstrap/audit.sh
./cloud/docker/audit.sh
./cloud/google/audit.sh
./cloud/google-drive/audit.sh
```

## Google Drive Mount Profile

Purpose:

- expose Google Drive in Windows
- expose the Windows Google Drive mount in WSL
- expose a native WSL rclone mount for Linux tooling

Required:

- Windows Google Drive for desktop mounted at `G:\`
- WSL DrvFs view mounted at `/mnt/g`
- rclone remote configured in WSL
- native rclone mount at `$HOME/mnt/gdrive`

Verify:

```powershell
.\cloud\google-drive\audit.ps1
```

Ensure Windows mount:

```powershell
.\cloud\google-drive\mount-windows.ps1
```

```bash
./cloud/google-drive/audit.sh
```

Ensure WSL mounts:

```bash
./cloud/google-drive/mount-wsl.sh
```

## Docker Profile

Purpose:

- reproducible local and cloud-like execution
- CPU test containers
- CUDA/GPU test containers when needed
- CI-like local checks

Required when project declares Docker support:

- Docker Desktop or Docker Engine
- `docker compose`
- `.dockerignore`
- `docker/Dockerfile.cpu`
- `docker/compose.yaml`

Optional:

- `docker/Dockerfile.cuda`
- NVIDIA Container Toolkit or Docker Desktop GPU support
- notebook service profile

Verify:

```powershell
.\cloud\docker\audit.ps1
```

```bash
./cloud/docker/audit.sh
```

Future per-project verification:

```bash
docker compose -f docker/compose.yaml run --rm test
```

## Google Colab Profile

Purpose:

- clean notebook runtime
- GPU/TPU experiments
- public examples
- quick independent validation

Required when project declares Colab support:

- `tools/colab_bootstrap.py`
- `examples/colab/`
- `docs/cloud/colab.md`
- notebooks that run from a fresh runtime

Optional:

- GPU-specific notebooks
- TPU-specific notebooks

Verify:

```bash
python tools/colab_bootstrap.py --check
```

In actual Colab, the notebook should run from a fresh runtime without private
credentials or local paths.

## Google Cloud Profile

Purpose:

- longer GPU jobs
- containerized benchmark runs
- batch validation
- managed artifacts
- possible self-hosted GitHub runners

Required when project declares Google Cloud support:

- Google Cloud CLI locally
- documented project ID policy
- documented artifact bucket or registry
- container build path
- Secret Manager or Workload Identity approach for secrets

Optional:

- Artifact Registry
- Cloud Run
- Compute Engine GPU VM
- Vertex AI Workbench or custom jobs
- GCS artifact bucket

Verify:

```powershell
.\cloud\google\audit.ps1
```

```bash
./cloud/google/audit.sh
```

Antigravity CLI should be audited with the same Google tooling audit. Gemini CLI
is legacy for individual/free Gemini coding workflows after Google's 2026-06-18
cutoff. Audit existing Gemini installs, but use Antigravity CLI for new
individual/free setups unless a licensed Standard or Enterprise workflow
explicitly requires Gemini Code Assist tooling.

Future per-project verification:

```bash
python tools/cloud/check_google_cloud.py
```

## Project Repo Profile

Purpose:

- ensure each related repo has consistent AI, docs, GitHub, Python, and cloud
  setup

Required:

- README
- `AGENTS.md`
- `CLAUDE.md`
- `.github/copilot-instructions.md`
- `docs/ai/context.md`
- `docs/ai/sessions/`
- GitHub PR template and CODEOWNERS when GitHub-hosted
- project-local dependency metadata

Optional by profile:

- Docker files
- Colab bootstrap
- Google Cloud docs
- GPU workflows
- docs publishing workflows

Future verification:

```bash
projects/scripts/audit-project.sh <repo>
projects/scripts/audit-all.sh
```

## Required Status Rules

1. Every standard must have a status.
2. Every status must name the verification command or say `planned`.
3. Generated machine status stays local unless sanitized.
4. A project capability is not considered supported until it has both docs and
   an audit/check command.
5. Cross-repo writes must be check-only first, then write, then commit, then push.
