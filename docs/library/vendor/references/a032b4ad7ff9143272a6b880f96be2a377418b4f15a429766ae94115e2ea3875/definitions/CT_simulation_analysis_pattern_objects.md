# CT Simulation Analysis Pattern Objects

## 0. Canonical pattern object

### 0.1 Single-field Matérn simulation-analysis pattern

```yaml
pattern_id: CT-ANALYSIS-PATTERN-SIMULATION-MATERN-SINGLEFIELD-V1
track_id: CT
pattern_name: Single-field Gaussian Matérn simulation-analysis pattern
pattern_goal:
  - finite-sample assessment of parameter estimation
  - comparison of covariance, spectral, operator/SPDE, and basis-expansion fits
  - comparison of plug-in kriging and Bayesian kriging
  - assessment of mean misspecification, covariance misspecification, regularization, and prior sensitivity
  - empirical fixed-domain infill asymptotic study under sampling-design variation
pattern_scope:
  - single-field Matérn truth
  - Euclidean bounded domain baseline
  - fixed truth within scenario
  - 1000 independent field replications per scenario
scenario_family_ids:
  - CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
comparison_block_ids:
  - CT-COMP-BLOCK-MATERN-FIT-ENGINES-V1
  - CT-COMP-BLOCK-MATERN-KRIGING-V1
  - CT-COMP-BLOCK-MATERN-PRIORS-V1
  - CT-COMP-BLOCK-MATERN-MISSPECIFICATION-V1
  - CT-COMP-BLOCK-MATERN-INFILL-V1
summary_block_ids:
  - CT-SUMMARY-BLOCK-MATERN-PARAMETERS-V1
  - CT-SUMMARY-BLOCK-MATERN-PREDICTION-V1
  - CT-SUMMARY-BLOCK-MATERN-UNCERTAINTY-V1
  - CT-SUMMARY-BLOCK-MATERN-RUNTIME-V1
  - CT-SUMMARY-BLOCK-MATERN-DECISION-TABLE-V1
artifact_policy:
  store_per_replication_outputs: true
  store_aggregate_outputs: true
  store_plot_objects: true
```

## 1. Truth scenario family

```yaml
scenario_family_id: CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
family_name: Single-field Matérn truth family
truth_model_class: covariance
domain_family_id: CT-DOMAIN-FAMILY-E2-UNIT-SQUARE
sampling_design_family_id: CT-DESIGN-FAMILY-E2-STUDY-V1
parameter_sweep_axes:
  - smoothness_regime
  - range_regime
  - nugget_regime
  - design_type
  - sample_size
scenario_ids:
  - CT-TRUTH-SCENARIO-MATERN-R1
  - CT-TRUTH-SCENARIO-MATERN-R2
  - CT-TRUTH-SCENARIO-MATERN-R3
  - CT-TRUTH-SCENARIO-MATERN-R4
```

## 2. Fixed-truth scenarios

### 2.1 Scenario R1: medium smoothness, quasi-uniform irregular, n=400

```yaml
scenario_id: CT-TRUTH-SCENARIO-MATERN-R1
scenario_family_id: CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
replication_count: 1000
truth_parameter_vector:
  beta_0: 1.0
  beta_1: 0.75
  sigma2: 1.0
  kappa: 8.0
  nu: 1.5
  tau2: 0.0
truth_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
  formula_latex: "mu(s)=beta_0 + beta_1 x_1(s)"
truth_latent_spec:
  latent_distribution_class: gaussian
  model_id: CT-MATERN-SINGLEFIELD
  kernel_id: matern_iso
  working_representation_type: covariance
truth_noise_spec:
  noise_form: none
domain_id: CT-DOMAIN-E2-UNIT-SQUARE
sampling_design_id: CT-DESIGN-E2-QUASIUNIFORM-400
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
seed_root: 10401
boundary_condition_id: CT-BOUNDARY-NATURAL
truth_pipeline_id: CT-PIPELINE-TRUTH-COV-CHOLESKY
notes:
  smoothness_regime: medium
  range_regime: moderate
  nugget_regime: none
  design_type: quasi_uniform_irregular
  n: 400
```

### 2.2 Scenario R2: rough truth, regular grid, n=400

