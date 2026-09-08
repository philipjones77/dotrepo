# CT Real Data Objects

---
*Status*: WORKING
*Version*: v1.1
*Date*: 2026-03-16
---

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_real_data_specs.md`

**Is Relied Upon By:**

* (none yet)

---

## 0. Preamble

### 0.1 Type of file

`details`

### 0.2 Scope and intent

This file provides non-normative example objects that conform to `CT_real_data_specs.md`.

The examples illustrate a first canonical real-data route:

* irregular space-time monitoring data,
* explicit statistical assessment,
* explicit visualization planning,
* and preparation for covariance-based Gaussian inference and kriging.

---

## 1. Example A — ozone monitoring data prepared for covariance-exact inference and kriging

### 1.1 `RealDataSpec`

```yaml
real_data_id: REALDATA:OZONE-ST-RAW-01
dataset_name: ozone_space_time_monitoring
data_status: ingested
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
raw_payload:
  payload_id: PAYLOAD:OZONE-ST-RAW-01
  observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
  value_layout: tabular_long
  value_dtype: float64
  ordering_convention: station_major_then_time
  value_shape: [18250, 8]
  response_field_names: [ozone]
  record_index_fields: [station_id, day]
  missing_value_policy: explicit_missing_rows_retained
  quality_flag_fields: [qa_flag]
  artifact_ref:
    artifact_id: ART:OZONE-ST-RAW-01
    artifact_type: real_data_table
    path: data/data_continuous/real_data/ozone_space_time/raw/ozone_long.parquet
    format: parquet
    content_hash: sha256:ozone-st-raw-01
    created_at: 2026-03-16T00:00:00Z
    provenance:
      source_kind: external_observational_dataset
      ingestion_run_id: RDINGEST:OZONE-01
response_schema:
  response_var_names: [ozone]
  response_target_kind: scalar
  measurement_scale: continuous
  response_units: [ppb]
  transform_status: raw
  censoring_policy: possible_detection_limit
coordinate_schema:
  coord_vars: [lon, lat, day]
  block_bindings:
    S1: [lon, lat]
    S2: [day]
  coord_units:
    lon: degrees_east
    lat: degrees_north
    day: day_index
  support_layout_kind: irregular
  ordering_convention: station_major_then_time
  time_index_kind: ordered_discrete_time
  duplicate_support_policy: unresolved_at_ingest
covariate_schema:
  covariates:
    - var_name: temperature
      role: mean_candidate
      units: celsius
      transform_status: raw
    - var_name: elevation
      role: mean_candidate
      units: meters
      transform_status: raw
measurement_schema:
  replicate_id_fields: [station_id, day, instrument_id]
  instrument_id_field: instrument_id
  quality_flag_fields: [qa_flag]
  detection_limit_field: dl_ppb
partition_schema:
  partitions:
    - partition_id: PART:TRAIN:2003-2005
      partition_role: training
      rule_summary: early years
    - partition_id: PART:VALID:2006
      partition_role: validation
      rule_summary: held-out final year
provenance:
  source_name: ozone_network_release
  source_version: v2026-01
  source_owner: external_provider
  ingestion_timestamp: 2026-03-16T00:00:00Z
notes:
  intended_use: first canonical CT real-data example
