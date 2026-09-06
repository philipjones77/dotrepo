# dotrepo Usefulness Plan

This repo should become the source of truth for repeatable setup across two
Windows machines, WSL Ubuntu on both machines, and the project repos under
`C:\dev` and `/home/phili/projects`.

The current repo is a useful start, but it mostly stores live settings. The
next version should also answer four practical questions:

1. How do I rebuild a machine?
2. How do I create or repair a project repo so Codex, Claude, ChatGPT, GitHub,
   VS Code, and Python agree on the basics?
3. How do optional tools such as Mathematica, CUDA, TeX, or system libraries get
   discovered without breaking machines where they are absent?
4. How do I check drift between this repo and the real machines/projects?
5. How do I run the same work locally, in Colab, in Docker, or on Google Cloud?

## Observed Baseline

Sample project repos inspected:

- `/home/phili/projects/arbplusJAX`
- `/home/phili/projects/data77`
- `/home/phili/projects/IntegralFunctionsJAX`
- `/home/phili/projects/RandomFields77`
- `/home/phili/projects/TopoSmplJAX`

Common patterns:

- Python/JAX projects generally use `pyproject.toml`; dotrepo should not replace
  repo-local dependency metadata.
- Several repos have `.claude/settings.json`, `.claude/settings.local.json`,
  `.vscode/settings.json`, `.github/workflows`, and project `.code-workspace`
  files, but the shape is inconsistent.
- `AGENTS.md` exists in at least `arbplusJAX` and contains high-value operating
  rules for coding agents, but equivalent startup guidance is not consistently
  propagated.
- GitHub workflows are project-specific and sometimes intentionally manual-only;
  dotrepo needs templates and policy checks, not one workflow copied everywhere.
- Current Python environment files in dotrepo look like snapshots of one
  machine environment. They are too broad to be the default project bootstrap
  contract.
- Colab, Google Cloud, Docker, CUDA, and WSL container support need explicit
  project profiles instead of ad hoc setup notes.

## Target Layout

Add these top-level areas:

```text
dotrepo/
|-- agents/
|   |-- AGENTS.template.md
|   |-- claude/
|   |   |-- settings.template.json
|   |   `-- settings.local.example.json
|   |-- session/
|   |   `-- session-capsule.template.md
|   |-- web/
|   |   |-- chatgpt-project-instructions.template.md
|   |   |-- claude-project-instructions.template.md
|   |   `-- github-copilot-instructions.template.md
|   `-- chatgpt/
|       `-- repo-instructions.template.md
|-- apps/
|   |-- optional-tools.yml
|   |-- mathematica/
|   |   |-- detect.ps1
|   |   `-- detect.sh
|   `-- cuda/
|       |-- detect.ps1
|       `-- detect.sh
|-- cloud/
|   |-- colab/
|   |-- docker/
|   `-- google/
|-- projects/
|   |-- profiles/
|   |   |-- python-jax.yml
|   |   |-- docs-heavy.yml
|   |   `-- data-private.yml
|   |-- templates/
|   |   |-- pyproject.toml
|   |   |-- .editorconfig
|   |   |-- .gitignore
|   |   |-- .vscode/settings.json
|   |   |-- .github/workflows/ci.yml
|   |   `-- workspace.code-workspace
|   |-- scripts/
|   |   |-- apply-project-template.ps1
|   |   |-- apply-project-template.sh
|   |   |-- audit-project.ps1
|   |   `-- audit-project.sh
|   `-- inventory.yml
|-- machines/
|   |-- machine.example.yml
|   |-- windows.example.yml
|   `-- wsl.example.yml
`-- docs/
    |-- usefulness-plan.md
    `-- operating-model.md
```

Keep the existing `bootstrap/`, `git/`, `python/`, `vscode/`, `windows/`, and
`wsl/` folders. They remain machine bootstrap inputs. The new folders add
project setup, optional-tool detection, agent instructions, and drift checks.

## Phase 1: Make Machine Bootstrap Auditable

Goal: know whether a Windows or WSL environment matches dotrepo before changing
anything.

Deliverables:

- Add `bootstrap/audit.ps1` and `bootstrap/audit.sh`.
- Report installed versions of Git, GitHub CLI, Python, conda/mamba, Node, VS
  Code, CUDA tools, Mathematica/Wolfram Engine, TeX, and common build tools.
