# Objective Objects — Continuous Track

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

* `CT_objective_specs.md`

**Is Relied Upon By:**

* `CT_inference_common_objects.md`
* `CT_inference_run_plan_objects.md`

---

## 1. Exact Gaussian marginal objective at the observation layer

```yaml
objective_id: OBJ:GG-MARG-OBS-01
objective_kind: neg_log_likelihood
direction: minimize
context:
  representation_ids: [RF-COV-01]
  layer_fit_strategy:
    fit_level_kind: marginal
    reference_layer_id: LAYER:Z
    explicit_layer_ids: []
    eliminated_layer_ids: [LAYER:Y]
    elimination_route_kind: analytic_gaussian
    outer_loop_kind: direct_objective
  latent_handling: integrated_out
  mean_handling: fixed_zero
  nugget_handling: included
  supported_representation_types: [covariance]
likelihood:
  likelihood_kind: gaussian
  evaluation_form: exact
  link_function: identity
  noise_structure: iid
  builtin_id: gaussian_exact_covariance
  requires_logdet: true
  requires_quadratic_form: true
  requires_score: true
```

## 2. Joint Gaussian objective with explicit latent layer

```yaml
objective_id: OBJ:GG-JOINT-01
objective_kind: neg_log_likelihood
direction: minimize
context:
  representation_ids: [RF-COV-01]
  layer_fit_strategy:
    fit_level_kind: joint
    reference_layer_id: LAYER:Z
    explicit_layer_ids: [LAYER:Y]
    eliminated_layer_ids: []
    elimination_route_kind: none
    outer_loop_kind: direct_objective
  latent_handling: joint
  mean_handling: fixed_zero
  nugget_handling: included
likelihood:
  likelihood_kind: gaussian
  evaluation_form: exact
  builtin_id: gaussian_joint_hierarchy
  requires_quadratic_form: true
  requires_score: true
```

## 3. Poisson-on-Gaussian latent approximate marginal objective

```yaml
objective_id: OBJ:PG-LAPLACE-MARG-01
objective_kind: neg_log_likelihood
direction: minimize
context:
  representation_ids: [OP-PREC-01]
  layer_fit_strategy:
    fit_level_kind: approximate_marginal
    reference_layer_id: LAYER:Z
    explicit_layer_ids: []
    eliminated_layer_ids: [LAYER:Y]
    elimination_route_kind: laplace
    outer_loop_kind: direct_objective
  latent_handling: integrated_out
  mean_handling: included
  nugget_handling: absent
likelihood:
  likelihood_kind: poisson
  evaluation_form: exact
  link_function: log
  builtin_id: poisson_log_gaussian_laplace_marginal
  requires_score: true
  requires_hessian: true
notes: Upper layer is Poisson; lower Gaussian latent layer is removed through a Laplace-type approximate marginal route.
```
