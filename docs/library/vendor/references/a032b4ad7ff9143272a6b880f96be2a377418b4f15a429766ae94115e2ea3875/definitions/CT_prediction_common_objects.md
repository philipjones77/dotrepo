# Prediction Common Objects — Continuous Track

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

* `CT_prediction_common_specs.md`
* `CT_inference_common_objects.md`

**Is Relied Upon By:**

* `CT_prediction_frequentist_objects.md`
* `CT_prediction_bayesian_objects.md`

---

## 1. Latent-layer prediction from a marginal observation-layer fit

```yaml
request_id: PredReq:LATENT-FROM-MARG-01
prediction_paradigm: frequentist
fit_ref: {artifact_type: inference_fit, artifact_id: Fit:GG-MARG-01}
query:
  locations: {space: [[0.1, 0.2], [0.4, 0.7]], time: [1.0, 1.5]}
targets: [latent]
predictor_kind: universal_kriging
parameter_uncertainty_mode: plug_in
layer_prediction_strategy:
  conditioning_layer_ids: [LAYER:Z]
  target_layer_ids: [LAYER:Y]
  integrated_layer_ids: []
  prediction_level_kind: latent_level
  conditioning_route_kind: analytic_gaussian
  noise_handling: exclude_measurement_noise
uq_mode: marginal
compute_diagnostics: true
```

## 2. Observation-level prediction from the same fit with both process and total uncertainty

```yaml
request_id: PredReq:OBS-FROM-MARG-01
prediction_paradigm: frequentist
fit_ref: {artifact_type: inference_fit, artifact_id: Fit:GG-MARG-01}
query:
  locations: {space: [[0.1, 0.2]], time: [1.0]}
targets: [observation]
predictor_kind: universal_kriging
parameter_uncertainty_mode: plug_in
layer_prediction_strategy:
  conditioning_layer_ids: [LAYER:Z]
  target_layer_ids: [LAYER:Z]
  integrated_layer_ids: [LAYER:Y]
  prediction_level_kind: observation_level
  conditioning_route_kind: analytic_gaussian
  noise_handling: report_both
uq_mode: marginal
```

## 3. Representative prediction-layer report

```yaml
request_id: PredReq:LATENT-FROM-MARG-01
status: success
predictions:
  latent:
    mean: [0.41, 0.55]
uncertainty:
  marginal_variance: [0.28, 0.31]
prediction_layer_report:
  conditioning_layer_ids: [LAYER:Z]
  target_layer_ids: [LAYER:Y]
  integrated_layer_ids: []
  prediction_level_kind: latent_level
  conditioning_route_kind: analytic_gaussian
  noise_handling: exclude_measurement_noise
  fit_level_kind_source: from_marginal_fit
```
