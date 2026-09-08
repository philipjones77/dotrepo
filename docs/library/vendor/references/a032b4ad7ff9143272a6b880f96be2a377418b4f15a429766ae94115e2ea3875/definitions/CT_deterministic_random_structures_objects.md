# Deterministic and Stochastic Structure Objects

---

*Status*: WORKING
*Version*: v5.0
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
* `CT_deterministic_random_structures_specs.md`

**Is Relied Upon By:**

* `CT_representation_objects.md`
* `CT_model_structure_objects.md`
* downstream model detail files that reference deterministic/stochastic structure instances

---

## 0. Preamble

### 0.0 Call Registry

* Registered structure IDs:
  * `DSO-FUNC-GEN-01`
  * `DSO-OP-GEN-01`
  * `DSO-ATTR-DET-01`
  * `DSO-LATENT-GEN-01`
  * `DSO-ATTR-STO-01`

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

* Enumerates generic object families that instantiate `CT_deterministic_random_structures_specs.md`.
* Assumes an admissible CT domain or admissible CT product domain has already been instantiated before the object is declared.
* Does not split object entries by manifold, product-manifold choice, or domain-factor count.
* Does not create separate catalog entries merely because an object is continuous, Holder regular, or otherwise refined by runtime properties.
* Treats every declared object here as infinite-dimensional.
* Leaves acceptable finite grids, mesh shapes, batch shapes, and array layouts to downstream realization layers.
* Supports runtime instantiation of concrete examples such as \(u \mapsto u^2\) on the already bound domain, with pointwise or batched evaluation chosen downstream.
* Allows the same declared structure to be reused across simulation, prediction, diagnostics, visualization, IO, and operator-study/runtime-support pipelines without changing object identity.

### 0.3 How to read this file

* Section 1 gives the canonical generic template.
* Sections 2-6 give generic object families that are valid on any already-instantiated admissible domain or admissible product domain.
* Section 7 records runtime refinement patterns for continuity, explicit multivariable declarations, and similar object properties.
* Section 8 records evaluation guidance.

### 0.4 Summary of Assumptions and Preconditions

* The bound geometry object is instantiated first in `CT_manifold_geometry_objects.md`.
* Domain-specific factor semantics belong to the bound domain object, not to distinct object families in this file.
* Notation is authoritative from `common_notation_objects.md`.
* Implementation environment details are runtime/platform concerns and must remain platform-neutral in this file.

### 0.5 Notation, Inputs and Aliases

* Uses only notation defined in `common_notation_objects.md`; no additional aliases introduced here.

### 0.6 Validation and Authority Rules

* Each declaration must choose exactly one `structure_mode`.
* Each declaration must choose an allowed `object_kind`.
* Each declaration must choose an allowed `target_space`.
* Every declaration in this file binds to an already-instantiated `bound_domain_id`.
* Separate registry entries MUST NOT be introduced solely because:
  * the bound domain is a different manifold or product manifold,
  * the number of domain factors changes,
  * continuity or Holder-type regularity metadata changes,
  * a different concrete runtime expression is supplied.
* Random declarations MUST include `stochastic_assumptions`.
* Deterministic declarations MUST set `stochastic_assumptions` to `null` or omit it.
* Call registry entries must use unique `structure_id` values.

### 0.7 Template

* Section 1 is the canonical template.
* If not applicable: `NA`.
* If applicable but unknown: `Not Known`.

---

## 1. Deterministic/Stochastic Object Template

### 1.1 Identification

* `structure_name`
* `structure_id`
* `bound_domain_id`
* `bound_domain_status`: `preinstantiated`
* `object_dimensionality`: `infinite`
* `structure_mode`: `deterministic` / `stochastic`
* `object_kind`
* `refines_object_kind`: base kind or `NA`

### 1.2 Runtime declaration

