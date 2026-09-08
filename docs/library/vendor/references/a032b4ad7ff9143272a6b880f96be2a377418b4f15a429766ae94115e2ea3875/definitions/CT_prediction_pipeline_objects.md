# Prediction Pipeline Objects

---
*Status*: WORKING
*Version*: v2.3.0
*Date*: 2026-06-23

**Depends Upon:**

* `CT_prediction_pipeline_specs.md`
* `CT_computation_plan_objects.md`

---

## 1. Dense simple kriging pipeline

```yaml
pipeline:
  pipeline_id: ct_prediction_simple_kriging_dense
  pipeline_kind: prediction
  pipeline_name: Dense simple kriging
  backend_ids: [jax]
  supported_representation_routes: [covariance, cross_covariance]
  supported_primary_routes: [dense_factorization]
supported_paradigms: [frequentist]
supported_predictor_types: [simple_kriging]
supported_predictive_routes: [analytic_gaussian]
supported_prediction_level_kinds: [latent_level, observation_level, joint_target_layers]
default_compute_plan_id: dense_predict
```

## 2. Scalable kriging pipelines

```yaml
pipelines:
  - pipeline_id: ct_prediction_simple_kriging_lazy_operator
    pipeline_kind: prediction
    supported_primary_routes: [operator_iterative]
    supported_methodologies: [M2B, M2C, M3B, M2B-HODLR]

  - pipeline_id: ct_prediction_simple_kriging_vecchia
    pipeline_kind: prediction
    supported_primary_routes: [operator_iterative]
    supported_methodologies: [M2V]

  - pipeline_id: ct_prediction_simple_kriging_ski
    pipeline_kind: prediction
    supported_primary_routes: [operator_iterative]
    supported_methodologies: [M5-SKI]

  - pipeline_id: ct_prediction_simple_kriging_precision_dense
    pipeline_kind: prediction
    supported_representation_routes: [precision_operator]
    supported_primary_routes: [dense_factorization]
```

## 3. Posterior predictive pipeline

```yaml
pipeline:
  pipeline_id: ct_prediction_posterior_predictive
  pipeline_kind: prediction
  pipeline_name: Posterior predictive sampling
  backend_ids: [jax]
  supported_representation_routes: [covariance, cross_covariance]
  supported_primary_routes: [sampling_based, hybrid]
supported_paradigms: [bayesian]
supported_predictor_types: [posterior_predictive, conditional_simulation]
supported_predictive_routes: [posterior_samples, analytic_gaussian]
```
