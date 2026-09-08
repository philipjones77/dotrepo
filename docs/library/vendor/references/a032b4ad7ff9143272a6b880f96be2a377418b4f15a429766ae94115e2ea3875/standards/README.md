# Repository Standards

**This is the canonical entry point for repository-level standards maintained by the references
repository.** Point people and coding agents here when asking them to apply our standards. The
linked specialist documents define the rules; dated reports describe observed results, not
alternative policies.

## Required Baseline

Apply the standards relevant to the repository's contents; a Python project does not need a LaTeX
toolchain merely to adopt these rules.

| Area                   | Required baseline                                                                  | Authority                                                                                      |
| ---------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Python code            | Naming, public interfaces, docstrings, tests and safe automation                   | [Python](python.md)                                                                            |
| Python analysis        | Pylance in VS Code; pinned Pyright CLI; `standard` checking, not globally disabled | [Analysis](python-analysis.md)                                                                 |
| Python lint and format | Ruff owns lint, formatting and import organization                                 | [Toolchain](tooling.md)                                                                        |
| Markdown               | mdformat formats; PyMarkdown lints; check local links                              | [Toolchain](tooling.md), [Markdown](markdown.md)                                               |
| Scientific/JAX code    | Explicit numerical contracts and transformation/runtime tests                      | [JAX](jax.md)                                                                                  |
| Research prose         | The shared writing handbook, with venue-specific overrides                         | [Writing](writing.md)                                                                          |
| LaTeX and notation     | Explicit math environments, semantic macros and shared symbol definitions          | [LaTeX](latex.md), [macros](latex-macros.md), [glossaries](glossary-and-notation.md)           |
| References and assets  | Verified identity, provenance, attachment relationships and deduplication          | [Bibliography](bibliography.md), [images](images.md)                                           |
| Structure and evidence | Clear ownership, generated/source separation and honest validation claims          | [Layout](repository-layout.md), [documentation](documentation.md), [validation](validation.md) |

## Adoption and Precedence

In a consuming repository, put a short adoption statement in its root README and agent instructions.
Record the exact references commit or dated asset release, the imported manifest digest when using
assets, applicable standards, local tool configuration paths, validation commands, and any
exceptions. For example:

> This repository follows the references Repository Standards at `docs/standards/README.md` in
> references revision `<commit-or-release>`. Our pinned local copy is
> `<local-path>/standards/README.md`. Local scope, validation commands and justified exceptions are
> in `<project-policy-file>`.

Replace placeholders with real values. A link to a changing branch is useful for discovery but is
not a reproducible standards version. Do not require access to someone else's `C:\dev` directory.
Asset consumers read their pinned `standards/` copy; source consumers use this directory. Follow the
established explicit asset refresh workflow rather than downloading new policy automatically during
builds.

Binding publisher, institutional, security and platform requirements take precedence within their
scope. Next apply documented, justified project-specific exceptions, then the applicable shared
standards. An exception records its scope, reason, owner and review trigger; personal editor
preferences and historical notes are not implicit overrides. Do not copy an entire handbook into
local rules.

Keep one authoritative configuration per tool. Adapt source roots, dependencies and genuine
generated/vendor exclusions to the receiving repository; do not copy this library's path exclusions
blindly. Record unsupported or deferred checks explicitly. Adoption is a policy decision, not
evidence that a repository passes.

Propose reusable corrections upstream with rationale and validation evidence; keep unaccepted local
changes identified as overrides. Updating this standards source does not automatically migrate
consumer repositories or publish an asset.

See [validation and evidence](validation.md) for the shared rules on structural, identity,
attachment, and workflow-completion claims.

This folder contains durable rules that should be followed repeatedly in this repository and reused
by external repositories when appropriate.

## Contents

- [Packaged tooling templates](tooling-assets.md): portable lint, editor and analysis configuration

- [Pylance and Pyright](python-analysis.md): shared analysis policy and staged enforcement

- [MathML and OpenMath](math-interchange.md): web notation, semantic exchange, provenance, and
  validation

- [GitHub publishing](github-publishing.md): renderer-specific math, release workflow, and research
  documentation

- [Toolchain](tooling.md): Python/Markdown tools, configurations, commands, and exclusions

- [Python](python.md): naming, headers, docstrings, API design, safety, and testing

- [JAX](jax.md): pure kernels, PRNG keys, shapes, dtypes, transformations, and benchmarking

- `bibliography.md`: citation routing, key, metadata, attachment, and processing rules

- `bibliography-key-migrations.csv`: machine-readable retired-to-canonical bibkey replacements for
  downstream source updates

- [Research Writing Handbook](writing.md): complete writing rules, workflow, editing examples,
  reusable prompt, publication/thesis review, and the scoped Philip Jones thesis writing profile

- `glossary-and-notation.md`: Bib2Gls glossary records and machine-readable symbol records

- `images.md`: image storage, topic/type classification, provenance, and deduplication rules

- `repository-layout.md`: root folders, source areas, generated output, and naming rules

- `documentation.md`: documentation placement, authority, and lifecycle rules

- `markdown.md`: Markdown style, links, code blocks, and generated report rules

- `latex.md`: reusable LaTeX package, pattern, and example conventions

- [LaTeX macros](latex-macros.md): semantic names, command interfaces, symbols, spacing, and tests

- `compilation.md`: LaTeX, BibLaTeX, Bib2Gls, and Markdown build workflows

- `source-code.md`: source tree placement, automation layout, and script rules

## How To Use This Folder

Use standards to answer policy questions. Use source-area READMEs for detailed local workflows, such
as the full bibliography or glossary rules.

## How To Add To This Folder

Add a standard only when the rule is durable and reusable. A standard should state scope, rules,
examples when useful, and the more detailed README or guide that operators should consult.

When a standard conflicts with an older README or ad hoc note, prefer the standard unless a
project-specific document states a deliberate narrower exception.

Published copies of these files are distributed in the `standards/` directory of the supported asset
archive.