* `declaration_mode`: `runtime_direct` / `runtime_lazy`
* `definition_form`: `explicit_map` / `generated_rule` / `deferred_constructor`
* `available_realization_modes`: subset of `{dense, matvec, cached_matvec}`
* `selected_realization_mode`
* `pattern_specialization_policy`: `generic` / `pattern_specialized`
* `runtime_refinements`

### 1.3 Target space

* `value_space`
* `target_space`: `real_scalar` / `complex_scalar` / `real_vector` / `complex_vector` / `normed_vector_space` / `hilbert_space` / `attribute_space` / `stochastic_space`
* `target_dimension`
* `base_field`
* `target_space_definition` when required
* `norm_definition` when required
* `value_storage_layout`
* `component_semantics`: `univariate_or_scalar` / `multivariate_point_axis`

### 1.4 Object-specific structure

* `map_signature` for function-like objects
* `operator_input_space` for operators
* `operator_output_space` for operators
* `object_properties`
* `runtime_definition_payload`

### 1.5 Mean or deterministic convention

* `mean_zero`: yes / no / `NA`
* `mean_decomposition` when applicable

### 1.6 Stochastic assumptions

* `stochastic_assumptions`: mapping/object or `null`

### 1.7 Notes

* Free-form clarifications

### 1.8 Efficient evaluation binding

* `evaluation_domain_id`
* `finite_binding_status`
* `evaluation_route`
* `evaluation_cache_keys`
* `preferred_chunking`
* `univariate_fast_path_preserved`: yes / no

---

## 2. DSO-FUNC-GEN-01 (generic deterministic function object)

### 2.1 Identification

* `structure_name`: DeterministicFunctionGeneric
* `structure_id`: DSO-FUNC-GEN-01
* `bound_domain_id`: inherited from bound `Domain`
* `bound_domain_status`: preinstantiated
* `object_dimensionality`: infinite
* `structure_mode`: deterministic
* `object_kind`: function
* `refines_object_kind`: NA at catalog level; runtime refinements allowed

### 2.2 Runtime declaration

* `declaration_mode`: runtime_direct
* `definition_form`: explicit_map
* `available_realization_modes`: `{dense, matvec, cached_matvec}`
* `selected_realization_mode`: runtime_declared
* `pattern_specialization_policy`: generic
* `runtime_refinements`:
  * `allowed_object_kinds`:
    * `function`
    * `multivariable_function`
    * `continuous_function`
    * `continuous_multivariable_function`
  * `continuity_metadata_runtime_declared`: true
  * `coordinate_role_metadata_runtime_declared`: true

### 2.3 Target space

* `value_space`: runtime_declared from any admissible value-space class in the spec
* `target_space`: runtime_declared from any admissible target-space class in the spec
* `target_dimension`: runtime_declared
* `base_field`: runtime_declared
* `target_space_definition`: runtime_declared when required
* `norm_definition`: runtime_declared when required
* `value_storage_layout`: runtime_declared, with `point_major_dense` the preferred numeric runtime layout
* `component_semantics`: `univariate_or_scalar` when `target_dimension = 1`; `multivariate_point_axis` when `target_dimension > 1`

### 2.4 Object-specific structure

* `map_signature`: \(f : \mathcal{M} \to K\), with explicit factor form recorded at runtime when desired
* `object_properties`:
  * `regularity_declared_at_runtime`: true
  * `coordinate_roles_declared_at_runtime`: true
  * `evaluation_semantics`:
    * `pointwise_supported`: true
    * `batched_supported`: true
* `runtime_definition_payload`:
  * `definition_handle`: runtime callable, symbolic rule, or generated evaluator
  * `parameter_payload`: optional runtime parameters
  * `example_instantiation`:
    * `bound_domain_id`: inherited
    * `runtime_expression`: \(u \mapsto u^2\)
    * `single_point_evaluation`: admissible
    * `batched_evaluation`: admissible

### 2.5 Mean or deterministic convention

* `mean_zero`: NA

### 2.6 Stochastic assumptions

