# LaTeX Standards

This is the canonical house standard for new documents and substantially revised templates. Use
[writing](writing.md) for prose, [glossary and notation](glossary-and-notation.md) for symbol
meaning, and [compilation](compilation.md) for build commands. Do not duplicate these policies in
template folders. Publisher and institutional requirements take precedence through a documented
project-specific override.

## Scope and Adoption

Prefer a small, explicit preamble that loads only what the document needs. The existing
`latex/packages/preamble.sty` is a legacy, broad KOMA-oriented profile, not a universally compatible
baseline. The tested lightweight `examples/latex/assets-consumer/` does not load that preamble.
Current compatibility findings are recorded in `docs/status/latex-review-2026-09-05.md` in the
source repository. Inclusion in an asset archive does not establish compatibility with every class
or engine.

The user-supplied [Patrick Emonts article](https://patrickemonts.com/post/latex_best_practice/)
(updated 2024-12-03; reviewed 2026-09-05) informs source readability and semantic markup. Treat it
as author guidance, not a package specification. Further references should be reconciled with
package manuals and the project's class requirements.

## Package Locations

- shared packages and macros: `latex/packages/`
- project examples and templates: `examples/`
- focused snippets and examples: `latex/patterns/`
- build helper files: `latex/tooling/`

## Shared Packages

Current shared packages include:

- `latex/packages/preamble.sty`
- `latex/packages/global_commands.sty`
- `latex/packages/references-assets.sty`

Treat files under `latex/packages/` as reusable interfaces. Avoid local, project-specific
assumptions unless the package name and README make that scope clear.

The path helper package does not select databases or citation styles for a project. The global
commands package currently provides list utilities and typed references, not a complete mathematical
notation registry. Do not assume a macro exists without checking its definition.

## Template Rules

- Keep one folder per template.
- Template folders should contain source files and a minimal README.
- Do not commit LaTeX build artifacts such as `*.aux`, `*.bbl`, `*.bcf`, `*.blg`, `*.log`, `*.out`,
  `*.run.xml`, or `*.synctex*`.
- Prefer relative package paths inside examples that live in this repository.
- Use LuaLaTeX by default unless a template documents a different required engine.
- Document required bibliography and glossary build steps in the template README.
- Keep University of Arizona-specific templates under `examples/university-of-arizona/`.
- State the entry point, working directory, engine, fonts, dependencies, resource paths, build
  command, output, and actually tested scope. A saved PDF alone does not establish a current
  successful build.
- Choose the publisher/institution class first; otherwise select `article`/`report`/`book` or the
  corresponding KOMA class according to document needs.
- Use `main.tex` as the default entry point. Separate content, local macros, figure sources/exports,
  and generated output. Use `\input` for logical sections and `\include` for chapter-sized units
  when its page breaks and separate auxiliary files are appropriate; do not fragment short
  documents.
- Use lowercase ASCII filenames with hyphens for new files. Preserve established public filenames.

## Source Style, Names, and Headers

The [macro standard](latex-macros.md) defines command ownership, modern definition interfaces,
symbol semantics, math-atom spacing, and compatibility testing. It is authoritative for new macros.

Use UTF-8, LF, and two-space environment indentation. Prefer a new source line for each prose
sentence; split long sentences at clause boundaries near 100 columns when useful. Do not reflow
unrelated sentences during an edit. This semantic-line convention is for TeX prose, not Markdown's
formatter. Separate paragraphs with blank lines, not `\\`. Avoid manual spacing and negative
`\vspace` to conceal layout defects. Use semantic headings rather than manually styled text.

Start local setup/macro files with a short purpose/dependency comment. Package files use
`\NeedsTeXFormat`, `\ProvidesPackage` with a meaningful version/date, `\RequirePackage` for
dependencies, and `\endinput`. Preserve license notices. Avoid decorative banners and commented-out
inventories of unused configurations; Git preserves history.

Use descriptive semantic macro names composed of letters, such as `\PrecisionMatrix`, not one-letter
global shortcuts or digits/underscores in ordinary control-sequence names. Define new commands
explicitly; do not silently redefine established symbols. Use `\providecommand` only for an
intentional, documented overridable fallback. Use LaTeX's document-command interfaces for complex
optional signatures.

Use unique labels with semantic slugs, never page or equation numbers:

| Object                              | Prefix                    | Example                     |
| ----------------------------------- | ------------------------- | --------------------------- |
| Chapter / section                   | `ch:` / `sec:`            | `sec:posterior-computation` |
| Figure / table                      | `fig:` / `tab:`           | `fig:graph-recovery`        |
| Equation                            | `eq:`                     | `eq:conditional-density`    |
| Theorem / lemma / proposition       | `thm:` / `lem:` / `prop:` | `thm:consistency`           |
| Definition / assumption / corollary | `def:` / `ass:` / `cor:`  | `ass:positive-definite`     |
| Algorithm / appendix                | `alg:` / `app:`           | `alg:gibbs-sampler`         |

Document labels are separate from bibliography keys and `en:`, `ab:`, `sym:` glossary keys. Put
figure/table labels after captions, section labels after headings, and equation labels inside
numbered environments. Use reference commands rather than hard-coded numbers. Keep one typed
cross-reference system per project: the house default is `zref` with `zref-clever`, already used by
the shared commands. Publisher requirements may justify a documented override. Do not load
`cleveref` alongside it by habit.

### Cross-References: zref and zref-clever

For new documents, load `hyperref` and then `zref-clever` once in the preamble; the latter loads the
zref support it needs. Keep its default `labelhook` enabled and use ordinary `\label` for numbered
objects. The hook also records zref data. This is the package author's recommended approach and
preserves compatibility with ordinary references. Use `\zlabel` directly only for special
requirements; it does not by itself create an ordinary `\label`.

```latex
\usepackage{hyperref}
\usepackage{zref-clever}
\begin{document}
The squared distance is
\begin{equation}
  d^2 = (x-y)^2. \label{eq:distance}
\end{equation}
\zcref[S]{eq:distance} defines the squared distance.
We use \zcref{eq:distance} below.
\end{document}
```

Use `\zcref{key}` for a typed reference and comma-separated keys for multiple objects, such as
`\zcref{eq:sum,eq:difference}`. Use `[S]` at sentence starts: it capitalizes and avoids abbreviating
the first type name. `[cap]` only controls capitalization and is not the full sentence-start option.
Do not prepend `Equation` or `Figure` when the command supplies the name. Reserve `\zref` for
deliberately untyped references, not as an interchangeable spelling of `\zcref`.

Place labels after captions/headings, or on the relevant numbered equation/align row. Do not label
unnumbered starred displays or issue both `\label` and `\zlabel` for the same key when the hook is
enabled. Configure custom theorem/counter types centrally and test their displayed names and
hyperlink targets. Rebuild until reference warnings clear and inspect the resulting PDF. See the
[maintainer's manual](https://github.com/gusbrs/zref-clever/blob/main/zref-clever-doc.tex) and the
executable [mathematics example](../../examples/latex/math-standard/README.md).

### Main `.tex` File Header

Use a short purpose header, optional editor hints, then the document setup in a predictable order.
Do not add decorative banners, manually maintained revision histories, machine-specific absolute
paths, or automatic last-edited dates. Preserve required copyright/license notices. Record
collaborators and change history in the project's normal authorship/version-control mechanisms.

```tex
% !TeX program = lualatex
% Purpose: Main entry point for the graph-estimation report.
% Build: See README.md for the complete engine, bibliography, and glossary recipe.
% Dependencies: See README.md for TeX distribution, fonts, and shared asset revision.

\documentclass{article}

% Packages and project configuration
\usepackage{mathtools}

% Document metadata
\title{Graph Estimation}
\author{Author Name}
\date{2026-09-05}

\begin{document}
\maketitle

\section{Introduction}
\label{sec:introduction}
The parameter \(x\) is real-valued.

\end{document}
```

This is a minimal header/structure example, not a universal package list. Substitute real metadata.
Use an explicit release date or `\date{}` if none is wanted; reserve `\today` for intentionally
date-varying drafts. A `% !TeX program` line is an editor hint, not an executable build recipe and
does not run Biber or Bib2Gls. README/build configuration remains authoritative. Include encoding
hints only when an editor needs them; files must still actually be UTF-8.

Where tagging/metadata support is configured, `\DocumentMetadata{...}` goes before `\documentclass`.
Then organize the preamble as engine/language/fonts, mathematical and other feature packages,
project configuration/macros, explicit bibliography/glossary resources, and document metadata,
respecting package-specific ordering constraints. Do not repeat settings already owned by a class or
shared package.

### Included Sections and Local Macro Files

An included section is not a second standalone document. For `sections/methods.tex`:

```tex
% !TeX root = ../main.tex
% Purpose: Model assumptions and estimation procedure.

\section{Methods}
\label{sec:methods}
Assume \(x > 0\).
```

The root hint is relative to this file and must match its actual location. Do not put another
`\documentclass`, preamble, or document environment in an ordinary included section. State any
unusual parent-provided macros briefly; do not duplicate the entire dependency inventory.

A local `macros.tex` needs a purpose comment and any important dependency assumptions, followed by
its definitions. Package-level declarations such as `\ProvidesPackage` belong in `.sty` files, not
normal `.tex` content. Keep semantic macros separate from journal-specific layout overrides where
practical.

## Packages, Fonts, and Compatibility

LuaLaTeX is the default; required pdfLaTeX or XeLaTeX workflows need separately tested engine
profiles. For LuaLaTeX use `fontspec` and, where Unicode mathematics is needed, `unicode-math` with
an available, documented font pair. Do not mix Unicode font setup with legacy encodings without a
supported reason. Exact fonts and page geometry remain project/class choices.

Use `mathtools`/`amsmath` for structured mathematics, `graphicx` for figures, `booktabs` for
ordinary data tables, and `siunitx` for quantities where needed. Choose one compatible theorem stack
and one subfigure stack; do not load both `subfig` and `subcaption` in the same baseline. This is
not a mandate to load every listed package.

Follow package manuals and class restrictions for load order. Configure language and quotation
handling deliberately. Load hyperlink support near the end except where documented ordering differs.
Do not redefine class internals or undefine commands to conceal option/name collisions. Keep layout,
citation style, and glossary presentation out of generic path helpers.

Shared package changes require minimal compile examples for affected classes/interfaces. Preserve
compatibility or document migration. Do not copy shared packages into projects and allow unrecorded
divergence; local variants must be deliberate, identified forks.

## Mathematics and Scientific Notation

### Authority and House Style

LaTeX defines commands and package behavior; it does not prescribe one universal notation for all
mathematics. The [AMS user guide](https://www.latex-project.org/help/documentation/amsldoc.pdf)
governs AMS environments, while [mathtools](https://ctan.org/pkg/mathtools), the selected math-font
package, and [siunitx](https://ctan.org/pkg/siunitx) govern their own interfaces. Use the manuals
matching the installed versions. A manual's older publication date alone does not make its stable
syntax obsolete. Blog/wiki recipes are supplementary, not authorities over package behavior.

Our delimiter spelling, indentation, naming, and default engine are house choices. Mathematical
meaning belongs to the notation registry and the discipline; publisher requirements are explicit
overrides. Do not call a preference an official LaTeX requirement. A successful compile establishes
syntax compatibility, not mathematical truth, good layout, or accessible mathematical semantics.

### Default Mathematics Source

Use `\(...\)` for inline mathematics. For displayed mathematics, the house standard is explicit
`\begin{...}` / `\end{...}` syntax: `equation` for a numbered display, `equation*` for an unnumbered
display, and appropriate named AMS environments for multiline structures. The spelling is
`equation`. Load `mathtools` (which loads `amsmath`) unless the class already supplies the required
facilities.

Do not use `\[...\]`, `$$...$$`, `displaymath`, or shorthand environment aliases in new house-style
display source. `\[...\]` is valid LaTeX, but explicit environments are our consistency preference,
not a claim of superior rendered output. Avoid `eqnarray`. Preserve third-party sources; migrate
existing documents deliberately rather than replacing delimiters blindly.

Define operators with `\DeclareMathOperator` (or its starred form where limits are appropriate). Use
`\text{...}` for words in mathematics and semantic delimiter commands for recurring expressions.
Choose delimiter sizes deliberately rather than applying `\left`/`\right` indiscriminately. State
scalar/vector/matrix conventions, domains, dimensions, and probability notation by referencing the
canonical notation records. Do not invent a separate notation convention in a template.

Number equations that need references. Automatic reference-only numbering requires testing with the
chosen cross-reference stack. Punctuate displays as parts of sentences. Preserve searchable
text/math instead of using screenshots of equations.

### Inline Mathematics

Use `\( ... \)` for short expressions within a sentence, including individual mathematical
variables. Keep one logical expression in one pair of delimiters. Put surrounding sentence
punctuation outside the inline math; keep mathematical punctuation, such as a tuple's comma, inside.

```tex
For \(x > 0\), define \(g(x) = \log x\).
The coefficient \(a_i\) belongs to the \(i\)th observation.
```

Use ordinary text for prose, `\text{...}` for words inside a mathematical expression, upright
semantic operators such as `\log`, and the notation registry's conventions for descriptive
subscripts. Use a units package for measurements rather than treating unit names as multiplied
variables.

Prefer compact forms such as `\(a/b\)` when unambiguous. `\frac` is allowed when it improves
clarity; do not force `\displaystyle` or `\dfrac` throughout running text. Move tall fractions,
matrices, long sums, or important multi-step relations to a display when they disrupt line spacing
or readability. Do not shrink an equation merely to keep it inline.

`$...$` and `\begin{math}...\end{math}` are valid LaTeX, but `\(...\)` is the single default for new
inline source. The explicit-environment preference applies to displays; the longer inline form does
not improve typesetting. Do not mix conventions without a documented publisher/tooling reason. These
are TeX-source rules: Markdown renderers may require different delimiters.

### Opening and Closing Displays

Put each opening and closing environment on its own line. Indent contents by two spaces, keep labels
inside numbered environments, and do not insert blank paragraphs inside mathematics. A display is
already in math mode: do not wrap its contents in `$...$` or `\(...\)`.

```tex
The squared distance is
\begin{equation}
  \label{eq:squared-distance}
  d^2 = (x - y)^2.
\end{equation}
```

For the same display without a referenceable number:

```tex
\begin{equation*}
  d^2 = (x - y)^2.
\end{equation*}
```

For a derivation with one equation number:

```tex
\begin{equation}
  \label{eq:distance-expansion}
  \begin{split}
    d^2 &= (x - y)^2 \\
        &= x^2 - 2xy + y^2.
  \end{split}
\end{equation}
```

The punctuation shown completes a sentence; use a comma or no terminal punctuation when the
surrounding sentence instead continues. Do not end the last row with an unnecessary `\\`. Use
`align` rather than `split` when individual rows need their own equation numbers. Do not label
unnumbered displays and expect ordinary equation references to resolve to them.

### Choosing Display Environments

Choose by mathematical structure and numbering needs, not visual trial and error. These distinctions
follow the [AMS manual](https://www.latex-project.org/help/documentation/amsldoc.pdf).

| Need                                              | Environment                                      |
| ------------------------------------------------- | ------------------------------------------------ |
| One numbered display                              | `equation`                                       |
| One unnumbered display                            | `equation*`                                      |
| One long equation without alignment points        | `multline`                                       |
| One numbered equation broken at aligned relations | `equation` containing `split`                    |
| A compact aligned block within mathematics        | `aligned` inside the enclosing math environment  |
| Separately numbered aligned relations             | `align`; suppress selected numbers with `\notag` |
| Consecutive displays without alignment            | `gather`                                         |
| Related equations with parent/child numbering     | `subequations` around the displays               |

Do not nest `align` inside `equation`. For grouped numbering, place a parent label immediately after
`\begin{subequations}` and child labels on their numbered equations. Use `\numberwithin` only when
the class/project requires section-based numbering. Reserve manual `\tag` values for intentional
external numbering, not normal counter management.

Use `align*`, `gather*`, or `multline*` when the corresponding structure needs no numbers. Put
alignment markers before relations (`a &= b`), and attach row labels before the row-ending `\\`.
`aligned`, `gathered`, and matrices are subordinate structures, not standalone displays. A pair of
`\left`/`\right` delimiters cannot straddle alignment cells or rows; use deliberately sized
delimiters or restructure the expression instead of inserting unrelated invisible delimiters.

Use `\intertext` between aligned rows for explanatory prose. Long top-level displays may permit
controlled breaks with `\displaybreak`; boxed structures such as `aligned` and `split` cannot break
across pages. Do not enable unrestricted display breaking without inspecting the resulting layout.

For piecewise definitions, use `cases`; use mathtools' `dcases` only when display-style entries are
needed. Use `\text{...}` for prose conditions. Prefer `\substack` for short multiline limits and
`\boxed` for a deliberately highlighted expression, rather than hand-built spacing and boxes. See
[mathtools](https://ctan.org/pkg/mathtools) and the AMS manual above.

### Symbols, Operators, and Delimiters

Use semantic symbol commands, not visual substitutes: `\times` for a multiplication sign, `\mid` for
a relation bar, and `\langle`/`\rangle` for angle delimiters. A juxtaposition, dot, cross product,
conditional bar, or divisibility relation must match the intended mathematics. Do not use a letter
`x` as a multiplication sign or `<`/`>` as angle brackets.

Keep variable indices italic (`a_i`) and fixed descriptive labels upright (`a_{\mathrm{ref}}`). Use
`\text{...}` for prose, `\mathrm` for an upright label, and `\DeclareMathOperator` for an operator
needing operator spacing; these are different jobs. Define recurring operators once, for example
`\DeclareMathOperator*{\argmin}{arg\,min}`. Use existing operators such as `\sin`, `\log`, and
`\det` directly, not italic letter sequences.

Use `pmatrix` or `bmatrix` for matrices; use their entries' own mathematical types, with `&` between
columns and `\\` between rows. Do not use a text table to imitate a matrix. Use braces for compound
indices and powers, such as `x_{i+1}^{2}`. Do not embolden a scalar index just because its base is a
vector. Font commands depend on the profile: with `unicode-math`, use explicit `\symbfup` or
`\symbfit` when that distinction is intended; a classic-font profile may use `bm`. Do not load both
profiles indiscriminately or assume `\mathbf` makes arbitrary Greek symbols bold italic. See the
[unicode-math author documentation](https://github.com/latex3/unicode-math/blob/master/um-doc-main.tex)
for symbol alphabets versus text-like identifiers.

Declare recurring absolute values and norms with mathtools' `\DeclarePairedDelimiter`; its plain,
explicit-size, and starred automatic-size forms allow deliberate sizing. Prefer `\lvert`/`\rvert`
and `\lVert`/`\rVert` to ambiguous raw bars. These choices specify typography, not a new definition
of the norm. See the
[mathtools manual](https://mirrors.mit.edu/CTAN/macros/latex/contrib/mathtools/mathtools.pdf).

Differential `d`, exponential `e`, imaginary units, vector boldness, and transpose notation vary
across disciplines. Declare the convention in the notation registry/project profile; do not impose
an unrecorded universal font rule. For example, `\int_0^1 x^2\,\mathrm{d}x` illustrates an
explicitly upright differential with thin separation, not the only legitimate convention.

### Tested Mathematics Example

The [mathematics example](../../examples/latex/math-standard/README.md) exercises the house source
forms with a small explicit LuaLaTeX preamble. It is independent of the legacy shared preamble and
does not establish that all existing templates work. Keep its log, package versions, resolved
references, and visual review with the actual run's evidence.

## Bibliography and Glossaries

For complete setup and release checklists, follow [BibLaTeX configuration](bibliography.md) and
[glossaries-extra configuration](glossary-and-notation.md). These are the authoritative detailed
standards; do not maintain a competing preamble recipe in each template.

Use `\zcref` for named references under the house profile; it supplies the object name and spacing.
For a deliberately number-only equation reference, `\eqref{eq:conditional-density}` remains
available with ordinary `\label` and amsmath. In publisher profiles requiring plain references, keep
explicit names attached to numbers, for example `Figure~\ref{fig:graph-recovery}`. Do not manually
wrap `\ref` in parentheses or duplicate a typed command's object name. Citation-command spacing
remains the bibliography style's concern.

Use BibLaTeX/Biber by default with a project-selected citation style. Publisher requirements for
BibTeX, natbib, or a supplied `.bst` are explicit overrides, not reasons to load competing systems
together. Keep canonical metadata unchanged when changing presentation.

Select bibliography and glossary resources explicitly. Use stable shared keys, `glossaries-extra`
with Bib2Gls where needed, and `field-aliases={citekey=user1,sourceurl=user2}`. Do not hand-edit
generated `.bbl` or `.glstex` files. Use the documented neutral `\itag` fallback from
`references-assets` when consuming abbreviation records without a styling definition.

Record the asset archive/revision and manifest digest in the consuming project. Use project-relative
paths or configured TeX input paths rather than personal absolute paths. A local bibliography may
hold genuinely project-only records, but must not duplicate or silently override canonical keys.
Follow the [bibliography standard](bibliography.md) when adding or correcting shared records.

## Figures, Tables, and Code

Preserve editable figure sources and provenance. Prefer vector PDF for plots/diagrams and suitable
raster formats for photographs. Do not upscale a low-resolution image and describe it as higher
quality. Follow the [image standard](images.md) for classification, rights, and duplicate
prevention. Use relative sizes such as `\linewidth` within panels/columns, readable labels,
distinguishable encodings, and captions explaining the content.

Let floats move unless a requirement justifies fixed placement. Put table captions above and figure
captions below by default, subject to class rules. Use meaningful headers, units, consistent numeric
precision, and appropriate numeric alignment. Avoid decorative vertical rules and screenshots of
tables; repeat header rows for multipage tables.

Use code-listing environments with a language and legible contrast. Prefer workflows not requiring
unrestricted shell execution. If minted, TikZ externalization, or another helper requires external
processes, document and explicitly enable the necessary trusted workflow. Never enable unrestricted
shell escape globally for downloaded documents.

## Accessibility and Release Quality

Use meaningful headings, descriptive links, readable contrast, and textual explanations of figures
and mathematical results. For accessible-PDF targets, follow the current LaTeX Tagging Project
instructions: document metadata precedes `\documentclass`; graphics and tables need appropriate
semantic annotation. Check class/package compatibility and the installed release. Enabling tagging
alone does not establish PDF/UA compliance. Inspect reading order, alternative text, tables, and
mathematics, and validate the delivered PDF with the project's required tools.

Require a clean build, resolved citations/glossaries/references, no missing glyphs/assets, reviewed
box warnings, and visual inspection of mathematics, floats, captions, headers, and links. Keep logs
and tool versions as evidence. Record which templates ran; do not extrapolate from one passing
example.

## Typesetting Checklist

Use this checklist when creating or reviewing a document; the sections above define the detailed
rules.

- [ ] Select the correct class, engine, fonts, language, and publication requirements before tuning
  layout.
- [ ] Give main and included `.tex` files the appropriate short header and documented build entry
  point.
- [ ] Use semantic headings, emphasis, quotation commands, and genuine paragraphs rather than visual
  hacks.
- [ ] Define notation before use; check symbol meaning, dimensions, units, and descriptive
  subscripts.
- [ ] Use `\(...\)` for readable inline expressions and explicit named environments for displays.
- [ ] Choose equation structure and numbering deliberately; align at relations and punctuate
  mathematics.
- [ ] Prefer semantic operators, delimiters, and unit commands over hand-built fonts and spacing.
- [ ] Use stable labels and canonical citation/glossary keys; resolve missing and duplicate
  references.
- [ ] Keep tables readable, numeric columns aligned, captions informative, and figure labels
  legible.
- [ ] Preserve vector/raster suitability and image provenance; inspect floats at the final
  publication size.
- [ ] Avoid global math-size overrides and ad hoc spacing fixes; review line breaks, widows/orphans,
  and boxes.
- [ ] Clean-build with the complete bibliography/glossary recipe; review warnings and remove draft
  TODOs.
- [ ] Inspect the PDF for glyphs, fonts, mathematics, page layout, links, and any required
  accessibility checks.
- [ ] Record tool/asset versions and actual validation scope; do not infer success from an old
  preview PDF.

## Usage

These examples locate the existing profile; they do not recommend loading it into every new
document. Relative paths depend on the actual document depth and must be checked per example.

Inside this repository's examples:

```tex
\usepackage{../../../latex/packages/preamble}
\usepackage{../../../latex/packages/global_commands}
```

For external projects, add `references/latex/packages` to the TeX input path and then load by
package name:

```tex
\usepackage{preamble}
\usepackage{global_commands}
```

## Compilation

Use the standard command sequences in `compilation.md` for:

- plain LaTeX builds
- BibLaTeX and Biber builds
- Bib2Gls glossary builds
- combined citation and glossary builds
- `latexmk` wrappers

## Linting, Formatting, and Primary Guidance

### Qualified Guidance from Emonts

Retain the article's semantic naming, consistent labels, and unit-aware markup. Do not make `align`
mandatory for every display: choose the appropriate AMS environment. `physics` is optional, not a
universal dependency. In particular, it and siunitx use `\qty` differently; select and document
command ownership before combining them. Prefer siunitx's `\unit` and `\qty` for new unit-aware code
where compatible, rather than manual unit typography. See the
[siunitx manual](https://mirrors.ctan.org/macros/latex/contrib/siunitx/siunitx.pdf).

Use built-in operators such as `\sin`, but ordinary parentheses do not automatically resize merely
because an operator is present. Use explicit sizing when needed. Use `\coloneqq` for definition by
equality and `\colon` where a punctuation colon is intended (for example `f\colon X\to Y`), not as a
blanket replacement for every mathematical colon. Use the appropriate math dots command. A macro for
blackboard-bold real numbers should use `\mathbb{R}`, not `\mathbf{R}`. These details are governed
by the [AMS manual](https://www.latex-project.org/help/documentation/amsldoc.pdf) and
[mathtools](https://ctan.org/pkg/mathtools), not copied uncritically from blog examples.

### Qualified Guidance from Damken

Also reviewed
[Fabian Damken's best-practices collection](https://fabian.damken.net/latex/best-practices/) on
2026-09-05. Its unfinished explanations and conflicting display-math recommendations require
qualification. Although `\[...\]` is valid LaTeX, our explicit-environment convention uses
`equation*`; appropriate inline fractions remain allowed, and raster images are not categorically
prohibited. Warning suppression must be narrow, justified, and reviewed, never a substitute for
fixing errors.

Use `\emph` for emphasis and semantic text superscripts/subscripts outside mathematics. Keep draft
TODOs identifiable and remove or disable them for release. Shared abbreviations continue to use the
existing glossary registry, not a competing database.

### Typography Clarifications from Package Documentation

Use `\enquote{...}` with a configured `csquotes` setup for language-aware quotations. A plain ASCII
quotation character does not by itself activate smart quoting; that requires explicit configuration.
See [csquotes](https://ctan.org/pkg/csquotes). Consider [microtype](https://ctan.org/pkg/microtype)
with the chosen engine/fonts and inspect the result, rather than compensating with manual spacing.

Use `\mathrm{KL}` for a fixed descriptive math subscript, `\text{...}` for actual prose, and
`\DeclareMathOperator` for an operator needing operator spacing. For prescripts use an appropriate
command such as `\prescript{2}{}{T}_1` from [mathtools](https://ctan.org/pkg/mathtools), not a
superscript that attaches to the preceding object. A multiline result with one number can use
`aligned` inside `equation`; multiple independently numbered relations can use `align`. See the
[AMS manual](https://www.latex-project.org/help/documentation/amsldoc.pdf).

`booktabs` adds rules and spacing for table environments; it does not replace `tabular`. See
[booktabs](https://ctan.org/pkg/booktabs). Caption alignment, nonfloating material, and required
fixed layouts remain class/project decisions rather than absolute prohibitions.

### Qualified Guidance from Wikibooks

Reviewed [Wikibooks: Advanced Mathematics](https://en.wikibooks.org/wiki/LaTeX/Advanced_Mathematics)
on 2026-09-05, revision `4626829`. Use it as a tutorial, with package manuals governing technical
behavior. The environment-selection guidance above captures the relevant house rules.

Do not adopt its global `\everymath{\displaystyle}` recipe as a default: preserve context-sensitive
math sizing. Display skips and equation indentation remain class-level decisions, not per-equation
repairs. Tutorial formulas illustrate syntax; they are not verified scientific references or
additions to the notation registry.

### Wikibooks FAQ and Tips: Qualified Adoption

Reviewed the [FAQ](https://en.wikibooks.org/w/index.php?title=LaTeX/FAQ&oldid=4666351) and
[Tips and Tricks](https://en.wikibooks.org/w/index.php?title=LaTeX/Tips_and_Tricks&oldid=4626837) on
2026-09-05. These are mixed-age tutorials, not current package specifications. Existing rules
already cover semantic paragraphs, scoped formatting, floats, notation, and numbering; do not
duplicate those recipes in templates.

- Encoding: do not copy the FAQ's mandatory `inputenc` recipe into new documents. UTF-8 became the
  LaTeX default in 2018; LuaLaTeX/XeLaTeX use it natively. Their font setup follows
  [fontspec](https://ctan.org/pkg/fontspec), not an automatic T1/Latin Modern workaround. See
  [LaTeX News 28](https://www.latex-project.org/news/latex2e-news/ltnews28.pdf). Investigate actual
  font and text-extraction problems rather than assuming every PDF search failure is OT1-related.
- Command spacing: `\LaTeX{} is` preserves the intended following space, but appending `{}` to every
  command is not a valid general rule. Respect required/optional arguments and avoid global `xspace`
  or logo redefinitions. See [command syntax](https://latexref.xyz/LaTeX-command-syntax.html).
- Tables: choose a tested width-aware environment when needed;
  [tabularx](https://ctan.org/pkg/tabularx) supplies adjustable paragraph columns. The FAQ's `tabu`
  recommendation is not our default.
- Graphics/builds: preserve editable sources and data, with readable labels at final size. Do not
  adopt screenshot-based plots, EPS conversion chains, or unrestricted shell escape as defaults from
  the Tips page. Follow [images](images.md) and [compilation](compilation.md). Generate figures
  through a documented trusted build step; keep logs and auxiliary output in the known build
  directory. Hiding files in an editor is not cleanup or evidence of a successful build.

This is a documentation review, not execution of the tutorials' commands or new compilation
coverage.

### Qualified Guidance from Wookai

Reviewed the supplied
[DeepWiki guide](https://deepwiki.com/Wookai/paper-tips-and-tricks/2-latex-typesetting-guidelines)
and its [source repository](https://github.com/Wookai/paper-tips-and-tricks) on 2026-09-05. The
source reinforces semantic lines, unbroken references, restrained table rules, and numeric
alignment. Use `\cmidrule` for grouped columns and `\addlinespace` for logical row groups; avoid
vertical rules in ordinary data tables. Heading capitalization follows the venue or documented
project style, not a universal title-case mandate.

Do not import its `fixmath` setup or redefine `\vec` automatically. Preserve the notation registry
and selected font stack. Style scalar components as scalars, distinguish columns from elements, and
keep ordinary indices outside bold symbol commands. Retain our `\(...\)` inline and explicit display
environments. Prefer modern siunitx `\qty`/`\unit` interfaces to its older `\SI` examples. For
BibLaTeX documents, optional back references belong to BibLaTeX configuration (`backref=true`), not
an additional competing back-reference setup. See the
[BibLaTeX manual](https://mirrors.ctan.org/macros/latex/contrib/biblatex/doc/biblatex.pdf).

### Qualified Guidance from TeX Tips

Reviewed [TeX Tips: Don'ts / Best practice](https://tex.tips/category/donts/) on 2026-09-05. These
2016 posts reinforce durable rules rather than establish a current package baseline: use semantic
macros, avoid cryptic shortcuts and accidental command redefinitions, and prefer LaTeX font
interfaces such as `\textbf`, `\textit`, `\bfseries`, and `\itshape` over legacy `\bf`/`\it`
switches. Use `\emph` when emphasis, rather than a particular font shape, is intended.

When deliberately setting an entire paragraph in a different font size, end that paragraph before
closing the size group, for example `{\Large A standalone notice.\par}`. This preserves that
paragraph's line spacing. Do not insert `\par` around an ordinary inline font change or substitute
manual font-size blocks for semantic section headings. Inspect custom notices with the chosen class.

### Qualified Guidance from Lshort

Reviewed selected sections of
[The Not So Short Introduction to LaTeX](https://tobi.oetiker.ch/lshort/lshort.pdf) on 2026-09-05:
line breaking (§2.1), mathematics (§§3.1–3.4), and bibliography (§4.2). The supplied PDF identifies
itself as nightly 7.0, revision `357b1a686cf242f03b80a4720c8fcde03876adf3`, dated 2025-05-12; do not
describe it as a stable release.

Its `mathtools`, inline-math, and BibLaTeX/Biber guidance supports our existing baseline. Retain
explicit `equation`/`equation*` displays rather than copying its shorthand delimiters. Its Unicode
math examples assume a compatible engine/font stack; ISO math styling is a documented project
choice, not an automatic override of the notation registry. Do not copy `warnings-off` settings
without reviewing command ownership and the actual warnings.

For overfull lines, inspect the affected paragraph, language/hyphenation, and unbreakable content
before changing layout. Do not adopt global `\sloppy` as a routine repair: relaxed spacing needs
visual review. Its command demonstrations explain available mechanisms, not mandatory house
defaults. The existing bibliography and compilation standards remain authoritative; no new template
build or full-book audit is claimed by this source review.

### LaTeX2e Command Reference

The supplied [TUG-hosted reference](https://tug.org/texinfohtml/latex2e.html) returned HTTP 403
during review on 2026-09-05. Consult the project's accessible
[LaTeX2e reference manual](https://latexref.xyz/), which identifies the June 2026 edition. This is
explicitly an unofficial command reference, not a LaTeX Project specification or a list of
recommended defaults. Use it for syntax and command behavior; resolve version-sensitive questions
against LaTeX Project release notes, the installed class/package manuals, and a minimal test. A
documented command is not automatically house-approved.

For headings and captions, distinguish fragile-command expansion from ordinary text formatting. Do
not add `\protect` indiscriminately: many commands, including `\(...\)`, became robust in the 2019
release. Ordinary `\verb` still cannot be repaired inside a caption simply by adding `\protect`;
prefer `\texttt{...}` with correctly escaped special characters, or a separately tested specialist
solution. See the manual's [moving-argument guidance](https://latexref.xyz/_005cprotect.html) and
[LaTeX News 30](https://www.latex-project.org/news/latex2e-news/ltnews30.pdf). Check rendered
headings/captions and their generated contents entries after rerunning the build. This
selected-section review adds no claim of full-manual review or template compilation.

### Unavailable Scribd Document

The supplied
[LaTeX Dos and Don'ts on Scribd](https://www.scribd.com/document/705164282/Latex-Dos-and-Donts)
could not be read on 2026-09-05 because the site returned a client challenge. Its contents and
authorship have not been verified, and no rules are attributed to it. Review an uploaded PDF or
accessible authoritative copy before incorporating it.

### Optional Static Tools

ChkTeX is the preferred optional static LaTeX linter; latexindent is the preferred optional
formatter. They are not yet repository-wide configured passing gates. Before adoption, select
maintained files, review macro-related false positives, pin tested configuration, and exclude
third-party templates, generated files, and imported documents. Use narrow, explained suppressions.
Do not bulk-format legacy TeX merely to make it look maintained. Neither tool replaces compilation
or PDF inspection.

- [AMS mathematics support and manuals](https://ctan.org/pkg/amsmath)
- [LaTeX package/class author guidance](https://www.latex-project.org/help/documentation/clsguide.pdf)
- [latexmk and its manual](https://ctan.org/pkg/latexmk)
- [ChkTeX](https://ctan.org/pkg/chktex)
- [latexindent](https://ctan.org/pkg/latexindent)
- [Accessible-PDF instructions](https://tagging-project.latex-project.org/documentation/usage-instructions)
- [Subcaption and compatibility information](https://ctan.org/pkg/subcaption)
