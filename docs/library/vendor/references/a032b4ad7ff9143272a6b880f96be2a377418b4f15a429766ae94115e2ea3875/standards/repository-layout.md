# Repository Layout Standards

This repository follows a focused root-folder model with only the folders that are actively useful
for the current repository.

## Standard Root Folders

- `docs/`: documentation authority and explanation
- `src/`: executable implementation and automation
- `examples/`: runnable demos, templates, and user-facing starter projects
- `experiments/`: exploratory work, normally one subfolder per experiment
- `papers/`: paper-specific manuscripts, appendices, and authored paper bundles
- `tools/`: third-party or repository-support tooling
- `resources/`: static manuals, reference assets, and vendored reference distributions that are not
  active source databases
- `assets/`: the consumer contract plus generated structured asset zips for sharing across
  repositories
- `_bundles/`: generated source bundle zips; do not put hand-authored files here

Repository-specific source-of-truth folders may add to this model. In this repo, those include:

- `bibliography/`: curated BibLaTeX libraries, inboxes, and status reports
- `glossaries/`: glossary, abbreviation, symbol, and index libraries, inboxes, and status reports
- `definitions/`: Markdown definition libraries, inboxes, and status reports
- `notation/`: Markdown notation libraries, inboxes, and status reports
- `images/`: image and figure metadata libraries, inboxes, and status reports; processed binary
  files live in the external OneDrive image store
- `latex/`: reusable LaTeX packages, patterns, and tooling

## Examples

Use `examples/` for runnable or copyable material intended to show usage.

Rules:

- examples should be user-facing or reusable
- example-local `_input/`, `_output/`, and notebook checkpoint folders are local artifacts and
  should not be committed
- templates and starter projects belong here, not under `latex/templates/`
- institution-specific examples should be grouped under a named subfolder, such as
  `examples/university-of-arizona/`

## Experiments

Use `experiments/` for exploratory work.

Rules:

- use one subfolder per experiment
- each durable experiment should have a short `README.md`
- local outputs belong in `_output/`, `output/`, or another clearly named artifact folder
- generated experiment artifacts must stay ignored unless explicitly promoted as maintained examples
  or documentation
- promote durable methods, results, or standards out of experiments once they become maintained
  project behavior

## Generated Outputs

Generated output should be easy to delete and regenerate.

Rules:

- bibliography status reports and generated enrichment `.bib` files belong under
  `bibliography/status/` only when they are machine working outputs
- durable bibliography audit and status summaries belong under `docs/status/bibliography/`
- durable glossary audit and status summaries belong under `docs/status/glossaries/`
- glossary generated build output belongs under `glossaries/status/`
- definition status reports and generated drafts belong under `definitions/status/` when they are
  machine working outputs
- notation status reports and generated drafts belong under `notation/status/` when they are machine
  working outputs
- example, experiment, and paper run outputs belong in ignored local artifact folders such as
  `output/`, `outputs/`, `results/`, `_output/`, or `generated/`
- clean stale generated output before creating source bundles or GitHub pull requests

## Papers

Use `papers/` only for authored paper material maintained directly by the repo.

Rules:

- use one subfolder per paper
- keep manuscript source and paper-specific figures together
- do not use `papers/` as a general PDF dump
- unprocessed reference PDFs still belong in `bibliography/inbox/`
- curated citation metadata still belongs in `bibliography/library/`

## Naming

- prefer lowercase hyphenated folder names
- avoid spaces in new paths
- keep root folders focused; do not create generic dumping grounds
- source bundles use `_bundles/<repo>_source_YYYY-MM-DD.zip`
- current structured assets use `assets/current_YYYY-MM-DD.zip`
