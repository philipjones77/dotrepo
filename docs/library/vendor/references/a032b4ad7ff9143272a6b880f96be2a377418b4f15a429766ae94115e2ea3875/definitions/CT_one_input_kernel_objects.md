# One-input Kernels

---

*Status*: WORKING
*Version*: v2.3
*Date*: 2026-03-08

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `theory_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_kernel_specs.md`
* `CT_manifold_geometry_specs.md`
* `CT_asymptotic_specs.md`
* `CT_representation_specs.md`

**Is Relied Upon By:**

* inference and prediction specifications citing one-input kernels

Notes:

* Concrete one-input kernel families (formulas) live here. Numerical algorithms belong to `CT_track_implementation.md`.
* Populate every field; use `NA` if not applicable and `Not Known` if applicable but unknown.

---

## 0. Preamble

### 0.0 Summary of Contents

1. `Cov-SM`: covariance Matern (RF)  
2. `Sp-SM`: spectral Matern (RF)  
3. `Int-SM`: intrinsic Matern (GRF)  
4. `SE-SSe`: squared exponential (RF)  
5. `PE-SPe`: powered exponential (RF)  
6. `GC-SC`: generalized Cauchy (RF)  
7. `WD-SW`: Wendland (RF)  
8. `W`: white noise (GRF)  
9. `B`: Brownian increments (GRF)  
10. `fB`: fractional Brownian increments (GRF)  
11. `IntM-SpM`: Matern Sphere (RF)  
12. `TR-TrP`: torus periodic template (RF)
13. `HumanM-HU`: Intrinsic Matern Human Manifold (RF)
14. `PESp-SpE`: sphere powered exponential (RF)
15. `MaternSp-SpM`: sphere Matérn (geodesic) (RF)
16. `GcSp-SpC`: sphere generalized Cauchy (RF)
17. `DagumSp-SpD`: sphere Dagum (RF)
18. `MQSp-Sp`: sphere multiquadric (RF)
19. `SineSp-Sp`: sphere sine power (RF)
20. `Spherical-SpSph`: sphere spherical (RF)
21. `AskeySp-Sp`: sphere Askey (RF)
22. `WendC2Sp-Sp`: sphere Wendland C2 (RF)
23. `WendC4Sp-Sp`: sphere Wendland C4 (RF)

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

Defines concrete one-input kernel families, including geometry admissibility, representations, parameters, and identifiability. One-input means exactly one manifold block. This file does not define algorithms or multi-input kernels.

### 0.3 How to read this file

Call registry (0.7) and the template (0.9) live in this preamble and are numbered `0.x` to keep kernel entries starting at `## 1`. Kernel sections begin at `## 1` and follow the numbering in 0.7. Geometry supplies distances/lags; kernels do not access coordinates. In each kernel entry, use the canonical one-input domain symbol `E1`, `SP1`, `TR1`, `HU1`, `TM1`, or `DC1` as appropriate in formulas.

### 0.4 Summary of Assumptions and Preconditions

* Exactly one manifold block per kernel entry; metrics and anisotropy come from geometry.
* Kernels must consume geometry outputs only (no coordinate access).
* Identifiability uses asymptotic case IDs from `CT_asymptotic_specs.md`.

### 0.5 Notation, Inputs and Aliases

* Use canonical one-input domain symbols from `CT_kernel_specs.md`: `E1`, `SP1`, `TR1`, `HU1`, `TM1`, `DC1`.
* Distances: `r_alias`; signed lags: `h_alias` (Euclidean only).
* Spectral variable: $\xi$ with alias subscript.
* External full-name convention: use `KERNEL1-<call_notation>` when exposing one-input kernels in external interfaces; per-entry fields in this file may keep only `call_notation`.

### 0.6 Validation and Authority Rules

* This file is authoritative for one-input kernel instances; downstream summaries must match.
* Template fields must be populated with a value or explicit `NA` / `Not Known`.
* The shared kernel-core bundle is defined authoritatively in `CT_kernel_specs.md` §3.2.12; this file supplies the one-input extension fields and one-input ordering/layout.
* `supported_target_spaces` must use the random-field `target_space` vocabulary from `CT_deterministic_random_structures_objects.md`, not mean-function target choices.
* Status WORKING: additive clarifications allowed; structural changes require coordinated version bumps.

### 0.7 Call Registry

1. `Cov-SM` (Section 1)  
2. `Sp-SM` (Section 2)  
3. `Int-SM` (Section 3)  
4. `SE-SSe` (Section 4)  
5. `PE-SPe` (Section 5)  
6. `GC-SC` (Section 6)  
7. `WD-SW` (Section 7)  
8. `W` (Section 8)  
9. `B` (Section 9)  
10. `fB` (Section 10)  
11. `IntM-SpM` (Section 11)  
12. `TR-TrP` (Section 12)  
13. `HumanM-HU` (Section 13)
14. `PESp-SpE` (Section 14)  
15. `MaternSp-SpM` (Section 15)  
16. `GcSp-SpC` (Section 16)  
17. `DagumSp-SpD` (Section 17)  
18. `MQSp-Sp` (Section 18)  
19. `SineSp-Sp` (Section 19)  
20. `Spherical-SpSph` (Section 20)  
21. `AskeySp-Sp` (Section 21)  
22. `WendC2Sp-Sp` (Section 22)  
23. `WendC4Sp-Sp` (Section 23)

### 0.8 One-Input Logic

This file is the authoritative object catalog for the **one-input extension** of
the consolidated kernel-object schema in `CT_kernel_specs.md` §3.2.12.

A one-input kernel entry is interpreted as:

* one shared kernel-core bundle, and
* one one-input extension bundle.

Shared kernel-core bundle in one-input form:

* identity:
  * `kernel_name`
  * `call_notation`
  * `aliases`
  * `domain_product_symbol`
  * `parent_kernel`
  * `parent_kernel_constraints`
* admissibility:
  * `supported_target_spaces`
  * `symmetry_requirement`
  * `intrinsic_dimension_constraints`
  * `admissible_metrics`
  * `forbidden_metrics`
* construction:
  * `construction_class`
  * `base_kernels`
  * `construction_formula`
  * `construction_notes`
* parameters
* RF/GRF regime
* default representation bundle
* optional secondary representation bundles
* precision / Markov / Kalman bundle
* normalization bundle
* reparameterization bundle
* property bundle
* computational bundle
* approximation bundle
* identifiability bundle

One-input extension bundle:

* `domain_product_symbol`
  * MUST be exactly one of `E1`, `SP1`, `TR1`, `HU1`, `TM1`, `DC1`
* `domain_block_symbol`
  * MUST equal `domain_product_symbol` for one-input kernels
* `manifold_type`
* `admissible_manifolds`
* one-block geometry dependence:
  * `requires_h_k`
  * `physical_dependence_type`
  * `directional_requirements_notes`
  * `spectral_object_type`
  * `spectral_dependence_type`
  * `spectral_atoms_possible`
* one-block reduction metadata:
  * `radial_spectral_reduction`
  * `spherical_spectral_reduction`

Representation logic for one-input kernels:

* `primary_representation_id` is mandatory.
* `primary_representation_call_symbol` is mandatory.
* `primary_representation_summary` is mandatory and is the authoritative
  grouped description of the default representation.
* `supported_representation_ids` must contain `primary_representation_id`.
* `secondary_representation_details` is optional and should be populated only
  when non-default representations are being tracked intentionally.
* Zero, one, or many secondary representation bundles are allowed.
* Legacy flat representation fields in older entries are transitional only and
  should be read as non-authoritative shorthands when they disagree with the
  grouped representation bundle.

Target-space logic for one-input kernels:

* `supported_target_spaces` must use the random-field `target_space` vocabulary
  from `CT_deterministic_random_structures_objects.md`.
* For one-input kernels, this field records what target spaces the kernel can
  support as a second-order object of the random field itself, not of the mean
  function.

Identifiability logic for one-input kernels:

* `identifiability_by_case_id` is the authoritative object form.
* Legacy asymptotic fields are compatibility-only and should not be extended.

### 0.9 Template (copy/paste for new kernels)

Populate every field. If a component is not appropriate, write `NA`. If it is appropriate but unknown, write `Not Known`. Kernel sections begin at `## 1` below.

Interpret Sections `0.9.1`-`0.9.16` as the one-input formatting of the shared
kernel-core bundle plus the one-input extension defined in
`CT_kernel_specs.md` §3.2.12 and the one-input logic in Section 0.8 of this
file.

#### 0.9.1 Name

* `kernel_name`:
* `call_notation`:
* `aliases`:
* `domain_product_symbol`:
  * must be one of `E1`, `SP1`, `TR1`, `HU1`, `TM1`, `DC1`
* `parent_kernel`:
* `parent_kernel_constraints`:

#### 0.9.2 Geometry and admissibility

* `manifold_type`:
* `domain_block_symbol`:
  * must equal `domain_product_symbol`
* `admissible_manifolds`:
* `intrinsic_dimension_constraints`:
* `admissible_metrics`:
* `forbidden_metrics`:

* `supported_target_spaces`:
  * `real_scalar`:yes / no
  * `real_vector`:yes / no
  * `complex_scalar`:yes / no
  * `complex_vector`:yes / no
  * `hilbert_space`:yes / no

* `symmetry_requirement`:
  * `symmetric`:yes / no
  * `Hermitian`:yes / no
  * `self_adjoint_psd`:yes / no

#### 0.9.3 Physical-space dependence

* `requires_h_k`: yes / no
* `physical_dependence_type`: lag-based / radial / distance-only
* `directional_requirements_notes`:

#### 0.9.4 Spectral-space dependence

* `spectral_object_type`: density / measure
* `spectral_dependence_type`: vector / radial
* `spectral_atoms_possible`: yes / no

#### 0.9.5 Construction

* `construction_class`:
* `base_kernels`:
* `construction_formula`:
* `construction_notes`:

#### 0.9.6 Parameters

* `parameter_list`:
* `parameter_meanings`:
* `parameter_constraints`:
* `PSD_guarantee_mechanism`:

#### 0.9.7 RF / GRF

* `RF_or_GRF`:
* `spectral_divergence_at_zero`:
* `spectral_divergence_at_infinity`:
* `GRF_correction_methodology`:

#### 0.9.8 Representations

* `primary_representation_id`:
* `primary_representation_call_symbol`:
* `supported_representation_ids`:
  * must contain `primary_representation_id`

* `primary_representation_summary`:
  * `representation_status`: exact / approximate / induced / Not Known
  * `representation_formula_or_operator`:
  * `normalization_notes`:
  * `approximation_routes`:
  * `special_function_routes`:
  * `representation_notes`:

* `secondary_representation_details`:
  * optional list of additional grouped representation bundles, each with:
  * zero, one, or many secondary representation bundles are allowed:
    * `representation_id`
    * `representation_call_symbol`
    * `representation_status`
    * `representation_formula_or_operator`
    * `normalization_notes`
    * `approximation_routes`
    * `special_function_routes`
    * `representation_notes`

#### 0.9.9 Precision / Markov structure

* `has_precision_representation`: yes / no / approximate
* `precision_form`: explicit_matrix / operator_derived / NA
* `markov_property`: yes / no / approximate
* `locality_type`: nearest_neighbor / finite_range_markov / differential_operator_local / NA
* `precision_sparse`: yes / no / depends_on_discretization
* `sparsity_driver`: SPDE_operator_order / compact_support / graph_structure / NA
* `precision_notes`:

#### 0.9.10 State-space (Kalman) representability

* `exact_kalman`: yes / no
* `approximate_kalman`: yes / no
* `approximation_method`: rational_spectral / SPDE_discretization / state_augmentation / time_discretization / NA
* `ordering_dimension_required`: yes / no
* `error_control`:

#### 0.9.11 Normalization

* `primary_scale_parameter`: gamma / sigma2
* `normalization_regime`: RF / GRF
* `spectral_normalization`: variance_normalized / increment_normalized / NA
* `derived_scale_relation`:
* `mixed_representation_normalization`:
* `normalization_notes`:

#### 0.9.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable: yes / no / partial; notes:
* `spherical_spectral_reduction`: applicable: yes / no / NA; notes:

#### 0.9.13 Reparameterization

* `reparameterizations`:

#### 0.9.14 Properties

* `symmetry`:
* `stationarity`:
* `isotropy`:
* `separability`:
* `pointwise_variance`:
* `mean_square_continuity`:
* `differentiability_order`:
* `holder_fractal_class`:
* `short_or_long_range_dependence`:
* `compact_support`:
* `ridge_effect`:
* `stein_regularity`:

* Identifiability (case IDs from `CT_asymptotic_specs.md`):

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`:
    * `notes`:
    * `identifiable_parameter_combinations`:
  * `ED_BALANCED`:
    * `classification`:
    * `notes`:
    * `identifiable_parameter_combinations`:
  * `ED_RAPID`:
    * `classification`:
    * `notes`:
    * `identifiable_parameter_combinations`:
  * `ED_DENSE`:
    * `classification`:
    * `notes`:
    * `identifiable_parameter_combinations`:

* Legacy (kept for compatibility; prefer `identifiability_by_case_id`):
* `fixed_domain_asymptotics`:
* `increasing_domain_asymptotics`:
* `mixed_domain_asymptotics`:
* `identifiable_parameter_combinations`:
  * compatibility-only legacy fields; do not use for new entries

#### 0.9.15 Computational implications

* `dense_or_sparse_structure`:
* `fft_suitability`:
* `nufft_suitability`:
* `spde_solver_suitability`:

#### 0.9.16 Approximations

* `power_series`:
* `asymptotic_expansions`:
* `special_function_representations`:
* `numerical_approximations`:
* `approximation_representation_id`: required when any approximation entry is not `NA`; must be one of `supported_representation_ids`

---


## 1. `Cov-SM`: covariance Matern (RF)

### 1.1 Name

* `kernel_name`: Matern (covariance-first)
* `call_notation`: `Cov-SM`
* `aliases`: Matern RF
* `domain_product_symbol`: `E1`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 1.2 Geometry and admissibility

* `manifold_type`: euclidean
* `domain_block_symbol`: `E1`
* `admissible_manifolds`: euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$ domain metric; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no
  * `hilbert_space`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
  * `self_adjoint_psd`: no

### 1.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic; anisotropy only via geometry-supplied distance

### 1.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 1.5 Construction

* `construction_class`: stationary covariance; Gaussian scale mixture
* `base_kernels`: NA
* `construction_formula`: Matern covariance closed form
* `construction_notes`: PSD for all $\nu > 0$, $\kappa > 0$, $\sigma^2 > 0$

### 1.6 Parameters

* `parameter_list`: $\sigma^2$, $\kappa$, $\nu$
* `parameter_meanings`: variance, inverse range, smoothness
* `parameter_constraints`: $\sigma^2 > 0$, $\kappa > 0$, $\nu > 0$
* `PSD_guarantee_mechanism`: known PSD on $\mathbb{R}^d$

### 1.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: none for $\nu > 0$
* `spectral_divergence_at_infinity`: algebraic decay; integrable for RF
* `GRF_correction_methodology`: NA

### 1.8 Representations

* `primary_representation_id`: RF-COV-01
* `primary_representation_call_symbol`: `C`
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01

* `primary_representation_summary`:
  * `representation_status`: exact
  * `representation_formula_or_operator`: $\displaystyle C(r_{E1}) = \sigma^2 \frac{2^{1-\nu}}{\Gamma(\nu)} (\kappa r_{E1})^{\nu} K_{\nu}(\kappa r_{E1})$
  * `normalization_notes`: variance-normalized with $C(0)=\sigma^2$
  * `approximation_routes`: radial Hankel inversion, SPDE discretization, FFT/NUFFT evaluation on finite point sets
  * `special_function_routes`: modified Bessel function $K_{\nu}$
  * `representation_notes`: default one-input RF covariance representation on the Euclidean domain block `E1`

* `secondary_representation_details`:
  * `representation_id`: RF-SPEC-01
    `representation_call_symbol`: `f`
    `representation_status`: exact
    `representation_formula_or_operator`: $\displaystyle f(\xi_{E1}) = \sigma^2 (2\pi)^d \frac{\Gamma(\nu + d/2)}{\Gamma(\nu)\,\pi^{d/2}} \kappa^{2\nu} (\kappa^2 + \|\xi_{E1}\|^2)^{-(\nu + d/2)}$
    `normalization_notes`: Fourier-dual spectral density for the same RF second-order structure
    `approximation_routes`: radial spectral quadrature, FFT/NUFFT inversion on finite grids
    `special_function_routes`: gamma-function constants only
    `representation_notes`: exact stationary spectral-density representation on Euclidean frequency space
  * `representation_id`: OP-01
    `representation_call_symbol`: `L`
    `representation_status`: induced
    `representation_formula_or_operator`: $\left(\kappa^2 - \Delta\right)^{\alpha/2} Y = W$ with $\alpha = \nu + d/2$
    `normalization_notes`: operator route induces the covariance/precision semantics after specifying the driving noise normalization
    `approximation_routes`: finite-element SPDE discretization, sparse GMRF approximation
    `special_function_routes`: NA
    `representation_notes`: operator/SPDE route is exact at the continuous level for the admissible parameter relation and approximate after discretization

### 1.9 Precision / Markov structure

* `has_precision_representation`: approximate (via SPDE discretization)
* `precision_form`: operator_derived
* `markov_property`: approximate (finite-element GMRF when $\alpha$ integer)
* `locality_type`: differential_operator_local
* `precision_sparse`: depends_on_discretization
* `sparsity_driver`: SPDE_operator_order
* `precision_notes`: sparse precision arises after discretizing the SPDE

### 1.10 State-space (Kalman) representability

* `exact_kalman`: no (except special low-d cases with rational spectra)
* `approximate_kalman`: yes
* `approximation_method`: SPDE_discretization
* `ordering_dimension_required`: yes (for filtering along an ordered axis)
* `error_control`: Not Known

### 1.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized (covariance at zero is $\sigma^2$)
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 1.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 1.13 Reparameterization

* `reparameterizations`: range $\rho = \sqrt{8\nu}/\kappa$; log-parameters $(\log \sigma^2, \log \kappa, \log \nu)$

### 1.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic (geometry may supply anisotropy)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes for all $\nu > 0$
* `differentiability_order`: $\lfloor \nu - 1 \rfloor$ in mean square
* `holder_fractal_class`: Hölder exponent up to $\nu - 1$
* `short_or_long_range_dependence`: short-range
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: satisfies

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: identifiable
    * `notes`: classic fixed-domain identifiability; microergodic combos may apply
    * `identifiable_parameter_combinations`: $\sigma^2 \kappa^{2\nu}$ (when microergodic)
  * `ED_BALANCED`:
    * `classification`: identifiable
    * `notes`: balanced expansion supports joint identification
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: weakly_identifiable
    * `notes`: high-frequency reach limited; smoothness may weaken
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: identifiable
    * `notes`: strongest joint information
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: see above

### 1.15 Computational implications

* `dense_or_sparse_structure`: dense covariance; sparse precision via SPDE discretization
* `fft_suitability`: yes (regular grids)
* `nufft_suitability`: yes
* `spde_solver_suitability`: yes

### 1.16 Approximations

* `power_series`: small- and large-lag asymptotics
* `asymptotic_expansions`: Bessel $K_{\nu}$ asymptotics
* `special_function_representations`: Bessel $K_{\nu}$
* `numerical_approximations`: quadrature or FFT/NUFFT as needed
* `approximation_representation_id`: RF-COV-01

---

## 2. `Sp-SM`: spectral Matern (RF)

### 2.1 Name

* `kernel_name`: Matern spectral form
* `call_notation`: `Sp-SM`
* `aliases`: spectral Matern
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 2.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; user-defined metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 2.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic; anisotropy only via geometry-supplied distance

### 2.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 2.5 Construction

* `construction_class`: stationary spectral density
* `base_kernels`: NA
* `construction_formula`: spectral density specified directly
* `construction_notes`: nonnegative spectral density; Bochner yields an RF covariance when $\nu>d/2$ (otherwise defines a GRF)

### 2.6 Parameters

* `parameter_list`: $\gamma$, $\kappa$, $\nu$
* `parameter_meanings`: spectral scale, inverse range, spectral exponent
* `parameter_constraints`: $\gamma > 0$, $\kappa > 0$, $\nu > d/2$ for finite variance (RF)
* `PSD_guarantee_mechanism`: nonnegative spectral density

### 2.7 RF / GRF

* `RF_or_GRF`: RF when $\nu > d/2$; GRF if $\nu \le d/2$ (not covered here)
* `spectral_divergence_at_zero`: none (finite at $\xi_S=0$)
* `spectral_divergence_at_infinity`: decays algebraically; integrable if $\nu > d/2$
* `GRF_correction_methodology`: NA in RF regime

### 2.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01, RF-COV-01, OP-01


* `covariance_representation`: yes
* `covariance_formula`: $\displaystyle C(r_S) = (2\pi)^{-d} \gamma\,\frac{2^{1-(\nu - d/2)}\pi^{d/2}}{\Gamma(\nu)}\,\kappa^{d-2\nu}\,(\kappa r_S)^{\nu - d/2}\,K_{\nu - d/2}(\kappa r_S)$ (for $\nu > d/2$)
* `spectral_representation`: yes
* `spectral_formula`: $\displaystyle f(\xi_S) = \gamma \left(\kappa^{2} + \|\xi_S\|^2\right)^{-\nu}$
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: yes (same operator as covariance Matern when parameters match)
* `SPDE_operator_formula`: $\left(\kappa^2 - \Delta\right)^{\alpha/2} Y = W$ with $\alpha = \nu$ (spectral exponent interpretation)

### 2.9 Precision / Markov structure

* `has_precision_representation`: approximate (via SPDE discretization)
* `precision_form`: operator_derived
* `markov_property`: approximate (integer $\alpha$ in SPDE yields Markov discretization)
* `locality_type`: differential_operator_local
* `precision_sparse`: depends_on_discretization
* `sparsity_driver`: SPDE_operator_order
* `precision_notes`: sparsity from discretized operator when $\alpha$ integer

### 2.10 State-space (Kalman) representability

* `exact_kalman`: no (except rational-spectrum special cases)
* `approximate_kalman`: yes
* `approximation_method`: SPDE_discretization
* `ordering_dimension_required`: yes for ordered domains when filtering
* `error_control`: Not Known

### 2.11 Normalization

* `primary_scale_parameter`: gamma
* `normalization_regime`: RF
* `spectral_normalization`: not variance-normalized (primary scale is $\gamma$; see derived relation to $\sigma^2$)
* `derived_scale_relation`: $\displaystyle \sigma^2 := C(0) = (2\pi)^{-d}\int_{\mathbb{R}^d} f(\xi_S)\,d\xi_S = (2\pi)^{-d}\gamma\,\pi^{d/2}\,\kappa^{d-2\nu}\,\frac{\Gamma(\nu - d/2)}{\Gamma(\nu)}$ (RF requires $\nu > d/2$). Equivalently $\gamma = \sigma^2(2\pi)^d\,\kappa^{2\nu-d}\,\frac{\Gamma(\nu)}{\pi^{d/2}\Gamma(\nu - d/2)}$.
* `mixed_representation_normalization`: NA
* `normalization_notes`: choose $\gamma$ to hit target $\sigma^2$ via $\sigma^2=(2\pi)^{-d}\int f(\xi_S)\,d\xi_S$; $\nu$ is a spectral exponent (SPDE order $\alpha=\nu$).

### 2.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 2.13 Reparameterization

* `reparameterizations`: Map to standard covariance-first Matérn (`Cov-SM`) via $\tilde{\nu} := \nu - d/2$ (Matérn smoothness) and $\sigma^2 := (2\pi)^{-d}\gamma\,\pi^{d/2}\,\kappa^{d-2\nu}\,\Gamma(\nu - d/2)/\Gamma(\nu)$.

### 2.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic (geometry may supply anisotropy)
* `separability`: NA
* `pointwise_variance`: finite for $\nu > d/2$: $\sigma^2 = (2\pi)^{-d}\gamma\,\pi^{d/2}\,\kappa^{d-2\nu}\,\Gamma(\nu - d/2)/\Gamma(\nu)$
* `mean_square_continuity`: yes for $\nu > d/2$ (RF regime)
* `differentiability_order`: $\lfloor (\nu - d/2) - 1 \rfloor$ in mean square (same as Matérn with smoothness $\tilde{\nu}=\nu-d/2$)
* `holder_fractal_class`: Hölder exponent up to $\nu - d/2$ (RF regime)
* `short_or_long_range_dependence`: short-range
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: satisfies for $\nu$ sufficiently large

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: identifiable
    * `notes`: spectral density specified; microergodic combos may apply
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: identifiable
    * `notes`: balanced expansion supports joint identification
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: weakly_identifiable
    * `notes`: smoothness may weaken with limited high-frequency reach
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: identifiable
    * `notes`: strongest joint information
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: see above

### 2.15 Computational implications

* `dense_or_sparse_structure`: dense covariance; sparse precision via SPDE discretization
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: yes

### 2.16 Approximations

* `power_series`: small- and large-lag asymptotics via Bessel $K$
* `asymptotic_expansions`: available
* `special_function_representations`: Bessel $K_{\nu - d/2}$
* `numerical_approximations`: FFT/NUFFT for covariance from spectrum
* `approximation_representation_id`: RF-SPEC-01

---

## 3. `Int-SM`: intrinsic Matern (GRF)

### 3.1 Name

* `kernel_name`: Intrinsic Matern (generalized covariance)
* `call_notation`: `Int-SM`
* `aliases`: intrinsic Matern, generalized Matern
* `parent_kernel`: `Cov-SM`
* `parent_kernel_constraints`: limit as variance diverges or $\nu$ below RF threshold

### 3.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 3.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial (generalized)
* `directional_requirements_notes`: isotropic; anisotropy only via geometry-supplied distance

### 3.4 Spectral-space dependence

* `spectral_object_type`: measure (non-integrable density)
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 3.5 Construction

* `construction_class`: generalized covariance / intrinsic random function
* `base_kernels`: NA
* `construction_formula`: generalized Matern with non-integrable spectrum
* `construction_notes`: PSD in the intrinsic sense; requires contrasts/differences

### 3.6 Parameters

* `parameter_list`: $\kappa$, $\nu$
* `parameter_meanings`: inverse range, smoothness (intrinsic order)
* `parameter_constraints`: $\kappa > 0$, $\nu \le d/2$
* `PSD_guarantee_mechanism`: intrinsic PSD via spectral measure positivity

### 3.7 RF / GRF

* `RF_or_GRF`: GRF
* `spectral_divergence_at_zero`: diverges (non-integrable at origin)
* `spectral_divergence_at_infinity`: decays algebraically
* `GRF_correction_methodology`: increments/contrasts; remove low-order polynomials

### 3.8 Representations

* `primary_representation_id`: GRF-SPEC-01
* `supported_representation_ids`: GRF-SPEC-01, OP-01


* `covariance_representation`: no (generalized only)
* `covariance_formula`: NA
* `spectral_representation`: yes
* `spectral_formula`: $\displaystyle f(\xi_S) \propto \kappa^{2\nu} (\kappa^2 + \|\xi_S\|^2)^{-(\nu + d/2)}$ (non-integrable at zero)
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: yes (fractional operator)
* `SPDE_operator_formula`: $\left(\kappa^2 - \Delta\right)^{\alpha/2} Y = W$ with $\alpha = \nu + d/2$ (distributional)

### 3.9 Precision / Markov structure

* `has_precision_representation`: approximate (via SPDE discretization)
* `precision_form`: operator_derived
* `markov_property`: approximate when $\alpha$ integer (after discretization)
* `locality_type`: differential_operator_local (when integer order)
* `precision_sparse`: depends_on_discretization
* `sparsity_driver`: SPDE_operator_order
* `precision_notes`: intrinsic nature requires constraints in estimation

### 3.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: SPDE_discretization
* `ordering_dimension_required`: yes for filtering
* `error_control`: Not Known

### 3.11 Normalization

* `primary_scale_parameter`: NA (no finite variance)
* `normalization_regime`: GRF
* `spectral_normalization`: increment_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: use contrast-based scaling

### 3.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 3.13 Reparameterization

* `reparameterizations`: log-parameters $(\log \kappa, \log \nu)$; contrast order linkage

### 3.14 Properties

* `symmetry`: symmetric (generalized)
* `stationarity`: stationary in the intrinsic sense
* `isotropy`: isotropic (geometry may supply anisotropy)
* `separability`: NA
* `pointwise_variance`: infinite (does not exist)
* `mean_square_continuity`: NA (generalized)
* `differentiability_order`: NA (distributional)
* `holder_fractal_class`: NA
* `short_or_long_range_dependence`: long-range (due to low-frequency divergence)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: weakly_identifiable
    * `notes`: identification via increments/contrasts; microergodic combos may apply
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: weakly_identifiable
    * `notes`: intrinsic nature; needs contrast design
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: weakly_identifiable
    * `notes`: low-frequency dominance; smoothness difficult
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: weakly_identifiable
    * `notes`: contrast-based information improves
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 3.15 Computational implications

* `dense_or_sparse_structure`: dense covariance of contrasts; sparse precision via SPDE discretization
* `fft_suitability`: yes (for contrast processes)
* `nufft_suitability`: yes
* `spde_solver_suitability`: yes (with constraints)

### 3.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: SPDE discretization with constraints
* `approximation_representation_id`: GRF-SPEC-01

---


## 4. `SE-SSe`: squared exponential (RF)

### 4.1 Name

* `kernel_name`: Squared exponential (Gaussian/RBF)
* `call_notation`: `SE-SSe`
* `aliases`: Gaussian, RBF
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 4.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 4.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic; anisotropy via geometry-supplied distance

### 4.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 4.5 Construction

* `construction_class`: stationary covariance
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_S) = \sigma^2 \exp\!\left(-\frac{r_S^2}{2\ell^2}\right)$
* `construction_notes`: PSD by Gaussian form

### 4.6 Parameters

* `parameter_list`: $\sigma^2$, $\ell$
* `parameter_meanings`: variance, length-scale
* `parameter_constraints`: $\sigma^2 > 0$, $\ell > 0$
* `PSD_guarantee_mechanism`: Gaussian PSD

### 4.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: finite
* `spectral_divergence_at_infinity`: exponential decay
* `GRF_correction_methodology`: NA

### 4.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_S)$ as above
* `spectral_representation`: yes
* `spectral_formula`: $\displaystyle f(\xi_S) = \sigma^2 (2\pi \ell^2)^{d/2} \exp\!\left(-\frac{\ell^2 \|\xi_S\|^2}{2}\right)$
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 4.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 4.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes for filtering
* `error_control`: Not Known

### 4.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 4.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 4.13 Reparameterization

* `reparameterizations`: length-scale $\ell$ to inverse range $\kappa = 1/\ell$

### 4.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: infinite (analytic)
* `holder_fractal_class`: smooth
* `short_or_long_range_dependence`: short-range
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: satisfies

* `identifiability_by_case_id`:
  * `FD_INFILL`: identifiable; notes: smooth kernel; combinations: Not Known
  * `ED_BALANCED`: identifiable; notes: Not Known; combos: Not Known
  * `ED_RAPID`: weakly_identifiable; notes: smoothness may be weak; combos: Not Known
  * `ED_DENSE`: identifiable; notes: strongest info; combos: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 4.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: no

### 4.16 Approximations

* `power_series`: Taylor expansion
* `asymptotic_expansions`: available
* `special_function_representations`: Gaussian
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 5. `PE-SPe`: powered exponential (RF)

### 5.1 Name

* `kernel_name`: Powered exponential
* `call_notation`: `PE-SPe`
* `aliases`: stable exponential
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 5.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 5.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic; anisotropy via geometry-supplied distance

### 5.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 5.5 Construction

* `construction_class`: stationary covariance
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_S) = \sigma^2 \exp\!\left(-\left(\frac{r_S}{\ell}\right)^{\alpha}\right)$
* `construction_notes`: PSD for $0 < \alpha \le 2$

### 5.6 Parameters

* `parameter_list`: $\sigma^2$, $\ell$, $\alpha$
* `parameter_meanings`: variance, scale, exponent
* `parameter_constraints`: $\sigma^2 > 0$, $\ell > 0$, $0 < \alpha \le 2$
* `PSD_guarantee_mechanism`: complete monotonicity for $0<\alpha\le 2$

### 5.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: finite
* `spectral_divergence_at_infinity`: depends on $\alpha$; heavier tail for smaller $\alpha$
* `GRF_correction_methodology`: NA

### 5.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_S)$ as above
* `spectral_representation`: yes
* `spectral_formula`: Not Known (stable-law form)
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 5.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 5.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes for filtering
* `error_control`: Not Known

### 5.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 5.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 5.13 Reparameterization

* `reparameterizations`: $\kappa = 1/\ell$

### 5.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: depends on $\alpha$; infinite at $\alpha=2$, none at $\alpha \le 1$
* `holder_fractal_class`: tied to $\alpha$
* `short_or_long_range_dependence`: short-range
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: identifiable; notes: exponent may be weak; combos: Not Known
  * `ED_BALANCED`: identifiable; notes: Not Known; combos: Not Known
  * `ED_RAPID`: weakly_identifiable; notes: high-frequency limited; combos: Not Known
  * `ED_DENSE`: identifiable; notes: strongest info; combos: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 5.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: no

### 5.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: available for tails
* `special_function_representations`: Not Known
* `numerical_approximations`: rational approximations
* `approximation_representation_id`: RF-COV-01

---


## 6. `GC-SC`: generalized Cauchy (RF)

### 6.1 Name

* `kernel_name`: Generalized Cauchy
* `call_notation`: `GC-SC`
* `aliases`: Cauchy family
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 6.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 6.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic

### 6.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 6.5 Construction

* `construction_class`: stationary covariance
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_S) = \sigma^2 \left(1 + \left(\frac{r_S}{\ell}\right)^{\alpha}\right)^{-\beta/\alpha}$
* `construction_notes`: PSD when $\beta > d$ and $0 < \alpha \le 2$

### 6.6 Parameters

* `parameter_list`: $\sigma^2$, $\ell$, $\alpha$, $\beta$
* `parameter_meanings`: variance, scale, tail exponent, smoothness/shape
* `parameter_constraints`: $\sigma^2 > 0$, $\ell > 0$, $0 < \alpha \le 2$, $\beta > d$
* `PSD_guarantee_mechanism`: known PSD parameter region

### 6.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: finite
* `spectral_divergence_at_infinity`: heavy tail controlled by $\beta$
* `GRF_correction_methodology`: NA

### 6.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_S)$ as above
* `spectral_representation`: yes
* `spectral_formula`: Not Known (hypergeometric form)
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 6.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 6.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes
* `error_control`: Not Known

### 6.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 6.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 6.13 Reparameterization

* `reparameterizations`: $\kappa = 1/\ell$

### 6.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: depends on $\beta$
* `holder_fractal_class`: tied to $\beta$
* `short_or_long_range_dependence`: potentially long-range if $\beta$ small; typically short-range for $\beta>d$
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: identifiable; notes: Not Known; combos: Not Known
  * `ED_BALANCED`: identifiable; notes: Not Known; combos: Not Known
  * `ED_RAPID`: weakly_identifiable; notes: tail-dominated; combos: Not Known
  * `ED_DENSE`: identifiable; notes: strongest info; combos: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 6.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: no

### 6.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: tail expansions
* `special_function_representations`: hypergeometric (Not Known explicitly)
* `numerical_approximations`: rational/mixture approximations
* `approximation_representation_id`: RF-COV-01

---

## 7. `WD-SW`: Wendland (RF)

### 7.1 Name

* `kernel_name`: Wendland compactly supported
* `call_notation`: `WD-SW`
* `aliases`: Wendland
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 7.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 7.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic

### 7.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 7.5 Construction

* `construction_class`: compactly supported radial basis
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_S) = \sigma^2 \left(1 - \frac{r_S}{R}\right)_+^{\ell} P\!\left(\frac{r_S}{R}\right)$ (family-specific polynomial $P$)
* `construction_notes`: PSD depends on dimension and smoothness parameters

### 7.6 Parameters

* `parameter_list`: $\sigma^2$, $R$, smoothness index $\ell$
* `parameter_meanings`: variance, support radius, smoothness order
* `parameter_constraints`: $\sigma^2 > 0$, $R > 0$, $\ell$ per Wendland admissibility for $d$
* `PSD_guarantee_mechanism`: Wendland conditions for given $d$

### 7.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: finite
* `spectral_divergence_at_infinity`: spectral oscillations due to compact support
* `GRF_correction_methodology`: NA

### 7.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01


* `covariance_representation`: yes
* `covariance_formula`: family-specific polynomial as above
* `spectral_representation`: yes
* `spectral_formula`: Not Known (Bessel-type)
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 7.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no (compact support, but not Markov)
* `locality_type`: NA (compact support does not imply Markov)
* `precision_sparse`: NA (no precision representation)
* `sparsity_driver`: NA
* `precision_notes`: No sparse precision; covariance matrices are sparse due to compact support (handled under computational implications)

### 7.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes (localized approximations)
* `approximation_method`: state_augmentation
* `ordering_dimension_required`: yes for filtering
* `error_control`: Not Known

### 7.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 7.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 7.13 Reparameterization

* `reparameterizations`: support radius $R$ to $\kappa = 1/R$

### 7.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: depends on smoothness index
* `holder_fractal_class`: tied to smoothness index
* `short_or_long_range_dependence`: short-range (compact support)
* `compact_support`: yes (radius $R$)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: identifiable; notes: compact support aids sparsity; combos: Not Known
  * `ED_BALANCED`: identifiable; notes: Not Known; combos: Not Known
  * `ED_RAPID`: weakly_identifiable; notes: tail info limited; combos: Not Known
  * `ED_DENSE`: identifiable; notes: strongest info; combos: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 7.15 Computational implications

* `dense_or_sparse_structure`: sparse covariance (compact support)
* `fft_suitability`: limited (support truncation)
* `nufft_suitability`: limited
* `spde_solver_suitability`: no

### 7.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: NA
* `special_function_representations`: polynomial pieces
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---


## 8. `W`: white noise (GRF)

### 8.1 Name

* `kernel_name`: White noise
* `call_notation`: `W`
* `aliases`: nugget
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 8.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: any; distance irrelevant
* `forbidden_metrics`: none (distance not used)
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 8.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only (degenerate at zero)
* `directional_requirements_notes`: covariance zero off-diagonal

### 8.4 Spectral-space dependence

* `spectral_object_type`: constant density (flat)
* `spectral_dependence_type`: vector
* `spectral_atoms_possible`: no

### 8.5 Construction

* `construction_class`: pure nugget
* `base_kernels`: NA
* `construction_formula`: $C(r_S) = \tau^2 \mathbf{1}\{r_S = 0\}$
* `construction_notes`: PSD as white noise GRF

### 8.6 Parameters

* `parameter_list`: $\tau^2$
* `parameter_meanings`: noise variance
* `parameter_constraints`: $\tau^2 \ge 0$
* `PSD_guarantee_mechanism`: white noise PSD

### 8.7 RF / GRF

* `RF_or_GRF`: GRF
* `spectral_divergence_at_zero`: none
* `spectral_divergence_at_infinity`: flat spectrum
* `GRF_correction_methodology`: NA

### 8.8 Representations

* `primary_representation_id`: GRF-SPEC-01
* `supported_representation_ids`: GRF-SPEC-01, RF-COV-01


* `covariance_representation`: yes (degenerate)
* `covariance_formula`: $C(r_S)$ as above
* `spectral_representation`: yes
* `spectral_formula`: flat spectral density $f(\xi_S) = \tau^2$
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 8.9 Precision / Markov structure

* `has_precision_representation`: yes (diagonal)
* `precision_form`: explicit_matrix
* `markov_property`: yes (independent)
* `locality_type`: nearest_neighbor (trivial independence)
* `precision_sparse`: yes
* `sparsity_driver`: independence
* `precision_notes`: diagonal precision

### 8.10 State-space (Kalman) representability

* `exact_kalman`: yes
* `approximate_kalman`: NA
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 8.11 Normalization

* `primary_scale_parameter`: sigma2 (here $\tau^2$)
* `normalization_regime`: GRF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 8.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: NA

### 8.13 Reparameterization

* `reparameterizations`: NA

### 8.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic (degenerate)
* `separability`: NA
* `pointwise_variance`: $\tau^2$
* `mean_square_continuity`: no
* `differentiability_order`: none
* `holder_fractal_class`: NA
* `short_or_long_range_dependence`: none (independent)
* `compact_support`: yes (at zero)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: identifiable
  * `ED_BALANCED`: identifiable
  * `ED_RAPID`: identifiable
  * `ED_DENSE`: identifiable

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: NA

### 8.15 Computational implications

* `dense_or_sparse_structure`: sparse (diagonal)
* `fft_suitability`: NA
* `nufft_suitability`: NA
* `spde_solver_suitability`: NA

### 8.16 Approximations

* `power_series`: NA
* `asymptotic_expansions`: NA
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: GRF-SPEC-01

---

## 9. `B`: Brownian increments (GRF)

### 9.1 Name

* `kernel_name`: Brownian increments
* `call_notation`: `B`
* `aliases`: Brownian
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 9.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 9.3 Physical-space dependence

* `requires_h_k`: yes
* `physical_dependence_type`: lag-based (increments)
* `directional_requirements_notes`: Euclidean only

### 9.4 Spectral-space dependence

* `spectral_object_type`: measure
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 9.5 Construction

* `construction_class`: intrinsic GRF (order 1 increments)
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(h_S) = \tau^2 \min(u_S, v_S)$ (1D) or $\propto \|h_S\|$ increments
* `construction_notes`: generalized covariance; PSD for increments

### 9.6 Parameters

* `parameter_list`: $\tau^2$
* `parameter_meanings`: scale of increments
* `parameter_constraints`: $\tau^2 > 0$
* `PSD_guarantee_mechanism`: intrinsic PSD

### 9.7 RF / GRF

* `RF_or_GRF`: GRF
* `spectral_divergence_at_zero`: diverges
* `spectral_divergence_at_infinity`: decays
* `GRF_correction_methodology`: increments

### 9.8 Representations

* `primary_representation_id`: GRF-SPEC-01
* `supported_representation_ids`: GRF-SPEC-01, OP-01
* `covariance_representation`: no (generalized; increments only)
* `covariance_formula`: NA
* `spectral_representation`: yes
* `spectral_formula`: $\displaystyle f(\xi_S) \propto \|\xi_S\|^{-2}$ (1D), general dimension analogous
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: yes (Laplacian inverse)
* `SPDE_operator_formula`: $-\Delta Y = W$ (distributional)

### 9.9 Precision / Markov structure

* `has_precision_representation`: approximate (discrete random walk)
* `precision_form`: operator_derived
* `markov_property`: yes (Markov in 1D increments)
* `locality_type`: nearest_neighbor (discrete)
* `precision_sparse`: yes (discrete RW)
* `sparsity_driver`: operator order
* `precision_notes`: requires boundary conditions

### 9.10 State-space (Kalman) representability

* `exact_kalman`: yes (1D ordered)
* `approximate_kalman`: yes
* `approximation_method`: state_augmentation
* `ordering_dimension_required`: yes
* `error_control`: Not Known

### 9.11 Normalization

* `primary_scale_parameter`: sigma2 (here $\tau^2$)
* `normalization_regime`: GRF
* `spectral_normalization`: increment_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 9.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 9.13 Reparameterization

* `reparameterizations`: NA

### 9.14 Properties

* `symmetry`: symmetric (increments)
* `stationarity`: stationary increments
* `isotropy`: isotropic (Euclidean)
* `separability`: NA
* `pointwise_variance`: infinite
* `mean_square_continuity`: yes (increments)
* `differentiability_order`: none
* `holder_fractal_class`: 1/2 in 1D
* `short_or_long_range_dependence`: depends on dimension; often long-range low-freq
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: weakly_identifiable
  * `ED_BALANCED`: weakly_identifiable
  * `ED_RAPID`: weakly_identifiable
  * `ED_DENSE`: identifiable (increments abundant)

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: NA

### 9.15 Computational implications

* `dense_or_sparse_structure`: sparse precision for discrete RW
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: yes

### 9.16 Approximations

* `power_series`: NA
* `asymptotic_expansions`: NA
* `special_function_representations`: NA
* `numerical_approximations`: discrete RW
* `approximation_representation_id`: GRF-SPEC-01

---

## 10. `fB`: fractional Brownian increments (GRF)

### 10.1 Name

* `kernel_name`: Fractional Brownian increments
* `call_notation`: `fB`
* `aliases`: fBm increments
* `parent_kernel`: `B`
* `parent_kernel_constraints`: NA

### 10.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed
* `forbidden_metrics`: non-Euclidean manifolds
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 10.3 Physical-space dependence

* `requires_h_k`: yes
* `physical_dependence_type`: lag-based (increments)
* `directional_requirements_notes`: Euclidean only

### 10.4 Spectral-space dependence

* `spectral_object_type`: measure
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 10.5 Construction

* `construction_class`: intrinsic GRF (order determined by Hurst)
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(h_S) = \frac{\sigma^2}{2} \left(\|u_S\|^{2H} + \|v_S\|^{2H} - \|h_S\|^{2H}\right)$
* `construction_notes`: PSD for $0 < H < 1$

### 10.6 Parameters

* `parameter_list`: $\sigma^2$, $H$
* `parameter_meanings`: scale, Hurst exponent
* `parameter_constraints`: $\sigma^2 > 0$, $0 < H < 1$
* `PSD_guarantee_mechanism`: known PSD of fBm increments

### 10.7 RF / GRF

* `RF_or_GRF`: GRF
* `spectral_divergence_at_zero`: diverges for $H < 1$
* `spectral_divergence_at_infinity`: decays as $\|\xi_S\|^{-(2H + d)}$
* `GRF_correction_methodology`: increments

### 10.8 Representations

* `primary_representation_id`: GRF-SPEC-01
* `supported_representation_ids`: GRF-SPEC-01


* `covariance_representation`: yes (increment form)
* `covariance_formula`: as above
* `spectral_representation`: yes
* `spectral_formula`: $\displaystyle f(\xi_S) \propto \|\xi_S\|^{-(2H + d)}$
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 10.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no (except $H=1/2$ reduces to Brownian)
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 10.10 State-space (Kalman) representability

* `exact_kalman`: yes for $H=1/2$; otherwise no
* `approximate_kalman`: yes
* `approximation_method`: state_augmentation
* `ordering_dimension_required`: yes
* `error_control`: Not Known

### 10.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: GRF
* `spectral_normalization`: increment_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 10.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable
* `spherical_spectral_reduction`: NA

### 10.13 Reparameterization

* `reparameterizations`: NA

### 10.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary increments
* `isotropy`: isotropic
* `separability`: NA
* `pointwise_variance`: infinite
* `mean_square_continuity`: yes
* `differentiability_order`: none
* `holder_fractal_class`: $H$
* `short_or_long_range_dependence`: long-range for $H>1/2$; short-range for $H<1/2$
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: weakly_identifiable
  * `ED_BALANCED`: weakly_identifiable
  * `ED_RAPID`: weakly_identifiable
  * `ED_DENSE`: identifiable

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: NA

### 10.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: limited

### 10.16 Approximations

* `power_series`: NA
* `asymptotic_expansions`: NA
* `special_function_representations`: NA
* `numerical_approximations`: circulant embeddings, wavelets
* `approximation_representation_id`: GRF-SPEC-01

---

## 11. `IntM-SpM`: Matern Sphere (RF)

### 11.1 Name

* `kernel_name`: Matern Sphere
* `call_notation`: `IntM-SpM`
* `aliases`: Whittle–Matérn on sphere; spherical Matérn; SPDE Matérn on compact manifold
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 11.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 2$
* `admissible_metrics`: geodesic distance on sphere (great-circle distance)
* `forbidden_metrics`: Euclidean chordal distance unless explicitly provided as a separate geometry choice; arbitrary user-defined non-geodesic metrics
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 11.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: rotation-invariant (isotropic) on the sphere; dependence only through geodesic distance $r_{SP}\in[0,\pi]$

### 11.4 Spectral-space dependence

* `spectral_object_type`: measure (harmonic coefficients indexed by degree)
* `spectral_dependence_type`: radial (by harmonic degree $\ell$)
* `spectral_atoms_possible`: yes (finite-harmonic truncations)

### 11.5 Construction

* `construction_class`: Whittle–Matérn / SPDE-defined Gaussian RF on compact manifold
* `base_kernels`: NA
* `construction_formula`: define $Y$ as the (mean-zero) weak solution of $\left(\kappa^2 - \Delta_{\mathbb{S}^d}\right)^{\alpha/2} Y = W$ on $\mathbb{S}^d$, where $\Delta_{\mathbb{S}^d}$ is the Laplace–Beltrami operator and $W$ is Gaussian white noise on $\mathbb{S}^d$
* `construction_notes`: PSD follows because the covariance operator is $\left(\kappa^2 - \Delta_{\mathbb{S}^d}\right)^{-\alpha}$, a self-adjoint, positive operator on $L^2(\mathbb{S}^d)$; isotropy follows from rotational invariance of $\Delta_{\mathbb{S}^d}$

### 11.6 Parameters

* `parameter_list`: $\sigma^2$, $\kappa$, $\nu$ (equivalently $\alpha = \nu + d/2$)
* `parameter_meanings`: marginal variance, inverse range, smoothness (Sobolev / mean-square differentiability)
* `parameter_constraints`: $\sigma^2>0$, $\kappa>0$, $\nu>0$ (equivalently $\alpha>d/2$ for an RF on $\mathbb{S}^d$)
* `PSD_guarantee_mechanism`: inverse fractional elliptic operator on a compact manifold (spectral calculus)

### 11.7 RF / GRF

* `RF_or_GRF`: RF when $\alpha > d/2$ (finite pointwise variance on compact sphere)
* `spectral_divergence_at_zero`: none (discrete spectrum; lowest mode controlled by $\kappa$)
* `spectral_divergence_at_infinity`: polynomial decay in harmonic degree (controlled by $\alpha$)
* `GRF_correction_methodology`: NA (RF regime)

### 11.8 Representations

* `primary_representation_id`: OP-01
* `supported_representation_ids`: OP-01, RF-SPEC-01, RF-COV-01


* `covariance_representation`: yes (harmonic series)
* `covariance_formula`: $\displaystyle C(r_{SP}) = \sum_{\ell=0}^{\infty} b_{\ell}\,P_{\ell}^{(d)}(\cos r_{SP})$ with $b_{\ell}\ge 0$ and $P_{\ell}^{(d)}$ the Gegenbauer/Legendre-type polynomial appropriate for $\mathbb{S}^d$
* `spectral_representation`: yes
* `spectral_formula`: $\displaystyle b_{\ell} = c\,(\kappa^2 + \lambda_{\ell})^{-\alpha}$ with Laplace–Beltrami eigenvalues $\lambda_{\ell}=\ell(\ell+d-1)$ and normalization constant $c$ chosen so that $C(0)=\sigma^2$
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: yes
* `SPDE_operator_formula`: $\left(\kappa^2 - \Delta_{\mathbb{S}^d}\right)^{\alpha/2} Y = W$ with $\alpha = \nu + d/2$ and $\operatorname{Var}(Y(x))=\sigma^2$

### 11.9 Precision / Markov structure

* `has_precision_representation`: yes
* `precision_form`: operator_derived
* `markov_property`: approximate (exact at the operator level; sparse GMRF after discretization when $\alpha$ integer)
* `locality_type`: differential_operator_local
* `precision_sparse`: depends_on_discretization
* `sparsity_driver`: SPDE_operator_order
* `precision_notes`: discretization via finite elements on a spherical triangulation yields a sparse precision matrix (GMRF) for integer $\alpha$; otherwise approximate via rational/SPDE discretization

### 11.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: SPDE_discretization
* `ordering_dimension_required`: no
* `error_control`: Not Known

### 11.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized (choose $c$ so $C(0)=\sigma^2$)
* `derived_scale_relation`: $\sigma^2$ determined by the trace / pointwise variance of $\left(\kappa^2 - \Delta_{\mathbb{S}^d}\right)^{-\alpha}$ under the chosen normalization
* `mixed_representation_normalization`: NA
* `normalization_notes`: on compact domains the variance is finite in the RF regime; scaling can be implemented either through $c$ in $b_{\ell}$ or by scaling the white-noise amplitude

### 11.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA (natural basis is harmonic)
* `spherical_spectral_reduction`: applicable (harmonic eigen-expansion)

### 11.13 Reparameterization

* `reparameterizations`: practical range proxy via $\kappa$ (e.g., use $\rho=\sqrt{8\nu}/\kappa$ as Euclidean analogue); log-parameters $(\log \sigma^2, \log \kappa, \log \nu)$

### 11.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant under rotations (not translation-stationary)
* `isotropy`: isotropic
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes (RF regime)
* `differentiability_order`: mean-square differentiable of order $m$ iff $\nu>m$
* `holder_fractal_class`: Hölder exponent up to $\nu-1$
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: satisfies (operator-defined smoothness away from coincident points)

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: identifiable (compact manifold; discrete spectrum)
    * `notes`: parameter identifiability depends on sampling regime and chosen parameterization; microergodic combinations may appear in fixed-domain limits
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: NA (compact)
    * `notes`: NA
    * `identifiable_parameter_combinations`: NA
  * `ED_RAPID`:
    * `classification`: NA (compact)
    * `notes`: NA
    * `identifiable_parameter_combinations`: NA
  * `ED_DENSE`:
    * `classification`: NA (compact)
    * `notes`: NA
    * `identifiable_parameter_combinations`: NA

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 11.15 Computational implications

* `dense_or_sparse_structure`: dense covariance; sparse precision via SPDE discretization
* `fft_suitability`: spherical harmonics (diagonal in harmonic domain)
* `nufft_suitability`: NA
* `spde_solver_suitability`: yes

### 11.16 Approximations

* `power_series`: small-distance expansions via harmonic tail
* `asymptotic_expansions`: large-degree asymptotics of $\lambda_{\ell}$ and Gegenbauer polynomials
* `special_function_representations`: Gegenbauer/Legendre polynomials; spherical harmonics
* `numerical_approximations`: harmonic truncation; FEM/SPDE discretization; rational approximations for fractional powers
* `approximation_representation_id`: OP-01

---



## 12. `TR-TrP`: torus periodic template (RF)

### 12.1 Name

* `kernel_name`: Torus periodic template
* `call_notation`: `TR-TrP`
* `aliases`: periodic kernel
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 12.2 Geometry and admissibility

* `manifold_type`: torus
* `admissible_manifolds`: torus (`TR` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: wrapped Euclidean with periods
* `forbidden_metrics`: non-wrapped metrics
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 12.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only (wrapped)
* `directional_requirements_notes`: periodic distance

### 12.4 Spectral-space dependence

* `spectral_object_type`: measure (Fourier series coefficients)
* `spectral_dependence_type`: vector (integer lattice)
* `spectral_atoms_possible`: yes (Fourier atoms)

### 12.5 Construction

* `construction_class`: periodic kernel via Fourier series
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{TR}) = \sum_{k\in \mathbb{Z}^d} a_k e^{i \langle k, \theta \rangle}$ with $r_{TR}$ encoded via wrapped angles $\theta$
* `construction_notes`: PSD when $a_k \ge 0$

### 12.6 Parameters

* `parameter_list`: $\{a_k\}$
* `parameter_meanings`: Fourier coefficients
* `parameter_constraints`: $a_k \ge 0$
* `PSD_guarantee_mechanism`: nonnegative coefficients

### 12.7 RF / GRF

* `RF_or_GRF`: RF (coefficients summable)
* `spectral_divergence_at_zero`: depends on $a_k$
* `spectral_divergence_at_infinity`: controlled by tail of $a_k$
* `GRF_correction_methodology`: NA

### 12.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01


* `covariance_representation`: yes
* `covariance_formula`: Fourier series as above
* `spectral_representation`: yes
* `spectral_formula`: $a_k$ on integer lattice
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no standard
* `SPDE_operator_formula`: NA

### 12.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 12.10 State-space (Kalman) representability

* `exact_kalman`: yes for 1D periodic via state-space with harmonics
* `approximate_kalman`: yes
* `approximation_method`: state_augmentation
* `ordering_dimension_required`: yes (angle)
* `error_control`: Not Known

### 12.11 Normalization

* `primary_scale_parameter`: sigma2 (via $\sum a_k$)
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\sum a_k$ finite
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 12.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: NA

### 12.13 Reparameterization

* `reparameterizations`: decay laws for $a_k$

### 12.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary on torus
* `isotropy`: isotropic if $a_k$ radial in $k$
* `separability`: NA
* `pointwise_variance`: finite if $\sum a_k < \infty$
* `mean_square_continuity`: yes if coefficients decay
* `differentiability_order`: linked to decay rate
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: short-range (compact domain)
* `compact_support`: no (periodic)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: identifiable (compact)
  * `ED_BALANCED`: NA (compact)
  * `ED_RAPID`: NA (compact)
  * `ED_DENSE`: NA (compact)

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 12.15 Computational implications

* `dense_or_sparse_structure`: dense covariance; diagonal in Fourier domain
* `fft_suitability`: yes (DFT on grid)
* `nufft_suitability`: yes
* `spde_solver_suitability`: NA

### 12.16 Approximations

* `power_series`: NA
* `asymptotic_expansions`: NA
* `special_function_representations`: Fourier series
* `numerical_approximations`: harmonic truncation
* `approximation_representation_id`: RF-COV-01

---

## 13. `HumanM-HU`: Intrinsic Matern Human Manifold (RF)

### 13.1 Name

* `kernel_name`: Intrinsic Matern Human Manifold
* `call_notation`: `HumanM-HU`
* `aliases`: human-manifold Matern; mesh-geodesic Matern on human domain
* `parent_kernel`: `Cov-SM`
* `parent_kernel_constraints`: uses human-manifold geometry outputs (`r_{HU}`) from domain block definition

### 13.2 Geometry and admissibility

* `manifold_type`: human_manifold
* `admissible_manifolds`: human_manifold (`HU` alias)
* `intrinsic_dimension_constraints`: mesh-native 2D surface in embedding space (as defined by domain metadata)
* `admissible_metrics`: `human_mesh_geodesic`; embedded `l2` only when explicitly configured by geometry
* `forbidden_metrics`: arbitrary non-geodesic user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 13.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on the human manifold under the configured domain metric; dependence through geodesic distance $r_{HU}$

### 13.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial (embedding-frequency approximation for spectral routes)
* `spectral_atoms_possible`: no

### 13.5 Construction

* `construction_class`: covariance-first Matérn transferred to mesh-native human manifold via geometry-provided distances
* `base_kernels`: `Cov-SM`
* `construction_formula`: $\displaystyle C(r_{HU})=\sigma^2 \frac{2^{1-\nu}}{\Gamma(\nu)}\left(\frac{\sqrt{2\nu}\,r_{HU}}{\ell}\right)^\nu K_\nu\!\left(\frac{\sqrt{2\nu}\,r_{HU}}{\ell}\right)$
* `construction_notes`: runtime consumes `LagFeatures.r` from the human manifold block; no coordinate access in kernel

### 13.6 Parameters

* `parameter_list`: $\sigma^2$, $\ell$, $\nu$
* `parameter_meanings`: marginal variance, lengthscale, smoothness
* `parameter_constraints`: $\sigma^2 > 0$, $\ell > 0$, $\nu > 0$
* `PSD_guarantee_mechanism`: Matérn PSD form applied to valid domain metric distances

### 13.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: no
* `spectral_divergence_at_infinity`: polynomial decay
* `GRF_correction_methodology`: NA

### 13.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01


* `covariance_representation`: yes
* `covariance_formula`: Matérn covariance in $r_{HU}$
* `spectral_representation`: yes (approximate embedded-coordinate route when domain spectral representation is available)
* `spectral_formula`: Matérn spectral density in embedding-frequency coordinates
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no (not mandated)
* `SPDE_operator_formula`: NA

### 13.9 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `locality_type`: differential_operator_local
* `precision_sparse`: depends_on_discretization
* `sparsity_driver`: graph_structure
* `precision_notes`: sparse precision may arise from mesh/SPDE approximations; dense covariance is default

### 13.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: SPDE_discretization
* `ordering_dimension_required`: no
* `error_control`: Not Known

### 13.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: same as covariance Matérn normalization
* `mixed_representation_normalization`: NA
* `normalization_notes`: choose parameters so diagonal variance matches $\sigma^2$

### 13.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable in embedding-frequency approximation
* `spherical_spectral_reduction`: NA

### 13.13 Reparameterization

* `reparameterizations`: $(\log \sigma^2,\log \ell,\log \nu)$

### 13.14 Properties

* `symmetry`: symmetric
* `stationarity`: metric-stationary with respect to human manifold geodesic metric (not Euclidean translation-stationary)
* `isotropy`: yes (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: increases with $\nu$
* `holder_fractal_class`: controlled by $\nu$
* `short_or_long_range_dependence`: short-range
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`: weakly_identifiable
  * `ED_BALANCED`: identifiable
  * `ED_RAPID`: identifiable
  * `ED_DENSE`: identifiable

