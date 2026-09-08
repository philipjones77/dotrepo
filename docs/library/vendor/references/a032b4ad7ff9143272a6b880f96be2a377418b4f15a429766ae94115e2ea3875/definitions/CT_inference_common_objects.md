# Inference Common Objects — Continuous Track

---
*Status*: WORKING
*Version*: v2.2
*Date*: 2026-03-17

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_inference_common_specs.md`
* `CT_objective_objects.md`
* `CT_constraint_set_objects.md`
* `CT_optimization_parameterization_objects.md`
* `CT_io_objects.md`
* `CT_diagnostic_objects.md`

**Is Relied Upon By:**

* `CT_inference_frequentist_objects.md`
* `CT_inference_bayesian_objects.md`
* `CT_prediction_common_objects.md`

---

## 1. Frequentist Gaussian marginal fit request

```yaml
request_id: InfReq:GG-MARG-01
inference_paradigm: frequentist
target: parameter_only
model_id: HMMf5-GGZN-Base0
domain_id: M:SpaceTime-Euclid-01
sampling_design_id: SD:SpaceTime-PointSet-01
representation_ids: [RF-COV-01]
parameter_grouping_id: PGCFG-COV-SM-ZN-01
objective_id: OBJ:GG-MARG-OBS-01
fit_layer_strategy:
  fit_level_kind: marginal
  reference_layer_id: LAYER:Z
  explicit_layer_ids: []
  eliminated_layer_ids: [LAYER:Y]
  elimination_route_kind: analytic_gaussian
  outer_loop_kind: direct_objective
data_ref: {artifact_type: observations, artifact_id: Obs:GG-01}
data_schema: {response_var: z, coord_vars: [s1, s2, t], missing_policy: drop}
method_id: mle
method_options:
  evaluation_representation_id: RF-COV-01
  hierarchical_likelihood_route: analytic_gaussian_marginal
  factorization_kind: dense_cholesky
  derivative_mode: autodiff
compute_diagnostics: true
requested_outputs: [point_estimate, objective_report]
```

## 2. Frequentist Gaussian joint fit request

```yaml
request_id: InfReq:GG-JOINT-01
inference_paradigm: frequentist
target: joint
model_id: HMMf5-GGZN-Base0
domain_id: M:SpaceTime-Euclid-01
sampling_design_id: SD:SpaceTime-PointSet-01
representation_ids: [RF-COV-01]
parameter_grouping_id: PGCFG-COV-SM-ZN-01
objective_id: OBJ:GG-JOINT-01
fit_layer_strategy:
  fit_level_kind: joint
  reference_layer_id: LAYER:Z
  explicit_layer_ids: [LAYER:Y]
  eliminated_layer_ids: []
  elimination_route_kind: none
  outer_loop_kind: direct_objective
parameterization_id: PARZ:GG-JOINT-01
data_ref: {artifact_type: observations, artifact_id: Obs:GG-01}
data_schema: {response_var: z, coord_vars: [s1, s2, t]}
method_id: mle
method_options:
  hierarchical_likelihood_route: joint_latent_optimization
  factorization_kind: dense_cholesky
  derivative_mode: hybrid
compute_diagnostics: true
requested_outputs: [point_estimate, latent_summary]
```

## 3. Poisson / Gaussian latent approximate marginal fit request

```yaml
request_id: InfReq:PG-LAPLACE-01
inference_paradigm: frequentist
target: parameter_only
model_id: HMMf5-PG-Base0
domain_id: M:SpaceTime-Euclid-01
sampling_design_id: SD:SpaceTime-PointSet-02
representation_ids: [OP-PREC-01]
parameter_grouping_id: PGCFG-PG-LATENT-01
objective_id: OBJ:PG-LAPLACE-MARG-01
fit_layer_strategy:
  fit_level_kind: approximate_marginal
  reference_layer_id: LAYER:Z
  explicit_layer_ids: []
  eliminated_layer_ids: [LAYER:Y]
  elimination_route_kind: laplace
  outer_loop_kind: direct_objective
parameterization_id: PARZ:PG-PARAM-ONLY-01
data_ref: {artifact_type: observations, artifact_id: Obs:PG-01}
data_schema: {response_var: z, coord_vars: [s1, s2, t], offset_var: exposure}
method_id: mle
method_options:
  hierarchical_likelihood_route: laplace_marginal
  factorization_kind: sparse_cholesky
  derivative_mode: analytic
compute_diagnostics: true
requested_outputs: [point_estimate, objective_report]
```

## 4. Representative fit-layer report

```yaml
request_id: InfReq:PG-LAPLACE-01
status: success
resolved_ids:
  model_id: HMMf5-PG-Base0
  representation_ids: [OP-PREC-01]
fit_summary:
  final_objective_value: 1832.51
execution_report:
  fit_layer_report:
    fit_level_kind: approximate_marginal
    reference_layer_id: LAYER:Z
    explicit_layer_ids: []
    eliminated_layer_ids: [LAYER:Y]
    hierarchical_likelihood_route: laplace_marginal
    outer_loop_kind: direct_objective
    approximation_status: approximate
parameter_estimates:
  native_parameters: {sigma2_Y: 1.10, kappa_Y: 0.45, beta0: -0.60}
```
