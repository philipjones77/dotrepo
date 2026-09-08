# Parameter Grouping Objects — Continuous Track

---
*Status*: WORKING
*Version*: v2.1
*Date*: 2026-03-16

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `theory_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_parameter_group_specs.md`
* `CT_model_structure_specs.md`
* `CT_representation_specs.md`
* `CT_kernel_specs.md`

**Is Relied Upon By:**

* `CT_inference_common_objects.md`
* `CT_prediction_common_objects.md`
* `CT_inference_run_plan_objects.md`

Notes:

* This file provides concrete runtime grouping bundles that instantiate `CT_parameter_group_specs.md`.
* IDs are illustrative unless they coincide with canonical IDs defined elsewhere.
* The first concrete entry is deliberately a covariance-representation kernel grouping, because that is the most common route for likelihood-based inference and kriging.

---

## 0. Preamble

### 0.0 Summary of Contents

1. A reusable bundle template.
2. Covariance-representation Matérn grouping for one latent layer.
3. Mean + $\sigma^2$ + $\tau^2$ handling for a linear-mean nugget model.
4. Multi-layer grouping with shared and layer-specific parameters.
5. Identifiable-only combination example.

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

These objects show how Level V grouping bundles can be assembled for common CT workflows.

### 0.3 How to read this file

Start with Section 1 (template), then read Section 2 for the simplest covariance-based kernel grouping, Section 3 for mean/variance/nugget treatment, Section 4 for more than one latent layer, and Section 5 for an identifiable-only combination pattern.

### 0.4 Summary of Assumptions and Preconditions

* The model and representation IDs used here are consistent with the narrative of the CT specs.
* Parameter IDs are runtime IDs; a concrete implementation may namespace them differently.

### 0.5 Notation, Inputs and Aliases

* `Y` denotes a primary latent layer.
* `ETA` denotes a random-mean residual layer when present.
* Primitive parameter IDs use plain-text names such as `sigma2_Y`, `kappa_Y`, `nu_Y`, `tau2_Z`, `beta0`.

### 0.6 Validation and Authority Rules

* These objects instantiate the schema but do not introduce new semantics.
* Every active primitive parameter appears in at least one active collection.

---

## 1. Template bundle

```yaml
grouping_config_id: PG:TEMPLATE-01
model_id: <MODEL_ID>
representation_ids: [<REPRESENTATION_ID>]
observation_object_ids: [<OBS_OBJECT_ID>]
parameter_slots:
  - param_id: <PARAM_ID>
    semantic_role: <ROLE>
    origin_kind: <ORIGIN_KIND>
    origin_object_id: <ORIGIN_OBJECT_ID>
    latent_layer_id: <LATENT_LAYER_ID>
    observation_object_id: <OBS_OBJECT_ID>
    representation_id: <REPRESENTATION_ID>
    default_status: variable
changeable_object_inventory:
  - object_id: kernel_microparameters
    object_category: kernel_parameter
    object_scope: runtime_variable
    param_ids: []
parameter_groups:
  - group_id: theta_M
    group_type: standard
    group_category: kernel
    group_scope_kind: latent_layer
    latent_layer_id: <LATENT_LAYER_ID>
    description: Kernel microparameters for one latent layer.
    parameter_collections:
      - collection_id: estimate
        param_ids: []
        role: estimate
        variation_status: variable
        estimation_status: estimable
        identified_status: individually_identified
        constraint_source_classes: [built_in_admissibility]
  - group_id: theta_W
    group_type: standard
    group_category: mean
    group_scope_kind: global
    description: Mean-structure parameters.
    parameter_collections:
      - collection_id: estimate
        param_ids: []
        role: estimate
        variation_status: variable
        estimation_status: conditionally_estimable
        identified_status: individually_identified
        constraint_source_classes: []
  - group_id: theta_NP
    group_type: standard
    group_category: noise
    group_scope_kind: observation_object
    observation_object_id: <OBS_OBJECT_ID>
    description: Nugget / observation parameters.
    parameter_collections:
      - collection_id: estimate
        param_ids: []
        role: estimate
        variation_status: variable
        estimation_status: estimable
        identified_status: individually_identified
        constraint_source_classes: [built_in_admissibility]
default_constraint_set_ids: []
identifiability_blocks: []
notes: Template only.
```

