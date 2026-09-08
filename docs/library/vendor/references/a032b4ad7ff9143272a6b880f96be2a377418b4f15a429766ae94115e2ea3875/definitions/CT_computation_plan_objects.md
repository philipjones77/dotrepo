# Computation Plan Objects

---
*Status*: WORKING
*Version*: v1.2.0
*Date*: 2026-06-23

**Depends Upon:**

* `CT_computation_plan_specs.md`

---

## 1. Exact Gaussian marginal dense-Cholesky plan

```yaml
computation_plan_id: dense_marginal
plan_name: Exact Gaussian marginal dense-Cholesky plan
computation_scope: inference
primary_route: dense_factorization
representation_requirements: [covariance]
layer_route:
  fit_level_kind: marginal
  reference_layer_id: LAYER:Z
  explicit_layer_ids: []
  eliminated_layer_ids: [LAYER:Y]
  hierarchical_likelihood_route: analytic_gaussian_marginal
  outer_loop_kind: direct_objective
  approximation_status: exact
linear_algebra_route:
  factorization_mode: dense_cholesky
  solve_mode: direct_block_solve
  logdet_mode: factorization_logdet
derivative_route:
  gradient_mode: autodiff_reverse
  hessian_mode: none
```

## 2. Matrix-free Gaussian marginal plan

```yaml
computation_plan_id: operator_marginal
plan_name: Matrix-free Gaussian marginal plan
computation_scope: inference
primary_route: operator_iterative
representation_requirements: [covariance]
layer_route:
  fit_level_kind: marginal
  reference_layer_id: LAYER:Z
  explicit_layer_ids: []
  eliminated_layer_ids: [LAYER:Y]
  hierarchical_likelihood_route: analytic_gaussian_marginal
  outer_loop_kind: direct_objective
  approximation_status: stochastic_logdet
linear_algebra_route:
  solve_mode: conjugate_gradient
  logdet_mode: stochastic_lanczos_quadrature
derivative_route:
  gradient_mode: autodiff_reverse
  hessian_mode: none
```

## 3. Approximate marginal Laplace plan

```yaml
computation_plan_id: laplace_sparse_marginal
plan_name: Sparse latent-Gaussian Laplace-MLE plan
computation_scope: inference
primary_route: sparse_factorization
representation_requirements: [precision_operator]
layer_route:
  fit_level_kind: approximate_marginal
  reference_layer_id: LAYER:Z
  explicit_layer_ids: []
  eliminated_layer_ids: [LAYER:Y]
  hierarchical_likelihood_route: laplace_marginal
  outer_loop_kind: direct_objective
  approximation_status: approximate
linear_algebra_route:
  factorization_mode: sparse_cholesky
  solve_mode: direct_block_solve
derivative_route:
  gradient_mode: analytic
  hessian_mode: laplace_local
```

## 4. Latent prediction from marginal fit

```yaml
computation_plan_id: dense_predict
plan_name: Dense latent prediction from marginal fit
computation_scope: prediction
primary_route: dense_factorization
representation_requirements: [covariance, cross_covariance]
layer_route:
  fit_level_kind: marginal
  reference_layer_id: LAYER:Z
  explicit_layer_ids: []
  eliminated_layer_ids: [LAYER:Y]
  prediction_conditioning_route: analytic_gaussian
  outer_loop_kind: not_applicable
linear_algebra_route:
  factorization_mode: dense_cholesky
  solve_mode: direct_block_solve
reuse_policy:
  factorization_reuse: across_prediction_queries
```

## 5. Operator prediction from marginal fit

```yaml
computation_plan_id: operator_predict
plan_name: Matrix-free latent prediction from marginal fit
computation_scope: prediction
primary_route: operator_iterative
representation_requirements: [covariance, cross_covariance]
layer_route:
  prediction_conditioning_route: operator_iterative
  outer_loop_kind: not_applicable
linear_algebra_route:
  solve_mode: conjugate_gradient
reuse_policy:
  preconditioner_reuse: across_prediction_queries
```
