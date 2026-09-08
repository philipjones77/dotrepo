# CT_observation_structure_objects.md
---
*Status*: WORKING  
*Version*: v5.1  
*Date*: 2026-03-06  
---

## Base Documents
- `architecture.md`
- `project_overview.md`
- `CT_project_governance.md`
- `CT_dependency_governance.md`
- `spec_standard.md`
- `common_notation_objects.md`
- `CT_observation_structure_specs.md`
- `CT_observation_structure_contracts.md`

## 0. Scope

This file defines:
1. The objects-level registry of observation `pattern_id`s (structural, runtime-filled; non-generative).
2. The objects-level registry of boundary `pattern_id`s (structural, runtime-filled; derived-structure aware).
3. Composition rules for product/block domains (combination-first; do not enumerate combinations).
4. Runtime attachment conventions for one or more observation patterns on the same model.
5. Reserved slots for future combined (non-factorizing) patterns.

All runtime point payloads MUST satisfy the geometry-compatibility contracts in
`CT_observation_structure_contracts.md`.

No semantic interpretation of blocks is encoded here.

This file provides pattern registries only. It does not contain realized data payloads.
The intended observation-level variable is typically `Z`, but the same registry may be used for:

* standard latent-field-derived observation objects,
* other observable random objects declared by a model,
* attribute-space observations declared as separate runtime-attached patterns.

For any instantiated observation structure built from this registry:

* the product-manifold binding is fixed first,
* the selected observation pattern family is fixed at instantiation,
* the realized observation-point payload may change dynamically afterward,
* and the realized point count may either stay within fixed capacity or resize the storage shape, depending on the chosen runtime shape policy.

---

## 1. Runtime payload conventions (normative)

### 1.1 Core point support payload types

For each block alias `A_k` appearing in `domain_aliases = [A_1,...,A_K]`, runtime MUST provide exactly one of:

(P1) CoordinatePointSupport
- `coords[A_k]`: array of coordinates in the block’s declared coordinate representation
- `coord_system[A_k]`: identifier consistent with geometry object (`coord_rep_k`)
- `num_points_block[A_k]`: integer (or inferable)

(P2) IndexPointSupport
- `indices[A_k]`: integer ids indexing into the geometry object registry
- `index_kind[A_k]`: one of `vertex_id | face_id | cell_id | user_defined`
- `num_points_block[A_k]`: integer (or inferable)

(P3) ContinuousOnMeshSupport
- `face_ids[A_k]`: face indices for each point
- `barycentric[A_k]`: barycentric coordinates per face (or equivalent local coords)
- `num_points_block[A_k]`: integer

### 1.2 Derived structure names (controlled vocabulary)

Derived structures may be provided or deterministically derivable from runtime payload + `domain_geometry_ref`.

- `CHART_CONVERTER`
- `CELL_LOOKUP`
- `ADJACENCY`
- `SUBMESH_MEMBERSHIP`
- `WRAP_NORMALIZER`
- `IMPLICIT_FUNCTION_EVAL`
- `POLYTOPE_MEMBERSHIP`
- `INTERPOLATION_OPERATOR`
- `MASS_OR_WEIGHTS`

If a pattern requires a derived structure and it is neither provided nor derivable, the pattern MUST be rejected.

### 1.3 Eligibility flags (controlled vocabulary)

Downstream pipelines may switch on these flags:

- `FFT_ELIGIBLE`
- `KRONECKER_ELIGIBLE`
- `TOEPLITZ_ELIGIBLE`
- `CIRCULANT_ELIGIBLE`
- `FAST_NEIGHBOR_SEARCH`
- `SPARSE_PRECISION_ELIGIBLE`
- `FEM_OPERATOR_ELIGIBLE`
- `INTERPOLATION_REQUIRED`
- `TRIANGULATION_PRESENT`
- `SPHERICAL_TRIANGULATION_PRESENT`
- `MESH_PRESENT`
- `PATCH_MEMBERSHIP_PRESENT`

---

## 2. Observation Pattern Registry (structural; runtime-filled)

Patterns declare:
- allowed support type(s) (P1/P2/P3), subject to geometry contracts;
- `requires_runtime_fields` (beyond core P1/P2/P3);
- `requires_derived_structures` (must exist);
- `eligibility_flags` (downstream hints).