* `fixed_domain_asymptotics`: microergodic combinations may dominate
* `increasing_domain_asymptotics`: identifiable
* `mixed_domain_asymptotics`: identifiable
* `identifiable_parameter_combinations`: $(\sigma^2,\ell,\nu)$ up to fixed-domain equivalence classes

### 13.15 Computational implications

* `dense_or_sparse_structure`: dense covariance by default
* `fft_suitability`: limited (only via embedding-frequency approximation for compatible point layouts)
* `nufft_suitability`: possible in embedding-frequency approximation
* `spde_solver_suitability`: possible with mesh-based approximations

### 13.16 Approximations

* `power_series`: small-distance Matérn expansion
* `asymptotic_expansions`: large-distance Matérn/Bessel decay
* `special_function_representations`: modified Bessel $K_\nu$
* `numerical_approximations`: mesh-geodesic precompute; embedded spectral quadrature; sparse SPDE approximations
* `approximation_representation_id`: RF-COV-01

---

## 14. `PESp-SpE`: sphere powered exponential (RF)

### 14.1 Name

* `kernel_name`: Sphere powered exponential
* `call_notation`: `PESp-SpE`
* `aliases`: sphere powered exponential; geodesic powered exponential
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 14.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 14.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 14.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 14.5 Construction

* `construction_class`: stationary covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2 \exp\!\left(-\left(\frac{r_{SP}}{c}\right)^{\alpha}\right)$
* `construction_notes`: PSD on $\mathbb{S}^d$ for $0<\alpha\le 1$ (uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret r as \\theta))

