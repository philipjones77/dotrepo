# Random Field Representation Details

---

*Status*: WORKING
*Version*: v2.2
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
* `CT_deterministic_random_structures_objects.md`
* `CT_representation_specs.md`

**Is Relied Upon By:**

* `CT_kernel_specs.md`
* Kernel family detail files that consume representation IDs

---

## 0. Preamble

### 0.0 Call Registry

* Registered representation IDs:
  * `RF-COV-01`
  * `GRF-VAR-01`
  * `RF-SPEC-01`
  * `RF-SPECM-01`
  * `GRF-SPEC-01`
  * `RF-LAPLACE-01`
  * `RF-MIXED-01`
  * `OP-COV-01`
  * `OP-PREC-01`
  * `OP-SPDE-01`
  * `OP-01` (deprecated alias of `OP-SPDE-01`)

### 0.1 Type of file

`details`

### 0.2 Scope and Intent

* Enumerates deterministic second-order objects used by kernels.
* Applies to a mean-zero random structure declared in `CT_deterministic_random_structures_specs.md`.

### 0.3 How to read this file

* Section 1 provides the template.
* Sections 2+ list concrete representations.

### 0.4 Summary of Assumptions and Preconditions

* Latent field $Y$ exists with declared target space.
* Geometry and notation are authoritative elsewhere.

### 0.5 Notation, Inputs and Aliases

* Uses only notation defined in `common_notation_objects.md`; no additional aliases introduced here.

### 0.6 Validation and Authority Rules

* Each representation must be compatible with at least one kernel family.
* Representation IDs must be unique and referenced by kernels through `primary_representation_id` or `supported_representation_ids`.

### 0.7 Template

* Section 1 is the canonical template; each field must be populated for every representation.
* If not applicable: `NA`. If applicable but unknown: `Not Known`.

---

## 1. Representation Template

Each entry must fill all fields. Use `NA` or `Not Known` where appropriate.

### 1.1 Identification

* `representation_name`
* `representation_id`
* `representation_type`
* `operator_role` (required when `representation_type = operator`; else `NA`)
* `structure_order` (must be `second_order`)

---

### 1.2 Domain applicability

* `supported_domain_types`
* `blockwise_supported`: yes / no
* `product_domain_support`: yes / no

---

### 1.3 Target-space compatibility

* `supported_target_spaces`

---

### 1.4 RF / GRF semantics

* `RF_or_GRF`
* `pointwise_variance_exists`: yes / no / depends
* `stationarity_type`: stationary / stationary_increments / nonstationary

---

### 1.5 Deterministic object produced

* `object_type`: function / measure / operator / matrix / pair
* `object_domain`
* `symmetry_requirement`: symmetric / Hermitian / self-adjoint / NA
* `positive_definiteness`

---

### 1.6 Mapping to kernels

* `kernel_consumption_mode`: full_object / blockwise_components / induced_distances

---

### 1.7 Notes

* Free-form clarifications
* If a note does not explicitly narrow stochastic applicability, interpret the representation as admissible for both RF and GRF semantics subject to the declared field constraints.

---

## 2. Stationary covariance representation (RF)

### Identification

* `representation_name`: StationaryCovariance
* `representation_id`: RF-COV-01
* `representation_type`: covariance
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector

### RF / GRF semantics

* `RF_or_GRF`: RF
* `pointwise_variance_exists`: yes
* `stationarity_type`: stationary

### Deterministic object produced

* `object_type`: function
* `object_domain`: lag space
* `symmetry_requirement`: symmetric
* `positive_definiteness`: required

### Mapping to kernels

* `kernel_consumption_mode`: full_object

### Notes

* Classical covariance-function representation.
* Valid only when pointwise variance exists (RF semantics).

---

## 3. Variogram representation (GRF / stationary increments)

### Identification

* `representation_name`: Variogram
* `representation_id`: GRF-VAR-01
* `representation_type`: variogram
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector

### RF / GRF semantics

* `RF_or_GRF`: RF or GRF
* `pointwise_variance_exists`: no / depends
* `stationarity_type`: stationary_increments

### Deterministic object produced

* `object_type`: function
* `object_domain`: lag space
* `symmetry_requirement`: symmetric
* `positive_definiteness`: conditionally negative definite (increment-variance object)

### Mapping to kernels

* `kernel_consumption_mode`: full_object

### Notes