```yaml
scenario_id: CT-TRUTH-SCENARIO-MATERN-R2
scenario_family_id: CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
replication_count: 1000
truth_parameter_vector:
  beta_0: 1.0
  beta_1: 0.75
  sigma2: 1.0
  kappa: 8.0
  nu: 0.5
  tau2: 0.0
truth_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
truth_latent_spec:
  latent_distribution_class: gaussian
  model_id: CT-MATERN-SINGLEFIELD
  kernel_id: matern_iso
  working_representation_type: covariance
truth_noise_spec:
  noise_form: none
domain_id: CT-DOMAIN-E2-UNIT-SQUARE
sampling_design_id: CT-DESIGN-E2-GRID-20X20
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
seed_root: 10402
boundary_condition_id: CT-BOUNDARY-NATURAL
truth_pipeline_id: CT-PIPELINE-TRUTH-COV-CHOLESKY
notes:
  smoothness_regime: rough
  design_type: regular_grid
  n: 400
```

### 2.3 Scenario R3: medium smoothness with nugget, clustered design, n=400

```yaml
scenario_id: CT-TRUTH-SCENARIO-MATERN-R3
scenario_family_id: CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
replication_count: 1000
truth_parameter_vector:
  beta_0: 1.0
  beta_1: 0.75
  sigma2: 1.0
  kappa: 8.0
  nu: 1.5
  tau2: 0.05
truth_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
truth_latent_spec:
  latent_distribution_class: gaussian
  model_id: CT-MATERN-SINGLEFIELD
  kernel_id: matern_iso
  working_representation_type: covariance
truth_noise_spec:
  noise_form: gaussian_nugget
  noise_parameter_vector:
    tau2: 0.05
domain_id: CT-DOMAIN-E2-UNIT-SQUARE
sampling_design_id: CT-DESIGN-E2-CLUSTERED-400
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
seed_root: 10403
boundary_condition_id: CT-BOUNDARY-NATURAL
truth_pipeline_id: CT-PIPELINE-TRUTH-COV-CHOLESKY
notes:
  smoothness_regime: medium
  nugget_regime: small
  design_type: clustered_irregular
  n: 400
```

### 2.4 Scenario R4: medium smoothness, quasi-uniform irregular, n=900 (infill)

```yaml
scenario_id: CT-TRUTH-SCENARIO-MATERN-R4
scenario_family_id: CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
replication_count: 1000
truth_parameter_vector:
  beta_0: 1.0
  beta_1: 0.75
  sigma2: 1.0
  kappa: 8.0
  nu: 1.5
  tau2: 0.0
truth_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
truth_latent_spec:
  latent_distribution_class: gaussian
  model_id: CT-MATERN-SINGLEFIELD
  kernel_id: matern_iso
  working_representation_type: covariance
truth_noise_spec:
  noise_form: none
domain_id: CT-DOMAIN-E2-UNIT-SQUARE
sampling_design_id: CT-DESIGN-E2-QUASIUNIFORM-900
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
seed_root: 10404
boundary_condition_id: CT-BOUNDARY-NATURAL
truth_pipeline_id: CT-PIPELINE-TRUTH-COV-CHOLESKY
notes:
  smoothness_regime: medium
  design_type: quasi_uniform_irregular
  n: 900
```

## 3. Fit requests (competing fitted methods)

### 3.1 Correct covariance fit, all free

```yaml
fit_request_id: CT-FIT-REQ-MATERN-COV-CORRECT-FREE
fit_label: covariance_correct_free
fit_model_class: covariance
fit_model_id: CT-MATERN-SINGLEFIELD
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-COV-DENSE-CHOLESKY
fit_engine_id: CT-ENGINE-MLE
```

### 3.2 Covariance fit with low smoothness fixed (misspecified)

```yaml
fit_request_id: CT-FIT-REQ-MATERN-COV-NU-LOW
fit_label: covariance_nu_fixed_low
fit_model_class: covariance
fit_model_id: CT-MATERN-SINGLEFIELD
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: M
  tau2: E
fit_parameter_reference_vector:
  nu: 0.5
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-COV-DENSE-CHOLESKY
fit_engine_id: CT-ENGINE-MLE
```

### 3.3 Mean-misspecified covariance fit (omit x1)

```yaml
fit_request_id: CT-FIT-REQ-MATERN-COV-MEAN-OMIT-X1
fit_label: covariance_mean_omit_x1
fit_model_class: covariance
fit_model_id: CT-MATERN-SINGLEFIELD
fit_mean_spec:
  mean_form: constant
  covariate_ids: [intercept]
  beta_parameter_ids: [beta_0]
fit_parameter_status_vector:
  beta_0: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-COV-DENSE-CHOLESKY
fit_engine_id: CT-ENGINE-MLE
```

### 3.4 Spectral fit

```yaml
fit_request_id: CT-FIT-REQ-MATERN-SPECTRAL-WHITTLE
fit_label: spectral_whittle
fit_model_class: spectral
fit_model_id: CT-MATERN-SINGLEFIELD
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-SPECTRAL-WHITTLE
fit_engine_id: CT-ENGINE-MLE
```

