# Asymptotic Support Objects (CT)

---
*Status*: WORKING
*Version*: v3.0
*Date*: 2026-03-16

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `theory_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_asymptotic_specs.md`
* `CT_manifold_geometry_objects.md`
* `CT_observation_structure_objects.md`
* `CT_boundary_layer_objects.md`

**Is Relied Upon By:**

* downstream observation, simulation, inference, prediction, and diagnostics objects that need concrete stage-wise fill policies

---

## 0. Preamble

### 0.0 Summary of Contents

1. Purpose and role of asymptotic objects  
2. Single-block fixed-support examples  
3. Single-block increasing-support examples  
4. Product-domain examples  
5. Moving-boundary example  
6. Copy/paste templates

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

This file provides **non-normative** concrete asymptotic-support objects that instantiate the schema in `CT_asymptotic_specs.md`.

The emphasis is operational:

* what happens to the points,
* what happens to the support bounds,
* what happens to the boundary,
* and what runtime payload must be filled at each stage.

### 0.3 How to read this file

* Sections 1–5 contain example YAML descriptors.
* Section 6 contains copy/paste templates.
* The mathematical semantics and validation rules remain authoritative in `CT_asymptotic_specs.md`.

### 0.4 Summary of Assumptions and Preconditions

* The domain is supplied at runtime or is already runtime-instantiated.
* The observation structure is fixed first.
* Pattern IDs and operator types remain fixed across stage $n$.
* Only realized support payloads, counts, bounds, masks, and capacities may vary across stage $n$.

### 0.5 Notation, Inputs and Aliases

* These objects use `block_index` rather than a hard-coded runtime alias because the bound domain is supplied at runtime.
* Where needed, comments indicate the intended manifold type of each block.

### 0.6 Validation and Authority Rules

* This file is **non-normative** and MUST NOT redefine the meanings in `CT_asymptotic_specs.md`.
* Observation-structure IDs and boundary-layer IDs referenced here are existing object-level IDs from the upstream object catalogs.

---

## 1. Single-block fixed-support examples

### 1.1 Euclidean fixed-support infill with fixed blockwise boundary

```yaml
asymptotic_descriptor_id: CT-ASY-EUCLIDEAN-FD-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n = 1"
    fill_distance_sequence: "h_n -> 0"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: irregular
    runtime_fill_requirements:
      - "block_points[1] at stage n"
      - "current point count on block 1"
      - "fixed support bounds for block 1 supplied once or inherited from the bound domain"
    block_notes:
      - intended for a Euclidean block with irregular point evaluation
boundary_asymptotics:
  boundary_present: true
  boundary_source: boundary_layer
  boundary_layer_id: BND-LAYER-BLOCK-01
  boundary_scope: blockwise_tensor
  boundary_geometry_behavior: fixed
  boundary_point_count_behavior: fixed
  active_boundary_behavior: changing_active_subset
  boundary_condition_behavior: fixed
  boundary_input_route: blockwise_boundary_payload
  boundary_available_shape_policies: [shape_stable, resize_allowed]
  boundary_selected_shape_policy_behavior: runtime_declared
  boundary_capacity_behavior: runtime_declared
  boundary_runtime_fill_requirements:
    - "blockwise boundary payload for block 1"
    - "active_mask and active_boundary_count when the active subset changes"
  boundary_notes:
    - fixed enclosure, changing active subset allowed
notes:
  - more points are added inside a fixed Euclidean support
```

### 1.2 Sphere fixed-support geodesic infill

```yaml
asymptotic_descriptor_id: CT-ASY-SPHERE-FD-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable]
selected_shape_policy_behavior: shape_stable
capacity_behavior: fixed_capacity
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: NA
    fill_distance_sequence: "h_n -> 0 under the inherited geodesic metric"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: quasi_uniform
    runtime_fill_requirements:
      - "block_points[1] on the fixed sphere support"
      - "active point count within fixed capacity"
    block_notes:
      - intended for a sphere block with geodesic distance
notes:
  - compact block; no increasing-domain interpretation is used
```

### 1.3 Torus fixed-support wrapped-metric infill

```yaml
asymptotic_descriptor_id: CT-ASY-TORUS-FD-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: NA
    fill_distance_sequence: "h_n -> 0 under the inherited wrapped torus metric"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: regular_grid
    runtime_fill_requirements:
      - "block_points[1] or pointset_generator_spec for the torus grid"
      - "current point count on block 1"
    block_notes:
      - intended for a torus block
notes:
  - fixed periodic support, denser realized torus support at larger n
```

