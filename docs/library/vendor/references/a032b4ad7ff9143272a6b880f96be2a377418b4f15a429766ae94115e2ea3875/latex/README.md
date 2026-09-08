# LaTeX toolkit

Start with the [canonical LaTeX standard](../docs/standards/latex.md) and
[compilation workflows](../docs/standards/compilation.md). The broad preamble is a legacy
KOMA-oriented profile; the lightweight asset consumer is the tested integration example. See the
[review and follow-up queue](../docs/status/latex-review-2026-09-05.md).

This folder contains reusable LaTeX building blocks:

- **Packages** (`latex/packages/`) — global preamble(s) and macros
- **Patterns** (`latex/patterns/`) — small focused snippets for common tasks
- **Tooling** (`latex/tooling/`) — helpers for building (latexmk, Makefiles, etc.)

Document templates and starter projects live under `examples/`.

## Packages

### `latex/packages/preamble.sty`

A general-purpose preamble package designed to centralize:

- font selection (LuaLaTeX-aware)
- core mathematical packages
- theorem tooling
- listings and algorithm environments
- hyperlink and color setup

### `latex/packages/global_commands.sty`

A shared list/environment pack with inline lists and typed `zref-clever` references.

### `latex/packages/references-assets.sty`

Path helpers for a structured asset archive. Define `\ReferencesAssetRoot` before loading it, then
use the bibliography and glossary path helpers in the project's own resource declarations.

## Recommended usage

If you are compiling inside this repo's examples, prefer **relative paths**:

```tex
\usepackage{../../../latex/packages/preamble}
\usepackage{../../../latex/packages/global_commands}
```

For external projects, extract the supported asset archive and add
`<references-assets>/latex/packages` to TeX's input path (for example through `TEXINPUTS` or
`latexmkrc`), then:

```tex
\usepackage{preamble}
\usepackage{global_commands}
```

Shared packages do not load bibliography or glossary databases automatically. Each project must
select its resources explicitly from the asset archive.

## Examples

Examples are grouped under `examples/`:

- `examples/latex/` for general LaTeX examples and document skeletons
- `examples/university-of-arizona/` for UA-specific themes and thesis or dissertation examples

Each example folder should contain source files, a minimal README, and only intentional preview
outputs. Build artifacts such as `*.aux` and `*.log` should not be committed.
