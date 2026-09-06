# Related Repositories

This file is the human-readable starting point for the managed repo inventory.
The machine-readable inventory should later live at `projects/inventory.yml`.

## Initial Repo Set

| Repo | WSL Path | Windows Path | Role |
| --- | --- | --- | --- |
| `arbplusJAX` | `/home/phili/projects/arbplusJAX` | TBD | Precision arithmetic, special functions, matrix/operator JAX work |
| `data77` | `/home/phili/projects/data77` | TBD | Data and domain handoff repository |
| `IntegralFunctionsJAX` | `/home/phili/projects/IntegralFunctionsJAX` | TBD | Differentiable integral/special-function utilities |
| `RandomFields77` | `/home/phili/projects/RandomFields77` | TBD | Random fields, kernels, and probabilistic/numeric workflows |
| `TopoSmplJAX` | `/home/phili/projects/TopoSmplJAX` | TBD | Mesh/manifold, SMPL, geometry, and downstream domain handoff |

## Relationship Map

Known or likely relationships from the inspected project metadata:

- `TopoSmplJAX` depends on `arbplusJAX` as an editable sibling for numeric
  primitives and operator functionality.
- `IntegralFunctionsJAX` can optionally use `arbplusJAX` for high-accuracy
  special-function backends.
- `arbplusJAX` references `RandomFields77` docs and source in local AI
  permissions and appears to interact with random-field or kernel workflows.
- `data77` appears to be a data/domain handoff repo for downstream consumers.

These relationships should be verified and encoded in `projects/inventory.yml`.

## Inventory Fields To Track

Each repo entry should eventually contain:

```yaml
name:
github_remote:
paths:
  windows:
  wsl:
main_branch:
profiles:
  package:
  ai:
  github:
  docs:
optional_tools:
  - mathematica
  - cuda
  - tex
cloud:
  colab:
  docker:
  google_cloud:
sibling_dependencies:
  - name:
    mode: editable
    required_for:
commands:
  test:
  lint:
  docs:
  build:
docs:
  overview:
  standards:
  decisions:
ai_files:
  agents:
  claude:
  copilot:
```

## Drift Questions

The project audit should answer:

- Does the repo exist on this machine?
- Does it have a clean or dirty working tree?
- Does it have the standard AI files?
- Does it have GitHub Copilot instructions?
- Does it have PR template and CODEOWNERS?
- Are workflows present and intentionally enabled/manual?
- Are optional tools detected?
- Are sibling dependencies present?
- Are Docker, Colab, and Google Cloud capabilities configured when declared?
- Are test commands known and runnable?
- Does the repo have uncommitted standard-file changes that dotrepo should
  commit and push?
