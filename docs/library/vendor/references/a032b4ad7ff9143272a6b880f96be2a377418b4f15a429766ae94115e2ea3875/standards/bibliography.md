# Bibliography Standards

The authoritative detailed workflow lives in `bibliography/README.md`. This file summarizes the
repository-wide rules that operators should follow repeatedly.

## Library Routing

Document-side configuration is defined below; record identity, enrichment, attachment evidence, and
promotion remain governed by the library workflow and [validation standard](validation.md).

## Modern BibLaTeX Document Setup

Use BibLaTeX with `backend=biber`, compatible installed versions, and an explicitly chosen style.
Load language support before BibLaTeX and use `csquotes` where quotation handling is needed. Declare
resources with `\addbibresource`, then print with `\printbibliography`. Do not combine this setup
with natbib, `\bibliographystyle`, or a separate BibTeX bibliography pipeline.

```tex
% Preamble: computational.bib is supplied by the pinned asset extraction.
\usepackage[english]{babel}
\usepackage{csquotes}
\usepackage[backend=biber,style=authoryear,sorting=nyt]{biblatex}
\addbibresource{vendor/references-assets/bibliography/computational.bib}
```

Author-year is an example profile, not a universal publisher requirement. In the document use
`\textcite{Nocedal2006}` for narrative citation, `\parencite{Nocedal2006}` for parenthetical
citation, or `\autocite{Nocedal2006}` when the chosen style should decide. Supply locators through
command arguments, not manually typed author/year strings. Print the bibliography at its intended
location.

