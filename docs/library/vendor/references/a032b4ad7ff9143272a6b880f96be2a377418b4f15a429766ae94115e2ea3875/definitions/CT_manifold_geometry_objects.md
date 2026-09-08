# Manifold Geometry Details

---

*Status*: WORKING
*Version*: v1.2.0
*Date*: 2026-03-01

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `theory_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_manifold_geometry_specs.md`

**Is Relied Upon By:**

* `CT_deterministic_random_structures_objects.md`
* `CT_observation_structure_objects.md`
* `CT_representation_objects.md`
* `CT_one_input_kernel_objects.md`
* `CT_two_input_kernel_objects.md`
* `CT_multivariate_kernel_objects.md`
* `CT_model_structure_objects.md`
* downstream simulation, inference, prediction contracts and implementations

---

## 0. Preamble

### 0.0 Call Registry

* `geometry.details.manifold_geometry`
* `geometry.details.manifold_operators`

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

Defines the deterministic manifold geometry, manifold-operator catalogs/structures, and geometry-to-kernel handoff objects used by random-field models. It instantiates the templates in `CT_manifold_geometry_specs.md` with allowed manifold types, canonical manifold-type symbols, metrics, anisotropy rules, point layouts, runtime restrictions, and cross-block distance combinations. Kernels, probability models, inference, prediction, and numerical methods are defined elsewhere.

### 0.3 How to read this file

Start with the object overview in Section 1, which follows the order of `CT_manifold_geometry_specs.md` (ManifoldSpec, manifold blocks, runtime instantiation, metrics, anisotropy, points, restrictions, LagFeatures, combinations, layout hints, manifold operators). Field names and invariants mirror the spec; this file supplies allowable values, defaults, and narrative guidance.

### 0.4 Summary of Assumptions and Preconditions

* The manifold is deterministic; block metrics are well-defined and operator-compatible when required.
* Block order is authoritative and shared across downstream components.
* Metrics and anisotropy are declared at the geometry layer and must not be overridden by kernels.
* Restrictions define subsets of the manifold product but preserve the declared metrics.
* Runtime usage, runtime aliases, and runtime metric choice are attached only after manifold instantiation.

### 0.5 Notation, Inputs and Aliases

* Uses notation from `common_notation_objects.md`: $\mathcal{M}_{\mathrm{blk}} = \mathcal{M}_1 \times \cdots \times \mathcal{M}_K$, and the total manifold is either $\mathcal{M} = \mathcal{M}_{\mathrm{blk}}$ or $\mathcal{M} = \mathcal{M}_{\mathrm{blk}} \times \mathcal{P}$ when a multivariate component index is present.
* Standard alias bases are associated intrinsically with manifold types in this file.
* Runtime aliases default to the intrinsic alias base for the declared manifold type unless overridden at instantiation.
* Manifold types are defined without positional indexing; positional indexing appears only when instantiated as ordered blocks of a total manifold.
* Component index $\mathcal{P}$, when present, is finite with $p \ge 1$.

### 0.6 Validation and Authority Rules

* Objects in this file MUST conform to `CT_manifold_geometry_specs.md`.
* Block order is authoritative. Downstream components MUST NOT reorder blocks.
* Runtime aliases MUST NOT be used to reinterpret block identity, block order, manifold type, axes, or intrinsic metric.
* Metric declarations MUST be compatible with the downstream kernel requirements (e.g., Euclidean blocks may expose signed lags; compact blocks MUST NOT).
* When anisotropy is declared, anisotropy operators MUST be well-defined (e.g., SPD) and dimensionally compatible.
* If a downstream object conflicts with any geometry object declared here, the downstream object is invalid.

### 0.7 Template

Instances must fill the fields defined in `CT_manifold_geometry_specs.md` for `ManifoldSpec`, `ManifoldBlockSpec`, `ManifoldInstantiationSpec`, `AxisSpec`, `MetricSpec`, `AnisotropySpec`, `ManifoldRestrictionSpec`, `LagFeatures`, optional `DistanceCombineSpec`, and the operator objects `ManifoldOperatorDef` and `ManifoldOperatorStructure` (when used). Section 1 enumerates the allowed values, defaults, shapes, and metadata conventions for each field.

### 0.8 Additional Validation Checks

