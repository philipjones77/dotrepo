# Optimization Parameterization Objects

---
*Status*: WORKING
*Version*: v2.2.0
*Date*: 2026-03-17

**Depends Upon:**

* `CT_optimization_parameterization_specs.md`

---

## 1. Parameter-only transform route

```yaml
parameterization_id: PARZ:PG-PARAM-ONLY-01
parameterization_kind: transform_only
native_parameters: [sigma2_Y, kappa_Y, beta0]
opt_variables: [log_sigma2_Y, log_kappa_Y, beta0]
transforms:
  - {opt_var_id: log_sigma2_Y, param_id: sigma2_Y, transform_kind: log}
  - {opt_var_id: log_kappa_Y, param_id: kappa_Y, transform_kind: log}
parameter_blocks:
  - {block_id: BLK:PARAM-01, opt_var_ids: [log_sigma2_Y, log_kappa_Y, beta0], block_role: optimizer_block}
```

## 2. Joint parameter plus explicit latent-state block

```yaml
parameterization_id: PARZ:GG-JOINT-01
parameterization_kind: transform_only
native_parameters: [sigma2_Y, tau2_Z]
opt_variables: [log_sigma2_Y, log_tau2_Z]
transforms:
  - {opt_var_id: log_sigma2_Y, param_id: sigma2_Y, transform_kind: log}
  - {opt_var_id: log_tau2_Z, param_id: tau2_Z, transform_kind: log}
layer_state_blocks:
  - state_block_id: STATE:Y-MESH-01
    layer_id: LAYER:Y
    coordinate_kind: mesh_coefficients
    block_role: optimized_state
    dimension_ref: mesh_n_vertices
parameter_blocks:
  - block_id: BLK:PARAM-01
    opt_var_ids: [log_sigma2_Y, log_tau2_Z]
    state_block_ids: [STATE:Y-MESH-01]
    block_role: optimizer_block
```

## 3. Identifiable-only combination

```yaml
parameterization_id: PARZ:MICROERGODIC-01
parameterization_kind: custom
native_parameters: [sigma2_Y, kappa_Y]
custom_maps:
  inverse_map_evaluator_id: eval_microergodic_inverse
estimable_combinations:
  - combination_id: COMB:SIGMA2-KAPPA-01
    source_var_ids: [sigma2_Y, kappa_Y]
    evaluator_id: eval_microergodic_combo
    combination_role: identifiability_reduction
    invertibility_status: noninvertible
```

## 4. Parameterization with frequentist hyperparameter layer

```yaml
parameterization_id: PARZ:PENALIZED-COV-01
parameterization_kind: transform_only
native_parameters: [sigma2_Y, kappa_Y, tau2_Z]
opt_variables: [log_sigma2_Y, log_kappa_Y, log_tau2_Z]
transforms:
  - {opt_var_id: log_sigma2_Y, param_id: sigma2_Y, transform_kind: log}
  - {opt_var_id: log_kappa_Y, param_id: kappa_Y, transform_kind: log}
  - {opt_var_id: log_tau2_Z, param_id: tau2_Z, transform_kind: log}
hyperparameter_layer_id: HPL:PENALIZED-COV-01
hyperparameter_layer:
  hyperparameter_layer_id: HPL:PENALIZED-COV-01
  hyperparameters:
    - {hyperparameter_id: HP:LASSO, role: regularization_strength, value: 0.2, status: fixed}
    - {hyperparameter_id: HP:GROUP, role: regularization_strength, value: 0.5, status: fixed}
  frequentist_terms:
    - term_id: TERM:L1-NUGGET
      application_kind: penalty
      family: lasso
      target_ids: [tau2_Z]
      target_scope: native_parameters
      transform_kind: identity
      hyperparameter_refs: {lambda: HP:LASSO}
    - term_id: TERM:GROUP-KERNEL
      application_kind: penalty
      family: group_ridge
      target_scope: native_parameters
      transform_kind: identity
      group_assignments:
        kernel_block: [sigma2_Y, kappa_Y]
      hyperparameter_refs: {lambda: HP:GROUP}
```

## 5. Parameterization with Bayesian hyperparameter layer

```yaml
parameterization_id: PARZ:MAP-PC-01
parameterization_kind: transform_only
native_parameters: [sigma2_Y, kappa_Y]
opt_variables: [log_sigma2_Y, log_kappa_Y]
transforms:
  - {opt_var_id: log_sigma2_Y, param_id: sigma2_Y, transform_kind: log}
  - {opt_var_id: log_kappa_Y, param_id: kappa_Y, transform_kind: log}
hyperparameter_layer_id: HPL:MAP-PC-01
hyperparameter_layer:
  hyperparameter_layer_id: HPL:MAP-PC-01
  hyperparameters:
    - {hyperparameter_id: HP:PC-RATE, role: prior_rate, value: 0.7, status: fixed}
    - {hyperparameter_id: HP:RIDGE, role: prior_scale, value: 0.1, status: fixed}
  bayesian_terms:
    - term_id: TERM:PC-KAPPA
      application_kind: prior
      family: pc_exponential
      target_ids: [kappa_Y]
      target_scope: native_parameters
      transform_kind: log
      hyperparameter_refs: {lambda: HP:PC-RATE}
    - term_id: TERM:RIDGE-SIGMA
      application_kind: prior
      family: gaussian
      target_ids: [sigma2_Y]
      target_scope: native_parameters
      transform_kind: identity
      hyperparameter_refs: {lambda: HP:RIDGE}
```
