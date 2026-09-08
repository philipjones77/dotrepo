# Notation

---
*Status*: AUTHORITATIVE
*Version*: v2.4.3
*Date*: 2026-09-05

Formatting and versioning follow `docs/standards/documentation.md` (FROZEN).

**Base Documents**

* `notation/README.md` (AUTHORITATIVE) — notation-layer scope, categories, and extension rules
* `docs/standards/glossary-and-notation.md` (WORKING) — notation authoring and usage rules
* `docs/standards/documentation.md` (FROZEN) — formatting and versioning conventions

**Depends Upon:**

* `notation/README.md`
* `docs/standards/documentation.md`

**Is Relied Upon By:**

* specs, objects, contracts, and theory documents using project-wide notation

Notes:

* This file is the concrete shared notation registry.
* Governance of the notation layer itself is defined in `notation/README.md`.

---

## 0. Preamble

### 0.0 Call Registry

This file defines notation in the following categories (each category is a “detailed object” section):

1. `CAT-DOM`: domains, aliases, points, axes, dimensions, indices
2. `CAT-GEO`: metrics, distances, lags, anisotropy, covariates
3. `CAT-SPEC`: spectral and harmonic notation (Euclidean and non-Euclidean)
4. `CAT-RFGRF`: random fields vs generalized random fields and second-order objects
5. `CAT-HSM`: five-level hierarchical-model notation
6. `CAT-KERN`: kernels, representations, parameter pools, family labels
7. `CAT-OP`: operators, SPDE symbols, precision / Markov structures
8. `CAT-SAMP`: sampling and replicates; asymptotic-design notation
9. `CAT-PROB`: probability spaces, measures, and moment operators
10. `CAT-PROBSTAT`: probability distributions and statistical operators
11. `CAT-VOC`: controlled non-mathematical labels
12. `CAT-CHAOS`: Gaussian Hilbert spaces, Wiener chaos, and Malliavin notation

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

This file is the **single source of truth** for the concrete shared mathematical symbols used across the project. It defines:

* domain and geometry symbols (compatible with `domain_geometry_covariates*.md`)
* kernel and representation symbols (compatible with `CT_kernel_specs.md`, `CT_one_input_kernel_objects.md`, `CT_two_input_kernel_objects.md`, `multivariate_kernel*.md`)
* inference- and design-related symbols (compatible with `CT_asymptotic_specs.md`)

Symbols **must not** be redefined locally in other files. Other files may reference these symbols and may introduce *file-local* temporary names only if they are explicitly declared as temporary and non-authoritative under the rules in `notation/README.md` and `docs/standards/glossary-and-notation.md`.

### 0.3 How to read this file

* Each category section starts with a short description and then lists symbols using a consistent per-symbol mini-template.
* Domain aliases are **mandatory** once a concrete domain is specified (see Section 1).
* Rendered mathematics in this Markdown file uses `$...$` or `$$...$$` for its renderer.
  Literal command names and source examples belong in code spans or fenced code blocks.
  These Markdown delimiters do not prescribe `.tex` source syntax.

### 0.4 Summary of Assumptions and Preconditions

* A field is indexed by a deterministic domain that is a product of one or more manifold blocks and (optionally) a covariate/attribute space.
* Geometry (metrics, anisotropy, coordinate representations) is deterministic and defined outside kernels.
* Time is **not** a separate manifold type: it is a Euclidean block whose *usage label* is “time”.
* A field may be scalar-valued, vector-valued (indexed by $\mathcal{P}$), or function-valued.
In the function-valued case, field values lie in a target RKHS $\mathcal{H}(\mathcal{N})$ for some
manifold $\mathcal{N}$. This is mathematically equivalent to a scalar field on the product
$\mathcal{M}\times\mathcal{N}$, but the distinction is preserved in this project because
$\mathcal{N}$ may represent intrinsic structure of the target rather than an indexing dimension.


### 0.5 Notation

This file defines the shared project notation registry. For the five-level
hierarchical-model family, it records the convention whose source of authority
is `texfiles/main/common_main_models_chapter.tex`.

### 0.6 Template

This file uses two templates: one for categories, one for individual symbols.

#### 0.6.1 Category template

For each category section:

* `category_id`: short identifier (e.g. `CAT-DOM`)
* `category_scope`: what the category covers
* `category_notes`: project-specific conventions and collisions resolved here

#### 0.6.2 Symbol template

For each symbol entry, include items as applicable:

* `symbol`: the TeX symbol (typeset)
* `use`: non-exhaustive examples of extra usage, mainly with other notation
* `name`: formal name
* `ascii_name`: optional canonical ASCII name (especially for code)
* `meaning`: plain-language meaning
* `type_shape`: scalar / vector / matrix / set; include dimension(s) when relevant
* `range`: the range of the value of the symbol e.g. $\mathbb{R}$ or $\mathbb{N}$
* `constraints`: positivity / integrability / admissibility, if any
* `where_used`: pointers to the main specs that use it
* `notes`: collisions, reserved status, or subtleties
* `math_role`: ordinary object / operator / relation / binary operation / delimiter
* `typeface`: explicit alphabet and weight, including any profile-dependent rendering
* `latex_source`: renderer-independent mathematical source using documented commands
* `macro`: optional implementation name and owning package; not a replacement for `symbol`
* `glossary_key`: matching verified `sym:` key, when present

The rendering fields are required for new or revised reusable entries. Existing entries are not
claimed to have been fully backfilled or reconciled. Mark unresolved fields for review instead of
guessing a mathematical role or inventing a glossary link.

Legacy registry ASCII transcription (not a Python naming prescription):

* Keep the capitalization as defined in the symbol e.g. the `symbol` $d_S$ has the `ascii_name` `d_S`.
* TeX subscripts use `_` (underscore), e.g. $\xi_S$ → `xi_S`.
* TeX superscripts use `__` (double underscore), e.g. $\sigma^2$ → `sigma__2`.
* Greek letters are spelled out: $\sigma$ → `sigma`, $\tau$ → `tau`, $\xi$ → `xi`, $\kappa$ → `kappa`, $\nu$ → `nu`, $\epsilon$ → `eps`.
* Symbols are atomic (no arguments or instantiated forms). Put argument-bearing forms only in `use` (e.g., symbol $f_X$; use $f_X(x)$, $f_X(x\mid\theta)$).

These identifiers preserve existing registry mappings. New Python/JAX APIs follow the code
standards and explicitly map their snake_case names to these identifiers when they differ.

### 0.7 Validation and Authority Rules

This file is AUTHORITATIVE for the shared notation inventory. If any other project document conflicts with this notation:

* update this file first, then
* propagate updates to dependent files.

Additional validation rules:

* Section numbering MUST follow `docs/standards/documentation.md` (all content starts at `## 1 ...` after this preamble).
* Rendered TeX belongs in math delimiters; literal source belongs in code spans or fenced blocks.
* All domain objects SHOULD be typeset using $\mathcal{(\cdot)}$ unless explicitly exempted; the covariate/attribute space uses $\mathcal{X}$.
* Domain-alias rules (Section 1.2) MUST be used consistently across all specs.

### 0.8 Thesis manuscript conventions

The registry records rendered notation; the following conventions govern its
use in the thesis source.

* Scalars are italic. Sets and spaces are calligraphic or blackboard bold as
  appropriate.
* Random variables and fields are upper-case, while their realizations are
  lower-case where both occur.
* The thesis historically prefers bold vectors/matrices and some operators. This does not
  override an individual entry's registered glyph (for example the differential operators in
  Section 6.2). Record weight and alphabet per object/profile before changing them. Under
  unicode-math, choose explicit upright-bold or italic-bold commands where that distinction
  matters; do not assume a global bold default resolves every symbol's typeface.
* Use declared expectation, variance, covariance, trace, and optimization
  operators rather than letter-shaped substitutes. Keep the differential
  $\mathrm{d}$ upright in integrals.
* The sphere glyph is $\mathbb{S}$. A legacy thesis implementation redefines `\S` to obtain
  it; that shortcut is not the shared standard. New code must preserve the built-in section
  sign and use explicit math source or a documented semantic sphere macro.
* A local notation exception must be declared at first use and must not
  redefine a shared symbol. Semantic stage labels and typed cross-references
  are preferred to relative references such as "above" or "below".

### 0.9 Thesis source aliases

The following are thesis-source commands for objects defined in the registry;
they are source aliases, not additional semantic definitions.

| Object family | Thesis source commands |
|---|---|
| Probability space and moments | $\OP$, $\FF$, $\PP$, $\E$, $\Var$, $\Cov$ |
| Domains and meshes | $\Ddom$, $\M$, $\Sdom$, $\Tdom$, $\Vdom$, $\Pdom$, $\SP$, $\Kh$, $\Sone$, $\Stwo$ |
| Intrinsic metrics | $\rhoM$, $\rhoS$, $\rhoT$, $\rhoSP$ |
| Scalar and helper spaces | $\R$, $\C$, $\N$, $\K$, $\cH$, $\cV$, $\cB$ |
| Basic algebra | $\norm{\cdot}$, $\abs{\cdot}$, $\ip{\cdot}{\cdot}$ |
| Graph objects | $\Graph$, $\Vertices$, $\Edges$, $\Nbhd$, $\cob$, $\InvProp$, $\Prop$ |
| Named operators and distributions | $\Lap$, $\tr$, $\argmax$, $\argmin$, $\Gau$ |
| Collision-safe shared objects | $\Wnoise$, $\LOU$, $\lambdaReg$, $\rhoADMM$ |

This is an inventory of existing thesis aliases, not an approved shared macro API. Use the
registered mathematical symbol in new source, or a tested semantic macro that renders that exact
symbol with the correct math role and typeface. The alias must not decide the mathematical
meaning. Do not assume these commands exist in Markdown, MathJax, or another document.

### 0.11 Meaning Before Source Shortcuts

Resolve the mathematical object and scope first, then its registered glyph, typeface, and math
role, and only then its implementation. A symbol with the right outline but the wrong meaning or
spacing class is not an acceptable substitute. The following examples use existing entries:

| Object | Explicit math source | Important distinction |
|---|---|---|
| Probability measure | `\mathbb{P}` | Not plain italic `P` or the paragraph-sign command `\P` |
| White-noise generalized field | `\mathcal{W}` | Not the distinct isonormal process `W(h)` |
| Sphere | `\mathbb{S}` | Not the section-sign command `\S` |
| Divergence on a manifold block | `\operatorname{div}_{\mathcal{M}_k}` | Named operator spacing, not italic letters `div` |
| Regularization weight | `\lambda_{\mathrm{reg}}` | Upright descriptive subscript; not reserved `\varpi` |
| ADMM penalty | `\rho_{\mathrm{ADMM}}` | Not the distinct operator functional `\varrho(A)` |

Use these inside math mode in `.tex`, normally `\(...\)` inline and explicit equation/align
environments for displays. Literal source in this table is intentional: it remains readable
without loading thesis macros. Use the shared LaTeX macro standard for implementation and spacing.
This clarification changes implementation guidance, not the mathematical definitions below.
The full inventory still needs a per-entry typeface/math-role/glossary audit; in particular, the
generic bold wording, existing vector glyphs, upright-differential examples, and the reused ASCII
name `eps` must be reconciled explicitly rather than normalized blindly.

### 0.10 Current thesis source boundary and reconciliation decisions

The inventory was reconciled on 2026-08-22 against the 35 entries selected by
the canonical assembled-chapter list in `thesis.tex`, including selected main
chapters, appendices, and supplementals. Files under `archive/` and catalog
entries not selected by that list do not establish shared notation. In
particular, the unassembled SMPL main and appendix entries are outside this
registry audit.

The registry includes a symbol when it is reused across assembled sources,
belongs to a stable thesis-wide family, or needs an explicit collision rule.
Application-only variables and one-off proof variables remain local when they
are introduced at first use and do not collide with a reserved symbol.

The audit identified the following source migrations, which were applied to
the assembled TeX sources in the 2026-08-22 propagation pass. The symbols on
the right are authoritative here.

| Former collision in assembled source | Authoritative distinction |
|---|---|
| $\varpi$ for both the Mellin--Barnes conic invariant and a regularization weight | retain $\varpi$ for the conic invariant; use $\lambda_{\mathrm{reg}}$ for the regularization weight |
| $\varrho(A)$ for the Schatten ratio and $\varrho$ for an ADMM penalty | retain $\varrho(A)$ for the Schatten ratio; use $\rho_{\mathrm{ADMM}}$ for the ADMM penalty |
| $\mathcal{W}$ and $W$ used interchangeably for white noise | use $\mathcal{W}$ for the white-noise GRF in SPDEs and $W(h)$ for the associated isonormal process |
| $L$ for a generic/SPDE operator and the Ornstein--Uhlenbeck generator | retain $L$ for the generic operator; use $L_{\mathrm{OU}}=-\delta D$ outside a locally declared Malliavin-only scope |

---

## 1. Domains, aliases, points, axes, dimensions, indices

*category_id*: `CAT-DOM`  
*category_scope*: deterministic domains, manifold blocks, points, axes, dimension and index conventions

### 1.1 Domains and product structure

* `symbol`: $\mathcal{D}$
  * `name`: `Domain` 
  * `ascii_name`: `D`
  * `meaning`: full indexing domain for a field (geometry + multivariate + optional covariates + optional restrictions)
  * `type_shape`: set
  * `notes`: in this project, $\mathcal{D}$ may be written as $\mathcal{P}\times\mathcal{M}\times \mathcal{X}$

* `symbol`: $\mathcal{M}$
  * `ascii_name`: `M`
  * `meaning`: geometric domain (product of manifold blocks only, no covariates)
  * `type_shape`: set
  * `notes`: $\mathcal{M}$ is a product of named manifold blocks, e.g. $\mathcal{S}\times\mathcal{T}$

* `symbol`: $\tilde{\mathcal{M}}$
  * `ascii_name`: `M_tilde`
  * `meaning`: restricted manifold (subset of a manifold block with inherited metric)
  * `type_shape`: set
  * `notes`: use the tilde only when the restriction must be explicit; otherwise $\mathcal{M}$ may be understood as already restricted by context

* `symbol`: $\mathcal{M}_k$
  * `ascii_name`: `M_k`
  * `meaning`: generic manifold block in the product decomposition of $\mathcal{M}$
  * `type_shape`: set (manifold), index $k\in\{1,\dots,K\}$
  * `use`: instantiate as $\mathcal{M}_1$, $\mathcal{M}_2$, ... for concrete blocks; bind each to a domain alias (e.g. $\mathcal{S}$, $\mathcal{T}$) once the block type is chosen
  * `notes`: one entry covers all block indices; add aliases in `domain_geometry_covariates*.md`

* `symbol`: $\mathcal{P}$
  * `ascii_name`: `P`
  * `meaning`: multivariate component domain (index set for vector-valued fields)
  * `type_shape`: set, typically a finite set $\{1,\dots,p\}$
  * `notes`: use together with the dimension symbol $p$ when a field has multiple components

* `symbol`: $u,v$
  * `ascii_name`: `u`, `v`
  * `use`: $u\in\mathcal{D}$, $v\in\mathcal{D}$, $u'$
  * `meaning`: generic points in the full domain; when two points are compared, the second is denoted with a prime $u'$ (ASCII: `u__prime`)
  * `type_shape`: elements of $\mathcal{D}$
  * `where_used`: `CT_kernel_specs.md`, `CT_model_structure_specs.md`

* `symbol`: $(x,t)$
  * `ascii_name`: `(x,t)`
  * `meaning`: shorthand for a point $u \in \mathcal{S}\times\mathcal{T}$
  * `type_shape`: ordered pair
  * `notes`: convenience alias only; mathematically equivalent to $u$; $x$ is reserved for the spatial point and $t$ for the temporal point

* `symbol`: $\mathcal{X}$
  * `ascii_name`: `X`
  * `meaning`: covariate / attribute space attached to points (non-geometric by default)
  * `type_shape`: set, typically $\mathcal{X}\subseteq \mathbb{R}^q$ (mixed discrete/continuous allowed)
  * `notes`: $\mathcal{X}$ is not a manifold block unless explicitly promoted to geometry in `domain_geometry_covariates*.md`

* `symbol`: $K$
  * `ascii_name`: `K`
  * `meaning`: number of manifold blocks in $\mathcal{M}$
  * `type_shape`: integer

* `symbol`: $\overline{\mathcal{D}}$
  * `ascii_name`: `D_closure`
  * `meaning`: closure of the domain $\mathcal{D}$ (includes boundary)
  * `type_shape`: set

* `symbol`: $\partial\mathcal{D}$
  * `ascii_name`: `partial_D`
  * `meaning`: boundary of the domain, $\partial\mathcal{D} = \overline{\mathcal{D}} \setminus \mathcal{D}^\circ$
  * `type_shape`: set

* `symbol`: $\mathcal{N}$
  * `ascii_name`: `N`
  * `name`: Target manifold
  * `meaning`: manifold underlying the target-space RKHS; values of a field may be functions on $\mathcal{N}$
  * `type_shape`: set (manifold)
  * `notes`: 
      * $\mathcal{N}$ is **not** part of the indexing domain $\mathcal{M}$ unless explicitly promoted.
      * Any existing manifold block type used in $\mathcal{M}$ may also be used as $\mathcal{N}$.
      * Scalar targets correspond to the degenerate case $\mathcal{N}=\{\ast\}$.

* `symbol`: $\mathcal{K}_h$
  * `ascii_name`: `K_h`
  * `name`: Mesh / triangulation
  * `use`: $\mathcal{K}_h$, $\mathcal{K}_{i,h}$
  * `meaning`: mesh or triangulation used as a discrete geometric domain or as an approximation to a smooth manifold block
  * `type_shape`: finite simplicial complex or discrete cell complex, indexed by resolution parameter $h$
  * `notes`:
      * use $\mathcal{K}_h$ for the mesh itself
      * use $\mathcal{K}_{i,h}$ when a block-indexed family of meshes is needed
      * do not use $M_h$ for the mesh when $M_h$ is reserved locally for a mass matrix or for an embedded polyhedral surface


### 1.2 Domain aliases (replace generic block indexing)

Project rule: **domain aliases replace generic block notation** once a concrete domain is specified.

* A *domain alias* is a short name for a manifold block used consistently across theory, specs, and code.
* Domain aliases are **not written as subscripts**. Use numeric suffixes instead.

Canonical alias forms (defaults; user may override):

* Euclidean “space” block: $\mathcal{S}$, $\mathcal{S}1$, $\mathcal{S}2$, ...
* Euclidean “time” block: $\mathcal{T}$, $\mathcal{T}1$, $\mathcal{T}2$, ...
* Sphere block: $\mathcal{S}\mathcal{P}$, $\mathcal{S}\mathcal{P}1$, ...
* Torus block: $\mathcal{T}\mathcal{R}$, $\mathcal{T}\mathcal{R}1$, ...
* Discrete block: $\mathcal{D}\mathcal{C}$, $\mathcal{D}\mathcal{C}1$, ...

Notes:

* The *manifold type* is declared in `domain_geometry_covariates*.md`; the alias is a naming convention.
* If two Euclidean blocks are both “space-like”, use $\mathcal{S}1$ and $\mathcal{S}2$ (not $\mathcal{S}_1$, $\mathcal{S}_2$).

### 1.3 Point aliases

Project rule: the spatial point is $x$ and the temporal point is $t$. Numeric
suffixes distinguish multiple blocks of the same type. The former spatial-point
alias $s$ is retired; $s$ remains available for Sobolev orders, Mellin
variables, sparsity indices, and other explicitly declared non-spatial uses.

Examples:

* point in $\mathcal{S}$: $x\in\mathcal{S}$
* point in $\mathcal{S}2$: $x2\in\mathcal{S}2$
* point in $\mathcal{T}$: $t\in\mathcal{T}$
* point on a sphere block: $x\in\mathcal{S}\mathcal{P}$ when the block is unambiguous

### 1.4 Axes, dimensions, and indices

* `symbol`: $d_{\mathcal{M}_k}$
  * `ascii_name`: `d_Mk`
  * `meaning`: intrinsic dimension of a manifold block $\mathcal{M}_k$ (or its alias)
  * `type_shape`: integer
  * `notes`: examples include $d_{\mathcal{S}}$, $d_{\mathcal{T}}$

* `symbol`: $d$
  * `ascii_name`: `d`
  * `meaning`: total geometric dimension of $\mathcal{M}$, or of the active geometric domain when the context has been restricted
  * `type_shape`: integer
  * `notes`: for $\mathcal{S}\times\mathcal{T}$, $d=d_{\mathcal{S}}+d_{\mathcal{T}}$