* `stochastic_assumptions`: null

### 2.7 Notes

* This is the canonical deterministic function object family for any already-instantiated admissible domain or admissible product domain.
* The declared codomain contract is the more general `value_space`; `attribute_space` is only one concrete instantiation of it.
* No separate catalog object is needed for different manifolds, different product-manifold structures, continuity, Holder continuity, or other regularity refinements.
* Such distinctions are declared at runtime through `object_kind`, `refines_object_kind`, and `object_properties` on the same generic family.
* Multivariate targets remain the same object family as the univariate target case, but downstream runtime realization MUST keep the univariate/scalar fast path intact.
* If `target_dimension > 1`, the preferred finite realization is a point-major multivariate layout that is equivalent to componentwise reuse of the univariate action, without changing the univariate object semantics.

### 2.8 Efficient evaluation binding

* `evaluation_domain_id`: inherited from bound `Domain`
* `finite_binding_status`: downstream_observation_bound
* `evaluation_route`: deferred
* `evaluation_cache_keys`: `[domain_fingerprint, structure_id, runtime_refinements, runtime_definition_payload]`
* `preferred_chunking`: decided downstream after finite support binding
* `univariate_fast_path_preserved`: yes; multivariate realization may reuse vectorized componentwise application but MUST NOT slow the `target_dimension = 1` path

---

## 3. DSO-OP-GEN-01 (generic deterministic operator object)

### 3.1 Identification

* `structure_name`: DeterministicOperatorGeneric
* `structure_id`: DSO-OP-GEN-01
* `bound_domain_id`: inherited from bound `Domain`
* `bound_domain_status`: preinstantiated
* `object_dimensionality`: infinite
* `structure_mode`: deterministic
* `object_kind`: operator
* `refines_object_kind`: NA

### 3.2 Runtime declaration

* `declaration_mode`: runtime_lazy
* `definition_form`: deferred_constructor
* `available_realization_modes`: `{dense, matvec, cached_matvec}`
* `selected_realization_mode`: runtime_declared
* `pattern_specialization_policy`: pattern_specialized
* `runtime_refinements`:
  * `operator_class_declared_at_runtime`: true
  * `linearity_declared_at_runtime`: true
  * `domain_of_action_declared_at_runtime`: true

### 3.3 Target space

* `target_space`: runtime_declared
* `target_dimension`: runtime_declared
* `base_field`: runtime_declared
* `target_space_definition`: runtime_declared when required
* `norm_definition`: runtime_declared when required
* `component_semantics`: `univariate_or_scalar` / `point_preserving_multivariate` / `component_coupled_multivariate`

### 3.4 Object-specific structure

* `operator_input_space`: runtime-declared deterministic function space, latent-field space, or other declared input space on the same bound domain
* `operator_output_space`: runtime-declared output space on the same bound domain
* `object_properties`:
  * `domain_fixed_with_object`: true
  * `operator_metadata_declared_at_runtime`: true
* `runtime_definition_payload`:
  * `operator_handle`: runtime constructor or callable
  * `parameter_payload`: optional runtime parameters
  * `operator_realization_route`: `registry_resolved` / `runtime_builder` / `prebuilt_finite_operator`
  * `observation_bound_realization`: optional finite operator artifact or callable specialized to the bound observation support

### 3.5 Mean or deterministic convention

* `mean_zero`: NA

### 3.6 Stochastic assumptions

* `stochastic_assumptions`: null

### 3.7 Notes

* The operator object is generic across all admissible already-instantiated domains and product domains.
* Domain geometry determines where the operator lives; this file does not split operators by manifold family.
* The same generic operator object family covers:
  * built-in domain operators such as Laplace-type operators,
  * runtime-supplied custom operators produced by a constructor/callable,
  * and prebuilt finite operator realizations attached after observation binding.