* The canonical second-order object for increment-stationary (intrinsic) models.
* When an RF covariance exists, the associated variogram can be formed, so this representation applies to both RF and GRF semantics for stationary-increment structure.

---

## 4. Spectral density representation (RF)

### Identification

* `representation_name`: SpectralDensity
* `representation_id`: RF-SPEC-01
* `representation_type`: spectral_density
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

### RF / GRF semantics

* `RF_or_GRF`: RF
* `pointwise_variance_exists`: yes (if integrable)
* `stationarity_type`: stationary

### Deterministic object produced

* `object_type`: function
* `object_domain`: frequency space
* `symmetry_requirement`: symmetric (real), Hermitian (complex)
* `positive_definiteness`: nonnegative

### Mapping to kernels

* `kernel_consumption_mode`: full_object

### Notes

* Fourier inversion recovers covariance when the spectral density is integrable.

---

## 5. Spectral measure representation (RF / stationary)

### Identification

* `representation_name`: SpectralMeasureFinite
* `representation_id`: RF-SPECM-01
* `representation_type`: spectral_measure
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

### RF / GRF semantics

* `RF_or_GRF`: RF
* `pointwise_variance_exists`: yes
* `stationarity_type`: stationary

### Deterministic object produced

* `object_type`: measure
* `object_domain`: frequency space
* `symmetry_requirement`: symmetric / Hermitian
* `positive_definiteness`: nonnegative finite measure

### Mapping to kernels

* `kernel_consumption_mode`: full_object

### Notes

* Covers singular/atomic spectral measures where no spectral density exists.
* Spectral density representation is the absolutely-continuous special case of this representation.

---

## 6. Spectral measure representation (GRF / stationary increments)

### Identification

* `representation_name`: SpectralMeasureIncrements
* `representation_id`: GRF-SPEC-01
* `representation_type`: spectral_measure
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

### RF / GRF semantics

* `RF_or_GRF`: GRF
* `pointwise_variance_exists`: no
* `stationarity_type`: stationary_increments

### Deterministic object produced

* `object_type`: measure
* `object_domain`: frequency space
* `symmetry_requirement`: symmetric / Hermitian
* `positive_definiteness`: nonnegative (possibly infinite) measure satisfying the GRF integrability constraints

### Mapping to kernels

* `kernel_consumption_mode`: full_object

### Notes

* Includes singular and atomic components.
* Used in variogram-style spectral representations for increment-stationary generalized fields.

---

## 7. Laplace-transform representation (kernel-level)

### Identification

* `representation_name`: LaplaceTransformKernel
* `representation_id`: RF-LAPLACE-01
* `representation_type`: laplace_transform
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector

### RF / GRF semantics

* `RF_or_GRF`: RF
* `pointwise_variance_exists`: yes
* `stationarity_type`: stationary

### Deterministic object produced

* `object_type`: function
* `object_domain`: Laplace parameter space (one-sided, nonnegative parameter)
* `symmetry_requirement`: NA
* `positive_definiteness`: NA (representation-specific admissibility constraints apply at the kernel level)

### Mapping to kernels

* `kernel_consumption_mode`: full_object

### Notes

* This is the (kernel-level) Laplace transform of a one-sided lag covariance function:
  * s ↦ ∫_0^∞ exp(-s h) C(h) dh, interpreting h ≥ 0.
* This object is **not** the domain Laplacian operator (Laplace–Beltrami / Euclidean Laplacian), which is declared in the domain-geometry layer.

---

## 8. Mixed / half-spectral representation

### Identification

* `representation_name`: MixedSpectral
* `representation_id`: RF-MIXED-01
* `representation_type`: mixed
* `operator_role`: NA
* `structure_order`: second_order

### Domain applicability

* `supported_domain_types`: euclidean (supports product domains)
* `blockwise_supported`: yes
* `product_domain_support`: yes

### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

### RF / GRF semantics

* `RF_or_GRF`: RF or GRF
* `pointwise_variance_exists`: depends on spectral block
* `stationarity_type`: stationary

### Deterministic object produced

* `object_type`: pair
* `object_domain`: frequency and lag space
* `symmetry_requirement`: inherited
* `positive_definiteness`: by construction

### Mapping to kernels

* `kernel_consumption_mode`: blockwise_components

### Notes

* Common in space-time modeling.
* This is a standalone second-order representation even when operational pipelines evaluate it only on finite lag/frequency sets.

