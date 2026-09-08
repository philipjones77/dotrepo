# LaTeX Macro Standard

This is the house policy for new and substantially revised macros. The [LaTeX standard](latex.md)
owns document syntax and cross-references. Mathematical definitions and assumptions live in
`definitions/library/`; `notation/library/notation_objects.md` owns their shared symbolic
representation and typeface conventions. The [notation standard](glossary-and-notation.md) governs
glossary records and usage. Existing thesis code is migration evidence, not an exception by default.
Publisher requirements may justify a documented profile. An old command is not wrong merely because
a newer interface exists.

## Ownership and Names

Define a macro for a recurring mathematical object, a reusable operation, or a stable document
interface—not merely to save a few keystrokes. Keep one maintained definition per public command.
Resolve the object in `notation/library/notation_objects.md` first. Prefer its explicit mathematical
source over an unverified shorthand; a semantic macro is acceptable only when its implementation
preserves the registered symbol, typeface, and spacing class. Never typeset a code identifier as if
it were the mathematical symbol. Shared implementations belong in `latex/packages/`;
project-specific implementations belong in the consuming project's explicitly loaded macro package.
Chapters use the interface rather than redefining it. Staged contributions and archived copies are
not additional active definitions.

Use descriptive letter-only public names such as `\PrecisionMatrix` and `\ConditionalCovariance`.
Reusable package APIs should have a documented prefix, for example `\RefNorm`, where collisions are
plausible. Do not introduce one-letter globals or names describing only a font. Preserve established
public names until an explicit migration. Do not redefine `\S`, `\P`, `\Re`, `\Im`, accent commands,
or standard operators to obtain unrelated symbols. Use `\Sphere` instead of changing the section
sign into a sphere. `\1` is legal TeX but not an acceptable new public name.

For each public macro, document its meaning/registry identifier, owner, signature, default values,
math/text mode, dependencies, side effects, supported font profile, and at least one example. A
macro controls rendering; it does not supply the mathematical definition or establish that two
symbols denote the same object. Resolve registry disagreements before sharing a replacement.

## Definition Interfaces

Prefer the kernel's `\NewDocumentCommand` for new document-facing commands, including simple
protected commands. Use `m` for required arguments, `O{default}` for ordinary optional values, `o`
only when omission differs from an empty value, and `s` for a meaningful starred variant. Use
`\IfNoValueTF` and `\IfBooleanTF` for their respective argument types. Accept paragraphs with `+m`
only when required. Prefer a small interface over many positional options.

Use specialized declarations where appropriate: `\DeclareMathOperator` for named operators,
`\DeclarePairedDelimiter` for delimiter pairs, and `\NewDocumentEnvironment` for new environments.
Do not wrap standard equation environments in opaque shortcuts: keep explicit `\begin{equation}`,
`\begin{align}`, and their matching ends in source.

