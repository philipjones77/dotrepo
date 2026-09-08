# Operator Runtime Objects

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

* `CT_observation_structure_objects.md`
* `CT_deterministic_random_structures_objects.md`
* `CT_operator_runtime_specs.md`

**Is Relied Upon By:**

* operator-study examples
* operator-runtime implementation notes
* downstream operational catalogs that need concrete operator runtime instantiations

---

## 0. Preamble

### 0.0 Call Registry

* Registered runtime operator IDs:
  * `CTOR-REG-01`
  * `CTOR-BUILDER-01`
  * `CTOR-PREBUILT-01`

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

* Enumerates generic runtime operator object families for deterministic operators on already-instantiated CT domains.
* Assumes the domain object and operator-kind deterministic structure already exist before the runtime operator is instantiated.
* Assumes the observation structure is instantiated before an observation-bound finite operator is attached.
* Does not split entries by manifold family, backend family, or operating system.

### 0.3 How to read this file

* Section 1 gives the canonical template.
* Sections 2-4 give the three canonical runtime operator families.
* Section 5 records shared evaluation and diagnostics guidance.

### 0.4 Summary of Assumptions and Preconditions

* Runtime operators refine deterministic operator objects already declared in `CT_deterministic_random_structures_objects.md`.
* Observation-bound action is interpreted using `CT_observation_structure_objects.md`.
* Finite realizations remain runtime objects; they do not replace the underlying infinite-dimensional operator declaration.

### 0.5 Notation, Inputs and Aliases

* Uses only notation defined in `common_notation_objects.md`; no additional authoritative notation is introduced here.

### 0.6 Validation and Authority Rules

* Every declaration must bind to:
  * `bound_domain_id`,
  * `operator_structure_id`,
  * and `observation_structure_id` when finite support is attached.
* Every declaration must choose exactly one `realization_mode`.
* Separate catalog entries MUST NOT be introduced solely because:
  * the bound manifold changes,
  * the factor count changes,
  * the backend changes,
  * the same runtime route is applied to a different concrete operator expression.

---

## 1. Runtime Operator Template

### 1.1 Identification

* `runtime_operator_name`
* `runtime_operator_id`
* `bound_domain_id`
* `operator_structure_id`
* `observation_structure_id`
* `realization_mode`
* `operator_role`
* `active_pipeline_kind`

### 1.2 Runtime declaration

* `resolution_status`: `unresolved` / `resolved`
* `available_realization_modes`: subset of `{dense, matvec, cached_matvec}`
* `selected_realization_mode`
* `block_order`
* `runtime_payload`
* `diagnostic_metadata`

### 1.3 Finite realization

* `shape`
* `backend_name`
* `dtype`
* `dense_available`
* `matvec_available`

### 1.4 Evaluation binding

* `observation_binding_status`
* `construction_route`
* `cache_key_components`
* `batch_compatibility`
* `pipeline_binding_scope`

### 1.5 Notes

* Free-form clarifications

---

## 2. CTOR-REG-01 (registry-resolved runtime operator)

### 2.1 Identification

* `runtime_operator_name`: RegistryResolvedRuntimeOperator
* `runtime_operator_id`: CTOR-REG-01
* `bound_domain_id`: inherited from bound `Domain`
* `operator_structure_id`: inherited from bound deterministic operator structure
* `observation_structure_id`: runtime-bound when finite support is attached
* `realization_mode`: registry_resolved
* `operator_role`: deterministic_observation_bound_operator

### 2.2 Runtime declaration

* `resolution_status`: resolved after domain lookup
* `available_realization_modes`: runtime_declared subset of `{dense, matvec, cached_matvec}`
* `selected_realization_mode`: runtime_declared
* `block_order`: runtime_declared when factor-restricted
* `runtime_payload`:
  * `operator_registry_id`
  * `operator_params`
  * `domain_lookup_route`
* `diagnostic_metadata`:
  * `construction_route`: domain_registry_lookup
  * `supports_dense`: runtime_declared
  * `supports_matvec`: runtime_declared
  * `supports_cached_matvec`: runtime_declared

### 2.3 Finite realization

* `shape`: runtime_declared from observation-bound support
* `backend_name`: inherited from bound domain backend
* `dtype`: runtime_declared
* `dense_available`: runtime_declared
* `matvec_available`: runtime_declared

### 2.4 Evaluation binding

* `observation_binding_status`: downstream_observation_bound
* `construction_route`: deferred until bound support is available
* `cache_key_components`: `[domain_fingerprint, observation_fingerprint, operator_registry_id, block_order, operator_params]`
* `batch_compatibility`: true on shared support

### 2.5 Notes

* This is the canonical family for built-in domain operators such as Laplace-type operators.
* The same registry-resolved runtime operator may be reused by operator-study, simulation, prediction, diagnostics, visualization, and IO/artifact pipelines.

