# Pipeline Objects

---
*Status*: WORKING
*Version*: v2.3.0
*Date*: 2026-06-23

**Depends Upon:**

* `CT_pipeline_specs.md`

---

## 1. Runtime registry mirror

The exhaustive executable registry is the set of `Pipeline(name=...)`
objects registered in `inference/v2/pipelines.py` and
`prediction/v2/pipelines.py`. This object file is a compact catalog of
current runtime IDs, not the authority for registration.

```yaml
registry_id: ct_pipeline_registry_v2
registry_name: CT v2 inference and prediction pipeline catalog
pipelines:
  - pipeline_id: ct_inference_frequentist_dense
    pipeline_kind: inference
    backend_family: dense_cholesky
    capabilities: [mle, reml, hessian_covariance]

  - pipeline_id: ct_inference_frequentist_lazy_operator
    pipeline_kind: inference
    backend_family: matrix_free_covariance
    capabilities: [mle, cg_inv_quad, slq_logdet]

  - pipeline_id: ct_inference_frequentist_vecchia
    pipeline_kind: inference
    backend_family: vecchia
    capabilities: [mle, sparse_conditioning]

  - pipeline_id: ct_inference_bayesian_laplace_dense
    pipeline_kind: inference
    backend_family: dense_laplace
    capabilities: [map, laplace_posterior]

  - pipeline_id: ct_inference_bayesian_numpyro_lazy_operator
    pipeline_kind: inference
    backend_family: numpyro_matrix_free
    capabilities: [nuts, operator_loss]

  - pipeline_id: ct_prediction_simple_kriging_dense
    pipeline_kind: prediction
    backend_family: dense_cholesky
    capabilities: [simple_kriging, analytic_gaussian]

  - pipeline_id: ct_prediction_simple_kriging_lazy_operator
    pipeline_kind: prediction
    backend_family: matrix_free_covariance
    capabilities: [simple_kriging, cg_solve]

  - pipeline_id: ct_prediction_posterior_predictive
    pipeline_kind: prediction
    backend_family: posterior_samples
    capabilities: [posterior_predictive]
```

Notes:

* Pipeline membership is execution context, not mathematical identity.
* Run-plan wrapper IDs such as `ct_inference_pipeline` and
  `ct_prediction_pipeline` still exist in the legacy run-plan runtime
  and are cataloged in the run-plan object files.