### 1.4 Human-manifold / mesh-native refinement infill

```yaml
asymptotic_descriptor_id: CT-ASY-HUMAN-FD-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: NA
    fill_distance_sequence: "h_n -> 0 under the inherited mesh-geodesic metric"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: mesh_refinement
    runtime_fill_requirements:
      - "indices[1] or face_ids[1], barycentric[1] at stage n"
      - "current point count on block 1"
      - "if refinement changes the active mesh support, updated support payload"
    block_notes:
      - intended for a human_manifold or triangular_mesh block
boundary_asymptotics:
  boundary_present: true
  boundary_source: boundary_layer
  boundary_layer_id: BND-LAYER-BLOCK-01
  boundary_scope: blockwise_tensor
  boundary_geometry_behavior: fixed
  boundary_point_count_behavior: fixed
  active_boundary_behavior: changing_active_subset
  boundary_condition_behavior: changing_within_declared_labels
  boundary_input_route: mesh_facet_derived
  boundary_available_shape_policies: [shape_stable, resize_allowed]
  boundary_selected_shape_policy_behavior: runtime_declared
  boundary_capacity_behavior: runtime_declared
  boundary_runtime_fill_requirements:
    - "mesh boundary facets or nodes for block 1"
    - "condition_codes when active boundary labels change"
  boundary_notes:
    - fixed mesh support with possibly changing active boundary labels
notes:
  - the manifold geometry is fixed; refinement occurs in the realized support or its mesh resolution
```

---

## 2. Single-block increasing-support examples

### 2.1 Euclidean balanced increasing-support regime

```yaml
asymptotic_descriptor_id: CT-ASY-EUCLIDEAN-ED-BALANCED-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [resize_allowed]
selected_shape_policy_behavior: resize_allowed
capacity_behavior: nondecreasing_capacity
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: ED_BALANCED
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: increasing
    sampling_support: expanding_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n -> infinity"
    fill_distance_sequence: "h_n -> 0 and eta_n = L_n h_n -> c in (0, infinity)"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: irregular
    runtime_fill_requirements:
      - "block_points[1] at stage n"
      - "updated support bounds for block 1"
      - "updated current point count on block 1"
    block_notes:
      - intended for a Euclidean block whose support expands and whose local resolution improves in balance
boundary_asymptotics:
  boundary_present: true
  boundary_source: boundary_layer
  boundary_layer_id: BND-LAYER-BLOCK-01
  boundary_scope: blockwise_tensor
  boundary_geometry_behavior: increasing
  boundary_point_count_behavior: nondecreasing
  active_boundary_behavior: changing_active_subset
  boundary_condition_behavior: fixed
  boundary_input_route: blockwise_boundary_payload
  boundary_available_shape_policies: [resize_allowed]
  boundary_selected_shape_policy_behavior: resize_allowed
  boundary_capacity_behavior: nondecreasing_capacity
  boundary_runtime_fill_requirements:
    - "updated boundary payload for the expanding Euclidean support"
    - "updated active_mask and active_boundary_count"
  boundary_notes:
    - the enclosure expands with the support
notes:
  - balanced increasing-domain asymptotics on a Euclidean block
```

---

## 3. Product-domain examples

### 3.1 Two-block Euclidean product: expanding block 1 and fixed-support infill on block 2

```yaml
asymptotic_descriptor_id: CT-ASY-PROD-EUCLIDEAN-MIXED-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: ED_BALANCED
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: increasing
    sampling_support: expanding_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n^(1) -> infinity"
    fill_distance_sequence: "h_n^(1) -> 0 with eta_n^(1) -> c_1 in (0, infinity)"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: irregular
    runtime_fill_requirements:
      - "block_points[1] at stage n"
      - "updated support bounds for block 1"
  - block_index: 2
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n^(2) = 1"
    fill_distance_sequence: "h_n^(2) -> 0"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: regular_grid
    runtime_fill_requirements:
      - "block_points[2] or pointset_generator_spec for block 2"
      - "current point count on block 2"
relative_rate_map:
  - relation_id: PROD-E1-E2-01
    block_i: 1
    block_j: 2
    domain_growth_relation: block_1_dominates
    resolution_relation: Not Known
notes:
  - valid mixed product-domain asymptotics with one expanding Euclidean block and one fixed-support infill Euclidean block
```

### 3.2 Sphere × Euclidean product with fixed sphere infill and temporal infill

