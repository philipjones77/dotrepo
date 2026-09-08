# Two-input Kernels

---

*Status*: WORKING
*Version*: v2.2
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

* inference and prediction specifications citing two-input kernels

Notes:

* This file defines concrete two-input kernel families (formulas) and the required template for new two-input kernels. Numerical algorithms belong to `CT_track_implementation.md`.
* Populate every field; use `NA` if not applicable and `Not Known` if applicable but unknown.

---

## 0. Preamble

### 0.0 Summary of Contents

1. `Complete-SSMM`: complete Euclidean-Euclidean Matérns kernel (WORKING)
2. `CompLimI-SSMM`: complete limited interaction Euclidean-Euclidean kernel (WORKING)
3. `CompExcI-SSMM`: complete excitable interaction Euclidean-Euclidean kernel (WORKING)
4. `Diffusion-SSMM`: diffusion-type Euclidean-Euclidean kernel (WORKING)
5. `Stein1-SSMM`: Stein Euclidean-Euclidean kernel (WORKING)
6. `IpLi-SSMM`: Ip and Li Euclidean-Euclidean kernel (WORKING)
7. `S2Flip-SSMM`: E2-flipped Euclidean-Euclidean kernel (WORKING)
8. `S1Flip-SSMM`: E1-flipped Euclidean-Euclidean (WORKING)
9. `W2`: two-input white noise (GRF) (WORKING)
10. `fB2`: two-input fractional Brownian increments (GRF) (WORKING)
11. `SepProd-SSMM`: separable product Euclidean-Euclidean Matérns kernel (WORKING)
12. `Gneit1-SSCC`: Gneiting nonseparable Euclidean-Euclidean Caucys kernel (WORKING)
13. `Gneit2-SpSMM`: Stieltjes Gneiting sphere-Euclidean Materns kernel (WORKING)
14. `Gneit3-SpSCM`: sphere-Euclidean cauchy-matern kernel (WORKING)
15. `GammaMix1-SpSMM`: gamma-mixture sphere-Euclidean Matérns kernel (WORKING)
16. `GammaMix2-SpSCC`: gamma-mixture sphere-Euclidean Cauchys kernel (WORKING)
17. `Stein2-SpSMM`: Stein sphere-Euclidean Matérns kernel (WORKING)
18. `NFSST-SSMC`: non-fully symmetric Euclidean-Euclidean Matérn–Cauchy (WORKING)
19. `SumProd-SSMM`: Sum-and-product Matérns kernel (WORKING)
20. `Stein3-HUSMM`: Stein human-manifold-Euclidean Matérns kernel (WORKING)
21. `SepProd-SSGG`: separable product Euclidean-Euclidean Gaussians (RBF) kernel (WORKING)
22. `Hristopulos2024-LDHO`: Hristopulos 2024 linear damped harmonic-oscillator hybrid spectral space-time kernel (WORKING)

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

Defines concrete two-input kernel families and the template to be used when adding new entries. Two-input kernels act on exactly two ordered manifold blocks. Geometry, metrics, and anisotropy come from `CT_manifold_geometry_specs.md`; kernel grammar from `CT_kernel_specs.md`.


### 0.3 How to read this file

Call registry (0.8) and template (0.9) live in this preamble and are numbered `0.x` to keep kernel entries starting at `## 1`. Kernel sections follow the numbering in 0.8. Geometry supplies distances/lags; kernels do not access coordinates. In each kernel entry, use the canonical ordered block symbols from `CT_kernel_specs.md` for block 1 and block 2 (e.g., `E1`, `E2`, `SP1`, `TR2`) and use those aliases in all formulas (e.g., $r_{E1}$, $r_{E2}$, $\xi_{E1}$, $\xi_{E2}$).


### 0.4 Summary of Assumptions and Preconditions

* Exactly two manifold blocks per kernel entry, ordered as $(M_1, M_2)$.
* Metrics and anisotropy come from geometry; kernels consume geometry outputs only.
* Identifiability uses asymptotic case IDs (and pairs) from `CT_asymptotic_specs.md`.
* When a block is compact (sphere/torus), expanding-domain regimes for that block are `NA`.


### 0.5 Notation, Inputs and Aliases

* Block aliases: use canonical ordered symbols `E1`, `SP1`, `TR1`, `HU1`, `TM1`, `DC1` for block 1 and `E2`, `SP2`, `TR2`, `HU2`, `TM2`, `DC2` for block 2.
* Distances: $r_{alias}$; signed lags: $h_{alias}$ (Euclidean only).
* Spectral variables: $\xi_{alias}$; joint spectra may couple $\xi_{alias,1}$ and $\xi_{alias,2}$.
* External full-name convention: use `KERNEL2-<call_notation>` when exposing two-input kernels in external interfaces; per-entry fields in this file may keep only `call_notation`.


### 0.6 Validation and Authority Rules

* This file is authoritative for two-input kernel instances; downstream summaries must match.
* Template fields must be populated with a value or explicit `NA` / `Not Known`.
* The shared kernel-core bundle is defined authoritatively in `CT_kernel_specs.md` §3.2.12; this file supplies the ordered two-input extension fields and two-block layout.
* `supported_target_spaces` must use the random-field `target_space` vocabulary from `CT_deterministic_random_structures_objects.md`, not mean-function target choices.
* Status WORKING: additive clarifications allowed; structural changes require coordinated version bumps.


### 0.7 Geometry inputs and block ordering

* Kernels consume geometry outputs only: $r_1$, $r_2$ (isotropic/anisotropic), $h_1$, $h_2$ (Euclidean only), block/axis metadata.
* Block order is always $(M_1, M_2)$ and must match geometry order.


### 0.8 Call Registry

1. `Complete-SSMM` (Section 1)
2. `CompLimI-SSMM` (Section 2)
3. `CompExcI-SSMM` (Section 3)
4. `Diffusion-SSMM` (Section 4)
5. `Stein1-SSMM` (Section 5)
6. `IpLi-SSMM` (Section 6)
7. `S2Flip-SSMM` (Section 7)
8. `S1Flip-SSMM` (Section 8)
9. `W2` (Section 9)
10. `fB2` (Section 10)
11. `SepProd-SSMM` (Section 11)
12. `Gneit1-SSCC` (Section 12)
13. `Gneit2-SpSMM` (Section 13)
14. `Gneit3-SpSCM` (Section 14)
15. `GammaMix1-SpSMM` (Section 15)
16. `GammaMix2-SpSCC` (Section 16)
17. `Stein2-SpSMM` (Section 17)
18. `NFSST-SSMC` (Section 18)
19. `SumProd-SSMM` (Section 19)
20. `Stein3-HUSMM` (Section 20)
21. `SepProd-SSGG` (Section 21)
22. `Hristopulos2024-LDHO` (Section 22)

### 0.9 Template (copy/paste for new two-input kernels)

Populate every field. If a component is not appropriate, write `NA`. If it is appropriate but unknown, write `Not Known`.
* `template_notes`:

Interpret Sections `0.9.1`-`0.9.17` as the two-input formatting of the shared
kernel-core bundle plus the two-input extension defined in
`CT_kernel_specs.md` §3.2.12.
  
#### 0.9.1 Name

* `kernel_name`:
* `call_notation`:
* `aliases`:
* `domain_product_symbol`:
* `parent_kernel`: 
* `parent_kernel_constraints`:
* `references`:
* `name_notes`:

#### 0.9.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: list of ordered pairs `(manifold_type_1, manifold_type_2)`
* `block_order`: always `(M_1, M_2)`
* `block_alias_1`:
* `block_alias_2`:
* `intrinsic_dimension_constraints`:
* `admissible_metrics_block_1`:
* `admissible_metrics_block_2`:
* `forbidden_metric_pairs`:

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
* `supported_domain_blocks_and_admissibility_notes`: 

#### 0.9.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes / no
  * `physical_dependence_type_1`: lag-based / radial / distance-only
  * `radial_quantity_used_1`: r_iso / r_aniso / NA
  * `directional_requirements_notes_1`:
* block 2:
  * `requires_h_2`: yes / no
  * `physical_dependence_type_2`: lag-based / radial / distance-only
  * `radial_quantity_used_2`: r_iso / r_aniso / NA
  * `directional_requirements_notes_2`:
* `physical_space_dependence_notes`:

#### 0.9.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density / measure / NA
  * `spectral_dependence_type_1`: vector / radial / NA
  * `spectral_atoms_possible_1`: yes / no / NA
* block 2:
  * `spectral_object_type_2`: density / measure / NA
  * `spectral_dependence_type_2`: vector / radial / NA
  * `spectral_atoms_possible_2`: yes / no / NA
* `joint_spectral_coupling`: separable / coupled / NA; notes:
* `spectral_space_dependence_notes`: 

#### 0.9.5 Construction

* `construction_class`: separable_product / additive_mixture / product_sum / joint_distance / scale_mixture / rational_spectral / gneiting_type / operator_coupling / other
* `base_kernels`: referenced one-input kernels (by `kernel_name`) if applicable
* `construction_formula`:
* `construction_notes`:

#### 0.9.6 Parameters

* `parameter_list`:
* `parameter_meanings`:
* `parameter_constraints`:
* `PSD_guarantee_mechanism`: by_construction / by_validation / mixed
* `parameters_notes`: 

#### 0.9.7 RF / GRF

* `RF_or_GRF`:
* `spectral_divergence_at_zero`:
* `spectral_divergence_at_infinity`:
* `GRF_correction_methodology`:
* `rf_grf_notes`: 

#### 0.9.8 Representations

* `primary_representation_id`:
  * exactly one default representation ID
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

#### 0.9.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: definition rule + formula
* `marginal_kernel_block_2`: definition rule + formula
* `marginal_consistency_conditions`:
* `separable_limit`:
* `marginal_reduction_limits`:
* `marginals_consistency_and_limits_notes`: Not Known

#### 0.9.10 Normalization

* `primary_scale_parameter`: gamma / sigma2
* `normalization_regime`: RF / GRF
* `spectral_normalization`: variance_normalized / increment_normalized / NA
* `derived_scale_relation`:
* `mixed_representation_normalization`:
* `normalization_notes`:

#### 0.9.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: yes / no / partial; notes:
* `two_input_radial_integration`: applicable: yes / no / partial; blockwise yes/no; requires_separability yes/no; notes:
* `two_input_radial_integration_and_reductions_notes`: Not Known

#### 0.9.12 Precision / Markov structure

* `has_precision_representation`: yes / no / approximate
* `precision_form`: explicit_matrix / operator_derived / NA
* `markov_property`: yes / no / approximate
* `precision_sparse`: yes / no / depends_on_discretization
* `precision_notes`:

#### 0.9.13 State-space (Kalman) representability

* `exact_kalman`: yes / no
* `approximate_kalman`: yes / no
* `approximation_method`: rational_spectral / SPDE_discretization / state_augmentation / time_discretization / NA
* `ordering_dimension_required`: yes / no
* `error_control`:
* `state_space_representability_notes`: Not Known

#### 0.9.14 Reparameterizations

* `reparameterizations`: names, mapping formulas, parameter meaning
* `reparameterizations_notes`: 

#### 0.9.15 Properties

* `symmetry`:
* `stationarity_invariance`:
* `isotropy_block_1`:
* `isotropy_block_2`:
* `separability`:
* `PSD_guarantee_mechanism`:
* `pointwise_variance`:
* `mean_square_continuity`:
* `differentiability_order`:
* `holder_fractal_class`:
* `short_or_long_range_dependence`:
* `compact_support`:
* `ridge_effect`:
* `stein_regularity`:

* Identifiability (case IDs from `CT_asymptotic_specs.md`):
  * `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: FD_INFILL / ED_BALANCED / ED_RAPID / ED_DENSE / Not Known / NA
  * `block_2_case_id`: FD_INFILL / ED_BALANCED / ED_RAPID / ED_DENSE / Not Known / NA
  * `marginal_block_1`: identifiable / weakly_identifiable / non_identifiable / Not Known / NA
  * `marginal_block_2`: identifiable / weakly_identifiable / non_identifiable / Not Known / NA
  * `coupling_parameters`: identifiable / weakly_identifiable / non_identifiable / Not Known / NA
  * `identifiable_parameter_combinations`:
  * `notes`:
  * `relative_rates`:
  * `relative_domain_growth`: record $L_1/L_2$ regime (e.g., $\to 0$, $\to c\in(0,\infty)$, $\to \infty$); state any identifiable parameter combinations that rely on this ratio.
  * `relative_infill_rate`: record $a_1/a_2$ regime (e.g., $\to 0$, $\to c\in(0,\infty)$, $\to \infty$); state any identifiable parameter combinations that rely on this ratio.
  * `notes`: summarize how relative rates affect cross-block coupling identifiability (use `Not Known` or `NA` if unknown or not applicable).

  * Legacy (kept for compatibility; prefer `identifiability_by_case_pair`):
  * `fixed_domain_asymptotics`:
  * `increasing_domain_asymptotics`:
  * `mixed_domain_asymptotics`:
  * `identifiable_parameter_combinations`:
* `properties_notes`: Not Known

#### 0.9.16 Computational implications

* `dense_or_sparse_structure`:
* `kronecker_structure_available`:
* `fft_suitability`:
* `nufft_suitability`:
* `spde_solver_suitability`:
* `computational_implications_notes`: Not Known

#### 0.9.17 Approximations

* `power_series`:
* `asymptotic_expansions`:
* `special_function_representations`:
* `numerical_approximations`:
* `approximation_representation_id`: required when any approximation entry is not `NA`; must be one of `supported_representation_ids`
* `approximations_notes`:

### 0.10 Notes
* `notes_notes`: 

## 1. `Complete-SSMM`: complete Euclidean-Euclidean Matérns kernel

### 1.1 Name

* `kernel_name`: complete Euclidean-Euclidean Matérns kernel
* `call_notation`: `Complete-SSMM`
* `aliases`: `Complete-SSMM`
* `domain_product_symbol`: `E1×E2`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 1.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no
  * `hilbert_space`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
  * `self_adjoint_psd`: no
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 1.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 1.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: additive blockwise terms plus a coupled term depending on both block norms
* `spectral_space_dependence_notes`: Not Known

### 1.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: Matérn(E1), Matérn(E2)
* `construction_formula`:

  Spectral density:

  $$
  f(\xi_{E1}, \xi_{E2}) =
  \gamma
  \{
  \epsilon_{E1}(\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})^{\alpha_{E1}}
  +
  \epsilon_{E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E2}}
  +
  \epsilon_{E1E2}(\kappa_{E1E2}^{2}+\|\xi_{E1}\|^{2}\,\|\xi_{E2}\|^{2})^{\alpha_{E1E2}}
  \}^{-\nu},
  \qquad
  (\xi_{E1},\xi_{E2})\in\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}} .
  $$
* `construction_notes`: reduces to separable product when $\epsilon_{E1E2}=0$; coupling term links block frequencies multiplicatively. (Informal description: “additive mixture + product-sum” inside a rational spectrum.)

### 1.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\kappa_{E1E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\alpha_{E1E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$: nonnegative weights on blockwise and coupled components
  * $\kappa_{(\cdot)}$: inverse range parameters
  * $\alpha_{(\cdot)}$: smoothness exponents
  * $\nu$: outer tail/heaviness exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2} \ge 0$ (not all zero); $\kappa_{(\cdot)}>0$; $\alpha_{(\cdot)}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction (positive spectral density)
* `parameters_notes`: Not Known

### 1.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: finite if $\nu \alpha_{E1}, \nu \alpha_{E2}, \nu \alpha_{E1E2}$ large enough; else may diverge
* `spectral_divergence_at_infinity`: controlled by $\nu$ and $\alpha_{(\cdot)}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 1.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `primary_representation_call_symbol`: `f`
* `supported_representation_ids`: RF-SPEC-01, RF-COV-01, RF-MIXED-01

* `primary_representation_summary`:
  * `representation_status`: exact
  * `representation_formula_or_operator`: the joint spectral density in Section 1.5
  * `normalization_notes`: $\gamma$ is the primary spectral scale and is chosen to match the desired RF variance normalization when finite
  * `approximation_routes`: direct spectral quadrature, radial/Hankel reduction when available blockwise, FFT/NUFFT inversion on finite grids
  * `special_function_routes`: Not Known
  * `representation_notes`: default two-input representation is the coupled joint spectral density on `E1×E2`

* `secondary_representation_details`:
  * `representation_id`: RF-COV-01
    `representation_call_symbol`: `C`
    `representation_status`: induced
    `representation_formula_or_operator`: inverse Fourier transform of the Section 1.5 spectral density; closed form Not Known
    `normalization_notes`: inherits normalization from the primary spectral representation
    `approximation_routes`: finite-grid inverse Fourier transform, direct quadrature, NUFFT
    `special_function_routes`: Not Known
    `representation_notes`: covariance representation exists but is usually treated operationally through inversion rather than closed form
  * `representation_id`: RF-MIXED-01
    `representation_call_symbol`: `f_{mix}`
    `representation_status`: approximate
    `representation_formula_or_operator`: one-block spectral / one-block covariance inversion route derived from the primary spectral density
    `normalization_notes`: mixed normalization must stay consistent with the primary spectral scale $\gamma$
    `approximation_routes`: partial Fourier inversion in one block with direct evaluation in the other
    `special_function_routes`: Not Known
    `representation_notes`: useful for partially spectral algorithms; treated as an optional operational representation rather than the default theoretical call form

### 1.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: recovers Matérn with parameters $(\gamma \epsilon_{E1}, \kappa_{E1}, \alpha_{E1}, \nu)$ when $\epsilon_{E1E2}=0$
* `marginal_kernel_block_2`: recovers Matérn with parameters $(\gamma \epsilon_{E2}, \kappa_{E2}, \alpha_{E2}, \nu)$ when $\epsilon_{E1E2}=0$
* `marginal_consistency_conditions`: $\epsilon_{E1E2}=0$ yields separable marginals
* `separable_limit`: set $\epsilon_{E1E2}=0$
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 1.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 1.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 1.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known (operator form, if any, requires separate derivation; may be NA if no SPDE exists for this family)

### 1.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 1.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 1.15 Properties

* `symmetry`: symmetric (covariance); not necessarily invariant under swapping blocks $(E1rightarrow E2)$
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: nonseparable when $\epsilon_{E1E2}>0$
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: finite if integrability conditions hold
* `mean_square_continuity`: depends on $\alpha_{(\cdot)}$ and $\nu$
* `differentiability_order`: depends on $\alpha_{(\cdot)}$ and $\nu$; Not Known exactly
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: tunable via $\alpha_{(\cdot)}$ and $\nu$
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: Not Known
  * `block_2_case_id`: Not Known
  * `marginal_block_1`: Not Known
  * `marginal_block_2`: Not Known
  * `coupling_parameters`: Not Known
  * `identifiable_parameter_combinations`: Not Known
  * `notes`: requires study per regime
  * `relative_rates`:
  * `relative_domain_growth`: Not Known
  * `relative_infill_rate`: Not Known

* `fixed_domain_asymptotics`: Not Known
* `increasing_domain_asymptotics`: Not Known
* `mixed_domain_asymptotics`: Not Known
* `identifiable_parameter_combinations`: Not Known
* `properties_notes`: Not Known

### 1.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no if $\epsilon_{E1E2}>0$; yes if $\epsilon_{E1E2}=0$
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 1.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: rational spectral approximations for Kalman-like filters (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 1.18 Notes
* `notes_notes`: Not Known

## 2. `CompLimI-SSMM`: complete limited interaction Euclidean-Euclidean kernel

### 2.1 Name

* `kernel_name`: complete limited interaction Euclidean-Euclidean kernel
* `call_notation`: `CompLimI-SSMM`
* `aliases`: `CompLimI-SSMM`
* `parent_kernel`: `Complete-SSMM`
* `parent_kernel_constraints`: $2 \alpha_{E1E2} < \min\{\alpha_{E1},\alpha_{E2}\}$
* `references`: Not Known
* `name_notes`: Not Known

### 2.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 2.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 2.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: additive blockwise terms plus a coupled term depending on both block norms
* `spectral_space_dependence_notes`: Not Known

### 2.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  Spectral density:

  $$
  f(\xi_{E1}, \xi_{E2}) =
  \gamma
  \{
  \epsilon_{E1}(\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})^{\alpha_{E1}}
  +
  \epsilon_{E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E2}}
  +
  \epsilon_{E1E2}(\kappa_{E1E2}^{2}+\|\xi_{E1}\|^{2}\,\|\xi_{E2}\|^{2})^{\alpha_{E1E2}}
  \}^{-\nu},
  \qquad
  (\xi_{E1},\xi_{E2})\in\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}} .
  $$
* `construction_notes`: nonseparable unless coupling weight vanishes; separable limit Not Known (other than the obvious $\epsilon_{E1E2}=0$)

### 2.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\kappa_{E1E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\alpha_{E1E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$: strictly positive weights on blockwise and coupled components
  * $\kappa_{(\cdot)}$: inverse range parameters
  * $\alpha_{(\cdot)}$: smoothness exponents
  * $\nu$: outer tail/heaviness exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2} > 0$; $\kappa_{(\cdot)}>0$; $\alpha_{(\cdot)}>0$; $\nu>0$; $2 \alpha_{E1E2} < \min\{\alpha_{E1},\alpha_{E2}\}$
* `PSD_guarantee_mechanism`: by_construction (positive spectral density)
* `parameters_notes`: Not Known

### 2.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\nu$ and $\alpha_{(\cdot)}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 2.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (inverse Fourier transform; closed form Not Known)
* `covariance_formula`: Not Known
* `spectral_representation`: yes
* `spectral_formula`: given in Section 2.5
* `mixed_half_spectral`: yes (one-block Fourier inversion)
* `mixed_half_spectral_formula`: Not Known
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 2.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not Known
* `marginal_kernel_block_2`: Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known (beyond $\epsilon_{E1E2}\to 0$)
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 2.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 2.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 2.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known (operator form, if any, requires separate derivation)

### 2.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 2.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 2.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: no (unless $\epsilon_{E1E2}=0$)
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: Not Known
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: Not Known
  * `block_2_case_id`: Not Known
  * `marginal_block_1`: Not Known
  * `marginal_block_2`: Not Known
  * `coupling_parameters`: Not Known
  * `identifiable_parameter_combinations`: Not Known
  * `notes`: Not Known
  * `relative_rates`:
  * `relative_domain_growth`: Not Known
  * `relative_infill_rate`: Not Known

* `fixed_domain_asymptotics`: Not Known
* `increasing_domain_asymptotics`: Not Known
* `mixed_domain_asymptotics`: Not Known
* `identifiable_parameter_combinations`: Not Known
* `properties_notes`: Not Known

### 2.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no if $\epsilon_{E1E2}>0$; yes if $\epsilon_{E1E2}=0$ (Not Known)
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 2.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 2.18 Notes
* `notes_notes`: Not Known

## 3. `CompExcI-SSMM`: complete excitable interaction Euclidean-Euclidean kernel

### 3.1 Name

* `kernel_name`: complete excitable interaction Euclidean-Euclidean kernel
* `call_notation`: `CompExcI-SSMM`
* `aliases`:  `CompExcI-SSMM`
* `parent_kernel`: `Complete-SSMM`
* `parent_kernel_constraints`: $2 \alpha_{E1E2} \ge \min\{\alpha_{E1},\alpha_{E2}\}$
* `references`: Not Known
* `name_notes`: Not Known

### 3.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 3.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 3.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: additive blockwise terms plus a coupled term depending on both block norms
* `spectral_space_dependence_notes`: Not Known

### 3.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  Spectral density:

  $$
  f(\xi_{E1}, \xi_{E2}) =
  \gamma
  \{
  \epsilon_{E1}(\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})^{\alpha_{E1}}
  +
  \epsilon_{E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E2}}
  +
  \epsilon_{E1E2}(\kappa_{E1E2}^{2}+\|\xi_{E1}\|^{2}\,\|\xi_{E2}\|^{2})^{\alpha_{E1E2}}
  \}^{-\nu},
  \qquad
  (\xi_{E1},\xi_{E2})\in\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}} .
  $$
* `construction_notes`: nonseparable unless coupling weight vanishes; separable limit Not Known (other than the obvious $\epsilon_{E1E2}=0$)

### 3.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\kappa_{E1E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\alpha_{E1E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$: strictly positive weights on blockwise and coupled components
  * $\kappa_{(\cdot)}$: inverse range parameters
  * $\alpha_{(\cdot)}$: smoothness exponents
  * $\nu$: outer tail/heaviness exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2} > 0$; $\kappa_{(\cdot)}>0$; $\alpha_{(\cdot)}>0$; $\nu>0$; $2 \alpha_{E1E2} \ge \min\{\alpha_{E1},\alpha_{E2}\}$
* `PSD_guarantee_mechanism`: by_construction (positive spectral density)
* `parameters_notes`: Not Known

### 3.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\nu$ and $\alpha_{(\cdot)}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 3.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (inverse Fourier transform; closed form Not Known)
* `covariance_formula`: Not Known
* `spectral_representation`: yes
* `spectral_formula`: given in Section 3.5
* `mixed_half_spectral`: yes (one-block Fourier inversion)
* `mixed_half_spectral_formula`: Not Known
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 3.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not Known
* `marginal_kernel_block_2`: Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known (beyond $\epsilon_{E1E2}\to 0$)
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 3.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 3.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 3.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known (operator form, if any, requires separate derivation)

### 3.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 3.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 3.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: no (unless $\epsilon_{E1E2}=0$)
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: Not Known
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: Not Known
  * `block_2_case_id`: Not Known
  * `marginal_block_1`: Not Known
  * `marginal_block_2`: Not Known
  * `coupling_parameters`: Not Known
  * `identifiable_parameter_combinations`: Not Known
  * `notes`: Not Known
  * `relative_rates`:
  * `relative_domain_growth`: Not Known
  * `relative_infill_rate`: Not Known

* `fixed_domain_asymptotics`: Not Known
* `increasing_domain_asymptotics`: Not Known
* `mixed_domain_asymptotics`: Not Known
* `identifiable_parameter_combinations`: Not Known
* `properties_notes`: Not Known

### 3.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no if $\epsilon_{E1E2}>0$; yes if $\epsilon_{E1E2}=0$ (Not Known)
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 3.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 3.18 Notes
* `notes_notes`: Not Known

## 4. `Diffusion-SSMM`: diffusion-type Euclidean-Euclidean kernel

### 4.1 Name

* `kernel_name`: diffusion-type Euclidean-Euclidean kernel
* `call_notation`: `Diffusion-SSMM`
* `aliases`: `Diffusion-SSMM`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 4.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 4.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 4.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: $\|\xi_{E2}\|$ enters additively inside the spectral denominator
* `spectral_space_dependence_notes`: Not Known

### 4.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  Spectral density:

  $$
  f(\xi_{E1}, \xi_{E2})=
  \frac{\gamma}{[\epsilon_{E2}^2\|\xi_{E2}\|^2+(\kappa_{E1}^2+\|\xi_{E1}\|^2)^{\alpha_{E1}}]^{\alpha_{E2}}(\kappa_{E1}^2+\|\xi_{E1}\|^2)^{\alpha_{e}}},
  \quad
  (\xi_{E1}, \xi_{E2}) \in \mathbb{R}^{d_{E1}} \times \mathbb{R}^{d_{E2}}.
  $$
* `construction_notes`: generalizes diffusion/heat-kernel/fractional Matérn-type spectra

### 4.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E2}$, $\kappa_{E1}$, $\alpha_{E1}$, $\alpha_{E2}$, $\alpha_{e}$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{E2}$: block-2 Euclidean scale
  * $\kappa_{E1}$: block-1 inverse range
  * $\alpha_{E1}$: block-1 exponent
  * $\alpha_{E2}$: block-2 exponent
  * $\alpha_{e}$: extra block-1 exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E2}>0$; $\kappa_{E1}>0$; $\alpha_{E1}>0$; $\alpha_{E2}>0$; $\alpha_{e} \ge 0$
* `PSD_guarantee_mechanism`: by_construction (positive spectral density)
* `parameters_notes`: Not Known

### 4.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\alpha_{E1}$, $\alpha_{E2}$, and $\alpha_{e}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 4.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (inverse Fourier transform; closed form Not Known)
* `covariance_formula`: Not Known
* `spectral_representation`: yes
* `spectral_formula`: given in Section 4.5
* `mixed_half_spectral`: yes (one-block Fourier inversion)
* `mixed_half_spectral_formula`: Not Known
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 4.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not Known
* `marginal_kernel_block_2`: Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 4.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 4.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 4.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known (operator form, if any, requires separate derivation)

### 4.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 4.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 4.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: Not Known
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: Not Known
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: Not Known
  * `block_2_case_id`: Not Known
  * `marginal_block_1`: Not Known
  * `marginal_block_2`: Not Known
  * `coupling_parameters`: Not Known
  * `identifiable_parameter_combinations`: Not Known
  * `notes`: Not Known
  * `relative_rates`:
  * `relative_domain_growth`: Not Known
  * `relative_infill_rate`: Not Known

* `fixed_domain_asymptotics`: Not Known
* `increasing_domain_asymptotics`: Not Known
* `mixed_domain_asymptotics`: Not Known
* `identifiable_parameter_combinations`: Not Known
* `properties_notes`: Not Known

### 4.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: Not Known
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 4.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 4.18 Notes
* `notes_notes`: Not Known

## 5. `Stein1-SSMM`: Stein Euclidean-Euclidean kernel

### 5.1 Name

* `kernel_name`: Stein Euclidean-Euclidean kernel
* `call_notation`: `Stein1-SSMM`
* `aliases`: `Stein1-SSMM`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Stein2005
* `name_notes`: Not Known

### 5.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`

* `block_order`: `(M_1, M_2)`

* `block_alias_1`: `E1`

* `block_alias_2`: `E2`

* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$, $d_{E2}\ge 1$

* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean

* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean

* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:

  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:

  * `symmetric`: yes
  * `Hermitian`: yes

### 5.3 Physical-space dependence (per block)

* block 1:

  * `requires_h_1`: yes (Euclidean lags)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso / r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:

  * `requires_h_2`: yes (Euclidean lags)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso / r_aniso
  * `directional_requirements_notes_2`: enters only through norm

### 5.4 Spectral-space dependence (per block)

* block 1:

  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:

  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: coupling induced by the shared outer exponent acting on an additive blockwise sum

### 5.5 Construction

* `construction_class`: rational_spectral

* `base_kernels`: Matérn-type spectral shapes on `E1` and `E2`

* `construction_formula`:

  Spectral density:

  $$
  f(\xi_{E1},\xi_{E2})
  ====================

  \gamma
  \Big[
  \epsilon_{E1},(\kappa_{E1}^{2}+|\xi_{E1}|^{2})^{\alpha_{E1}}
  +
  \epsilon_{E2},(\kappa_{E2}^{2}+|\xi_{E2}|^{2})^{\alpha_{E2}}
  \Big]^{-\nu},
  \qquad
  (\xi_{E1},\xi_{E2})\in\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}}.
  $$

* `construction_notes`:

  * PSD holds by construction because $f\ge 0$ and defines a stationary covariance by Bochner.
  * This is a two-input Euclidean kernel on $E1\times E2$ with **additive blockwise spectral terms** inside a shared power $-\nu$.

### 5.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\nu$
* `parameter_meanings`:

  * $\gamma$: overall scale
  * $\epsilon_{E1}$, $\epsilon_{E2}$: nonnegative block weights
  * $\kappa_{E1}$, $\kappa_{E2}$: inverse range parameters
  * $\alpha_{E1}$, $\alpha_{E2}$: block spectral exponents (inside the additive term)
  * $\nu$: outer tail/heaviness exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2}\ge 0$ with $\epsilon_{E1}+\epsilon_{E2}>0$; $\kappa_{E1},\kappa_{E2}>0$; $\alpha_{E1},\alpha_{E2}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction

### 5.7 RF / GRF

* `RF_or_GRF`: RF if $\int_{\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}}} f(\xi_{E1},\xi_{E2}),d\xi_{E1}d\xi_{E2} < \infty$; otherwise GRF
* `spectral_divergence_at_zero`: none when $\kappa_{E1},\kappa_{E2}>0$ (finite at origin)
* `spectral_divergence_at_infinity`: polynomial tail governed by $(\alpha_{E1},\alpha_{E2},\nu)$; exact integrability threshold Not Known
* `GRF_correction_methodology`: NA

### 5.8 Representations

* `primary_representation_id`: RF-SPEC-01

* `supported_representation_ids`: RF-SPEC-01, RF-COV-01

* `covariance_representation`: yes (inverse Fourier transform on $\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}}$)

* `covariance_formula`: Not Known (closed form)

* `spectral_representation`: yes

* `spectral_formula`: given in Section 5.5

* `mixed_half_spectral`: yes

* `mixed_half_spectral_formula`: Not Known

* `SPDE_operator_representation`: Not Known

* `SPDE_operator_formula`: NA

### 5.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: define by restriction $h_{E2}=0$ (equivalently integrate out $\xi_{E2}$); closed form Not Known
* `marginal_kernel_block_2`: define by restriction $h_{E1}=0$ (equivalently integrate out $\xi_{E1}$); closed form Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: no (in general); degenerate limits may exist (Not Known)
* `marginal_reduction_limits`: Not Known

### 5.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen to enforce $C(0,0)=1$
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired point variance if finite

### 5.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block but nonseparable in $(\xi_{E1},\xi_{E2})$.
* `two_input_radial_integration`: applicable: partial; blockwise yes/no: block 1 yes, block 2 yes; requires_separability no; notes: joint integral does not factor.

### 5.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known

### 5.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (if one block is treated as ordered)
* `error_control`: Not Known

### 5.14 Reparameterizations

* `reparameterizations`: NA

### 5.15 Properties

* `symmetry`: symmetric

* `stationarity_invariance`: stationary on both Euclidean blocks