Patterns DO NOT generate points.

Recommended runtime attachment fields for any instantiated observation-structure object using this registry:

* `runtime_attachment_mode`: `single_pattern | multi_pattern`
* `observed_object_class`
* `observed_variable_id`
* `observation_patterns`: list of instantiated pattern references drawn from this registry
* `attribute_observation.enabled`
* `available_shape_policies`: subset of `{shape_stable, resize_allowed}`
* `selected_shape_policy`

### 2.1 Euclidean block patterns (aliases like `S_1`, `S_2`, ... when Euclidean)

PATTERN_EUCLIDEAN_ARBITRARY
- Allowed support: P1
- requires_runtime_fields: none
- requires_derived_structures: none
- eligibility_flags: none

PATTERN_EUCLIDEAN_CARTESIAN_GRID
- Allowed support: P1
- requires_runtime_fields:
  - `grid_axes[A_k]`: list of 1D coordinate arrays
  - `grid_shape[A_k]`: list[int]
  - `grid_ordering[A_k]`: `lex | colex`
- requires_derived_structures: none
- eligibility_flags:
  - `FFT_ELIGIBLE` (conditional on kernel/operator)
  - `KRONECKER_ELIGIBLE` (conditional on kernel/operator)

PATTERN_EUCLIDEAN_AFFINE_LATTICE
- Allowed support: P1
- requires_runtime_fields:
  - `lattice_origin[A_k]`
  - `lattice_basis[A_k]`
  - `lattice_indices[A_k]`: integer multi-indices per point
- requires_derived_structures: none
- eligibility_flags:
  - `FAST_NEIGHBOR_SEARCH` (conditional)

PATTERN_EUCLIDEAN_WITH_NEIGHBOR_GRAPH
- Allowed support: P1
- requires_runtime_fields:
  - `neighbor_graph[A_k]`: `edge_list | csr | csc`
  - `graph_semantics[A_k]`: `knn | radius | user_defined`
- requires_derived_structures: none
- eligibility_flags:
  - `SPARSE_PRECISION_ELIGIBLE`
  - `FAST_NEIGHBOR_SEARCH`

PATTERN_EUCLIDEAN_WITH_PARTITION
- Allowed support: P1
- requires_runtime_fields:
  - `partition_id[A_k]`: integer label per point
- requires_derived_structures: none
- eligibility_flags:
  - `FAST_NEIGHBOR_SEARCH` (conditional)

PATTERN_EUCLIDEAN_TRIANGULATION
- Allowed support: P2 or P3 (or P1 with CELL_LOOKUP provided), subject to geometry contracts
- requires_runtime_fields:
  - triangulation reference: `triangulation_ref[A_k]` OR `triangulation_runtime[A_k]` (V,F)
  - support attachment: `indices[A_k]` with `index_kind=vertex_id|face_id` OR (`face_ids[A_k]`, `barycentric[A_k]`)
- requires_derived_structures:
  - `ADJACENCY` (required for FEM/precision paths)
  - `CELL_LOOKUP` (required only if P1 coords are used)
- eligibility_flags:
  - `TRIANGULATION_PRESENT`
  - `FEM_OPERATOR_ELIGIBLE`
  - `INTERPOLATION_REQUIRED` (if P3)

---

### 2.2 Sphere block patterns (aliases like `SP1`, `SP2`, ...)

PATTERN_SPHERE_ARBITRARY
- Allowed support: P1
- requires_runtime_fields: none
- requires_derived_structures: none
- eligibility_flags: none

PATTERN_SPHERE_HIERARCHICAL_EQUAL_AREA
- Allowed support: P1 or P2, subject to geometry contracts
- requires_runtime_fields:
  - `hierarchy_level[SP*]`
  - if P2: `indices[SP*]` with `index_kind=user_defined` (cell id registry)
  - if P1: `cell_id[SP*]` per point
- requires_derived_structures:
  - `CELL_LOOKUP` (if P1 and `cell_id` not provided)
- eligibility_flags:
  - `FAST_NEIGHBOR_SEARCH` (conditional)
  - `PATCH_MEMBERSHIP_PRESENT` (conditional)

PATTERN_SPHERE_GEODESIC_REFINEMENT_GRID
- Allowed support: P1 or P2, subject to geometry contracts
- requires_runtime_fields:
  - `refinement_family[SP*]`
  - `refinement_level[SP*]`