### 14.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\alpha$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, range/scale, exponent; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c > 0$, $\alpha \in (0,1]$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 14.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 14.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 14.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 14.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 14.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 14.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 14.13 Reparameterization

* `reparameterizations`: NA

### 14.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known (depends on $\alpha$)
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 14.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 14.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 15. `MaternSp-SpM`: sphere Matérn (geodesic) (RF)

### 15.1 Name

* `kernel_name`: Sphere Matérn (geodesic)
* `call_notation`: `MaternSp-SpM`
* `aliases`: geodesic Matérn on sphere
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 15.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 15.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 15.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 15.5 Construction

* `construction_class`: stationary covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2 \frac{2^{1-\nu}}{\Gamma(\nu)}\left(\frac{r_{SP}}{c}\right)^{\nu} K_{\nu}\!\left(\frac{r_{SP}}{c}\right)$
* `construction_notes`: PSD on $\mathbb{S}^d$ for $\nu \in (0, 1/2]$ (geodesic Matérn); normalized so $C(0)=\sigma^2$

### 15.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\nu$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, range/scale, smoothness; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c > 0$, $\nu \in (0, 1/2]$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 15.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 15.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 15.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 15.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 15.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 15.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 15.13 Reparameterization

* `reparameterizations`: NA

### 15.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known (depends on $\nu$)
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 15.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 15.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Bessel $K_{\nu}$ asymptotics
* `special_function_representations`: modified Bessel $K_{\nu}$
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 16. `GcSp-SpC`: sphere generalized Cauchy (RF)