* Block names are unique and ordered; axis order within each block is authoritative for layout and serialization.
* If a runtime metric is absent, it defaults to `intrinsic_metric_k`; operator-based constructions require `operator_compatible = true` on the intrinsic metric.
* Anisotropy is block-level only; kernels may not redefine it.
* Restrictions are expressed as axis-aligned bounds per block and do not change the metrics.
* `LagFeatures` is the exclusive geometry-to-kernel handoff; shapes and ordering must match the manifold block order.

### 0.9 Implementation Trace

Maps each objects-file section to the spec it instantiates, the contract that operationalizes it, and the code that implements it.

| Objects Section | Spec Reference | Contract Section | Code Module | Symbol |
| --- | --- | --- | --- | --- |
| §1.1 Manifold product and total manifold | `CT_manifold_geometry_specs.md` §1–2 | `CT_manifold_contracts.md` §1.1, §2.1–2.2 | `manifolds/spec_types.py`, `manifolds/manifold_common.py`, `manifolds/numpy_impl.py` | manifold-spec implementation |
| §1.2 Manifold blocks (structure) | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §1.1, §2.2 | `manifolds/spec_types.py` | `ManifoldBlockSpec` |
| §1.2.2 Runtime instantiation | `CT_manifold_geometry_specs.md` §3.1 | `CT_manifold_contracts.md` §1.1 | implementation-defined runtime binding layer | manifold-instantiation implementation |
| §1.3.1 Euclidean | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §2.3–2.5 | `manifolds/manifold_common.py` | metric dispatch in `lag_features()`, `_canonicalize()` |
| §1.3.2 Sphere | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §2.3–2.5 | `manifolds/sphere_torus_builders.py`, `manifolds/numpy_impl.py` | `build_sphere_domain_spec()`, `NumpyDomain.create_sphere()` |
| §1.3.3 Torus | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §2.3–2.5 | `manifolds/sphere_torus_builders.py`, `manifolds/numpy_impl.py` | `build_torus_domain_spec()`, `NumpyDomain.create_torus()` |
| §1.3.4 Discrete | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §2.3–2.5 | `manifolds/manifold_common.py` | metric dispatch (Hamming / user matrix) |
| §1.3.5 Triangular mesh | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §2.3–2.5 | `manifolds/sphere_torus_builders.py`, `manifolds/numpy_impl.py` | `build_triangular_mesh_domain_spec()`, `NumpyDomain.create_triangular_mesh()` |
| §1.3.6 Human manifold | `CT_manifold_geometry_specs.md` §3 | `CT_manifold_contracts.md` §2.3–2.5 | `manifolds/sphere_torus_builders.py`, `manifolds/numpy_impl.py` | `build_human_manifold_domain_spec()`, `NumpyDomain.create_human_manifold()` |
| §1.5 Axes | `CT_manifold_geometry_specs.md` §4 | — | `manifolds/spec_types.py` | `AxisSpec` |
| §1.6 Points and point sets | `CT_manifold_geometry_specs.md` §7 | `CT_manifold_contracts.md` §2.3–2.4 | `manifolds/manifold_common.py` | `canonicalize_point_set()`, `validate_point_set()`, `_canonicalize()` |
| §1.7 Restrictions | `CT_manifold_geometry_specs.md` §8 | `CT_manifold_contracts.md` §2.3 | `manifolds/spec_types.py`, `manifolds/sphere_torus_builders.py` | manifold-restriction implementation |
| §1.8 Anisotropy | `CT_manifold_geometry_specs.md` §6 | — | `manifolds/spec_types.py` | `AnisotropySpec` |
| §1.9 LagFeatures handoff | `CT_manifold_geometry_specs.md` §9 | `CT_manifold_contracts.md` §2.5 | `manifolds/representations.py`, `manifolds/manifold_common.py` | `LagFeatures`, `lag_features()` |
| §1.10 Cross-block combinations | `CT_manifold_geometry_specs.md` §10 | `CT_manifold_contracts.md` §2.5 | `manifolds/representations.py` | `DistanceCombineSpec` |
| §1.11 Layout hints | `CT_manifold_geometry_specs.md` §7.2 | — | `manifolds/representations.py` | `CanonicalPointSet.layout_*` fields |
| §1.12 Manifold operators | `CT_manifold_geometry_specs.md` §11 | `CT_manifold_contracts.md` §2.7 | `manifolds/representations.py`, `manifolds/manifold_common.py`, `manifolds/numpy_impl.py` | manifold-operator implementation |