* For `target_dimension = 1`, downstream runtimes SHOULD use the ordinary univariate operator path.
* For `target_dimension > 1`, downstream runtimes MAY realize either:
  * `point_preserving_multivariate`, where the same point operator is reused across components while preserving the trailing component axis, or
  * `component_coupled_multivariate`, where the finite runtime operator couples components explicitly.
* These multivariate realizations are separate runtime refinements of the same generic operator object and MUST NOT impose overhead on the univariate path.

### 3.8 Efficient evaluation binding

* `evaluation_domain_id`: inherited from bound `Domain`
* `finite_binding_status`: downstream_observation_bound
* `evaluation_route`: deferred
* `evaluation_cache_keys`: `[domain_fingerprint, structure_id, operator_input_space, operator_output_space, runtime_definition_payload]`
* `preferred_chunking`: decided downstream after finite operator realization is chosen
* `univariate_fast_path_preserved`: yes; multivariate/vector-valued operator runtimes must be layered separately from the scalar path

---

## 4. DSO-ATTR-DET-01 (generic deterministic attribute operator)

### 4.1 Identification

* `structure_name`: DeterministicAttributeOperatorGeneric
* `structure_id`: DSO-ATTR-DET-01
* `bound_domain_id`: inherited from bound `Domain`
* `bound_domain_status`: preinstantiated
* `object_dimensionality`: infinite
* `structure_mode`: deterministic
* `object_kind`: attribute_operator
* `refines_object_kind`: NA

### 4.2 Runtime declaration

* `declaration_mode`: runtime_direct
* `definition_form`: explicit_map
* `available_realization_modes`: `{dense}`
* `selected_realization_mode`: dense
* `pattern_specialization_policy`: generic
* `runtime_refinements`:
  * `attribute_semantics_declared_at_runtime`: true

### 4.3 Target space

* `target_space`: attribute_space
* `target_dimension`: runtime_declared
* `base_field`: NA
* `target_space_definition`:
  * `space_kind`: attribute_space
  * `declared_at_runtime`: true

### 4.4 Object-specific structure

* `map_signature`: \(a : \mathcal{M} \to X\), where \(X\) is the declared attribute domain
* `object_properties`:
  * `attribute_semantics_declared`: true
* `runtime_definition_payload`:
  * `definition_handle`: runtime callable or lookup rule
  * `attribute_schema`: runtime-declared

### 4.5 Mean or deterministic convention

* `mean_zero`: NA

### 4.6 Stochastic assumptions

* `stochastic_assumptions`: null

### 4.7 Notes

* Deterministic attribute operators remain generic map-like objects on the already bound domain, with codomain given by the declared attribute domain.

### 4.8 Efficient evaluation binding

* `evaluation_domain_id`: inherited from bound `Domain`
* `finite_binding_status`: downstream_observation_bound
* `evaluation_route`: deferred
* `evaluation_cache_keys`: `[domain_fingerprint, structure_id, target_space_definition, runtime_definition_payload]`
* `preferred_chunking`: decided downstream after attribute-support binding

---

## 5. DSO-LATENT-GEN-01 (generic stochastic latent-field object)

### 5.1 Identification

* `structure_name`: LatentFieldGeneric
* `structure_id`: DSO-LATENT-GEN-01
* `bound_domain_id`: inherited from bound `Domain`
* `bound_domain_status`: preinstantiated
* `object_dimensionality`: infinite
* `structure_mode`: stochastic
* `object_kind`: latent_field
* `refines_object_kind`: NA at catalog level; runtime refinements allowed

### 5.2 Runtime declaration

* `declaration_mode`: runtime_direct
* `definition_form`: explicit_map
* `available_realization_modes`: `{dense, matvec, cached_matvec}`
* `selected_realization_mode`: runtime_declared
* `pattern_specialization_policy`: pattern_specialized
* `runtime_refinements`:
  * `allowed_object_kinds`:
    * `latent_field`
    * `multivariable_latent_field`
    * `continuous_latent_field`
    * `continuous_multivariable_latent_field`
  * `continuity_metadata_runtime_declared`: true
  * `coordinate_role_metadata_runtime_declared`: true

