# Constraint Set Objects — Continuous Track

---
*Status*: WORKING
*Version*: v2.1
*Date*: 2026-03-16

**Base Documents**

* `architecture.md`
* `project_overview.md`
* `CT_project_governance.md`
* `CT_dependency_governance.md`
* `spec_standard.md`
* `common_notation_objects.md`

**Depends Upon:**

* `CT_constraint_set_specs.md`

**Is Relied Upon By:**

* `CT_inference_common_objects.md`
* `CT_inference_run_plan_objects.md`

---

## 0. Preamble

### 0.0 Summary of Contents

1. Default positivity / admissibility constraints for a covariance-representation Matérn run.
2. Fixing a smoothness parameter at runtime.
3. Equality-tie constraints across variables.
4. A soft validity-rule example.

### 0.1 Type of file

`details`

### 0.2 Scope and intent

This file provides concrete examples of runtime constraint sets consistent with `CT_constraint_set_specs.md`.

### 0.3 How to read this file

Choose a constraint set that is compatible with the active parameter grouping bundle and inference request.

### 0.4 Summary of Assumptions and Preconditions

* Variable IDs are resolved from the active runtime bundle.
* These examples illustrate semantics; implementations may enforce them through transforms, solvers, barriers, or projections.

### 0.5 Notation, Inputs and Aliases

No additional notation is introduced.

### 0.6 Validation and Authority Rules

* These objects instantiate, but do not extend, the constraint grammar.

---

## 1. `CSET:COV-SM-DEFAULT-01`: hard positivity and admissibility in native space

```yaml
constraint_set_id: CSET:COV-SM-DEFAULT-01
constraint_set_kind: hard
constraints:
  - constraint_id: C:BOX-sigma2_Y
    constraint_kind: box
    variable_space: native
    variables: [sigma2_Y]
    origin_class: built_in_admissibility
    severity: hard
    handling: reject
    parameters:
      lower: 0.0
      upper: +inf
  - constraint_id: C:BOX-kappa_Y
    constraint_kind: box
    variable_space: native
    variables: [kappa_Y]
    origin_class: built_in_admissibility
    severity: hard
    handling: reject
    parameters:
      lower: 0.0
      upper: +inf
  - constraint_id: C:BOX-nu_Y
    constraint_kind: box
    variable_space: native
    variables: [nu_Y]
    origin_class: built_in_admissibility
    severity: hard
    handling: reject
    parameters:
      lower: 0.0
      upper: +inf
  - constraint_id: C:BOX-tau2_Z
    constraint_kind: box
    variable_space: native
    variables: [tau2_Z]
    origin_class: built_in_admissibility
    severity: hard
    handling: reject
    parameters:
      lower: 0.0
      upper: +inf
notes: Positivity constraints for the covariance-route Matérn example.
```

---

## 2. `CSET:FIX-NU-01`: hold smoothness fixed at runtime

```yaml
constraint_set_id: CSET:FIX-NU-01
constraint_set_kind: hard
constraints:
  - constraint_id: C:FIX-nu_Y
    constraint_kind: fixed
    variable_space: native
    variable_id: nu_Y
    origin_class: user_runtime
    severity: hard
    handling: transform
    value: 1.5
notes: Useful for runs in which smoothness is fixed before optimization or where only a microergodic combination is reported.
```

---

## 3. `CSET:EQ-kappa-Y-ETA-01`: equality tie across latent layers

```yaml
constraint_set_id: CSET:EQ-kappa-Y-ETA-01
constraint_set_kind: hard
constraints:
  - constraint_id: C:EQ-kappa_Y-kappa_ETA
    constraint_kind: equality
    variable_space: native
    variables: [kappa_Y, kappa_ETA]
    latent_layer_id: Y
    origin_class: identifiability
    severity: hard
    handling: projection
notes: Enforces a shared range parameter across the primary latent layer and the residual mean layer.
```

---

## 4. `CSET:SOFT-VALIDITY-MICROERGODIC-01`: soft runtime validity note

```yaml
constraint_set_id: CSET:SOFT-VALIDITY-MICROERGODIC-01
constraint_set_kind: mixed
constraints:
  - constraint_id: C:RULE-microergodic-only-low-dim
    constraint_kind: validity_rule
    variable_space: derived
    variables: [microergodic_Y]
    origin_class: identifiability
    severity: soft
    handling: diagnostic_only
    rule_id: microergodic_only_low_dimension
    rule_scope: model
    parameters:
      notes: Primitive scale and range parameters may only be stably inferable through a derived combination in the active asymptotic regime.
notes: Example of a soft diagnostic rule that does not alter the feasible region.
```

---

## 5. Summary

* The default hard set encodes positivity / admissibility.
* Smoothness can be held fixed by a dedicated `fixed` constraint.
* Shared parameters across layers can be expressed with an `equality` constraint.
* Soft validity rules can document identifiable-only regimes without changing feasibility.