### 3.5 Operator/SPDE fit

```yaml
fit_request_id: CT-FIT-REQ-MATERN-SPDE-FEM
fit_label: operator_spde_fem
fit_model_class: operator_spde
fit_model_id: CT-WHITTLE-MATERN-SPDE
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-SPDE-FEM-DIRECT
fit_engine_id: CT-ENGINE-MLE
boundary_condition_id: CT-BOUNDARY-NATURAL
```

### 3.6 Basis-expansion fit

```yaml
fit_request_id: CT-FIT-REQ-MATERN-BASIS-LOWRANK
fit_label: basis_lowrank
fit_model_class: basis_expansion
fit_model_id: CT-MATERN-BASIS-LOWRANK
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-BASIS-LOWRANK-DENSE
fit_engine_id: CT-ENGINE-MLE
```

### 3.7 Bayesian covariance fit with PC prior

```yaml
fit_request_id: CT-FIT-REQ-MATERN-BAYES-PC
fit_label: covariance_bayes_pc
fit_model_class: covariance
fit_model_id: CT-MATERN-SINGLEFIELD
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-COV-DENSE-CHOLESKY
fit_engine_id: CT-ENGINE-BAYES-MCMC
prior_id: CT-PRIOR-PC-MATERN-V1
```

### 3.8 Bayesian covariance fit with approximate reference prior

```yaml
fit_request_id: CT-FIT-REQ-MATERN-BAYES-AR
fit_label: covariance_bayes_approx_reference
fit_model_class: covariance
fit_model_id: CT-MATERN-SINGLEFIELD
fit_mean_spec:
  mean_form: linear_covariates
  covariate_ids: [intercept, x1]
  beta_parameter_ids: [beta_0, beta_1]
fit_parameter_status_vector:
  beta_0: E
  beta_1: E
  sigma2: E
  kappa: E
  nu: E
  tau2: E
fit_parameter_reference_vector: {}
fit_constraint_map:
  free_parameter_ids: [beta_0, beta_1, sigma2, kappa, nu, tau2]
  parameter_map_kind: identity
fit_pipeline_id: CT-PIPELINE-COV-DENSE-CHOLESKY
fit_engine_id: CT-ENGINE-BAYES-MCMC
prior_id: CT-PRIOR-APPROX-REFERENCE-MATERN-V1
```

## 4. Prediction evaluation requests

### 4.1 Plug-in universal kriging

```yaml
evaluation_request_id: CT-PRED-REQ-PLUGIN-UNIVERSAL
evaluation_type: kriging
kriging_mode: plug_in
prediction_target: all
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
predictive_uq: true
metric_ids:
  - kriging_rmse
  - kriging_mae
  - log_score
  - predictive_interval_coverage
  - calibration_ratio
heldout_truth_kind: observation
```

### 4.2 Bayesian kriging with drift

```yaml
evaluation_request_id: CT-PRED-REQ-BAYES-DRIFT
evaluation_type: bayesian_kriging
kriging_mode: bayesian
prediction_target: all
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
predictive_uq: true
metric_ids:
  - kriging_rmse
  - log_score
  - predictive_interval_coverage
  - interval_width
  - calibration_ratio
heldout_truth_kind: observation
posterior_sample_count: 500
```

### 4.3 Full Bayesian kriging

```yaml
evaluation_request_id: CT-PRED-REQ-FULL-BAYES
evaluation_type: full_bayesian_kriging
kriging_mode: full_bayesian
prediction_target: all
prediction_design_id: CT-DESIGN-E2-HOLDOUT-100
predictive_uq: true
metric_ids:
  - kriging_rmse
  - log_score
  - predictive_interval_coverage
  - interval_width
  - calibration_ratio
heldout_truth_kind: observation
posterior_sample_count: 500
```

## 5. Comparison blocks

### 5.1 Fit-engine comparison block

```yaml
comparison_block_id: CT-COMP-BLOCK-MATERN-FIT-ENGINES-V1
block_type: fit_comparison
target_scenario_family_ids:
  - CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
fit_request_ids:
  - CT-FIT-REQ-MATERN-COV-CORRECT-FREE
  - CT-FIT-REQ-MATERN-SPECTRAL-WHITTLE
  - CT-FIT-REQ-MATERN-SPDE-FEM
  - CT-FIT-REQ-MATERN-BASIS-LOWRANK
evaluation_request_ids:
  - CT-PRED-REQ-PLUGIN-UNIVERSAL
block_goal:
  - compare statistical formulations and pipelines under the same fixed truths
```