---

## 3. CTOR-BUILDER-01 (builder-resolved runtime operator)

### 3.1 Identification

* `runtime_operator_name`: BuilderResolvedRuntimeOperator
* `runtime_operator_id`: CTOR-BUILDER-01
* `bound_domain_id`: inherited from bound `Domain`
* `operator_structure_id`: inherited from bound deterministic operator structure
* `observation_structure_id`: runtime-bound when finite support is attached
* `realization_mode`: runtime_builder
* `operator_role`: deterministic_observation_bound_operator

### 3.2 Runtime declaration

* `resolution_status`: resolved after builder execution
* `available_realization_modes`: runtime_declared subset of `{dense, matvec, cached_matvec}`
* `selected_realization_mode`: runtime_declared
* `block_order`: runtime_declared when factor-restricted
* `runtime_payload`:
  * `builder_handle`
  * `builder_params`
  * `builder_inputs`
  * `example_pattern`: same support used for one or many functions
* `diagnostic_metadata`:
  * `construction_route`: runtime_builder
  * `supports_dense`: runtime_declared
  * `supports_matvec`: runtime_declared
  * `supports_cached_matvec`: runtime_declared

### 3.3 Finite realization

* `shape`: runtime_declared from observation-bound support
* `backend_name`: inherited from bound backend
* `dtype`: runtime_declared
* `dense_available`: runtime_declared
* `matvec_available`: runtime_declared

### 3.4 Evaluation binding

* `observation_binding_status`: downstream_observation_bound
* `construction_route`: deferred until builder inputs are assembled from bound support
* `cache_key_components`: `[domain_fingerprint, observation_fingerprint, builder_handle, builder_params, block_order]`
* `batch_compatibility`: true on shared support
* `pipeline_binding_scope`: pipeline_bound_ephemeral_runtime or pipeline_agnostic_reusable_runtime

### 3.5 Notes

* This is the canonical family for custom runtime operators supplied as constructors/callables rather than pre-registered domain operators.

---

## 4. CTOR-PREBUILT-01 (prebuilt finite runtime operator)

### 4.1 Identification

* `runtime_operator_name`: PrebuiltFiniteRuntimeOperator
* `runtime_operator_id`: CTOR-PREBUILT-01
* `bound_domain_id`: inherited from bound `Domain`
* `operator_structure_id`: inherited from bound deterministic operator structure
* `observation_structure_id`: required
* `realization_mode`: prebuilt_finite_operator
* `operator_role`: deterministic_observation_bound_operator

### 4.2 Runtime declaration

* `resolution_status`: resolved
* `available_realization_modes`: runtime_declared subset of `{dense, matvec, cached_matvec}`
* `selected_realization_mode`: runtime_declared
* `block_order`: runtime_declared when applicable
* `runtime_payload`:
  * `finite_operator_handle`
  * `finite_operator_shape`
  * `finite_operator_backend`
  * `finite_operator_dtype`
* `diagnostic_metadata`:
  * `construction_route`: prebuilt_attachment
  * `supports_dense`: runtime_declared
  * `supports_matvec`: runtime_declared
  * `supports_cached_matvec`: runtime_declared

### 4.3 Finite realization

* `shape`: declared directly
* `backend_name`: declared directly
* `dtype`: declared directly
* `dense_available`: runtime_declared
* `matvec_available`: runtime_declared

### 4.4 Evaluation binding

* `observation_binding_status`: observation_already_bound
* `construction_route`: direct attachment
* `cache_key_components`: `[domain_fingerprint, observation_fingerprint, finite_operator_shape, finite_operator_backend, finite_operator_dtype]`
* `batch_compatibility`: true on shared support when shape compatibility holds

### 4.5 Notes

* This family is used when the finite operator has already been materialized or packaged before entering the runtime pipeline.
* This family commonly appears at diagnostics/visualization/IO boundaries after another upstream pipeline has already constructed the finite operator.

---

## 5. Shared Evaluation Guidance

### 5.1 One-or-many structure application

* Any runtime operator family in this file may be applied to one evaluated structure or to many evaluated structures on the same support.
* Shared-support batching does not create a new runtime operator family.

### 5.2 Dense/matvec comparison

* When both dense and matvec routes exist, diagnostics should compare their finite actions on the same support.

### 5.3 Product-domain reuse

* The same family entries apply to:
  * Euclidean times Euclidean domains,
  * sphere times Euclidean domains,
  * and other admissible product domains.

---

## 6. Summary

* `CTOR-REG-01` covers domain-registry operators.
* `CTOR-BUILDER-01` covers custom runtime builder operators.
* `CTOR-PREBUILT-01` covers prebuilt finite operators attached after observation binding.
* No separate object entries are needed per manifold family or backend.