- Report whether expected dotfiles are symlinked, copied, missing, or locally
  changed.
- Add `machines/*.example.yml` for machine-local facts that should not be
  hard-coded in tracked scripts: host name, Windows user, WSL distro, conda root,
  GPU availability, preferred projects root, and optional tools.
- Update `bootstrap/install.*` to support `--dry-run` and `--audit`.

Acceptance check:

```powershell
.\bootstrap\audit.ps1
```

```bash
./bootstrap/audit.sh
```

Both commands should produce a readable report without modifying files.

## Phase 2: Split Global Python From Project Python

Goal: dotrepo should provide project environment patterns, not one giant frozen
machine environment.

Deliverables:

- Keep `python/windows` and `python/wsl` as global convenience environments.
- Add `projects/profiles/python-jax.yml` describing the standard JAX project
  contract: Python versions, CPU/GPU notes, editable sibling dependency policy,
  and expected commands.
- Add project template scripts that create `.venv` or conda envs from a
  repo-local `pyproject.toml`.
- Prefer repo-local installs:

```bash
python -m pip install -e ".[dev,test]"
```

or a project-specific extra set when available.

- Add a policy for sibling editable packages such as `arbplusJAX` and
  `IntegralFunctionsJAX`; this should live in project templates or generated
  workspace files, not in the global requirements snapshot.

Acceptance check:

```bash
projects/scripts/audit-project.sh /home/phili/projects/arbplusJAX
projects/scripts/audit-project.sh /home/phili/projects/IntegralFunctionsJAX
```

The audit should identify the intended Python command, test command, editable
siblings, and missing optional tools.

## Phase 3: Standardize Agent And Chat Setup

Goal: every repo should give Codex, Claude, and ChatGPT the same first-page
orientation while still allowing project-specific rules.

Deliverables:

- Add `agents/AGENTS.template.md` with these sections:
  - mandatory startup read
  - project commands
  - test strategy
  - JAX/numerics rules
  - Git and PR rules
  - optional-tool policy
- Add `.claude/settings.template.json` with conservative shared permissions and
  no machine-local secrets.
- Treat `.claude/settings.local.json` as local-only and provide
  `settings.local.example.json`.
- Add `agents/chatgpt/repo-instructions.template.md` for prompts or custom GPT
  project instructions that cannot be auto-installed.
- Add `docs/ai-session-methodology.md`, `docs/ai-github-standards.md`, and web
  project instruction templates for Claude.ai, ChatGPT, and GitHub Copilot.
- Add `projects/scripts/apply-project-template.*` modes:
  - `--check`: report missing or stale agent files
  - `--write`: create missing files
  - `--update`: update managed blocks only

Acceptance check:

```bash
projects/scripts/audit-project.sh /home/phili/projects/TopoSmplJAX
```

The audit should say whether `AGENTS.md`, Claude settings, VS Code settings, and
workspace files exist and whether they match managed templates.

## Phase 4: Add GitHub Repo Standards

Goal: make GitHub behavior predictable without forcing the same CI into every
project.

Deliverables:

- Add workflow templates:
  - lightweight PR lint/test workflow
  - manual full test workflow
  - docs validation workflow
  - optional GPU/self-hosted workflow
  - dependency audit workflow
- Add `.github/PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`, issue templates, and
  release checklist templates under `projects/templates/.github`.
- Add `projects/profiles/*.yml` knobs for which workflows a project should
  receive.
- Add an audit that reports:
  - missing branch protection assumptions
  - workflows disabled or manual-only
  - missing PR template
  - missing dependency audit
  - missing release workflow for publishable packages

Acceptance check:

```bash
projects/scripts/audit-project.sh /home/phili/projects/arbplusJAX --github
```

The report should distinguish intentional manual-only workflows from accidental
CI gaps.

## Phase 5: Make Optional Applications First-Class

Goal: projects can use tools like Mathematica when present, but repo setup does
not fail when they are absent.

Deliverables:

- Add `apps/optional-tools.yml` describing optional tools:
  - Mathematica or Wolfram Engine
  - CUDA/NVIDIA tooling
  - TeX/LaTeX
  - Git LFS
  - Graphviz
  - compiler/build toolchains
- Add Windows and WSL detection scripts per tool.
- Add project-profile declarations such as:

