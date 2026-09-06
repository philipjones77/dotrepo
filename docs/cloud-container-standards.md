# Cloud, Colab, And Container Standards

dotrepo should support local Windows, local WSL, Google Colab, Google Cloud, and
containerized development without making each project invent its own setup.

## Goals

- Make Python/JAX projects runnable on local WSL, local Windows, Colab, and
  Google Cloud.
- Use Docker for reproducible development and CI-like verification.
- Keep GPU, CUDA, and cloud-specific setup explicit.
- Avoid committing secrets, service-account keys, private datasets, or generated
  cloud outputs.
- Let each project declare whether it supports CPU-only, CUDA GPU, Colab, or
  Google Cloud execution.

## Execution Targets

### Local Windows

Use Windows for:

- VS Code local UI
- PowerShell automation
- GitHub Desktop or GitHub CLI if useful
- Docker Desktop management
- Windows-native tools

Prefer WSL for Linux-first Python/JAX development unless a project explicitly
needs Windows-native behavior.

### Local WSL

Use WSL Ubuntu as the primary Linux development target:

- Python/JAX environments
- CUDA-backed JAX when available
- local tests
- Linux shell tooling
- Docker CLI integration

WSL should be able to run the same repo commands used in CI and cloud images.

### Google Colab

Use Colab for:

- quick GPU/TPU experiments
- notebook demos
- reproducible public examples
- lightweight external validation

Each Colab-capable repo should provide:

```text
tools/colab_bootstrap.py
examples/colab/
docs/cloud/colab.md
```

The bootstrap should:

- detect Colab
- install the package from source or GitHub
- install optional extras for the notebook
- verify JAX backend and device availability
- avoid requiring private credentials

Notebooks should be able to run from a clean Colab runtime.

### Google Cloud

Use Google Cloud for:

- longer GPU jobs
- reproducible container runs
- benchmark sweeps
- batch validation
- self-hosted GitHub runners, when useful

Each cloud-capable repo should provide:

```text
docker/
  Dockerfile.cpu
  Dockerfile.cuda
  compose.yaml
docs/cloud/google-cloud.md
tools/cloud/
```

Google Cloud setup should support:

- Artifact Registry or another container registry
- Cloud Run for CPU services when appropriate
- Vertex AI Workbench or custom jobs for notebooks/training
- Compute Engine GPU VMs for direct control
- GCS buckets for non-secret artifacts
- Secret Manager for secrets

Do not commit service-account JSON keys. Prefer `gcloud auth application-default
login` locally and Workload Identity or Secret Manager in cloud workflows.

## Docker Standards

### Required Files

Container-capable repos should converge toward:

```text
.dockerignore
docker/Dockerfile.cpu
docker/Dockerfile.cuda
docker/compose.yaml
docker/README.md
```

### CPU Image

The CPU image should:

- use a slim Python base or micromamba base
- install project dependencies from `pyproject.toml`
- install the project in editable mode for development images
- run a smoke import
- run a small test command where feasible

### CUDA Image

The CUDA image should:

- start from an NVIDIA CUDA runtime or devel base compatible with the selected
  JAX CUDA package
- document the expected driver/runtime compatibility
- set JAX/XLA GPU environment variables explicitly
- run a JAX device check
- include a CPU fallback note when no GPU is available

### Compose

Use compose for local reproducibility:

- mount the repo for development
- isolate caches
- expose notebooks only when requested
- support CPU by default
- provide a GPU profile when Docker and NVIDIA runtime support it

Example profiles to standardize later:

```text
cpu
gpu
notebook
docs
test
```

## Docker On Windows And WSL

Recommended model:

- install Docker Desktop on Windows
- enable WSL integration for the Ubuntu distro
- run Linux containers from WSL for project work
- keep source repos under the WSL filesystem for Linux-heavy projects
- avoid heavy bind mounts from `/mnt/c` into Linux containers for performance

dotrepo should provide audits for:

- Docker Desktop installed
- WSL integration enabled
- `docker` available in PowerShell
- `docker` available in WSL
- `docker compose` available
- NVIDIA Container Toolkit or GPU runtime available when needed
- current user can run Docker commands

## Synchronization

The synchronization source of truth is still git.

Use:

- GitHub for code, docs, issues, PRs, and Actions
- container registries for built images
- GCS for large generated artifacts when appropriate
- ignored local folders for cache and secrets

Do not sync `.venv`, conda envs, Docker volumes, raw cloud credentials, or large
generated outputs through git.

## Project Inventory Fields

`projects/inventory.yml` should eventually support:

```yaml
cloud:
  colab:
    supported: true
    bootstrap: tools/colab_bootstrap.py
    notebooks:
      - examples/colab/demo.ipynb
  docker:
    supported: true
    cpu_image: docker/Dockerfile.cpu
    cuda_image: docker/Dockerfile.cuda
    compose: docker/compose.yaml
  google_cloud:
    supported: true
    registry:
    artifact_bucket:
    preferred_targets:
      - compute-engine-gpu
      - vertex-ai-custom-job
optional_tools:
  - docker
  - gcloud
  - cuda
```

## dotrepo Deliverables

Add to dotrepo:

- `cloud/colab/` templates
- `cloud/google/` templates
- `docker/` templates
- Windows and WSL Docker audit scripts
- Google Cloud CLI audit scripts
- Google Cloud / Gemini reset plan and install-method audit
- container build/test helper scripts
- project profile fields for CPU, GPU, Colab, Docker, and Google Cloud support

## Verification Commands

Expected future dotrepo commands:

```powershell
.\cloud\docker\audit.ps1
.\cloud\google\audit.ps1
```

```bash
./cloud/docker/audit.sh
./cloud/google/audit.sh
```

Expected future per-project commands:

```bash
docker compose -f docker/compose.yaml run --rm test
python tools/colab_bootstrap.py --check
python tools/cloud/check_google_cloud.py
```

## Non-Goals

- Do not make Docker the only way to run local development.
- Do not require Google Cloud for ordinary tests.
- Do not commit cloud secrets or service-account keys.
- Do not force GPU images on CPU-only projects.
- Do not store large datasets in dotrepo.
