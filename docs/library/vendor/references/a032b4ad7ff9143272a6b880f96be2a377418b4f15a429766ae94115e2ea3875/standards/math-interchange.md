# Mathematical Interchange: MathML and OpenMath

This standard defines representation and publishing boundaries, not a new symbol registry. Use
[LaTeX](latex.md) for authored TeX, [glossary and notation](glossary-and-notation.md) for meaning,
and [GitHub publishing](github-publishing.md) for web documentation.

## Choose a Representation by Purpose

| Purpose                                           | Representation                                     | Ownership                                        |
| ------------------------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| Authored mathematical exposition and PDF          | LaTeX                                              | Document source and shared semantic macros       |
| Mathematical meaning, domains, assumptions, units | Existing definitions/notation and glossary records | Canonical libraries                              |
| Browser-oriented structured notation              | Presentation MathML, targeting MathML Core         | Reviewed export of source expressions            |
| Explicit machine-readable operations and binding  | OpenMath or Content MathML when required           | Reviewed semantic representation with provenance |
| GitHub repository documentation                   | Markdown with supported math syntax                | Authored docs or identified generated excerpts   |

Presentation does not uniquely determine meaning. A printed product, function application,
conditional bar, or superscript can be ambiguous. Do not label a TeX-to-MathML conversion as
semantically verified merely because it renders correctly. OpenMath is not a browser layout
language, and neither format replaces the explanatory text, assumptions, or citations.

## Specification Baseline

Checked 2026-09-05. Pin the actual specification revision and tool versions used by an exporter;
recheck publication status during upgrades, not by guessing from a version number.

- MathML Core's published specification is a Candidate Recommendation Snapshot dated 2025-06-24. Use
  its browser-focused presentation subset as the interoperability target, with tested browser
  coverage. Do not call it a finalized Recommendation.
  [MathML Core](https://www.w3.org/TR/mathml-core/)
- MathML 4's published document is a Working Draft dated 2026-06-04. Experimental features require
  explicit opt-in and compatibility tests; they are not the portable default.
  [MathML 4](https://www.w3.org/TR/mathml4/)
- OpenMath's normative standard is version 2.0 revision 2. An older publication date alone does not
  make a currently normative specification obsolete.
  [OpenMath standards](https://openmath.org/standard/)

MathML includes both presentation and content vocabularies. Core targets rendering; browser support
for presentation does not establish support for Content MathML semantics. MathML can be serialized
as XML or embedded in HTML; XML parsing rules do not automatically apply to an HTML document.
[MathML specification](https://www.w3.org/TR/mathml4/)

## MathML Authoring and Export Rules

Use structural elements, not spacing tricks: identifiers, numbers, and operators belong in `mi`,
`mn`, and `mo`; fractions and scripts use their corresponding structures. Use `mtext` for prose.
Preserve grouping and distinguish inline from block display. Standalone XML uses the MathML
namespace:

```xml
<math xmlns="http://www.w3.org/1998/Math/MathML" display="inline">
  <mrow><mi>x</mi><mo>+</mo><mn>1</mn></mrow>
</math>
```

This is a presentation example, not a proof of the meaning of `x`. Use Unicode characters or numeric
character references when XML entities are not defined; do not assume TeX commands work inside XML.
Follow [MathML Core](https://www.w3.org/TR/mathml-core/) for supported elements and browser layout.

House export requirements:

- Preserve source expression, stable source/document identifier, canonical symbol references,
  converter version/options, input hash, and an explicit list of unsupported or approximated
  constructs.
- Keep semantic annotations separate from display hints. An embedded TeX annotation is provenance,
  not a machine-verified interpretation. Do not silently discard unsupported custom macros.
- Generate from one authoritative source; do not maintain independent handwritten TeX, MathML, and
  Markdown copies of the same formula unless the synchronization contract is documented.
- Validate parsing/profile conformance and inspect rendering separately. Include fractions, indices,
  matrices, piecewise definitions, operators, and long expressions in conversion fixtures.
- Test keyboard access, zoom, and representative browser/screen-reader combinations. Structured
  markup alone does not establish accessibility. Keep an explanatory sentence and an accessible
  fallback where the target cannot consume the markup; do not replace all mathematics with
  screenshots.

## OpenMath Semantic Rules

Use existing Content Dictionaries for established operations. Identify symbols by their Content
Dictionary and symbol name, with a documented dictionary base; a familiar printed glyph is not a
semantic identifier. Represent application, binding, and variables structurally. Record variable
scope, domains, units, and assumptions needed by the receiving system. Do not infer them from
typography.

When no suitable dictionary exists, propose a versioned dictionary with a stable URI, definitions,
examples, dependencies, ownership, and review status. Do not silently redefine an existing symbol or
present a private dictionary as an approved public one. Pin the dictionaries alongside the exporter.
Validate XML against the normative RELAX NG schema and then check dictionary references and semantic
constraints. Schema validity alone does not prove mathematical equivalence.
[OpenMath normative specification and schemas](https://openmath.org/standard/om20-2019-07-01/)

OpenMath and MathML may be associated through an explicitly documented annotation/mapping scheme.
Require operator, binding, and domain-preservation tests for conversions. Compare structured
meanings rather than raw XML byte equality; reject ambiguous mappings for human review.

## Security, Storage, and Implementation Status

Treat imported XML and TeX as untrusted data. Disable external entity/DTD fetching and network
access in XML validation, use bounded input sizes, and do not execute embedded instructions. Resolve
only approved local schema/dictionary dependencies. Record provenance and licensing before
redistribution.

Keep experiments in `experiments/` and generated output in a declared build/status directory. A
future maintained exporter belongs under `src/automation/` with fixtures, a schema/version contract,
and an explicit archive inclusion decision. No canonical OpenMath/MathML record store or exporter is
introduced by this standard. Do not add opaque semantic fields to existing `.bib` schemas without a
migration.

Current implementation status: standards only. Browser/accessibility tests, semantic conversion,
schema validation, and export packaging remain to be implemented and tested. Existing structural
checks do not certify any of those capabilities.
