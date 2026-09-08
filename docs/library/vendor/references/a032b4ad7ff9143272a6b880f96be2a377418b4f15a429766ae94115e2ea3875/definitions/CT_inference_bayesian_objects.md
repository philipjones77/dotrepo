# Inference Bayesian Objects

---
*Status*: WORKING
*Version*: v2.2.0
*Date*: 2026-03-17

**Depends Upon:**

* `CT_inference_bayesian_specs.md`
* `CT_inference_common_objects.md`

---

## 1. INLA latent-Gaussian route

```yaml
method_id: inla
method_options:
  layer_posterior_route: inla_nested_laplace
  latent_blocking: marginalized
computation_report:
  fit_level_kind: approximate_marginal
  reference_layer_id: LAYER:Z
  layer_posterior_route: inla_nested_laplace
  approximation_status: approximate
```

## 2. Joint NUTS route with explicit latent block

```yaml
method_id: mcmc
method_options:
  sampler_id: nuts
  layer_posterior_route: hmc_joint
  latent_blocking: explicit_block
computation_report:
  fit_level_kind: joint
  reference_layer_id: LAYER:Z
  explicit_layer_ids: [LAYER:Y]
  explicit_state_block_ids: [STATE:Y-MESH-01]
  layer_posterior_route: hmc_joint
  approximation_status: exact
```

## 3. MAP route with hyperparameter-layer priors

```yaml
method_id: cholesky
objective: map
hyperparameter_layer_id: HPL:MAP-PC-01
hyperparameter_layer:
  hyperparameter_layer_id: HPL:MAP-PC-01
  hyperparameters:
    - {hyperparameter_id: HP:PC-RATE, role: prior_rate, value: 0.7, status: fixed}
  bayesian_terms:
    - term_id: TERM:PC-RANGE
      application_kind: prior
      family: pc_exponential
      target_ids: [kappa_Y]
      target_scope: native_parameters
      transform_kind: log
      hyperparameter_refs: {lambda: HP:PC-RATE}
computation_report:
  fit_level_kind: marginal
  reference_layer_id: LAYER:Z
  layer_posterior_route: analytic_gaussian_marginalization
  log_density_route: exact_gaussian_plus_prior_terms
  approximation_status: exact
```
