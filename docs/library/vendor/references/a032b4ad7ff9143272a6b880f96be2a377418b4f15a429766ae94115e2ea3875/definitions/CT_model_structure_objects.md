# CT Model Structure Objects

---
*Status*: WORKING
*Version*: v2.2
*Date*: 2026-03-06
---

## File roles and authority

This file is a **non-normative object library**.
All objects below MUST conform to `CT_model_structure_specs.md`.

---

## 1. Family: HMMf5

## 1.0 ModelFamily: HMMf5

- `family_name`: Latent/Observable fixed mean with hyperparameters
- `family_id`: HMMf5
- `layer_schema`:
  - data (observation) layer
  - process (latent field) layer
  - parameter layer (\(\theta^{N}=\{\theta_{z},\theta_{y},\beta\}\))
  - microparameter layer (\(\theta^{M}\))
  - hyperparameter layer (\(\theta^{H}\), optional)
- `layer_type_schema`:
  - observation field layer
  - latent process layer
  - nuisance/mean parameter layer
  - kernel microparameter layer
  - hyperparameter layer
- `layer_structure_schema`:
  - observation layer = Level II observation structure bound to observational field object `Z`
  - process layer = Level II Gaussian random structure for latent field `Y`
  - parameter layer = decomposable into nuisance-parameter and mean-parameter structures
  - microparameter layer = kernel microparameter structure
  - hyperparameter layer = optional hyperparameter structure
- `layer_domain_schema`:
  - observation layer domain = product domain \(\mathcal{M}=S_1 \times S_2\)
  - latent process layer domain = product domain \(\mathcal{M}=S_1 \times S_2\)
  - parameter layer domain = parameter space
  - microparameter layer domain = parameter space
  - hyperparameter layer domain = parameter space
- `layer_target_space_schema`:
  - observation layer target space = scalar observational target
  - latent process layer target space = scalar latent target
  - parameter layer target space = finite-dimensional parameter target
  - microparameter layer target space = finite-dimensional microparameter target
  - hyperparameter layer target space = finite-dimensional hyperparameter target
- `latent_field_roles`:
  - observation field: `Z`
  - latent field: `Y`
  - mean component: \(v(\cdot;\beta)\) (deterministic; class fixed by subfamily)
- `allowed_representation_ids`:
  - RF-COV-01
  - RF-SPEC-01
  - OP-01
  - RF-MIXED-01
- `allowed_kernel_sources`:
  - `CT_one_input_kernel_objects.md`
  - `CT_two_input_kernel_objects.md`
  - `CT_multivariate_kernel_objects.md`

---

## 2. Subfamilies: Gaussian observation / Gaussian latent (HMMf5)

All HMMf5 subfamilies below share:
- \(\mathcal{M}=S_{1}\times S_{2}\) (Euclidean blocks)
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- observation operator: `PE`, map: `ID`

## 2.1 Zero mean (Gaussian/Gaussian)

### HMMf5-GGZ0 (no nugget)

- `subfamily_name`: Gaussian/Gaussian; zero mean; no nugget
- `subfamily_id`: HMMf5-GGZ0
- `parent_family_id`: HMMf5
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian, latent=Gaussian, nugget=absent
- `distribution_schema`: obs=Gaussian, latent=Gaussian
- `exact_layer_types`: Z=Gaussian observation field, Y=Gaussian latent field
- `exact_layer_structure_model`: observation layer = direct point-evaluation observation structure; latent layer = Gaussian random field; parameter layer = deterministic mean coefficients only
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: zero
- `mean_structure_class`: zero
- `covariate_policy`: disallowed
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### HMMf5-GGZN (with nugget)

- `subfamily_name`: Gaussian/Gaussian; zero mean; nugget
- `subfamily_id`: HMMf5-GGZN
- `parent_family_id`: HMMf5
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian, latent=Gaussian, nugget=present (i.i.d. variance \(\tau^2\))
- `distribution_schema`: obs=Gaussian, latent=Gaussian
- `exact_layer_types`: Z=Gaussian observation field with nugget, Y=Gaussian latent field
- `exact_layer_structure_model`: observation layer = Gaussian observation field with additive nugget; latent layer = Gaussian random field; parameter layer = deterministic mean coefficients plus nuisance variance
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: zero
- `mean_structure_class`: zero
- `covariate_policy`: disallowed
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