- requires_derived_structures:
  - `ADJACENCY`
- eligibility_flags:
  - `FEM_OPERATOR_ELIGIBLE`
  - `FAST_NEIGHBOR_SEARCH`

PATTERN_SPHERE_PATCH_RESTRICTED
- Allowed support: P1 or P2, subject to geometry contracts
- requires_runtime_fields:
  - `base_pattern_id[SP*]`
  - `patch_membership_mask[SP*]`: boolean mask length n
- requires_derived_structures: none
- eligibility_flags:
  - `PATCH_MEMBERSHIP_PRESENT`

PATTERN_SPHERE_TRIANGULATION
- Allowed support: P2 or P3 (or P1 with CELL_LOOKUP provided), subject to geometry contracts
- requires_runtime_fields:
  - triangulation reference: `triangulation_ref[SP*]` OR `triangulation_runtime[SP*]` (V,F on sphere)
  - support attachment: `indices[SP*]` with `index_kind=vertex_id|face_id` OR (`face_ids[SP*]`, `barycentric[SP*]`)
- requires_derived_structures:
  - `ADJACENCY`
  - `CHART_CONVERTER` (conditional)
  - `CELL_LOOKUP` (required only if P1 coords are used)
- eligibility_flags:
  - `SPHERICAL_TRIANGULATION_PRESENT`
  - `FEM_OPERATOR_ELIGIBLE`
  - `INTERPOLATION_REQUIRED` (if P3)

---

### 2.3 Torus block patterns (aliases like `TR`, `TR1`, ...)

PATTERN_TORUS_ARBITRARY
- Allowed support: P1
- requires_runtime_fields: none
- requires_derived_structures:
  - `WRAP_NORMALIZER` (required if coords use wrapped conventions)
- eligibility_flags: none

PATTERN_TORUS_TENSOR_GRID
- Allowed support: P1
- requires_runtime_fields:
  - `grid_axes[TR*]`
  - `grid_shape[TR*]`
  - `grid_ordering[TR*]`
- requires_derived_structures:
  - `WRAP_NORMALIZER`
- eligibility_flags:
  - `CIRCULANT_ELIGIBLE` (conditional)
  - `FFT_ELIGIBLE` (conditional)
  - `KRONECKER_ELIGIBLE` (conditional)

---

### 2.4 Mesh / embedded manifold patterns (aliases like `Human`, `Mesh1`, ...)

PATTERN_MESH_VERTEX_SUPPORT
- Allowed support: P2 (`index_kind=vertex_id`)
- requires_runtime_fields:
  - `indices[Mesh*]`
- requires_derived_structures:
  - `ADJACENCY` (required for sparse precision / FEM paths)
- eligibility_flags:
  - `MESH_PRESENT`
  - `SPARSE_PRECISION_ELIGIBLE`
  - `FEM_OPERATOR_ELIGIBLE`

PATTERN_MESH_FACE_SUPPORT
- Allowed support: P2 (`index_kind=face_id`)
- requires_runtime_fields:
  - `indices[Mesh*]`
- requires_derived_structures: none
- eligibility_flags:
  - `MESH_PRESENT`

PATTERN_MESH_CONTINUOUS_SUPPORT
- Allowed support: P3
- requires_runtime_fields:
  - `face_ids[Mesh*]`
  - `barycentric[Mesh*]`
- requires_derived_structures:
  - `INTERPOLATION_OPERATOR`
- eligibility_flags:
  - `MESH_PRESENT`
  - `INTERPOLATION_REQUIRED`

---

### 2.5 Universal mesh observation operator pattern (all manifold types)

PATTERN_MANIFOLD_MESH_OPERATOR
- Applicable aliases: any (`S_1`, `SP1`, `TR`, `Human`, ...)
- Allowed support: P2 or P3
- requires_runtime_fields:
  - mesh reference: `mesh_ref[A_k]` OR `mesh_runtime[A_k]`
  - support attachment: `indices[A_k]` with `index_kind ∈ (vertex_id, face_id, cell_id)` OR (`face_ids[A_k]`, `barycentric[A_k]`)