```

### 1.2 `RealDataAssessmentSpec`

```yaml
assessment_id: RDASSESS:OZONE-ST-BASE-01
real_data_id: REALDATA:OZONE-ST-RAW-01
assessment_checks:
  - check_id: CHK:OZONE:MISSING-01
    check_category: integrity
    check_kind: missingness
    target_fields: [ozone, lon, lat, day]
    support_scope: whole_dataset
    action_if_failed: modify
    thresholds:
      max_missing_fraction_response: 0.10
  - check_id: CHK:OZONE:DUPSUPPORT-01
    check_category: support
    check_kind: duplicate_support
    target_fields: [lon, lat, day]
    support_scope: whole_dataset
    action_if_failed: modify
  - check_id: CHK:OZONE:TAIL-01
    check_category: marginal
    check_kind: tail_heaviness
    target_fields: [ozone]
    support_scope: whole_dataset
    action_if_failed: warn
  - check_id: CHK:OZONE:TRANSFORM-01
    check_category: marginal
    check_kind: monotone_transform_suitability
    target_fields: [ozone]
    support_scope: whole_dataset
    action_if_failed: modify
  - check_id: CHK:OZONE:MEAN-01
    check_category: mean
    check_kind: trend_mean_structure
    target_fields: [ozone, temperature, elevation, day]
    support_scope: whole_dataset
    action_if_failed: modify
  - check_id: CHK:OZONE:SEASON-01
    check_category: mean
    check_kind: seasonality
    target_fields: [ozone, day]
    support_scope: by_partition
    action_if_failed: modify
  - check_id: CHK:OZONE:DEP-01
    check_category: dependence
    check_kind: empirical_dependence
    target_fields: [ozone, lon, lat, day]
    support_scope: whole_dataset
    action_if_failed: branch_methodology
  - check_id: CHK:OZONE:ANISO-01
    check_category: dependence
    check_kind: anisotropy_proxy
    target_fields: [ozone, lon, lat]
    support_scope: spatial_block
    action_if_failed: warn
  - check_id: CHK:OZONE:SEP-01
    check_category: dependence
    check_kind: separability_proxy
    target_fields: [ozone, lon, lat, day]
    support_scope: whole_dataset
    action_if_failed: warn
  - check_id: CHK:OZONE:NUGGET-01
    check_category: measurement
    check_kind: nugget_evidence
    target_fields: [ozone, lon, lat, day]
    support_scope: replicate_groups
    action_if_failed: warn
  - check_id: CHK:OZONE:READY-01
    check_category: readiness
    check_kind: exact_covariance_readiness
    target_fields: [ozone, lon, lat, day]
    support_scope: whole_dataset
    action_if_failed: branch_methodology
visualization_plan:
  - view_id: VIEW:OZONE:SUPPORT-01
    target_kind: pointset
    figure_kind: support_map
    target_fields: [lon, lat]
    artifact_required: true
  - view_id: VIEW:OZONE:COVERAGE-01
    target_kind: statistical_summary
    figure_kind: temporal_coverage
    target_fields: [day]
    artifact_required: true
  - view_id: VIEW:OZONE:MISS-01
    target_kind: statistical_summary
    figure_kind: missingness_summary
    target_fields: [ozone]
    artifact_required: true
  - view_id: VIEW:OZONE:HIST-01
    target_kind: statistical_summary
    figure_kind: response_distribution
    target_fields: [ozone]
    artifact_required: true
  - view_id: VIEW:OZONE:QQ-01
    target_kind: statistical_summary
    figure_kind: qq_or_normal_scores
    target_fields: [ozone]
    artifact_required: true
  - view_id: VIEW:OZONE:EMPDEP-01
    target_kind: result_summary
    figure_kind: empirical_dependence
    target_fields: [ozone, lon, lat, day]
    artifact_required: true
  - view_id: VIEW:OZONE:ANISO-01
    target_kind: result_summary
    figure_kind: anisotropy_view
    target_fields: [ozone, lon, lat]
    artifact_required: true
decision_policy:
  minimum_required_categories: [integrity, mean, dependence]
  fail_on: [invalid_domain_values, empty_response_after_filter]
artifact_policy:
  diagnostics_bundle_required: true
  figure_persistence_required: true
notes:
  intended_output: assessment bundle for route selection
```

### 1.3 `RealDataPreparationSpec`

```yaml
preparation_id: RDPREP:OZONE-ST-COVEXACT-01
real_data_id: REALDATA:OZONE-ST-RAW-01
assessment_id: RDASSESS:OZONE-ST-BASE-01
target_methodology:
  methodology_binding_id: MBIND:OZONE-ST-COVEXACT-01
  methodology_kind: covariance_exact
  target_model_id: HMMf5-GGZN-Base0
  target_representation_id: RF-COV-01
  target_objective_id: OBJ:NLL-GAUSS-EXACT-01
  target_observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
  required_layout_kind: irregular
  downstream_task_kinds: [frequentist_inference, kriging]
  required_assumptions:
    - residual-scale approximate second-order stationarity
    - explicit nugget allowance
    - Euclidean spatial metric on S1 and ordered time coordinate on S2
allowed_modification_classes:
  - metadata_only
  - record_filtering
  - replicate_aggregation
  - mean_structure_adjustment
  - support_reindexing