## 2.2 Linear mean (Gaussian/Gaussian)

### HMMf5-GGL0 (no nugget)

- `subfamily_name`: Gaussian/Gaussian; linear mean; no nugget
- `subfamily_id`: HMMf5-GGL0
- `parent_family_id`: HMMf5
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian, latent=Gaussian, nugget=absent
- `distribution_schema`: obs=Gaussian, latent=Gaussian
- `exact_layer_types`: Z=Gaussian observation field, Y=Gaussian latent field
- `exact_layer_structure_model`: observation layer = direct point-evaluation observation structure; latent layer = Gaussian random field; parameter layer = linear deterministic mean coefficients
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: linear_deterministic
- `mean_structure_class`: linear
- `covariate_policy`: optional
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### HMMf5-GGLN (with nugget)

- `subfamily_name`: Gaussian/Gaussian; linear mean; nugget
- `subfamily_id`: HMMf5-GGLN
- `parent_family_id`: HMMf5
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian, latent=Gaussian, nugget=present (i.i.d. variance \(\tau^2\))
- `distribution_schema`: obs=Gaussian, latent=Gaussian
- `exact_layer_types`: Z=Gaussian observation field with nugget, Y=Gaussian latent field
- `exact_layer_structure_model`: observation layer = Gaussian observation field with additive nugget; latent layer = Gaussian random field; parameter layer = linear deterministic mean coefficients plus nuisance variance
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: linear_deterministic
- `mean_structure_class`: linear
- `covariate_policy`: optional
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

## 2.3 Mixed mean (Gaussian/Gaussian)

### HMMf5-GGM0 (no nugget)

- `subfamily_name`: Gaussian/Gaussian; mixed mean; no nugget
- `subfamily_id`: HMMf5-GGM0
- `parent_family_id`: HMMf5
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian, latent=Gaussian, nugget=absent
- `distribution_schema`: obs=Gaussian, latent=Gaussian
- `exact_layer_types`: Z=Gaussian observation field, Y=Gaussian latent field
- `exact_layer_structure_model`: observation layer = direct point-evaluation observation structure; latent layer = Gaussian random field; parameter layer = mixed deterministic mean structure
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: mixed_deterministic
- `mean_structure_class`: mixed
- `covariate_policy`: optional
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### HMMf5-GGMN (with nugget)

- `subfamily_name`: Gaussian/Gaussian; mixed mean; nugget
- `subfamily_id`: HMMf5-GGMN
- `parent_family_id`: HMMf5
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian, latent=Gaussian, nugget=present (i.i.d. variance \(\tau^2\))
- `distribution_schema`: obs=Gaussian, latent=Gaussian
- `exact_layer_types`: Z=Gaussian observation field with nugget, Y=Gaussian latent field
- `exact_layer_structure_model`: observation layer = Gaussian observation field with additive nugget; latent layer = Gaussian random field; parameter layer = mixed deterministic mean structure plus nuisance variance
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: mixed_deterministic
- `mean_structure_class`: mixed
- `covariate_policy`: optional
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

---

## 3. Models (HMMf5): kernels bound downstream

### HMMf5-GGZN-Base0

- `object_name`: Model
- `model_name`: Gaussian/Gaussian (zero mean, nugget); kernel bound downstream
- `model_id`: HMMf5-GGZN-Base0
- `parent_subfamily_id`: HMMf5-GGZN
- `kernel_binding_schema`:
  - binding kind = single kernel slot
  - kernel slot = `Y`
  - kernel slot note = Y governs the latent field on \(\mathcal{M}\); resolved downstream given instantiated domain
- `working_representation_schema`:
  - allowed downstream routes = covariance or precision
  - working representation is the implementation-side realization used for inference/prediction/simulation
  - exact representation object remains to be chosen when the model is fully instantiated
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

