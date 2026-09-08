# Inference Frequentist Objects

---
*Status*: WORKING
*Version*: v2.2.0
*Date*: 2026-03-17

**Depends Upon:**

* `CT_inference_frequentist_specs.md`
* `CT_inference_common_objects.md`

---

## 1. Exact Gaussian marginal MLE

```yaml
method_id: mle
computation_report:
  fit_level_kind: marginal
  reference_layer_id: LAYER:Z
  hierarchical_likelihood_route: analytic_gaussian_marginal
  linear_algebra_route: dense_cholesky
  gradient_route: autodiff_reverse
  hessian_route: none
  approximation_status: exact
```

## 2. Poisson / Gaussian latent Laplace MLE

```yaml
method_id: mle
computation_report:
  fit_level_kind: approximate_marginal
  reference_layer_id: LAYER:Z
  hierarchical_likelihood_route: laplace_marginal
  linear_algebra_route: sparse_cholesky
  gradient_route: analytic
  hessian_route: laplace_local
  approximation_status: approximate
```

## 3. Alternating EM-style fit

```yaml
method_id: em
computation_report:
  fit_level_kind: conditional
  reference_layer_id: LAYER:Z
  explicit_layer_ids: [LAYER:Y]
  hierarchical_likelihood_route: em_expected_complete_loglik
  outer_loop_kind: em_outer_loop
  linear_algebra_route: sparse_cholesky
  approximation_status: approximate
```
