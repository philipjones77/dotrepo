# Glossary And Symbol Standards

The detailed glossary workflow lives in `glossaries/README.md`. The detailed Markdown notation
workflow lives in `notation/README.md`. This standard summarizes the reusable rules for Bib2Gls
records and machine-readable symbols.

[MathML/OpenMath interchange](math-interchange.md) builds on these canonical meanings; generated
presentation or semantic exports must not become competing symbol registries.

## Canonical Glossary Files

The document workflow below consumes these records; it does not replace their canonical keys or
introduce a second local definition registry.

## Modern Glossaries-Extra Document Setup

Use `glossaries-extra` with its `record` option and Bib2Gls for shared `.bib` resources. It loads
the base `glossaries` package itself. If hyperlinks are required, load `hyperref` first. Select
abbreviation styling before resource loading. Do not mix this workflow with
`\makeglossaries`/makeindex/xindy for the same glossary. Other indexing methods remain valid
alternatives, but are not this house pipeline.

```tex
% Preamble: resource path assumes a pinned asset extraction.
\usepackage{hyperref}
\usepackage[record]{glossaries-extra}
\setabbreviationstyle{long-short}
\providecommand{\itag}[1]{#1}
\GlsXtrLoadResources[
  src={vendor/references-assets/glossaries/abbreviations},
  field-aliases={citekey=user1,sourceurl=user2}
]
```

The neutral `\itag` fallback is also supplied by `references-assets.sty`; use that helper when
already consuming asset paths. This minimal snippet loads abbreviations only. Add required concept,
symbol, or dictionary resources explicitly, including records needed by cross-references. Glossary
`.bib` files are not citation databases: do not give them to `\addbibresource`.