`\newcommand` remains supported; do not mechanically convert expandable helpers to protected
commands. Label-key/path builders may require expansion: prefer literal keys and paths, or use
`\NewExpandableDocumentCommand` with a genuinely expandable body and a test at the actual use site.
Robustness does not imply expandability or automatic PDF-bookmark compatibility. Modern kernels
provide these document-command interfaces without loading `xparse` solely for them. See the
[LaTeX author guide](https://www.latex-project.org/help/documentation/usrguide.pdf).

New definitions must fail on a name collision. Use `\RenewDocumentCommand` only for a named,
reviewed override. `\ProvideDocumentCommand`/`\providecommand` are for documented fallbacks, not a
way to conceal competing definitions. Avoid unconditional `\DeclareDocumentCommand` or primitive
`\def` for public interfaces. Advanced internals may use expl3 with a package-specific namespace and
explicit scoping; do not expose underscore/colon internals as author commands. Group temporary font,
color, counter, and spacing changes; document intentional global effects.

## Mathematical Symbols and Spacing

Let TeX's math atom classes determine spacing. Do not repair a wrongly classified object with
scattered `\!`, `\,`, `\hspace`, or `\mkern`. Use the following distinctions consistently:

| Meaning                               | Preferred implementation                                              | Avoid                                                   |
| ------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------- |
| Variable or named mathematical object | Registry-selected symbol/font, ordinarily a math ordinary atom        | Text words accidentally rendered as products of letters |
| Named operator                        | Existing `\sin`, `\log`, etc.; otherwise `\DeclareMathOperator`       | `\mathrm{sin}` or an unclassified textual name          |
| Operator with display limits          | `\DeclareMathOperator*` when limits belong below/above                | Adding `\limits` to an ordinary symbol                  |
| Relation                              | Existing relation or `\mathrel{...}` for a custom construction        | Manual spaces around an ordinary atom                   |
| Binary operation                      | Existing operator or `\mathbin{...}`                                  | Hard-coded spaces that fail in scripts/unary contexts   |
| Delimiter pair                        | `\DeclarePairedDelimiter` with `\lvert/\rvert`, `\lVert/\rVert`, etc. | Ambiguous bars or automatic sizing everywhere           |
| Descriptive subscript                 | `a_{\mathrm{ref}}`                                                    | Italic multi-letter label read as a product             |
| Prose within mathematics              | `\text{if }`, `\text{otherwise}`                                      | `\mathrm` used for sentences                            |
| Units and quantities                  | `\unit` and `\qty` from siunitx                                       | Manually assembled number/unit spaces                   |

The ordinary delimiter form uses natural size; `[\big]` requests a chosen size, and `*` requests
automatic sizing. Choose by visual need, especially in fractions and subscripts. An inner-product
macro can use `\DeclarePairedDelimiterX` to express two arguments without forcing `\left/\right`.
See the [mathtools manual](https://mirrors.ctan.org/macros/latex/contrib/mathtools/mathtools.pdf).

Use `\colon` for mappings (`f\colon X\to Y`), `\mid` for a divides/such-that relation, and
`\coloneqq` for a definition if that convention is selected. A conditional-probability bar is a
separator, not automatically a divisibility relation: choose its delimiter/spacing within the
probability macro. Use `\dots` or the appropriate context-specific dots command, not three periods.
Use a genuine minus in math mode, not a text hyphen substitute. Keep punctuation in the sentence; do
not hide terminal commas or periods in reusable mathematical macros. See the
[AMS mathematics guide](https://www.latex-project.org/help/documentation/amsldoc.pdf).

Keep variables italic and descriptive labels upright. Select vector/matrix and differential
conventions through the notation profile. With unicode-math, use its `\sym...` interfaces for
mathematical alphabets; do not import a legacy bold-math package merely from habit. Upright versus
italic differentials and some constant styles vary across disciplines. The house example uses
`\int f(x)\,\mathrm{d}x`; it is a declared convention, not a universal mathematical law.

Keep math-only macros math-only by default. Use `\ensuremath` only for a documented dual-mode
interface; it does not manage surrounding prose spaces. For text commands, write `\Command{} text`
or `\Command\ text` where needed, rather than adding a trailing space or `\xspace` to every macro.
Preserve display/text/script/scriptscript sizing. Avoid unconditional `\displaystyle`, fixed text
sizes, negative spacing, and color inside semantic symbol definitions. Necessary optical fixes
belong in one documented implementation with font/style regression examples.

## Package Contract and Tests

Packages have a short purpose header, `\NeedsTeXFormat`, dated/versioned `\ProvidesPackage`,
explicit `\RequirePackage` dependencies, and `\endinput`. Separate mathematical semantics,
cross-reference configuration, and thesis presentation. Do not let a symbol package select page
geometry, citation style, institution colors, or a complete font stack.

Before promotion, compile a minimal consumer using the intended engine/font profile. Exercise every
supported argument form, nesting, inline/display/script sizes, nearby punctuation, and intentional
collision behavior. Test heading/caption/bookmark use when supported, with a semantic plain-text
PDF-string alternative where required. For numbered environments also test zref-clever names,
labels, lists, and hyperlink targets over repeated builds. No unresolved references or missing
glyphs are acceptable. Inspect the PDF; source lint cannot establish correct typography.

The executable [macro example](../../examples/latex/macro-standard/README.md) demonstrates these
interfaces without declaring a new canonical notation registry. `tools/validate_latex.py` enforces a
deliberately small set of source rules for maintained examples in CI. It is a lexical check, not a
TeX parser, mathematical validator, or proof that legacy packages comply. Broader migration requires
reviewed inventories and compilation tests; do not bulk-rename macros in thesis chapters.

## Thesis Adoption

Keep its self-contained library and explicit refresh process. The thesis's flat library adapter does
not currently import upstream style packages, so publishing this standard does not migrate its macro
implementation. Preserve local custom stage/type concepts, but test their counter and label
semantics before sharing them. See the
[thesis comparison](../status/thesis-macro-review-2026-09-05.md) for concrete migration candidates.
