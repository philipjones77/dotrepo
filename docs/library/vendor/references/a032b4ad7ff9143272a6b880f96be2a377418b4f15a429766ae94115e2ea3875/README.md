# References Assets

This archive is the supported interface for repositories that consume the shared writing standards,
LaTeX packages, bibliography, glossaries, definitions, and notation. Keep the directory structure
intact when extracting or vendoring it.

## Contents

- `standards/README.md`: canonical entry point for repository-level adoption

- `standards/tooling/`: curated Python/Markdown configuration, editor and lint-driver templates;
  read `standards/tooling-assets.md` before merging into a consumer

- `standards/`: cross-repository writing, Markdown, LaTeX, bibliography, glossary, notation,
  documentation, compilation, layout, and source standards

- `latex/`: reusable packages, patterns, and build-tool guidance

- `bibliography/`: canonical BibLaTeX databases

- `glossaries/`: canonical Bib2Gls databases

- `definitions/`: reusable Markdown definitions

- `notation/`: reusable notation conventions

- `images/`: normalized image BibLaTeX metadata and source-credit links (not image binaries)

- `MANIFEST.json`: format version, source mapping, size, and SHA-256 digest for every payload file

`glossaries/acronyms.bib` is intentionally absent because it is a legacy migration source. Use
`glossaries/abbreviations.bib` for current records.

This is asset format 1, with an optional `images/` metadata namespace added in September 2026. Older
format-1 releases may omit it. External PDF, image, data, and software binaries are not included. A
local attachment field in a bibliography record does not mean the file is inside this archive.
Resolve those attachments through the owning library's configured storage, subject to access and
licensing.

Resolve image binaries as `<configured-image-root>/<imageid>` from the image record. Its `usera` is
the originating machine's attachment location, not a portable dependency. `sourcekey` identifies the
paper in the bibliography namespace; `credit`, `license`, and `rightsstatus` document known
attribution and permissions. `needs_review` records are not publication-ready figures.

In the source repository, `assets/README.md` is maintained source; `assets/current_YYYY-MM-DD.zip`
files are generated releases, not editable libraries. Extract a release into a separate vendor
directory. Do not point LaTeX at the repository's ZIP-storage directory and expect extracted
databases.

## Consumer Contract

Pin a dated archive or repository commit. Do not silently replace a vendored copy during a document
build. Preserve paths under the extraction root, which is referred to below as
`<references-assets>`.

Load citation databases explicitly:

```tex
\usepackage[backend=biber]{biblatex}
\addbibresource{<references-assets>/bibliography/mathematics.bib}
\addbibresource{<references-assets>/bibliography/statistics.bib}
```

Load glossary databases without the `.bib` suffix:

```tex
\GlsXtrLoadResources[
  src={<references-assets>/glossaries/entries},
  field-aliases={citekey=user1,sourceurl=user2},
]
\GlsXtrLoadResources[
  src={<references-assets>/glossaries/symbols},
  type=symbols,
  field-aliases={citekey=user1,sourceurl=user2},
]
```

Add `<references-assets>/latex/packages` to `TEXINPUTS`, or load a package by relative path. Read
`standards/README.md` before adopting the shared writing and technical conventions.

Load `references-assets` before using the shared abbreviations: it defines the `\itag{...}`
initial-letter marker as plain text unless the consumer has already defined a preferred style. Run
Bib2Gls with `--tex-encoding UTF-8` for UTF-8 LaTeX auxiliary files rather than relying on the
Windows locale default.

## Updating

Review `MANIFEST.json` and the repository diff before replacing a pinned asset version.
Contributions flow back through the owning repository's matching inbox and are promoted to canonical
sources only after review.

Before upgrading, apply `standards/bibliography-key-migrations.csv` to the consumer's citation
sources. Canonical bibliography records intentionally do not provide alias keys; an old key must be
replaced with the listed canonical key in `\\cite`, `\\textcite`, glossary `citekey`, and equivalent
source fields.