* `symbol`: $q$
  * `ascii_name`: `q`
  * `meaning`: covariate/attribute dimension for $\mathcal{X}$
  * `type_shape`: integer

* `symbol`: $p$
  * `ascii_name`: `p`
  * `meaning`: multivariate dimension (number of components in $\mathcal{P}$)
  * `type_shape`: integer, typically $p\ge 1$
  * `notes`: $\mathcal{P}$ is often realized as the index set $\{1,\dots,p\}$

* `symbol`: $i,j$
  * `ascii_name`: `i`, `j`
  * `meaning`: generic point/sample indices
  * `type_shape`: integers

* `symbol`: $\ell$
  * `ascii_name`: `ell`
  * `meaning`: harmonic degree (spherical blocks)
  * `type_shape`: integer, $\ell\in\{0,1,2,\dots\}$

---

## 2. Metrics, distances, lags, anisotropy, covariates

*category_id*: `CAT-GEO`  
*category_scope*: deterministic geometry objects produced by `domain_geometry_covariates*.md` and consumed by kernels

### 2.1 Metrics and distances

* `symbol`: $\rho_{\mathcal{M}_k}$
  * `ascii_name`: `rho_Mk`
  * `use`: $\rho_{\mathcal{M}_k}(\cdot,\cdot)$, $\rho_k$, $\rho_{\mathcal{S}}$, $\rho_{\mathcal{T}}$
  * `meaning`: metric (or pseudometric) on manifold block $\mathcal{M}_k$ (or its alias)
  * `type_shape`: function $\mathcal{M}_k\times\mathcal{M}_k\to \mathbb{R}_{\ge 0}$
  * `where_used`: `domain_geometry_covariates*.md`, `CT_kernel_specs.md`
  * `notes`: For a generic block use $\rho_{\mathcal{M}_k}$ or $\rho_k$; once an alias is fixed (e.g., $\mathcal{S}$), use the alias (e.g., $\rho_{\mathcal{S}}$).