### 5.3 Target space

* `value_space`: runtime_declared from any admissible value-space class in the spec
* `target_space`: runtime_declared from any admissible target-space class in the spec
* `target_dimension`: runtime_declared
* `base_field`: runtime_declared
* `target_space_definition`: runtime_declared when required
* `norm_definition`: runtime_declared when required
* `value_storage_layout`: runtime_declared, with `point_major_dense` the preferred numeric runtime layout
* `component_semantics`: `univariate_or_scalar` when `target_dimension = 1`; `multivariate_point_axis` when `target_dimension > 1`

### 5.4 Object-specific structure

* `map_signature`: \(Y : \mathcal{M} \to K\), with explicit factor form recorded at runtime when desired
* `object_properties`:
  * `latent_role`: true
  * `regularity_declared_at_runtime`: true
  * `coordinate_roles_declared_at_runtime`: true
  * `evaluation_semantics`:
    * `pointwise_supported`: true
    * `batched_supported`: true
* `runtime_definition_payload`:
  * `definition_handle`: runtime sampler, stochastic rule, or generated evaluator
  * `parameter_payload`: optional runtime parameters

### 5.5 Mean or deterministic convention

* `mean_zero`: yes by default unless runtime mean decomposition is declared downstream
* `mean_decomposition`: runtime_declared when applicable

### 5.6 Stochastic assumptions

* `stochastic_assumptions`:
  * `second_order`: runtime_declared
  * `mean_square_continuous`: runtime_declared
  * `stationarity_regime`: runtime_declared
  * `group_action`: runtime_declared

### 5.7 Notes

* This is the canonical stochastic object family for any already-instantiated admissible domain or admissible product domain.
* No separate catalog object is needed solely because the bound domain changes or because the latent field is continuous, explicit multivariable, or otherwise refined.
* Those distinctions are carried by runtime declaration metadata on the same generic family.

### 5.8 Efficient evaluation binding

* `evaluation_domain_id`: inherited from bound `Domain`
* `finite_binding_status`: downstream_observation_bound
* `evaluation_route`: deferred
* `evaluation_cache_keys`: `[domain_fingerprint, structure_id, runtime_refinements, runtime_definition_payload, stochastic_assumptions]`
* `preferred_chunking`: decided downstream after sample-support binding

---

## 6. DSO-ATTR-STO-01 (generic stochastic attribute operator)

### 6.1 Identification

* `structure_name`: StochasticAttributeOperatorGeneric
* `structure_id`: DSO-ATTR-STO-01
* `bound_domain_id`: inherited from bound `Domain`
* `bound_domain_status`: preinstantiated
* `object_dimensionality`: infinite
* `structure_mode`: stochastic
* `object_kind`: attribute_operator
* `refines_object_kind`: NA

### 6.2 Runtime declaration

* `declaration_mode`: runtime_direct
* `definition_form`: explicit_map
* `available_realization_modes`: `{dense}`
* `selected_realization_mode`: dense
* `pattern_specialization_policy`: generic
* `runtime_refinements`:
  * `attribute_semantics_declared_at_runtime`: true

### 6.3 Target space

* `target_space`: `attribute_space` or `stochastic_space`, runtime-declared
* `target_dimension`: runtime_declared
* `base_field`: NA
* `target_space_definition`:
  * `space_kind`: runtime-declared
  * `declared_at_runtime`: true

### 6.4 Object-specific structure

* `map_signature`: \(A : \mathcal{M} \to X\) for a stochastic attribute-domain object, or \(A : \mathcal{M} \to \Xi\) when the runtime declaration uses a broader stochastic target space
* `object_properties`:
  * `attribute_semantics_declared`: true
  * `target_is_runtime_declared`: true