---

## 1. ManifoldGeometryDetails

### 1.1 Manifold product and total manifold

* $\mathcal{M}_{\mathrm{blk}} = \mathcal{M}_1 \times \cdots \times \mathcal{M}_K$ (ordered manifold blocks).
* $\mathcal{M} = \mathcal{M}_{\mathrm{blk}}$ when no multivariate component index is present.
* $\mathcal{M} = \mathcal{M}_{\mathrm{blk}} \times \mathcal{P}$ when a multivariate component index is present, with optional restrictions applied to the manifold factors.
* Optional manifold `metadata` may carry units, CRS, calendars, or notes.
* A manifold type is intrinsically unindexed; once instantiated into the ordered block list of a total manifold, it acquires positional identity as block 1, block 2, ..., block `K`.

### 1.2 Manifold blocks (identity and structure)

* Each block declares `name_k`, `manifold_type_k`, required `manifold_symbol`, optional `manifold_underlying_type_k`, ordered `axes_k`, `coord_rep_k`, required `intrinsic_metric_k`, optional `anisotropy_k`, and optional `metadata_k`.
* Invariants: block order is preserved everywhere; runtime metric choice defaults to `intrinsic_metric_k`; restrictions inherit the declared metrics; kernels cannot redefine intrinsic geometry or anisotropy.
* `manifold_symbol` MUST match the authoritative symbol registered below for the chosen `manifold_type_k`.

### 1.2.1 Manifold-type symbol registry

The following manifold-type to symbol and intrinsic alias-base assignments are authoritative for this file:

* `euclidean` -> $\mathbb{R}^d$, intrinsic alias base `E`
* `sphere` -> $\mathbb{S}^d$, intrinsic alias base `SP`
* `torus` -> $\mathbb{T}^d$, intrinsic alias base `TR`
* `discrete` -> $\mathbb{D}$, intrinsic alias base `DC`
* `triangular_mesh` -> $\mathbb{M}_{\triangle}$, intrinsic alias base `TM`
* `human_manifold` -> `HU`, intrinsic alias base `HU`

### 1.2.2 Runtime instantiation properties

The following fields are attached only when a manifold has been instantiated for a concrete runtime/model use:

* `usage_k`: semantic role label such as `space`, `time`, `depth`, `frequency`, `custom`
* `alias_k`: optional runtime alias
* `runtime_metric_k`: optional metric used at runtime
* `instantiation_mode`: default `lazy`
* `instantiation_status`: `declared_unresolved` before runtime realization, `instantiated_locked` after realization
* `block_dimensions_locked`: populated at instantiation from the ordered block list
* `product_dimension_locked`: populated at instantiation as the sum of ordered block dimensions
* `notes_k`: optional runtime note

Rules:

* `usage_k` is not part of the manifold definition.
* `alias_k` is not part of the manifold definition.
* `alias_k` defaults from the intrinsic alias base for `manifold_type_k`.
* If runtime aliases are generated automatically, they are indexed by block position in the instantiated total manifold, even when there is only one block (for example `E1`, `SP1`, `HU1`).
* `runtime_metric_k` defaults to `intrinsic_metric_k`.
* Different runtime instantiations may assign different usage labels, runtime aliases, and runtime metrics to the same manifold definition.
* Lazy/late realization of the product manifold is allowed and preferred when runtime binding happens deep in a pipeline.
* Once instantiated, `block_dimensions_locked` and `product_dimension_locked` are immutable runtime invariants.

### 1.3 Manifold types and metrics

Runtime geometry-source semantics:

* Formula-driven manifolds (`euclidean`, `sphere`, `torus`, `discrete`) are identified as `geometry_source = formula`; any mesh/grid is runtime discretization only.
* Mesh-native manifolds (`triangular_mesh`, `human_manifold`) are identified as `geometry_source = mesh_static`; mesh payload is part of the manifold definition.
* Runtime `active_mesh` updates for mesh-native blocks and optional-active-mesh formula blocks default to `active_mesh_shape_policy = shape_stable`.
* Under `shape_stable`, mesh geometry may change but node/cell/facet storage shape must remain fixed.
* `resize_allowed` is permitted only as an explicit runtime opt-in when downstream rebuild/recompile is acceptable.