* `symbol`: $r_{\mathcal{M}_k}$
  * `ascii_name`: `r_Mk`
  * `meaning`: radial distance between two points in block $\mathcal{M}_k$
  * `type_shape`: scalar, $r_{\mathcal{M}_k}=\rho_{\mathcal{M}_k}(a,a')$
  * `notes`: used when a kernel is written as a radial function

### 2.2 Signed lags (Euclidean blocks only)

* `symbol`: $h_{\mathcal{M}_k}$
  * `ascii_name`: `h_Mk`
  * `meaning`: signed lag vector (Euclidean blocks only)
  * `type_shape`: vector in $\mathbb{R}^{d_{\mathcal{M}_k}}$
  * `definition`: $h_{\mathcal{M}_k} = a-a'$ when the block is Euclidean
  * `notes`: kernels may require signed lags for directional effects

* `symbol`: $(h_1,h_2)$
  * `ascii_name`: `(h_1,h_2)`
  * `meaning`: joint signed lags for a two-input kernel
  * `type_shape`: element of $\mathbb{R}^{d_{\mathcal{M}_{k_1}}}\times\mathbb{R}^{d_{\mathcal{M}_{k_2}}}$
  * `definition`: $h_i = a_i - a_i'$ for Euclidean blocks
  * `notes`: defined only when both blocks are Euclidean

### 2.3 Anisotropy maps and anisotropic distance

* `symbol`: $A_{\mathcal{M}_k}$
  * `ascii_name`: `A_Mk`
  * `meaning`: deterministic anisotropy linear map for Euclidean block $\mathcal{M}_k$
  * `type_shape`: matrix in $\mathbb{R}^{d_{\mathcal{M}_k}\times d_{\mathcal{M}_k}}$
  * `constraints`: typically $A_{\mathcal{M}_k}$ is nonsingular; SPD constraints may be imposed by geometry
  * `notes`: kernels do not define anisotropy; geometry does

* `symbol`: $B_{\mathcal{M}_k}$
  * `ascii_name`: `B_Mk`
  * `meaning`: SPD anisotropy/metric matrix for Euclidean block $\mathcal{M}_k$ (Mahalanobis form)
  * `type_shape`: matrix in $\mathbb{R}^{d_{\mathcal{M}_k}\times d_{\mathcal{M}_k}}$
  * `notes`: used when anisotropy is expressed as $\|h\|_{B_{\mathcal{M}_k}}$; defined by geometry, not kernels

* `symbol`: $r_{\mathcal{M}_k,\mathrm{aniso}}$
  * `ascii_name`: `r_Mk_aniso`
  * `meaning`: anisotropic radial distance
  * `type_shape`: scalar
  * `definition`: $r_{\mathcal{M}_k,\mathrm{aniso}}=\|A_{\mathcal{M}_k}(a-a')\|_2$ (Euclidean blocks)

* `symbol`: $(r_1,r_2)$
  * `ascii_name`: `(r_1,r_2)`
  * `meaning`: joint radial distances for a two-input kernel
  * `type_shape`: element of $\mathbb{R}_{\ge 0}^2$
  * `definition`: $r_k = \rho_{\mathcal{M}_k}(a_k,a_k')$
  * `notes`: used for radial or distance-only two-input kernels

### 2.4 Geometry-to-kernel handoff objects

* `symbol`: `LagFeatures`
  * `ascii_name`: `LagFeatures`
  * `meaning`: geometry output object passed to kernels
  * `type_shape`: structured object / dict
  * `components`:
    * $r_{\mathrm{iso}}[\mathcal{M}_k]$: isotropic distance matrices per block
    * $r_{\mathrm{aniso}}[\mathcal{M}_k]$: anisotropic distance matrices per block (if present)
    * $h[\mathcal{M}_k]$: signed lag tensors per Euclidean block (if requested)
  * `notes`: exact shapes are defined in `domain_geometry_covariates*.md`

* `symbol`: `DistanceCombineSpec`
  * `ascii_name`: `DistanceCombineSpec`
  * `meaning`: deterministic specification for combining per-block distances into a joint distance object
  * `type_shape`: structured object / dict
  * `notes`: defines geometry-level combination semantics before kernel evaluation

* `symbol`: `DomainOperatorDef`
  * `ascii_name`: `DomainOperatorDef`
  * `meaning`: operator-definition object for a block/domain (operator family, parameters, boundary semantics)
  * `type_shape`: structured object / dict
  * `notes`: used when domain operators are declared as part of geometry/runtime representations

* `symbol`: `DomainOperatorStructure`
  * `ascii_name`: `DomainOperatorStructure`
  * `meaning`: resolved operator-structure object exposed by domain runtime representations
  * `type_shape`: structured object / dict
  * `notes`: may include eigenpair metadata, discretization level, and approximation markers

* `symbol`: `domain_properties`
  * `ascii_name`: `domain_properties`
  * `meaning`: deterministic runtime payload summarizing domain identity and block-level properties
  * `type_shape`: dictionary / structured object
  * `notes`: includes representation-facing flags such as geometry source, mesh policy, and operator compatibility

### 2.5 Covariates / attributes

The covariate dimension is $q$, as defined in Section 1.4. Its definition is
kept there with the other dimensions and indices.

* `symbol`: $c$
  * `ascii_name`: `c`
  * `use`: $c\in \mathcal{X}$
  * `meaning`: covariate vector attached to a point
  * `type_shape`: typically $c\in \mathbb{R}^q$ (may include categorical components)
  * `notes`: $x$ is reserved for the spatial point and is not reused for a covariate vector

---

## 3. Spectral and harmonic notation

*category_id*: `CAT-SPEC`  
*category_scope*: Euclidean Fourier symbols and non-Euclidean harmonic symbols

### 3.1 Euclidean spectral variables

* `symbol`: $\xi_{\mathcal{M}_k}$
  * `ascii_name`: `xi_Mk`
  * `meaning`: Euclidean frequency vector for block $\mathcal{M}_k$
  * `type_shape`: vector in $\mathbb{R}^{d_{\mathcal{M}_k}}$
  * `notes`: when the aliases are fixed, use $\xi_S$, $\xi_{S1}$, $\xi_{S2}$,
    or $\xi_T$. A mixed sphere--time expansion may instead use $\omega$ for
    the temporal frequency.

* `symbol`: $\zeta_{\mathcal{M}_k}$
  * `ascii_name`: `zeta_Mk`
  * `meaning`: radial frequency (frequency magnitude)
  * `type_shape`: scalar, $\zeta_{\mathcal{M}_k}=\|\xi_{\mathcal{M}_k}\|$

### 3.2 Spherical harmonic variables

* `symbol`: $Y_{\ell,m}$
  * `ascii_name`: `Y_ell_m`
  * `meaning`: spherical harmonic (basis function)
  * `type_shape`: function on $\mathbb{S}^{d}$ (dimension determined by the spherical block)
  * `notes`: $\ell$ is the harmonic degree and $m$ is its multiplicity index.
    The unadorned symbol $m$ remains reserved for a mean function elsewhere in
    the registry.

* `symbol`: $\mu_{\ell}$
  * `ascii_name`: `mu_ell`
  * `meaning`: Laplace–Beltrami eigenvalue associated with degree $\ell$
  * `type_shape`: scalar
  * `definition`: $\mu_{\ell}=\ell(\ell+d-1)$ for $\mathbb{S}^{d}$

Notes:

* The symbol $\lambda$ is reserved for other uses; spherical eigenvalues use $\mu_{\ell}$.

### 3.3 Spectral conventions on compact manifolds (sphere, torus, products)

Project convention for **compact** manifold blocks (sphere, torus, etc.):

* Let $M$ be a compact Riemannian manifold block with Riemannian volume element $d\mathrm{vol}$.
* Define the **normalized (probability) volume measure** $d\omega = d\mathrm{vol}/\mathrm{vol}(M)$ so that $\int_M d\omega = 1$.
* Use an **orthonormal Laplace–Beltrami eigenbasis** $\{\varphi_j\}_{j\ge 0}$ in $L^2(M,d\omega)$, i.e.
  $$
  -\Delta_M \varphi_j = \mu_j\,\varphi_j,
  \qquad
  \int_M \varphi_j(u)\,\overline{\varphi_{j'}(u)}\,d\omega(u)=\delta_{jj'}.
  $$

With this convention, for any $g\in L^2(M,d\omega)$:

* **forward (harmonic coefficients):**
  $$
  \widehat g_j = \int_M g(u)\,\overline{\varphi_j(u)}\,d\omega(u),
  $$
* **backward (reconstruction):**
  $$
  g(u)=\sum_{j\ge 0}\widehat g_j\,\varphi_j(u),
  $$
  with convergence in $L^2(M,d\omega)$.

Kernel / spectrum relation on compact blocks (RF regime):

* A (second-order) kernel admits a compact-manifold spectral representation when
  $$
  C(u,v)=\sum_{j\ge 0} a_j\,\varphi_j(u)\,\overline{\varphi_j(v)},
  \qquad a_j\ge 0,
  $$
  and (when defined) the marginal variance is $C(u,u)=\sum_{j\ge 0} a_j$.

#### 3.3.1 Torus ($\mathbb{T}^d$) Fourier-series convention

Let $M=\mathbb{T}^d_P$ be a $d$-torus with per-axis periods $P=(P_1,\ldots,P_d)$ and coordinates $x\in\prod_{i=1}^d[0,P_i)$.

Define the integer frequency index $n\in\mathbb{Z}^d$ and the corresponding (angular) frequency vector
$$
\xi_n = 2\pi\left(\frac{n_1}{P_1},\ldots,\frac{n_d}{P_d}\right).
$$

Then the standard eigenbasis is
$$
\varphi_n(x)=e^{i\langle \xi_n, x\rangle},
\qquad n\in\mathbb{Z}^d,
$$
which is orthonormal in $L^2(\mathbb{T}^d_P,d\omega)$ where $d\omega=dx/\prod_i P_i$.

Accordingly, for $g\in L^2(\mathbb{T}^d_P,d\omega)$:

* **forward:**
  $$
  \widehat g[n] = \int_{\mathbb{T}^d_P} g(x)\,e^{-i\langle \xi_n, x\rangle}\,d\omega(x),
  $$
* **backward:**
  $$
  g(x)=\sum_{n\in\mathbb{Z}^d} \widehat g[n]\,e^{i\langle \xi_n, x\rangle}.
  $$

Stationary covariance / spectrum relation on $\mathbb{T}^d_P$ (RF regime):

$$
C(h)=\sum_{n\in\mathbb{Z}^d} f[n]\,e^{i\langle \xi_n, h\rangle},
\qquad
f[n]=\int_{\mathbb{T}^d_P} C(h)\,e^{-i\langle \xi_n, h\rangle}\,d\omega(h),
$$

where $h=x-y$ is the wrapped lag in $\mathbb{T}^d_P$.
For real-valued processes, the discrete spectrum satisfies $f[n]\in\mathbb{R}_{\ge 0}$ and $f[-n]=f[n]$.

#### 3.3.2 Sphere ($\mathbb{S}^d$) harmonic convention

Let $M=\mathbb{S}^d$ with uniform probability measure $d\omega=d\mathrm{vol}/\mathrm{vol}(\mathbb{S}^d)$.
Let $\{Y_{\ell,m}\}$ denote spherical harmonics, orthonormal in $L^2(\mathbb{S}^d,d\omega)$.

For $g\in L^2(\mathbb{S}^d,d\omega)$:

* **forward:**
  $$
  \widehat g_{\ell m} = \int_{\mathbb{S}^d} g(u)\,\overline{Y_{\ell,m}(u)}\,d\omega(u),
  $$
* **backward:**
  $$
  g(u)=\sum_{\ell=0}^{\infty}\sum_{m=1}^{N_{d,\ell}} \widehat g_{\ell m}\,Y_{\ell,m}(u).
  $$

Stationary (isotropic) covariance / spectrum relation on $\mathbb{S}^d$ (RF regime):

$$
C(u,v)
=\sum_{\ell=0}^{\infty}\sum_{m=1}^{N_{d,\ell}} a_{\ell}\,Y_{\ell,m}(u)\,\overline{Y_{\ell,m}(v)},
\qquad a_{\ell}\ge 0.
$$

If $C$ is isotropic so that $C(u,v)=C(r)$ with $r$ the geodesic distance, then by the addition theorem:

$$
C(r)=\sum_{\ell=0}^{\infty} a_{\ell}\,N_{d,\ell}\,P_{\ell}^{(d)}(\cos r),
$$

where $N_{d,\ell}$ is the multiplicity (dimension) of the degree-$\ell$ harmonic subspace and $P_{\ell}^{(d)}$ is the appropriate Gegenbauer/Legendre-type polynomial.

#### 3.3.3 Products of compact manifolds

If $M=M_1\times M_2$ is a product of compact blocks, use tensor-product eigenfunctions
$\varphi_{j_1,j_2}(u_1,u_2)=\varphi^{(1)}_{j_1}(u_1)\,\varphi^{(2)}_{j_2}(u_2)$.
Spectral coefficients (and covariance expansions) are indexed by the corresponding multi-index.

### 3.4 Active-direction spectral notation

These symbols are used by the CT product-manifold chapter when a two-variable
spectrum is reduced to the direction that controls regularity, equivalence,
or local quadratic variation.

Let $F\in\{S,T,ST\}$ denote the active spectral direction: $S$ and $T$
denote axis directions, while $ST$ denotes the simultaneous high-frequency
product direction. In the same local statement, avoid the unadorned $F$ for a
spectral measure; use a decorated measure such as $F_Y$ instead.

* `symbol`: $D_F$
  * `ascii_name`: `D_F`
  * `meaning`: dimension of the active direction
  * `type_shape`: integer
  * `definition`: $D_S=d_S$, $D_T=d_T$, and $D_{ST}=d_S+d_T$

* `symbol`: $s_F$
  * `ascii_name`: `s_F`
  * `meaning`: Korte--Stapff / CT active-direction Sobolev or RKHS order
  * `type_shape`: positive scalar
  * `constraints`: pointwise RF statements require $s_F>D_F/2$

* `symbol`: $\beta_F$
  * `ascii_name`: `beta_F`
  * `meaning`: effective facewise Sobolev order read by the likelihood on the resolved axis or balanced diagonal band
  * `type_shape`: positive scalar
  * `use`: $\beta_S=\max\{s_S,s_{ST}\}$, $\beta_T=\max\{s_T,s_{ST}\}$, and $\beta_{ST}=\max\{s_S,s_T,s_{ST}\}$ for the triple-scale product model
  * `notes`: $\beta_F$ is a likelihood-visible effective order and need not equal the named component order $s_F$.

* `symbol`: $\nu_F^{\mathrm{Loh}}$
  * `ascii_name`: `nu_F_Loh`
  * `meaning`: Loh/Stein local Matérn smoothness on the same active direction
  * `type_shape`: scalar
  * `definition`: $\nu_F^{\mathrm{Loh}}=s_F-D_F/2$
  * `notes`: retain the superscript whenever the global Stein--SSMM parameter
    $\nu$ is also in scope; it prevents a local-smoothness parameter from
    being mistaken for that model parameter.

* `symbol`: $\eta_F$
  * `ascii_name`: `eta_F`
  * `meaning`: active-direction microergodic residue / leading spectral amplitude
  * `type_shape`: positive scalar

* `symbol`: $\nu_i$, $s_i^{\mathrm{marg}}$, $c_i=\varphi_i$
  * `ascii_name`: `nu_i`, `s_i_marg`, `c_i`
  * `meaning`: Stein-family axis specialization of local smoothness, marginal Sobolev order, and microergodic residue
  * `type_shape`: positive scalars for $i\in\{S,T\}$
  * `use`: $s_i^{\mathrm{marg}}=\nu_i+d_i/2$ and $c_i=\varphi_i=\eta_i$
  * `notes`: cross-family statements use $\nu_F^{\mathrm{Loh}}$, $s_F$, and $\eta_F$; the axis notation is retained where the assembled Stein specialization uses it explicitly.

* `symbol`: $\rho_F$
  * `ascii_name`: `rho_F`
  * `meaning`: first subleading active-direction spectral gap
  * `type_shape`: positive scalar

* `symbol`: $g_{\theta,F}$
  * `ascii_name`: `g_theta_F`
  * `meaning`: active-direction spectral multiplier under parameter $\theta$
  * `type_shape`: positive function of one spectral variable
  * `use`: $$g_{\theta,F}(\lambda)=\eta_F(\theta)\lambda^{-s_F(\theta)}\{1+b_F(\theta)\lambda^{-\rho_F}+O(\lambda^{-\rho_F-\varepsilon_F})\}.$$
  * `notes`: suppress $\theta$ only when the parameter value is fixed by context.

### 3.5 Fox--H and Mellin--Barnes notation

These objects are shared by the assembled manifold and Fox--H chapters and
their appendices. They describe the analytic representation of a spectral
multiplier, not a second random field.

* `symbol`: $\mathfrak{H}_N$
  * `ascii_name`: `H_fraktur_N`
  * `use`: $\mathfrak{H}_2$ for the two-variable product-domain class
  * `meaning`: admissible $N$-variable Fox--H / Mellin--Barnes class used for spectral multipliers
  * `type_shape`: family of functions represented by $N$-fold Mellin--Barnes integrals
  * `notes`: do not confuse this analytic family with the noise Hilbert space $\mathfrak{H}$ in Section 12.

* `symbol`: $z=(z_1,\ldots,z_N)$
  * `ascii_name`: `z_MB`
  * `meaning`: Mellin--Barnes integration variable
  * `type_shape`: vector in $\mathbb{C}^N$
  * `notes`: a decorated form such as $z_{\mathrm{MB}}$ may be used when a statistical variable $z$ is also in scope.

* `symbol`: $\varpi$
  * `ascii_name`: `varpi_MB`
  * `meaning`: Mellin--Barnes conic-hull invariant controlling absolute convergence and admissible sectors
  * `type_shape`: real scalar
  * `use`: $\varpi(\alpha,A)=\min_{\lVert x\rVert=1}\sum_k\alpha_k\lvert x\mathbin{\cdot}A_k\rvert$
  * `notes`: $\varpi$ is reserved for this analytic invariant. A regularization weight is $\lambda_{\mathrm{reg}}$, not $\varpi$.

* `symbol`: $\varrho_j$
  * `ascii_name`: `varrho_j_pole`
  * `meaning`: crossed Mellin-pole location, appearing as a spectral decay exponent
  * `type_shape`: scalar pole coordinate indexed by $j$
  * `use`: $\lambda^{-\varrho_j}P_j(\log\lambda)$
  * `notes`: the subscript is mandatory. The operator functional $\varrho(A)$ in Section 12 is a separate, argument-bearing object, and unadorned $\varrho$ is not an ADMM penalty.

* `symbol`: $z_F^\star$
  * `ascii_name`: `z_F_star`
  * `meaning`: binding pole in active direction $F$
  * `type_shape`: pole location or pole-intersection point in Mellin space
  * `notes`: its location determines the active spectral order; the associated residue determines $\eta_F$.

* `symbol`: $\operatorname{Res}_{z=z_F^\star}$
  * `ascii_name`: `Res_z_F_star`
  * `meaning`: residue functional at the binding pole
  * `type_shape`: scalar or matrix, matching the spectral multiplier


## 4. Random fields, generalized random fields, and second-order objects

*category_id*: `CAT-RFGRF`  
*category_scope*: $Y$, $Z$, covariance/variogram objects; RF vs GRF distinctions


### 4.0 Target-space RKHS

* `symbol`: $\mathcal{H}(\mathcal{N})$
  * `ascii_name`: `H_N`
  * `meaning`: reproducing kernel Hilbert space of functions on the target manifold $\mathcal{N}$
  * `type_shape`: Hilbert space
  * `notes`:
      * Used when a field value is itself a function on $\mathcal{N}$.
      * Scalar-valued fields correspond to $\dim \mathcal{H}(\mathcal{N}) = 1$.




### 4.1 Latent and observed processes

* `symbol`: $Y$
  * `ascii_name`: `Y`
  * `use`: $Y(u)$, $Y(u')$
  * `meaning`: latent field (random field or generalized random field)
  * `type_shape`: scalar or vector depending on $p$ (see below)
  * `where_used`: `CT_model_structure_specs.md`, inference/prediction/simulation docs

* `symbol`: $Z$
  * `ascii_name`: `Z`
  * `use`: $Z(u)$, $Z(u')$, $Z(u,v)=m(u,v)+Y(u)$
  * `meaning`: observed process linked to $Y$ (e.g. noisy observation)
  * `type_shape`: scalar or vector
  * `notes`: in the optional attribute-augmented observation model,
    $v\in\mathcal{X}$ indexes attributes and does not enlarge the geometric
    domain of $Y$.

* `symbol`: $\varepsilon$
  * `ascii_name`: `eps`
  * `use`: $\varepsilon(u)$
  * `meaning`: observation noise / nugget component
  * `constraints`: typically independent across $u$

### 4.2 Mean and second-order structure

* `symbol`: $m$
  * `ascii_name`: `m`
  * `use`: $m(u)$
  * `meaning`: mean function of $Y$
  * `type_shape`: scalar function on $\mathcal{D}$
  * `notes`: mean is written as $m$ (not $\mu$) to avoid symbol collisions

* `symbol`: $C_Y$
  * `ascii_name`: `C_Y`
  * `use`: $C_Y(u,u')$
  * `meaning`: covariance function of $Y$ (RF regime only)
  * `type_shape`: scalar function or matrix-valued function (multivariate)

* `symbol`: $K_Y$
  * `ascii_name`: `K_Y`
  * `use`: $K_Y(u,u')$
  * `meaning`: correlation kernel (unit-variance kernel) when defined
  * `type_shape`: scalar function
  * `notes`: typically $C_Y(u,u')=\sigma^2 K_Y(u,u')$ in RF regimes

* `symbol`: $\gamma_V$
  * `ascii_name`: `gamma_V`
  * `use`: $\gamma_V(h)$
  * `meaning`: variogram / generalized covariance for stationary increments (GRF regime)
  * `type_shape`: scalar function on lags

### 4.3 Five-level hierarchical model notation

*category_id*: `CAT-HSM`

*authority*: `texfiles/main/common_main_models_chapter.tex`

* `symbol`: $[Z \mid Y]$
  * `ascii_name`: `Z_given_Y_theta_D`
  * `use`: $[\mathbf{Z} \mid \mathbf{Y}, \theta_D]$
  * `meaning`: data model (conditional distribution of $Z$ given latent field and data parameters)
  * `type_shape`: distributional statement
  * `authority`: five-level hierarchy notation follows `texfiles/main/common_main_models_chapter.tex`

* `symbol`: $[Y \mid w]$
  * `ascii_name`: `Y_given_w_theta_P`
  * `use`: $[\mathbf{Y} \mid \mathbf{w}(\beta), \theta_P]$
  * `meaning`: process model (latent field conditional on mean/regression component and process parameters)
  * `type_shape`: distributional statement
  * `authority`: five-level hierarchy notation follows `texfiles/main/common_main_models_chapter.tex`

* `symbol`: $w$
  * `ascii_name`: `w_beta`
  * `use`: $w(\cdot;\beta)$
  * `meaning`: mean/regression component parameterized by $\beta$
  * `type_shape`: function on $\mathcal{D}$

* `symbol`: $\theta=\{\theta_D,\theta_P,\beta\}$
  * `ascii_name`: `theta`
  * `meaning`: collection of model parameters (data, process, and regression)
  * `type_shape`: parameter set
  * `authority`: five-level hierarchy notation follows `texfiles/main/common_main_models_chapter.tex`

* `symbol`: $\vartheta$
  * `ascii_name`: `vartheta`
  * `use`: $\widehat\vartheta$, $\vartheta^\star$
  * `meaning`: full free parameter vector used by an estimation, optimization, or posterior calculation when it is broader than a single structured block $\theta$
  * `type_shape`: finite-dimensional parameter vector
  * `notes`: the exact composition is declared locally; $\theta$ retains its structured hierarchical-model meaning, while a hat denotes an estimate and a star denotes the target or data-generating value.

* `symbol`: $\theta_D$
  * `ascii_name`: `theta_D`
  * `meaning`: data-model parameters at Level 1
  * `type_shape`: parameter block

* `symbol`: $\theta_P$
  * `ascii_name`: `theta_P`
  * `meaning`: process-model parameters at Level 2
  * `type_shape`: parameter block

* `symbol`: $\beta$
  * `ascii_name`: `beta`
  * `meaning`: regression/covariate parameters in the process mean component
  * `type_shape`: parameter block or vector

* `symbol`: $\phi$
  * `ascii_name`: `phi`
  * `meaning`: microparameters governing the prior on $\theta$
  * `type_shape`: parameter set

* `symbol`: $\psi$
  * `ascii_name`: `psi`
  * `meaning`: hyperparameters
  * `type_shape`: parameter set

* `symbol`: $[\theta\mid\phi]$
  * `ascii_name`: `theta_given_phi`
  * `meaning`: parameter model, specifying the conditional law of the
    interpretable parameter collection given microparameters
  * `type_shape`: distributional statement

* `symbol`: $[\phi\mid\psi]$
  * `ascii_name`: `phi_given_psi`
  * `meaning`: microparameter model, specifying the conditional law of
    microparameters given hyperparameters
  * `type_shape`: distributional statement

* `symbol`: $[\psi]$
  * `ascii_name`: `psi_prior`
  * `meaning`: hyperparameter model or terminal prior distribution
  * `type_shape`: distributional statement

* `symbol`: $H_n$
  * `ascii_name`: `H_n`
  * `meaning`: observation operator mapping the latent field to the finite data space
  * `type_shape`: bounded linear map, often matrix-valued after discretization

* `symbol`: $\eta^*$
  * `ascii_name`: `eta_star`
  * `meaning`: linear predictor produced by the observation operator
  * `use`: $\eta^* = H_n\mathbf{Y}$
  * `type_shape`: $n$-vector

* `symbol`: $\mathbf{Z}_{(n)}$
  * `ascii_name`: `Z_n_observed_vector`
  * `meaning`: finite observed data vector
  * `type_shape`: $n$-vector

* `symbol`: $\mathbf{z}_{(n)}$
  * `ascii_name`: `z_n_realized_vector`
  * `meaning`: realized finite data vector
  * `type_shape`: $n$-vector

### 4.4 Variance parameters (project convention)

* `symbol`: $\sigma^2$
  * `ascii_name`: `sigma__2`
  * `meaning`: latent process variance (when it exists)
  * `constraints`: $\sigma^2>0$

* `symbol`: $\tau^2$
  * `ascii_name`: `tau__2`
  * `meaning`: nugget / measurement-noise variance
  * `constraints`: $\tau^2\ge 0$

### 4.5 RF vs GRF (notation-level statements)

* RF (random field):
  * pointwise variance exists (finite)
  * covariance $C_Y$ exists as a function

* GRF (generalized random field):
  * pointwise variance may not exist
  * second-order structure is encoded by generalized covariances, variograms, spectral measures, or operators

---

## 5. Kernels, representations, parameters, and family labels

*category_id*: `CAT-KERN`  
*category_scope*: kernel objects and their equivalent representations

### 5.1 Kernel as a second-order object

* `symbol`: $H$
  * `ascii_name`: `H`
  * `meaning`: generic kernel (PSD second-order object)
  * `type_shape`: function or generalized function on $\mathcal{D}\times\mathcal{D}$

### 5.2 Spectral objects

* `symbol`: $f$
  * `ascii_name`: `f`
  * `use`: $f(\xi)$
  * `meaning`: spectral density (absolutely continuous spectrum)
  * `constraints`: $f(\xi)\ge 0$ and integrable if RF covariance exists

* `symbol`: $F$
  * `ascii_name`: `F`
  * `use`: $F(d\xi)$
  * `meaning`: spectral measure (allows atoms/singular components and non-integrable behavior)
  * `constraints`: nonnegative tempered measure/distribution as required

### 5.3 Fourier conventions (Euclidean blocks)

Project convention (inverse has $(2\pi)^{-d}$):

$$
\mathcal{F}\{g\}(\xi)=\int_{\mathbb{R}^{d}} e^{-i\langle \xi,h\rangle}\, g(h)\, dh,
\qquad
\mathcal{F}^{-1}\{G\}(h)=(2\pi)^{-d}\int_{\mathbb{R}^{d}} e^{i\langle \xi,h\rangle}\, G(\xi)\, d\xi .
$$

Stationary Euclidean covariance / spectrum relation:

$$
C(h)=(2\pi)^{-d}\int_{\mathbb{R}^{d}} e^{i\langle \xi,h\rangle}\, f(\xi)\, d\xi .
$$

### 5.4 Kernel-family labels and call notation

* Kernel families have a **call notation** string (e.g. `SM`, `SE`, `GC`, `WD`) used in specs and code.
* In math, a family label may be rendered using $\mathrm{(\cdot)}$ subscripts, e.g. $H_{\mathrm{SM}}$, $f_{\mathrm{SM}}$.

### 5.5 Common parameter pool (names and meaning)

The following parameters are used across multiple kernel families (all optional; use only when relevant):

* `symbol`: $\gamma$
  * `ascii_name`: `gamma`
  * `meaning`: global scale parameter for a spectral object (or other global amplitude)
  * `constraints`: typically $\gamma>0$

* `symbol`: $\epsilon$
  * `ascii_name`: `eps`
  * `meaning`: mixture/component weights (often nonnegative and normalized by convention)
  * `constraints`: family-dependent

* `symbol`: $w_q$
  * `ascii_name`: `w_q`
  * `meaning`: mixture weight indexed by component $q$
  * `type_shape`: scalar weight
  * `notes`: use alongside $\epsilon$ when a named weight vector is needed

* `symbol`: $\epsilon_{\mathcal{S}}, \epsilon_{\mathcal{T}}, \epsilon_{\mathcal{S}\mathcal{T}}$
  * `ascii_name`: `eps_S`, `eps_T`, `eps_ST`
  * `meaning`: mixture weights for two-input constructions (e.g., product–sum / sum–product patterns)
  * `type_shape`: scalars, typically nonnegative and constrained to sum appropriately

* `symbol`: $\kappa$
  * `ascii_name`: `kappa`
  * `meaning`: inverse range / scale parameter
  * `constraints`: typically $\kappa>0$

* `symbol`: $\nu$
  * `ascii_name`: `nu`
  * `meaning`: smoothness/exponent parameter (family-dependent role)
  * `constraints`: typically $\nu>0$

* `symbol`: $\alpha$
  * `ascii_name`: `alpha`
  * `meaning`: spectral/operator exponent
  * `constraints`: typically $\alpha>0$

* `symbol`: $\lambda_{\mathrm{reg}}$
  * `ascii_name`: `lambda_reg`
  * `meaning`: generic regularization or penalty strength
  * `constraints`: $\lambda_{\mathrm{reg}}>0$
  * `notes`: use a method-specific subscript when several penalties are present; do not use $\varpi$, which is reserved for the Mellin--Barnes conic invariant.

### 5.6 Thesis product-domain spectral families

These are named specializations of the generic spectral objects in
Section 5.2. Directional subscripts identify the corresponding spatial,
temporal, or cross-block term; they do not create a new parameter family.

* `symbol`: $f_{\mathrm{Stein}},g_{\mathrm{Stein}}$
  * `ascii_name`: `f_Stein`, `g_Stein`
  * `meaning`: spectral density and multiplier for the additive
    Stein--SSMM product-domain family
  * `type_shape`: nonnegative spectral density and positive multiplier
  * `notes`: the usual parameter set is
    $(\gamma,\epsilon_S,\epsilon_T,\kappa_S,\kappa_T,
    \alpha_S,\alpha_T,\nu)$.

* `symbol`: $f_{\mathcal{GFS}},g_{\mathcal{GFS}},\mathcal{L}_{\mathcal{GFS}}$
  * `ascii_name`: `f_GFS`, `g_GFS`, `L_GFS`
  * `meaning`: spectral density, multiplier, and operator for the coupled
    GFS product-domain family
  * `type_shape`: nonnegative spectral density, positive multiplier, and
    linear operator
  * `notes`: the parameter set augments the two blockwise terms with the
    cross-block quantities
    $(\epsilon_{S1S2},\kappa_{S1S2},\alpha_{S1S2})$.

---

## 6. Operators, SPDE notation, precision / Markov structures

*category_id*: `CAT-OP`  
*category_scope*: operator-based kernel representations and precision-matrix notation

### 6.1 Operators and white noise

* `symbol`: $L$
  * `ascii_name`: `L`
  * `meaning`: (pseudo-)differential operator defining a kernel via an SPDE
  * `type_shape`: linear operator on functions/distributions on a manifold block (or on the full product manifold, when defined globally)

* `symbol`: $\mathcal{W}$
  * `name`: White-noise generalized random field
  * `math_role`: ordinary mathematical object
  * `typeface`: calligraphic uppercase W
  * `latex_source`: `\mathcal{W}`
  * `ascii_name`: `W_white_noise`
  * `meaning`: white noise (as a GRF) on the relevant manifold or product manifold
  * `type_shape`: generalized random field
  * `use`: $\mathcal{L}u=\mathcal{W}$ or $A^{s/2}Y=\mathcal{W}$
  * `notes`: the associated isonormal process is $W(h)$; the different glyphs distinguish the generalized random object from its Hilbert-space indexing map.

### 6.2 Differential operator notation

* `symbol`: $\nabla_{\mathcal{M}_k}$
  * `ascii_name`: `nabla_Mk`
  * `meaning`: gradient operator associated with the domain metric on block $\mathcal{M}_k$
  * `type_shape`: first-order differential operator mapping scalar fields to tangent vector fields
  * `notes`: on Euclidean blocks this is the usual vector of partial derivatives; on Riemannian manifolds it is the Riemannian gradient

* `symbol`: $\operatorname{div}_{\mathcal{M}_k}$
  * `name`: Manifold divergence operator
  * `math_role`: named operator with a domain subscript
  * `typeface`: upright Roman operator name; calligraphic manifold symbol; italic index
  * `latex_source`: `\operatorname{div}_{\mathcal{M}_k}`
  * `ascii_name`: `div_Mk`
  * `meaning`: divergence operator associated with the domain metric on block $\mathcal{M}_k$
  * `type_shape`: first-order differential operator mapping tangent vector fields to scalar fields
  * `notes`: on Euclidean blocks this is the usual divergence; on Riemannian manifolds it uses the metric volume form

* `symbol`: $\Delta_{\mathcal{M}_k}$
  * `ascii_name`: `Delta_Mk`
  * `meaning`: Laplacian on Euclidean block $\mathcal{M}_k$, or Laplace-Beltrami operator on a manifold block
  * `notes`: when defined, $\Delta_{\mathcal{M}_k} = \operatorname{div}_{\mathcal{M}_k}\circ\nabla_{\mathcal{M}_k}$ under the project sign convention (negative semidefinite)

### 6.3 SPDE-style Matérn operator (example notation)

$$
\left(\kappa^2 I - \Delta_{\mathcal{M}_k}\right)^{\alpha/2} Y = \mathcal{W} .
$$

### 6.4 Precision / Markov structures

* `symbol`: $Q$
  * `ascii_name`: `Q`
  * `meaning`: precision matrix/operator (inverse covariance when it exists)
  * `type_shape`: matrix (discrete setting) or operator (continuous setting)

* `symbol`: “Markov property”
  * `meaning`: local dependence structure implied by sparse $Q$ (discrete) or local operator $L$ (continuous)

Notes:

* “Kalman filter / state space” methods require additional state notation and appear in implementation/inference docs; $Q$ and $L$ are the shared kernel-level symbols.

### 6.5 FC time-varying Gaussian graphical-model notation

The FC chapter uses these objects for a sequence of Gaussian graphical models.
The assembled layered precision remains $Q$; $\Omega_t$ denotes a
within-slice precision when a time-indexed matrix representation is used.

* `symbol`: $X_t^{(i)}$
  * `ascii_name`: `X_t_i`
  * `meaning`: observation $i$ at time or slice $t$
  * `type_shape`: vector in $\mathbb{R}^p$

* `symbol`: $\Sigma_t$
  * `ascii_name`: `Sigma_t`
  * `meaning`: covariance matrix at time or slice $t$
  * `type_shape`: symmetric positive-definite $p\times p$ matrix

* `symbol`: $\Omega_t=\Sigma_t^{-1}$
  * `ascii_name`: `Omega_t`
  * `meaning`: within-slice precision matrix at time or slice $t$
  * `type_shape`: symmetric positive-definite $p\times p$ matrix
  * `notes`: off-diagonal zeros encode absent conditional-dependence edges;
    this notation is local to the time-indexed graphical-model view and does
    not replace the assembled precision $Q$.

* `symbol`: $S_t$
  * `ascii_name`: `S_t`
  * `meaning`: sample covariance matrix for the observations at time or
    slice $t$
  * `type_shape`: symmetric $p\times p$ matrix

* `symbol`: $\Omega_{V,t}$
  * `ascii_name`: `Omega_V_t`
  * `meaning`: off-diagonal portion of $\Omega_t$ used in sparsity and fused
    penalties
  * `type_shape`: symmetric $p\times p$ matrix with zero diagonal
  * `notes`: the legacy form $\Omega_{\backslash jj,t}$ denotes the same
    diagonal-removed object.

* `symbol`: $\lVert\cdot\rVert_r$
  * `ascii_name`: `norm_r`
  * `meaning`: vector or entrywise matrix $\ell_r$ norm
  * `type_shape`: nonnegative scalar

* `symbol`: $\lVert\cdot\rVert_{\max}$
  * `ascii_name`: `norm_max`
  * `meaning`: entrywise maximum norm
  * `type_shape`: nonnegative scalar

* `symbol`: $\lVert\cdot\rVert_F$
  * `ascii_name`: `norm_F`
  * `meaning`: Frobenius norm
  * `type_shape`: nonnegative scalar

* `symbol`: $\lVert\cdot\rVert_{(r,s)}$
  * `ascii_name`: `norm_r_s`
  * `meaning`: induced operator norm from $\ell_r$ to $\ell_s$
  * `type_shape`: nonnegative scalar

### 6.6 FC layered-graph and filtered-field notation

The assembled FC chapter uses the following objects to distinguish the sparse
graph generator from the generally dense covariance or propagator.

* `symbol`: $\mathsf{G}=(\mathsf{V},\mathsf{E})$
  * `ascii_name`: `G_V_E`
  * `meaning`: graph together with its vertex and edge sets
  * `type_shape`: finite graph
  * `notes`: thesis-source aliases are $\Graph$, $\Vertices$, and $\Edges$.

* `symbol`: $\mathsf{V}_{\mathrm{ST}}$
  * `ascii_name`: `V_ST`
  * `meaning`: vertex set of the layered space--time graph
  * `type_shape`: disjoint union of slice-specific vertex sets

* `symbol`: $\mathcal{N}(a)$
  * `ascii_name`: `N_a_graph`
  * `meaning`: graph neighborhood of vertex $a$
  * `type_shape`: subset of $\mathsf{V}$
  * `notes`: the thesis-source alias is $\Nbhd$; this is distinct from the target manifold $\mathcal{N}$ because it always carries a vertex argument.

* `symbol`: $\mathsf{E}_t^{\parallel}$
  * `ascii_name`: `E_t_parallel`
  * `meaning`: within-slice edge set at slice $t$
  * `type_shape`: set of unordered vertex pairs

* `symbol`: $\mathsf{E}_{tt'}^{\times}$
  * `ascii_name`: `E_tt_prime_cross`
  * `meaning`: cross-slice edge set joining slices $t$ and $t'$
  * `type_shape`: set of vertex pairs

* `symbol`: $\mathsf{d}$
  * `ascii_name`: `d_coboundary`
  * `meaning`: oriented graph coboundary or incidence operator
  * `type_shape`: linear map from vertex functions to edge functions
  * `notes`: the thesis-source alias is $\cob$; this upright graph operator is distinct from an integration differential $\mathrm{d}$.

* `symbol`: $L_{\mathrm{ST}}=\mathsf{d}^{\mathsf{T}}D_w\mathsf{d}$
  * `ascii_name`: `L_ST`
  * `meaning`: weighted layered-graph Laplacian
  * `type_shape`: symmetric positive-semidefinite matrix

* `symbol`: $Q_\theta$
  * `ascii_name`: `Q_theta`
  * `meaning`: parameterized sparse precision or graph generator
  * `type_shape`: symmetric positive-definite matrix on the proper Gaussian subspace

* `symbol`: $F_\eta$
  * `ascii_name`: `F_eta`
  * `meaning`: scalar operator form factor applied to the graph generator
  * `type_shape`: nonnegative scalar function on the spectrum of $Q_\theta$

* `symbol`: $\Gamma^{(2)}=Q_\theta F_\eta(Q_\theta)$
  * `ascii_name`: `Gamma__2`
  * `meaning`: dressed inverse propagator
  * `type_shape`: positive precision-like matrix or operator
  * `notes`: the thesis-source alias is $\InvProp$.

* `symbol`: $G^{(2)}=\{\Gamma^{(2)}\}^{-1}$
  * `ascii_name`: `G__2`
  * `meaning`: propagator or connected two-point covariance
  * `type_shape`: dense covariance matrix or operator
  * `notes`: the thesis-source alias is $\Prop$; its nonzero pattern is not the conditional-independence graph encoded by $Q_\theta$.

* `symbol`: $\rho_{\mathrm{ADMM}}$
  * `ascii_name`: `rho_ADMM`
  * `meaning`: augmented-Lagrangian penalty used by ADMM
  * `type_shape`: positive scalar
  * `notes`: do not use the unadorned $\varrho$ for this penalty; $\varrho(A)$ is reserved for the Schatten ratio in Section 12.

---

## 7. Sampling, replicates, and asymptotic design

*category_id*: `CAT-SAMP`  
*category_scope*: sample size and replicate notation; asymptotic regimes referenced by inference

### 7.1 Sampling counts

* `symbol`: $n$
  * `ascii_name`: `n`
  * `meaning`: number of distinct design points (locations) in $\mathcal{D}$
  * `type_shape`: integer

* `symbol`: $u_i$
  * `ascii_name`: `u_i`
  * `meaning`: $i$-th design point in $\mathcal{D}$
  * `type_shape`: element of $\mathcal{D}$

* `symbol`: $X_n$
  * `ascii_name`: `X_n`
  * `meaning`: set of design points at stage $n$
  * `type_shape`: finite subset of $\mathcal{D}$

### 7.2 Replicates (data level, not geometry)

* `symbol`: $R_i$
  * `ascii_name`: `R_i`
  * `meaning`: number of replicates observed at design point $u_i$
  * `type_shape`: integer, $R_i\ge 1$

* `symbol`: $R$
  * `ascii_name`: `R`
  * `meaning`: maximum replicate count across points, $R=\max_i R_i$
  * `type_shape`: integer

Notes:

* Replicates are part of the **data layout** and may be ragged; padding to length $R$ is an implementation choice.

### 7.3 Asymptotic regimes (names only)

Asymptotic-regime names are defined formally in `CT_asymptotic_specs.md`. Notation used there:

* fixed-domain (infill): domain bounded, $n\to\infty$
* increasing-domain: domain expands with $n$
* mixed/anisotropic expansion: different blocks expand at different rates

* `symbol`: $O(\cdot)$, $o(\cdot)$, $\asymp$
  * `ascii_name`: `big_O`, `little_o`, `asymp`
  * `meaning`: standard asymptotic upper-bound, negligible-order, and
    two-sided-order relations
  * `type_shape`: relations between real sequences

* `symbol`: $L_n$
  * `ascii_name`: `L_n`
  * `meaning`: domain scale parameter governing growth with $n$
  * `type_shape`: positive scalar sequence

* `symbol`: $h_n$
  * `ascii_name`: `h_n`
  * `meaning`: fill distance / resolution parameter
  * `type_shape`: positive scalar sequence

* `symbol`: $\eta_n=L_n h_n$
  * `ascii_name`: `eta_n`
  * `meaning`: balance indicator combining domain growth and resolution
  * `type_shape`: positive scalar sequence

* `symbol`: `FD_INFILL`, `ED_BALANCED`, `ED_RAPID`, `ED_DENSE`
  * `ascii_name`: `FD_INFILL`, `ED_BALANCED`, `ED_RAPID`, `ED_DENSE`
  * `meaning`: case identifiers for asymptotic design regimes
  * `type_shape`: labels / enums

### 7.4 Active-direction quadratic-variation design notation

The CT product-manifold chapter uses the following notation for Loh-type
active-direction finite differences and quadratic variations.

* `symbol`: $m_{F,n}$
  * `ascii_name`: `m_F_n`
  * `meaning`: raw active-direction grid resolution at stage $n$
  * `type_shape`: positive integer sequence

* `symbol`: $\omega_{F,n}$
  * `ascii_name`: `omega_F_n`
  * `meaning`: Loh thinning / lag-separation parameter on the active direction
  * `type_shape`: positive integer sequence

* `symbol`: $h_{F,n}$
  * `ascii_name`: `h_F_n`
  * `meaning`: active-direction lag
  * `type_shape`: positive scalar sequence
  * `definition`: $h_{F,n}=\omega_{F,n}/m_{F,n}$

* `symbol`: $N_{F,n}$
  * `ascii_name`: `N_F_n`
  * `meaning`: retained active-direction quadratic-variation block count after
    thinning
  * `type_shape`: positive integer sequence
  * `definition`: $N_{F,n}\asymp(m_{F,n}/\omega_{F,n})^{D_F}$

* `symbol`: $N_{\mathrm{raw},F,n}$
  * `ascii_name`: `N_raw_F_n`
  * `meaning`: raw active-direction sample count before thinning
  * `type_shape`: positive integer sequence
  * `definition`: $N_{\mathrm{raw},F,n}\asymp m_{F,n}^{D_F}$

* `symbol`: $\ell_F$
  * `ascii_name`: `ell_F`
  * `meaning`: active-direction finite-difference order
  * `type_shape`: positive integer
  * `constraints`: $\ell_F>\nu_F^{\mathrm{Loh}}=s_F-D_F/2$

* `symbol`: $\Gamma_{F,n}$
  * `ascii_name`: `Gamma_F_n`
  * `meaning`: covariance matrix of the active-direction differenced vector
  * `type_shape`: square covariance matrix
  * `use`: $$\lambda_{\max}(\Gamma_{F,n})^2/\operatorname{tr}(\Gamma_{F,n}^2)\to0.$$
  * `notes`: this is the Bardet--Surgailis eigenvalue condition used for the thesis-level QV CLT.

---

## 8. Reserved symbols

The following symbols are reserved and should not be repurposed without updating this file:

* $\mathcal{D}$: full domain
* $\mathcal{M}$: geometry-only domain
* $\mathcal{X}$: covariate/attribute space
* $\rho_{\mathcal{M}_k}$: metric/distance on a block (use alias when fixed, e.g., $\rho_{\mathcal{S}}$)
* $r_{\mathcal{M}_k}$: radial distance
* $h_{\mathcal{M}_k}$: Euclidean signed lag
* $Y$, $Z$: latent and observed processes
* $m$: mean function
* $\sigma^2$, $\tau^2$: latent variance and nugget variance
* $f$, $F$: spectral density and spectral measure
* $L$, $\mathcal{W}$, $Q$: operator, white noise, precision
* $\varpi$: Mellin--Barnes conic invariant
* $\varrho(A)$: Schatten ratio of an operator $A$
* $\lambda_{\mathrm{reg}}$: generic regularization weight
* $\rho_{\mathrm{ADMM}}$: ADMM penalty

---

## 9. Probability and measure theory

*category_id*: `CAT-PROB`  
*category_scope*: probability spaces, measures, integration, expectation operators

* `symbol`: $(\Omega,\mathcal{F},\mathbb{P})$
  * `ascii_name`: `Omega_F_P`
  * `meaning`: base probability space
  * `type_shape`: triple (set, $\sigma$-algebra, measure)
  * `notes`: all random elements are defined on this space unless stated otherwise

* `symbol`: $\omega\in\Omega$
  * `ascii_name`: `omega`
  * `meaning`: sample point / outcome
  * `type_shape`: element of the underlying sample space
  * `notes`: use $d\mathbb{P}(\omega)$ or $d\mathbb{P}_0(\omega)$, $d\mathbb{P}_1(\omega)$, ... to indicate integration w.r.t. specific base probability measures

* `symbol`: $d\mathbb{P}$
  * `ascii_name`: `dP`
  * `use`: $d\mathbb{P}(\omega)$, $d\mathbb{P}_i(\omega)$
  * `meaning`: probability-measure differential on $(\Omega,\mathcal{F},\mathbb{P})$
  * `type_shape`: measure element
  * `notes`: use separate symbols when multiple base measures are present (e.g. $d\mathbb{P}_0(\omega)$, $d\mathbb{P}_1(\omega)$)

* `symbol`: $\mathbb{E}$
  * `ascii_name`: `E`
  * `use`: $\mathbb{E}[\cdot]$, $\mathbb{E}[\cdot\mid\cdot]$
  * `meaning`: expectation with respect to $\mathbb{P}$
  * `type_shape`: linear functional on integrable random variables
  * `notes`: conditional expectation uses $\mathbb{E}[\cdot\mid\cdot]$

* `symbol`: $\operatorname{Var}$
  * `name`: Variance operator
  * `math_role`: named operator
  * `typeface`: upright Roman
  * `latex_source`: `\operatorname{Var}`
  * `ascii_name`: `Var`
  * `use`: $\operatorname{Var}[\cdot]$
  * `meaning`: variance under $\mathbb{P}$
  * `type_shape`: nonnegative scalar (or matrix for vector-valued arguments)
  * `notes`: covariance is written as $\operatorname{Cov}[\cdot,\cdot]$

* `symbol`: $\operatorname{Cov}$
  * `name`: Covariance operator
  * `math_role`: named operator
  * `typeface`: upright Roman
  * `latex_source`: `\operatorname{Cov}`
  * `ascii_name`: `Cov`
  * `use`: $\operatorname{Cov}[\cdot,\cdot]$, $\operatorname{Cov}_{\mathbb{P}_i}[\cdot,\cdot]$
  * `meaning`: covariance under $\mathbb{P}$
  * `type_shape`: scalar or matrix depending on the arguments
  * `notes`: for matrix-valued fields, interpret as block covariance; use $\operatorname{Cov}_{\mathbb{P}_i}$ to disambiguate measures

* `symbol`: $\mathbb{P}$
  * `ascii_name`: `P`
  * `use`: $\mathbb{P}[\cdot]$, $\mathbb{P}[\cdot\mid\cdot]$, $\mathbb{P}_i[\cdot]$
  * `meaning`: probability of an event under $\mathbb{P}$
  * `type_shape`: scalar in $[0,1]$
  * `notes`: conditional probability uses $\mathbb{P}[\cdot\mid\cdot]$; when multiple base spaces are used, decorate as $\mathbb{P}_i[\cdot]$

* `symbol`: $\mu$
  * `ascii_name`: `mu`
  * `meaning`: reference measure on a measurable space (e.g. Lebesgue or surface measure)
  * `type_shape`: measure
  * `notes`: specify the underlying space (e.g. $\mu_{\mathcal{M}_k}$) when needed

* `symbol`: $\mathbf{1}$
  * `ascii_name`: `1_indicator`
  * `use`: $\mathbf{1}_A$, $\mathbf{1}_{\{x>0\}}$
  * `meaning`: indicator of event or set $A$
  * `type_shape`: $\{0,1\}$-valued function
  * `notes`: used inside expectations and integrals

---

## 10. Probability and statistics (distributions and operators)

*category_id*: `CAT-PROBSTAT`  
*category_scope*: probability distributions, densities, distribution functions, and related operators not covered in CAT-PROB

* `symbol`: $f_X$
  * `ascii_name`: `f_X`
  * `use`: $f_X(x)$
  * `meaning`: probability density function (pdf) of random variable $X$
  * `type_shape`: nonnegative function on the support of $X$
  * `notes`: use $p_X(x)$ if a likelihood-style notation is preferred in a given spec

* `symbol`: $F_X$
  * `ascii_name`: `F_X`
  * `use`: $F_X(x)$
  * `meaning`: cumulative distribution function (cdf) of random variable $X$
  * `type_shape`: nondecreasing function with limits in $[0,1]$

* `symbol`: $\operatorname{Corr}$
  * `ascii_name`: `Corr_U_V`
  * `use`: $\operatorname{Corr}[U,V]$
  * `meaning`: correlation between random elements $U$ and $V$
  * `type_shape`: scalar or matrix (for vector-valued arguments)

* `symbol`: $\mathit{Gau}$
  * `ascii_name`: `Gau`
  * `use`: $\mathit{Gau}(\mu,\Sigma)$
  * `meaning`: Gaussian/Normal distribution with mean $\mu$ and covariance $\Sigma$ (family label)
  * `type_shape`: distribution on $\mathbb{R}^p$ (univariate uses variance $\sigma^2$)
  * `notes`: use italic `Gau` as the canonical distribution label in specs

* `symbol`: $\mathit{Bern}$
  * `ascii_name`: `Bern`
  * `use`: $\mathit{Bern}(p)$
  * `meaning`: Bernoulli distribution with success probability $p$
  * `type_shape`: distribution on $\{0,1\}$

* `symbol`: $\mathit{Pois}$
  * `ascii_name`: `Pois`
  * `use`: $\mathit{Pois}(\lambda)$
  * `meaning`: Poisson distribution with rate $\lambda>0$
  * `type_shape`: distribution on $\mathbb{N}$

* `symbol`: $\mathit{Dir}$
  * `ascii_name`: `Dir`
  * `use`: $\mathit{Dir}(\alpha)$
  * `meaning`: Dirichlet distribution with concentration vector $\alpha$
  * `type_shape`: distribution on the simplex (components nonnegative, sum to 1)

* `symbol`: $\mathit{Gam}$
  * `ascii_name`: `Gam`
  * `use`: $\mathit{Gam}(k,\theta)$
  * `meaning`: Gamma distribution with shape $k>0$ and scale $\theta>0$
  * `type_shape`: distribution on $\mathbb{R}_{>0}$

---

## 11. Controlled vocabulary (non-mathematical labels)

These are named concepts, not mathematical symbols. They are used across specs as controlled labels.

*category_id*: `CAT-VOC`

*category_scope*: stable prose labels and code-facing case identifiers

* `lag-based`, `radial`, `distance-only`: dependence types (kernel structural descriptors)
* `vector-spectral`, `radial-spectral`: spectral dependence types
* `RF`, `GRF`: kernel regimes (random field vs generalized random field)
* `exact_kalman`, `approximate_kalman`, `has_precision_representation`, `precision_sparse`: state-space / precision flags
* `FD_INFILL`, `ED_BALANCED`, `ED_RAPID`, `ED_DENSE`: asymptotic design case IDs (see detailed definitions in Section 7.3)

---

## 12. Gaussian Hilbert spaces, Wiener chaos, and Malliavin notation

*category_id*: `CAT-CHAOS`

*category_scope*: isonormal Gaussian processes, Wiener chaos, Malliavin operators, second-chaos operators, and normal-approximation diagnostics

### 12.1 Noise space and chaos decomposition

* `symbol`: $\mathfrak{H}$
  * `ascii_name`: `H_noise`
  * `use`: $\mathfrak{H}=L^2(\mathcal{M}_S\times\mathcal{M}_T)$ when the reference measure is understood
  * `meaning`: real separable Hilbert space indexing an isonormal Gaussian process
  * `type_shape`: Hilbert space
  * `notes`: distinct from the analytic Fox--H class $\mathfrak{H}_N$ and an RKHS $\mathcal{H}$.

* `symbol`: $W(h)$
  * `ascii_name`: `W_h`
  * `meaning`: isonormal Gaussian process evaluated at $h\in\mathfrak{H}$
  * `type_shape`: centered Gaussian random variable
  * `use`: $\mathbb{E}[W(h)W(g)]=\langle h,g\rangle_{\mathfrak{H}}$

* `symbol`: $I_q(f)$
  * `ascii_name`: `I_q_f`
  * `meaning`: multiple Wiener--Itô integral of order $q$
  * `type_shape`: random variable in the $q$th Wiener chaos
  * `constraints`: $f\in\mathfrak{H}^{\odot q}$

* `symbol`: $\mathcal{H}_q$
  * `ascii_name`: `H_chaos_q`
  * `meaning`: $q$th Wiener-chaos subspace
  * `type_shape`: closed subspace of $L^2(\Omega)$

* `symbol`: $f\otimes_r g$
  * `ascii_name`: `f_contract_r_g`
  * `meaning`: contraction of order $r$ between symmetric kernels $f$ and $g$
  * `type_shape`: tensor in the appropriate power of $\mathfrak{H}$

### 12.2 Malliavin operators

* `symbol`: $D$
  * `ascii_name`: `D_Malliavin`
  * `meaning`: Malliavin derivative
  * `type_shape`: closed derivative operator from random variables to $\mathfrak{H}$-valued random elements

* `symbol`: $\delta$
  * `ascii_name`: `delta_divergence`
  * `meaning`: divergence or Skorohod-integral operator, adjoint to $D$
  * `type_shape`: unbounded operator on random $\mathfrak{H}$-valued elements

* `symbol`: $L_{\mathrm{OU}}=-\delta D$
  * `ascii_name`: `L_OU`
  * `meaning`: Ornstein--Uhlenbeck generator
  * `type_shape`: self-adjoint operator on Gaussian $L^2$
  * `notes`: a locally declared Malliavin-only derivation may shorten this to $L$; cross-chapter text uses $L_{\mathrm{OU}}$ to avoid collision with the generic/SPDE operator $L$.

* `symbol`: $\Gamma(F,G)$
  * `ascii_name`: `Gamma_F_G`
  * `meaning`: carré-du-champ bilinear form
  * `type_shape`: random scalar
  * `use`: $\Gamma(F,G)=\langle DF,DG\rangle_{\mathfrak{H}}$

* `symbol`: $\mathbb{D}^{k,p}$
  * `ascii_name`: `D_Malliavin_k_p`
  * `meaning`: Malliavin--Sobolev space with $k$ derivatives in $L^p$
  * `type_shape`: Banach space of random variables

### 12.3 Second-chaos operators and approximation distances

* `symbol`: $A_f$
  * `ascii_name`: `A_f`
  * `meaning`: Hilbert--Schmidt operator associated with a symmetric second-chaos kernel $f$
  * `type_shape`: compact self-adjoint operator on $\mathfrak{H}$

* `symbol`: $\varrho(A)$
  * `ascii_name`: `varrho_A`
  * `meaning`: Schatten ratio controlling Gaussian approximation of a second-chaos quadratic form
  * `type_shape`: nonnegative scalar
  * `use`: $$\varrho(A)=\frac{\lVert A\rVert_{S_4}^2}{\lVert A\rVert_{S_2}^2}.$$
  * `notes`: $\varrho$ is reserved for this operator diagnostic; the ADMM penalty is $\rho_{\mathrm{ADMM}}$.

* `symbol`: $d_{\mathrm{TV}}$, $d_{\mathrm{Kol}}$, $d_W$
  * `ascii_name`: `d_TV`, `d_Kol`, `d_W`
  * `meaning`: total-variation, Kolmogorov, and Wasserstein probability distances
  * `type_shape`: nonnegative metrics or probability-distance functionals
  * `notes`: state the test-function convention when constants matter.