```yaml
optional_tools:
  mathematica:
    required_for: ["oracle-tests", "symbolic-reference"]
    env_vars: ["WOLFRAMSCRIPT"]
  cuda:
    required_for: ["gpu-tests", "benchmarks"]
```

- Teach project audits to say "available", "missing but optional", or "required
  for selected task".

Acceptance check:

```powershell
.\apps\mathematica\detect.ps1
```

```bash
./apps/mathematica/detect.sh
```

Both scripts should return structured status and a nonzero exit only when called
in a mode that requires Mathematica.

## Phase 6: Inventory And Drift Management

Goal: see all managed repos and machines from one place.

Deliverables:

- Add `projects/inventory.yml` with entries for:
  - `arbplusJAX`
  - `data77`
  - `IntegralFunctionsJAX`
  - `RandomFields77`
  - `TopoSmplJAX`
- Track repo path per platform, primary language, package profile, agent profile,
  GitHub workflow profile, optional tools, and sibling dependencies.
- Add `projects/scripts/audit-all.*` to scan every inventory entry.
- Add `projects/scripts/update-inventory.*` to discover repos under configured
  roots and suggest inventory changes.

Acceptance check:

```bash
projects/scripts/audit-all.sh
```

The report should show which repos are healthy, which are missing templates, and
which require manual decisions.

## Phase 7: Documentation That Drives Use

Goal: reduce "what do I run now?" friction.

Deliverables:

- Add `docs/operating-model.md` explaining:
  - machine bootstrap
  - project bootstrap
  - agent setup
  - optional tools
  - Docker, Colab, and Google Cloud execution
  - setup status and verification commands
  - update and audit workflow
- Add a README quickstart for:
  - new Windows machine
  - new WSL distro
  - new Python/JAX project
  - repairing an existing project
  - checking drift
- Add a short "what not to store here" section: secrets, private keys, tokens,
  large data, generated outputs, and per-machine local overrides.

Acceptance check:

Someone should be able to clone dotrepo on a fresh machine and answer these
questions from the README:

- What command checks this machine?
- What command applies machine settings?
- What command checks a project?
- What command updates a project template?
- Where do local-only secrets and paths go?
- Where is setup status recorded?

## Phase 8: Colab, Google Cloud, And Containers

Goal: make local, Colab, Docker, and Google Cloud execution explicit and
repeatable.

Deliverables:

- Add `docs/cloud-container-standards.md`.
- Add Docker templates for CPU and CUDA images.
- Add Docker Desktop / WSL integration audit scripts.
- Add Google Cloud CLI audit scripts.
- Add Colab bootstrap templates.
- Extend project profiles with Colab, Docker, Google Cloud, CPU, and GPU support
  fields.
- Add per-project checks for `.dockerignore`, `docker/`, `docs/cloud/`, and
  `tools/colab_bootstrap.py` where the profile requires them.

Acceptance check:

```bash
projects/scripts/audit-project.sh /home/phili/projects/arbplusJAX --cloud
```

The audit should report whether Docker, Colab, Google Cloud, and CUDA support
are absent, optional, configured, or broken.

## Implementation Order

1. Add audit scripts for Windows and WSL machine state.
2. Add `projects/inventory.yml` and project audit scripts.
3. Add agent templates and managed-block update logic.
4. Add optional-tool detection scripts, starting with Mathematica and CUDA.
5. Add Docker, Colab, and Google Cloud templates and audits.
6. Add project templates for VS Code, GitHub, and Python/JAX.
7. Apply templates in check-only mode to the five sample repos and review the
   diff before writing.
8. Update README quickstarts after the scripts are real.

## Non-Goals

- Do not centralize every project dependency into dotrepo. Project dependencies
  belong in each repo's `pyproject.toml`, lock file, or local environment file.
- Do not commit `.claude/settings.local.json`, secrets, private SSH keys, API
  keys, tokens, private datasets, or generated benchmark outputs.
- Do not force identical GitHub workflows into every repo. Use profiles and
  audits so differences are intentional.
- Do not make Docker, Colab, or Google Cloud mandatory for repos that only need
  local CPU workflows.
- Do not make WSL and Windows share one checkout. Keep separate platform
  checkouts because home directories, symlinks, interpreter paths, and VS Code
  state differ.
