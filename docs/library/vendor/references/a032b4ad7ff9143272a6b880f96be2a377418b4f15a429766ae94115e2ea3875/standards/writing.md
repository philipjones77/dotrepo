# Research Writing Handbook

These rules primarily govern formal research papers, scholarly publications, and theses that consume
this repository. Mathematical exposition and reproducible research are central; product
documentation advice is supplementary. A downstream project must record applicable journal,
institution, or publisher requirements as scoped overrides, not assume this house style replaces
them.

This is the canonical, complete working document for our scholarly writing framework: rules,
structure, drafting, sentence flow, assisted editing, attribution, and release review. Use it
directly when writing or reviewing a paper or thesis. The former workflow and editing guides now
point here so that there is only one maintained version.

Detailed LaTeX implementation and library-storage contracts remain in their specialist standards;
the writing decisions and operating checklists are included here. Current venue and institutional
requirements take precedence within their stated scope.

The [Philip Jones thesis profile](#philip-jones-thesis-writing-profile) preserves the supplied
authorial method and thesis conventions within this same handbook. Its British English, voice,
chapter rhythm, and appendix register apply to the thesis and projects that explicitly adopt that
profile. Other projects retain the shared defaults and their documented overrides. Read the complete
handbook when applying the profile; its checklist does not replace the shared workflow or review.

## Contents

- [Purpose and document type](#purpose-audience-and-document-type)
- [Prose](#prose) and [structure, flow, and assisted-writing rules](#structure)
- [Evidence, paper sections, uncertainty, and figures](#evidence-and-scientific-claims)
- [Thesis structure](#thesis-and-dissertation-structure)
- [Philip Jones thesis writing profile](#philip-jones-thesis-writing-profile)
- [Grammar](#grammar-and-academic-register) and [mathematics](#mathematics)
- [Citations, contributions, and AI accountability](#citations-and-attribution)
- [Numbers and units](#numbers-units-and-code)
- [Do and don't checklist](#do-and-dont-checklist)
- [End-to-end workflow](#end-to-end-writing-workflow)
- [Editing examples, sentence-flow pass, and reusable prompt](#editing-review-and-reusable-prompt)
- [Manuscript similarity review](#manuscript-similarity-review)
- [Evidence and supporting standards](#evidence-and-supporting-standards)

## Purpose, Audience, and Document Type

Before drafting, identify the intended reader, their prerequisites, the question or task, the
document's scope, and the outcome it must support. State important assumptions instead of guessing
what readers know. Consult an appropriate subject expert for unfamiliar material, and retain
traceable evidence rather than treating expertise alone as proof.

Choose the form that serves the purpose:

- Research paper: a bounded contribution supported by methods, findings, and interpretation.
- Mathematical exposition: definitions and assumptions, precise claims, proofs, examples, and
  limits.
- Thesis: an overarching research argument with linked chapter contributions; follow the
  institution's requirements rather than applying a short-journal-article length rule.
- Tutorial or procedure: prerequisites, actions, expected outcomes, and recovery from likely
  failures.
- Reference documentation: a stable description of interfaces, fields, units, constraints, and
  errors.
- Explanation or design rationale: the problem, alternatives, decision, tradeoffs, and consequences.

Do not force all documents into Introduction, Methods, Results, and Discussion (IMRaD). Use that
structure where appropriate to the research and venue. Separate the order in which you draft from
the order in which readers encounter the material.

## Prose

- Write direct, complete sentences and prefer active voice when the actor matters.
- Put the main claim before qualifications and implementation detail.
- Use one term consistently for one concept. Define specialized terms on first use or link them to
  the shared glossary or definitions.
- Avoid conversational filler, unsupported intensifiers, and claims such as "obvious" or "trivial"
  when a precise justification is available.
- Use American English unless a downstream publication or an explicitly adopted project profile
  specifies another variety. The Philip Jones thesis profile uses British English with `-ise`. Do
  not mix spelling systems within one document.
- Use the serial comma in lists of three or more items.

### Concision Without Lost Meaning

Remove repetition, inflated phrasing, and needless setup, not essential qualifications. A short
sentence that conceals the population, condition, uncertainty, or failure mode is not an
improvement. Keep specialist terms when they carry necessary meaning, define them for the intended
audience, and use one canonical name. Prefer a direct verb over an unnecessary nominalization: write
"we compared" instead of "we performed a comparison" when the meaning is unchanged.

Prefer active voice when responsibility or the actor matters; passive voice is acceptable when the
process or object is the focus. First-person language is allowed when appropriate to the venue. Do
not impose a passive-voice quota, a fixed sentence length, or a ban on ordinary pronouns. Make
referents unambiguous: "this estimate" is often clearer than an isolated "this".

Keep related words close, avoid long stacks of nouns, and use explicit logical transitions. Use
parallel grammatical forms in lists. Number steps when order matters; do not turn a connected
argument into bullets merely to make it appear shorter. Readability scores are prompts for review,
not measures of truth or scientific quality. Prefer skilled review over assumptions about a
reviewer's native language.

Place limiting words such as "only" next to their intended scope. For example, "only model A
converged" and "model A converged only on dataset B" make different claims. Complete comparisons
with an identifiable baseline. Report unsuccessful attempts accurately rather than replacing
"attempted to estimate" with "estimated" when no estimate was obtained.

Aim for the smallest complete argument: keep every definition, assumption, qualification,
interpretation, and proof obligation needed for correctness. Apply the deletion test to suspected
filler: remove it, reread the passage, and restore it if meaning, evidence, scope, or a necessary
dependency was lost. A sentence should define, assume, claim, support, interpret, contrast, or
connect something the argument needs. Keep local notation no richer than the result requires.

## Structure

### Sentence and Paragraph Flow

Order sentences so readers can identify what each one adds: evidence, explanation, consequence,
contrast, or qualification. Where helpful, begin with an established topic and introduce the new
information afterward. Reuse a precise noun to maintain continuity; decorative synonyms can make one
concept appear to be several. Make subject changes and pronoun referents explicit.

Choose transitions for the actual relationship, not surface smoothness. "Therefore" requires an
inference; "however" requires a contrast. A connective cannot repair a missing reasoning step.
Preserve useful repetition of terms while removing repetition of whole claims. Vary sentence length
as needed, and keep conditions close to the statements they qualify. These are flexible principles,
not a compulsory sentence pattern. See
[Harvard's transitions guidance](https://writingcenter.fas.harvard.edu/transitions) and
[UNC's flow guidance](https://writingcenter.unc.edu/tips-and-tools/flow/).

Check continuity at sentence, paragraph, section, and chapter scales. A paragraph opening should
make its relationship to the preceding argument clear; a section boundary should connect the
established result to the next scientific objective where that connection matters. Read the first
sentences of consecutive paragraphs as an outline. If they form only a list of topics, inspect the
missing dependencies and order. These checks diagnose gaps; they do not require every opening to use
the same syntax or every ending to preview the next unit.

Use three-part groupings when the content supports them, such as mathematical, statistical, and
computational validity. Preserve two cases or five assumptions when those are the actual structure.
Do not force repeated triads, equal paragraph lengths, symmetric advantages and limitations, or
identical claim-example-summary patterns onto unequal ideas.

### Editorial Artifacts in AI-Assisted Prose

Apply the same quality criteria to human-written and AI-assisted text. Style is not proof of
authorship. Keep editing instructions separate from manuscript content: a request to avoid a generic
overview should produce a specific argument, not a sentence declaring that the paper is "not a
generic overview". Include contrasts only when they explain a real distinction supported by the
work. Preserve meaningful negatives, null results, limitations, and logical negation.

Use connected paragraphs for scholarly reasoning. Reserve lists for genuinely discrete items, such
as assumptions, contributions, cases, or procedures; keep necessary links between them explicit.
Avoid heading-per-sentence layouts and repeating a list immediately in prose. This is not a bullet
quota: structured standards and checklists legitimately use lists more often than research
discussions.

Remove generic scene-setting, self-praise, redundant summaries, and sentences that announce an
explanation without supplying it. Prefer one precise claim over several synonymous restatements.
Keep repeated technical terms when they preserve identity; retain necessary context in abstracts,
captions, and chapter transitions. Compactness means less verbal overhead, not denser syntax or
fewer qualifications. Use the [editing review](#editing-review-and-reusable-prompt) for examples, a
bounded editing prompt, and verification steps.

### Organization and Reuse

- Give each section one clear purpose and arrange sections in dependency order.
- Introduce notation before using it and keep symbols consistent with `notation/` and
  `glossaries/library/symbols.bib`.
- State assumptions near the result or method that depends on them.
- Distinguish definitions, assumptions, results, examples, and implementation notes through prose or
  appropriate LaTeX environments.
- Keep captions self-contained enough to identify the object and explain abbreviations or encodings
  that are not defined nearby.

Give each paragraph a clear function: introduce a claim or question, develop it with evidence or
reasoning, and explain its consequence where needed. Not every paragraph needs the same formula.
During revision, summarize each paragraph in one short margin note; reorder or remove passages that
do not advance the document's purpose. Keep short orienting summaries where readers need them, but
do not repeat an entire result in the introduction, results, discussion, and conclusion.

One canonical source should own each reusable rule, definition, interface, and notation entry. Link
to it instead of maintaining competing copies. A standalone abstract, caption, or procedure may
intentionally repeat essential context; the repeated content must stay consistent.

## Supplementary Research Software Documentation

State the starting location (screen, file, or working directory), prerequisites, permissions, and
supported version. Put ordered actions in numbered steps, normally one principal action per step,
with its expected result where useful. Place warnings before the risky action and explain relevant
failure/recovery paths. Mark placeholders clearly; do not use real credentials or destructive
commands as casual examples. A tested example must name the environment and actual outcome.

Use direct, neutral language without belittling difficulty: explain requirements rather than saying
"just" or "obviously". Imperatives and "you" are allowed in instructions; "we" is allowed for the
authors' work when appropriate. Keep logical transitions needed for reasoning. Do not adopt another
organization's blanket bans on pronouns or transitions as a universal standard.

Use figures and tables when they make relationships easier to understand, not because a list exceeds
an arbitrary item count. Important instructions and meanings must remain available in accessible
text; a screenshot alone is not a complete procedure. Follow [Markdown](markdown.md),
[images](images.md), and [documentation structure](documentation.md).

## Evidence and Scientific Claims

- Match the strength of the wording to the evidence and its scope. Distinguish observations,
  estimates, hypotheses, interpretations, and mathematical proofs. Do not turn an association into a
  causal claim by wording alone.
- Report relevant contradictory, null, and negative findings. Do not select results solely because
  they support a preferred conclusion or meet a significance threshold.
- For numerical comparisons, state the comparator, metric, units, population or test conditions,
  sample/replicate meaning, and uncertainty where applicable. Distinguish statistical from practical
  importance. Avoid unsupported "better", "robust", "optimal", "significant", and "state of the
  art".
- Keep exclusions, missing data, exploratory choices, and material changes to planned analysis
  visible. A persuasive narrative does not authorize changing the evidence.
- State a defensible contribution rather than insisting on dramatic novelty. Replications, null
  results, corrections, datasets, and expository work can serve legitimate purposes.
- Keep conclusions within the study's evidence. Specific, justified future work is useful; generic
  promises and speculative benefits presented as established results are not.

### Negative and Nonexistence Claims

Negative assertions require evidence and a stated scope. A failed search, missing implementation,
incomplete proof, or prompting question does not establish that a method or result does not exist.
Distinguish "not proved here", "not implemented in this repository", "not identifiable under these
assumptions", and "outside the present scope". When a review is bounded, say "We did not identify
such a result in the sources reviewed" rather than claiming universal nonexistence.

Check a prompt's negative premise before adopting it. Preserve supported negative results,
limitations, and logical negation; remove negative claims or contrasts that merely reproduce an
editing conversation. Compare methods by their actual assumptions and results without inventing a
weakness to motivate a preferred method.

### Model, Analysis, and Validation Layers

Introduce the scientific object and inferential target before selecting mathematical machinery. For
model-based research, distinguish the domain, latent process, observations, parameters, and
computation. State the observation and data-delivery pattern before choosing a likelihood or solver:
irregular locations, replication, aggregation, missingness, and observation order can affect the
analysis without changing the domain or latent process. Do not let a numerical approximation
silently redefine the model or an observation assumption become a property of the latent field.

A reproducible methodology identifies the scientific target and unit of analysis; domain, sampling
design, and observed variables; latent and observation models; parameter meanings, constraints, and
identifiable combinations; objective or estimating equation; representation and solver;
approximation assumptions, tolerances, and diagnostics; and inferential or predictive output with
uncertainty. Present these in the order the argument requires. Link reported outputs to data and
preprocessing, software versions, configuration, applicable seeds, evaluation metrics, reproduction
commands, and hardware when performance is claimed.

Keep three forms of validity distinct:

- Mathematical validity: existence, positive definiteness, well-posedness, and structural
  conditions.
- Statistical validity: identifiability, calibration, consistency, and the sampling or asymptotic
  regime.
- Computational validity: approximation error, solver convergence, conditioning, reproducibility,
  and numerical diagnostics.

Evidence for one form does not establish the others. State the connection when a theorem,
experiment, or diagnostic supports several. Numerical agreement can support a diagnostic claim; it
does not by itself prove a theorem or universal stability.

Compare methods against their common problem using decision-relevant assumptions, estimands,
domains, identifiability, accuracy, cost, scalability, and failure modes. Use a table for exact
parallel comparisons and prose to explain the choice in the stated setting.

### Section Responsibilities for a Research Paper

| Section                              | Required job                                                                                                                                                            |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Title                                | Identify the topic/contribution accurately; avoid a stronger claim than the paper supports.                                                                             |
| Abstract                             | State the problem, approach, principal result, and bounded implication; include informative quantities when appropriate and obey the venue's structure/limit.           |
| Introduction                         | Establish context, the relevant gap or question, and the contribution without an indiscriminate literature dump.                                                        |
| Methods                              | Supply the information needed to understand and assess the work; identify resources, versions, settings, controls, analysis choices, and departures from cited methods. |
| Results                              | Present relevant findings in a logical sequence with evidence; distinguish findings from their wider interpretation.                                                    |
| Discussion                           | Interpret, compare with prior work, address alternatives and limitations, and explain what follows; a brief orienting recap is allowed.                                 |
| Conclusion                           | Answer the research question within scope; do not introduce unreported results.                                                                                         |
| Declarations and supporting material | Complete contributions, funding, interests, approvals where applicable, availability, acknowledgements, references, and supplements required by the venue.              |

Abstracts must agree with the final paper, not introduce new claims. Avoid unexplained abbreviations
and unnecessary citations; follow venue exceptions rather than a universal prohibition. Choose
keywords that describe the actual subject and aid discovery, using canonical terminology where
possible. Their count and placement are venue choices, not a global six-keyword rule.

Methods must remain sufficient after editing for length. Put extensive supporting details in stable,
accessible supplements when appropriate, but do not hide information essential to evaluating the
main claim. For computational work, connect reported results to the actual code/data revision,
environment, configuration, seeds where relevant, and evaluation procedure; see [Python](python.md),
[JAX](jax.md), and [GitHub publishing](github-publishing.md).

### Uncertainty and Quantitative Reporting

Define every error bar, band, and plus/minus term: quantity estimated, interval or uncertainty type,
level where applicable, calculation method, and number and meaning of independent units. Distinguish
data spread (SD), precision of an estimated mean (SE), confidence intervals, and measurement
uncertainty. Repeated measurements on one unit are not automatically independent replicates. Do not
infer significance from overlapping bars alone or interpret a p-value as the probability that the
null hypothesis is true. Report the relevant estimate and uncertainty, not merely a threshold
decision; see the [ASA statement](https://www.amstat.org/asa/files/pdfs/p-valuestatement.pdf).

Choose precision from the measurement/analysis and intended use, not a universal digit count for all
temperatures or model coefficients. Retain adequate computational precision and round for
presentation. Missing uncertainty must not be inferred from the last printed digit. Document
propagation assumptions and account for relevant covariance; a sum of squared components alone is
not the general correlated-input case. See
[NIST's propagation guidance](https://www.nist.gov/pml/nist-technical-note-1297/nist-tn-1297-appendix-law-propagation-uncertainty).

### Figures and Graphical Abstracts

Design figures for the actual delivery size; check labels, units, symbols, and line styles after
export. Explain whether lines represent fitted models, interpolation, or visual guides. Define
uncertainty in captions and distinguish observations from predictions. Use redundant encodings where
needed; color alone does not ensure legibility in grayscale or accessible viewing.

A graphical abstract should accurately summarize the contribution and meet the venue's current
requirements; it does not replace a required text abstract. Do not impose one journal's column
width, font size, or line weight on every publication. Use the [image standard](images.md) for
classification/provenance and [LaTeX standard](latex.md) for typesetting rather than duplicating
those contracts here.

## Thesis and Dissertation Structure

A thesis must develop a coherent research argument, not merely collect papers. Record the central
question and map each chapter to its contribution, evidence, dependencies, and limitations. A
literature review should synthesize competing approaches and evidence to motivate the question, not
catalogue papers or manufacture a gap.

Distinguish the candidate's contributions from established results and collaborators' work. For a
thesis incorporating publications, identify reused chapters, their publication status, co-author
contributions, required attribution, and permissions under institutional and publisher policies. Do
not silently present previously published text as new work. Keep notation and terminology consistent
across chapters and explain any unavoidable changes inherited from published articles.

Provide chapter transitions and a final synthesis connecting the findings to the overarching
question, their combined limitations, and justified next questions. Use cross-references to reduce
duplication while retaining enough context for chapters to be readable. Check the institution's
current front matter, declarations, abstract, bibliography, accessibility, deposit, and embargo
requirements; no universal thesis template or chapter order is prescribed here.

## Philip Jones Thesis Writing Profile

This profile incorporates the supplied *Thesis Writing Style Guide* into the canonical handbook. It
governs Philip Jones's mathematical thesis and other projects that explicitly adopt it. The shared
sections remain the baseline; this profile supplies the thesis's voice, scientific method, chapter
rhythm, and local revision checks. Distribution of the handbook alone does not impose its
thesis-specific conventions on unrelated papers or software documentation.

### Profile Scope and Supporting Standards

The profile uses British English with `-ise` and the serial comma, `we` for mathematical exposition,
and `I` for personal contribution claims in running prose. Its authorial-signature section permits
`I` in specified footnotes and a guiding-question list once at a main chapter's opening. Title Case
headings, chapter orientation, and explicit appendix-proof references belong to this profile.
Institutional or publisher requirements take precedence within their applicable scope.

Orientation, motivation, interpretation, and concluding transitions apply to main chapters and
clearly identified introductory appendix chapters when they advance the argument.
Chapter-accompanying appendices instead follow the formal appendix register throughout drafting,
revision, and checklist review. A short paragraph or section need not follow a fixed rhetorical
formula.

| Need                                                                 | Canonical source or consuming-project responsibility                                                       |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Shared scholarly framework, editing workflow, and publication review | This complete handbook                                                                                     |
| Thesis voice, chapter rhythm, and local revision checks              | This profile, with documented project-specific exceptions                                                  |
| LaTeX labels, cross-references, and quotation syntax                 | [LaTeX](latex.md) and the consuming project's configuration                                                |
| Shared terms, symbols, and notation                                  | [Glossary and notation](glossary-and-notation.md)                                                          |
| Builds and tooling                                                   | [Compilation](compilation.md), [toolchain](tooling.md), and the project's build guide                      |
| Package and style implementation                                     | [LaTeX macros](latex-macros.md) and the project's architecture guide                                       |
| Asset revision, adoption, and overrides                              | [Repository Standards](README.md#adoption-and-precedence) and the project's pinned lock or revision record |

Before claiming conformity, check the writing and asset revision recorded by the consuming project.
Its own startup, refresh, and contribution workflow owns local paths and required session readings;
the original thesis's paths are not portable release links. Read the whole handbook when writing or
reviewing under this profile, including its sentence-flow pass, bounded editing workflow, and
publication review. Apply every local deletion or rhythm check subject to preservation of scientific
meaning and authorial features. Editorial patterns are review targets, not evidence of AI
authorship.

### Local Authorial Method

The thesis uses a systems-first, layered method of exposition. Begin with the scientific object and
the question to be answered, then introduce only the mathematical structure needed to answer it.
Keep the connections among theory, statistical meaning, and computation visible throughout.

The characteristic progression is:

1. State the scientific problem or inferential target.
1. Specify the domain, random object, and observation scheme.
1. Separate the data, process, parameter, and computational layers.
1. State assumptions immediately before they are used.
1. Give the mathematical representation or result.
1. Explain what the result means for the field, data, or estimator.
1. State what it enables next: a construction, proof, algorithm, inference procedure, or extension.

This progression is a guide to logical order, not a paragraph template. Omit a step when it adds no
information. The governing principle is the **smallest complete argument**: retain every assumption,
definition, qualification, and interpretation needed for correctness, but remove anything that does
not move the argument forward.

#### Layered Exposition

Keep distinct objects in distinct conceptual layers:

- **Domain:** space, time, attributes, topology, metric, measure, and sampling locations.
- **Process:** latent field, covariance or precision structure, regularity, and governing operator.
- **Observation:** measurements, observation operator, likelihood, noise, and missingness.
- **Parameters:** estimands, constraints, priors or penalties, and identifiability.
- **Computation:** representation, approximation, solver, and error control.

State explicitly when moving between layers. Do not let a computational approximation silently
redefine the stochastic model, or let a data assumption silently become a property of the latent
field.

State the data-delivery pattern before selecting an inferential or computational method. Irregular
locations, replication, aggregation, missingness, and the ordering of observations may change the
likelihood and solver without changing the underlying domain or latent process.

#### Simplest Case to General Case

Develop the simplest case that contains the main idea before adding dimensions or branches. A
typical order is scalar before multivariate, Euclidean before manifold, Gaussian before
non-Gaussian, stationary before nonstationary, and exact before approximate. State which parts of
the baseline argument survive the extension and which assumptions change.

Do not remove a dimension, dependence, or observation feature when it carries the scientific
question. In that case, begin with the smallest faithful model rather than an artificially simpler
one.

Use extensions only when they advance the current argument. Place substantial side branches in a
later section or appendix. A short extension may remain near the baseline result if it clarifies
scope without interrupting the main line.

#### Multiple Mathematical Views

Distinguish views of the stochastic object from its analytic and computational representations. A
field may be treated as a collection of indexed random variables, one random function, a spatially
indexed family of temporal random functions, or a temporally indexed family of spatial random
functions. State the measurable structure and the correspondence between views before using a change
of view in an argument.

Covariance, spectral, operator/SPDE, basis, graph, and computational forms may then describe the
same object. Name the active view and give the bridge to the next view. For each change of
representation, state the invariant object, the resulting advantage, and any changed assumptions or
loss of information. Do not present equivalent forms as an unconnected catalogue.

### Authorial Signature

The supplied style guide identifies the reference sample for the thesis voice as the 2024
comprehensive exam, *Spatio-Temporal Random Fields: Non-Bayesian and Bayesian Analysis of Space-Time
Processes*. The target recorded in the supplied guide is that document's method and curiosity with
its drafting habits removed. This profile preserves that author-provided characterization; it does
not claim a separate review of the examination manuscript. The main text is a minimal but
interesting conversation with a competent reader; the appendix is a record of fact.

#### Features to Preserve

- **Problem before machinery.** A chapter opens with the scientific object, the use case, and the
  data-delivery pattern, and only then with the mathematics. The heading pattern *Problem Statement,
  Use Case, and Data Delivery* is characteristic and stays.
- **A named taxonomy that organises the whole.** The Type I/II/III random-field classification and
  the View A/B/C representations are the author's own scaffolding. Keep such named devices and reuse
  them across chapters rather than inventing local synonyms.
- **A concrete physical picture at the point of abstraction.** A tumour that grows and shrinks, a
  road network with closed roads, a sewage catchment: one sentence of physical imagery placed
  exactly where an abstract object is introduced. Keep one; do not accumulate several.
- **Honest scope statements.** “The dream of real-time Bayesian analysis of streaming data is still
  a long way off” is a claim about the field stated plainly. Prefer this kind of direct assessment
  to hedged neutrality.
- **Footnotes for notation decisions, attribution asides, and history.** The origin of kriging, the
  reason a vector is left unbolded, the decision to say “non-Bayesian” rather than “frequentist” all
  belong in footnotes, not the running argument. Footnotes may use `I`.
- **Remarks for side branches.** A Remark environment holds a consequence, caution, or connection
  (deeper hierarchies, local versus global separability) that would interrupt the main line. This
  keeps the main line short without losing the thought.
- **A chapter-opening list of guiding questions.** The device “We seek to answer the following
  questions” appears once per chapter and is retained there as a framing list. Everywhere else,
  convert a question into an objective as the Tone section requires. Drop the word “interesting”
  from the list's introduction; the questions establish interest by themselves.
- **Sparse idiom.** “Best tool for the job” and “in the eye of the beholder” are acceptable once
  each in a chapter when they name a real modelling judgement. Two idioms in one paragraph is a
  drafting habit, not a voice.

#### Habits to Remove

These occur throughout the reference sample and are the author's own fluff, not an AI pattern.
Remove them on revision.

| Habit                                                                                                                                    | Fix                                                                               |
| ---------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| “Generally speaking,” “of course,” “clearly,” “so-called,” “obviously”                                                                   | Delete, or replace with the reason the reader needs.                              |
| “we will take the time to,” “we will delve into,” “we briefly touch upon”                                                                | State the claim or the section's objective directly.                              |
| “Note that,” “We note that,” “It must be noted that” as sentence openers                                                                 | Start with the subject of the note.                                               |
| “interesting,” “attractive,” “nice” as evaluative adjectives                                                                             | Remove; let the choice of question carry the interest.                            |
| Slash compounds: “experiment/measurement,” “hardware/software,” “and/or”                                                                 | Choose one word or write the exact relation.                                      |
| Parenthetical self-commentary in the body: “(read simplifying assumptions),” “(assuming of course that the proposed work is successful)” | Move to a footnote or delete.                                                     |
| “Finally,” “Furthermore,” “However” used as paragraph glue                                                                               | Name the logical relation (see Continuity).                                       |
| Restating a definition's content in prose immediately after the definition                                                               | Keep the definition; keep only the interpretation that the display does not show. |
| Doubled reference commands: “Equation Equation (2.11),” “Figure Figure 2.1”                                                              | Repository cross-reference macro, once.                                           |
| A question posed and immediately answered by the next sentence                                                                           | Merge into one declarative sentence.                                              |

### Voice and Person

- Use **we** for mathematical exposition (definitions, proofs, derivations).
- In running prose, use **I** only for explicit personal contribution claims. The
  authorial-signature convention permits `I` in footnotes about notation decisions, attribution
  asides, and history.
- Prefer active voice unless the actor is irrelevant.
- Use present tense for mathematical facts and past tense for completed experiments or
  implementations.

### British English, Grammar, and Punctuation

Use British English throughout authored prose. The house spelling uses `-ise` and `-isation`:
`analyse`, `characterise`, `generalise`, `optimise`, and `regularisation`. Use British forms such as
`behaviour`, `centre`, `colour`, `labelled`, `modelling`, and `travelling`.

Preserve the original spelling of proper names, publication titles, direct quotations, software
interfaces, code, file paths, and bibliography fields. Use `program` for computer software and
`programme` for a planned sequence of work. Distinguish `practice` (noun) from `practise` (verb),
and `licence` (noun) from `license` (verb). Treat `data` as plural in formal thesis prose; use
`dataset` when a singular collective noun is intended.

#### Sentence Grammar

- Write complete sentences except in headings, table cells, labels, and deliberately parallel list
  items.
- Make the grammatical subject explicit and keep it close to its verb.
- Maintain subject–verb agreement, including after long mathematical phrases.
- Ensure every pronoun has an unambiguous antecedent.
- Keep coordinated clauses and list items grammatically parallel.
- Avoid dangling modifiers. Ensure an introductory participial phrase modifies the grammatical
  subject of the following clause.
- Use `where` to introduce notation or a domain, and `if` or `when` to state a logical condition.
- Use `respectively` only when the pairing is immediate and unambiguous.
- Prefer `different from`, `fewer` for countable quantities, and `less` for continuous or mass
  quantities.
- Use `comprises` to mean “consists of”; do not write “is comprised of.”

#### Commas and Full Stops

- Use a full stop to close every prose sentence, including one that ends with a displayed equation.
- Use the serial comma in a list of three or more items.
- Use commas to separate introductory material and non-essential clauses when they aid parsing. Do
  not separate a subject from its verb.
- Do not join independent clauses with a comma. Use a full stop, semicolon, or conjunction.
- Keep restrictive material unpunctuated; enclose genuinely parenthetical material with paired
  commas.
- Place commas and full stops outside quotation marks unless they belong to the quoted material.

#### Colons, Semicolons, Dashes, and Parentheses

- Use a colon after a complete clause to introduce an explanation, list, or formal statement. Do not
  insert a colon merely because a display follows.
- Use a semicolon between closely related independent clauses or to separate list items that already
  contain commas. Prefer a full stop when the relation is not immediate.
- Use a hyphen for an established compound or a compound modifier before a noun, as in
  `spatio-temporal model` and `finite-sample bound`. Do not hyphenate an `-ly` adverb and its
  adjective.
- Use an en dash for ranges and symmetric relations, and an em dash sparingly for a genuine
  interruption. Follow the repository's LaTeX source convention for producing these marks.
- Use parentheses for secondary information, not for assumptions or qualifications required by the
  argument. Avoid nested parentheses.
- Avoid slashes in prose when `and`, `or`, or a more exact relation is meant.

#### Quotations, Capitalisation, and Abbreviations

- Use the project's semantic quotation command rather than typing quotation marks directly. Apply
  British logical punctuation: punctuation belongs inside the quotation only when it forms part of
  the quoted material.
- Capitalise formal named objects only when the name is part of the title or the project convention
  requires it. Use lowercase for generic references to a theorem, model, section, or method.
- Prefer `for example`, `that is`, and `namely` in running prose. Use `e.g.` and `i.e.` sparingly
  and punctuate them consistently.
- Define an abbreviation at first substantive use, using the configured glossary commands where
  applicable, unless it is standard for the intended readership.

### Tone

- Keep language formal and technical.
- Prefer precise claims over vague emphasis.
- Mark uncertainty explicitly (`suggests`, `indicates`, `does not imply`).
- Keep terminology stable; reuse glossary-backed terms consistently.
- Preserve intellectual curiosity through the choice and sequence of problems, not through
  rhetorical questions or conversational asides outside the chapter-opening guiding-question list.
- Outside that chapter-opening list, convert questions into objectives or claims. Prefer “We
  determine whether temporal replication improves the rate” to “Can time help convergence?”
- Do not carry prompting questions, chat instructions, or provisional objections into finished
  prose. Resolve the issue, then state the supported conclusion in the document's own voice.
- Avoid autobiographical commentary in running prose. Use `I` there only for an explicit personal
  contribution claim; state routine modelling and implementation choices in the expository voice.
  The footnote exception remains limited to the authorial-signature purposes stated above.

### Structure and Flow

- Start each chapter with a brief orientation paragraph.
- Start each section with its local objective.
- End a section by stating what its result enables when a transition helps the argument. Do not
  append a formulaic roadmap to every short section.
- Avoid one-subsection sections unless unavoidable.
- Write headings in Title Case: capitalise important words, while leaving short function words
  lowercase unless they begin the heading.
- Organise by the reader's scientific dependency order rather than by the chronology of discovery or
  implementation.
- Keep the primary argument in the chapter and technical support in the appendix. The main text must
  remain intelligible without reproducing the proof.
- Return to the motivating scientific problem after an abstract development. State how the new
  result changes modelling, inference, prediction, or computation.

Recommended chapter rhythm:

1. Motivation.
1. Setup and assumptions.
1. Core theory/model/algorithm.
1. Implications or computation.
1. Scientific synthesis and transition, when needed.

A chapter-level synthesis or the thesis's final synthesis may connect distinct results and answer
the motivating question. Avoid routine section summaries that only repeat preceding claims; this
restriction does not remove a substantive synthesis or a required institutional component.

For methodological chapters, use the more specific dependency chain when it fits:

1. Domain and scientific target.
1. Latent and observation models.
1. Representation and construction.
1. Statistical properties and identifiability.
1. Inference and computation.
1. Approximation or asymptotic regime.
1. Scientific interpretation and transition.

### Appendix Style

A technical appendix that accompanies a substantive chapter is a formal record, not a second
exposition of the chapter. Write it in a terse, matter-of-fact style. Begin with any
appendix-specific notation or assumptions that are strictly necessary, then proceed directly through
the required formal statements.

Use only the structure needed by the mathematics:

1. Assumption, definition, or assertion.
1. Lemma or proposition.
1. Theorem or corollary.
1. Proof.

The order follows logical dependence; not every sequence requires every type of statement. Each
formal result must remain complete: include its objects, domains, quantifiers, assumptions,
conclusion, attribution, and proof or exact proof reference.

Identify whether an assertion is assumed, established in the appendix, or quoted from a source. An
assertion label does not replace a proof obligation.

For chapter-accompanying appendices:

- State results and proofs directly.
- Use transitions only to record mathematical dependence, such as “By the preceding theorem” or
  “Applying the preceding lemma.”
- Omit motivation, historical discussion, rhetorical questions, previews, summaries, and repeated
  interpretations from the chapter.
- Do not restate the chapter's scientific narrative. Cross-reference the corresponding chapter
  statement when needed.
- Keep proof commentary limited to the argument's structure or a non-obvious justification.
- End when the required assertion has been established; do not add a general concluding paragraph.

An **introductory appendix chapter** is the exception. When an appendix chapter introduces
background, notation, or a self-contained theory needed by several chapters, it may use ordinary
expository prose, orientation, interpretation, and transitions. Keep that exposition subject to the
same minimalist standard as the main thesis.

### Main Text and Appendix Registers

The thesis uses two registers. The difference is not one of rigour; both are exact. The difference
is how much the reader is told about why.

| Aspect                        | Main chapter                                       | Chapter-accompanying appendix         |
| ----------------------------- | -------------------------------------------------- | ------------------------------------- |
| Purpose                       | Argue the scientific case                          | Record the formal support             |
| Opening                       | Problem, use case, data delivery                   | Notation and standing assumptions     |
| Physical picture              | One, at the point of abstraction                   | None                                  |
| Interpretation after a result | When the meaning is not immediate                  | None; cross-reference the chapter     |
| Transitions                   | Named dependencies between paragraphs and sections | “By the preceding lemma,” or none     |
| Footnotes                     | Notation decisions, asides, history                | Locators and attribution only         |
| Remarks                       | Side branches that aid the reader                  | Only a needed caution on a hypothesis |
| Voice                         | `we`, with `I` for contribution claims             | `we`, or impersonal                   |
| Ending                        | The consequence for the next dependency            | The last required assertion           |
| Sentence rhythm               | Varied; conversational without asides              | Uniform and declarative               |

When a main-chapter result needs interpretation, a bare record of facts is incomplete. A
chapter-accompanying appendix should not acquire a second exposition. Move interpretation to the
main chapter when needed, retaining only necessary formal support in the appendix. The
introductory-appendix exception remains applicable.

### Minimalist Scientific Prose

Minimalism means compression without loss of mathematical or scientific content. It does not mean
removing assumptions, qualifications, interpretation, or proof obligations.

- Put the governing claim early. Do not delay it with a long historical or motivational preamble.
- Prefer one strong sentence to two sentences that repeat the same claim in different words.
- Use the shortest familiar term that remains exact. Define a specialised term only when it carries
  work later.
- Remove throat-clearing phrases such as “it is interesting to note,” “we take the time to,”
  “generally speaking,” and “it should be mentioned.”
- Remove repeated roadmaps, repeated summaries, and conclusions already stated by a displayed
  equation.
- Avoid strings of parenthetical remarks. Integrate necessary qualifications into the sentence; move
  secondary detail to a note or appendix.
- Prefer direct verbs: “defines,” “implies,” “estimates,” “restricts,” and “approximates.” Avoid
  noun-heavy phrases such as “provides an estimation of.”
- Use a list only for genuinely parallel items. Use prose when the items form an argument.
- Keep local notation no richer than the result requires. Reuse canonical symbols instead of
  introducing temporary synonyms.
- Retain a sentence only if it defines, assumes, claims, supports, interprets, contrasts, or
  transitions. Revise or delete sentences with no clear role.

Aim for short paragraphs, not uniformly short sentences. Vary sentence length to preserve rhythm,
but keep the logical subject close to its verb. A dense technical sentence may remain when splitting
it would obscure a single mathematical dependency.

#### Fluff Removal

Fluff is any word, phrase, or sentence whose removal leaves the argument's claims, assumptions, and
dependencies intact. The test is deletion: delete it, reread, and restore it only if a claim became
weaker or a dependency disappeared.

Apply the deletion test to the following forms and remove them when they add no meaning. Preserve a
defined technical use, a necessary qualification, or an actual logical relation:

- announcements of intent: “in this section we will,” “we now turn to,” “let us consider,” “in what
  follows,” “before proceeding,” “it is time to”;
- evaluations of the material: “interesting,” “important,” “key,” “crucial,” “fundamental,”
  “elegant,” “natural,” “powerful,” “rich,” “subtle,” unless the sentence then states what makes it
  so;
- reassurances: “it is easy to see,” “it is well known,” “clearly,” “obviously,” “trivially,” “as
  expected,” “not surprisingly”;
- softeners with no content: “essentially,” “basically,” “somewhat,” “rather,” “quite,” “fairly,” “a
  bit,” “kind of,” “in some sense”;
- quantity vagueness: “a number of,” “various,” “numerous,” “a wide range of,” “many,” when the
  count or the class can be named;
- empty prepositional scaffolding: “in order to” (write “to”), “in terms of,” “with respect to” when
  a possessive suffices, “the fact that,” “due to the fact that” (write “because”), “in the context
  of,” “in the case of”;
- repeated subject: a paragraph that begins three sentences with “The covariance function” when a
  pronoun or a subordinate clause chains them;
- restatement: a sentence that says in words what the preceding display already shows, or a closing
  sentence that repeats the opening claim;
- borrowed enthusiasm: “promising,” “exciting,” “remarkable,” “dramatic.”

Replace rather than delete:

- “There is a result that shows” becomes the result.
- “It should be mentioned that X” becomes “X.”
- “X is said to be Y” becomes “X is Y” unless the terminology itself is the point.
- “We can see that X” becomes “X” with the reason if one is needed.
- “This means that” becomes the consequence stated with its own subject.

Minimal is not terse. A minimal paragraph keeps its interpretation, its physical picture, and its
stated assumptions. It loses only the words that were standing between the reader and those things.

#### Continuity at Three Scales

Build continuity from named dependencies across sentences, paragraphs, sections, and chapters. The
patterns below guide logical order; they do not require every unit to use the same opening or
ending.

**Sentence to sentence.** Where the dependency benefits from this order, open with something already
established (the previous sentence's object, result, or condition) and end with the new thing. Known
information leads; new information trails. Chain by repeating the key noun or by a pronoun with an
unambiguous antecedent, not by “however,” “moreover,” or “in addition.” If a sentence has no content
connection to its predecessor, inspect its order and paragraph placement.

The following illustrates sentence structure, not a stand-alone regularity theorem; the actual
result must supply its model assumptions and conditions.

> Weak: The spectral density satisfies the theorem's decay condition. Moreover, the theorem gives a
> sample-path regularity bound. Furthermore, that bound depends on the decay rate.
>
> Chained: The spectral density satisfies the theorem's decay condition. Under its remaining
> assumptions, that decay rate determines the stated sample-path regularity bound.

**Paragraph to paragraph.** The first sentence of a paragraph names its dependence on the previous
paragraph's result: the object it inherits, the condition it now relaxes, or the consequence it now
draws. The last sentence of a paragraph is the paragraph's own conclusion, not a preview of the
next. If the connection cannot be stated, inspect paragraph order and whether a necessary reasoning
step is missing.

> The integrability condition gives existence of the field. Existence alone does not fix regularity,
> which requires the high-frequency behaviour of the same density.

**Section to section.** A section closes by stating what its result enables (when the transition
helps the argument) and the next section opens with its local objective. The two sentences should
read as one dependency when placed side by side; if they do not, inspect the section boundary and
any missing dependency. Do not add a roadmap paragraph, a “Summary” subsection, or a sentence of the
form “Having established X, we now turn to Y.”

**Within a chapter.** Return to the chapter's use case at each point where a new result changes the
model, the estimand, or the computation, with the same name and notation each time. The recurring
example is the reader's thread through the abstraction.

Continuity check: read only the first sentence of every paragraph in a section. If the sequence
makes a coherent argument on its own, the section is continuous. If it reads as a list of topics,
rewrite the openings as dependencies.

### Lists and the Rule of Three

Prose is the default. Bullet points are a navigation device, not a substitute for connected
scientific reasoning.

- Use bullets for parallel alternatives, requirements, inputs, outputs, or checks that a reader may
  need to scan independently.
- Use a numbered list only when order, priority, or dependency matters.
- Use a table when several methods or objects are compared across the same attributes.
- Use sentences and paragraphs for causation, qualification, interpretation, and argument.
- Do not place every sentence in a list, create a one-item list, or nest lists when a short
  paragraph is clearer.
- Introduce a necessary list with a sentence that states its organising idea. Add a conclusion only
  when the items support a further inference that needs stating.

Use the **rule of three** selectively. Three parallel terms, sentences, or clauses often give an
argument a clear and memorable shape. Prefer three-part groupings for high-level framing when the
content naturally supports them—for example, mathematical validity, statistical validity, and
computational validity.

Do not force material into three parts. Scientific completeness and logical structure take
precedence. If there are two genuine cases, state two; if there are five required assumptions, state
five. Use the rule of three to shape emphasis and rhythm, not to omit, duplicate, or invent content.

### Negative Claims and Prompt Residue

Treat negative and nonexistence claims as substantive assertions requiring evidence. A failed
search, missing implementation, incomplete proof, or prompting question does not establish that a
method, result, or connection does not exist.

- Verify the scope before writing “no,” “none,” “cannot,” “does not exist,” “has not been studied,”
  or an equivalent universal negative.
- Match the claim to the evidence. Prefer “We did not identify such a result in the sources
  reviewed” to “No such result exists” when the review is not exhaustive.
- Distinguish “not proved here,” “not implemented in this repository,” “not identifiable under these
  assumptions,” and “outside the present scope.” These statements make different claims.
- Do not adopt a negative premise merely because a prompt asks what is wrong, missing, impossible,
  or unsupported. First determine whether the premise is true.
- Remove negative claims that exist only as residue from drafting or prompt history. State the
  positive scope, supported limitation, or required condition instead.
- Preserve a negative result when it is mathematically or scientifically important, but state its
  assumptions, domain, and evidentiary basis.

The same rule applies to contrasts. Describe what each method establishes and where its assumptions
differ; do not manufacture a weakness merely to motivate the preferred method.

### AI-Assisted Review

AI review must preserve and strengthen the author's established style. Its role is editorial:
clarify the argument, identify omissions or inconsistencies, and improve local expression without
replacing the authorial method with a generic voice.

Preserve the systems-first structure, layered exposition, mathematical precision, restrained tone,
and movement from result to interpretation to implementation. Retain characteristic phrasing and
sentence rhythm when they are clear and correct. A revision should sound like a more exact version
of the author, not like a different author.

#### Review Constraints

- Preserve mathematical meaning, scope, notation, attribution, and logical order unless the task
  explicitly authorises a substantive change.
- Make the smallest revision that resolves the identified problem. Do not rewrite an entire passage
  to correct one sentence.
- Augment an incomplete explanation by connecting it to the existing argument; do not replace the
  argument with a generic textbook summary.
- Retain deliberate technical detail. Compression must not remove assumptions, boundary cases, proof
  obligations, statistical meaning, or computational conditions.
- Do not invent claims, citations, terminology, examples, contributions, or negative results.
- Flag a suspected mathematical error or ambiguous claim for verification when it cannot be
  corrected from the available evidence.
- Preserve the distinction between main-chapter exposition, formal appendices, and introductory
  appendix chapters.
- Apply British English and the local notation, citation, cross-reference, and LaTeX conventions.

#### Editorial Patterns to Remove

Remove or avoid the following patterns unless the argument genuinely requires them:

- generic openings that announce that a topic is important, complex, rapidly evolving, or widely
  applicable without adding a specific claim;
- inflated adjectives such as `crucial`, `pivotal`, `groundbreaking`, `powerful`, `robust`,
  `seamless`, and `comprehensive` when no stated evidence supports them;
- stock verbs and metaphors such as `delve`, `unpack`, `navigate the landscape`, `unlock`,
  `leverage`, `shed light on`, and `underscore`;
- canned contrasts such as “not merely X but Y”, “not only X but also Y”, or “this is more than X”
  when a direct statement is stronger;
- formulaic topic sentences, repeated mini-summaries, and a concluding sentence that simply restates
  the paragraph;
- excessive headings, bullet lists, bold labels, parenthetical remarks, em dashes, and three-part
  constructions;
- artificial symmetry that gives unequal ideas equal weight or forces every method into the same
  paragraph pattern;
- vague references such as “this approach”, “these findings”, or “the above” without a named
  referent;
- false balance, invented limitations, or negative assertions introduced only to create a
  transition;
- generic concluding claims about future impact, broader significance, or real-world relevance that
  are not established by the chapter;
- excessive transition words, especially repeated `however`, `furthermore`, `moreover`, and
  `therefore`;
- unnecessary assurances that a method is clear, rigorous, novel, efficient, or interpretable
  instead of demonstrating the relevant property.

##### Additional Lexical Traps

Treat the following as local style-review targets, regardless of authorship. Remove empty or
unearned uses after the deletion test; retain a precise technical meaning, supported claim, or
necessary logical relation. These words do not identify AI authorship and are not an automatic
blacklist:

- sentence-initial adverbs of emphasis: `Importantly,` `Notably,` `Crucially,` `Interestingly,`
  `Specifically,` `Overall,` `Ultimately,` `Essentially,` `Fundamentally,`;
- verbs of vague agency: `serves as`, `acts as`, `plays a role in`, `contributes to`, `facilitates`,
  `fosters`, `enables`, `ensures`, `highlights`, `showcases`, `captures`, `encapsulates`, `informs`;
- container nouns: `framework`, `landscape`, `paradigm`, `realm`, `lens`, `tapestry`, `journey`,
  `toolkit`, `building block`, `cornerstone`, unless the word is a defined technical term in the
  thesis;
- doubled hedges: `may potentially`, `could possibly`, `it is possible that ... may`;
- stacked adjectives before a technical noun: “a flexible, scalable, and interpretable model”;
- `a key`, `a critical`, `a vital`, `a central` before a noun that the sentence does not then
  justify;
- `it is important to note`, `it is worth noting`, `it should be emphasised`;
- the pair `not X, but rather Y` and the pattern `X is not just Y; it is Z`;
- `in today's`, `in the modern era`, `in recent years` as openers;
- `Firstly`, `Secondly`, `Lastly` in prose where the order is not the point;
- `respectively` more than once in a paragraph;
- `the reader` or `one` used to avoid `we`;
- `let us` and `let's`;
- `robust`, `rich`, `elegant`, `principled`, `unified`, `holistic`, `nuanced`, `comprehensive` as
  unearned praise;
- `delve`, `dive into`, `explore`, `unpack`, `navigate`, `leverage`, `harness`, `unlock`,
  `shed light`, `pave the way`, `bridge the gap`, `underscore`, `foster`, `bolster`, `hinge on`
  (except in a genuine dependence statement), `stand as a testament`;
- `arguably` and `perhaps` used to avoid committing to a claim that the evidence supports.

##### Structural and Rhythmic Traps

Review these patterns in context because word searches cannot assess their argumentative role. They
can weaken the intended authorial cadence, regardless of whether a human or an AI system drafted the
passage:

- uniform paragraph length, with every paragraph of four to six sentences;
- every paragraph shaped as topic sentence, three supporting sentences, and a concluding sentence;
- every paragraph ending with a consequence or implication;
- triadic sentence rhythm repeated across a section (“X. Y. And Z.”);
- lists of exactly three examples whenever examples are given;
- a definition offered for every standard term, including terms the intended reader knows;
- balanced antithesis in consecutive sentences (“While A, B. Although C, D.”);
- a `Summary` or `In summary` paragraph at the end of every section;
- headings that are complete sentences or noun phrases ending in a colon;
- bold lead-ins on bullet items (`**Domain:**`) outside this guide and reference tables;
- em dashes in pairs within a single sentence, or more than one em dash per paragraph;
- colons introducing lists of noun phrases where a sentence was needed;
- alternating short and long sentences in a mechanical pattern;
- symmetrical `advantages` and `limitations` blocks for every method;
- a first-person plural verb of promise in every section opening (“we present,” “we introduce,” “we
  propose”);
- a sentence that names its own rhetorical function (“This section establishes,” “The following
  result shows”) rather than performing it;
- a concluding claim of generality that no result in the section earned;
- an example that is generic (“consider a temperature field”) when the thesis already has a named
  use case with real data;
- a limitation acknowledged and immediately dismissed in the same sentence.

##### Cadence and Authorial Review

Read expository passages aloud at speaking pace. Preserve the author's variable cadence and place a
concrete image or plain assessment where the argument needs it. If three consecutive paragraphs have
the same shape, inspect and revise the mechanical repetition while preserving the argument. Check
that a section contains specific knowledge of the actual experiment, proof, or source where its
purpose calls for that knowledge; do not invent details to create an authorial effect. Uniform
declarative rhythm remains appropriate in formal appendices. Cadence is a style check, not an
AI-authorship test.

Finished prose must not expose the prompt or the editing conversation. Omit phrases such as “as
requested”, “the user asked”, “this revised section”, or references to earlier drafts unless the
document itself is a revision report.

Apply the Revision Sequence below while preserving the passage's scientific role, claims,
dependencies, and authorial features. Correct problems locally, add only what completeness requires,
and remove the identified editorial patterns. The final revision must retain Philip Jones's
recognisable authorial method while improving precision.

### Transitions

Transitions should expose logical dependence rather than announce document movement. Prefer a
compact backward link plus a forward consequence:

> The spectral condition establishes existence. Under the regularity theorem's assumptions, its
> high-frequency behaviour also determines the stated sample-path regularity bound.

Choose the transition according to the relation:

| Relation              | Preferred form                                                                                    |
| --------------------- | ------------------------------------------------------------------------------------------------- |
| Consequence           | “Therefore,” “Thus,” or an explicit subject and verb                                              |
| Contrast              | “By contrast,” “whereas,” or “however”                                                            |
| Restriction           | “Under fixed-domain asymptotics,” or the relevant condition                                       |
| Extension             | “The multivariate case replaces … with …”                                                         |
| Representation change | “In the spectral representation, the condition becomes …”                                         |
| Return to application | “For the observation model, this implies …” or “In the North Atlantic use case, this condition …” |
| Next dependency       | “This bound supplies the error term used in …”                                                    |

Do not use “next,” “as stated above,” or “below we discuss” when the logical relation can be named.
Avoid stacking transition words. One clear relation is enough.

### Paragraph Style

- Give each paragraph one main argumentative purpose.
- Establish the necessary context, then develop the claim in logical order.
- Split a paragraph when it begins to perform a second argumentative task.
- Resolve pronoun ambiguity (`this`, `that`, `it`, `they`).
- When using `this`, name the referent: “this integrability condition,” “this estimator,” or “this
  approximation error.”
- Keep literature review inside the argument. Synthesise sources around a claim or methodological
  choice rather than summarising papers one at a time.
- End when the paragraph's purpose is complete. Add a consequence or transition only when it
  advances the argument.

### Mathematical Prose

- In expository passages, introduce objects conceptually before symbols.
- Use formal environments for core definitions.
- State assumptions before dependent results.
- In expository passages, surround important equations with the explanatory prose needed to
  establish their role.
- Treat equations as sentence components and punctuate accordingly.
- In expository passages, state why a central definition is introduced and which later result uses
  it when that role is not immediate.
- In expository passages, interpret a central formula's important terms, limiting behaviour, or
  statistical role when the meaning is not already immediate. Do not narrate algebra that the
  notation already shows.
- Define symbols at first substantive use and keep domains and dimensions visible when ambiguity is
  possible.
- Distinguish the model definition from a convenient parameterisation and from its numerical
  implementation.
- Use remarks for consequences, cautions, or connections that materially aid the reader. Do not use
  them as storage for unfinished thoughts.

### Scientific Methodology

A methodology section must permit the reader to reconstruct both the model and the analysis. State,
in the order required by the argument:

- the scientific target and unit of analysis;
- the domain, sampling design, and observed variables;
- the latent process and observation model;
- parameter meanings, constraints, and identifiable combinations;
- the objective, likelihood, posterior, or estimating equation;
- the computational representation and solver;
- approximation assumptions, tolerances, and diagnostics; and
- the inferential or predictive output and its uncertainty.

Separate three kinds of validity:

- **Mathematical validity:** existence, positive definiteness, well-posedness, or other structural
  conditions.
- **Statistical validity:** identifiability, calibration, consistency, and the sampling or
  asymptotic regime.
- **Computational validity:** discretisation error, convergence, conditioning, reproducibility, and
  numerical diagnostics.

A result in one category does not establish the others. State the connection when a theorem,
experiment, or diagnostic supports more than one category.

For reported computational or empirical results, identify the data and preprocessing, software
versions, configuration, random seeds where applicable, hardware when performance is claimed,
evaluation metrics, and the commands or workflow needed to reproduce the analysis. Link these
details to the reported outputs.

### Comparisons and Method Selection

Compare methods on decision-relevant axes: assumptions, estimand, domain, identifiability, accuracy,
computational cost, scalability, and failure modes. State the setting in which a method is
preferable; avoid declaring one method universally “best.”

When introducing several methods, first state the common problem they solve. Use a table for exact
parallel comparisons and prose for the resulting choice. End with the consequence for the thesis
model or use case.

### Examples and Use Cases

Examples are part of the argument, not decorative interruptions. Each example should identify:

1. the scientific question and observed data;
1. the domain and model components;
1. why the selected representation or method is appropriate; and
1. what the result means scientifically.

Introduce a running example early when it reduces abstraction. Revisit it only when the new theory
changes the model, computation, or interpretation. Keep exploratory alternatives out of the main
line unless they support a stated comparison.

Refer back to an established practical example or use case when it materially clarifies a
theoretical point. The reference should identify the exact connection: which assumption the data
satisfy, which parameter the theorem governs, which representation the implementation uses, which
sampling regime applies, or which empirical result illustrates the consequence. Prefer a short
sentence at the point of relevance over a detached example paragraph.

Use the practical reference as a logical transition from theory to scientific meaning. The following
is a conditional illustration of the supplied guide's North Atlantic example, not a claim that
fixed-domain sampling alone establishes nonidentifiability or that a particular analysis was
verified:

> Under the stated model assumptions and fixed-domain regime, this result establishes that the
> variance and range are not separately identifiable. For a North Atlantic analysis satisfying those
> assumptions, the infill ladder should report the corresponding microergodic combination rather
> than interpret the two estimates independently.

Maintain continuity when a use case recurs. Use the same name, notation, estimand, and stated data
limitations each time. Do not introduce a new example when an existing thesis use case already
supplies the required illustration. Do not force an application reference when it adds no
interpretation or merely repeats a chapter summary.

### Results, Proofs, and Evidence

- State a result's objects, domains, quantifiers, assumptions, and conclusion together. Distinguish
  sufficient conditions from necessary ones.
- In the main chapter, explain the proof's main idea before a long derivation. In a
  chapter-accompanying appendix, proceed directly through the proof. In either location, name the
  assumption or prior result used at a nontrivial step; a citation cannot supply an unstated
  hypothesis.
- If a proof belongs in an appendix, keep a self-contained statement and an explicit proof reference
  in the main chapter. Separate intuition from proof.
- Mark a result as quoted, adapted, derived here, or conjectured as appropriate. Describe what
  changed in an adaptation, including assumptions and notation.
- Distinguish exact identities, asymptotic statements, approximations, and empirical observations.
  Specify the limiting regime or approximation error when a claim depends on it.
- For empirical claims, give the relevant data scope, comparison, uncertainty, and computational
  conditions. Numerical agreement supports a diagnostic claim; it does not by itself prove a theorem
  or universal stability result.
- In expository passages, follow important results with a short interpretation when their
  statistical meaning is not immediate: state what changes with the parameters, which regime
  matters, and what the reader may infer.
- For asymptotic results, name the regime—fixed, increasing, or mixed domain—and state what grows,
  what remains fixed, and which parameters or combinations are estimable.
- For finite-sample results, state the probability level, effective sample size, dimension or
  sparsity dependence, and the practical implication of the bound.

### Cross-Reference Style

- Integrate references into sentences.
- Keep references as unobtrusive as possible: use them to support the sentence, not to dominate it.
- Use part-level references for roadmap context and chapter/section references for detail.
- When theory is instantiated by a thesis use case, cite the exact use-case section, figure, table,
  or appendix record that demonstrates the connection.
- State the substantive link before the reference; do not write only “see the North Atlantic
  example” or “as shown in the application.”
- Avoid relative references like “above/below” without labels.
- Avoid reference-heavy single sentences.

### Figures and Tables in Prose

- Explain why the figure/table is shown before referencing it.
- Use self-contained captions with a takeaway, not only a description.
- State what the reader should notice in the text.

### Citation Style

- In LaTeX under the adopted citation profile, integrate citations into the sentence whenever
  possible by using `\textcite`.
- Place citations at clause boundaries where claims are made.
- Under that profile, use `\parencite` only when a parenthetical citation is more natural than a
  sentence-integrated one. Follow a publisher's required citation interface within its scope.
- Keep citations unobtrusive: prefer the least disruptive form that still gives clear attribution.
- Prefer coherent attribution over citation stacking.
- Distinguish standard literature, adaptations, and original contributions.
- Check a source's actual statement before attributing a result. Include a theorem, section, or page
  locator when it helps the reader verify the claim.
- Mark quotations and retain their locators. Paraphrase from understanding; changing a few words
  does not make borrowed wording original exposition.
- Cite datasets and software used to obtain a reported result, with versions where relevant. A paper
  describing an algorithm may not identify the implementation actually used.

### Revision Sequence

1. Argument and voice pass: preserve the authorial method, verify scientific dependency order, and
   remove side branches.
1. Correctness pass: verify definitions, assumptions, results, and evidence.
1. Interpretation pass: in expository passages, add the meaning of central formulas and results when
   it is not immediate.
1. Compression pass: apply the deletion test; remove repetition, filler, evaluative adjectives, and
   unnecessary notation.
1. Continuity pass: chain sentences by known-to-new order and name the logical relation between
   paragraphs and sections; run the first-sentence check.
1. Consistency pass: check terms, notation, citations, and cross-references.
1. Linear read-through: read as the intended scientific reader and remove any remaining generic AI
   phrasing.

### Writing Checklist

- Voice usage is consistent (`we` vs `I`).
- Chapter and section openings state scope clearly.
- In expository passages, central displayed equations are introduced and interpreted when their role
  or meaning is not immediate.
- Claims are evidence-backed and cited appropriately.
- Cross-references are label-based and specific.
- Terminology and glossary usage are consistent.
- British spelling, grammar, and logical punctuation are consistent.
- Paragraphs are single-purpose, with transitions where logical dependence needs to be stated.
- Result assumptions, attribution, and proof locations are explicit.
- Approximation, asymptotic, and empirical claims have the appropriate scope.
- New shared terms, notation, and sources follow the consuming project's recorded upstream
  contribution workflow.
- The scientific question appears before the machinery used to answer it.
- Domain, process, observation, parameter, and computational layers remain distinct.
- The smallest scientifically faithful case carries the main idea before extensions are introduced.
- Changes of mathematical view state what remains invariant and what becomes easier.
- In expository passages, central results receive a statistical or scientific interpretation when
  their meaning is not immediate.
- Theoretical claims refer back to an established practical example or use case when it clarifies an
  assumption, mechanism, estimand, regime, implementation, limitation, or consequence.
- Practical cross-references state the exact connection and point to the relevant use-case section,
  figure, table, or appendix record.
- Transitions name logical relationships rather than merely announcing the next section.
- Every retained sentence performs a clear argumentative role.
- Rhetorical questions outside the chapter-opening guiding-question list, conversational asides
  outside their permitted footnotes, repeated roadmaps, and residual drafting commentary have been
  removed.
- Bullet points are limited to genuinely parallel, independently scannable material; connected
  arguments remain in prose.
- Three-part structures reflect the content rather than forcing it.
- Universal negative claims are supported; bounded negative claims state their search, model,
  repository, or proof scope.
- Prompting questions and unsupported negative premises have not entered the finished document.
- AI review has augmented rather than replaced the author's voice, structure, and scientific method.
- Generic AI openings, inflated claims, canned contrasts, excessive formatting, and repetitive
  rhetorical patterns have been removed.
- Chapter-accompanying appendices contain only the formal material and minimal connective prose
  required by the mathematics.
- The author's own drafting habits listed under Authorial Signature have been removed, and the
  features to preserve are still present.
- The deletion test has been applied to every evaluative adjective and sentence-initial adverb.
- The first sentences of consecutive paragraphs, read alone, form a coherent argument.
- Expository paragraphs avoid three consecutive mechanically repeated shapes; formal appendices
  retain the declarative register. Routine sections have no appended summary paragraph. Substantive
  chapter and final syntheses remain.
- Each main chapter returns to its named use case where a result changes the model, estimand, or
  computation.
- Introductory appendix chapters are clearly identified before using the expository exception.

## Grammar and Academic Register

Use formal, precise language without inflated vocabulary. Prefer present tense for definitions,
mathematical statements, and what the manuscript shows; use past tense for completed experimental
procedures and observations where appropriate. Tense changes should reflect meaning, not a blanket
rule that every sentence must use one tense. Avoid dangling modifiers and make pronoun references
and subject-verb agreement clear.

Our default is plural agreement for observations ("the data are") and singular agreement for a
dataset ("the dataset is"). This is a house preference, not a claim that singular mass-noun "data"
is ungrammatical: [Merriam-Webster](https://www.merriam-webster.com/dictionary/data) recognizes both
constructions. Follow a venue's explicit preference consistently. Grammar tools offer suggestions;
authors must reject edits that alter scientific meaning, notation, quotations, or uncertainty.

## Mathematics

Use the [LaTeX mathematics standard](latex.md) for source syntax and environment selection; notation
and disciplinary font choices are not universal LaTeX requirements.

- Treat displayed mathematics as part of the surrounding sentence and punctuate it accordingly.
- Define every nonstandard symbol and specify dimensions, domains, and indexing ranges when
  ambiguity is possible.
- Use semantic LaTeX commands from the shared packages for recurring operators; do not reproduce a
  visual effect with ad hoc spacing or font commands.
- Use `\label` and `\zcref` under the house `zref-clever` profile (`\zcref[S]` at sentence starts).
  Follow the [LaTeX cross-reference standard](latex.md) for setup and publisher overrides. Do not
  write hard-coded equation, figure, table, theorem, or section numbers.
- Reserve a symbol for one meaning within a document. If a local exception is unavoidable, state it
  explicitly.

Introduce what a formula expresses before using it and interpret the consequence afterward when
needed. A derivation must show or identify the justification for nontrivial steps. Distinguish a
definition from an equality requiring proof and a theorem from an empirical observation. Examples
illustrate claims; they do not prove a general statement. Keep assumptions close enough that the
reader can assess applicability without searching unrelated chapters.

Develop the smallest scientifically faithful case before extending it. State which parts of the
argument survive an extension and which assumptions change; do not remove the dimension, dependence,
or observation feature that carries the question. When changing mathematical views or
representations, name the invariant object, the correspondence, the benefit, and any changed
assumptions or loss of information. A stochastic object, its parameterization, and its numerical
implementation are distinct.

State a result's objects, domains, quantifiers, assumptions, and conclusion together. Distinguish
necessary from sufficient conditions and label quoted, adapted, original, and conjectured results.
Explain changed assumptions or notation in an adaptation. Keep a self-contained statement and an
exact proof reference in the main text when the proof is elsewhere. A citation cannot supply an
unstated hypothesis.

For asymptotic results, name the regime, what grows, what remains fixed, and which parameters or
combinations are estimable. For finite-sample bounds, state the probability level, effective sample
size, dimension or sparsity dependence, and practical consequence. Distinguish identities,
approximations, asymptotic statements, and empirical observations; specify approximation error or
limiting conditions where the claim depends on them.

Use an established practical example at the point where it clarifies an assumption, parameter,
representation, sampling regime, limitation, or consequence. State the exact connection before a
specific section, figure, table, or appendix reference. Keep its name, notation, estimand, and data
limitations consistent. Do not introduce another example or narrate every symbol when neither adds
meaning. Adapt interpretation and proof commentary to the document's expository or formal register.

## Citations And Attribution

- Cite the primary source for a theorem, dataset, method, or software artifact when it is available.
- Place citation metadata in the shared bibliography rather than hand-writing author, title, or year
  strings in prose.
- Use a stable bibliography key from `bibliography/`; do not create a local duplicate of a shared
  record merely to change presentation.
- Mark quotations as quotations and include a locator when the source provides stable pages,
  sections, or theorem numbers.

Check that each cited work supports the attached statement, not merely that its DOI resolves.
Distinguish a primary source, a review, a tutorial, and personal communication. Cite the version
actually used, and record limitations when only an abstract or secondary account was available. Do
not invent a reference, locator, result, or quotation. An uploader is not automatically an author.
Credit borrowed ideas and adapted illustrations; attribution does not itself establish permission to
reuse material. Follow [bibliography](bibliography.md), [images](images.md), and
[validation](validation.md) for the respective records and checks.

Use the [similarity review](#manuscript-similarity-review) when screening a manuscript. Similarity
scores are review aids, not plagiarism verdicts or universal submission thresholds. Review
attribution, quotations, paraphrases, and reuse of your own published work in context.

Select references for relevance, support, and proper credit, including foundational and contrary
work. Do not pad references, prefer recency regardless of relevance, or cite to appease reviewers or
increase citation counts. Choose a journal for scope, readership, policies, and suitability; the
journal cited most often is a candidate, not an automatic destination. Citation counts and journal
metrics are not substitutes for assessing the work itself.

### Authorship and Contributions

Agree contribution records, authorship criteria, and author-order conventions early and revisit them
before submission. Apply the venue's policy; do not assume name order universally ranks contribution
or seniority. Where ICMJE criteria apply, all four requirements must be satisfied, including
qualifying contributions, intellectual drafting/review, approval, and accountability. Credit
non-author contributions appropriately and obtain acknowledgement consent where required. Neither
routine work nor intellectual input should be handled by an automatic inclusion/exclusion rule
detached from the policy. See
[ICMJE's criteria and contributor guidance](https://www.icmje.org/recommendations/browse/roles-and-responsibilities/defining-the-role-of-authors-and-contributors.html).

Human authors remain responsible for AI-assisted material. Verify citations, numbers, quotations,
and technical claims independently; never treat generated text as evidence. Record material tool
assistance and follow the target venue's current disclosure policy. Do not expose confidential
manuscripts or data to external services without appropriate authorization. AI is not an accountable
co-author; see [COPE's authorship position](https://doi.org/10.24318/cCVRZBms).

## Numbers, Units, And Code

- Use SI units by default and let a semantic unit command such as those provided by `siunitx` handle
  quantity spacing, including special conventions for plane-angle symbols.
- Use numerals for measured values, dimensions, versions, and identifiers.
- Format code identifiers, filenames, commands, and literal field names as code in Markdown and with
  an appropriate semantic command in LaTeX.
- Report enough precision to support the claim; do not imply precision that the data or method does
  not provide.

## Project Overrides

A consuming repository should record overrides in its own standards document. An override must name
the external requirement or local reason, define its scope, and take precedence only within that
scope. Unstated local habits do not override these shared defaults.

## Do and Don't Checklist

These pairs are review prompts, not automated word bans. Examples are illustrative, not study
results.

| Do                                                                         | Don't                                                                                 |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| State the reader's task or the paper's contribution early.                 | Begin with generic claims that the field is important.                                |
| Keep conditions with claims: "The method converged on these test cases."   | Inflate this to "The method always converges."                                        |
| Give a precise comparison and its evidence.                                | Write "vastly superior" without a comparator or metric.                               |
| Remove filler while retaining limits and exceptions.                       | Delete uncertainty to make the abstract sound decisive.                               |
| Explain a necessary technical term once and reuse it consistently.         | Replace precise terminology with misleading simplifications or decorative synonyms.   |
| Separate findings, interpretations, and proofs.                            | Present a plausible explanation as an observed fact.                                  |
| Show important negative evidence and explain its bearing.                  | Hide inconvenient runs or undocumented exclusions.                                    |
| Use captions and cross-references to connect figures to the argument.      | Repeat every table cell in prose or leave a figure unexplained.                       |
| Test procedures and record their environment and outcome.                  | Declare instructions correct because formatting or syntax checks pass.                |
| Ask for expert and intended-reader review.                                 | Assume clear prose proves technical correctness, or expertise guarantees readability. |
| Address reviewer comments individually with evidence and change locations. | Agree mechanically, argue personally, or claim changes that were not made.            |
| Maintain shared rules once and record scoped overrides.                    | Copy standards into several repos and let them drift silently.                        |

## End-to-End Writing Workflow

Use these stages as a working method, not as evidence that any manuscript has completed review.

### 1. Establish the Brief

Record the following in the project's normal issue, outline, or planning document:

```text
Document and owner:
Reader and prerequisites:
Question/task and intended outcome:
Contribution or decision supported:
In scope / out of scope:
Venue, format, length, and required disclosures:
Canonical glossary, notation, bibliography, and asset revision:
Evidence/code/data locations and known gaps:
Technical reviewer and intended-reader reviewer:
Acceptance checks and review date:
```

Verify current venue instructions before choosing a template. Do not invent an audience profile or
present an untested assumption as established. For a thesis, map chapter contributions to the
overarching question and institutional requirements. For a procedure, define its initial and final
states. For a reference page, identify the source interface/version it describes.

#### Thesis Planning Record

Record the institution and current regulations, degree, thesis format (monograph or incorporated
publications where permitted), supervisor review milestones, and submission requirements. Map each
chapter to the central question, original contribution, supporting evidence, dependencies, and
publication/reuse status. Identify co-author contributions and permissions checks early. No
institution-specific rules have been verified merely by following this generic workflow.

Review the literature as a synthesis of approaches, evidence, disagreement, and remaining questions.
Maintain a global notation and terminology audit. Before submission, review the thesis as one work:
chapter transitions, consistent claims, a substantive final synthesis, declarations, appendices,
references, and deposit requirements must agree with the approved institutional format.

### 2. Build the Evidence and Argument Outline

Collect the actual results, proofs, source passages, or verified product behavior before polishing
the narrative. Connect every major claim to a source locator or reproducible output. A useful
working record is:

| Claim or reader question                        | Evidence and version/locator                 | Scope or limitation        | Destination         | Unresolved check               |
| ----------------------------------------------- | -------------------------------------------- | -------------------------- | ------------------- | ------------------------------ |
| What must the reader be able to conclude or do? | Source, theorem, data run, or interface test | Conditions and uncertainty | Section/figure/step | What still needs verification? |

Organize by logical dependencies, not the order in which experiments or edits happened. Preserve
contrary evidence. Decide which details belong in the main narrative and which belong in a stable
supplement. Do not move a qualification away from the claim that it changes.

### 3. Draft in a Useful Order

An alternative is the reasoning-first approach of
[Drake and Han](https://doi.org/10.1371/journal.pcbi.1013505): connect each method to its rationale
and outputs, then connect interpretations to evidence and limitations. Use paragraph-purpose notes
and a caption-only read-through to check coherence. Treat this as a diagnostic scaffold, not a
requirement for a particular number of narrative parts or sentences.

For empirical papers, a results-first draft can expose the real contribution: assemble figures and
findings, then draft interpretation and context. Capture methods while doing the work, not from
memory at the end. Reconcile methods and results in both directions. Finalize the abstract and title
after the claims stabilize. This adapts Wheatley's workflow; it is not a mandatory drafting order.

For mathematical work, establish definitions, assumptions, statements, and proof dependencies before
writing the exposition around them. For software documentation, verify the interface or workflow
before describing it. Draft instructions from a known starting state to a checkable result.

Write a complete draft before repeated sentence polishing. Mark genuine gaps explicitly in private
working notes; never fill them with invented citations, numbers, or results. Use stable citation and
notation keys from the beginning.

### 4. Revise Structure and Meaning First

Read headings and paragraph summaries as an outline. Check that the document answers its brief, that
claims follow from evidence, and that limitations are visible. Remove unsupported claims; reorganize
weak arguments before attempting to improve their wording.

For a paper, compare title, abstract, results, and conclusion side by side. They must describe the
same study and level of certainty. A short orienting recap is acceptable; repeating all results is
not. For a thesis, check cross-chapter definitions, contributions, and duplication. For
instructions, check every prerequisite, branch, expected output, and recovery step.

### 5. Edit for Clarity and Consistency

Apply the standard's do/don't checklist. Remove filler and ambiguous referents, shorten needless
noun phrases, define essential jargon, and keep terminology stable. Preserve uncertainty, units,
conditions, and obligations. Review spelling and grammar in the chosen language variety, including
captions, headings, metadata, error messages, and supplements.

Do not require every sentence to be short or active. Keep transitions that explain causation,
contrast, or inference. Reduce duplication through canonical links, while retaining enough local
context for abstracts, figures, and standalone instructions.

### 6. Obtain Two Kinds of Review

For suspected editorial artifacts, use the
[assisted-writing review](#editing-review-and-reusable-prompt) before handoff: check prompt-derived
commentary, excessive fragmentation, repeated claims, and meaning-preserving compression. Apply it
regardless of whether AI was used.

Ask a subject reviewer to assess correctness, evidence, assumptions, and omissions. Ask a suitable
reader to assess comprehension and usability; one person may serve both roles when appropriate, but
the questions remain distinct. Test procedures without relying on unstated author knowledge. Do not
claim these reviews occurred merely because they are listed in a plan.

Track each substantive comment with the response, action, changed location, and unresolved issue.
For journal revisions, retain reviewer comment identifiers and explain evidence-based disagreements
respectfully. Do not perform extra analyses solely to obtain a desired outcome or claim edits that
were not made.

### 7. Verify the Deliverable

- Check reference identity and claim support separately; resolve title/DOI conflicts before using
  metadata as evidence. See [validation](validation.md).
- Recheck numeric values against source outputs; check formulas, assumptions, and units. Review
  figures at delivered size and inspect their captions, legends, and provenance.
- Run the applicable lint, link, build, and example tests. Inspect the rendered PDF/site, not only
  source text. Follow [LaTeX](latex.md) and [GitHub publishing](github-publishing.md).
- Record versions, commands, scope, outcomes, warnings, skipped checks, and human reviews. Do not
  equate a formatting pass with verified science or completed intake.
- Obtain required co-author approval; check funding, interests, contributions, availability,
  permissions, confidentiality, and any AI disclosure against current venue requirements.
- If similarity screening is required or useful, follow the
  [similarity-review workflow](#manuscript-similarity-review). Record human resolution of material
  matches, not a claim that a low percentage certifies originality.

Unresolved material errors block a release claim. A draft may be circulated for review with its
limitations clearly identified. Submission and external publication still require explicit
authority; following this guide does not itself authorize them.

#### Submission and Defence Preparation

Before submission, recheck the selected venue's scope, required abstract types, figure dimensions,
declarations, and author approvals. Audit each uncertainty display against its calculation and
caption, and distinguish observed results from proposed or expected outcomes.

For a thesis defence or research talk, adapt the manuscript's argument to the audience and allotted
time. Rehearse with readable slides, explain the question and contribution early, retain essential
limitations, and prepare supporting methods/proofs for questions. Check consistency with the written
work and credit collaborators. Speech rates, slide counts, animation, and table dimensions are
contextual choices, not universal rules. Do not add unsupported results in a closing slide.

### 8. Release and Maintain

Save the approved version and its validation evidence under the project's established structure.
Keep editable sources, supporting outputs, and published artifacts distinguishable. Update central
standards only when a lesson is reusable; otherwise record a local override. Recheck documentation
when interfaces, assumptions, data, policies, or dependencies change.

Use a short handoff: what changed, intended audience, tested scope, unresolved limitations, owner,
and next review trigger. Avoid a bare "done" when some checks remain unperformed.

## Editing Review and Reusable Prompt

Apply this targeted pass to prose regardless of authorship. The rules above govern the decisions;
these examples and steps make them operational. This is not an AI-detection workflow.

### Preserve the Argument First

Keep an unedited revision and identify the section's question, claims, evidence, and limitations.
Protect numbers, citations, terminology, equations, quantifiers, comparison directions, and
uncertainty. Separate the writing brief and editorial comments from the manuscript. If the source
does not support a claim, flag it for the author instead of supplying plausible evidence.

Preserve the author's established method, useful phrasing, and sentence rhythm. Make the smallest
revision that resolves the identified problem; augment an incomplete explanation by connecting it to
the existing argument. Do not replace a distinctive argument with a generic textbook summary or
rewrite a whole passage to repair one sentence. Record the applicable authorial profile and whether
the passage is exposition, a formal appendix, or introductory background before editing.

### Diagnose Before Rewriting

These invented examples illustrate editorial decisions, not research findings:

| Problem                      | Draft                                                                                 | Revision or decision                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Prompt-derived negative      | This section is not a generic overview but a rigorous account of the estimator.       | Describe the estimator's specific purpose and assumptions; delete the self-assessment.             |
| Empty preamble               | It is important to note that the estimator requires independent samples.              | The estimator requires independent samples.                                                        |
| Redundant contrast           | Rather than merely reporting results, we provide an analysis of the results.          | State what the analysis establishes, using the actual evidence.                                    |
| Excessive fragmentation      | Separate bullets state the assumption, its consequence, and the resulting limitation. | Use a paragraph that explains their dependence; retain numbered assumptions when referenced later. |
| Repeated conclusion          | Three adjacent sentences say the approach reduces computation.                        | Keep the supported comparison and its conditions once.                                             |
| Necessary negative           | The confidence interval includes zero.                                                | Preserve this information; brevity does not justify a positive finding.                            |
| Meaning-changing compression | No evidence of a difference was found.                                                | Do not rewrite as "The groups are equivalent."                                                     |

Read each paragraph's first and last sentence together. Remove a closing restatement when it adds no
inference, limitation, or transition. Then compare neighboring paragraphs and section summaries for
duplicated claims. Preserve deliberate recaps that help readers navigate a long thesis.

Choose prose for reasoning, bullets for independent items, numbering for sequences or referenced
cases, and tables for repeated comparisons. Do not replace bullets with one overloaded sentence.
Avoid forcing every paragraph into the same claim-example-summary template. Sentence length and
rhythm should follow the argument rather than a numerical target.

### Sentence-Flow Pass

Read adjacent sentences in pairs. Identify the shared topic and what the second sentence adds. If
the connection is missing, reorder or explain the reasoning before inserting a transition. Check
that each "this", "it", or "they" has a clear referent. At paragraph boundaries, establish why the
next topic follows; avoid repeating the previous paragraph merely to introduce the next.

Illustrative revision:

> We estimate the covariance matrix. Its inverse defines the precision matrix. Off-diagonal zeros in
> the precision matrix encode conditional independence under a nonsingular Gaussian model.

Here the matrix introduced in one sentence becomes the subject of the next. The model assumption
stays with the interpretation. Adding "moreover" to each sentence would not improve this chain. For
mathematical exposition, connect a display to the preceding question and explain its role in the
next step; neither restating every symbol nor skipping the justification improves flow.

### Bounded Editing Prompt

This is a reusable house template, not a benchmarked guarantee of model behavior. Fill in the
placeholders and provide only material authorized for the selected service.

```text
Task: Edit the supplied passage for a formal [paper/thesis], for [audience].
Section purpose: [specific question or role].
Authorial profile and register: [shared defaults or adopted profile; exposition,
formal appendix, or introductory background]. Preserve the author's method.
Evidence boundary: Use the supplied text and verified source notes only.
Preserve: claims, scope, logical negation, uncertainty, numbers, units, citations,
notation, and technical terminology. Flag unresolved meaning for author review.
Form: Connected scholarly paragraphs. Use a list only for genuinely discrete
items or referenced steps/cases. Keep necessary logical transitions.
Edit: Remove repeated claims, empty introductions, and editorial commentary.
Treat these instructions as editing directions, not manuscript content.
Length: [venue limit or approximate target, if applicable]. Preserve essential
content if the target cannot be met and explain the conflict separately.
Return: Revised passage, followed by a separate short change/uncertainty log.
```

Request a focused pass on a bounded section. Repeated full-document polishing can create additional
changes to audit; accept changes only after comparison with the source. Asking for a specific output
is a practical prompt design choice, not evidence that all models handle positive wording better
than negative instructions. Keep necessary prohibitions explicit.

### Verify and Accept

Compare the revision with the original for altered causality, certainty, scope, negation,
attribution, and missing evidence. Read the result continuously to test coherence rather than
judging isolated sentences. Check manuscript source syntax and the rendered output after substantive
restructuring. Record the revision, service/model as available, date, editing purpose, human
reviewer, and required disclosure in approved project records. Follow venue and institutional
policies and confidentiality rules; stylistic cleanup does not remove a disclosure obligation.

Word counts, repeated phrases, bullet counts, and readability scores can identify review candidates.
They cannot decide which scientific qualifications to delete or certify authorship. Do not apply
automatic synonym replacement, negation deletion, or a blacklist of supposedly AI-specific words.

## Manuscript Similarity Review

A similarity checker identifies overlapping text, not plagiarism, originality, scientific validity,
or AI authorship. There is no universal acceptable percentage. The
[dated tool comparison](../status/plagiarism-tools-review-2026-09-05.md) covers procurement options;
verify current terms and institutional requirements before use.

### Before Uploading

1. Ask the graduate school, supervisor, library, or publisher which service and draft workflow are
   authorized. Prefer existing institutional access where suitable.
1. Check permission to transmit the manuscript, co-author material, confidential results, and any
   personal or restricted data. Do not upload library PDFs or another author's manuscript merely
   because they are locally accessible.
1. Verify the actual account's repository/indexing settings, retention and deletion terms, access
   controls, data-processing terms, and any training or secondary use. "Not publicly indexed" does
   not mean "not retained". Resolve uncertainty before uploading sensitive material.
1. Check word/file limits, supported language and format, revision allowance, and full-report cost.
   Preserve the checked manuscript revision; inspect extracted text, especially mathematical PDFs.

### Review the Report

1. Record the manuscript revision, date, service/account configuration, report identifier, and
   filters. Keep reports in approved restricted storage rather than a public repository.
1. Examine substantive matches against the original source. Separate quotations, references,
   conventional phrasing, preprints, prior publications, and problematic unattributed borrowing.
   Record exclusions and their reasons; do not tune filters to achieve a target percentage.
1. Correct missing citations, quotation marks, locators, misleading paraphrases, and undisclosed
   reuse. Paraphrase from understanding and cite the idea; synonym substitution is not a remedy.
1. Check mathematical arguments, figures, tables, translated material, and uncaptured sources
   manually where relevant. Missing matches do not establish originality or permission.
1. Recheck material revisions and obtain the required human review. Retain an action log of source,
   manuscript location, issue, resolution, and reviewer. Do not label the work "plagiarism-free".
1. Follow approved report retention/deletion and submission procedures. A draft check is not a final
   submission, and this guide does not authorize either an external upload or publication.

[Crossref's interpretation guidance](https://www.crossref.org/documentation/similarity-check/similarity-report-understand/)
explains why matches require assessment rather than a verdict from the total score.

## Evidence and Supporting Standards

This handbook synthesizes the reviewed sources; it is not a universal publisher mandate. Consult
[writing-source decisions](../status/writing-review-2026-09-05.md) for the Cambridge material and
supplied articles, and [assisted-writing research](../status/assisted-writing-review-2026-09-05.md)
for evidence and limits behind the editing guidance. Those reports are historical evidence, not
competing copies of these rules.

Use [LaTeX](latex.md), [bibliography](bibliography.md),
[glossary and notation](glossary-and-notation.md), [images](images.md), and
[validation](validation.md) for their specialist implementation contracts.