* `runtime_definition_payload`:
  * `definition_handle`: runtime stochastic rule or lookup rule
  * `attribute_schema`: runtime-declared

### 6.5 Mean or deterministic convention

* `mean_zero`: NA

### 6.6 Stochastic assumptions

* `stochastic_assumptions`:
  * `second_order`: runtime_declared
  * `mean_square_continuous`: runtime_declared
  * `stationarity_regime`: runtime_declared
  * `group_action`: runtime_declared

### 6.7 Notes

* Stochastic attribute operators remain stochastic objects and are never mixed with deterministic semantics in one declaration.

### 6.8 Efficient evaluation binding

* `evaluation_domain_id`: inherited from bound `Domain`
* `finite_binding_status`: downstream_observation_bound
* `evaluation_route`: deferred
* `evaluation_cache_keys`: `[domain_fingerprint, structure_id, target_space_definition, runtime_definition_payload, stochastic_assumptions]`
* `preferred_chunking`: decided downstream after attribute-support binding

---

## 7. Runtime Refinement Patterns

### 7.1 Domain binding rule

* The domain or product domain is instantiated first.
* The object is then instantiated against that existing `bound_domain_id`.
* The same object family may therefore be used on:
  * a single admissible CT domain,
  * a product of admissible CT domains,
  * a product mixing spatial, temporal, parameter, attribute-domain, or discrete-factor components when the bound geometry object allows it.

### 7.2 Multivariable declaration rule

* If factor roles should be explicit at object level, the runtime declaration may set:
  * `object_kind = multivariable_function`, or
  * `object_kind = multivariable_latent_field`.
* This does not create a new catalog object family.
* It is a runtime refinement of the generic function or latent-field family after the product domain already exists.

### 7.3 Continuity and regularity rule

* If continuity or stronger regularity should be explicit at object level, the runtime declaration may set:
  * `object_kind = continuous_function`,
  * `object_kind = continuous_multivariable_function`,
  * `object_kind = continuous_latent_field`, or
  * `object_kind = continuous_multivariable_latent_field`.
* Additional regularity metadata such as Holder exponents, Sobolev order, differentiability class, or norm regime belongs in `object_properties`.
* These refinements do not require separate registry entries in this file.

### 7.4 Concrete function payload rule

* Concrete runtime definitions belong in `runtime_definition_payload`.
* Examples:
  * `runtime_expression = u -> u^2`
  * `runtime_expression = (x,t) -> x^2 + t`
  * `runtime_expression = generated basis expansion with runtime coefficients`
* The catalog object gives the admissible declaration shape; the actual function or rule is supplied only at runtime.

---

## 8. Evaluation Patterns

### 8.1 Canonical standard point-set kinds

Finite point-set kinds are not object-defining at this layer. They are realized downstream.

The following are common downstream realization families that later layers may bind:

* `regular_grid`
* `tensor_product_grid`
* `irregular`
* `mesh_vertices`
* `operator_nodes`

### 8.2 Evaluation-route selection guidance

* `deferred` is the correct object-level default in this file.
* Concrete routes such as `vectorized_direct`, `blockwise_direct`, `operator_expansion`, and `mesh_lookup` are chosen only after downstream finite binding.
* Concrete instantiated functions or latent fields may be evaluated one point at a time or over a whole bound point set in batch.

### 8.3 Minimal efficient runtime payload

Every runtime realization that evaluates one of these objects on a standard point set SHOULD materialize:

* `domain_fingerprint`
* `structure_id`
* `runtime_refinements`
* `runtime_definition_payload`
* `evaluation_route`
* `pointset_structure_fingerprint` after a finite support is actually bound
* `chunk_plan_id` or equivalent chunk metadata when batching is used
* `backend`

---

## 9. References

* `CT_deterministic_random_structures_specs.md`
* `CT_manifold_contracts.md`
* `CT_pointset_contracts.md`
* `common_notation_objects.md`
* `CT_manifold_geometry_objects.md`