#### 1.3.1 Euclidean

* `manifold_type`: `euclidean`; 
* `manifold_symbol`: $\mathbb{R}^d$
* Default axes: `(e1, e2, ...)` 
* Manifold metric: $\rho(u, v) = \|u - v\|_2$.
* Anisotropy: allowed via a block-level linear transform before distance evaluation.
* Coordinate representations: `cartesian` (default), `polar`, `spherical`, `custom`.

#### 1.3.2 Sphere

* `manifold_type`: `sphere`; axes `(theta1, theta2, ...)` for angular coordinates.
* `manifold_symbol`: $\mathbb{S}^d$
* Manifold metric (geodesic arc length): $\rho(u, v) = R \cdot \arccos(\operatorname{clip}(u \cdot v, -1, 1))$ with radius $R$ from the block metadata.
* Anisotropy: only with explicit operator/harmonic constructions.
* Coordinate representations: `embedding` (unit vectors), `latlon` (when $d_{M_k}=2$), `custom`.

#### 1.3.3 Torus

* `manifold_type`: `torus`; axes `(theta1, theta2, ...)` with periods $P_i$.
* `manifold_symbol`: $\mathbb{T}^d$
* Manifold metric (wrapped Euclidean): $\delta_i = \operatorname{wrap}(u_i - v_i) \in (-P_i/2, P_i/2]$, $\rho(u, v) = \sqrt{\sum_i \delta_i^2}$.
* Periods $P_i$ are part of metric parameters and stored in metadata.
* Coordinate representations: `wrapped` (default), `angle` (radians, period $2\pi$), `custom`.

#### 1.3.4 Discrete

* `manifold_type`: `discrete`; axes `(id)`.
* `manifold_symbol`: $\mathbb{DC}$
* Manifold metric: `none`
* Optional distance metric override: Hamming distance, Manhatten, user-defined pairwise distance matrix (deterministic).

#### 1.3.5 Triangular Mesh

* `manifold_type`: `triangular_mesh`; axes represent embedding coordinates (for coordinate mode) or a single vertex index axis (for index mode).
* `manifold_symbol`: $\mathbb{M}_{\triangle}$
* Manifold metric (mesh geodesic): shortest-path distance on the mesh edge graph induced by triangular faces.
* Required mesh metadata for geodesic mode: canonical `metadata_k.nodes` and `metadata_k.cells` (legacy aliases `mesh_vertices` / `mesh_faces` are accepted).
* Coordinate representations:
  * `cartesian` / `embedding`: point coordinates in the embedding space,
  * `vertex_index`: integer vertex ids for direct mesh-node addressing.
* Optional distance metric override: `embedded_l2` for embedding-space Euclidean approximations.
* Canonical mesh metadata payload:
  * `nodes`: `(n_nodes, d)` float coordinates
  * `cells`: `(n_elem, k)` integer connectivity (triangles for current geodesic runtime path)
  * `cell_tags`: optional `(n_elem,)` integer region/material tags
  * `facets`: optional boundary facet connectivity
  * `facet_tags`: optional boundary-condition tags aligned with `facets`
  * `geodesic_matrix`: optional `(n_nodes, n_nodes)` precomputed all-pairs mesh geodesic matrix for static runtimes
* Recommended ingestion flow: Gmsh/pygmsh mesh generation, meshio conversion, then canonical payload storage in `metadata_k`.

#### 1.3.6 Human Manifold (mesh-native)

* `manifold_type`: `human_manifold`.
* `manifold_symbol`: `HU`
* Core geometry is a user-defined triangular surface mesh supplied as:
  * `metadata_k.nodes` (vertex coordinates),
  * `metadata_k.cells` (triangular faces).
* Required invariants:
  * `metadata_k.invariants` MUST be present and non-empty.
* Optional static-runtime acceleration:
  * `metadata_k.geodesic_matrix` MAY store a precomputed all-pairs geodesic matrix for static meshes; JAX runtimes can use it as pure array lookup.
