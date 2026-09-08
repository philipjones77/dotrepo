# Source Code Standards

These rules define where executable repository code belongs.

See [Python conventions](python.md), [JAX conventions](jax.md), and the
[lint/format toolchain](tooling.md) for naming, documentation, and enforced checks.

## Root Rule

Put code that performs real work under `src/`.

Do not create new root-level `scripts/` or `automation/` folders. Those names are too easy to turn
into catch-all dumping grounds and make it harder to distinguish code from data, documentation,
resources, and generated output.

Document templates and examples are not source code for this repository. Put them under `examples/`.

## Current Layout

- `src/automation/`: repository maintenance workflows and command wrappers
- `src/automation/biblatex/`: bibliography ingest, enrichment, normalization, validation, and
  document-library reconciliation tools

## Placement Rules

- Put reusable Python modules beside the workflow that owns them unless they are shared across
  multiple automation families.
- Put command wrappers close to the scripts they execute.
- Keep the current cross-workflow regression suite under `tools/tests/`. Workflow-specific suites
  may live under `src/<area>/tests/` when their runner and dependencies are documented and included
  in CI.
- Keep generated caches such as `__pycache__/` out of the repository.
- Prefer explicit workflow names over generic names such as `misc.py` or `helper.py`.

## Path Rules

Scripts under `src/automation/<workflow>/` should resolve repository-root paths relative to their
file location, not the caller's current directory.

For scripts in `src/automation/biblatex/`, the repository root is three levels above the script
directory:

```python
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[2]
```

Wrappers should accept explicit path arguments when practical, while keeping repo-root defaults
useful for normal operator runs.