---

## 4. Family: HMRm06 (random mean hierarchy)

## 4.0 ModelFamily: HMRm06

- `family_name`: Hierarchical Model with Random Mean
- `family_id`: HMRm06
- `layer_schema`:
  - data (observation) layer
  - process (primary latent field) layer
  - residual-mean process layer
  - parameter layer
  - microparameter layer
  - hyperparameter layer (optional)
- `layer_type_schema`:
  - observation field layer
  - primary latent process layer
  - residual mean process layer
  - nuisance/mean parameter layer
  - kernel microparameter layer
  - hyperparameter layer
- `layer_structure_schema`:
  - observation layer = Level II observation structure bound to `Z`
  - primary latent layer = Level II Gaussian random structure for `Y`
  - residual mean layer = Level II Gaussian random structure for `eta`
  - parameter layer = decomposable into fixed-effects and nuisance-parameter structures
  - microparameter layer = kernel microparameter structure
  - hyperparameter layer = optional hyperparameter structure
- `layer_domain_schema`:
  - observation, primary latent, and residual mean layers domain = product domain \(\mathcal{M}=S_1 \times S_2\)
  - remaining layers domain = parameter space
- `layer_target_space_schema`:
  - observation layer target space = scalar observational target
  - primary latent layer target space = scalar latent target
  - residual mean layer target space = scalar mean-correction target
  - remaining layers target space = finite-dimensional parameter targets
- `latent_field_roles`:
  - observation field: Z
  - primary latent field: Y
  - mean process: v
  - residual mean process: eta
  - fixed effects: beta
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01
- `allowed_kernel_sources`:
  - `CT_one_input_kernel_objects.md`
  - `CT_two_input_kernel_objects.md`
  - `CT_multivariate_kernel_objects.md`

### HMRm06-GrLN (random mean; Gaussian obs nugget; Gaussian Y; Gaussian eta)

- `subfamily_name`: Gaussian obs (nugget) + Gaussian Y + random mean v=Xβ+eta (eta Gaussian)
- `subfamily_id`: HMRm06-GrLN
- `parent_family_id`: HMRm06
- `domain_regime`: Euclidean product domain \(\mathcal{M}=S_{1}\times S_{2}\)
- `domain_blocks`: [S1, S2]
- `domain_block_kinds`: S1=Euclidean, S2=Euclidean
- `second_order_regime`: block-stationary on \(\mathcal{M}\)
- `fixed_layer_constraints`: obs=Gaussian (nugget present), Y=Gaussian, eta=Gaussian
- `distribution_schema`: obs=Gaussian, Y=Gaussian, eta=Gaussian
- `exact_layer_types`: Z=Gaussian observation field with nugget, Y=Gaussian latent field, eta=Gaussian residual mean field
- `exact_layer_structure_model`: observation layer = Gaussian observation field with nugget; primary latent layer = Gaussian random field; residual mean layer = Gaussian random field added into the mean structure
- `latent_structure_type`: Z=scalar Gaussian observation process, Y=Gaussian random field, eta=Gaussian random mean field
- `operator_structure_model`: direct point-evaluation observation operator with identity latent-support map
- `mean_methodology`: linear_random_mean
- `mean_structure_class`: linear_random_mean
- `covariate_policy`: optional
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### HMRm06-GrLN-Base0

- `object_name`: Model
- `model_name`: Random mean structural model; kernels for Y and eta bound downstream
- `model_id`: HMRm06-GrLN-Base0
- `parent_subfamily_id`: HMRm06-GrLN
- `kernel_binding_schema`:
  - binding kind = multi-slot kernel binding
  - kernel slots = [Y, eta]
  - kernel slot notes = Y governs primary latent field; eta governs residual mean process
- `working_representation_schema`:
  - allowed downstream routes = covariance or precision
  - working representation is the implementation-side realization used for downstream workflows
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

---

## 5. Family: DGP3 (three-layer deep GP)

## 5.0 ModelFamily: DGP3