* Coordinate representations:
  * `vertex_index`: one-axis point representation with integer mesh vertex ids,
  * `cartesian`: embedding-coordinate point representation (nearest-vertex projection used for mesh geodesic lookup at runtime).
* Canonical metric:
  * `intrinsic_metric_k.metric_name = human_mesh_geodesic`,
  * interpreted as shortest-path distance on the mesh edge graph.
* This manifold type MAY appear as one block in a multi-block product domain together with Euclidean/torus/sphere/discrete blocks.

### 1.4 Naming rules for multiple blocks

* Block names are unique.
* If runtime aliases are generated automatically, the first block using an intrinsic alias base uses suffix `1` (for example `E1`, `SP1`, `TR1`, `DC1`); subsequent blocks increment numerically.
* Automatic runtime alias generation is a convenience only and MUST NOT be treated as part of the manifold definition.

### 1.5 Axes

* Axis names are lowercase; order is significant; intrinsic dimension of $\mathcal{M}_k$ is `len(axes_k)`.
* For an instantiated product manifold, the locked total product dimension is the sum of the locked block dimensions in authoritative order.
* Periods for wrapped axes belong in metric parameters or block metadata.

### 1.6 Points and point sets

* A point $u \in \mathcal{M}$ is $u = (u_1, \ldots, u_K)$ with $u_k \in \mathcal{M}_k$.
* Allowed point-set layouts:
  * Tuple of block arrays `(U_1, ..., U_K)`, each shaped `(n, d_{M_k})`.
  * Dictionary keyed by block names `{name_k: U_k}`.
  * Flattened table (column-major by block then axis) per `CT_io_specs.md`.
* Layout metadata may be attached but is advisory.

### 1.7 Manifold restrictions

* `ManifoldRestrictionSpec` stores `block_bounds` keyed by block name; each value lists per-axis `(lower, upper)` bounds aligned with `axes_k`.
* Default is no restriction. Restrictions define subsets of $\mathcal{M}$ used at runtime; they do not alter metrics.

### 1.8 Anisotropy

* `AnisotropySpec` is block-level: optional linear transform `A_k`, optional SPD matrix `B_k`, optional parameters/metadata.
* Anisotropy affects distance evaluation only; axes and ordering are unchanged; kernels must not redefine anisotropy.

### 1.9 LagFeatures (geometry -> kernel handoff)

* For each block $k$: `r_k` is a distance matrix of shape `(n, m)`; `h_k` is signed lags `(n, m, d_{M_k})` for Euclidean blocks, otherwise `None`.
* Additional fields: `block_names`, `manifold_types`, per-block `axes`, `metadata` noting whether manifold or distance metric and anisotropy were used.
* Invariants: shapes align across blocks for a given `(U, V)`; ordering matches the manifold block order; kernels consume only `LagFeatures` (never raw coordinates).

### 1.10 Cross-block distance combinations

* Optional `DistanceCombineSpec`: `inputs` (block indices or names), `combine_fn_name`, optional `combine_fn_parameters`, `output_kind` (`distance` or `pseudodistance`), optional `notes`.
* Combination is performed in geometry; kernels consume the combined distances.

### 1.11 Layout hints (non-binding)

* Optional `layout_kind`: `regular_grid` | `tensor_product_grid` | `irregular`.
* Optional `layout_metadata`: spacing, ordering conventions, or other advisory hints.

### 1.12 Manifold operators

This section instantiates the operator catalog objects declared in `CT_manifold_geometry_specs.md` §12.

The catalog supplies stable `operator_id` values that may appear in a manifold's `"operator"` representation
(`ManifoldOperatorStructure` / `BlockOperatorStructure`).

#### 1.13.1 Canonical operator IDs

**(A) Euclidean Laplacian**

* `operator_id`: `laplacian`
* `operator_kind`: `laplacian`
* `operator_scope`: `block`
* `supported_manifold_types`: `euclidean`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: negative semidefinite (Fourier multiplier is $-\|\omega\|^2$)
* `canonical_basis_kind`: `spectral_multiplier`
* `canonical_spectral_coordinate_schema`:
  * `type`: `vector_frequency`
  * `space`: `R^d`
  * `dim`: $d_{\mathcal{M}_k}$