- requires_derived_structures:
  - `ADJACENCY` (required for sparse precision / FEM paths)
  - `INTERPOLATION_OPERATOR` (required if P3)
  - `MASS_OR_WEIGHTS` (required if operator_type is `cell_average` or weighted aggregation)
- eligibility_flags:
  - `MESH_PRESENT`
  - `SPARSE_PRECISION_ELIGIBLE` (conditional)
  - `FEM_OPERATOR_ELIGIBLE`
  - `INTERPOLATION_REQUIRED` (if P3)

---

### 2.6 Attribute-space observation patterns

These patterns are used when the observed object is an attribute-space object rather than a direct product-domain observation payload.

PATTERN_ATTRIBUTE_POINT_EVALUATION
- Allowed support: P1 or P2, subject to the supporting domain/attribute map contracts
- requires_runtime_fields:
  - `attribute_space_id`
  - `attribute_map_ref`
  - `attribute_channel_id` or equivalent observable selector
- requires_derived_structures:
  - `INTERPOLATION_OPERATOR` (conditional)
- eligibility_flags:
  - `INTERPOLATION_REQUIRED` (conditional)

PATTERN_ATTRIBUTE_AGGREGATE
- Allowed support: P1, P2, or P3
- requires_runtime_fields:
  - `attribute_space_id`
  - `attribute_map_ref`
  - `aggregation_rule`
  - optional `aggregation_weights`
- requires_derived_structures:
  - `MASS_OR_WEIGHTS` (conditional)
- eligibility_flags:
  - `INTERPOLATION_REQUIRED` (conditional)

PATTERN_ATTRIBUTE_PROJECTION
- Allowed support: P1 or P3
- requires_runtime_fields:
  - `attribute_space_id`
  - `attribute_projection_id`
  - `attribute_projection_params`
- requires_derived_structures:
  - `INTERPOLATION_OPERATOR` (conditional)
- eligibility_flags:
  - `INTERPOLATION_REQUIRED` (conditional)

---

## 3. Product/block composition patterns (combination-first; do not enumerate)

A product/block observation pattern is either:
1. a combination of per-block patterns plus an index coupling rule (defined here), or
2. a combined (non-factorizing) pattern (reserved; defined later).

All combinations of per-block patterns are permitted and treated as existing.

PATTERN_PRODUCT_CARTESIAN_COMPOSITION
- Meaning: global support is the Cartesian product of per-block supports.
- requires_runtime_fields:
  - `block_patterns`: mapping `A_k -> per-block pattern_id`
  - `product_ordering`: `lex_by_alias_order` (default) or explicit `multi_index_map`
- requires_derived_structures: none
- eligibility_flags:
  - `KRONECKER_ELIGIBLE` (conditional)

PATTERN_PRODUCT_PAIRED_INDEXWISE_COMPOSITION
- Meaning: indexwise pairing across blocks (shared i).
- requires_runtime_fields:
  - `block_patterns`
  - `pairing_index` (optional if arrays are explicitly aligned)
- requires_derived_structures: none
- eligibility_flags: none

PATTERN_PRODUCT_GENERAL_INCIDENCE_COMPOSITION
- Meaning: arbitrary coupling described by an incidence map.
- requires_runtime_fields:
  - `block_patterns`
  - `incidence_map` (explicit)
- requires_derived_structures: none
- eligibility_flags: none

Reserved: combined (non-factorizing) observation patterns will be defined later.

---

## 3A. Runtime attachment composition conventions

The following conventions govern how instantiated observation-structure objects may attach one or more patterns to a model runtime.

ATTACHMENT_SINGLE_PRIMARY
- Meaning: one primary observation pattern is attached for one observed variable (typically `Z`).
- required runtime fields:
  - `runtime_attachment_mode=single_pattern`
  - `observed_variable_id`
  - one pattern with `pattern_role=primary_observation`

ATTACHMENT_MULTI_PATTERN
- Meaning: more than one observation pattern is attached to the same model runtime.
- required runtime fields:
  - `runtime_attachment_mode=multi_pattern`
  - `observed_variable_id`
  - `observation_patterns` with distinct `pattern_role` assignments
- intended use:
  - primary plus auxiliary observation views of `Z`
  - observation of more than one observable random object
  - separate attribute-space observation attached alongside product-domain observation