---

## 2. `PGCFG-COV-SM-ZN-01`: covariance-route Matérn kernel grouping (single latent layer)

This is the first concrete entry requested by the runtime design brief: a kernel parameter grouping that is valid when the active representation is a covariance function.

```yaml
grouping_config_id: PGCFG-COV-SM-ZN-01
model_id: HMMf5-GGZN-Base0
representation_ids: [RF-COV-01]
observation_object_ids: [OBSSTRUCT_Z_POINT_EVAL_IRREGULAR]
parameter_slots:
  - param_id: sigma2_Y
    semantic_role: latent_total_variance
    origin_kind: kernel
    origin_object_id: Cov-SM
    latent_layer_id: Y
    kernel_slot_id: Y
    representation_id: RF-COV-01
    default_status: variable
  - param_id: kappa_Y
    semantic_role: kernel_microparameter
    origin_kind: kernel
    origin_object_id: Cov-SM
    latent_layer_id: Y
    kernel_slot_id: Y
    representation_id: RF-COV-01
    default_status: variable
  - param_id: nu_Y
    semantic_role: kernel_microparameter
    origin_kind: kernel
    origin_object_id: Cov-SM
    latent_layer_id: Y
    kernel_slot_id: Y
    representation_id: RF-COV-01
    default_status: variable
  - param_id: tau2_Z
    semantic_role: nugget_variance
    origin_kind: observation_structure
    origin_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
    observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
    default_status: variable
changeable_object_inventory:
  - object_id: kernel_covariance_Y
    object_category: kernel_parameter
    object_scope: runtime_variable
    param_ids: [sigma2_Y, kappa_Y, nu_Y]
    latent_layer_id: Y
    notes: All free covariance-side Matérn parameters required by `RF-COV-01`.
  - object_id: observation_noise_Z
    object_category: variance_component
    object_scope: runtime_variable
    param_ids: [tau2_Z]
    observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
parameter_groups:
  - group_id: theta_M
    group_type: standard
    group_category: kernel
    group_scope_kind: latent_layer
    latent_layer_id: Y
    description: Covariance-side Matérn parameters for the primary latent layer.
    parameter_collections:
      - collection_id: estimate
        param_ids: [sigma2_Y, kappa_Y, nu_Y]
        role: estimate
        variation_status: variable
        estimation_status: estimable
        identified_status: individually_identified
        constraint_source_classes: [built_in_admissibility]
  - group_id: theta_NP
    group_type: standard
    group_category: noise
    group_scope_kind: observation_object
    observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
    description: Observation nugget.
    parameter_collections:
      - collection_id: estimate
        param_ids: [tau2_Z]
        role: estimate
        variation_status: variable
        estimation_status: estimable
        identified_status: individually_identified
        constraint_source_classes: [built_in_admissibility]
default_constraint_set_ids: [CSET:COV-SM-DEFAULT-01]
notes: The bundle exposes exactly the primitive parameters required to evaluate the covariance representation.
```

---

## 3. `PGCFG-COV-SM-LINMEAN-01`: mean, $\sigma^2$, and $\tau^2$ in one run bundle

This entry answers the Level V requirement that the mean function, latent total variance, and nugget be treated as first-class runtime objects.