### 5.2 Kriging comparison block

```yaml
comparison_block_id: CT-COMP-BLOCK-MATERN-KRIGING-V1
block_type: kriging_comparison
target_scenario_family_ids:
  - CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
fit_request_ids:
  - CT-FIT-REQ-MATERN-COV-CORRECT-FREE
  - CT-FIT-REQ-MATERN-BAYES-PC
  - CT-FIT-REQ-MATERN-BAYES-AR
evaluation_request_ids:
  - CT-PRED-REQ-PLUGIN-UNIVERSAL
  - CT-PRED-REQ-BAYES-DRIFT
  - CT-PRED-REQ-FULL-BAYES
block_goal:
  - compare plug-in and Bayesian kriging under matched truths
```

### 5.3 Prior comparison block

```yaml
comparison_block_id: CT-COMP-BLOCK-MATERN-PRIORS-V1
block_type: prior_comparison
target_scenario_family_ids:
  - CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
fit_request_ids:
  - CT-FIT-REQ-MATERN-BAYES-PC
  - CT-FIT-REQ-MATERN-BAYES-AR
evaluation_request_ids:
  - CT-PRED-REQ-BAYES-DRIFT
  - CT-PRED-REQ-FULL-BAYES
block_goal:
  - compare PC and approximate-reference prior behavior in estimation and prediction
```

### 5.4 Misspecification block

```yaml
comparison_block_id: CT-COMP-BLOCK-MATERN-MISSPECIFICATION-V1
block_type: misspecification_block
target_scenario_family_ids:
  - CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
fit_request_ids:
  - CT-FIT-REQ-MATERN-COV-CORRECT-FREE
  - CT-FIT-REQ-MATERN-COV-NU-LOW
  - CT-FIT-REQ-MATERN-COV-MEAN-OMIT-X1
evaluation_request_ids:
  - CT-PRED-REQ-PLUGIN-UNIVERSAL
  - CT-PRED-REQ-BAYES-DRIFT
block_goal:
  - separate mean misspecification from covariance misspecification
```

### 5.5 Infill block

```yaml
comparison_block_id: CT-COMP-BLOCK-MATERN-INFILL-V1
block_type: asymptotic_block
target_scenario_family_ids:
  - CT-TRUTH-FAMILY-MATERN-SINGLEFIELD-V1
fit_request_ids:
  - CT-FIT-REQ-MATERN-COV-CORRECT-FREE
  - CT-FIT-REQ-MATERN-BAYES-PC
  - CT-FIT-REQ-MATERN-BAYES-AR
evaluation_request_ids:
  - CT-PRED-REQ-PLUGIN-UNIVERSAL
  - CT-PRED-REQ-BAYES-DRIFT
block_goal:
  - empirical fixed-domain infill study across increasing sample sizes
```

## 6. Summary blocks

### 6.1 Parameter summary

```yaml
summary_block_id: CT-SUMMARY-BLOCK-MATERN-PARAMETERS-V1
summary_type: parameter_summary
metric_ids:
  - bias
  - empirical_sd
  - rmse
  - median
  - quantile_interval
  - microergodic_error
group_by:
  - scenario_id
  - fit_request_id
```

### 6.2 Prediction summary

```yaml
summary_block_id: CT-SUMMARY-BLOCK-MATERN-PREDICTION-V1
summary_type: prediction_summary
metric_ids:
  - kriging_rmse
  - kriging_mae
  - log_score
group_by:
  - scenario_id
  - fit_request_id
  - evaluation_request_id
```

### 6.3 Uncertainty summary

```yaml
summary_block_id: CT-SUMMARY-BLOCK-MATERN-UNCERTAINTY-V1
summary_type: uncertainty_summary
metric_ids:
  - predictive_interval_coverage
  - interval_width
  - calibration_ratio
group_by:
  - scenario_id
  - fit_request_id
  - evaluation_request_id
```

### 6.4 Runtime summary

```yaml
summary_block_id: CT-SUMMARY-BLOCK-MATERN-RUNTIME-V1
summary_type: runtime_summary
metric_ids:
  - convergence_rate
  - hessian_failure_rate
  - runtime_seconds
group_by:
  - scenario_id
  - fit_request_id
```

### 6.5 Decision table

```yaml
summary_block_id: CT-SUMMARY-BLOCK-MATERN-DECISION-TABLE-V1
summary_type: decision_table
metric_ids:
  - kriging_rmse
  - predictive_interval_coverage
  - runtime_seconds
  - bias
group_by:
  - fit_request_id
```

## 7. Notes on intended extension

This first pattern is deliberately scoped to the **single-field Gaussian Matérn baseline**.

