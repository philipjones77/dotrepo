# Prediction Bayesian Objects

---
*Status*: WORKING
*Version*: v2.2.0
*Date*: 2026-03-17

**Depends Upon:**

* `CT_prediction_bayesian_specs.md`
* `CT_prediction_common_objects.md`

---

## 1. Posterior predictive layer recovery from INLA-type fit

```yaml
posterior_predictive_route: inla_marginals
conditioning_route: analytic_marginalization
conditioning_fit_level_kind: from_approximate_marginal_posterior
computation_report:
  posterior_predictive_route: inla_marginals
  conditioning_route: analytic_marginalization
  conditioning_fit_level_kind: from_approximate_marginal_posterior
  approximation_status: approximate
```

## 2. Posterior predictive draws from joint latent posterior

```yaml
posterior_predictive_route: posterior_samples
conditioning_route: posterior_draw_conditioning
conditioning_fit_level_kind: from_joint_posterior
computation_report:
  posterior_predictive_route: posterior_samples
  conditioning_route: posterior_draw_conditioning
  conditioning_fit_level_kind: from_joint_posterior
  approximation_status: exact
```
