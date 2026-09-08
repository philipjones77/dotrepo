# CT IO Objects

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
* `theory_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_io_specs.md`

**Is Relied Upon By:**

* (none)

Working instance library for CT IO artifacts and run manifests (v0.1.0).


## 0. Preamble

### 0.0 Call Registry
This file instantiates concrete working objects and assigns stable IDs for use by other components.

### 0.1 Type of file
`details`

### 0.2 Scope and Intent
Working library of instances for v0.1.x development. Instances are not exhaustive.

### 0.3 How to read this file
Each §1+ item is a self-contained instance with an ID and fields that satisfy the associated specification.

### 0.4 Summary of Assumptions and Preconditions
* Instances must conform to the corresponding `_specs.md` document.
* IDs are globally unique within the CT namespace.

### 0.5 Notation, Inputs and Aliases
* `id`: canonical identifier
* `alias`: short mnemonic for humans (optional)

### 0.6 Validation and Authority Rules

* If an instance conflicts with its spec, the spec prevails.
* Downstream users SHOULD treat these as examples and templates, not as the only options.

### 0.7 Template

Instances in Sections 1+ must conform to the schemas in `CT_io_specs.md`.

## 1. IO-RunManifest-Minimal

**id**: `IO-RunManifest-Minimal`  
**alias**: `IO-RM-Min`

**type**: `RunManifest`  
**fields**:
* `run_id`: `RUN-2026-01-07-0001`
* `created_at`: `2026-01-07T00:00:00Z`
* `spec_versions`: `{ "CT_io_specs.md": "v0.1.0" }`
* `resolved_ids`: `{ "model_id": "Model:St-SSGauGau-M", "kernel_id": "Kernel:ST-Matern-NS-01" }`
* `resolved_hashes`: `{ "model_id": "sha256:...", "kernel_id": "sha256:..." }`
* `backend`: `numpy`
* `device`: `CPU`
* `precision`: `float64`
* `rng`: `{ "seed": 12345, "rng_algorithm": "default" }`
* `artifacts`: `[ { "artifact_id": "A1", "artifact_type": "inference_fit", "path": "artifacts/inference_fit.json", "format": "json", "content_hash": "sha256:...", "created_at": "2026-01-07T00:00:01Z", "provenance": { "request_id": "INF-0001" } } ]`

## 2. IO-ArtifactRef-PosteriorSamples

**id**: `IO-ArtifactRef-PosteriorSamples`  
**alias**: `IO-PSamps`

**type**: `IOArtifactRef`  
**fields**:
* `artifact_id`: `A-POST-0001`
* `artifact_type`: `posterior_samples`
* `path`: `artifacts/posterior_samples.npz`
* `format`: `npz`
* `content_hash`: `sha256:...`
* `created_at`: `2026-01-07T00:10:00Z`
* `provenance`: `{ "fit_id": "FIT-0007", "model_id": "Model:St-SSGauGau-M" }`

## 3. IO-ArtifactRef-DomainSpec

**id**: `IO-Artifact-DomainSpec-01`

**type**: `IOArtifactRef`  
**fields**:
* `artifact_id`: `A-DOM-0001`
* `artifact_type`: `domain_spec`
* `path`: `artifacts/domains/domain_spacetime_sphere.json`
* `format`: `json`
* `content_hash`: `sha256:...`
* `created_at`: `2026-02-23T00:00:00Z`
* `provenance`: `{ "domain_id": "Domain:SphereTime-01" }`

## 4. IO-ArtifactRef-PointSet

**id**: `IO-Artifact-PointSet-01`

**type**: `IOArtifactRef`  
**fields**:
* `artifact_id`: `A-PTS-0001`
* `artifact_type`: `point_set`
* `path`: `artifacts/pointsets/pts_sphere_irregular.json`
* `format`: `json`
* `content_hash`: `sha256:...`
* `created_at`: `2026-02-23T00:00:00Z`
* `provenance`: `{ "domain_id": "Domain:SphereTime-01", "layout_kind": "irregular" }`

## 5. IO-ArtifactRef-LagFeatures

**id**: `IO-Artifact-LagFeatures-01`

**type**: `IOArtifactRef`  
**fields**:
* `artifact_id`: `A-LAG-0001`
* `artifact_type`: `lag_features`
* `path`: `artifacts/lags/lag_sphere_time.json`
* `format`: `json`
* `content_hash`: `sha256:...`
* `created_at`: `2026-02-23T00:00:00Z`
* `provenance`: `{ "domain_id": "Domain:SphereTime-01", "method_id": "auto" }`

## 6. IO-ArtifactRef-CovarianceMatrix

**id**: `IO-Artifact-CovMat-01`

**type**: `IOArtifactRef`  
**fields**:
* `artifact_id`: `A-COV-0001`
* `artifact_type`: `covariance_matrix`
* `path`: `artifacts/covariance/cov_sphere_time.npy`
* `format`: `npy`
* `content_hash`: `sha256:...`
* `created_at`: `2026-02-23T00:00:00Z`
* `provenance`: `{ "kernel_id": "Kernel:SphereTime-Gneiting-01", "method_id": "special_function_closed_form" }`

## 7. IO-ArtifactRef-ObservationStructure

**id**: `IO-Artifact-ObservationStructure-01`

**type**: `IOArtifactRef`
**fields**:
* `artifact_id`: `A-OBS-0001`
* `artifact_type`: `observation_structure`
* `path`: `artifacts/observations/obs_tensor_primary.json`
* `format`: `json`
* `content_hash`: `sha256:...`
* `created_at`: `2026-03-09T00:00:00Z`
* `provenance`: `{ "level_tag": "Level II", "observation_structure_id": "Obs:TensorPrimary-01", "pattern_type": "tensor_product" }`

## 8. IO-ArtifactRef-OperatorApplicationBatch

**id**: `IO-Artifact-OperatorBatch-01`

**type**: `IOArtifactRef`
**fields**:
* `artifact_id`: `A-OPB-0001`
* `artifact_type`: `operator_application_batch`
* `path`: `artifacts/operator_batches/op_batch_laplace_cached.npz`
* `format`: `npz`
* `content_hash`: `sha256:...`
* `created_at`: `2026-03-09T00:00:00Z`
* `provenance`: `{ "level_tag": "Level II", "selected_realization_mode": "cached_matvec", "mesh_state_override_blocks": ["surface"] }`

## X. Summary
* These instances illustrate minimal schema-complete objects for IO manifests and artifact references.
* Level II runtime-support artifacts are treated as first-class persisted objects.