```yaml
grouping_config_id: PGCFG-COV-SM-LINMEAN-01
model_id: HMMf5-GGLN-Base0
representation_ids: [RF-COV-01]
observation_object_ids: [OBSSTRUCT_Z_POINT_EVAL_IRREGULAR]
parameter_slots:
  - {param_id: sigma2_Y, semantic_role: latent_total_variance, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y, kernel_slot_id: Y, representation_id: RF-COV-01, default_status: variable}
  - {param_id: kappa_Y,  semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y, kernel_slot_id: Y, representation_id: RF-COV-01, default_status: variable}
  - {param_id: nu_Y,     semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y, kernel_slot_id: Y, representation_id: RF-COV-01, default_status: variable}
  - {param_id: tau2_Z,   semantic_role: nugget_variance, origin_kind: observation_structure, origin_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR, observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR, default_status: variable}
  - {param_id: beta0,    semantic_role: mean_parameter, origin_kind: mean_structure, origin_object_id: HMMf5-GGLN, default_status: variable}
  - {param_id: beta_x1,  semantic_role: mean_parameter, origin_kind: mean_structure, origin_object_id: HMMf5-GGLN, default_status: variable}
  - {param_id: beta_x2,  semantic_role: mean_parameter, origin_kind: mean_structure, origin_object_id: HMMf5-GGLN, default_status: variable}
changeable_object_inventory:
  - object_id: kernel_covariance_Y
    object_category: kernel_parameter
    object_scope: runtime_variable
    param_ids: [sigma2_Y, kappa_Y, nu_Y]
    latent_layer_id: Y
  - object_id: mean_linear
    object_category: mean_structure
    object_scope: runtime_variable
    param_ids: [beta0, beta_x1, beta_x2]
  - object_id: observation_noise_Z
    object_category: variance_component
    object_scope: runtime_variable
    param_ids: [tau2_Z]
parameter_groups:
  - group_id: theta_M
    group_type: standard
    group_category: kernel
    group_scope_kind: latent_layer
    latent_layer_id: Y
    description: Kernel parameters for the latent Matérn field.
    parameter_collections:
      - collection_id: estimate
        param_ids: [sigma2_Y, kappa_Y, nu_Y]
        role: estimate
        variation_status: variable
        estimation_status: estimable
        identified_status: individually_identified
        constraint_source_classes: [built_in_admissibility]
  - group_id: theta_W
    group_type: standard
    group_category: mean
    group_scope_kind: global
    description: Linear deterministic mean coefficients.
    parameter_collections:
      - collection_id: estimate
        param_ids: [beta0, beta_x1, beta_x2]
        role: estimate
        variation_status: variable
        estimation_status: conditionally_estimable
        identified_status: individually_identified
        constraint_source_classes: []
  - group_id: theta_NP
    group_type: standard
    group_category: noise
    group_scope_kind: observation_object
    observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
    description: Nugget variance.
    parameter_collections:
      - collection_id: estimate
        param_ids: [tau2_Z]
        role: estimate
        variation_status: variable
        estimation_status: estimable
        identified_status: individually_identified
        constraint_source_classes: [built_in_admissibility]
notes: `sigma2_Y` is direct in the covariance representation; `tau2_Z` lives in the nuisance/noise group; mean coefficients live in `theta_W`.
```

---

## 4. `PGCFG-COV-RANDMEAN-MULTILAYER-01`: more than one latent layer

This entry shows a model with a primary latent layer `Y` and a residual random-mean layer `ETA`.