ATTACHMENT_ATTRIBUTE_SEPARATE
- Meaning: attribute-space observation is attached as a distinct pattern family, not merged into the primary product-domain pattern.
- required runtime fields:
  - `attribute_observation.enabled=true`
  - `attribute_space_id`
  - one attribute pattern id from Section 2.6

---

## 4. Boundary Registry (structural; runtime-filled; derived-structure aware)

### 4.1 Boundary capability flags (controlled vocabulary)
- `FAST_MEMBERSHIP_TEST`
- `FAST_MEMBERSHIP_WITH_INDEX`
- `REQUIRES_CHART_CONVERSION`
- `REQUIRES_CELL_LOOKUP`
- `REQUIRES_GEODESIC_DISTS`
- `PROJECTION_AVAILABLE`
- `MESH_REGISTRY_LOOKUP`

### 4.2 Boundary derived-structure names (controlled vocabulary)
- `CHART_CONVERTER`
- `CELL_LOOKUP`
- `ADJACENCY`
- `SUBMESH_MEMBERSHIP`
- `WRAP_NORMALIZER`
- `IMPLICIT_FUNCTION_EVAL`
- `POLYTOPE_MEMBERSHIP`

### 4.3 Euclidean boundary patterns

BOUNDARY_EUCLIDEAN_BOX
- Allowed support: P1
- requires_runtime_fields: `box_min[A_k]`, `box_max[A_k]`
- requires_derived_structures: none
- eligibility_flags: `FAST_MEMBERSHIP_TEST`, `PROJECTION_AVAILABLE` (if semantics is `clip`)

BOUNDARY_EUCLIDEAN_HALFSPACE_INTERSECTION
- Allowed support: P1
- requires_runtime_fields: `A_matrix[A_k]`, `b_vector[A_k]`
- requires_derived_structures: none
- eligibility_flags: `FAST_MEMBERSHIP_TEST`

BOUNDARY_EUCLIDEAN_POLYTOPE_VREP
- Allowed support: P1
- requires_runtime_fields: `vertices[A_k]`
- requires_derived_structures: `POLYTOPE_MEMBERSHIP`
- eligibility_flags: `FAST_MEMBERSHIP_TEST` (only if accelerator available)

BOUNDARY_EUCLIDEAN_LEVEL_SET
- Allowed support: P1
- requires_runtime_fields: `level_set_id[A_k]`, `level_set_params[A_k]`, `level_set_convention[A_k]`
- requires_derived_structures: `IMPLICIT_FUNCTION_EVAL`
- eligibility_flags: `FAST_MEMBERSHIP_TEST` (conditional)

---

### 4.4 Sphere boundary patterns

BOUNDARY_SPHERE_CAP
- Allowed support: P1
- requires_runtime_fields: `cap_center[SP*]`, `cap_angle[SP*]`
- requires_derived_structures: `CHART_CONVERTER` (conditional)
- eligibility_flags: `FAST_MEMBERSHIP_TEST`, `REQUIRES_CHART_CONVERSION` (conditional)

BOUNDARY_SPHERE_LATLON_WINDOW
- Allowed support: P1
- requires_runtime_fields: `lat_range[SP*]`, `lon_range[SP*]`, `wrap_convention[SP*]`
- requires_derived_structures: `WRAP_NORMALIZER`, `CHART_CONVERTER` (conditional)
- eligibility_flags: `FAST_MEMBERSHIP_TEST`, `REQUIRES_CHART_CONVERSION` (conditional)

BOUNDARY_SPHERE_TESSELLATION_CELL_SET
- Allowed support: P2 or P1 with lookup
- requires_runtime_fields: `cell_ids_allowed[SP*]`
- requires_derived_structures: `CELL_LOOKUP` (conditional)
- eligibility_flags: `FAST_MEMBERSHIP_WITH_INDEX` (if P2), `REQUIRES_CELL_LOOKUP` (conditional)

---

### 4.5 Torus boundary patterns

BOUNDARY_TORUS_ANGULAR_WINDOW
- Allowed support: P1
- requires_runtime_fields: `angle_ranges[TR*]`, `wrap_convention[TR*]`
- requires_derived_structures: `WRAP_NORMALIZER`, `CHART_CONVERTER` (conditional)
- eligibility_flags: `FAST_MEMBERSHIP_TEST`, `REQUIRES_CHART_CONVERSION` (conditional)