operations:
  - operation_id: OP:OZONE:UNITS-01
    operation_kind: harmonize_units
    input_fields: [ozone, temperature]
    output_fields: [ozone, temperature]
    modification_class: metadata_only
    provenance_required: true
    justification: ensure downstream parameter interpretation is consistent
  - operation_id: OP:OZONE:FILTER-01
    operation_kind: drop_invalid_records
    input_fields: [ozone, lon, lat, day, qa_flag]
    output_fields: [ozone, lon, lat, day]
    modification_class: record_filtering
    provenance_required: true
    justification: remove invalid or out-of-domain observations
    parameters:
      allowed_quality_flags: [0, 1]
  - operation_id: OP:OZONE:AGG-01
    operation_kind: aggregate_exact_replicates
    input_fields: [ozone, station_id, day]
    output_fields: [ozone]
    modification_class: replicate_aggregation
    provenance_required: true
    justification: duplicate support points should map to one prepared observation
    parameters:
      reducer: arithmetic_mean
  - operation_id: OP:OZONE:MEAN-01
    operation_kind: remove_mean_structure
    input_fields: [ozone, temperature, elevation, day]
    output_fields: [ozone_residual]
    modification_class: mean_structure_adjustment
    provenance_required: true
    justification: align prepared response with zero-mean covariance route
    parameters:
      mean_formula: ozone ~ temperature + elevation + seasonal_basis(day)
  - operation_id: OP:OZONE:ORDER-01
    operation_kind: reindex_support
    input_fields: [lon, lat, day, ozone_residual]
    output_fields: [record_id, ozone_residual]
    modification_class: support_reindexing
    provenance_required: true
    justification: construct deterministic runtime ordering for inference and kriging
notes:
  first_default_route: exact covariance likelihood with nugget
```

### 1.4 `PreparedRealDataSpec`

```yaml
prepared_real_data_id: PREPARED:OZONE-ST-COVEXACT-01
parent_real_data_id: REALDATA:OZONE-ST-RAW-01
preparation_id: RDPREP:OZONE-ST-COVEXACT-01
preparation_decision: ready_with_modifications
target_methodology:
  methodology_binding_id: MBIND:OZONE-ST-COVEXACT-01
  methodology_kind: covariance_exact
  target_model_id: HMMf5-GGZN-Base0
  target_representation_id: RF-COV-01
  target_objective_id: OBJ:NLL-GAUSS-EXACT-01
  target_observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
  required_layout_kind: irregular
  downstream_task_kinds: [frequentist_inference, kriging]
  required_assumptions:
    - residual-scale approximate second-order stationarity
    - explicit nugget allowance
prepared_payload:
  payload_id: PAYLOAD:OZONE-ST-PREP-01
  observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
  value_layout: dense_vector
  value_dtype: float64
  ordering_convention: record_id_station_major_then_time
  value_shape: [15432]
  response_field_names: [ozone_residual]
  record_index_fields: [record_id]
  missing_value_policy: no_missing_values
  artifact_ref:
    artifact_id: ART:OZONE-ST-PREP-01
    artifact_type: prepared_real_data_vector
    path: data/data_continuous/real_data/ozone_space_time/prepared/ozone_residual_vector.npz
    format: npz
    content_hash: sha256:ozone-st-prepared-01
    created_at: 2026-03-16T00:00:00Z
    provenance:
      parent_real_data_id: REALDATA:OZONE-ST-RAW-01
      preparation_id: RDPREP:OZONE-ST-COVEXACT-01
change_log:
  - operation_id: OP:OZONE:FILTER-01
    modification_class: record_filtering
    summary: invalid and failed-QA rows removed
  - operation_id: OP:OZONE:AGG-01
    modification_class: replicate_aggregation
    summary: exact replicates averaged within support points
  - operation_id: OP:OZONE:MEAN-01
    modification_class: mean_structure_adjustment
    summary: residual response constructed via explicit mean model
  - operation_id: OP:OZONE:ORDER-01
    modification_class: support_reindexing
    summary: deterministic runtime ordering added
readiness_summary:
  ready_for: [frequentist_inference, kriging]
  blocked_routes: []
  assumptions_checked:
    - exact_covariance_readiness
    - nugget_evidence
    - empirical_dependence
  comments: prepared object is the canonical downstream input
notes:
  canonical_use: first real-data covariance workflow
```