* `boundary_conditions`: `unbounded` (default)
* `notes`: for bounded or restricted Euclidean subsets, boundary conditions are solver- and representation-specific and MUST be declared in the operator representation metadata

**(B) Periodic Laplacian on a torus**

* `operator_id`: `laplacian_periodic`
* `operator_kind`: `laplacian`
* `operator_scope`: `block`
* `supported_manifold_types`: `torus`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: negative semidefinite (integer Fourier eigenmodes)
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `integer_multiindex`
  * `space`: `Z^d`
  * `dim`: $d_{\mathcal{M}_k}$
  * `periods`: tuple of axis periods (from `AxisSpec.period`)
* `boundary_conditions`: `periodic`

**(C) Laplace–Beltrami operator on a sphere**

* `operator_id`: `laplace_beltrami`
* `operator_kind`: `laplacian`
* `operator_scope`: `block`
* `supported_manifold_types`: `sphere`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: negative semidefinite (spherical-harmonic eigenbasis)
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `spherical_harmonic_multiindex`
  * `space`: `N x Z^(d-1)` (schema-level description)
  * `dim`: sphere dimension
  * `radius`: sphere radius (from block metadata or metric parameters)
* `boundary_conditions`: `closed_manifold`

**(D) Mesh Laplacian (discrete approximation)**

* `operator_id`: `mesh_graph_laplacian`
* `operator_kind`: `laplacian`
* `operator_scope`: `block`
* `supported_manifold_types`: `triangular_mesh`, `human_manifold`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: negative semidefinite (graph/mesh Laplacian convention)
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `eigen_index`
  * `space`: `N`
  * `index_name`: `j`
  * `truncation_parameter`: `L_max`
* `boundary_conditions`: `mesh_free_boundary` (default unless overridden)

**(E) Euclidean gradient**

* `operator_id`: `gradient_euclidean`
* `operator_kind`: `gradient`
* `operator_scope`: `block`
* `supported_manifold_types`: `euclidean`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: first-order differential operator; no Laplacian sign convention applies
* `canonical_basis_kind`: `vector_differential_operator`
* `canonical_spectral_coordinate_schema`:
  * `type`: `vector_frequency`
  * `space`: `R^d`
  * `dim`: $d_{\mathcal{M}_k}$
  * `output_rank`: `tangent_vector`
* `boundary_conditions`: `unbounded` (default)
* `notes`: intrinsic and extrinsic gradients coincide for Euclidean blocks; output lives in the tangent space identified with `R^d`; both NumPy and JAX realizations are admissible

**(F) Periodic gradient on a torus**

* `operator_id`: `gradient_periodic`
* `operator_kind`: `gradient`
* `operator_scope`: `block`
* `supported_manifold_types`: `torus`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: first-order differential operator; no Laplacian sign convention applies
* `canonical_basis_kind`: `vector_differential_operator`
* `canonical_spectral_coordinate_schema`:
  * `type`: `integer_multiindex`
  * `space`: `Z^d`
  * `dim`: $d_{\mathcal{M}_k}$
  * `periods`: tuple of axis periods (from `AxisSpec.period`)
  * `output_rank`: `tangent_vector`
* `boundary_conditions`: `periodic`
* `notes`: tangent vectors are represented in wrapped coordinate charts aligned with the torus axes; both NumPy and JAX realizations are admissible

**(G) Riemannian gradient on a sphere**

* `operator_id`: `gradient_riemannian`
* `operator_kind`: `gradient`
* `operator_scope`: `block`
* `supported_manifold_types`: `sphere`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: first-order differential operator; no Laplacian sign convention applies
* `canonical_basis_kind`: `tangent_bundle_operator`
* `canonical_spectral_coordinate_schema`:
  * `type`: `spherical_harmonic_multiindex`
  * `space`: `N x Z^(d-1)` (schema-level description)
  * `dim`: sphere dimension
  * `radius`: sphere radius (from block metadata or metric parameters)
  * `output_rank`: `tangent_vector`
* `boundary_conditions`: `closed_manifold`
* `notes`: output values are tangent vectors on the sphere; any ambient-coordinate realization MUST enforce tangency; both NumPy and JAX realizations are admissible

**(H) Mesh gradient (discrete approximation)**