```yaml
grouping_config_id: PGCFG-COV-RANDMEAN-MULTILAYER-01
model_id: HMRm06-GrLN-Base0
representation_ids: [RF-COV-01]
observation_object_ids: [OBSSTRUCT_Z_POINT_EVAL_IRREGULAR]
parameter_slots:
  - {param_id: sigma2_Y,   semantic_role: latent_total_variance, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y,   kernel_slot_id: Y,   representation_id: RF-COV-01, default_status: variable}
  - {param_id: kappa_Y,    semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y,   kernel_slot_id: Y,   representation_id: RF-COV-01, default_status: variable}
  - {param_id: nu_Y,       semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y,   kernel_slot_id: Y,   representation_id: RF-COV-01, default_status: variable}
  - {param_id: sigma2_ETA, semantic_role: latent_total_variance, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: ETA, kernel_slot_id: ETA, representation_id: RF-COV-01, default_status: variable}
  - {param_id: kappa_ETA,  semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: ETA, kernel_slot_id: ETA, representation_id: RF-COV-01, default_status: variable}
  - {param_id: nu_ETA,     semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: ETA, kernel_slot_id: ETA, representation_id: RF-COV-01, default_status: variable}
  - {param_id: tau2_Z,     semantic_role: nugget_variance, origin_kind: observation_structure, origin_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR, observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR, default_status: variable}
  - {param_id: beta0,      semantic_role: mean_parameter, origin_kind: mean_structure, origin_object_id: HMRm06-GrLN, default_status: variable}
changeable_object_inventory:
  - {object_id: kernel_primary_latent, object_category: kernel_parameter, object_scope: runtime_variable, param_ids: [sigma2_Y, kappa_Y, nu_Y], latent_layer_id: Y}
  - {object_id: kernel_random_mean, object_category: kernel_parameter, object_scope: runtime_variable, param_ids: [sigma2_ETA, kappa_ETA, nu_ETA], latent_layer_id: ETA}
  - {object_id: observation_noise_Z, object_category: variance_component, object_scope: runtime_variable, param_ids: [tau2_Z], observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR}
  - {object_id: mean_intercept, object_category: mean_structure, object_scope: runtime_variable, param_ids: [beta0]}
parameter_groups:
  - group_id: theta_M_Y
    group_type: structural
    group_category: kernel
    group_scope_kind: latent_layer
    latent_layer_id: Y
    description: Kernel parameters for the primary latent field.
    parameter_collections:
      - {collection_id: estimate, param_ids: [sigma2_Y, kappa_Y, nu_Y], role: estimate, variation_status: variable, estimation_status: estimable, identified_status: individually_identified, constraint_source_classes: [built_in_admissibility]}
  - group_id: theta_M_ETA
    group_type: structural
    group_category: kernel
    group_scope_kind: latent_layer
    latent_layer_id: ETA
    description: Kernel parameters for the residual mean layer.
    parameter_collections:
      - {collection_id: estimate, param_ids: [sigma2_ETA, kappa_ETA, nu_ETA], role: estimate, variation_status: variable, estimation_status: estimable, identified_status: individually_identified, constraint_source_classes: [built_in_admissibility]}
  - group_id: theta_W
    group_type: standard
    group_category: mean
    group_scope_kind: global
    description: Fixed-effect mean coefficients.
    parameter_collections:
      - {collection_id: estimate, param_ids: [beta0], role: estimate, variation_status: variable, estimation_status: conditionally_estimable, identified_status: individually_identified, constraint_source_classes: []}
  - group_id: theta_NP
    group_type: standard
    group_category: noise
    group_scope_kind: observation_object
    observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
    description: Shared nugget variance.
    parameter_collections:
      - {collection_id: estimate, param_ids: [tau2_Z], role: estimate, variation_status: variable, estimation_status: estimable, identified_status: individually_identified, constraint_source_classes: [built_in_admissibility]}
notes: Demonstrates that Level V can organize more than one latent layer without changing Level IV identity.
```

---

## 5. `PGCFG-COV-SM-MICROERGODIC-01`: identifiable-only combination example

This entry shows how a bundle records that primitive parameters are only stable through a reported combination.

