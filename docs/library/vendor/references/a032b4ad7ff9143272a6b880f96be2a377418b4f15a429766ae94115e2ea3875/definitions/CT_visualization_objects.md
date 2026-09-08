# CT Visualization Objects

---
*Status*: WORKING
*Version*: v2.0
*Date*: 2026-02-23
---

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`

**Depends Upon:**

* `CT_visualization_specs.md`

**Is Relied Upon By:**

* (none)

This file provides working visualization instances aligned with `CT_visualization_specs.md`.

## 0. Preamble

### 0.1 Type of file

`details`

## 1. VisualizationRequest-PointSet-2D

**id**: `VizReq-PointSet-2D-01`

```yaml
request_id: VizReq-PointSet-2D-01
target_kind: pointset
figure_kind: scatter_2d
target_payload:
  points:
    - [0.0, 0.1]
    - [0.4, 0.7]
    - [0.9, 0.3]
title: "2D Point Set"
labels:
  x: "x"
  y: "y"
options:
  point_size: 24
  alpha: 0.8
```

## 2. VisualizationRequest-TriangularMesh

**id**: `VizReq-TriMesh-01`

```yaml
request_id: VizReq-TriMesh-01
target_kind: triangular_mesh
figure_kind: triplot
target_payload:
  nodes:
    - [0.0, 0.0]
    - [1.0, 0.0]
    - [0.0, 1.0]
    - [1.0, 1.0]
  cells:
    - [0, 1, 2]
    - [1, 3, 2]
title: "Triangular Mesh"
options:
  show_nodes: true
```

## 3. VisualizationRequest-CovarianceMatrix

**id**: `VizReq-CovMat-01`

```yaml
request_id: VizReq-CovMat-01
target_kind: covariance_matrix
figure_kind: heatmap
target_payload:
  matrix:
    - [1.0, 0.6, 0.2]
    - [0.6, 1.0, 0.4]
    - [0.2, 0.4, 1.0]
title: "Covariance Heatmap"
options:
  cmap: viridis
```

## 4. FigureArtifactRef-Example

**id**: `VizArtifact-01`

```yaml
artifact_id: artifact_viz_01
artifact_type: visualization_figure
path: runs/run_001/figures/covariance_heatmap.png
format: png
content_hash: sha256:...
created_at: 2026-02-16T00:00:00Z
provenance:
  run_id: run_001
  request_id: VizReq-CovMat-01
  figure_kind: heatmap
```

## 5. VisualizationRequest-RandomField

**id**: `VizReq-RandomField-01`

```yaml
request_id: VizReq-RandomField-01
target_kind: random_field
figure_kind: field_heatmap
target_payload:
  field:
    - [[0.1, 0.2], [0.3, 0.4]]
    - [[0.0, 0.1], [0.2, 0.2]]
title: "Random Field Realization"
options:
  realization_index: 0
  cmap: viridis
```

## 6. VisualizationRequest-StatisticalSummary

**id**: `VizReq-StatSummary-01`

```yaml
request_id: VizReq-StatSummary-01
target_kind: statistical_summary
figure_kind: hist_box_qq
target_payload:
  samples: [0.1, 0.2, -0.1, 0.0, 0.3, -0.2]
title: "Statistical Summary"
style_id: seaborn-darkgrid
```

## 7. VisualizationRequest-ArraySlice

**id**: `VizReq-ArraySlice-01`

```yaml
request_id: VizReq-ArraySlice-01
target_kind: array_slice
figure_kind: tensor_slice
target_payload:
  array:
    - [[0.0, 0.1], [0.2, 0.3]]
    - [[0.4, 0.5], [0.6, 0.7]]
title: "Tensor Slice"
options:
  axis: 0
  index: 1
```

## 8. VisualizationRequest-DomainPointSet-SphereTime

**id**: `VizReq-DomainPointSet-SphereTime-01`

```yaml
request_id: VizReq-DomainPointSet-SphereTime-01
target_kind: domain_pointset
figure_kind: multi_panel_scatter
target_payload:
  domain: "<Domain object: sphere × time>"
  points: "<PointSet or tuple of block arrays>"