* `isotropy_block_1`: isotropic (radial)

* `isotropy_block_2`: isotropic (radial)

* `separability`: no (in general)

* `PSD_guarantee_mechanism`: by_construction

* `pointwise_variance`: finite iff $\int f < \infty$ (Not Known exact condition set)

* `mean_square_continuity`: Not Known

* `differentiability_order`: Not Known

* `holder_fractal_class`: Not Known

* `short_or_long_range_dependence`: Not Known

* `compact_support`: no

* `ridge_effect`: no

* `stein_regularity`: Not Known

* Identifiability (case IDs from `CT_asymptotic_specs.md`):

  * `identifiability_by_case_pair`:

    * `case_pair`:

      * `block_1_case_id`: Not Known
      * `block_2_case_id`: Not Known
      * `marginal_block_1`: Not Known
      * `marginal_block_2`: Not Known
      * `coupling_parameters`: NA
      * `identifiable_parameter_combinations`: Not Known
      * `notes`: Not Known
    * `relative_rates`:

      * `relative_domain_growth`: Not Known
      * `relative_infill_rate`: Not Known
      * `notes`: Not Known

### 5.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes
* `spde_solver_suitability`: Not Known

### 5.17 Approximations

* `power_series`: Not Known
* `asymptotic_expansions`: Not Known
* `special_function_representations`: Not Known
* `numerical_approximations`: Not Known

---


## 6. `IpLi-SSMM`: Ip and Li Euclidean-Euclidean kernel

### 6.1 Name

* `kernel_name`: Ip and Li Euclidean-Euclidean kernel
* `call_notation`: `IpLi-SSMM`
* `aliases`: `IpLi-SSMM`
* `parent_kernel`: `Complete-SSMM`
* `parent_kernel_constraints`: fix $(\alpha_{E1},\alpha_{E2},\alpha_{E1E2})=(1,1,1)$ in `Complete-SSMM`
* `references`: Not Known
* `name_notes`: Not Known

### 6.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 6.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 6.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: coupling via multiplicative term $\|\xi_{E1}\|^2\|\xi_{E2}\|^2$
* `spectral_space_dependence_notes`: Not Known

### 6.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  $$
  f(\xi_{E1}, \xi_{E2}) =
  \gamma
  \{
  \epsilon_{E1}(\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})
  +
  \epsilon_{E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})
  +
  \epsilon_{E1E2}(\kappa_{E1E2}^{2}+\|\xi_{E1}\|^{2}\,\|\xi_{E2}\|^{2})
  \}^{-\nu}.
  $$
* `construction_notes`: special case of `Complete-SSMM` with all inner exponents set to 1

### 6.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\kappa_{E1E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$: nonnegative weights on blockwise and coupled components
  * $\kappa_{(\cdot)}$: inverse range parameters
  * $\nu$: outer exponent controlling tails
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2}\ge 0$ (not all zero); $\kappa_{(\cdot)}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 6.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\nu$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 6.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (inverse Fourier transform; closed form Not Known)
* `covariance_formula`: Not Known
* `spectral_representation`: yes
* `spectral_formula`: given in Section 6.5
* `mixed_half_spectral`: yes (one-block Fourier inversion)
* `mixed_half_spectral_formula`: Not Known
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 6.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not Known
* `marginal_kernel_block_2`: Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: $\epsilon_{E1E2}=0$
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 6.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 6.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 6.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known (operator form, if any, requires separate derivation)

### 6.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 6.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 6.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: no unless $\epsilon_{E1E2}=0$
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: Not Known
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: Not Known
  * `block_2_case_id`: Not Known
  * `marginal_block_1`: Not Known
  * `marginal_block_2`: Not Known
  * `coupling_parameters`: Not Known
  * `identifiable_parameter_combinations`: Not Known
  * `notes`: Not Known
  * `relative_rates`:
  * `relative_domain_growth`: Not Known
  * `relative_infill_rate`: Not Known

* `fixed_domain_asymptotics`: Not Known
* `increasing_domain_asymptotics`: Not Known
* `mixed_domain_asymptotics`: Not Known
* `identifiable_parameter_combinations`: Not Known
* `properties_notes`: Not Known

### 6.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no if $\epsilon_{E1E2}>0$; yes if $\epsilon_{E1E2}=0$ (Not Known)
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 6.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 6.18 Notes
* `notes_notes`: Not Known

## 7. `S2Flip-SSMM`: E2-flipped Euclidean-Euclidean kernel

### 7.1 Name

* `kernel_name`: E2-flipped Euclidean-Euclidean kernel
* `call_notation`: `S2Flip-SSMM`
* `aliases`:  `S2Flip-SSMM`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 7.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 7.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 7.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: coupling via flipped/exchange term inside rational spectrum
* `spectral_space_dependence_notes`: Not Known

### 7.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  $$
  f(\xi_{E1}, \xi_{E2}) =
  \gamma
  g\{
  \epsilon_{E1}(\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})^{\alpha_{E1}}
  +
  [
  \epsilon_{E2}+\epsilon_{E1E2}(\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})^{\alpha_{E1E2}}
  ]
  (\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E2}}
  g\}^{-\nu}.
  $$
* `construction_notes`: nonseparable rational spectrum

### 7.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\alpha_{E1E2}$, $\nu$
* `parameter_meanings`: Not Known
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2} \ge 0$ (not all zero); $\kappa_{E1},\kappa_{E2}>0$; $\alpha_{E1},\alpha_{E2},\alpha_{E1E2}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 7.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\nu$ and $\alpha_{(\cdot)}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 7.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (inverse Fourier transform; closed form Not Known)
* `covariance_formula`: Not Known
* `spectral_representation`: yes
* `spectral_formula`: given in Section 7.5
* `mixed_half_spectral`: yes (one-block Fourier inversion)
* `mixed_half_spectral_formula`: Not Known
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 7.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not Known
* `marginal_kernel_block_2`: Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 7.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: Not Known

### 7.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 7.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known

### 7.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 7.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 7.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: no
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: Not Known
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 7.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: Not Known
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 7.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 7.18 Notes
* `notes_notes`: Not Known

## 8. `S1Flip-SSMM`: E1-flipped Euclidean-Euclidean

### 8.1 Name

* `kernel_name`: E1-flipped Euclidean-Euclidean
* `call_notation`: `S1Flip-SSMM`
* `aliases`: `S1Flip-SSMM`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 8.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 8.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters only through norm
* block 2:
  * `requires_h_2`: yes (Euclidean lags used via radial duality)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters only through norm
* `physical_space_dependence_notes`: Not Known

### 8.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: coupling via flipped/exchange term inside rational spectrum
* `spectral_space_dependence_notes`: Not Known

### 8.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  $$
  f(\xi_{E1}, \xi_{E2}) =
  \gamma
  g\{
  \epsilon_{E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E2}}
  +
  [
  \epsilon_{E1}+\epsilon_{E1E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E1E2}}
  ]
  (\kappa_{E1}^{2}+\|\xi_{E1}\|^{2})^{\alpha_{E1}}
  g\}^{-\nu}.
  $$
* `construction_notes`: nonseparable rational spectrum

### 8.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\alpha_{E1E2}$, $\nu$
* `parameter_meanings`: Not Known
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2} \ge 0$ (not all zero); $\kappa_{E1},\kappa_{E2}>0$; $\alpha_{E1},\alpha_{E2},\alpha_{E1E2}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 8.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\nu$ and $\alpha_{(\cdot)}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 8.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (inverse Fourier transform; closed form Not Known)
* `covariance_formula`: Not Known
* `spectral_representation`: yes
* `spectral_formula`: given in Section 8.5
* `mixed_half_spectral`: yes (one-block Fourier inversion)
* `mixed_half_spectral_formula`: Not Known
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 8.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not Known
* `marginal_kernel_block_2`: Not Known
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 8.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: Not Known

### 8.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: radial in each block
* `two_input_radial_integration`: applicable: partial; blockwise yes/no; requires_separability yes/no; notes: Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 8.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known

### 8.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose block for ordering)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 8.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 8.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: no
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: Not Known
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 8.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: Not Known
* `fft_suitability`: yes (spectral)
* `nufft_suitability`: yes for irregular designs
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 8.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 8.18 Notes
* `notes_notes`: Not Known

## 9. `W2`: two-input white noise (GRF)

### 9.1 Name

* `kernel_name`: two-input white noise (GRF)
* `call_notation`: `W2`
* `aliases`: `W2`, `WN2`, `two-input nugget`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 9.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$, $d_{E2}\ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: yes
  * `complex_scalar`: yes
  * `complex_vector`: yes

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 9.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: delta at $r_{E1}=0$
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: distance-only
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: delta at $r_{E2}=0$
* `physical_space_dependence_notes`: Not Known

### 9.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density (generalized / flat)
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: density (generalized / flat)
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: separable; notes: constant spectrum (distributional)
* `spectral_space_dependence_notes`: Not Known

### 9.5 Construction

* `construction_class`: other
* `base_kernels`: white noise on each block (delta covariance)
* `construction_formula`:

  $$
  C((x_1,x_2),(y_1,y_2)) = \sigma^2 \,\delta(x_1-y_1)\,\delta(x_2-y_2).
  $$
* `construction_notes`: generalized covariance; requires distributional interpretation

### 9.6 Parameters

* `parameter_list`: $\sigma^2$
* `parameter_meanings`: variance/intensity
* `parameter_constraints`: $\sigma^2>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 9.7 RF / GRF

* `RF_or_GRF`: GRF
* `spectral_divergence_at_zero`: NA (flat)
* `spectral_divergence_at_infinity`: NA (flat)
* `GRF_correction_methodology`: distributional
* `rf_grf_notes`: Not Known

### 9.8 Representations

* `primary_representation_id`: GRF-SPEC-01
* `supported_representation_ids`: GRF-SPEC-01, GRF-VAR-01

* `covariance_representation`: yes
* `covariance_formula`: delta product
* `spectral_representation`: yes
* `spectral_formula`: constant spectrum
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: yes (formal)
* `SPDE_operator_formula`: identity operator; Not Known details
* `representations_notes`: Not Known

### 9.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: white noise on block 1
* `marginal_kernel_block_2`: white noise on block 2
* `marginal_consistency_conditions`: NA
* `separable_limit`: already separable
* `marginal_reduction_limits`: NA
* `marginals_consistency_and_limits_notes`: Not Known

### 9.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: GRF
* `spectral_normalization`: NA
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 9.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: NA
* `two_input_radial_integration`: applicable: NA
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 9.12 Precision / Markov structure

* `has_precision_representation`: yes
* `precision_form`: explicit_matrix (diagonal, in discretization)
* `markov_property`: yes
* `precision_sparse`: yes
* `precision_notes`: nugget yields diagonal precision in discretized models

### 9.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA
* `state_space_representability_notes`: Not Known

### 9.14 Reparameterizations

* `reparameterizations`: NA
* `reparameterizations_notes`: Not Known

### 9.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary
* `isotropy_block_1`: isotropic (delta)
* `isotropy_block_2`: isotropic (delta)
* `separability`: yes
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: infinite as a pointwise RF; defined as GRF
* `mean_square_continuity`: no
* `differentiability_order`: none
* `holder_fractal_class`: NA
* `short_or_long_range_dependence`: none (no correlation)
* `compact_support`: yes (in distributional sense)
* `ridge_effect`: no
* `stein_regularity`: NA

* `identifiability_by_case_pair`: NA
* `properties_notes`: Not Known

### 9.16 Computational implications

* `dense_or_sparse_structure`: sparse (diagonal in discretization)
* `kronecker_structure_available`: yes (if grid separable)
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: NA
* `computational_implications_notes`: Not Known

### 9.17 Approximations

* `power_series`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)
* `asymptotic_expansions`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)
* `special_function_representations`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)
* `numerical_approximations`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 9.18 Notes
* `notes_notes`: Not Known

## 10. `fB2`: two-input fractional Brownian increments (GRF)

### 10.1 Name

* `kernel_name`: two-input fractional Brownian increments (GRF)
* `call_notation`: `fB2`
* `aliases`: `fB2`, `fractional_Brownian_2input`, `intrinsic_fractional`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 10.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$, $d_{E2}\ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 10.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (increments)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: enters via joint lag norm
* block 2:
  * `requires_h_2`: yes (increments)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: enters via joint lag norm
* `physical_space_dependence_notes`: Not Known

### 10.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density (improper)
  * `spectral_dependence_type_1`: radial (joint)
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density (improper)
  * `spectral_dependence_type_2`: radial (joint)
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: depends on joint norm in the product frequency space
* `spectral_space_dependence_notes`: Not Known

### 10.5 Construction

* `construction_class`: joint_distance
* `base_kernels`: fractional Brownian (intrinsic) on $\mathbb{R}^{d_{E1}+d_{E2}}$
* `construction_formula`:

  Let $h=(h_{E1},h_{E2})\in \mathbb{R}^{d_{E1}+d_{E2}}$ be the joint lag vector. Define the variogram

  $$
  \gamma(h) = \sigma^2 \|h\|^{2H},
  \qquad 0<H<1,
  $$

  and the canonical generalized covariance (intrinsic order-0 representation)

  $$
  C(h) = -\frac{\sigma^2}{2}\,\|h\|^{2H},
  $$

  which is defined up to an additive constant in intrinsic (GRF) models.

  $C(u,v)=\frac{\sigma^2}{2}(\|u\|^{2H}+\|v\|^{2H}-\|u-v\|^{2H})$ when an origin is fixed; the kernel grammar here uses lag-only and treats the model as an intrinsic GRF on the product space.
* `construction_notes`: equivalent to the usual fractional Brownian field covariance

### 10.6 Parameters

* `parameter_list`: $\sigma^2$, $H$
* `parameter_meanings`:
  * $\sigma^2$: scale (variogram)
  * $H$: Hurst exponent controlling roughness and long-range dependence
* `parameter_constraints`: $\sigma^2>0$; $0<H<1$
* `PSD_guarantee_mechanism`: mixed (intrinsic; conditional positive definiteness / generalized)
* `parameters_notes`: Not Known

### 10.7 RF / GRF

* `RF_or_GRF`: GRF (intrinsic)
* `spectral_divergence_at_zero`: diverges (intrinsic)
* `spectral_divergence_at_infinity`: diverges depending on $H$ (improper)
* `GRF_correction_methodology`: use increments / intrinsic random function framework; specify reference constraints
* `rf_grf_notes`: Not Known

### 10.8 Representations

* `primary_representation_id`: GRF-SPEC-01
* `supported_representation_ids`: GRF-SPEC-01, GRF-VAR-01

* `covariance_representation`: yes (generalized covariance)
* `covariance_formula`: $C(h)=-\frac{\sigma^2}{2}\|h\|^{2H}$
* `spectral_representation`: yes (improper)
* `spectral_formula`: $f(\xi)\propto \|\xi\|^{-(2H+d_{E1}+d_{E2})}$, where $\xi=(\xi_{E1},\xi_{E2})$
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 10.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Not applicable as a proper RF; intrinsic marginal variogram on block 1 induced by setting $h_{E2}=0$
* `marginal_kernel_block_2`: intrinsic marginal variogram on block 2 induced by setting $h_{E1}=0$
* `marginal_consistency_conditions`: intrinsic-only; requires choice of generalized covariance convention
* `separable_limit`: none (intrinsic joint-distance)
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 10.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: GRF
* `spectral_normalization`: increment_normalized
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: normalize via variogram at unit lag

### 10.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: no (joint)
* `two_input_radial_integration`: applicable: no
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 10.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: intrinsic long-memory GRF

### 10.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: no
* `approximation_method`: NA
* `ordering_dimension_required`: no
* `error_control`: NA
* `state_space_representability_notes`: Not Known

### 10.14 Reparameterizations

* `reparameterizations`: NA
* `reparameterizations_notes`: Not Known

### 10.15 Properties

* `symmetry`: symmetric (as generalized covariance)
* `stationarity_invariance`: stationary increments; not stationary as a proper RF
* `isotropy_block_1`: isotropic in joint space
* `isotropy_block_2`: isotropic in joint space
* `separability`: no
* `PSD_guarantee_mechanism`: mixed
* `pointwise_variance`: infinite / undefined (intrinsic)
* `mean_square_continuity`: Not Known (intrinsic)
* `differentiability_order`: $H$ controls local regularity; Not Known exact
* `holder_fractal_class`: $H$-Hölder in increments
* `short_or_long_range_dependence`: long-range dependence for $H>1/2$
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 10.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no
* `fft_suitability`: partial (spectral is improper)
* `nufft_suitability`: partial
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 10.17 Approximations