BOUNDARY_TORUS_CELL_SET
- Allowed support: P2 or P1 with lookup
- requires_runtime_fields: `cell_ids_allowed[TR*]`
- requires_derived_structures: `CELL_LOOKUP` (conditional)
- eligibility_flags: `FAST_MEMBERSHIP_WITH_INDEX` (if P2), `REQUIRES_CELL_LOOKUP` (conditional)

---

### 4.6 Mesh boundary patterns

BOUNDARY_MESH_VERTEX_SET
- Allowed support: P2 (`vertex_id`)
- requires_runtime_fields: `vertex_ids_allowed[Mesh*]`
- requires_derived_structures: none
- eligibility_flags: `FAST_MEMBERSHIP_WITH_INDEX`

BOUNDARY_MESH_FACE_SET
- Allowed support: P2 (`face_id`) or P3
- requires_runtime_fields: `face_ids_allowed[Mesh*]`
- requires_derived_structures: none
- eligibility_flags: `FAST_MEMBERSHIP_WITH_INDEX`

BOUNDARY_MESH_SUBMESH_ID
- Allowed support: P2 or P3
- requires_runtime_fields: `submesh_id[Mesh*]`
- requires_derived_structures: `SUBMESH_MEMBERSHIP`
- eligibility_flags: `MESH_REGISTRY_LOOKUP`

---

### 4.7 Universal boundary: external membership mask

BOUNDARY_EXTERNAL_POINT_MASK
- Allowed support: any
- requires_runtime_fields: `mask`
- requires_derived_structures: none
- eligibility_flags: `FAST_MEMBERSHIP_WITH_INDEX`

---

### 4.8 Product/block boundaries (composition-first; do not enumerate)

All combinations of per-block boundary patterns are permitted and treated as existing.

BOUNDARY_PRODUCT_INTERSECTION_COMPOSITION
- requires_runtime_fields: `block_boundaries`, `enclosure_semantics`
- requires_derived_structures: none
- eligibility_flags: union of per-block flags

Reserved: combined (non-factorizing) product boundaries will be defined later.

---

## 5. Concrete ObservationStructure objects

The following objects are non-normative examples of instantiated observation-pattern objects
that conform to `CT_observation_structure_specs.md`.

### 5.1 Single-pattern observation of `Z`

OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
- `observation_structure_id`: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
- `observation_structure_name`: Irregular point-evaluation observation of Z
- `design_purpose`: inference
- `runtime_attachment_mode`: single_pattern
- `observed_object_class`: observation_level_random_object
- `observed_variable_id`: Z
- `model_domain`:
  - `block_count`: K
- `observation_patterns`:
  - pattern 1:
    - `pattern_id`: PATTERN_PRODUCT_PAIRED_INDEXWISE_COMPOSITION
    - `operator_type`: point_evaluation
    - `observation_domain`:
      - `block_count`: K
      - `map_type`: identity
    - `required_runtime_structures`: []
    - `pattern_role`: primary_observation
    - `block_patterns`:
      - `A_1 -> PATTERN_EUCLIDEAN_ARBITRARY`
      - `A_2 -> PATTERN_TORUS_ARBITRARY`
- `point_support`:
  - `support_type`: irregular
  - `representation_type`: blockwise_arrays
  - `points_provided_at_runtime`: true
  - `available_shape_policies`: [shape_stable, resize_allowed]
  - `selected_shape_policy`: runtime_declared
- `attribute_observation`:
  - `enabled`: false
- `replicates`:
  - `replicates_present`: false

### 5.2 Multi-pattern observation attached to the same `Z`

OBSSTRUCT_Z_PRIMARY_PLUS_AUXILIARY
- `observation_structure_id`: OBSSTRUCT_Z_PRIMARY_PLUS_AUXILIARY
- `observation_structure_name`: Primary plus auxiliary observation patterns for Z
- `design_purpose`: benchmarking
- `runtime_attachment_mode`: multi_pattern
- `observed_object_class`: observation_level_random_object
- `observed_variable_id`: Z
- `model_domain`:
  - `block_count`: K
