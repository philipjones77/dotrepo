# Documentation Standards

These rules define how documentation should be structured in this repository.

Use [GitHub publishing](github-publishing.md) for review, web rendering, releases, and research
methodology documentation. Use [MathML/OpenMath](math-interchange.md) for mathematical interchange.
Use [writing](writing.md) for content rules and the
[writing workflow](../guides/writing-workflow.md) for evidence-led drafting and review.

## Folder Model

- `docs/overview/`: repository orientation and layout
- `docs/reference/`: external-user reference material
- `docs/guides/`: day-to-day workflows and operator instructions
- `docs/standards/`: durable rules and conventions
- `docs/status/`: migration notes, report inventories, and current-state summaries

Executable code belongs under `src/`. Automation belongs under `src/automation/`. Examples belong
under `examples/`. Exploratory work belongs under `experiments/`. Paper-specific authored material
belongs under `papers/`.

Reusable source databases live outside `docs/`:

- `bibliography/`
- `glossaries/`
- `definitions/`
- `notation/`
- `images/` (metadata; binaries remain in the configured external store)

## Authority Order

Use this order when documents disagree:

1. Explicit project contracts or API specifications
1. `docs/standards/` documents
1. Source-area READMEs such as `bibliography/README.md`
1. `docs/guides/` workflows
1. Status notes, migration notes, TODO files, and generated reports

Status documents describe current state; they do not override standards.

## README Roles

- Root `README.md`: purpose, quick start, primary links, and source-area map
- `docs/README.md`: documentation tree overview
- Source-area `README.md`: what is in the folder, how to use it, and how to add to it
- Subfolder `README.md`: local contents, usage, and contribution rules

## Adding Documentation

- Put durable rules in `docs/standards/`.
- Put task workflows in `docs/guides/`.
- Put external-user explanations in `docs/reference/`.
- Put repository maps in `docs/overview/`.
- Put migration notes and report summaries in `docs/status/`.
- Keep source-area operational details in the source-area README when they only apply to that source
  area.

## Lifecycle

- Promote recurring status guidance into standards once it becomes policy.
- Remove or archive stale notes when a newer standard supersedes them.
- Update links in the same change that moves or renames a document.
- Keep stable document paths once external repos or templates reference them.
