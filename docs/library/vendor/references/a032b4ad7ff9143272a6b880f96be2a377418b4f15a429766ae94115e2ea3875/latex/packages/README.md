# LaTeX packages

This folder is the **canonical home** for reusable `.sty` packages.

## Contents

- `preamble.sty` — a “standard preamble” package (fonts, math, theorem tooling, listings,
  hyperlinks)
- `global_commands.sty` — shared commands/environments
- `references-assets.sty` — stable asset paths and the neutral `\itag` marker used by shared
  abbreviation records; consumers may define its styling first

## Usage patterns

### Within this repository

Examples in `examples/**` include these packages via relative paths when needed.

### In external projects

Extract the supported asset archive and add `<references-assets>/latex/packages` to your TeX input
search path. Then load:

```tex
\usepackage{preamble}
\usepackage{global_commands}
```

Set `\ReferencesAssetRoot` before loading `references-assets` when a document uses its path helpers.
Bibliography and glossary databases are always selected explicitly by the consuming project.

## Change control

Because these packages affect multiple documents, treat changes as “global”:

- Keep backwards compatibility when possible
- Add new macros in a non-breaking way
- Prefer documenting behavior changes in a short note (commit message or a small `docs/` entry)