---

## 9. Operator representations (covariance / precision / SPDE)

### 9.1 Covariance operator representation

#### Identification

* `representation_name`: CovarianceOperator
* `representation_id`: OP-COV-01
* `representation_type`: operator
* `operator_role`: covariance_operator
* `structure_order`: second_order

#### Domain applicability

* `supported_domain_types`: euclidean, sphere, manifold
* `blockwise_supported`: yes
* `product_domain_support`: yes

#### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

#### RF / GRF semantics

* `RF_or_GRF`: RF or GRF
* `pointwise_variance_exists`: depends (e.g. trace-class vs generalized)
* `stationarity_type`: stationary or nonstationary

#### Deterministic object produced

* `object_type`: operator
* `object_domain`: function/distribution space
* `symmetry_requirement`: self-adjoint
* `positive_definiteness`: positive semidefinite operator

#### Mapping to kernels

* `kernel_consumption_mode`: full_object or induced_distances

#### Notes

* For RFs, this operator corresponds to an integral operator induced by the covariance kernel (when defined).
* For GRFs, this may be interpreted via weak / distributional formulations.
* Operator constructions may reference domain operators (e.g. Laplacian, gradient/divergence) declared in `CT_manifold_geometry_objects.md`.

---

### 9.2 Precision operator representation

#### Identification

* `representation_name`: PrecisionOperator
* `representation_id`: OP-PREC-01
* `representation_type`: operator
* `operator_role`: precision_operator
* `structure_order`: second_order

#### Domain applicability

* `supported_domain_types`: euclidean, sphere, manifold
* `blockwise_supported`: yes
* `product_domain_support`: yes

#### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

#### RF / GRF semantics

* `RF_or_GRF`: RF or GRF
* `pointwise_variance_exists`: depends
* `stationarity_type`: stationary or nonstationary

#### Deterministic object produced

* `object_type`: operator
* `object_domain`: function/distribution space
* `symmetry_requirement`: self-adjoint
* `positive_definiteness`: positive (typically unbounded) operator

#### Mapping to kernels

* `kernel_consumption_mode`: full_object or induced_distances

#### Notes

* When it exists as an operator inverse, Q = C^{-1}.
* Precision operators are the primary objects for Markov structure and sparse discretizations.
* Operator constructions may reference domain operators (e.g. Laplacian) declared in `CT_manifold_geometry_objects.md`.

---

### 9.3 Generator / SPDE operator representation

#### Identification

* `representation_name`: SPDEOperator
* `representation_id`: OP-SPDE-01
* `representation_type`: operator
* `operator_role`: generator_operator
* `structure_order`: second_order

#### Domain applicability

* `supported_domain_types`: euclidean, sphere, manifold
* `blockwise_supported`: yes
* `product_domain_support`: yes

#### Target-space compatibility

* `supported_target_spaces`: real_scalar, real_vector, complex_scalar, complex_vector

#### RF / GRF semantics

* `RF_or_GRF`: RF or GRF
* `pointwise_variance_exists`: depends on operator formulation
* `stationarity_type`: stationary or nonstationary

#### Deterministic object produced

* `object_type`: operator
* `object_domain`: function/distribution space
* `symmetry_requirement`: depends (often constructed so that Q = L*L is self-adjoint)
* `positive_definiteness`: depends (typically used to induce a positive precision operator)

#### Mapping to kernels

* `kernel_consumption_mode`: full_object or induced_distances

#### Notes

* Generator/SPDE operators define the field via a (weak) equation of the form L Y = W.
* In common constructions, the induced precision operator has the form Q = L*L.
* Operator constructions may reference domain operators (e.g. Laplacian, gradient/divergence) declared in `CT_manifold_geometry_objects.md`.

---

### 9.4 Deprecated legacy alias (backwards compatibility)

#### Identification

* `representation_name`: SPDEOperator_Legacy
* `representation_id`: OP-01
* `representation_type`: operator
* `operator_role`: generator_operator
* `structure_order`: second_order

#### Notes

* Deprecated alias of `OP-SPDE-01`. New kernels SHOULD reference `OP-SPDE-01` instead.

---

## 10. Open Questions

* None. Populate this section with representation-detail issues while status is WORKING.

---

## 11. References

* `CT_deterministic_random_structures_specs.md`
* `CT_representation_specs.md`
* `CT_kernel_specs.md`