```yaml
grouping_config_id: PGCFG-COV-SM-MICROERGODIC-01
model_id: HMMf5-GGZN-Base0
representation_ids: [RF-COV-01]
observation_object_ids: [OBSSTRUCT_Z_POINT_EVAL_IRREGULAR]
parameter_slots:
  - {param_id: sigma2_Y,          semantic_role: latent_total_variance, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y, kernel_slot_id: Y, representation_id: RF-COV-01, default_status: variable}
  - {param_id: kappa_Y,           semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y, kernel_slot_id: Y, representation_id: RF-COV-01, default_status: variable}
  - {param_id: nu_Y,              semantic_role: kernel_microparameter, origin_kind: kernel, origin_object_id: Cov-SM, latent_layer_id: Y, kernel_slot_id: Y, representation_id: RF-COV-01, default_status: fixed}
  - {param_id: tau2_Z,            semantic_role: nugget_variance, origin_kind: observation_structure, origin_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR, observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR, default_status: variable}
  - {param_id: microergodic_Y,    semantic_role: derived_parameter, origin_kind: derived_runtime, origin_object_id: microergodic_combo, latent_layer_id: Y, default_status: derived}
changeable_object_inventory:
  - {object_id: kernel_microparameters, object_category: kernel_parameter, object_scope: runtime_variable, param_ids: [sigma2_Y, kappa_Y, nu_Y], latent_layer_id: Y}
  - {object_id: identified_combo, object_category: custom, object_scope: derived, param_ids: [microergodic_Y], latent_layer_id: Y, notes: Reportable combination exposed to inference.}
parameter_groups:
  - group_id: theta_M
    group_type: standard
    group_category: kernel
    group_scope_kind: latent_layer
    latent_layer_id: Y
    description: Primitive kernel parameters.
    parameter_collections:
      - collection_id: estimate_primitive
        param_ids: [sigma2_Y, kappa_Y]
        role: estimate
        variation_status: variable
        estimation_status: jointly_estimable_only
        identified_status: combination_identified
        estimable_block_id: IDB:MICROERGODIC-Y
        constraint_source_classes: [identifiability, built_in_admissibility]
      - collection_id: fixed_smoothness
        param_ids: [nu_Y]
        role: fixed
        variation_status: static
        estimation_status: not_estimated
        identified_status: fixed
        value_binding:
          binding_kind: fixed_value
          value: 1.5
        constraint_source_classes: [user_runtime]
  - group_id: theta_T
    group_type: standard
    group_category: transform_composite
    group_scope_kind: latent_layer
    latent_layer_id: Y
    description: Derived identifiable combination.
    parameter_collections:
      - collection_id: report_combo
        param_ids: [microergodic_Y]
        role: report_only
        variation_status: derived
        estimation_status: derived
        identified_status: derived
        estimable_block_id: IDB:MICROERGODIC-Y
        transform_binding:
          transform_kind: derived_formula
          source_param_ids: [sigma2_Y, kappa_Y, nu_Y]
          target_param_ids: [microergodic_Y]
          jacobian_status: not_required
          notes: Representative documented formula depends on the chosen asymptotic regime.
        constraint_source_classes: [identifiability]
  - group_id: theta_NP
    group_type: standard
    group_category: noise
    group_scope_kind: observation_object
    observation_object_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
    description: Nugget variance.
    parameter_collections:
      - {collection_id: estimate, param_ids: [tau2_Z], role: estimate, variation_status: variable, estimation_status: estimable, identified_status: individually_identified, constraint_source_classes: [built_in_admissibility]}
identifiability_blocks:
  - estimable_block_id: IDB:MICROERGODIC-Y
    param_ids: [sigma2_Y, kappa_Y, nu_Y]
    identified_quantity_kind: microergodic_combination
    reported_var_ids: [microergodic_Y]
    preferred_variable_space: derived
    formula_documentation: "Representative example: a stable combination such as sigma2_Y * kappa_Y^(2*nu_Y) when the asymptotic regime justifies it."
default_constraint_set_ids: [CSET:FIX-NU-01, CSET:COV-SM-DEFAULT-01]
notes: Primitive parameters are not declared individually identifiable; the bundle exposes a derived reportable combination instead.
```

---

## 6. Summary

* `PGCFG-COV-SM-ZN-01` is the baseline covariance-representation kernel grouping.
* `PGCFG-COV-SM-LINMEAN-01` shows how mean, latent variance, and nugget are grouped together in a single run object.
* `PGCFG-COV-RANDMEAN-MULTILAYER-01` shows more than one latent layer.
* `PGCFG-COV-SM-MICROERGODIC-01` shows how identifiable-only combinations are exposed without redefining the model.
