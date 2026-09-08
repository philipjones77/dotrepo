# Inference Pipeline Objects

---
*Status*: WORKING
*Version*: v2.3.0
*Date*: 2026-06-23

**Depends Upon:**

* `CT_inference_pipeline_specs.md`
* `CT_computation_plan_objects.md`

---

## 1. Frequentist dense pipeline

```yaml
pipeline:
  pipeline_id: ct_inference_frequentist_dense
  pipeline_kind: inference
  pipeline_name: Frequentist dense Cholesky inference
  backend_ids: [jax]
  supported_representation_routes: [covariance]
  supported_primary_routes: [dense_factorization]
supported_paradigms: [frequentist]
supported_objectives: [mle, reml]
supported_fit_level_kinds: [marginal]
default_compute_plan_id: dense_marginal
```

## 2. Matrix-free frequentist pipeline

```yaml
pipeline:
  pipeline_id: ct_inference_frequentist_lazy_operator
  pipeline_kind: inference
  pipeline_name: Frequentist lazy-operator covariance inference
  backend_ids: [jax]
  supported_representation_routes: [covariance]
  supported_primary_routes: [operator_iterative]
supported_paradigms: [frequentist]
supported_methodologies: [M2B, M2C, M3B, M2B-HODLR]
default_compute_plan_id: operator_marginal
```

## 3. Vecchia frequentist pipeline

```yaml
pipeline:
  pipeline_id: ct_inference_frequentist_vecchia
  pipeline_kind: inference
  pipeline_name: Frequentist Vecchia inference
  backend_ids: [jax]
  supported_representation_routes: [covariance]
  supported_primary_routes: [operator_iterative]
supported_paradigms: [frequentist]
supported_methodologies: [M2V]
```

## 4. Bayesian examples

```yaml
pipelines:
  - pipeline_id: ct_inference_bayesian_laplace_dense
    pipeline_kind: inference
    supported_paradigms: [bayesian]
    bayesian_backend: laplace
    supported_representation_routes: [covariance]
    supported_primary_routes: [dense_factorization]

  - pipeline_id: ct_inference_bayesian_numpyro_lazy_operator
    pipeline_kind: inference
    supported_paradigms: [bayesian]
    bayesian_backend: numpyro_nuts
    supported_representation_routes: [covariance]
    supported_primary_routes: [operator_iterative]

  - pipeline_id: ct_inference_bayesian_blackjax_ski
    pipeline_kind: inference
    supported_paradigms: [bayesian]
    bayesian_backend: blackjax_nuts
    supported_representation_routes: [covariance]
    supported_primary_routes: [operator_iterative]
```