- `family_name`: Deep Gaussian process surrogate (three-layer)
- `family_id`: DGP3
- `layer_schema`:
  - latent GP layer 1: Y|W
  - latent GP layer 2: W|Z
  - latent GP layer 3: Z|X
  - parameter layer
  - microparameter layer
  - hyperparameter layer (optional)
- `layer_type_schema`:
  - latent conditional layer Y|W
  - latent conditional layer W|Z
  - latent conditional layer Z|X
  - nuisance parameter layer
  - kernel microparameter layer
  - hyperparameter layer
- `layer_structure_schema`:
  - each latent conditional layer = Level II Gaussian random structure conditioned on the previous layer
  - nuisance parameter layer = decomposable parameter structure
  - microparameter layer = kernel microparameter structure
  - hyperparameter layer = optional hyperparameter structure
- `layer_domain_schema`:
  - conditional layers domain = Euclidean input spaces declared by [X, Z, W]
  - remaining layers domain = parameter space
- `layer_target_space_schema`:
  - each latent conditional layer target space = scalar latent target
  - remaining layers target space = finite-dimensional parameter targets
- `latent_field_roles`: Y, W, Z, X
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01
- `allowed_kernel_sources`:
  - `CT_one_input_kernel_objects.md`
  - `CT_two_input_kernel_objects.md`

### DGP3-Gau0

- `subfamily_name`: Three-layer DGP; Gaussian layers; isotropic; no nugget
- `subfamily_id`: DGP3-Gau0
- `parent_family_id`: DGP3
- `domain_regime`: Euclidean input X with latent Euclidean layers Z,W
- `domain_blocks`: [X, Z, W]
- `domain_block_kinds`: X=Euclidean, Z=Euclidean, W=Euclidean
- `second_order_regime`: stationary/isotropic kernels in each layer input space
- `fixed_layer_constraints`: nugget absent; node-wise conditional independence in Z and W
- `distribution_schema`: all latent conditional layers Gaussian
- `exact_layer_types`: Y|W Gaussian layer, W|Z Gaussian layer, Z|X Gaussian layer
- `exact_layer_structure_model`: three chained Gaussian conditional random-field layers with fixed conditional ordering
- `latent_structure_type`: Y, W, Z are Gaussian random structures on their declared supports
- `operator_structure_model`: identity-style inter-layer conditioning operators between consecutive latent layers
- `mean_methodology`: zero
- `mean_structure_class`: zero
- `covariate_policy`: disallowed
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### DGP3-Gau0-Base0

- `object_name`: Model
- `model_name`: DGP3 structural model; kernels bound downstream
- `model_id`: DGP3-Gau0-Base0
- `parent_subfamily_id`: DGP3-Gau0
- `kernel_binding_schema`:
  - binding kind = multi-slot kernel binding
  - kernel slots = [Y|W, W|Z, Z|X]
  - kernel slot notes = kernels correspond to the three conditional layers
- `working_representation_schema`:
  - allowed downstream routes = covariance or precision
  - working representation is the implementation-side realization used for downstream workflows
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

---

## 6. Family: DGPC (deep compositional, deterministic warping)

## 6.0 ModelFamily: DGPC