### 16.1 Name

* `kernel_name`: Sphere generalized Cauchy
* `call_notation`: `GcSp-SpC`
* `aliases`: sphere Cauchy family
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 16.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 16.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 16.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 16.5 Construction

* `construction_class`: stationary covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2 \left(1+\left(\frac{r_{SP}}{c}\right)^\alpha\right)^{-\tau / \alpha}$
* `construction_notes`: PSD on $\mathbb{S}^d$ for $0<\alpha\le 1$, $\tau>0$

### 16.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\alpha$, $\tau$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, range/scale, exponent, tail parameter; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c > 0$, $\alpha \in (0,1]$, $\tau > 0$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 16.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 16.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 16.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 16.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 16.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 16.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 16.13 Reparameterization

* `reparameterizations`: NA

### 16.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 16.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 16.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 17. `DagumSp-SpD`: sphere Dagum (RF)

### 17.1 Name

* `kernel_name`: Sphere Dagum
* `call_notation`: `DagumSp-SpD`
* `aliases`: sphere Dagum family
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 17.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 17.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 17.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 17.5 Construction

* `construction_class`: stationary covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\left[1-\left(\left(\frac{r_{SP}}{c}\right)^\tau /\left(1+\frac{r_{SP}}{c}\right)^\tau\right)^{\alpha / \tau}\right]$
* `construction_notes`: PSD on $\mathbb{S}^d$ for $\tau \in (0,1]$, $\alpha \in (0,\tau)$