Use filters for selected lists and `refsection` only for genuinely independent bibliographies. Avoid
`\nocite{*}` in ordinary papers; reserve it for intentional catalogs. Do not edit generated `.bbl`
files. See the
[BibLaTeX manual](https://ctan.math.illinois.edu/macros/latex/contrib/biblatex/doc/biblatex.pdf).

The shared asset helper may replace the literal path above; see the integration example in
`examples/latex/assets-consumer/` in the source repository. Do not load a package twice when a
legacy preamble already owns its configuration. A publisher-mandated alternative is a documented
exception, not an obsolete workflow to convert indiscriminately.

## Bibliography Release Checklist

- [ ] Load only needed canonical resources; do not copy entries just to alter citation styling.
- [ ] Resolve identifiers, title/author conflicts, and same-work duplicates before claiming
  completeness.
- [ ] Preserve meaningful capitalization in metadata without freezing an entire title's case.
- [ ] Keep local attachments and software relationships as metadata, not prose in the printed
  reference.
- [ ] Follow [compilation](compilation.md); inspect Biber and final LaTeX logs for missing keys and
  data errors.
- [ ] Inspect rendered names, dates, titles, identifiers, sorting, and locators under the selected
  style.
- [ ] Record the actual tested tool and asset versions; successful typesetting does not verify a
  work exists.

## Library File Selection

Use the most specific curated file in `bibliography/library/`:

- `random_fields.bib`: random fields, stochastic processes, Gaussian processes, spatial and
  spatio-temporal processes, Markov random fields, random graphs, random networks, random sets,
  random domains, and related random structures
- `probability.bib`: probability theory and primarily probabilistic work
- `statistics.bib`: general statistics
- `biostatistics.bib`: biological, medical, epidemiological, or health-science work where statistics
  is supporting or central
- `computational.bib`: computational theory and practice, high-performance computing, scientific
  computing, numerical algorithms, randomized numerical linear algebra, domain decomposition,
  preconditioning, matrix computations, sketching, GPU/parallel/distributed methods, and
  performance-oriented computational methodology
- `mathematics.bib`: formal mathematical work that does not fit the higher priority random-fields,
  probability, statistics, biostatistics, or computational libraries
- `software.bib`: formal software citations, manuals, implementation papers, systems papers, package
  papers, machine-learning systems, computer-vision papers, datasets framed as software or systems,
  and repository records
- `datasets.bib`: dataset records when the dataset itself is the citation target and is not better
  treated as software
- `online.bib`: blogs, project pages, webpages, and other web-native resources without formal
  publication structure
- `adhoc.bib`: slides, presentations, orphan chapters, lecture notes, handouts, worksheets, partial
  materials, and incomplete references
- `encyclopedia.bib`: formal encyclopedia entries, normally `@inreference`
- `dictionary.bib`: formal dictionary entries, normally `@inreference`
- `general.bib`: formal non-mathematical fallback only when no more specific library applies

Do not use `general.bib` for uncertain records. Leave ambiguous material in `bibliography/inbox/`
until it can be identified confidently.

## Key Rules

- Bibkeys must be globally unique across `bibliography/library/*.bib`.
- Every work has exactly one canonical bibkey. Do not use BibLaTeX `ids` or any other alias
  mechanism.
- Formal records use first author's last name plus year, with `a`, `b`, `c`, etc. suffixes for
  same-author same-year collisions.
- Standalone software records use `<softwarename><year>`, lowercase with no underscore.
- Online records use `<relevantname>_<year>`.
- Encyclopedia and dictionary records use the source-prefix patterns already established in their
  library files.

## Key Migration

When a key is corrected, change downstream citation sources to the new key. Do not keep the old key
as an alias and do not add a duplicate bibliography record. The machine-readable
`bibliography-key-migrations.csv` file beside this standard lists every retired key and its sole
canonical replacement.

Consumers must apply the table to citation commands and glossary `citekey` fields before updating
their pinned references asset. Retired keys are deliberately absent from the canonical bibliography,
so unresolved old keys remain visible during compilation instead of silently citing through an
alias.

Some citation defects are contextual rather than simple key renames and must not be applied as
global replacements:

| Existing citation | Cited claim                                                  | Required canonical key |
| ----------------- | ------------------------------------------------------------ | ---------------------- |
| `Fuentes2005`     | Formal test for spatial nonstationarity                      | `Fuentes2005`          |
| `Fuentes2005`     | Separability of spatial--temporal covariance functions       | `Fuentes2006b`         |
| `Lu2005`          | Directional symmetry using the periodogram                   | `Lu2005`               |
| `Lu2005`          | Directional sample variograms with a chi-square limit        | `Lu2001`               |
| `Loh2000`         | Smooth Gaussian random field structured correlation matrices | `Loh2000`              |

The unconditional migration table separately maps `VanHala2024` to `Eckle2026`,
`GelfandVilenkin1964Gen` to `GelfandVilenkin1964`, and every other retired spelling to its canonical
key.

## Metadata Rules

- Do not keep duplicate entries for the same work in multiple library files.
- Enrich new or pasted records before considering them complete.
- Add stable metadata when available: DOI, arXiv ID, ISBN, canonical URL, publisher, venue,
  institution, report number, project page, and `urldate`.
- Prefer canonical landing-page URLs over transient download URLs.
- Use `@software` for standalone software records; avoid `@misc` in `software.bib`.

## ISBN And ISSN Storage

For the default BibLaTeX/Biber model, store one identifier in each `isbn` or `issn` field, not a
comma-separated collection. The
[official BibLaTeX manual](https://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf)
defines these as scalar literal fields and provides the custom verbatim fields `verba`, `verbb`, and
`verbc`. Do not redefine the standard identifier fields as lists: that would require a custom model
and compatible styles in every downstream consumer.

This repository reserves `verba` for `isbn-alternates=...` and `verbb` for `issn-alternates=...`.
These labels are repository conventions, not built-in ISBN/ISSN semantics. Retain all additional
identifier spellings in their original order, separated by commas. Standard bibliography styles do
not print these custom verbatim fields; they remain available in exported data. Keep `usera` through
`userf` for attachments and software references.

```bibtex
isbn = {9783662473238},
verba = {isbn-alternates=9783662473245},
issn = {0162-8828},
verbb = {issn-alternates=1939-3539},
```

For mechanical migration, retain the first legacy identifier in the scalar field. This preserves
ordering; it does not verify a primary, print, electronic, or current edition. Selecting the
identifier for a specifically cited edition requires source evidence. Check every token's checksum,
preserve recovery copies and a per-record change report, and block conflicting use of the reserved
fields. If no scalar identifier can be justified for a newly curated record, retain candidates as
unreviewed metadata until identity is resolved; do not guess. Never discard alternatives merely to
clear a validation warning.

## Attachments And Bundles

- Local attachments use `usera`, `userb`, `userc`, etc. with labels such as `filename=`,
  `software=`, `supplement=`, and `appendix=`.
- Image and figure assets found in `bibliography/inbox/` should be moved to `images/inbox/` during
  regular cleanup; citation inboxes should not retain standalone image assets.
- `bibliography/inbox/` may have only one storage subfolder: `bibliography/inbox/files/`.
- Do not create or keep duplicate inbox storage folders such as `files_2`, `files_3`, or
  `files (1)`.
- Single-file attachments can be stored as files.
- Multi-file supplements or primary documents should remain folders.
- Software folders attached to a record should normally be named `<bibkey>_software`.
- Archives in `bibliography/inbox/` should be extracted during processing and flattened to the first
  folder that contains real project content.

## Standard Scripts

Prefer these workflows over ad hoc file moves:

```powershell
python src/automation/biblatex/pdf_inbox_ingest.py --include-abstract
python src/automation/biblatex/pdf_inbox_ingest.py --include-abstract --apply
powershell -ExecutionPolicy Bypass -File src/automation/biblatex/run_pdf_inbox_ingest.ps1 -Apply
python src/automation/biblatex/reconcile_document_library.py
```

Use targeted enrichment and validation scripts from `src/automation/biblatex/` when cleaning
individual `.bib` files.