- `family_name`: Deep compositional Gaussian process via injective input warping
- `family_id`: DGPC
- `source`: Zammit-Mangion, Ng, Vu, Filippone 2022, JASA, "Deep Compositional Spatial Models"; reference implementation [andrewzm/deepspat](https://github.com/andrewzm/deepspat)
- `layer_schema`:
  - latent stationary GP layer: Y|W
  - bijective warping layers: W = f_θ(X) with f_θ = g_L ∘ ⋯ ∘ g_1
  - parameter layer (warp-layer parameters + base-kernel parameters)
  - microparameter layer (base-kernel microparameters)
  - hyperparameter layer (optional; layer-wise priors on warp params)
- `layer_type_schema`:
  - latent conditional layer Y|W (stationary GP)
  - deterministic bijective warping layers g_1, …, g_L (NOT stochastic conditional layers)
  - nuisance parameter layer
  - kernel microparameter layer
  - hyperparameter layer
- `layer_structure_schema`:
  - latent conditional layer Y|W = Level II Gaussian random structure on warped input W
  - each warping layer g_ℓ = deterministic injective map between Euclidean input spaces, parameterized by θ_ℓ
  - parameter / microparameter / hyperparameter layers as in DGP3
- `layer_domain_schema`:
  - conditional layer domain = warped Euclidean image space W
  - warping layers domain = Euclidean input spaces declared by [X, X^(1), …, X^(L−1) = W]
  - remaining layers domain = parameter space
- `layer_target_space_schema`:
  - latent conditional layer target space = scalar latent target
  - warping layers target space = Euclidean (same dimension as input)
  - remaining layers target space = finite-dimensional parameter targets
- `latent_field_roles`: Y, W (warped image of X)
- `warping_layer_registry`:
  - axial sigmoid warp
  - radial basis function bump
  - Möbius / AWU (axial warping unit)
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01
- `allowed_kernel_sources`:
  - `CT_one_input_kernel_objects.md` (base stationary kernel on W)
  - `CT_two_input_kernel_objects.md` (when the composed `k(x, y) = k_stat(f_θ(x), f_θ(y))` is registered as a two-input kernel entry)

### DGPC-Warp0

- `subfamily_name`: Single-output deep compositional GP; stationary Matérn base; deterministic warping chain
- `subfamily_id`: DGPC-Warp0
- `parent_family_id`: DGPC
- `domain_regime`: Euclidean input X with warped Euclidean image W = f_θ(X)
- `domain_blocks`: [X]
- `domain_block_kinds`: X=Euclidean
- `second_order_regime`: stationary base kernel on W; induced **nonstationary** kernel on X
- `fixed_layer_constraints`: each warping layer injective by construction (sigmoid / radial / Möbius all admit invertible parameterizations)
- `distribution_schema`: Y|W Gaussian; warping layers deterministic
- `exact_layer_types`: Y|W Gaussian layer; g_1, …, g_L deterministic bijective layers
- `exact_layer_structure_model`: stationary GP composed with a finite chain of deterministic injective maps; reduces to a single nonstationary two-input kernel evaluator
- `latent_structure_type`: Y is a Gaussian random structure on W; W is a deterministic function of X
- `operator_structure_model`: deterministic bijective composition operator between layers (no stochastic conditioning operators, in contrast to DGP3)
- `mean_methodology`: zero (default) or linear in X
- `mean_structure_class`: zero or deterministic
- `covariate_policy`: disallowed in the base subfamily
- `observation_operator_class`: PE
- `observation_to_latent_map_kind`: ID
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### DGPC-Warp0-Base0

- `object_name`: Model
- `model_name`: DGPC structural model; warping chain and base stationary kernel bound downstream
- `model_id`: DGPC-Warp0-Base0
- `parent_subfamily_id`: DGPC-Warp0
- `kernel_binding_schema`:
  - binding kind = single-slot composed kernel binding
  - kernel slots = [Y|W]
  - kernel slot notes = bound to a stationary base kernel on W; warping chain is bound separately via the warping_layer_registry
- `working_representation_schema`:
  - allowed downstream routes = covariance (M-tier) only
  - working representation is the implementation-side realization used for downstream workflows
- `allowed_representation_ids`: RF-COV-01, RF-SPEC-01, OP-01, RF-MIXED-01

### DGPC-WarpMulti0 (multi-output, gap-blocked)

- `subfamily_name`: Multi-output deep compositional GP; shared warping chain with LCM/ICM-style cross-covariance
- `subfamily_id`: DGPC-WarpMulti0
- `parent_family_id`: DGPC
- `status`: **deferred** — depends on G2 (multi-output GP) landing first; tracked in [CT_multi_output_gp_scoping.md](../practical/CT_multi_output_gp_scoping.md)
- `notes`: corresponds to `DeepCompMultiModel` in [andrewzm/deepspat](https://github.com/andrewzm/deepspat); same shared-warp construction over multiple correlated outputs.