- `observation_patterns`:
  - pattern 1:
    - `pattern_id`: PATTERN_PRODUCT_PAIRED_INDEXWISE_COMPOSITION
    - `operator_type`: point_evaluation
    - `observation_domain`:
      - `block_count`: K
      - `map_type`: identity
    - `required_runtime_structures`: []
    - `pattern_role`: primary_observation
    - `block_patterns`:
      - `A_1 -> PATTERN_SPHERE_ARBITRARY`
      - `A_2 -> PATTERN_EUCLIDEAN_ARBITRARY`
  - pattern 2:
    - `pattern_id`: PATTERN_PRODUCT_CARTESIAN_COMPOSITION
    - `operator_type`: cell_average
    - `observation_domain`:
      - `block_count`: K
      - `map_type`: identity
    - `required_runtime_structures`:
      - MASS_OR_WEIGHTS
    - `pattern_role`: auxiliary_observation
    - `block_patterns`:
      - `A_1 -> PATTERN_SPHERE_GEODESIC_REFINEMENT_GRID`
      - `A_2 -> PATTERN_EUCLIDEAN_CARTESIAN_GRID`
- `point_support`:
  - `support_type`: hybrid
  - `representation_type`: blockwise_arrays
  - `points_provided_at_runtime`: true
  - `available_shape_policies`: [shape_stable, resize_allowed]
  - `selected_shape_policy`: runtime_declared
- `attribute_observation`:
  - `enabled`: false
- `replicates`:
  - `replicates_present`: true
  - `replicate_axis_name`: replicate_id
  - `replicate_counts`: runtime_defined
  - `replicate_independence_assumption`: conditionally_independent_given_latent

### 5.3 Separate attribute-space observation pattern

OBSSTRUCT_ATTRIBUTE_CHANNEL
- `observation_structure_id`: OBSSTRUCT_ATTRIBUTE_CHANNEL
- `observation_structure_name`: Attribute-space observation attached separately from product-domain observation
- `design_purpose`: prediction
- `runtime_attachment_mode`: multi_pattern
- `observed_object_class`: attribute_space_object
- `observed_variable_id`: Z_attr
- `model_domain`:
  - `block_count`: K
- `observation_patterns`:
  - pattern 1:
    - `pattern_id`: PATTERN_ATTRIBUTE_POINT_EVALUATION
    - `operator_type`: attribute_projection
    - `observation_domain`:
      - `block_count`: K
      - `map_type`: attribute_map
    - `required_runtime_structures`:
      - INTERPOLATION_OPERATOR
    - `pattern_role`: attribute_observation
- `point_support`:
  - `support_type`: irregular
  - `representation_type`: blockwise_arrays
  - `points_provided_at_runtime`: true
  - `available_shape_policies`: [shape_stable, resize_allowed]
  - `selected_shape_policy`: runtime_declared
- `attribute_observation`:
  - `enabled`: true
  - `attribute_space_id`: X_attribute_space
  - `attribute_pattern_id`: PATTERN_ATTRIBUTE_POINT_EVALUATION
  - `attribute_operator_type`: attribute_projection
- `replicates`:
  - `replicates_present`: false

### 5.4 Observation of another observable random object

OBSSTRUCT_ETA_MONITOR
- `observation_structure_id`: OBSSTRUCT_ETA_MONITOR
- `observation_structure_name`: Monitoring pattern for observable random mean object eta
- `design_purpose`: simulation
- `runtime_attachment_mode`: single_pattern
- `observed_object_class`: other_random_object
- `observed_variable_id`: eta
- `model_domain`:
  - `block_count`: K
- `observation_patterns`:
  - pattern 1:
    - `pattern_id`: PATTERN_PRODUCT_PAIRED_INDEXWISE_COMPOSITION
    - `operator_type`: linear_functional
    - `observation_domain`:
      - `block_count`: K
      - `map_type`: identity
    - `required_runtime_structures`: []
    - `pattern_role`: primary_observation
    - `block_patterns`:
      - `A_1 -> PATTERN_EUCLIDEAN_WITH_NEIGHBOR_GRAPH`
- `point_support`:
  - `support_type`: irregular
  - `representation_type`: blockwise_arrays
  - `points_provided_at_runtime`: true
  - `available_shape_policies`: [shape_stable, resize_allowed]
  - `selected_shape_policy`: runtime_declared
- `attribute_observation`:
  - `enabled`: false
- `replicates`:
  - `replicates_present`: false