### 17.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\tau$, $\alpha$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, range/scale, tail parameter, shape; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c > 0$, $\tau \in (0,1]$, $\alpha \in (0,\tau)$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 17.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 17.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 17.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 17.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 17.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 17.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 17.13 Reparameterization

* `reparameterizations`: NA

### 17.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 17.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 17.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 18. `MQSp-Sp`: sphere multiquadric (RF)

### 18.1 Name

* `kernel_name`: Sphere multiquadric
* `call_notation`: `MQSp-Sp`
* `aliases`: sphere multiquadric
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 18.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 18.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 18.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 18.5 Construction

* `construction_class`: stationary covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\,(1-\delta)^{2 \tau} /\left(1+\delta^2-2 \delta \cos r_{SP}\right)^\tau$
* `construction_notes`: PSD on $\mathbb{S}^d$ for $\tau>0$, $\delta \in (0,1)$; uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret r as \\theta)

### 18.6 Parameters

* `parameter_list`: $\sigma^2$, $\tau$, $\delta$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, smoothness/shape, multiquadric parameter; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $\tau > 0$, $\delta \in (0,1)$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 18.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 18.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 18.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 18.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 18.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 18.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 18.13 Reparameterization

* `reparameterizations`: NA

### 18.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 18.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 18.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01














## 19. `SineSp-Sp`: sphere sine power (RF)

### 19.1 Name

* `kernel_name`: Sphere sine power
* `call_notation`: `SineSp-Sp`
* `aliases`: sphere sine power
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 19.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 19.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 19.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 19.5 Construction

* `construction_class`: stationary covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\left[1-\left(\sin \frac{r_{SP}}{2}\right)^\alpha\right]$
* `construction_notes`: PSD on $\mathbb{S}^d$ for $\alpha \in (0,2)$

### 19.6 Parameters

* `parameter_list`: $\sigma^2$, $\alpha$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, exponent; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $\alpha \in (0,2)$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 19.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 19.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 19.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 19.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 19.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 19.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 19.13 Reparameterization

* `reparameterizations`: NA

### 19.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 19.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 19.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 20. `Spherical-SpSph`: sphere spherical (RF)

### 20.1 Name

* `kernel_name`: Sphere spherical
* `call_notation`: `Spherical-SpSph`
* `aliases`: sphere spherical
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 20.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 20.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 20.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 20.5 Construction

* `construction_class`: compactly supported covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\left(1+\frac{1}{2} \frac{r_{SP}}{c}\right)\left(1-\frac{r_{SP}}{c}\right)_{+}^2$
* `construction_notes`: compact support for $r_{SP} \le c$

### 20.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, support/range; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c > 0$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 20.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 20.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 20.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 20.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 20.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 20.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 20.13 Reparameterization

* `reparameterizations`: NA

### 20.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: yes (range $c$)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 20.15 Computational implications

* `dense_or_sparse_structure`: sparse via compact support in distance-based covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 20.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 21. `AskeySp-Sp`: sphere Askey (RF)

### 21.1 Name

* `kernel_name`: Sphere Askey
* `call_notation`: `AskeySp-Sp`
* `aliases`: sphere Askey
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 21.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 21.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 21.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 21.5 Construction

* `construction_class`: compactly supported covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\left(1-\frac{r_{SP}}{c}\right)_{+}^{\tau}$
* `construction_notes`: compact support for $r_{SP} \le c$

### 21.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\tau$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, support/range, smoothness parameter; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c > 0$, $\tau \ge 2$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 21.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 21.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 21.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 21.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 21.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 21.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 21.13 Reparameterization

* `reparameterizations`: NA

### 21.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: yes (range $c$)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 21.15 Computational implications

* `dense_or_sparse_structure`: sparse via compact support in distance-based covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 21.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 22. `WendC2Sp-Sp`: sphere Wendland C2 (RF)

### 22.1 Name

* `kernel_name`: Sphere Wendland C2
* `call_notation`: `WendC2Sp-Sp`
* `aliases`: sphere Wendland C2
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 22.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 22.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 22.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 22.5 Construction

* `construction_class`: compactly supported covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\left(1+\tau \frac{r_{SP}}{c}\right)\left(1-\frac{r_{SP}}{c}\right)_{+}^{\tau}$
* `construction_notes`: compact support for $r_{SP} \le c$

### 22.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\tau$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, support/range, smoothness parameter; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c \in (0,\pi]$, $\tau \ge 4$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 22.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 22.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 22.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 22.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 22.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 22.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 22.13 Reparameterization

