# Diagnostic Objects

---

*Status*: WORKING
*Version*: v2.0
*Date*: 2026-02-23

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_diagnostic_specs.md`

**Is Relied Upon By:**

* `CT_inference_common_objects.md`
* `CT_prediction_common_objects.md`

---

## 0. Preamble

### 0.1 Type of file

`details`

### 0.2 Scope and intent

This file provides example diagnostics payloads consistent with `CT_diagnostic_specs.md`.

---

## 1. Example diagnostics bundle (inference)

```yaml
bundle_id: DiagBundle:InfReq-FREQ-MLE-LOGPOS-01
diagnostics:
  - kind: convergence
    status: ok
    summary:
      method: bfgs
      termination: gradient_tolerance_met
      n_iter: 85
    details:
      final_gradient_norm: 8.0e-7

  - kind: numerical_stability
    status: warning
    summary:
      jitter_added: true
      jitter_strength: 1.0e-8
    details:
      covariance_factorization: cholesky
      min_eigenvalue_estimate: 1.0e-10

  - kind: timing
    status: ok
    summary:
      total_s: 12.8
      phases_s:
        covariance: 8.1
        objective: 0.4
        optimizer: 4.2
```

---

## 2. Example diagnostics bundle (prediction)

```yaml
bundle_id: DiagBundle:PredReq-01
diagnostics:
  - kind: timing
    status: ok
    summary: {total_s: 0.42}
```

---

## 3. Example diagnostics bundle (pointset + lag features)

```yaml
bundle_id: DiagBundle:PointsetLag-01
diagnostics:
  - kind: pointset_layout
    status: ok
    summary:
      layout_kind: irregular
      n_points: 64
    details:
      domain_id: Domain:SphereTime-01

  - kind: lag_features
    status: warning
    summary:
      nonfinite_counts: [0, 2]
    details:
      block_names: [sphere, time]
      message: "LagFeatures contains non-finite entries"
```

---

## 4. Example diagnostics bundle (covariance)

```yaml
bundle_id: DiagBundle:Covariance-01
diagnostics:
  - kind: covariance_symmetry
    status: ok
    summary:
      max_abs_asymmetry: 1.0e-12

  - kind: covariance_psd
    status: warning
    summary:
      min_eigenvalue: -2.0e-8
      tolerance: 1.0e-10
    details:
      message: "Slight negative eigenvalue; likely numerical noise"
```

---

## 5. Example diagnostics bundle (Level II runtime support)

```yaml
bundle_id: DiagBundle:LevelII-OperatorStudy-01
level_tag: Level II
authority_refs:
  spec: CT_operator_runtime_specs.md
  object: CT_operator_runtime_objects.md
  contract: CT_operator_runtime_contracts.md
runtime_context:
  backend: jax
  dtype: float32
  selected_realization_mode: cached_matvec
  shape_policy: shape_stable
  mesh_state_override_blocks: [surface]
diagnostics:
  - kind: timing
    status: ok
    summary:
      cold_elapsed_s: 0.84
      warm_elapsed_s: 0.02
  - kind: numerical_stability
    status: ok
    summary:
      finite_output: true
```