* `power_series`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)
* `asymptotic_expansions`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)
* `special_function_representations`: NA (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)
* `numerical_approximations`: simulate via spectral synthesis / circulant embedding on bounded grids (requires regularization) (representation_type: spectral_measure; representation_id: GRF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 10.18 Notes
* `notes_notes`: Not Known

## 11. `SepProd-SSMM`: separable product Euclidean-Euclidean Matérns kernel

### 11.1 Name

* `kernel_name`: separable product Euclidean-Euclidean Matérns kernel
* `call_notation`: `SepProd-SSMM`
* `aliases`: `SepProd-SSMM`, `separable_matérn_matérn`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 11.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$, $d_{E2}\ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 11.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (via norm)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: radial Matérn-type
* block 2:
  * `requires_h_2`: yes (via norm)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: radial Matérn-type
* `physical_space_dependence_notes`: Not Known

### 11.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: separable; notes: product form
* `spectral_space_dependence_notes`: Not Known

### 11.5 Construction

* `construction_class`: separable_product
* `base_kernels`: Matérn-type (E1), Matérn-type (E2)
* `construction_formula`:
  $$
  f(\xi_{E1},\xi_{E2}) = \gamma\,(\kappa_{E1}^2+\|\xi_{E1}\|^2)^{-\alpha_{E1}\nu}\,(\kappa_{E2}^2+\|\xi_{E2}\|^2)^{-\alpha_{E2}\nu}.
  (\kappa_{E1}^2+\|\xi_{E1}\|^2)^{-\alpha_{E1}\nu}\,
  (\kappa_{E2}^2+\|\xi_{E2}\|^2)^{-\alpha_{E2}\nu}.
  $$
* `construction_notes`: separable; weights are absorbed into $\gamma$ and/or the $\kappa$ parameters

### 11.6 Parameters

* `parameter_list`: $\gamma$, $\kappa_{E1}$, $\kappa_{E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\kappa_{E1},\kappa_{E2}$: inverse range parameters
  * $\alpha_{E1},\alpha_{E2}$: smoothness exponents
  * $\nu$: outer exponent (shared)
* `parameter_constraints`: $\gamma>0$; $\kappa_{E1},\kappa_{E2}>0$; $\alpha_{E1},\alpha_{E2}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 11.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\alpha_{E1}\nu$ and $\alpha_{E2}\nu$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 11.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01

* `covariance_representation`: yes (separable product of one-block inverse Fourier transforms; closed form depends on parameters)
* `covariance_formula`: $C(h_{E1},h_{E2}) = C_{E1}(h_{E1})\,C_{E2}(h_{E2})$ (with Matérn-type factors)
* `spectral_representation`: yes
* `spectral_formula`: given in Section 11.5
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: yes (blockwise, if each factor has SPDE)
* `SPDE_operator_formula`: product of blockwise operators; Not Known
* `representations_notes`: Not Known

### 11.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Matérn-type $C_{E1}$ obtained by setting $h_{E2}=0$
* `marginal_kernel_block_2`: Matérn-type $C_{E2}$ obtained by setting $h_{E1}=0$
* `marginal_consistency_conditions`: NA
* `separable_limit`: already separable
* `marginal_reduction_limits`: NA
* `marginals_consistency_and_limits_notes`: Not Known

### 11.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for unit variance
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: NA
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 11.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: yes (both blocks)
* `two_input_radial_integration`: applicable: partial; requires_separability yes; notes: blockwise Hankel transforms possible
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 11.12 Precision / Markov structure

* `has_precision_representation`: yes (if both factors admit SPDE / Markov)
* `precision_form`: operator_derived
* `markov_property`: yes (if each factor is Markov)
* `precision_sparse`: depends_on_discretization
* `precision_notes`: separability supports Kronecker precision structure in discretizations

### 11.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: SPDE_discretization
* `ordering_dimension_required`: yes (if using state-space along one block)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 11.14 Reparameterizations

* `reparameterizations`: standard Matérn reparameterizations per block
* `reparameterizations_notes`: Not Known

### 11.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: yes
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: finite if integrability holds
* `mean_square_continuity`: yes for admissible parameter ranges
* `differentiability_order`: controlled by $\alpha_{E1}\nu$ and $\alpha_{E2}\nu$
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: short-range (Matérn-type)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: as per Matérn

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 11.16 Computational implications

* `dense_or_sparse_structure`: dense unless SPDE discretization used
* `kronecker_structure_available`: yes (separable)
* `fft_suitability`: yes
* `nufft_suitability`: yes
* `spde_solver_suitability`: yes (blockwise)
* `computational_implications_notes`: Not Known

### 11.17 Approximations

* `power_series`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `special_function_representations`: Matérn Bessel forms (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)
* `numerical_approximations`: SPDE/GMRF approximations; low-rank separable approximations (representation_type: spectral_density; representation_id: RF-SPEC-01; approximate)

---
* `approximations_notes`: Not Known

### 11.18 Notes
* `notes_notes`: Not Known

## 12. `Gneit1-SSCC`: Gneiting nonseparable Euclidean-Euclidean Caucys kernel

### 12.1 Name

* `kernel_name`: Gneiting nonseparable Euclidean-Euclidean Caucys kernel
* `call_notation`: `Gneit1-SSCC`
* `aliases`: `Gneiting2002`, `Gneiting-ST`, `Gneiting-class`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 12.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1` (space)
* `block_alias_2`: `E2` (time)
* `intrinsic_dimension_constraints`:
  * Euclidean space dimension $d_{E1}\ge 1$
  * Euclidean block-2 dimension $d_{E2}=1$ (this kernel is defined for a scalar Euclidean block-2 lag)
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean (via $r_{E1}$)
* `admissible_metrics_block_2`: Euclidean on $\mathbb{R}$ (via $r_{E2}=|u|$)
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 12.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no (uses only distance $r_{E1}=\|h_{E1}\|$)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso or r_aniso
  * `directional_requirements_notes_1`: isotropic/anisotropic space depends on geometry-provided $r_{E1}$
* block 2:
  * `requires_h_2`: yes (1D lag $u$)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso
  * `directional_requirements_notes_2`: time uses absolute lag $r_{E2}=|u|$ (fully symmetric in time)
* `physical_space_dependence_notes`: Not Known

### 12.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: NA
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: NA
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: coupled; notes: nonseparable covariance form; explicit joint spectrum not required for definition
* `spectral_space_dependence_notes`: Not Known

### 12.5 Construction

* `construction_class`: gneiting_type
* `base_kernels`: generalized Cauchy in Euclidean block 1; generalized Cauchy in Euclidean block 2; Gneiting warping
* `construction_formula`:

  For Euclidean block-1 distance $r_{E1}\ge 0$ and Euclidean block-2 lag magnitude $r_{E2}=|u|\ge 0$,

  $$
  C(r_{E1}, r_{E2})
  =
  \frac{\sigma^2}{(1 + a\, r_{E2}^{2\alpha})^{\beta}}
  \;
  \varphi\!(
    \frac{r_{E1}}{(1 + a\, r_{E2}^{2\alpha})^{\gamma}}
  ),
  $$

  where $\varphi:[0,\infty)\to\mathbb{R}$ is completely monotone (CM).

  A common explicit choice is $\varphi(t) = (1+t^2)^{-\nu}$, giving

  $$
  C(r_{E1}, r_{E2})
  =
  \frac{\sigma^2}{(1 + a\, r_{E2}^{2\alpha})^{\beta}}
  (
    1 + \frac{r_{E1}^2}{(1 + a\, r_{E2}^{2\alpha})^{2\gamma}}
  )^{-\nu}.
  $$

  * Valid (positive definite on $\mathbb{R}^{d_{E1}}\times\mathbb{R}$) under Gneiting’s conditions: $\varphi$ CM, $0<\alpha\le 1$, $a>0$, $\beta\ge 0$, $\gamma\in[0,1]$ with constraint $\beta \ge \gamma\, d_{E1}/2$ (for the CM class). Additional constraints apply for specific $\varphi$ choices.
  * When $\gamma=0$, the model becomes separable: space factor $\varphi(r_{E1})$ times time factor $(1+a r_{E2}^{2\alpha})^{-\beta}$.
* `construction_notes`:

### 12.6 Parameters

* `parameter_list`: $\sigma^2$, $a$, $\alpha$, $\beta$, $\gamma$, $\varphi$ (and parameters of $\varphi$, e.g., $\nu$)
* `parameter_meanings`:
  * $\sigma^2$: variance
  * $a$: Euclidean block-2 range/scale
  * $\alpha$: Euclidean block-2 smoothness/shape (Cauchy-type exponent)
  * $\beta$: Euclidean block-2 tail/decay exponent (and cross constraint)
  * $\gamma$: Euclidean-block interaction/warping exponent
  * $\varphi$: CM function controlling Euclidean block-1 shape; e.g. $\nu$ controls the Euclidean tail in generalized Cauchy
* `parameter_constraints`:
  * $\sigma^2>0$
  * $a>0$
  * $0<\alpha\le 1$
  * $\beta\ge 0$
  * $0\le \gamma \le 1$
  * $\varphi$ completely monotone
  * plus Gneiting’s admissibility constraint(s), including $\beta \ge \gamma d_{E1}/2$ for the CM class
* `PSD_guarantee_mechanism`: by_construction (Gneiting class)
* `parameters_notes`: Not Known

### 12.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 12.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01

* `covariance_representation`: yes
* `covariance_formula`: given in Section 12.5
* `spectral_representation`: Not Known (exists by Bochner; explicit density Not Known)
* `spectral_formula`: Not Known
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 12.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: $C(r_{E1},0)=\sigma^2\,\varphi(r_{E1})$
* `marginal_kernel_block_2`: $C(0,r_{E2})=\sigma^2(1+a r_{E2}^{2\alpha})^{-\beta}$
* `marginal_consistency_conditions`: $\varphi(0)=1$ if $\sigma^2$ is the marginal variance
* `separable_limit`: $\gamma=0$ gives separable product
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 12.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\sigma^2$ is marginal variance
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: choose $\sigma^2$ so that $C(0,0)=\sigma^2$

### 12.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: yes (space is radial; time is 1D)
* `two_input_radial_integration`: applicable: partial; requires_separability no; notes: space radial reductions possible; full joint reduction Not Known
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 12.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: covariance-defined; no canonical sparse precision

### 12.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: time_discretization
* `ordering_dimension_required`: yes (time)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 12.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 12.15 Properties

* `symmetry`: symmetric in the full arguments; fully symmetric in time (depends on $|u|$)
* `stationarity_invariance`: stationary in space and time
* `isotropy_block_1`: isotropic unless anisotropic $r_{E1}$ is used
* `isotropy_block_2`: isotropic in 1D (depends on $|u|$)
* `separability`: no unless $\gamma=0$
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: depends on $\alpha$ and $\varphi$; Not Known exact
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: typically short-range; tails depend on $\beta$ and $\varphi$ choice
* `compact_support`: no
* `ridge_effect`: yes (interaction through scaling of one Euclidean argument by the other)
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
  * `block_1_case_id`: Not Known
  * `block_2_case_id`: Not Known
  * `marginal_block_1`: Not Known
  * `marginal_block_2`: Not Known
  * `coupling_parameters`: Not Known
  * `identifiable_parameter_combinations`: Not Known
  * `notes`: Not Known
  * `relative_rates`:
  * `relative_domain_growth`: Not Known
  * `relative_infill_rate`: Not Known
* `properties_notes`: Not Known

### 12.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no (unless separable $\gamma=0$)
* `fft_suitability`: yes for gridded domains
* `nufft_suitability`: yes for irregular Euclidean designs (approximate)
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 12.17 Approximations

* `power_series`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `numerical_approximations`: Euclidean discretization plus Euclidean FFT/NUFFT; separable approximation for small $\gamma$ (representation_type: covariance; representation_id: RF-COV-01; approximate)

---
* `approximations_notes`: Not Known

### 12.18 Notes
* `notes_notes`: Not Known

## 13. `Gneit2-SpSMM`: Stieltjes Gneiting sphere-Euclidean Materns kernel

### 13.1 Name

* `kernel_name`: Stieltjes Gneiting sphere-Euclidean Materns kernel
* `call_notation`: `Gneit2-SpSMM`
* `aliases`: `Gneiting-Sphere-Stieltjes`, `sphere_time_gneiting_stieltjes`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 13.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(sphere, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `SP1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{SP1}=2$, $d_{E2}=1$
* `admissible_metrics_block_1`: great-circle
* `admissible_metrics_block_2`: Euclidean on $\mathbb{R}$
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 13.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: r_iso
  * `directional_requirements_notes_1`: depends on $r_{SP1}$ (great-circle)
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso
  * `directional_requirements_notes_2`: depends on $r_{E2}=|t|$
* `physical_space_dependence_notes`: Not Known

### 13.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: NA
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: NA
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: NA; notes: defined via covariance form; spectrum not specified
* `spectral_space_dependence_notes`: Not Known

### 13.5 Construction

* `construction_class`: gneiting_type
* `base_kernels`: generalized Cauchy on sphere; Cauchy-type in time; Stieltjes mixing
* `construction_formula`:

  $$
  C(\theta,t)=\frac{1}{(1+b(t))^c}\varphi(\frac{\theta}{(1+b(t))^d}),
  $$

  where $\theta=r_{SP1}/R_{SP1}$, $t$ is the Euclidean block-2 lag, $b(t)$ is Bernstein, and $\varphi$ is a Stieltjes function with $\varphi(0)=1$.
* `construction_notes`: a spherical analogue of Gneiting’s class; admissibility depends on Stieltjes/Bernstein conditions and parameter inequalities.

### 13.6 Parameters

* `parameter_list`: $\sigma^2$, $b(\cdot)$, $\varphi(\cdot)$, $c$, $d$, plus parameters inside $b,\varphi$
* `parameter_meanings`: Not Known
* `parameter_constraints`: $\sigma^2>0$; $\varphi$ Stieltjes; $b$ Bernstein; additional inequalities Not Known
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 13.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 13.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01

* `covariance_representation`: yes
* `covariance_formula`: given in 13.5
* `spectral_representation`: Not Known
* `spectral_formula`: Not Known
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 13.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: $C(\theta,0)=\varphi(\theta)$
* `marginal_kernel_block_2`: $C(0,t)=(1+b(t))^{-c}$
* `marginal_consistency_conditions`: $\varphi(0)=1$
* `separable_limit`: $d=0$ yields separable form
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 13.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $C(0,0)=\sigma^2$
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: choose $\sigma^2$ so that $C(0,0)=\sigma^2$

### 13.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial
* `two_input_radial_integration`: applicable: NA
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 13.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: NA

### 13.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: time_discretization
* `ordering_dimension_required`: yes
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 13.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 13.15 Properties

* `symmetry`: symmetric in $(\theta,t)$ via $|t|$
* `stationarity_invariance`: stationary in time; isotropic on sphere
* `isotropy_block_1`: isotropic (zonal)
* `isotropy_block_2`: isotropic in 1D
* `separability`: no unless $d=0$
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: yes
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 13.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no (unless separable)
* `fft_suitability`: no (sphere)
* `nufft_suitability`: no
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 13.17 Approximations

* `power_series`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `numerical_approximations`: spherical harmonic truncation; time discretization (representation_type: covariance; representation_id: RF-COV-01; approximate)

---
* `approximations_notes`: Not Known

### 13.18 Notes
* `notes_notes`: Not Known

## 14. `Gneit3-SpSCM`: sphere-Euclidean cauchy-matern kernel

### 14.1 Name

* `kernel_name`: sphere-Euclidean cauchy-matern kernel
* `call_notation`: `Gneit3-SpSCM`
* `aliases`: `sphere_time_gneiting_gencauchy`
* `parent_kernel`: `Gneit2-SpSMM`
* `parent_kernel_constraints`: choose Bernstein/Stieltjes pair corresponding to generalized Cauchy
* `references`: Not Known
* `name_notes`: Not Known

### 14.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(sphere, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `SP1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{SP1}=2$, $d_{E2}=1$
* `admissible_metrics_block_1`: great-circle
* `admissible_metrics_block_2`: Euclidean on $\mathbb{R}$
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 14.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: r_iso
  * `directional_requirements_notes_1`: depends on $r_{SP1}$ (great-circle)
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso
  * `directional_requirements_notes_2`: depends on $r_{E2}=|t|$
* `physical_space_dependence_notes`: Not Known

### 14.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: NA
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: NA
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: NA; notes: covariance-defined
* `spectral_space_dependence_notes`: Not Known

### 14.5 Construction

* `construction_class`: gneiting_type
* `base_kernels`: generalized Cauchy
* `construction_formula`:

  $$
  C(\theta,t)=\frac{1}{(1+a|t|^{\alpha})^{\beta}}(1+\frac{\theta^{\gamma}}{(1+a|t|^{\alpha})^{\delta}})^{-\nu},
  $$

  for admissible parameter ranges (Not Known here).
* `construction_notes`: special case; admissibility inherits from 13 with specific Stieltjes/Bernstein choices.

### 14.6 Parameters

* `parameter_list`: $\sigma^2$, $a$, $\alpha$, $\beta$, $\gamma$, $\delta$, $\nu$
* `parameter_meanings`: Not Known
* `parameter_constraints`: $\sigma^2>0$; $a>0$; other constraints Not Known
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 14.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 14.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01

* `covariance_representation`: yes
* `covariance_formula`: given in 14.5
* `spectral_representation`: Not Known
* `spectral_formula`: Not Known
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 14.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: $C(\theta,0)=(1+\theta^\gamma)^{-\nu}$
* `marginal_kernel_block_2`: $C(0,t)=(1+a|t|^\alpha)^{-\beta}$
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: $\delta=0$ yields separable
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 14.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $C(0,0)=\sigma^2$
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 14.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial
* `two_input_radial_integration`: applicable: NA
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 14.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: NA

### 14.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: time_discretization
* `ordering_dimension_required`: yes
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 14.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 14.15 Properties

* `symmetry`: symmetric in $t$ (depends on $|t|$)
* `stationarity_invariance`: stationary in time; isotropic on sphere
* `isotropy_block_1`: isotropic
* `isotropy_block_2`: isotropic in 1D
* `separability`: no unless $\delta=0$
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: yes
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 14.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 14.17 Approximations

* `power_series`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `numerical_approximations`: spherical harmonic truncation; time discretization (representation_type: covariance; representation_id: RF-COV-01; approximate)

---
* `approximations_notes`: Not Known

### 14.18 Notes
* `notes_notes`: Not Known

## 15. `GammaMix1-SpSMM`: gamma-mixture sphere-Euclidean Matérns kernel

### 15.1 Name

* `kernel_name`: gamma-mixture sphere-Euclidean Matérns kernel
* `call_notation`: `GammaMix1-SpSMM`
* `aliases`: `GammaMix-SPT-Matern`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 15.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(sphere, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `SP1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{SP1}=2$, $d_{E2}=1$
* `admissible_metrics_block_1`: great-circle
* `admissible_metrics_block_2`: Euclidean on $\mathbb{R}$
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 15.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: r_iso
  * `directional_requirements_notes_1`: depends on great-circle distance via $\theta=r_{SP1}/R_{SP1}$
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso
  * `directional_requirements_notes_2`: depends on $r_{E2}=|t|$
* `physical_space_dependence_notes`: Not Known

### 15.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: NA
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: NA
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: NA; notes: covariance-defined scale mixture
* `spectral_space_dependence_notes`: Not Known

### 15.5 Construction

* `construction_class`: scale_mixture
* `base_kernels`: Gaussian on $\mathbb{R}^3\times \mathbb{R}$ mixed over a gamma variable
* `construction_formula`:

  Let $\theta=r_{SP1}/R_{SP1}\in[0,\pi]$ and define scaled distances

  $$
  d_s(\theta)=2a_s\sin(\theta/2),
  \qquad
  d_t(r_{E2})=\frac{r_{E2}}{a_t}.
  $$

  Let $g_{\nu,1}(s)=\frac{s^{\nu-1}e^{-s}}{\Gamma(\nu)}$ be the Gamma$(\nu,1)$ density on $(0,\infty)$. Then

  $$
  C(\theta,r_{E2})
  =
  \sigma^2 \int_0^\infty g_{\nu,1}(s)
  \exp\!(
  -\frac{\nu}{2s}[d_s(\theta)^2+d_t(r_{E2})^2]
  )\,ds.
  $$
* `construction_notes`: gamma mixture over an exponential quadratic form yields a Matérn-type dependence.

### 15.6 Parameters

* `parameter_list`: $\sigma^2$, $\nu$, $a_s$, $a_t$
* `parameter_meanings`: variance, mixture/smoothness, sphere scale, time scale
* `parameter_constraints`: $\sigma^2>0$; $\nu>0$; $a_s>0$; $a_t>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 15.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 15.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01

* `covariance_representation`: yes
* `covariance_formula`: given in 15.5
* `spectral_representation`: Not Known
* `spectral_formula`: Not Known
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 15.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: $C(\theta,0)$ gives a sphere Matérn-type kernel
* `marginal_kernel_block_2`: $C(0,r_{E2})$ gives a Matérn-type kernel on $\mathbb{R}$
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 15.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $C(0,0)=\sigma^2$
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 15.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial
* `two_input_radial_integration`: applicable: NA
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 15.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: NA

### 15.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: time_discretization
* `ordering_dimension_required`: yes
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 15.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 15.15 Properties

* `symmetry`: symmetric in time (depends on $|t|$)
* `stationarity_invariance`: stationary in time; isotropic on sphere
* `isotropy_block_1`: isotropic
* `isotropy_block_2`: isotropic in 1D
* `separability`: Not Known
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 15.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 15.17 Approximations

* `power_series`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `numerical_approximations`: numerical quadrature for the mixing integral (representation_type: covariance; representation_id: RF-COV-01; approximate)

---
* `approximations_notes`: Not Known

### 15.18 Notes
* `notes_notes`: Not Known

## 16. `GammaMix2-SpSCC`: gamma-mixture sphere-Euclidean Cauchys kernel

### 16.1 Name

* `kernel_name`: gamma-mixture sphere-Euclidean Cauchys kernel
* `call_notation`: `GammaMix2-SpSCC`
* `aliases`: `GammaMix-SPT-Cauchy`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Not Known
* `name_notes`: Not Known

### 16.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(sphere, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `SP1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{SP1}=2$, $d_{E2}=1$
* `admissible_metrics_block_1`: great-circle
* `admissible_metrics_block_2`: Euclidean on $\mathbb{R}$
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 16.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: r_iso
  * `directional_requirements_notes_1`: depends on great-circle distance via $\theta=r_{SP1}/R_{SP1}$
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso
  * `directional_requirements_notes_2`: depends on $r_{E2}=|t|$
* `physical_space_dependence_notes`: Not Known

### 16.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: NA
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: NA
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: NA; notes: covariance-defined scale mixture
* `spectral_space_dependence_notes`: Not Known

### 16.5 Construction

* `construction_class`: scale_mixture
* `base_kernels`: exponential quadratic form mixed over a gamma-like variable
* `construction_formula`:

  Let $\theta=r_{SP1}/R_{SP1}\in[0,\pi]$ and define scaled distances

  $$
  d_s(\theta)=2a_s\sin(\theta/2),
  \qquad
  d_t(r_{E2})=(\frac{r_{E2}}{a_t})^{\gamma}.
  $$

  With Gamma$(\nu,1)$ density $g_{\nu,1}(s)=\frac{s^{\nu-1}e^{-s}}{\Gamma(\nu)}$, define

  $$
  C(\theta,r_{E2})
  =
  \sigma^2 \int_0^\infty g_{\nu,1}(s)
  \exp\!(
  -\frac{\nu}{2s}\, d_s(\theta)^2
  - s\, d_t(r_{E2})
  )\,ds.
  $$
* `construction_notes`: mixture yields generalized Cauchy-type behavior in time.

### 16.6 Parameters

* `parameter_list`: $\sigma^2$, $\nu$, $a_s$, $a_t$, $\gamma$
* `parameter_meanings`: variance, mixture parameter, sphere scale, time scale, time exponent
* `parameter_constraints`: $\sigma^2>0$; $\nu>0$; $a_s>0$; $a_t>0$; $\gamma\in(0,2]$ (typical; exact Not Known)
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 16.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 16.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01

* `covariance_representation`: yes
* `covariance_formula`: given in 16.5
* `spectral_representation`: Not Known
* `spectral_formula`: Not Known
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 16.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: $C(\theta,0)$ gives a sphere kernel
* `marginal_kernel_block_2`: $C(0,r_{E2})$ gives a Cauchy-type kernel on $\mathbb{R}$
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 16.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $C(0,0)=\sigma^2$
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: NA

### 16.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial
* `two_input_radial_integration`: applicable: NA
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 16.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: NA

### 16.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: time_discretization
* `ordering_dimension_required`: yes
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 16.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 16.15 Properties

* `symmetry`: symmetric in time (depends on $|t|$)
* `stationarity_invariance`: stationary in time; isotropic on sphere
* `isotropy_block_1`: isotropic
* `isotropy_block_2`: isotropic in 1D
* `separability`: Not Known
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 16.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no
* `fft_suitability`: no
* `nufft_suitability`: no
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 16.17 Approximations

* `power_series`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `numerical_approximations`: numerical quadrature for the mixing integral (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `approximations_notes`: Not Known

### 16.18 Notes
* `notes_notes`: Not Known

## 17. `Stein2-SpSMM`: Stein sphere-Euclidean Matérns kernel

### 17.1 Name

* `kernel_name`: Stein sphere-Euclidean Matérns kernel
* `call_notation`: `Stein2-SpSMM`
* `aliases`: `Stein2-SpSMM`, `Stein-SPxS`, `Stein-sphere-euclidean`
* `parent_kernel`: `Stein1-SSMM`
* `parent_kernel_constraints`: relabel aliases to $(SP1,E2)$
* `references`: Not Known
* `name_notes`: Not Known

### 17.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(sphere, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `SP1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{SP1}=2$, $d_{E2}\ge 1$
* `admissible_metrics_block_1`: great-circle
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 17.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no (compact)
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: r_iso
  * `directional_requirements_notes_1`: depends on great-circle distance $r_{SP1}$
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso or r_aniso
  * `directional_requirements_notes_2`: depends on Euclidean norm $\|h_{E2}\|$ (or anisotropic norm via geometry)
* `physical_space_dependence_notes`: Not Known

### 17.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: measure (discrete in $\ell$)
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: coupled through $(\ell,\xi_{E2})$ in a single rational denominator
* `spectral_space_dependence_notes`: Not Known

### 17.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: NA
* `construction_formula`:

  Mixed discrete–continuous spectral density:

  $$
  f(\ell,\xi_{E2})
  =
  \frac{1}{4\pi}\,
  \frac{\gamma}{
    [
      (\epsilon_{SP1}\,\lambda_\ell + \kappa_{SP1}^2)^{\alpha_{SP1}}
      +
      (\kappa_{E2}^2 + \|\xi_{E2}\|^2)^{\alpha_{E2}}
    ]^{\nu}
  },
  \qquad
  \lambda_\ell=\ell(\ell+1).
  $$

  Covariance (zonal on the sphere):

  $$
  C(r_{SP1},h_{E2})
  =
  \sum_{\ell=0}^{\infty}\frac{2\ell+1}{4\pi}\,
  P_\ell\!(\cos\!\frac{r_{SP1}}{R_{SP1}})
  \int_{\mathbb{R}^{d_{E2}}} e^{i\xi_{E2}^\top h_{E2}}\, f(\ell,\xi_{E2})\, d\xi_{E2}.
  $$

  * This is the same Stein mixed-spectrum model as Section 5, but uses the canonical aliases requested: `SP1 × E2` (not `S1`).
* `construction_notes`:

### 17.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{SP1}$, $\kappa_{SP1}$, $\alpha_{SP1}$, $\kappa_{E2}$, $\alpha_{E2}$, $\nu$
* `parameter_meanings`: as in Section 5, relabeled to `SP1 × E2`
* `parameter_constraints`: $\gamma>0$; $\epsilon_{SP1}>0$; $\kappa_{SP1},\kappa_{E2}>0$; $\alpha_{SP1},\alpha_{E2}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: Not Known

### 17.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: controlled by $\nu$, $\alpha_{SP1}$, $\alpha_{E2}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 17.8 Representations

* `primary_representation_id`: RF-MIXED-01
* `supported_representation_ids`: RF-MIXED-01
* `covariance_representation`: yes
* `covariance_formula`: given in 17.5
* `spectral_representation`: yes
* `spectral_formula`: given in 17.5
* `mixed_half_spectral`: yes
* `mixed_half_spectral_formula`: given in 17.5
* `SPDE_operator_representation`: Not Known
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 17.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: set $h_{E2}=0$; yields a zonal kernel with coefficients $\int f(\ell,\xi_{E2})\,d\xi_{E2}$ (Not Known closed form)
* `marginal_kernel_block_2`: set $r_{SP1}=0$; yields a Euclidean kernel with spectral density proportional to $\sum_\ell (2\ell+1) f(\ell,\xi_{E2})$ (Not Known closed form)
* `marginal_consistency_conditions`: Not Known
* `separable_limit`: Not Known
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 17.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ selected so $C(0,0)$ matches target
* `derived_scale_relation`: Not Known
* `mixed_representation_normalization`: Not Known
* `normalization_notes`: choose $\gamma$ to match desired marginal variance

### 17.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: Euclidean block radial; sphere block discrete
* `two_input_radial_integration`: applicable: partial; notes: Euclidean radial transform inside each $\ell$ term
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 17.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: Not Known

### 17.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: rational_spectral
* `ordering_dimension_required`: yes (choose an ordering on the Euclidean block)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 17.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 17.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary in Euclidean block; isotropic on sphere
* `isotropy_block_1`: isotropic (zonal on $S^2$)
* `isotropy_block_2`: isotropic (radial) unless anisotropic distance is used
* `separability`: Not Known
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: finite if summability/integrability conditions hold
* `mean_square_continuity`: Not Known
* `differentiability_order`: Not Known
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: Not Known
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: Not Known
* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 17.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no
* `fft_suitability`: yes (Euclidean block)
* `nufft_suitability`: yes
* `spde_solver_suitability`: Not Known
* `computational_implications_notes`: Not Known

### 17.17 Approximations

* `power_series`: Not Known (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `special_function_representations`: Legendre expansion (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `numerical_approximations`: truncate in $\ell$; radial FFT/Hankel transforms or NUFFT for Euclidean inversion (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `approximations_notes`: Not Known

### 17.18 Notes


## 18. `NFSST-SSMC`: non-fully symmetric space–space Matérn–Cauchy

### 18.1 Name

* `kernel_name`: non-fully symmetric space–space Matérn–Cauchy
* `call_notation`: `NFSST-SSMC`
* `aliases`: `NFSST-MC`, `NFSST-Matern-Cauchy`, `Wu-2021-MC`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA
* `references`: Wu2021
* `name_notes`: Not Known

### 18.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1` (space)
* `block_alias_2`: `E2` (time)
* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$, $d_{E2}=1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean (via $h_{E1}$)
* `admissible_metrics_block_2`: Euclidean on $\mathbb{R}$ (via scalar lag $u=h_{E2}$)
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: Not Known

### 18.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes
  * `physical_dependence_type_1`: lag-based
  * `radial_quantity_used_1`: NA
  * `directional_requirements_notes_1`: depends on $\|h_{E1}\|$ and on the projection $\mathbf{r}^\top h_{E1}$ (directional coupling)
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: lag-based
  * `radial_quantity_used_2`: NA
  * `directional_requirements_notes_2`: depends on $u$ and $u^2$ (not purely $|u|$ when coupling $\mathbf{r}\neq 0$)
* `physical_space_dependence_notes`: Not Known

### 18.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: NA
  * `spectral_dependence_type_1`: NA
  * `spectral_atoms_possible_1`: NA
* block 2:
  * `spectral_object_type_2`: NA
  * `spectral_dependence_type_2`: NA
  * `spectral_atoms_possible_2`: NA
* `joint_spectral_coupling`: coupled; notes: nonseparable covariance; explicit closed-form spectrum Not Known
* `spectral_space_dependence_notes`: Not Known

### 18.5 Construction

* `construction_class`: scale_mixture
* `base_kernels`: Matérn in Euclidean block 1; Cauchy in Euclidean block 2 (as marginals)
* `construction_formula`:

  Let $h_{E1}\in\mathbb{R}^{d_{E1}}$ be the Euclidean block-1 lag and let $u=h_{E2}\in\mathbb{R}$ be the Euclidean block-2 lag.
  Let $\mathbf{r}\in\mathbb{R}^{d_{E1}}$ be a coupling vector satisfying $\|\mathbf{r}\|<1$.

  Let $V_1\sim \Gamma(\nu_1,\text{rate}=1/2)$ and $V_2$ independent with density

  $$
  f_{V_2}(v)=\frac{\exp\!(-v^{\nu_2})}{\Gamma\!(1+\frac{1}{\nu_2})}, \qquad v>0.
  $$

  Define the correlation function

  $$
  \rho(h_{E1},u)
  =
  \mathbb{E}[
    \exp(
      -\frac12(
        \frac{a_1^2\|h_{E1}\|^2}{V_1}
        +
        \frac{2\sqrt{2}\,a_1 a_2\,u\,\mathbf{r}^\top h_{E1}\, V_2^{\nu_2/2}}{\sqrt{V_1}}
        +
        2 a_2^2 u^2 V_2^{\nu_2}
      )
    )
  ].
  $$

  A covariance kernel is then $C(h_{E1},u)=\sigma^2\,\rho(h_{E1},u)$.

  * “Non-fully symmetric” means generally $\rho(h_{E1},u)\neq \rho(h_{E1},-u)$ when $\mathbf{r}\neq 0$, while stationarity symmetry $\rho(h_{E1},u)=\rho(-h_{E1},-u)$ holds.
  * When $\mathbf{r}=0$, the model becomes fully symmetric and separable.
* `construction_notes`:

### 18.6 Parameters

* `parameter_list`: $\sigma^2$, $a_1$, $a_2$, $\nu_1$, $\nu_2$, $\mathbf{r}$
* `parameter_meanings`:
  * $\sigma^2$: variance scale (optional if using correlation)
  * $a_1$: Euclidean block-1 scale
  * $a_2$: Euclidean block-2 scale
  * $\nu_1$: Euclidean block-1 Matérn smoothness (via mixing on $V_1$)
  * $\nu_2$: Euclidean block-2 Cauchy shape parameter (via $V_2$)
  * $\mathbf{r}$: Euclidean-block coupling direction/intensity vector ($\|\mathbf{r}\|<1$)
* `parameter_constraints`: $\sigma^2>0$; $a_1>0$; $a_2>0$; $\nu_1>0$; $\nu_2>0$; $\|\mathbf{r}\|<1$
* `PSD_guarantee_mechanism`: by_construction (scale mixture of characteristic functions)
* `parameters_notes`: Not Known

### 18.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known
* `spectral_divergence_at_infinity`: Not Known
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: Not Known

### 18.8 Representations

* `primary_representation_id`: RF-COV-01
* `supported_representation_ids`: RF-COV-01
* `covariance_representation`: yes
* `covariance_formula`: given in Section 18.5
* `spectral_representation`: Not Known
* `spectral_formula`: Not Known
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no
* `SPDE_operator_formula`: NA
* `representations_notes`: Not Known

### 18.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: $\rho(h_{E1},0)$ is Matérn in $\mathbb{R}^{d_{E1}}$ with parameters $(\nu_1,a_1)$
* `marginal_kernel_block_2`: $\rho(0,u)$ is Cauchy on $\mathbb{R}$ with parameters $(\nu_2,a_2)$
* `marginal_consistency_conditions`: correlation normalization $\rho(0,0)=1$ (implied by construction)
* `separable_limit`: $\mathbf{r}=0$ gives $\rho(h_{E1},u)=\rho(h_{E1},0)\,\rho(0,u)$
* `marginal_reduction_limits`: Not Known
* `marginals_consistency_and_limits_notes`: Not Known

### 18.10 Normalization

* `primary_scale_parameter`: $\sigma^2$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\sigma^2=C(0,0)$
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: If using correlation, set $\sigma^2=1$.

### 18.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: only in the separable limit $\mathbf{r}=0$ (otherwise directional)
* `two_input_radial_integration`: applicable: no
* `two_input_radial_integration_and_reductions_notes`: Not Known

### 18.12 Precision / Markov structure

* `has_precision_representation`: no
* `precision_form`: NA
* `markov_property`: no
* `precision_sparse`: NA
* `precision_notes`: no known sparse precision form for the full non-fully symmetric model

### 18.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: time_discretization
* `ordering_dimension_required`: yes (time)
* `error_control`: Not Known
* `state_space_representability_notes`: Not Known

### 18.14 Reparameterizations

* `reparameterizations`: Not Known
* `reparameterizations_notes`: Not Known

### 18.15 Properties

* `symmetry`: symmetric as a covariance kernel; not fully symmetric in time reversal when $\mathbf{r}\neq 0$
* `stationarity_invariance`: stationary in the Euclidean block-1 and Euclidean block-2 lags
* `isotropy_block_1`: anisotropic/directional unless $\mathbf{r}=0$
* `isotropy_block_2`: not purely isotropic in 1D when $\mathbf{r}\neq 0$ (sign matters)
* `separability`: no unless $\mathbf{r}=0$
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $\sigma^2$
* `mean_square_continuity`: yes (for admissible parameters); Not Known proof details here
* `differentiability_order`: controlled by $(\nu_1,\nu_2)$; Not Known exact mapping in this entry
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: short-range in space (Matérn); heavy tails in time (Cauchy)
* `compact_support`: no
* `ridge_effect`: yes (directional Euclidean-block interaction)
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`: Not Known
* `properties_notes`: Not Known

### 18.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: no (unless $\mathbf{r}=0$)
* `fft_suitability`: partial (separable case); otherwise no simple FFT due to directional coupling term
* `nufft_suitability`: partial
* `spde_solver_suitability`: no
* `computational_implications_notes`: Not Known

### 18.17 Approximations

* `power_series`: yes (Taylor / series expansions in the coupling term; see implementation sources) (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `numerical_approximations`: numerical evaluation via truncated series and numerical integration (see `matern_cauchy.R`) (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `approximations_notes`: Not Known

## 19. `SumProd-SSMM`: Sum-and-product Matérns kernel

### 19.1 Name

* `kernel_name`: Sum-and-product Matérns kernel
* `call_notation`: `SumProd-SSMM`
* `aliases`: `sum_product_matern`, `sum+product Matérn`, `SumProd-SSMM`
* `parent_kernel`: NA
* `parent_kernel_constraints`: NA

### 19.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1} \ge 1$, $d_{E2} \ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA
* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no
* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes

### 19.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: r_iso / r_aniso
  * `directional_requirements_notes_1`: Matérn-type dependence on $r_{E1}$; additive components may be constant in block 2
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: r_iso / r_aniso
  * `directional_requirements_notes_2`: Matérn-type dependence on $r_{E2}$; additive components may be constant in block 1

### 19.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: measure
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: yes
* block 2:
  * `spectral_object_type_2`: measure
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: yes
* `joint_spectral_coupling`: coupled; notes: joint spectral **measure** contains a continuous product-density term plus singular ridge components with atoms at zero frequency in the other block.

### 19.5 Construction

* `construction_class`: product_sum
* `base_kernels`: Matérn-type (E1), Matérn-type (E2), Constant extensions to the product domain
* `construction_formula`:
  Define one-block Matérn-type spectral factors (your parameterization):
  $$
  f_{E1}(\xi_{E1}) := \big(\kappa_{E1}^{2}+|\xi_{E1}|^{2}\big)^{-\alpha_{E1}\nu},
  \qquad
  f_{E2}(\xi_{E2}) := \big(\kappa_{E2}^{2}+|\xi_{E2}|^{2}\big)^{-\alpha_{E2}\nu}.
  $$
  The joint spectral **measure** on $\mathbb{R}^{d_{E1}}\times\mathbb{R}^{d_{E2}}$ is
  $$
  \mu(d\xi_{E1},d\xi_{E2})
  ========================
  \gamma\Big[
  \epsilon_{E1}, f_{E1}(\xi_{E1}), d\xi_{E1}, \delta_{0}(d\xi_{E2})
  +
  \epsilon_{E2}, \delta_{0}(d\xi_{E1}), f_{E2}(\xi_{E2}), d\xi_{E2}
  +
  \epsilon_{E1E2}, f_{E1}(\xi_{E1}), f_{E2}(\xi_{E2}), d\xi_{E1}, d\xi_{E2}
  \Big],
  $$
  where $\delta_0$ denotes the Dirac measure at zero in the relevant frequency space.

  The covariance is then
  $$
  C(h_{E1},h_{E2})
  ================
  \int e^{i(\xi_{E1}^{\top}h_{E1}+\xi_{E2}^{\top}h_{E2})},\mu(d\xi_{E1},d\xi_{E2}).
  $$
* `construction_notes`:
  * PSD holds by construction as a nonnegative weighted sum of PSD kernels on the product domain.
  * The $\epsilon_{E1}$ and $\epsilon_{E2}$ terms are ridge components (constant in the other block), hence the spectral atoms $\delta_0$.
  * If $\epsilon_{E1}=\epsilon_{E2}=0$, the kernel reduces to a purely separable product Matérn-type model with a continuous joint density.

### 19.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{E1}$, $\epsilon_{E2}$, $\epsilon_{E1E2}$, $\kappa_{E1}$, $\kappa_{E2}$, $\alpha_{E1}$, $\alpha_{E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{E1}$: weight for block-1-only Matérn-type component (constant in block 2)
  * $\epsilon_{E2}$: weight for block-2-only Matérn-type component (constant in block 1)
  * $\epsilon_{E1E2}$: weight for separable product (interaction) component
  * $\kappa_{E1}$, $\kappa_{E2}$: inverse range parameters
  * $\alpha_{E1}$, $\alpha_{E2}$: block spectral exponents
  * $\nu$: shared outer exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{E1},\epsilon_{E2},\epsilon_{E1E2}\ge 0$ (not all zero); $\kappa_{E1},\kappa_{E2}>0$; $\alpha_{E1},\alpha_{E2}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction

### 19.7 RF / GRF

* `RF_or_GRF`: RF if $\alpha_{E1}\nu>d_{E1}/2$ and $\alpha_{E2}\nu>d_{E2}/2$; otherwise GRF
* `spectral_divergence_at_zero`: finite (since $\kappa_{E1},\kappa_{E2}>0$), with spectral atoms present when $\epsilon_{E1}>0$ or $\epsilon_{E2}>0$
* `spectral_divergence_at_infinity`: controlled by $\alpha_{E1}\nu$ and $\alpha_{E2}\nu$
* `GRF_correction_methodology`: NA

### 19.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01, RF-COV-01, RF-MIXED-01
* `covariance_representation`: yes
* `covariance_formula`:
  $$
  C(h_{E1},h_{E2})
  ================
  \gamma\Big[\epsilon_{E1}C_{E1}(h_{E1}) + \epsilon_{E2}C_{E2}(h_{E2}) + \epsilon_{E1E2}C_{E1}(h_{E1})C_{E2}(h_{E2})\Big],
  $$
  where $C_{E1}$ and $C_{E2}$ are the one-block inverse Fourier transforms of $f_{E1}$ and $f_{E2}$.
* `spectral_representation`: yes
* `spectral_formula`: joint spectral measure $\mu$ given in Section 19.5
* `mixed_half_spectral`: yes
* `mixed_half_spectral_formula`: termwise one-block inversions exist; ridge terms reduce via $\delta_0$ atoms (closed form Not Known in this parameterization)
* `SPDE_operator_representation`: approximate
* `SPDE_operator_formula`: Not Known (latent-sum representation into Matérn/SPDE components when applicable)

### 19.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`:
  * rule: set $h_{E2}=0$
  * formula: $C(h_{E1},0)=\gamma\big[\epsilon_{E2}+ (\epsilon_{E1}+\epsilon_{E1E2})C_{E1}(h_{E1})\big]$
* `marginal_kernel_block_2`:
  * rule: set $h_{E1}=0$
  * formula: $C(0,h_{E2})=\gamma\big[\epsilon_{E1}+ (\epsilon_{E2}+\epsilon_{E1E2})C_{E2}(h_{E2})\big]$
* `marginal_consistency_conditions`: none (always consistent by restriction)
* `separable_limit`: $\epsilon_{E1}=\epsilon_{E2}=0$ gives $C(h_{E1},h_{E2})=\gamma\epsilon_{E1E2}C_{E1}(h_{E1})C_{E2}(h_{E2})$
* `marginal_reduction_limits`: NA

### 19.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized if $\gamma$ chosen for a target $C(0,0)$
* `derived_scale_relation`: if $C_{E1}(0)=C_{E2}(0)=1$ then $C(0,0)=\gamma(\epsilon_{E1}+\epsilon_{E2}+\epsilon_{E1E2})$ and unit variance can be enforced by $\gamma = 1/(\epsilon_{E1}+\epsilon_{E2}+\epsilon_{E1E2})$
* `mixed_representation_normalization`: NA
* `normalization_notes`: weights can be normalized and absorbed into $\gamma$ if desired

### 19.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: yes; notes: $f_{E1}$ and $f_{E2}$ are radial in their own frequency variables
* `two_input_radial_integration`: applicable: partial; blockwise yes/no: block 1 yes, block 2 yes; requires_separability no; notes: product term admits blockwise radial reductions; ridge terms reduce to one-block inversions via atoms.

### 19.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: exact Markov/SPDE structure holds for latent Matérn components when represented as sums of independent SPDE fields; observed sum is not generally Markov without augmentation.

### 19.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: state_augmentation
* `ordering_dimension_required`: yes (if one block is treated as ordered time; otherwise NA)
* `error_control`: Not Known

### 19.14 Reparameterizations

* `reparameterizations`:
  * normalized weights: $w_i=\epsilon_i/(\epsilon_{E1}+\epsilon_{E2}+\epsilon_{E1E2})$ for $i\in{S1,S2,S1S2}$ (when denominator nonzero) and $\tilde\gamma=\gamma(\epsilon_{E1}+\epsilon_{E2}+\epsilon_{E1E2})$.

### 19.15 Properties

* `symmetry`: symmetric
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: no (except separable limit)
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: $C(0,0)=\gamma(\epsilon_{E1}+\epsilon_{E2}+\epsilon_{E1E2})$ if $C_{E1}(0)=C_{E2}(0)=1$
* `mean_square_continuity`: yes for RF parameter ranges (Not Known exact condition set in this parameterization)
* `differentiability_order`: governed by blockwise Matérn-type exponents (Not Known exact mapping)
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: mixture-dependent; ridge terms imply non-decay in the other block
* `compact_support`: no
* `ridge_effect`: yes
* `stein_regularity`: Not Known
* Identifiability (case IDs from `CT_asymptotic_specs.md`):
  * `identifiability_by_case_pair`:
    * `case_pair`:
      * `block_1_case_id`: Not Known
      * `block_2_case_id`: Not Known
      * `marginal_block_1`: Not Known
      * `marginal_block_2`: Not Known
      * `coupling_parameters`: Not Known
      * `identifiable_parameter_combinations`: Not Known
      * `notes`: ridge weights may be weakly identifiable without replication across the other block; regime dependent.
    * `relative_rates`:
      * `relative_domain_growth`: Not Known
      * `relative_infill_rate`: Not Known
      * `notes`: Not Known
  * Legacy (kept for compatibility; prefer `identifiability_by_case_pair`):
  * `fixed_domain_asymptotics`: Not Known
  * `increasing_domain_asymptotics`: Not Known
  * `mixed_domain_asymptotics`: Not Known
  * `identifiable_parameter_combinations`: Not Known

### 19.16 Computational implications

* `dense_or_sparse_structure`: dense (covariance); structured sum of Kronecker terms in discretizations
* `kronecker_structure_available`: yes (sum of Kronecker products in gridded/discretized settings)
* `fft_suitability`: yes (per-term on grids)
* `nufft_suitability`: yes (per-term)
* `spde_solver_suitability`: yes (latent SPDE components; with augmentation)

### 19.17 Approximations

* `power_series`: yes (standard Matérn expansions)
* `asymptotic_expansions`: yes
* `special_function_representations`: Bessel-$K$ forms in one-block Matérn covariances
* `numerical_approximations`: SPDE/GMRF approximations; sum-of-Kronecker acceleration; low-rank approximations of ridge components

## 20. `Stein3-HUSMM`: Stein human-manifold-Euclidean Matérns kernel

### 20.1 Name

* `kernel_name`: Stein human-manifold-Euclidean Matérns kernel
* `call_notation`: `Stein3-HUSMM`
* `aliases`: `Stein3-HUSMM`, `Stein-HUxE`, `Stein-human-euclidean`
* `domain_product_symbol`: `HU1×E2`
* `parent_kernel`: `Stein2-SpSMM`
* `parent_kernel_constraints`: replace the sphere block by a human-manifold block with an admissible compact/non-Euclidean spectral representation or finite-basis mesh representation
* `references`: Stein2005; human-manifold adaptation in this catalog is modelled after the Stein mixed-spectrum construction and inherits the same construction logic where admissible
* `name_notes`: This entry is the human-manifold analogue of the sphere-Euclidean Stein kernel and is intended for `human_manifold × Euclidean` products.

### 20.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(human_manifold, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `HU1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: finite human-manifold mesh support in block 1; $d_{E2}\ge 1$ in block 2
* `admissible_metrics_block_1`: human-manifold geodesic metric or operator/basis-induced metric declared by geometry/representation
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: Euclidean chordal approximations on the human manifold unless explicitly declared as geometry-approved approximations

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no
  * `hilbert_space`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
  * `self_adjoint_psd`: no
* `supported_domain_blocks_and_admissibility_notes`: The human-manifold block is mesh-native. Admissibility is therefore tied to the declared human-manifold geometry and its associated finite-basis/eigen representation rather than a closed-form compact-manifold harmonic family.

### 20.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no
  * `physical_dependence_type_1`: distance-only
  * `radial_quantity_used_1`: `r_{HU1}`
  * `directional_requirements_notes_1`: depends on human-manifold geodesic distance or the equivalent mesh-basis/operator representation; no signed lags
* block 2:
  * `requires_h_2`: yes
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: `r_iso` or `r_aniso`
  * `directional_requirements_notes_2`: depends on Euclidean lag norm $\|h_{E2}\|$ or its anisotropic counterpart supplied by geometry
* `physical_space_dependence_notes`: This is a mixed non-Euclidean/Euclidean two-input kernel. The human-manifold block supplies only metric distances or operator-eigen coordinates.

### 20.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: measure
  * `spectral_dependence_type_1`: discrete / basis-indexed
  * `spectral_atoms_possible_1`: yes
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: Stein-style additive blockwise spectral terms with a shared outer power, but with the human-manifold block represented through an operator/basis spectrum rather than a sphere harmonic degree
* `spectral_space_dependence_notes`: The human-manifold block is interpreted through a finite or countable operator spectrum $\{\lambda_j,\phi_j\}$ supplied by the declared Level III representation.

### 20.5 Construction

* `construction_class`: rational_spectral
* `base_kernels`: human-manifold Matérn-type operator spectrum in `HU1`; Euclidean Matérn in `E2`
* `construction_formula`:

  Let $\{(\lambda_j,\phi_j)\}_{j\ge 0}$ denote the human-manifold operator/basis spectrum for block `HU1`, and let $\xi_{E2}\in\mathbb{R}^{d_{E2}}$ denote the Euclidean spectral variable.

  Define the joint spectral weights

  $$
  f_j(\xi_{E2})
  =
  \gamma
  \Big\{
  \epsilon_{HU1}(\kappa_{HU1}^{2}+\lambda_j)^{\alpha_{HU1}}
  +
  \epsilon_{E2}(\kappa_{E2}^{2}+\|\xi_{E2}\|^{2})^{\alpha_{E2}}
  +
  \epsilon_{HU1E2}(\kappa_{HU1E2}^{2}+\lambda_j\|\xi_{E2}\|^{2})^{\alpha_{HU1E2}}
  \Big\}^{-\nu}.
  $$

  The covariance kernel is then represented as

  $$
  C((u,t),(v,s))
  =
  \sum_{j\ge 0}\phi_j(u)\phi_j(v)
  (2\pi)^{-d_{E2}}
  \int_{\mathbb{R}^{d_{E2}}}
  e^{i\langle \xi_{E2},\, t-s\rangle}
  f_j(\xi_{E2})\,d\xi_{E2}.
  $$

* `construction_notes`: This is the `HU1×E2` analogue of the Stein mixed-spectrum model. The sphere harmonic degree $\ell$ in `Stein2-SpSMM` is replaced by the human-manifold operator/basis eigenvalue index $j$ and corresponding eigenvalue $\lambda_j$.

### 20.6 Parameters

* `parameter_list`: $\gamma$, $\epsilon_{HU1}$, $\epsilon_{E2}$, $\epsilon_{HU1E2}$, $\kappa_{HU1}$, $\kappa_{E2}$, $\kappa_{HU1E2}$, $\alpha_{HU1}$, $\alpha_{E2}$, $\alpha_{HU1E2}$, $\nu$
* `parameter_meanings`:
  * $\gamma$: overall scale
  * $\epsilon_{HU1}$, $\epsilon_{E2}$, $\epsilon_{HU1E2}$: weights on human-manifold, Euclidean, and coupled spectral contributions
  * $\kappa_{(\cdot)}$: inverse range / regularization parameters
  * $\alpha_{(\cdot)}$: blockwise or coupled spectral exponents
  * $\nu$: shared outer tail exponent
* `parameter_constraints`: $\gamma>0$; $\epsilon_{HU1},\epsilon_{E2},\epsilon_{HU1E2}\ge 0$ (not all zero); $\kappa_{(\cdot)}>0$; $\alpha_{(\cdot)}>0$; $\nu>0$
* `PSD_guarantee_mechanism`: by_construction when the human-manifold spectrum and Euclidean spectral factors are admissible
* `parameters_notes`: Any implementation must tie the human-manifold spectral branch to a declared operator/basis representation and truncation rule when finite realization is used.

### 20.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: Not Known in full generality; depends on the lowest human-manifold eigenvalues and Euclidean origin behavior
* `spectral_divergence_at_infinity`: controlled by $\nu$ and the exponents $\alpha_{HU1},\alpha_{E2},\alpha_{HU1E2}$
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: A GRF analogue may exist for singular low-mode or high-frequency parameter settings, but this entry is the RF version.

### 20.8 Representations

* `primary_representation_id`: RF-MIXED-01
* `primary_representation_call_symbol`: `f_j`
* `supported_representation_ids`: RF-MIXED-01, RF-COV-01, OP-COV-01

* `primary_representation_summary`:
  * `representation_status`: exact up to the declared human-manifold operator/basis representation; finite realizations are truncation-based
  * `representation_formula_or_operator`: mixed human-manifold spectral expansion plus Euclidean Fourier inversion as given in Section 20.5
  * `normalization_notes`: $\gamma$ is the primary mixed spectral scale
  * `approximation_routes`: truncate the human-manifold basis; radial FFT/Hankel or NUFFT in the Euclidean block; finite-basis-to-covariance route on the human-manifold block
  * `special_function_routes`: Euclidean Matérn special-function inversion inside each human-manifold basis mode when available
  * `representation_notes`: This is the natural default representation because the human manifold is mesh-native and already represented operationally through finite operator spectra

* `secondary_representation_details`:
  * `representation_id`: RF-COV-01
    `representation_call_symbol`: `C`
    `representation_status`: induced
    `representation_formula_or_operator`: covariance kernel induced by the mixed representation in Section 20.5
    `normalization_notes`: inherits from the primary mixed representation
    `approximation_routes`: truncate the human-manifold basis and numerically invert the Euclidean branch
    `special_function_routes`: per-mode Euclidean Matérn inversions when closed form is available
    `representation_notes`: physical-space covariance is generally evaluated through the mixed/basis route
  * `representation_id`: OP-COV-01
    `representation_call_symbol`: `L^{-1}`
    `representation_status`: approximate
    `representation_formula_or_operator`: covariance-inducing operator on the human-manifold block coupled with Euclidean spectral filtering
    `normalization_notes`: representation-specific and tied to the chosen finite basis/operator truncation
    `approximation_routes`: mesh operator discretization plus Euclidean spectral quadrature
    `special_function_routes`: NA
    `representation_notes`: operational route for mesh-native implementations

### 20.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: set $h_{E2}=0$; yields a human-manifold kernel induced by the summed Euclidean-zero-frequency branch
* `marginal_kernel_block_2`: evaluate at coincident human-manifold locations or collapse onto the human-manifold low-mode sum; yields a Euclidean kernel with mode-summed spectral weights
* `marginal_consistency_conditions`: same as the Stein mixed-spectrum family; consistency depends on using the same admissible human-manifold basis/operator family in all marginal and joint evaluations
* `separable_limit`: $\epsilon_{HU1E2}=0$
* `marginal_reduction_limits`: finite-basis truncation limit recovers the operational implementation route
* `marginals_consistency_and_limits_notes`: Not Known in closed form; operationally defined through the chosen human-manifold representation

### 20.10 Normalization

* `primary_scale_parameter`: $\gamma$
* `normalization_regime`: RF
* `spectral_normalization`: variance_normalized when finite
* `derived_scale_relation`: Not Known in closed form; depends on the human-manifold basis normalization and Euclidean inversion constant
* `mixed_representation_normalization`: human-manifold eigenfunctions are assumed orthonormal under the declared representation
* `normalization_notes`: finite-basis implementations must keep the human-manifold basis normalization consistent with the Euclidean inversion normalization

### 20.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: partial; notes: Euclidean block radial within each human-manifold basis mode; human-manifold block is discrete/basis-indexed rather than radial
* `two_input_radial_integration`: applicable: partial; blockwise yes/no: block 1 no, block 2 yes; requires_separability no; notes: only the Euclidean block admits standard radial reduction
* `two_input_radial_integration_and_reductions_notes`: human-manifold reduction is by basis truncation, not by a one-dimensional radial transform

### 20.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: operator_derived
* `markov_property`: approximate
* `precision_sparse`: depends_on_discretization
* `precision_notes`: sparse precision structure may arise from the mesh/operator discretization of the human-manifold block, not from a closed-form covariance expression

### 20.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes
* `approximation_method`: state_augmentation
* `ordering_dimension_required`: yes (choose an ordering on the Euclidean block)
* `error_control`: basis truncation in `HU1` plus Euclidean state-space approximation if used
* `state_space_representability_notes`: Not Known in full generality

### 20.14 Reparameterizations

* `reparameterizations`: use log-parameters for positive scale/range/exponent terms; optional finite-basis truncation rank as a representation-side realization parameter rather than a kernel parameter
* `reparameterizations_notes`: truncation rank belongs to the representation/runtime layer, not to the kernel ontology

### 20.15 Properties

* `symmetry`: symmetric
* `stationarity_invariance`: metric-stationary on the human manifold under the declared geodesic/operator representation; stationary on the Euclidean block
* `isotropy_block_1`: isotropic only in the metric/operator sense supplied by the human-manifold representation
* `isotropy_block_2`: isotropic on the Euclidean block
* `separability`: no unless $\epsilon_{HU1E2}=0$
* `PSD_guarantee_mechanism`: by_construction under an admissible human-manifold spectral representation
* `pointwise_variance`: finite for RF-admissible parameter settings
* `mean_square_continuity`: yes for RF-admissible settings
* `differentiability_order`: controlled jointly by the human-manifold operator spectrum and the Euclidean Matérn branch; Not Known in a closed universal form
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: typically short-range in the Euclidean block; human-manifold decay depends on the operator spectrum and chosen basis
* `compact_support`: no
* `ridge_effect`: yes in the mixed-spectrum sense
* `stein_regularity`: Not Known

* `identifiability_by_case_pair`:
  * `case_pair`:
    * `block_1_case_id`: NA
    * `block_2_case_id`: FD_INFILL / ED_BALANCED / ED_RAPID / ED_DENSE depending on Euclidean design
    * `marginal_block_1`: weakly_identifiable
    * `marginal_block_2`: identifiable
    * `coupling_parameters`: weakly_identifiable
    * `identifiable_parameter_combinations`: basis-truncation-dependent combinations Not Known
    * `notes`: human-manifold identifiability depends on the chosen finite-basis/operator realization and mesh support
  * `relative_rates`:
    * `relative_domain_growth`: NA for the human-manifold block in the compact/static-mesh interpretation
    * `relative_infill_rate`: Not Known
    * `notes`: relative-rate statements are only meaningful on the Euclidean block or under a declared mesh-refinement regime for the human manifold
  * Legacy (kept for compatibility; prefer `identifiability_by_case_pair`):
  * `fixed_domain_asymptotics`: Not Known
  * `increasing_domain_asymptotics`: NA on the compact/static human manifold
  * `mixed_domain_asymptotics`: Not Known
  * `identifiable_parameter_combinations`: Not Known
* `properties_notes`: This entry is operationally meaningful because `human_manifold` already has Level III basis/operator realizations in the repo.

### 20.16 Computational implications

* `dense_or_sparse_structure`: dense covariance; sparse/operator-derived structure may exist on the human-manifold basis side
* `kronecker_structure_available`: no in general; partial block-structured acceleration may exist after human-manifold basis truncation
* `fft_suitability`: yes on the Euclidean block
* `nufft_suitability`: yes on the Euclidean block
* `spde_solver_suitability`: partial / operator-side only
* `computational_implications_notes`: practical implementations should use the mesh-basis/operator representation for `HU1` and dense/matvec/cached-matvec on the Euclidean side

### 20.17 Approximations

* `power_series`: Not Known (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `asymptotic_expansions`: Not Known (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `special_function_representations`: Euclidean Matérn special-function inversions within each human-manifold basis mode (representation_type: mixed; representation_id: RF-MIXED-01; approximate/exact-by-mode)
* `numerical_approximations`: human-manifold finite-basis truncation; per-mode Euclidean FFT/Hankel/NUFFT inversion; operator-derived sparse approximations on the human-manifold block (representation_type: mixed; representation_id: RF-MIXED-01; approximate)
* `approximation_representation_id`: RF-MIXED-01
* `approximations_notes`: finite-basis truncation is the expected operational route for this kernel family in the current repo
---

## 21. `SepProd-SSGG`: separable product Euclidean-Euclidean Gaussians (RBF) kernel

### 21.1 Name

* `kernel_name`: separable product Euclidean-Euclidean Gaussians (RBF / squared-exponential) kernel
* `call_notation`: `SepProd-SSGG`
* `aliases`: `rbf_sep_prod`, `separable_rbf_rbf`, `separable_squared_exponential`, `SepProd-SSGG`
* `parent_kernel`: `SepProd-SSMM` (§11)
* `parent_kernel_constraints`: `nu_1 -> infinity`, `nu_2 -> infinity` (infinite-smoothness limit of the separable Matérn product)
* `references`: Rasmussen & Williams (2006), *Gaussian Processes for Machine Learning*, §4.2; Stein (1999), *Interpolation of Spatial Data*, §2.7.
* `name_notes`: registered separately from `SepProd-SSMM` so users can select infinite-smoothness separable covariance explicitly without sending `nu_k` to a very large number.

### 21.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1`
* `block_alias_2`: `E2`
* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$, $d_{E2}\ge 1$
* `admissible_metrics_block_1`: Euclidean / anisotropic Euclidean
* `admissible_metrics_block_2`: Euclidean / anisotropic Euclidean
* `forbidden_metric_pairs`: NA

* `supported_target_spaces`:
  * `real_scalar`: yes
  * `real_vector`: no
  * `complex_scalar`: no
  * `complex_vector`: no

* `symmetry_requirement`:
  * `symmetric`: yes
  * `Hermitian`: yes
* `supported_domain_blocks_and_admissibility_notes`: identical compatibility to `SepProd-SSMM`.

### 21.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: yes (via norm)
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: $r_{\mathrm{iso}}$ or $r_{\mathrm{aniso}}$
  * `directional_requirements_notes_1`: radial Gaussian
* block 2:
  * `requires_h_2`: yes (via norm)
  * `physical_dependence_type_2`: radial
  * `radial_quantity_used_2`: $r_{\mathrm{iso}}$ or $r_{\mathrm{aniso}}$
  * `directional_requirements_notes_2`: radial Gaussian
* `physical_space_dependence_notes`: smooth ($C^\infty$) radial decay in each block.

### 21.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: radial
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: separable; notes: product form
* `spectral_space_dependence_notes`: the spectral density is itself Gaussian in each block (self-conjugate under Fourier).

### 21.5 Construction

* `construction_class`: separable_product
* `base_kernels`: Gaussian / squared-exponential (E1), Gaussian / squared-exponential (E2)
* `construction_formula` (covariance side):
  $$
  C(h_{E1}, h_{E2}) = \text{variance}\,\exp\!\left(-\tfrac{1}{2}\tfrac{\|h_{E1}\|^2}{\ell_1^2}\right)\,\exp\!\left(-\tfrac{1}{2}\tfrac{\|h_{E2}\|^2}{\ell_2^2}\right).
  $$
* `construction_formula` (spectral-density side, Fourier convention `phys_to_freq_exp(-i omega·x)`):
  $$
  f(\xi_{E1}, \xi_{E2}) = \text{variance}\,\prod_{k\in\{1,2\}} (2\pi)^{d_{Ek}/2}\,\ell_k^{d_{Ek}}\,\exp\!\left(-\tfrac{1}{2}\,\ell_k^2\,\|\xi_{Ek}\|^2\right).
  $$
* `construction_notes`: separable; obtained as the `nu_k -> infinity` limit of `SepProd-SSMM` with the standard Matérn parameterisation $\kappa_k = \sqrt{2\nu_k}/\ell_k$.

### 21.6 Parameters

* `parameter_list`: `variance`, `lengthscale_1`, `lengthscale_2`
* `parameter_meanings`:
  * `variance`: marginal variance $C(0,0)$
  * `lengthscale_1`: RBF length scale for block 1
  * `lengthscale_2`: RBF length scale for block 2
* `parameter_constraints`: `variance > 0`; `lengthscale_1, lengthscale_2 > 0`
* `PSD_guarantee_mechanism`: by_construction (positive product of positive univariate Gaussian correlations, each positive definite by Bochner)
* `parameters_notes`: no smoothness parameter — infinite-smoothness is implied by the family.

### 21.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: no (Gaussian density is bounded at $\xi=0$)
* `spectral_divergence_at_infinity`: no (Gaussian decay)
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: trace-class on any bounded domain; induces $C^\infty$ sample paths.

### 21.8 Representations

* `primary_representation_id`: RF-SPEC-01
* `supported_representation_ids`: RF-SPEC-01, RF-COV-01 (closed-form covariance descriptor is provided).

* `covariance_representation`: yes (closed form — product of two Gaussian correlations)
* `covariance_formula`: as in §21.5.
* `spectral_representation`: yes (closed form — product of two Gaussian spectral densities)
* `spectral_formula`: as in §21.5.
* `mixed_half_spectral`: no
* `mixed_half_spectral_formula`: NA
* `SPDE_operator_representation`: no (Gaussian kernel is the $\alpha=\infty$ limit of the Matérn SPDE; not a proper finite-order operator representation)
* `SPDE_operator_formula`: NA
* `representations_notes`: the closed-form covariance is available directly and is the preferred route at every M-tier that consumes `ClosedFormCovarianceDescriptor`.

### 21.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: Gaussian correlation $C_{E1}(h_{E1}) = \exp(-\|h_{E1}\|^2/(2\ell_1^2))$
* `marginal_kernel_block_2`: Gaussian correlation $C_{E2}(h_{E2}) = \exp(-\|h_{E2}\|^2/(2\ell_2^2))$
* `marginal_consistency_conditions`: NA
* `separable_limit`: already separable
* `marginal_reduction_limits`:
  * `lengthscale_k -> 0`: kernel degenerates to an isolated variance-only spike at $h_{Ek}=0$ (independent observations across block $k$).
  * `lengthscale_k -> infinity`: kernel becomes constant $\text{variance}$ across block $k$ (fully correlated).
* `marginals_consistency_and_limits_notes`: retrieving `SepProd-SSMM` from `SepProd-SSGG` is not possible — the Gaussian is the $\nu \to \infty$ endpoint, not a Matérn interior point.

### 21.10 Normalization

* `primary_scale_parameter`: `variance`
* `normalization_regime`: RF
* `spectral_normalization`: `variance`-normalized; the spectral density integrates (with the `phys_to_freq_exp(-i omega·x)` convention and the $(2\pi)^{-d}$ inverse factor) to `variance` at $h=0$.
* `derived_scale_relation`: NA
* `mixed_representation_normalization`: NA
* `normalization_notes`: choose `variance` to match the desired marginal variance directly.

### 21.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: yes (both blocks — radial Gaussian)
* `two_input_radial_integration`: applicable: yes; requires_separability yes; notes: blockwise radial reduction trivial (closed form)
* `two_input_radial_integration_and_reductions_notes`: the spectral density is radially Gaussian in each block.

### 21.12 Precision / Markov structure

* `has_precision_representation`: approximate (Gaussian kernel has no finite-order SPDE precision; low-rank + diagonal precision approximations exist)
* `precision_form`: NA
* `markov_property`: no (infinite-smoothness)
* `precision_sparse`: no
* `precision_notes`: unlike the Matérn separable kernel, the RBF has no finite-order Markov representation; practical large-scale fits should use M2B matrix-free or M4-\* low-rank approximations rather than M2V Vecchia.

### 21.13 State-space (Kalman) representability

* `exact_kalman`: no
* `approximate_kalman`: yes (via Gauss-Hermite / Taylor state-space approximations)
* `approximation_method`: finite-order state-space approximation of the $\nu\to\infty$ Matérn limit
* `ordering_dimension_required`: yes (if using state-space along one block)
* `error_control`: controlled by the state dimension
* `state_space_representability_notes`: exact state-space requires infinite state dimension; in practice use `SepProd-SSMM` with large finite `nu_k` (e.g., 10-50) when a state-space path is required.

### 21.14 Reparameterizations

* `reparameterizations`:
  * $\tau_k^2 = 1/\ell_k^2$ — inverse-length-scale, more convenient for prior specification.
  * Connection to `SepProd-SSMM`: setting $\kappa_k = \sqrt{2\nu_k}/\ell_k$ in the Matérn parameterisation and letting $\nu_k \to \infty$ recovers this kernel exactly.
* `reparameterizations_notes`: NA

### 21.15 Properties

* `symmetry`: symmetric (covariance)
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic (radial)
* `isotropy_block_2`: isotropic (radial)
* `separability`: yes
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: `variance` (finite)
* `mean_square_continuity`: yes
* `differentiability_order`: $C^\infty$ (infinitely differentiable sample paths; mean-square infinitely differentiable)
* `holder_fractal_class`: NA (smoother than any Hölder class)
* `short_or_long_range_dependence`: short-range (super-exponential decay)
* `compact_support`: no
* `ridge_effect`: no
* `stein_regularity`: infinite (smoother than any Matérn)

* `identifiability_by_case_pair`: $(\text{variance}, \ell_1, \ell_2)$ are jointly identifiable from the covariance on any fixed 2-block grid.
* `properties_notes`: the infinite smoothness makes the Gram matrix rapidly ill-conditioned for closely spaced points; a nugget is almost always required for stable Cholesky factorisation.

### 21.16 Computational implications

* `dense_or_sparse_structure`: dense
* `kronecker_structure_available`: yes (separable ⇒ Kronecker in block-product point layouts)
* `fft_suitability`: yes (M5-SKI and FFT-grid evaluators work on regular block-product grids)
* `nufft_suitability`: yes
* `spde_solver_suitability`: no (no finite-order SPDE)
* `computational_implications_notes`: the kernel's infinite smoothness produces very rapidly decaying eigenvalues; low-rank (M4-SGPR / M4-SVGP) approximations are typically extremely accurate with small inducing-point sets. Conversely the Gram matrix becomes numerically rank-deficient for tightly clustered points, so a nugget $\ge 10^{-6}$ is standard.

### 21.17 Approximations

* `power_series`: Taylor expansion of $\exp(-r^2/(2\ell^2))$ around $r=0$ (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: standard Laplace / saddle-point on the Gaussian tail (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: NA (elementary function)
* `numerical_approximations`:
  * low-rank inducing-point (Titsias / SVGP) — very high accuracy due to fast spectral decay (representation_type: covariance; representation_id: RF-COV-01; approximate)
  * finite-order state-space via `SepProd-SSMM` with large `nu_k` (representation_type: covariance; representation_id: RF-COV-01; approximate)
  * FFT-grid / KISS-GP on regular block-product grids (representation_type: covariance; representation_id: RF-COV-01; approximate)

---

* `approximations_notes`: the rapid eigenvalue decay makes most standard approximation schemes exceptionally effective for this kernel; choose based on data layout rather than accuracy concerns.

### 21.18 Notes

* `notes_notes`: registered in `kernels/registry.py` as `rbf_sep_prod`; NumPy implementation at `kernels/numpy_impl.py::SeparableRbfProductSpectralKernel`; JAX implementation at `kernels/jax_impl.py::SeparableRbfProductSpectralKernel`; unit tests at `tests/tests_continuous/test_rbf_sep_prod_kernel.py`.

## 22. `Hristopulos2024-LDHO`: Hristopulos 2024 linear damped harmonic-oscillator hybrid spectral space-time kernel

### 22.1 Name

* `kernel_name`: Hristopulos 2024 linear damped harmonic-oscillator hybrid spectral space-time covariance
* `call_notation`: `Hristopulos2024-LDHO`
* `aliases`: `hristopulos2024_ldho`, `LDHO-Hybrid`
* `domain_product_symbol`: `E1 x E2`
* `parent_kernel`: NA
* `parent_kernel_constraints`: underdamped LDHO regime
* `references`: Hristopulos, D. T. (2024), "Non-Separable Covariance Kernels for Spatiotemporal Gaussian Processes Based on a Hybrid Spectral Method and the Harmonic Oscillator", IEEE Transactions on Information Theory 70(2), 1268-1283, doi:10.1109/TIT.2023.3321215; arXiv:2302.09580
* `name_notes`: first-class RF77 object for the LDHO / hybrid-spectral provenance; runtime id `hristopulos2024_ldho`.

### 22.2 Supported domain blocks and admissibility

* `supported_manifold_pairs`: `(Euclidean, Euclidean)`
* `block_order`: `(M_1, M_2)`
* `block_alias_1`: `E1` (space)
* `block_alias_2`: `E2` (time)
* `intrinsic_dimension_constraints`: $d_{E1}\ge 1$; $d_{E2}=1$ recommended for physical time, though the RF77 radial lag evaluator accepts a Euclidean block-2 radial lag
* `admissible_metrics_block_1`: Euclidean radial distance
* `admissible_metrics_block_2`: Euclidean time lag magnitude
* `forbidden_metric_pairs`: non-Euclidean time metrics without a Euclidean lag interpretation
* `supported_target_spaces`: `real_scalar`: yes; `real_vector`: no; `complex_scalar`: no; `complex_vector`: no; `hilbert_space`: no
* `symmetry_requirement`: `symmetric`: yes; `Hermitian`: no; `self_adjoint_psd`: yes
* `supported_domain_blocks_and_admissibility_notes`: PSD is inherited from the LDHO covariance construction.

### 22.3 Physical-space dependence (per block)

* block 1:
  * `requires_h_1`: no
  * `physical_dependence_type_1`: radial
  * `radial_quantity_used_1`: `r_iso`
  * `directional_requirements_notes_1`: dispersion enters through the spatial radial lag in the registered runtime.
* block 2:
  * `requires_h_2`: no
  * `physical_dependence_type_2`: radial / absolute time lag
  * `radial_quantity_used_2`: `r_iso`
  * `directional_requirements_notes_2`: temporal covariance is even in the lag.
* `physical_space_dependence_notes`: The covariance includes a Gaussian zero-time spatial marginal, damped temporal oscillation, and dispersion-driven space-time interaction.

### 22.4 Spectral-space dependence (per block)

* block 1:
  * `spectral_object_type_1`: density
  * `spectral_dependence_type_1`: radial
  * `spectral_atoms_possible_1`: no
* block 2:
  * `spectral_object_type_2`: density
  * `spectral_dependence_type_2`: vector / scalar frequency
  * `spectral_atoms_possible_2`: no
* `joint_spectral_coupling`: coupled; notes: hybrid spectral construction couples spatial frequency with oscillator coefficients through dispersion.
* `spectral_space_dependence_notes`: RF77 registers spectral and mixed/hybrid representation metadata but currently executes the closed-form covariance route.

### 22.5 Construction

* `construction_class`: rational_spectral / other
* `base_kernels`: stochastic linear damped harmonic oscillator; spatial dispersion modulation
* `construction_formula`: RF77 closed-form runtime implements the underdamped radial LDHO covariance
  $C(r,\tau)=c_0 e^{-|\tau|/(2\tau_c)}[F_1(r,\tau)+F_2(r,\tau)]$,
  where $F_1,F_2$ are assembled from the real/imaginary radial Fourier factors generated by the hybrid spectral construction; the executable implementation is `Hristopulos2024LdhoCovarianceKernel._cov_underdamped`.
* `construction_notes`: This is a separate RF77 runtime kernel, not an alias of `harmonic_oscillator`; critical/overdamped regimes are tracked as future runtime extensions.

### 22.6 Parameters

* `parameter_list`: `c0`, `tau_c`, `omega_d`, `epsilon`, `b_dispersion`
* `parameter_meanings`: LDHO spectral/covariance scale; characteristic relaxation time; damped cyclic frequency; spectral variance-stabilization scale; space-time dispersion strength
* `parameter_constraints`: `c0>0`; `tau_c>0`; `omega_d>0`; `epsilon>0`; `b_dispersion>=0`
* `PSD_guarantee_mechanism`: by_construction
* `parameters_notes`: `b_dispersion=0` removes dispersion-induced space-time interaction.

### 22.7 RF / GRF

* `RF_or_GRF`: RF
* `spectral_divergence_at_zero`: finite under registered positive parameter constraints
* `spectral_divergence_at_infinity`: controlled by spectral/hybrid LDHO dispersion and damping
* `GRF_correction_methodology`: NA
* `rf_grf_notes`: covariance route is pointwise finite at zero lag.

### 22.8 Representations

* `primary_representation_id`: RF-COV-01
* `primary_representation_call_symbol`: `C`
* `supported_representation_ids`: RF-COV-01, RF-SPEC-01, RF-MIXED-01
* `primary_representation_summary`:
  * `representation_status`: exact for the registered underdamped covariance parameterisation
  * `representation_formula_or_operator`: Section 22.5 covariance formula
  * `normalization_notes`: `c0` is the LDHO scale; for spatial dimension `d`, zero-lag covariance is `c0 / (4*pi*epsilon)^(d/2)`.
  * `approximation_routes`: dense covariance, matrix-free pointwise covariance, Vecchia / inducing approximations downstream
  * `special_function_routes`: Not Known for the registered reduced form
  * `representation_notes`: primary RF77 runtime is covariance-side.
* `secondary_representation_details`:
  * `representation_id`: RF-SPEC-01
    `representation_call_symbol`: `f`
    `representation_status`: theoretical / provenance
    `representation_formula_or_operator`: hybrid spectral LDHO density from the cited paper; executable spectral evaluator Not Implemented in RF77 runtime
    `normalization_notes`: must match the covariance scale under inverse transform
    `approximation_routes`: numerical spectral inversion and radial Fourier/Hankel routes
    `special_function_routes`: regime-dependent expressions in the cited paper
    `representation_notes`: tracked for routing and documentation.
  * `representation_id`: RF-MIXED-01
    `representation_call_symbol`: `f_mix`
    `representation_status`: theoretical / provenance
    `representation_formula_or_operator`: spatial spectral / temporal covariance hybrid representation generated by the LDHO construction
    `normalization_notes`: inherits covariance normalization
    `approximation_routes`: partial inversion in one block
    `special_function_routes`: Not Known
    `representation_notes`: useful for future half-spectral implementations.

### 22.9 Marginals, consistency, and limits

* `marginal_kernel_block_1`: at zero time lag, Gaussian spatial covariance with scale controlled by `epsilon`
* `marginal_kernel_block_2`: at zero spatial lag, damped oscillatory temporal covariance
* `marginal_consistency_conditions`: positive parameters and finite dispersion
* `separable_limit`: `b_dispersion=0` removes dispersion-induced space-time interaction
* `marginal_reduction_limits`: as temporal damping/frequency limits vary, the covariance approaches monotone or near-periodic temporal regimes
* `marginals_consistency_and_limits_notes`: regime-specific exact formulas from the paper are not yet separate RF77 runtime ids.

### 22.10 Normalization

* `primary_scale_parameter`: `c0`
* `normalization_regime`: RF
* `spectral_normalization`: induced by covariance normalization
* `derived_scale_relation`: `C(0,0)=c0 / (4*pi*epsilon)^(d/2)`
* `mixed_representation_normalization`: must preserve the covariance scale after partial inversion
* `normalization_notes`: RF77 tests enforce finite diagonal values and NumPy/JAX parity.

### 22.11 Two-input radial integration and reductions

* `blockwise_radial_spectral_reduction`: applicable: yes for spatially radial hybrid spectral forms
* `two_input_radial_integration`: applicable: partial; requires_separability no; notes: hybrid LDHO derivation uses radial spectral transforms
* `two_input_radial_integration_and_reductions_notes`: runtime covariance route bypasses explicit quadrature.

### 22.12 Precision / Markov structure

* `has_precision_representation`: approximate
* `precision_form`: state-space / oscillator-derived in time; spatial discretization dependent
* `markov_property`: approximate after discretization
* `precision_sparse`: depends_on_discretization
* `precision_notes`: future exact state-space forms should be registered separately if exposed.

### 22.13 State-space (Kalman) representability

* `exact_kalman`: yes for temporal LDHO component under fixed spatial frequency / dispersion mode
* `approximate_kalman`: yes for spatially discretized or low-rank expansions
* `approximation_method`: spectral-mode state-space or basis expansion
* `ordering_dimension_required`: yes (time)
* `error_control`: basis/spectral truncation dependent
* `state_space_representability_notes`: downstream Kalman exposure is not yet a separate RF77 tier.

### 22.14 Reparameterizations

* `reparameterizations`: physical LDHO parameters can be mapped to damping time, damped frequency, and dispersion coefficients.
* `reparameterizations_notes`: positive-parameter transforms can be added at the optimizer layer; the kernel object itself validates constrained values.

### 22.15 Properties

* `symmetry`: symmetric covariance
* `stationarity_invariance`: stationary on both blocks
* `isotropy_block_1`: isotropic
* `isotropy_block_2`: isotropic / even time lag
* `separability`: nonseparable when `b_dispersion>0`
* `PSD_guarantee_mechanism`: by_construction
* `pointwise_variance`: finite
* `mean_square_continuity`: yes under positive parameters
* `differentiability_order`: controlled by damping and spatial decay; Not Known exactly
* `holder_fractal_class`: Not Known
* `short_or_long_range_dependence`: short-range in registered covariance route
* `compact_support`: no
* `ridge_effect`: possible via dispersion relation
* `stein_regularity`: Not Known
* `identifiability_by_case_pair`: Not Known
* `properties_notes`: permits oscillatory temporal correlations with spatially varying damped frequency.

### 22.16 Computational implications

* `dense_or_sparse_structure`: dense covariance
* `kronecker_structure_available`: no when `b_dispersion>0`
* `fft_suitability`: yes for regular product grids after spectral implementation; covariance route supports matrix-free pointwise evaluation
* `nufft_suitability`: yes in principle for spectral/hybrid routes
* `spde_solver_suitability`: approximate
* `computational_implications_notes`: registered downstream through `kernels/registry.py`, the spectral adapter pointwise path, and covariance / prediction code paths that consume closed-form covariance descriptors.

### 22.17 Approximations

* `power_series`: Not Known (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `asymptotic_expansions`: LDHO regime-specific asymptotics in the cited paper (representation_type: covariance; representation_id: RF-COV-01; approximate)
* `special_function_representations`: regime-specific expressions from Hristopulos 2024 (representation_type: covariance/spectral; representation_id: RF-COV-01/RF-SPEC-01; exact or approximate by regime)
* `numerical_approximations`: dense covariance, Vecchia, inducing-point, basis / spectral-mode state-space approximations

---

* `approximations_notes`: RF77 currently executes the covariance descriptor; spectral and mixed routes are registered as supported provenance for future evaluators.

### 22.18 Notes

* `notes_notes`: registered in `kernels/registry.py` as `hristopulos2024_ldho`; NumPy runtime is `Hristopulos2024LdhoCovarianceKernel`; JAX runtime is `Hristopulos2024LdhoCovarianceKernel`; covered by `tests/tests_continuous/test_british_isles_parity_kernels.py`.
