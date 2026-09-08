# Inference Run Plan Objects

---
*Status*: WORKING
*Version*: v2.3.0
*Date*: 2026-06-23

**Depends Upon:**

* `CT_inference_run_plan_specs.md`
* `CT_inference_common_objects.md`

---

## 1. Marginal-versus-joint comparison plan

```yaml
run_plan_id: RunPlan:GG-COMPARE-01
run_plan_name: Gaussian marginal versus joint fit comparison
default_pipeline_id: ct_inference_pipeline
default_compute_plan_id: dense_marginal
execution_policy: serial
runs:
  - run_id: RUN:GG-MARG
    request_ref: {artifact_type: inference_request, artifact_id: InfReq:GG-MARG-01}
    tags: [marginal, gaussian]
  - run_id: RUN:GG-JOINT
    request_ref: {artifact_type: inference_request, artifact_id: InfReq:GG-JOINT-01}
    warm_start_from_run_id: RUN:GG-MARG
    tags: [joint, gaussian]
```

## 2. Approximate marginal comparison plan for Poisson observations

```yaml
run_plan_id: RunPlan:PG-COMPARE-01
run_plan_name: Poisson latent-Gaussian route comparison
default_pipeline_id: ct_inference_pipeline
execution_policy: serial
runs:
  - run_id: RUN:PG-LAPLACE
    request_ref: {artifact_type: inference_request, artifact_id: InfReq:PG-LAPLACE-01}
    compute_plan_id: laplace_sparse_marginal
    tags: [laplace, approximate_marginal]
  - run_id: RUN:PG-EM
    request_ref: {artifact_type: inference_request, artifact_id: InfReq:PG-LAPLACE-01}
    overrides:
      method_id: em
      method_options:
        hierarchical_likelihood_route: em_expected_complete_loglik
        outer_loop_kind: em_outer_loop
    dependency_ids: [RUN:PG-LAPLACE]
    tags: [em, approximate]
```
