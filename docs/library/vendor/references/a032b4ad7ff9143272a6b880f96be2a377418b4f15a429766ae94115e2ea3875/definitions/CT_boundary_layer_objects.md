# Boundary Layer Objects

---

*Status*: WORKING
*Version*: v1.0
*Date*: 2026-03-08

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `theory_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_manifold_geometry_objects.md`
* `CT_observation_structure_objects.md`
* `CT_boundary_layer_specs.md`

**Is Relied Upon By:**

* boundary-layer contracts
* boundary-layer runtime implementations

---

## 0. Preamble

### 0.0 Call Registry

* `BND-LAYER-BLOCK-01`
* `BND-LAYER-DOMAIN-01`

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

* Enumerates generic boundary-layer object families for already-instantiated CT manifolds and product manifolds.
* The boundary layer is optional and may be attached late in program flow.
* Dynamic boundary updates are allowed.
* Fixed-capacity runtime storage is preferred when the runtime expects repeated application on the same shaped payload.
* Resize-allowed runtime storage is also permitted when later increases in boundary-point capacity are required.
* The recorded boundary geometry may change dynamically, and more boundary points may be activated later, either within a fixed preallocated capacity or by growing the runtime payload shape.

---

## 1. Boundary Layer Template

### 1.1 Identification

* `boundary_layer_name`
* `boundary_layer_id`
* `bound_domain_id`
* `instantiation_binding`
* `boundary_scope`
* `dynamic_status`

### 1.2 Runtime declaration

* `num_boundary_points`
* `available_shape_policies`
* `geometry_representation`
* `declared_condition_labels`
* `available_condition_labels`
* `boundary_source`
* `shape_locked`

### 1.3 Runtime payload

* `active_mask`
* `condition_codes`
* `active_boundary_count`
* `boundary_points`

---

## 2. BND-LAYER-BLOCK-01 (blockwise tensor boundary layer)

* `boundary_layer_name`: BlockwiseTensorBoundaryLayer
* `boundary_layer_id`: BND-LAYER-BLOCK-01
* `instantiation_binding`: runtime_declared as `manifold_only` or `manifold_and_observation`
* `boundary_scope`: blockwise_tensor
* `dynamic_status`: runtime_declared
* `num_boundary_points`: runtime_declared current storage capacity
* `available_shape_policies`: runtime_declared subset of `{shape_stable, resize_allowed}`
* `geometry_representation`: runtime_declared as one of `{point_cloud, ordered_segments, facet_connectivity, mesh_boundary_facets, mesh_boundary_nodes, geodesic_arcs, geodesic_facets, observation_subset, implicit_level_set, custom}` or supplied blockwise per selected block
* `declared_condition_labels`: runtime_declared superset of condition labels admissible for this instantiated layer
* `available_condition_labels`: runtime_declared subset of `{dirichlet, neumann, robin, periodic, absorbing, reflecting, custom, unspecified}`
* `boundary_source`: explicit_points / observation_indices / mesh_facets / custom
* `shape_locked`: runtime_declared; typically true under `shape_stable`, optionally false under `resize_allowed`
* `boundary_points`: stored per selected block with leading axis `num_boundary_points`

Notes:

* This family is preferred when boundary structure should follow the tensor/block decomposition explicitly.
* It is attached only after the bound manifold/product manifold has already been instantiated.
* For Euclidean blocks, preferred representations include `ordered_segments`, `facet_connectivity`, `point_cloud`, `observation_subset`, and `implicit_level_set`.
* For sphere blocks, preferred representations include `geodesic_arcs`, `geodesic_facets`, `point_cloud`, `observation_subset`, and `implicit_level_set`.
* For mesh-native blocks, preferred representations include `mesh_boundary_facets`, `mesh_boundary_nodes`, `facet_connectivity`, `point_cloud`, `observation_subset`, and `implicit_level_set`.
* Mixed products may assign different geometry representations to different block contributions \(\mathcal{D}_i\).
* Dynamic updates may change the represented boundary geometry, active subset, and active boundary-condition assignments, and may activate more points later.
* Under `shape_stable`, the runtime array shape is preserved by preallocated capacity.
* Under `resize_allowed`, `num_boundary_points` and the runtime array shape may both increase or decrease.

---

## 3. BND-LAYER-DOMAIN-01 (whole-domain boundary layer)

* `boundary_layer_name`: WholeDomainBoundaryLayer
* `boundary_layer_id`: BND-LAYER-DOMAIN-01
* `instantiation_binding`: runtime_declared as `manifold_only` or `manifold_and_observation`
* `boundary_scope`: whole_domain
* `dynamic_status`: runtime_declared
* `num_boundary_points`: runtime_declared current storage capacity
* `available_shape_policies`: runtime_declared subset of `{shape_stable, resize_allowed}`
* `geometry_representation`: runtime_declared as one of `{point_cloud, ordered_segments, facet_connectivity, mesh_boundary_facets, mesh_boundary_nodes, geodesic_arcs, geodesic_facets, observation_subset, implicit_level_set, custom}`
* `declared_condition_labels`: runtime_declared superset of condition labels admissible for this instantiated layer
* `available_condition_labels`: runtime_declared subset of `{dirichlet, neumann, robin, periodic, absorbing, reflecting, custom, unspecified}`
* `boundary_source`: explicit_points / observation_indices / mesh_facets / custom
* `shape_locked`: runtime_declared; typically true under `shape_stable`, optionally false under `resize_allowed`
* `boundary_points`: stored on the full product-domain coordinate ordering with leading axis `num_boundary_points`

Notes:

* This family is preferred when the boundary should be recorded as one object on the whole product domain.
* It is attached only after the bound manifold/product manifold has already been instantiated.
* For Euclidean `whole_domain`, preferred representations include `facet_connectivity`, `ordered_segments`, `point_cloud`, `observation_subset`, and `implicit_level_set`.
* For sphere-containing products, preferred `whole_domain` representations include `point_cloud`, `observation_subset`, `implicit_level_set`, and `custom`, unless explicit geodesic/facet connectivity is supplied.
* For mesh-containing products, preferred `whole_domain` representations include `mesh_boundary_facets`, `facet_connectivity`, `mesh_boundary_nodes`, `point_cloud`, `observation_subset`, and `implicit_level_set`.
* The instantiated manifold with its attached boundary layer may be denoted by \(\mathcal{D}\), with block contributions \(\mathcal{D}_i\).
* Dynamic updates may change the represented boundary geometry, active subset, and active boundary-condition assignments, and may activate more points later.
* Under `shape_stable`, the runtime array shape is preserved by preallocated capacity.
* Under `resize_allowed`, `num_boundary_points` and the runtime array shape may both increase or decrease.
