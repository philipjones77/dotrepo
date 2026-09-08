# Compilation Standards

This file defines standard build workflows for LaTeX, BibLaTeX, Bib2Gls, and Markdown-oriented
documentation across this repository family.

## General Rules

- Prefer reproducible scripted builds over manual one-off commands.
- Keep source files and generated files separate where practical.
- Do not commit transient build artifacts.
- Commit generated outputs only when they are intentional deliverables, previews, or reports that
  cannot be easily reproduced by downstream users.
- When documenting a build, include the working directory, command, engine, and expected primary
  output.
- Run the sequences below from the folder containing `main.tex`; use
  `-interaction=nonstopmode -halt-on-error -file-line-error` for unattended LaTeX runs. Check
  process exit codes and the final log: warnings do not necessarily cause a nonzero exit.
- Do not enable unrestricted shell escape by default. Imported `.tex`, `.sty`, classes, and
  `latexmkrc` files are executable inputs; review them before a trusted build.
- Record TeX distribution, engine, Biber, Bib2Gls/Java versions, fonts, and asset revision. Keep
  generated output in a known build directory when its resource search paths are tested.

## LaTeX Engine

Use LuaLaTeX by default for repository examples and templates unless a specific example explicitly
requires another engine.

Standard manual build without bibliography or glossaries:

```powershell
lualatex main.tex
lualatex main.tex
```

Run the second pass when cross-references, table of contents entries, labels, or page references are
present.

## BibLaTeX And Biber

Use BibLaTeX with Biber for citation bibliographies.

Standard build:

```powershell
lualatex main.tex
biber main
lualatex main.tex
lualatex main.tex
```

Rules:

- Run `biber` after the first LaTeX pass.
- Use the job name without `.tex` when calling `biber`.
- Treat unresolved citation warnings as build failures for curated examples, templates, and
  release-ready documents.
- Prefer `\addbibresource{...}` paths that are stable relative to the document or provided by the
  project build configuration.

## Glossaries With Bib2Gls

Use Bib2Gls for glossary, abbreviation, symbol, and index resources.

Standard build:

```powershell
lualatex main.tex
bib2gls --tex-encoding UTF-8 main
lualatex main.tex
lualatex main.tex
```

When a document uses both BibLaTeX and Bib2Gls:

```powershell
lualatex main.tex
biber main
bib2gls --tex-encoding UTF-8 main
lualatex main.tex
lualatex main.tex
```

Rules:

- Use `field-aliases={citekey=user1,sourceurl=user2}` when loading shared glossary resources.
- Bib2Gls requires Java. Use explicit UTF-8 decoding for shared records, especially on Windows.
- If generated glossary content introduces citations, run Biber again after LaTeX has read that
  content, then rerun LaTeX until citations and cross-references stabilize.
- Treat missing glossary entries as source errors, not as cosmetic warnings.
- Do not commit Bib2Gls scratch files unless a specific example or template documents them as
  intended outputs.

## Latexmk

Use `latexmk` when a project has a stable `.latexmkrc` or equivalent wrapper.

Recommended command:

```powershell
latexmk -lualatex main.tex
```

If the document uses Biber or Bib2Gls, the project-specific `latexmk` configuration must include
those steps. Do not assume bare `latexmk -pdf` is enough.

The historical report example's empty `.latexmkrc` is not such a wrapper. The maintained lightweight
consumer check is
`python tools/smoke_assets.py --archive <asset-zip> --report-dir <report-directory>` from the
repository root; its reported scope is asset paths, shared lists, one citation, and one
abbreviation, not every template or glossary hook.

## Markdown Documentation

Markdown files do not require compilation by default. When a repo renders Markdown into HTML, PDF,
or a docs site, document the renderer and command in the local project README or `docs/guides/`.

Rules:

- Keep Markdown source readable without the renderer.
- Use relative links for repository-local documents.
- Verify links after moving docs.
- Do not commit generated site output unless the project intentionally publishes generated docs from
  the repository.

## Generated Artifacts To Exclude

Do not commit routine LaTeX build artifacts:

- `*.aux`
- `*.bbl`
- `*.bcf`
- `*.blg`
- `*.fdb_latexmk`
- `*.fls`
- `*.glg`
- `*.glo`
- `*.gls`
- `*.ist`
- `*.log`
- `*.out`
- `*.run.xml`
- `*.synctex*`
- `*.toc`

Generated PDFs may be committed only when they are deliberate previews, deliverables, or archived
reference outputs.
