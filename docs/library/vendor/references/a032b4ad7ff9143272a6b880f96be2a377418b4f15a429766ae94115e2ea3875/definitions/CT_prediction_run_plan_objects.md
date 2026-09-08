# Prediction Run Plan Objects

---
*Status*: WORKING
*Version*: v1.1.0
*Date*: 2026-06-23

**Depends Upon:**

* `CT_prediction_run_plan_specs.md`
* `CT_prediction_common_objects.md`

---

## 1. Multi-target prediction plan from one fit

```yaml
run_plan_id: PredRunPlan:GG-MULTITARGET-01
run_plan_name: Latent and observation predictions from one marginal fit
default_pipeline_id: ct_prediction_pipeline
default_compute_plan_id: dense_predict
execution_policy: serial
runs:
  - run_id: PRUN:LATENT
    request_ref: {artifact_type: prediction_request, artifact_id: PredReq:LATENT-FROM-MARG-01}
    tags: [latent, kriging]
  - run_id: PRUN:OBS
    request_ref: {artifact_type: prediction_request, artifact_id: PredReq:OBS-FROM-MARG-01}
    tags: [observation, total_variance]
```

## 2. Route comparison over one fit

```yaml
run_plan_id: PredRunPlan:ROUTE-COMPARE-01
run_plan_name: Dense versus operator prediction routes
execution_policy: parallel_independent
runs:
  - run_id: PRUN:DENSE
    request_ref: {artifact_type: prediction_request, artifact_id: PredReq:LATENT-FROM-MARG-01}
    pipeline_id: ct_prediction_pipeline
    compute_plan_id: dense_predict
    tags: [dense]
  - run_id: PRUN:MATVEC
    request_ref: {artifact_type: prediction_request, artifact_id: PredReq:LATENT-FROM-MARG-01}
    pipeline_id: ct_prediction_simple_kriging_lazy_operator
    compute_plan_id: operator_predict
    tags: [operator]
```