Use `\gls{ab:api}` in prose, `\Gls` at sentence beginnings, and `\glspl` for plurals. Configure
first-use behavior deliberately; do not repeatedly reset entries to force expansion. Inspect
headings, captions, and abstracts for unintended first use. Print selected lists with
`\printunsrtglossaries` or the appropriate typed `\printunsrtglossary`. Bib2Gls controls sorting
despite the command name. See the
[author's introductory guide](https://mirrors.ctan.org/support/bib2gls/bib2gls-begin.pdf).

## Provenance and Presentation Boundaries

Our `citekey`/`sourceurl` fields and aliases are a shared-data contract. Storing or aliasing a
citation key does not automatically print a citation. Any rendering hook must explicitly consume the
mapped field, load the corresponding bibliography, and have a regression test. Do not copy the
legacy preamble's unverified `useri`/`userii` hooks as the standard implementation.

Record definitions, abbreviations, and symbols separately. A document's glossary style, list
headings, first-use reset policy, and whether lists appear in the contents are presentation choices;
do not rewrite shared records to achieve them. Define missing document-only terms locally under
distinct keys and propose reusable terms through the glossary inbox.

## Glossary Release Checklist

- [ ] Resolve referenced concept/symbol keys and supporting citation keys against the selected
  resources.
- [ ] Check expansion, capitalization, plurals, symbol glyphs, units, sorting, and hyperlink
  targets.
- [ ] Run Bib2Gls with Java and explicit UTF-8 as specified in [compilation](compilation.md).
- [ ] Rerun Biber if rendered glossary content introduces new citations; finish LaTeX passes until
  stable.
- [ ] Check logs for missing entries and inspect the actual printed lists, not only successful exit
  codes.
- [ ] Keep generated `.glstex` files out of canonical source records; do not edit them to fix
  definitions.
- [ ] Record tested coverage; the existing abbreviation smoke test does not validate all glossary
  hooks.

## Canonical Resource List

- concepts: `glossaries/library/entries.bib`
- dictionary-backed concepts: `glossaries/library/entries_dictionary.bib`
- abbreviations and acronyms: `glossaries/library/abbreviations.bib`
- symbols: `glossaries/library/symbols.bib`
- index-only entries: `glossaries/library/index.bib`

`glossaries/library/acronyms.bib` is legacy-only. Do not add new content there.

## Markdown Notation Files

### Linked Definition, Notation, and Glossary Review

For a new or substantially revised shared symbol, review the mathematical definition and its
assumptions first. Record its symbol, meaning, scope, type/shape, mathematical role, typeface,
explicit LaTeX source, and owning macro (if any) in the notation registry. Add the exact verified
`glossary_key` there when a printable symbol record exists. The matching `sym:` record supplies
concise printable text; it must not quietly use a different glyph or redefine the object. Record an
unresolved link explicitly rather than inventing a key. Not every local proof variable needs a
global glossary entry.

Glossary concepts, abbreviations, symbols, and index records remain separate categories with the
existing canonical key prefixes and files. Retain `citekey`/`sourceurl` provenance and the declared
Bib2Gls aliases; do not add arbitrary positional `user*` meanings or load glossary records as
citation databases. Image `sourcekey` fields point to bibliography records, not glossary keys.

Run `python tools/validate_assets.py` for existing glossary/schema/citation checks and
`python tools/audit_notation.py` for the generated definition/notation/symbol-link review. Inspect
current source rows before correcting a finding. Missing rendering fields and ASCII-name collisions
require scoped review, not automatic text substitution. A successful Bib2Gls build establishes
compilation, not that a symbol's mathematical definition is correct.

Mathematical objects and assumptions belong in `definitions/library/`; the concrete shared symbol
and typeface registry is `notation/library/notation_objects.md`. Macro implementations follow the
[macro standard](latex-macros.md). Match records by meaning and scope, not merely by glyph or a
convenient source alias. These layers must agree, but a glossary export is not a replacement for the
mathematical definition.

Use `notation/library/*.md` for explanatory notation conventions and symbol families. Do not put
long notation explanations into `symbols.bib`.

When a reusable notation note introduces a symbol that should appear in glossary output, add or
update the matching `sym:` record in `glossaries/library/symbols.bib`.

## Key Prefixes

- `en:<slug>` for general glossary concepts
- `dict:<slug>` for dictionary-backed concepts
- `ab:<slug>` for abbreviations and acronyms
- `sym:<slug>` for symbols

Use ASCII, lowercase slugs for `en:`, `dict:`, and `ab:` keys. Prefer underscores for multiword
slugs.

## Field Vocabulary

Use canonical field names:

- `name`
- `description`
- `category`
- `plural`
- `short`
- `shortplural`
- `long`
- `longplural`
- `symbol`
- `unit`
- `see`
- `citekey`
- `sourceurl`

Do not introduce new `citationkey` fields. Normalize legacy `citationkey` fields to `citekey` when
touching a record.

## Description Style

`description` values should be concise definitional phrases:

- start lowercase unless the first token must be capitalized
- do not end with punctuation
- do not include citation prose
- keep references in `citekey` or `sourceurl`

## Abbreviations

Every reusable abbreviation or acronym should have a corresponding concept entry in `entries.bib`.

```bibtex
@entry{en:mle,
  name        = {maximum likelihood estimation},
  description = {estimation method based on maximizing the likelihood function},
  category    = {estimation},
  citekey     = {Pawitan2001},
}

@abbreviation{ab:mle,
  short       = {MLE},
  long        = {\itag{m}aximum \itag{l}ikelihood \itag{e}stimation},
  description = {estimation method based on maximizing the likelihood function},
  category    = {estimation},
  see         = {en:mle},
}
```

Put conceptual sources on the `en:` entry unless the abbreviation itself needs a distinct source.

## Symbols

Each symbol entry represents one semantic meaning, not merely one glyph.

```bibtex
@symbol{sym:prob,
  symbol      = {\ensuremath{\mathbb{P}}},
  name        = {probability measure},
  description = {probability measure},
  category    = {probability},
  unit        = {\ensuremath{\varnothing}},
}
```

Use `\ensuremath{...}` in `symbol=`. Prefer semantic symbol keys such as `sym:prob` or
`sym:sigma_scale` over raw TeX fragments.