* `operator_id`: `mesh_gradient`
* `operator_kind`: `gradient`
* `operator_scope`: `block`
* `supported_manifold_types`: `triangular_mesh`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: first-order differential operator; no Laplacian sign convention applies
* `canonical_basis_kind`: `discrete_tangent_operator`
* `canonical_spectral_coordinate_schema`:
  * `type`: `mesh_local_basis`
  * `space`: `cell_or_vertex_local_frames`
  * `index_name`: `j`
  * `output_rank`: `tangent_vector`
* `boundary_conditions`: `mesh_free_boundary` (default unless overridden)
* `notes`: gradient is interpreted as a local discrete tangent operator on the mesh; concrete realization may be face-based, vertex-based, or chart-based but MUST declare the choice in operator metadata; both NumPy and JAX realizations are admissible

**(I) Human-manifold gradient (mesh-native discrete approximation)**

* `operator_id`: `human_manifold_gradient`
* `operator_kind`: `gradient`
* `operator_scope`: `block`
* `supported_manifold_types`: `human_manifold`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: first-order differential operator; no Laplacian sign convention applies
* `canonical_basis_kind`: `discrete_tangent_operator`
* `canonical_spectral_coordinate_schema`:
  * `type`: `mesh_local_basis`
  * `space`: `cell_or_vertex_local_frames`
  * `index_name`: `j`
  * `output_rank`: `tangent_vector`
* `boundary_conditions`: `mesh_free_boundary` (default unless overridden)
* `notes`: output lives in local tangent frames on the human manifold mesh; any ambient-coordinate embedding is an implementation detail and MUST preserve tangent-space semantics; both NumPy and JAX realizations are admissible

**(J) Euclidean heat semigroup**

* `operator_id`: `heat_semigroup_euclidean`
* `operator_kind`: `heat_semigroup`
* `operator_scope`: `block`
* `supported_manifold_types`: `euclidean`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: positivity-preserving contraction semigroup generated by the negative semidefinite Euclidean Laplacian
* `derived_from_operator_id`: `laplacian`
* `canonical_basis_kind`: `spectral_multiplier`
* `canonical_spectral_coordinate_schema`:
  * `type`: `vector_frequency`
  * `space`: `R^d`
  * `dim`: $d_{\mathcal{M}_k}$
  * `semigroup_parameter`: `t`
* `boundary_conditions`: `unbounded` (default)
* `notes`: represents $e^{t\Delta}$ or another declared admissible function of the Euclidean Laplacian; efficient realizations may use FFT/Fourier diagonalization, spectral multiplication, or matrix-free approximation

**(K) Periodic heat semigroup on a torus**

* `operator_id`: `heat_semigroup_periodic`
* `operator_kind`: `heat_semigroup`
* `operator_scope`: `block`
* `supported_manifold_types`: `torus`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: positivity-preserving contraction semigroup generated by the negative semidefinite periodic Laplacian
* `derived_from_operator_id`: `laplacian_periodic`
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `integer_multiindex`
  * `space`: `Z^d`
  * `dim`: $d_{\mathcal{M}_k}$
  * `periods`: tuple of axis periods (from `AxisSpec.period`)
  * `semigroup_parameter`: `t`
* `boundary_conditions`: `periodic`
* `notes`: represents $e^{t\Delta}$ or another declared admissible function of the periodic Laplacian; efficient realizations may use Fourier diagonalization or matrix-free approximation

**(L) Riemannian heat semigroup on a sphere**

* `operator_id`: `heat_semigroup_riemannian`
* `operator_kind`: `heat_semigroup`
* `operator_scope`: `block`
* `supported_manifold_types`: `sphere`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: positivity-preserving contraction semigroup generated by the negative semidefinite Laplace-Beltrami operator
* `derived_from_operator_id`: `laplace_beltrami`
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `spherical_harmonic_multiindex`
  * `space`: `N x Z^(d-1)` (schema-level description)
  * `dim`: sphere dimension
  * `radius`: sphere radius (from block metadata or metric parameters)
  * `semigroup_parameter`: `t`
* `boundary_conditions`: `closed_manifold`
* `notes`: represents $e^{t\Delta_{\mathcal{M}_k}}$ or another declared admissible function of the sphere Laplace-Beltrami operator; efficient realizations may use truncated eigenbases, harmonic diagonalization, Krylov methods, or matrix-free approximation