The same pattern structure should be reused for:

- product-domain truths,
- nonseparable space-time truths,
- distributionally misspecified truths,
- regularization studies,
- and product-domain shared-vs-distinct smoothness studies.

### Sibling pattern documents

- [CT_comp_ssmm_phase1_pattern.md](CT_comp_ssmm_phase1_pattern.md) — Comp-SSMM Phase 1 frequentist analysis pattern and basic Bayesian start (product-domain truth reuse of this structure).

## 8. Runs

Worked examples of the run-level objects defined in `CT_simulation_analysis_pattern_specs.md` §8.7. They correspond to one concrete execution of `CT-ANALYSIS-PATTERN-SIMULATION-MATERN-SINGLEFIELD-V1` against the `CT-PIPELINE-REGISTRY-V1` pipeline registry.

### 8.1 PatternRun

```yaml
pattern_run_id: CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001
pattern_id: CT-ANALYSIS-PATTERN-SIMULATION-MATERN-SINGLEFIELD-V1
started_at: "2026-04-10T09:14:02Z"
finished_at: "2026-04-10T11:47:51Z"
status: ok
# backend and runtime_profile_id MAY be a single string OR a nested
# mapping whose structure is a substructure of any ReplicationRun's
# bound_pipeline_ids under this PatternRun. Example of the nested form
# (commented out) that would pair a numpy truth factor with a jax fit:
#   backend:
#     truth:
#       block_spatial: numpy
#     fit: jax
#     evaluation: numpy
backend: numpy
runtime_profile_id: CT-RUNTIME-PROFILE-DENSE-CPU-V1
pipeline_registry_ref: CT-PIPELINE-REGISTRY-V1
manifest_ref:
  artifact_id: pattern_run_manifest
  artifact_type: run_manifest
  path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/manifest.json
  format: json
replication_run_refs:
  - artifact_id: replication_run_0001
    artifact_type: replication_run
    path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/replications/0001.json
    format: json
  - artifact_id: replication_run_0002
    artifact_type: replication_run
    path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/replications/0002.json
    format: json
extensions:
  profiler_mode: off
  resume_from: null
  shard_index: 0
```

### 8.2 ReplicationRun

```yaml
replication_run_id: CT-REPLICATION-RUN-R1-F1-E1-0001
pattern_run_id: CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001
scenario_id: CT-TRUTH-SCENARIO-MATERN-R1
fit_request_id: CT-FIT-REQ-MATERN-COV-CORRECT-FREE
evaluation_request_id: CT-PRED-REQ-PLUGIN-UNIVERSAL
replication_id: 1
# seed MAY be a single integer (runner fans it out deterministically
# across every role) OR a nested mapping whose structure is a
# substructure of bound_pipeline_ids. The nested form is how a
# replication carries per-role sub-seeds so that re-running just the
# fit role keeps the truth stream frozen. Example (commented out):
#   seed:
#     truth:
#       block_spatial: 10401001
#     fit: 20401001
#     evaluation: 30401001
seed: 10401001
bound_pipeline_ids:
  # Structured form: each role value MAY be a single pipeline_id OR a
  # nested mapping whose leaves are pipeline_ids. The single-block
  # Matérn truth below uses a one-leaf nested mapping; a space-time
  # product truth would instead carry something like
  #   truth:
  #     block_spatial: CT-PIPELINE-TRUTH-COV-CHOLESKY
  #     block_temporal: CT-PIPELINE-TRUTH-AR1-DIRECT
  # without any schema change to this file.
  truth:
    block_spatial: CT-PIPELINE-TRUTH-COV-CHOLESKY
  fit: CT-PIPELINE-COV-DENSE-CHOLESKY
  evaluation: CT-PIPELINE-PREDICTION-KRIGING-DENSE
run_manifest_refs:
  truth:
    block_spatial:
      artifact_id: truth_run_manifest_spatial
      artifact_type: run_manifest
      path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/replications/0001/truth/block_spatial/manifest.json
      format: json
  fit:
    artifact_id: fit_run_manifest
    artifact_type: run_manifest
    path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/replications/0001/fit/manifest.json
    format: json
  evaluation:
    artifact_id: evaluation_run_manifest
    artifact_type: run_manifest
    path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/replications/0001/evaluation/manifest.json
    format: json
per_replication_record_ref:
  artifact_id: per_replication_record_0001
  artifact_type: per_replication_record
  path: runs/CT-PATTERN-RUN-MATERN-SINGLEFIELD-2026-04-10-001/replication_table.parquet#row=0
  format: parquet_row
status_code: success
extensions:
  hessian_condition_number: 4.2e6
```