```yaml
asymptotic_descriptor_id: CT-ASY-PROD-SPHERE-EUCLIDEAN-01
observation_structure_id: OBSSTRUCT_Z_PRIMARY_PLUS_AUXILIARY
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: NA
    fill_distance_sequence: "h_n -> 0 under sphere geodesic distance"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: quasi_uniform
    runtime_fill_requirements:
      - "block_points[1] or generator-derived points on the sphere"
  - block_index: 2
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n = 1"
    fill_distance_sequence: "h_n -> 0"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: regular_grid
    runtime_fill_requirements:
      - "block_points[2] or pointset_generator_spec on the fixed Euclidean block"
notes:
  - compact-first mixed product with fixed support on both blocks and denser support through n
```

### 3.3 Human-manifold × Euclidean product with mesh refinement and increasing Euclidean horizon

```yaml
asymptotic_descriptor_id: CT-ASY-PROD-HUMAN-EUCLIDEAN-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: NA
    fill_distance_sequence: "h_n -> 0 under mesh-geodesic refinement"
    minimum_separation_behavior: comparable_to_fill_distance
    design_regularity: mesh_refinement
    runtime_fill_requirements:
      - "indices[1] or face_ids[1], barycentric[1] at stage n"
  - block_index: 2
    classical_case_id: ED_RAPID
    point_count_behavior: increasing
    point_location_behavior: regenerated_each_stage
    support_bound_behavior: increasing
    sampling_support: expanding_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n^(2) -> infinity"
    fill_distance_sequence: "eta_n^(2) = L_n^(2) h_n^(2) -> infinity"
    minimum_separation_behavior: not_specified
    design_regularity: irregular
    runtime_fill_requirements:
      - "block_points[2] at stage n"
      - "updated support bounds for block 2"
boundary_asymptotics:
  boundary_present: true
  boundary_source: boundary_layer
  boundary_layer_id: BND-LAYER-DOMAIN-01
  boundary_scope: whole_domain
  boundary_geometry_behavior: mixed
  boundary_point_count_behavior: varying
  active_boundary_behavior: changing_active_subset
  boundary_condition_behavior: changing_within_declared_labels
  boundary_input_route: whole_domain_boundary_payload
  boundary_available_shape_policies: [shape_stable, resize_allowed]
  boundary_selected_shape_policy_behavior: runtime_declared
  boundary_capacity_behavior: runtime_declared
  boundary_runtime_fill_requirements:
    - "whole-domain boundary payload at stage n"
    - "active_mask, active_boundary_count, and condition_codes"
  boundary_notes:
    - mixed whole-domain boundary because one block is fixed mesh-native and the other expands
notes:
  - valid mixed product-domain asymptotics on a mesh-native block crossed with an increasing Euclidean block
```

### 3.4 Attribute-channel support evolution without boundary

```yaml
asymptotic_descriptor_id: CT-ASY-ATTRIBUTE-CHANNEL-01
observation_structure_id: OBSSTRUCT_ATTRIBUTE_CHANNEL
domain_binding_mode: runtime_provided_domain
support_scope: whole_domain
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: points
available_shape_policies: [shape_stable, resize_allowed]
selected_shape_policy_behavior: runtime_declared
capacity_behavior: runtime_declared
whole_domain_point_regime:
  point_count_behavior: varying
  point_location_behavior: regenerated_each_stage
  support_bound_behavior: NA
  sampling_support: not_specified
  resolution_mode: coverage_only
  domain_scale_sequence: NA
  fill_distance_sequence: NA
  minimum_separation_behavior: not_specified
  design_regularity: irregular
  runtime_fill_requirements:
    - "points at stage n in the attribute-observation channel"
    - "current point count or leading axis"
  classical_case_id: NA
notes:
  - example of valid asymptotic support semantics when fill distance is not the primary notion of resolution
```

---

## 4. Moving-boundary example

### 4.1 Whole-domain moving boundary on a fixed support