* `reparameterizations`: NA

### 22.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: yes (range $c$)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 22.15 Computational implications

* `dense_or_sparse_structure`: sparse via compact support in distance-based covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 22.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01

---

## 23. `WendC4Sp-Sp`: sphere Wendland C4 (RF)

### 23.1 Name

* `kernel_name`: Sphere Wendland C4
* `call_notation`: `WendC4Sp-Sp`
* `aliases`: sphere Wendland C4
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 23.2 Geometry and admissibility

* `manifold_type`: sphere
* `admissible_manifolds`: sphere (`SP` alias)
* `intrinsic_dimension_constraints`: $d \ge 1$
* `admissible_metrics`: sphere geodesic / great-circle distance
* `forbidden_metrics`: non-geodesic sphere metrics unless explicitly represented in manifold geometry
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 23.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: distance-only
* `directional_requirements_notes`: isotropic on sphere; dependence only through geodesic distance $r_{SP}$; angular form uses \\theta = r_{SP}/R (set `distance_mode` = `angular` to interpret input as \\theta)

### 23.4 Spectral-space dependence

* `spectral_object_type`: Not Known
* `spectral_dependence_type`: Not Known
* `spectral_atoms_possible`: Not Known

### 23.5 Construction

* `construction_class`: compactly supported covariance on sphere
* `base_kernels`: NA
* `construction_formula`: $\displaystyle C(r_{SP}) = \sigma^2\left(1+\tau \frac{r_{SP}}{c}+\frac{\tau^2-1}{3} \frac{r_{SP}^2}{c^2}\right)\left(1-\frac{r_{SP}}{c}\right)_{+}^{\tau}$
* `construction_notes`: compact support for $r_{SP} \le c$

### 23.6 Parameters

* `parameter_list`: $\sigma^2$, $c$, $\tau$, `distance_mode` (optional), `radius` (optional)
* `parameter_meanings`: variance, support/range, smoothness parameter; `distance_mode`: `arc_length` (default) or `angular`; `radius`: sphere radius used to map arc length to angle
* `parameter_constraints`: $\sigma^2 > 0$, $c \in (0,\pi]$, $\tau \ge 6$; `distance_mode` in {`arc_length`, `angular`}; `radius` > 0 if provided (required for arc_length if domain radius is missing)
* `PSD_guarantee_mechanism`: known positive definite class on sphere for stated range

### 23.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA

### 23.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01


* `covariance_representation`: yes
* `covariance_formula`: $C(r_{SP})$ as above
* `spectral_representation`: no
* `spectral_formula`: NA
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 23.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 23.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 23.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 23.12 Radial and harmonic reduction

* `radial_spectral_reduction`: NA
* `spherical_spectral_reduction`: applicable; notes: harmonic coefficients Not Known

### 23.13 Reparameterization

* `reparameterizations`: NA

### 23.14 Properties

* `symmetry`: symmetric
* `stationarity`: isometry-invariant on sphere
* `isotropy`: isotropic (distance-only)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: NA (compact domain)
* `compact_support`: yes (range $c$)
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* `fixed_domain_asymptotics`: NA
* `increasing_domain_asymptotics`: NA
* `mixed_domain_asymptotics`: NA
* `identifiable_parameter_combinations`: Not Known

### 23.15 Computational implications

* `dense_or_sparse_structure`: sparse via compact support in distance-based covariance
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no

### 23.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: NA
* `numerical_approximations`: NA
* `approximation_representation_id`: RF-COV-01


## 24. `Confluent-SHg`: confluent hypergeometric covariance (RF)

### 24.1 Name

* `kernel_name`: Confluent hypergeometric covariance (CH class)
* `call_notation`: `Confluent-SHg`
* `aliases`: Confluent Hypergeometric (CH) covariance; Ma–Bhadra CH
* `parent_kernel`: `Cov-SM`
* `parent_kernel_constraints`: Gaussian scale mixture / Matérn scale mixture construction

### 24.2 Geometry and admissibility

* `manifold_type`: Euclidean
* `admissible_manifolds`: Euclidean (`E1` alias)
* `intrinsic_dimension_constraints`: $d\ge 1$
* `admissible_metrics`: Euclidean $L^2$; anisotropic distance supplied by geometry is allowed (kernel remains radial in the provided distance)
* `forbidden_metrics`: non-Euclidean manifolds; arbitrary user metrics without PSD guarantee
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: yes
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 24.3 Physical-space dependence

* `requires_h_k`: no
* `physical_dependence_type`: radial
* `directional_requirements_notes`: isotropic (depends only on $r_S=\|h_S\|$; anisotropy only via geometry-supplied distance)

### 24.4 Spectral-space dependence

* `spectral_object_type`: density
* `spectral_dependence_type`: radial
* `spectral_atoms_possible`: no

### 24.5 Construction

* `construction_class`: Gaussian scale mixture of Matérn (interpretable polynomial-tail extension)
* `base_kernels`: `Cov-SM`
* `construction_formula`:

  A convenient closed form for the CH covariance uses the confluent hypergeometric function of the second kind $U(\cdot)$:
  $$
  C(h_S;\nu,\alpha,\beta,\sigma^2)
  =
  \sigma^2\,\frac{\Gamma(\nu+\alpha)}{\Gamma(\nu)}\,
  U\!\left(\alpha,\;1-\nu,\;\nu\left(\frac{\|h_S\|}{\beta}\right)^2\right),
  $$
  with parameters $\sigma^2>0$, $\alpha>0$, $\beta>0$, $\nu>0$. fileciteturn4file0L1-L19

  An equivalent integral representation (useful for analysis and numerical quadrature) is:
  $$
  C(h_S;\nu,\alpha,\beta,\sigma^2)
  =
  \sigma^2\,\frac{\Gamma(\nu+\alpha)}{\Gamma(\nu)\Gamma(\alpha)}
  \int_0^\infty
  t^{\alpha-1}(t+1)^{-(\nu+\alpha)}
  \exp\!\left(-\nu\|h_S\|^2\,t/\beta^2\right)\,dt.
  $$ fileciteturn4file0L20-L39

* `construction_notes`:
  * The class is termed the **Confluent Hypergeometric (CH)** covariance class. fileciteturn4file0L16-L19
  * It is constructed as a Matérn scale mixture to decouple **local smoothness** (controlled by $\nu$) from **tail decay** (controlled by $\alpha$). fileciteturn4file4L19-L24

### 24.6 Parameters

* `parameter_list`: $\sigma^2$, $\nu$, $\alpha$, $\beta$
* `parameter_meanings`:
  * $\sigma^2$: marginal variance scale ($C(0)=\sigma^2$ under the stated normalization)
  * $\nu$: local smoothness / origin differentiability controller (Matérn-like)
  * $\alpha$: tail heaviness parameter (polynomial tail index)
  * $\beta$: range/scale parameter
* `parameter_constraints`: $\sigma^2>0$, $\nu>0$, $\alpha>0$, $\beta>0$
* `PSD_guarantee_mechanism`: by_construction (Gaussian/Matérn scale mixture; nonnegative mixture weights)

### 24.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: none (Not Known in closed-form spectral coordinates; covariance is finite at the origin with $C(0)=\sigma^2$)
* `spectral_divergence_at_infinity`: Not Known (spectral density exists; covariance tail is polynomial)
* `GRF_correction_methodology`: NA

### 24.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01

* `covariance_representation`: yes
* `covariance_formula`: given in Section 24.5
* `spectral_representation`: yes
* `spectral_formula`: Not Known (paper derives spectral representation; not reproduced here)
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA

### 24.9 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `locality_type`: NA
* `precision_sparse`: no
* `sparsity_driver`: NA
* `precision_notes`: NA

### 24.10 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: Not Known
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA

### 24.11 Normalization

* `primary_scale_parameter`: sigma2
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: $C(0)=\sigma^2$ under the stated closed form.

### 24.12 Radial and harmonic reduction

* `radial_spectral_reduction`: applicable: yes; notes: isotropic in Euclidean distance.
* `spherical_spectral_reduction`: applicable: NA; notes: NA

### 24.13 Reparameterization

* `reparameterizations`:
  * Matérn limiting regime: for fixed $\gamma>0$, set $\beta^2=2(\alpha+1)\gamma^2$ and take $\alpha\to\infty$ to recover the Matérn covariance as a limit (parameter mapping described in the source). fileciteturn4file1L10-L25

### 24.14 Properties

* `symmetry`: symmetric
* `stationarity`: stationary
* `isotropy`: isotropic (radial)
* `separability`: NA
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes
* `differentiability_order`: controlled by $\nu$ in the same way as Matérn (origin behavior). fileciteturn4file0L49-L52
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: long-range / heavier tails than Matérn (polynomial tail in $h$). fileciteturn4file0L52-L74
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_id`:
  * `FD_INFILL`:
    * `classification`: Not Known
    * `notes`: infill asymptotics and equivalent measures are studied in the source; microergodic combinations may apply (Not Known in this spec extract). fileciteturn4file4L23-L26
    * `identifiable_parameter_combinations`: Not Known
  * `ED_BALANCED`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_RAPID`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known
  * `ED_DENSE`:
    * `classification`: Not Known
    * `notes`: Not Known
    * `identifiable_parameter_combinations`: Not Known

* Legacy (kept for compatibility; prefer `identifiability_by_case_id`):
  * `fixed_domain_asymptotics`: Not Known
  * `increasing_domain_asymptotics`: Not Known
  * `mixed_domain_asymptotics`: Not Known
  * `identifiable_parameter_combinations`: Not Known

### 24.15 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `fft_suitability`: yes (on grids; via spectral or circulant methods)
* `nufft_suitability`: yes
* `spde_solver_suitability`: no

### 24.16 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: origin and tail asymptotics available; tail behaves as $|h|^{-2\\alpha}$ up to slowly varying factors (see source). fileciteturn4file0L52-L67
* `special_function_representations`: confluent hypergeometric $U$ (second kind). fileciteturn4file0L1-L15
* `numerical_approximations`: evaluate via special-function libraries for $U$ or via quadrature of the integral representation. 
* `approximation_representation_id`: RF-COV-01


---