title: "Sphere × Time PointSet"
```

## 9. VisualizationRequest-LagFeatures

**id**: `VizReq-LagFeatures-01`

```yaml
request_id: VizReq-LagFeatures-01
target_kind: lag_features
figure_kind: lag_histograms
target_payload:
  lag_features:
    block_names: [sphere, time]
    r:
      - [[0.0, 0.5], [0.5, 0.0]]
      - [[0.0, 1.0], [1.0, 0.0]]
    h:
      - null
      - [[[0.0], [1.0]], [[-1.0], [0.0]]]
title: "Lag Distributions"
options:
  bins: 30
```

## 10. VisualizationRequest-ObservationStructure

**id**: `VizReq-ObservationStructure-01`

```yaml
request_id: VizReq-ObservationStructure-01
target_kind: observation_structure
figure_kind: support_panel
target_payload:
  observation: "<FiniteObservationStructure runtime object>"
metadata:
  level_tag: Level II
  authority_refs:
    spec: CT_observation_structure_specs.md
    object: CT_observation_structure_objects.md
    contract: CT_observation_structure_contracts.md
```

## 11. VisualizationRequest-EvaluatedStructure

**id**: `VizReq-EvaluatedStructure-01`

```yaml
request_id: VizReq-EvaluatedStructure-01
target_kind: evaluated_structure
figure_kind: values_on_support
target_payload:
  observation: "<FiniteObservationStructure runtime object>"
  evaluated: "<EvaluatedStructure runtime object>"
metadata:
  level_tag: Level II
  backend: jax
  selected_realization_mode: cached_matvec
  mesh_state_override_blocks: [surface]
```

## 12. VisualizationRequest-MellinBarnesPoleMap

**id**: `VizReq-MellinBarnesPoleMap-01`

```yaml
request_id: VizReq-MellinBarnesPoleMap-01
target_kind: mellin_barnes_pole_map
figure_kind: pole_map
target_payload:
  variables:
    - name: s
      left:
        - label: Gamma(b + B s)
          b: 0.0
          B: 1.0
      right:
        - label: Gamma(1 - a - A s)
          a: 1.0
          A: 1.0
title: "Mellin-Barnes Pole Map"
options:
  k_max: 6
  crossing_tol: 1.0e-9
  resonance_tol: 1.0e-8
metadata:
  level_tag: Level III
  authority_refs:
    paper: Friot-Greynat-2011-arXiv-1107.0328
```

This view is the visualization-chapter bridge from Fox-H/Mellin-Barnes theory
to RF77 runtime decisions: it exposes which Gamma pole families are available,
where bounded residues collide, and where rational-spacing or integer-gap flags
warn that power-log terms or alternate residue sets may be needed.

## 13. VisualizationRequest-FoxHFunctionStory

**id**: `VizReq-FoxHFunctionStory-01`

```yaml
request_id: VizReq-FoxHFunctionStory-01
target_kind: foxh_function_story
figure_kind: story_panel
target_payload:
  function_id: foxh.matern.radial
  parameters:
    nu: 1.5
    kappa: 2.0
  hierarchy:
    ladder: M/S
    tier: FoxH-special-function
    route: Mellin-Barnes -> residue/contour -> Clenshaw pack
    domain: Euclidean radial
  regime:
    current_point:
      nu: 1.5
      kappa: 2.0
    cells:
      - label: rational-slope Matérn
        bounds:
          nu: [1.0, 2.0]
          kappa: [0.5, 4.0]
        residue_family: right
        convergence: safe
  samples:
    z: "<array-like argument grid>"
    values: "<array-like Fox-H values>"
    y_label: H(z)
  pole_spec:
    variables:
      - name: s
        left:
          - label: Gamma(b + B s)
            b: 0.0
            B: 1.0
        right:
          - label: Gamma(1 - a - A s)
            a: 1.0
            A: 1.0
title: "Fox-H Function Story"
options:
  k_max: 6
  log_abs: false
metadata:
  level_tag: Level III
  authority_refs:
    paper: Friot-Greynat-2011-arXiv-1107.0328
    memo: legacy memo foxh_covariance_precision_spec.md
```

This is the chapter-level view for a whole Fox-H function: one figure carries
RF77 hierarchy placement, parameter-regime placement, sampled function values,
and the Mellin-Barnes pole chart used to reason about residue switching.