**(M) Mesh heat semigroup (discrete approximation)**

* `operator_id`: `heat_semigroup_mesh`
* `operator_kind`: `heat_semigroup`
* `operator_scope`: `block`
* `supported_manifold_types`: `triangular_mesh`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: positivity-preserving diffusion operator derived from the negative semidefinite discrete mesh Laplacian
* `derived_from_operator_id`: `mesh_graph_laplacian`
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `eigen_index`
  * `space`: `N`
  * `index_name`: `j`
  * `truncation_parameter`: `L_max`
  * `semigroup_parameter`: `t`
* `boundary_conditions`: `mesh_free_boundary` (default unless overridden)
* `notes`: represents a heat/diffusion operator obtained from the declared mesh Laplacian; efficient realizations may use eigentruncation, Chebyshev/polynomial approximation, Krylov methods, or matrix-free repeated matvecs

**(N) Human-manifold heat semigroup (mesh-native discrete approximation)**

* `operator_id`: `heat_semigroup_human_manifold`
* `operator_kind`: `heat_semigroup`
* `operator_scope`: `block`
* `supported_manifold_types`: `human_manifold`
* `supported_backends`: `numpy`, `jax`
* `requires_operator_compatible_metric`: yes
* `sign_convention`: positivity-preserving diffusion operator derived from the negative semidefinite discrete human-manifold Laplacian
* `derived_from_operator_id`: `mesh_graph_laplacian`
* `canonical_basis_kind`: `eigenpairs`
* `canonical_spectral_coordinate_schema`:
  * `type`: `eigen_index`
  * `space`: `N`
  * `index_name`: `j`
  * `truncation_parameter`: `L_max`
  * `semigroup_parameter`: `t`
* `boundary_conditions`: `mesh_free_boundary` (default unless overridden)
* `notes`: represents a heat/diffusion operator obtained from the declared human-manifold discrete Laplacian; efficient realizations may use eigentruncation, polynomial/rational approximation, Krylov methods, or matrix-free repeated matvecs

**(O) Reserved / sentinel operator IDs**

These entries are included for completeness and uniform error signaling.

* `operator_id`: `divergence`
  * `operator_kind`: `divergence`
  * `operator_scope`: `block`
  * `supported_manifold_types`: `euclidean`, `sphere`, `torus`, `triangular_mesh`, `human_manifold`
  * `notes`: reserved operator id; often used only implicitly via the Laplacian

* `operator_id`: `unsupported`
  * `operator_kind`: `custom`
  * `operator_scope`: `block`
  * `supported_manifold_types`: any
  * `requires_operator_compatible_metric`: no
* `notes`: sentinel id used when a manifold does not provide an operator schema for a block

---

### 1.14 Summary

* $\mathcal{M}_{\mathrm{blk}}$ is an ordered product of manifold blocks with declared metrics and optional anisotropy; the total manifold is either $\mathcal{M} = \mathcal{M}_{\mathrm{blk}}$ or $\mathcal{M} = \mathcal{M}_{\mathrm{blk}} \times \mathcal{P}$ when a multivariate component index is present, with optional restrictions.
* Allowed manifold types are Euclidean, sphere, torus, discrete, triangular mesh, and mesh-native human manifold, each with canonical metrics and coordinate options.
* Axes and block order are authoritative for layout, serialization, and downstream compatibility.
* Downstream exposure includes both total-manifold metadata and the ordered metadata/identity of each instantiated block.
* `LagFeatures` is the exclusive geometry-to-kernel handoff; optional cross-block combinations must be declared explicitly.
* Canonical deterministic operator IDs (e.g., `laplacian`, `laplacian_periodic`, `laplace_beltrami`, `mesh_graph_laplacian`, `gradient_euclidean`, `gradient_periodic`, `gradient_riemannian`, `mesh_gradient`, `human_manifold_gradient`, `heat_semigroup_euclidean`, `heat_semigroup_periodic`, `heat_semigroup_riemannian`, `heat_semigroup_mesh`, `heat_semigroup_human_manifold`) support operator/SPDE representations via an optional operator representation.

---

## 2. Open Questions

* None at this time.
