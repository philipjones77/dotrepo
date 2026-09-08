# Prediction Frequentist Objects

---
*Status*: WORKING
*Version*: v2.2.0
*Date*: 2026-03-17

**Depends Upon:**

* `CT_prediction_frequentist_specs.md`
* `CT_prediction_common_objects.md`

---

## 1. Latent kriging after marginal fit

```yaml
predictor_type: universal_kriging
parameter_uncertainty_mode: plugin_only
conditioning_route: factorization_reuse
conditioning_fit_level_kind: from_marginal_fit
computation_report:
  conditioning_route: factorization_reuse
  conditioning_fit_level_kind: from_marginal_fit
  linear_algebra_route: dense_cholesky
  approximation_status: exact
```

## 2. Observation prediction after joint fit

```yaml
predictor_type: blup
parameter_uncertainty_mode: plugin_only
conditioning_route: joint_block_solve
conditioning_fit_level_kind: from_joint_fit
computation_report:
  conditioning_route: joint_block_solve
  conditioning_fit_level_kind: from_joint_fit
  linear_algebra_route: sparse_cholesky
  approximation_status: exact
```