```yaml
asymptotic_descriptor_id: CT-ASY-MOVING-BOUNDARY-01
observation_structure_id: OBSSTRUCT_Z_POINT_EVAL_IRREGULAR
domain_binding_mode: runtime_provided_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: block_points
available_shape_policies: [shape_stable]
selected_shape_policy_behavior: shape_stable
capacity_behavior: fixed_capacity
blockwise_point_regimes:
  - block_index: 1
    classical_case_id: FD_INFILL
    point_count_behavior: fixed
    point_location_behavior: moving_within_fixed_bounds
    support_bound_behavior: fixed
    sampling_support: fixed_support
    resolution_mode: fill_distance
    domain_scale_sequence: "L_n = 1"
    fill_distance_sequence: "h_n = constant"
    minimum_separation_behavior: bounded_below
    design_regularity: irregular
    runtime_fill_requirements:
      - "block_points[1] moved at stage n within the same support"
boundary_asymptotics:
  boundary_present: true
  boundary_source: boundary_layer
  boundary_layer_id: BND-LAYER-DOMAIN-01
  boundary_scope: whole_domain
  boundary_geometry_behavior: moving
  boundary_point_count_behavior: fixed
  active_boundary_behavior: changing_active_subset
  boundary_condition_behavior: changing_within_declared_labels
  boundary_input_route: whole_domain_boundary_payload
  boundary_available_shape_policies: [shape_stable]
  boundary_selected_shape_policy_behavior: shape_stable
  boundary_capacity_behavior: fixed_capacity
  boundary_runtime_fill_requirements:
    - "whole-domain boundary payload at stage n"
    - "active_mask, active_boundary_count, and condition_codes"
  boundary_notes:
    - moving enclosure on a fixed-capacity payload
notes:
  - illustrates moving-window / moving-boundary support semantics without changing the pattern family
```

---

## 5. Copy/paste templates

### 5.1 Single-block template

```yaml
asymptotic_descriptor_id: <string>
observation_structure_id: <existing_observation_structure_id>
domain_binding_mode: runtime_provided_domain | preinstantiated_domain
support_scope: blockwise
pattern_ids_fixed_across_n: true
operator_types_fixed_across_n: true
observation_domain_map_fixed_across_n: true
support_source_fixed_across_n: true
representation_type_fixed_across_n: true
instantiation_mode_fixed_across_n: true
point_payload_route: points | block_points | pointset_generator_spec
available_shape_policies: [shape_stable] | [resize_allowed] | [shape_stable, resize_allowed]
selected_shape_policy_behavior: shape_stable | resize_allowed | runtime_declared
capacity_behavior: fixed_capacity | nondecreasing_capacity | runtime_declared
blockwise_point_regimes:
  - block_index: <1..K>
    classical_case_id: FD_INFILL | ED_BALANCED | ED_RAPID | ED_DENSE | NA | Not Known
    point_count_behavior: fixed | increasing | nondecreasing | varying | Not Known
    point_location_behavior: fixed_locations | moving_within_fixed_bounds | regenerated_each_stage | mixed | Not Known
    support_bound_behavior: fixed | increasing | moving | mixed | NA | Not Known
    sampling_support: fixed_support | expanding_support | mixed_support | not_specified
    resolution_mode: fill_distance | coverage_only | not_specified
    domain_scale_sequence: <string or NA>
    fill_distance_sequence: <string or NA>
    minimum_separation_behavior: bounded_below | tends_to_zero | comparable_to_fill_distance | not_specified
    design_regularity: regular_grid | irregular | quasi_uniform | mesh_refinement | not_specified
    runtime_fill_requirements:
      - <stage-indexed point payload requirement>
notes:
  - <free-form note>
```

### 5.2 Boundary template

```yaml
boundary_asymptotics:
  boundary_present: true
  boundary_source: observation_structure_boundary | boundary_layer | both
  boundary_layer_id: <existing_boundary_layer_id>
  boundary_scope: blockwise_tensor | whole_domain | inherited_from_observation_structure | NA
  boundary_geometry_behavior: fixed | increasing | moving | mixed | NA | Not Known
  boundary_point_count_behavior: fixed | increasing | nondecreasing | varying | NA | Not Known
  active_boundary_behavior: fixed_active_subset | changing_active_subset | nondecreasing_active_subset | NA | Not Known
  boundary_condition_behavior: fixed | changing_within_declared_labels | NA | Not Known
  boundary_input_route: explicit_boundary_points | explicit_boundary_indices | blockwise_boundary_payload | whole_domain_boundary_payload | mesh_facet_derived | other | NA
  boundary_available_shape_policies: [shape_stable] | [resize_allowed] | [shape_stable, resize_allowed] | NA
  boundary_selected_shape_policy_behavior: shape_stable | resize_allowed | runtime_declared | NA
  boundary_capacity_behavior: fixed_capacity | nondecreasing_capacity | runtime_declared | NA
  boundary_runtime_fill_requirements:
    - <stage-indexed boundary payload requirement>
```
