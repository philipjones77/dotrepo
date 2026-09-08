# Comp-SSMM mean-zero, no-nugget, MLE-only test suite

This is a human-readable object note for the **Comp-SSMM**
simulation-analysis pattern in the **mean = 0**, **nugget = 0**,
**MLE-only** phase. The executable authority is
`src/src_continuous/randomfields77_continuous/analysis/v2/patterns/comp_ssmm_m0_n0_v1.py`;
this file mirrors the scenario vocabulary and design intent for
documentation and review.

It assumes the modified model with

\[
\alpha_1 = 1,\qquad \epsilon_1 = \epsilon_2 = 1.
\]

Replications:

* **1000 independent fields per fixed truth scenario**

This document is a **sibling** to [CT_simulation_analysis_pattern_objects.md](CT_simulation_analysis_pattern_objects.md); that file scopes the single-field Matérn baseline pattern, and this file reuses the same pattern structure for the Comp-SSMM product-domain truth family.

---

## 0. Computational scope by approach and size

This test suite is **not** to be interpreted as a dense-covariance study at all sizes.

### 0.1 Dense covariance benchmark scope

Dense covariance-matrix inference is intended only as a **small-sample benchmark**.

Recommended use:

* `N256` for all design types (`RG`, `QI`, `CL`)
* optionally `N1296` for a **very limited overlap subset** of truths/fits if memory and runtime permit

Dense covariance inference is **not** the default for `N4096`.

### 0.2 Scalable operator / SPDE scope

Operator / SPDE / sparse-precision pipelines are intended as the **main engine** for medium- and large-size scenarios.

Recommended use:

* `N256`
* `N1296`
* `N4096`

for all design types (`RG`, `QI`, `CL`) whenever the fitted formulation supports them.

### 0.3 Spectral scope

Spectral pipelines are primarily intended for:

* regular grids
* stationary settings
* medium and large `n`

Recommended use:

* `RG-N256`
* `RG-N1296`
* `RG-N4096`

Use on irregular designs only if an explicit irregularized spectral approximation has been defined.

### 0.4 Basis-expansion scope

Basis-expansion / low-rank pipelines are intended as scalable comparators for:

* `N256`
* `N1296`
* `N4096`

and all design types (`RG`, `QI`, `CL`) where the basis construction is valid.

### 0.5 Interpretation rule

Whenever a scenario block below lists designs and sizes, interpret it as follows:

* **dense covariance**: run only on benchmark-compatible sizes
* **operator/SPDE**: run on full scalable size range
* **spectral**: prioritize regular-grid cases
* **basis**: run on full scalable size range

---

## 1. Global conventions

### 1.1 Fixed structural constants

These are held fixed throughout this phase:

\[
\alpha_1 = 1,\qquad \epsilon_1 = \epsilon_2 = 1,\qquad \tau^2 = 0,\qquad \mu = 0.
\]

### 1.2 Default baseline values

Unless explicitly swept, use

\[
\gamma = 1,\quad
\epsilon_{12} = 0.25,\quad
\kappa_1 = 1.0,\quad
\kappa_2 = 1.2,\quad
\kappa_{12} = 0.9,\quad
\alpha_2 = 1.1,\quad
\alpha_{12} = 0.35,\quad
\nu = 1.0.
\]

### 1.3 Reduced free parameter vector for this phase

\[
\theta = (\gamma,\epsilon_{12},\kappa_1,\kappa_2,\kappa_{12},\alpha_2,\alpha_{12},\nu).
\]

### 1.4 Design codes

* `RG` = regular grid
* `QI` = quasi-uniform irregular design
* `CL` = clustered irregular design

### 1.5 Size codes

* `N256`
* `N1296`
* `N4096`

For irregular designs, the matching nominal sizes are approximately:

* `N256` → about 250 points
* `N1296` → about 1300 points
* `N4096` → about 4000 points

---

## 2. Fit codes

### `F1` Full Comp-SSMM MLE

Estimate
\[
(\gamma,\epsilon_{12},\kappa_1,\kappa_2,\kappa_{12},\alpha_2,\alpha_{12},\nu).
\]

### `F2` Oracle-\(\nu\) MLE

Fix \(\nu\) at truth and estimate
\[
(\gamma,\epsilon_{12},\kappa_1,\kappa_2,\kappa_{12},\alpha_2,\alpha_{12}).
\]

### `F3` Oracle-\(\alpha\) MLE

Fix \((\alpha_2,\alpha_{12})\) at truth and estimate
\[
(\gamma,\epsilon_{12},\kappa_1,\kappa_2,\kappa_{12},\nu).
\]

### `F4` Separable surrogate MLE

Fix
\[
\epsilon_{12}=0,\qquad \alpha_{12}=0,
\]
estimate the remaining parameters.

### `F5` Limited-interaction constrained MLE

Constrain
\[
\alpha_{12} < 0.5
\]
and estimate the remaining free parameters.

### `F6` Threshold-fixed surrogate MLE

Fix
\[
\alpha_{12}=0.5
\]
and estimate the remaining free parameters.

---

## 3. Truth scenario codes

## 3.1 Core family-comparison truths

### `T1SEP` separable benchmark

\[
\epsilon_{12}=0,\qquad \alpha_{12}=0.
\]

### `T2LIM` limited interaction baseline

\[
\epsilon_{12}=0.25,\qquad \alpha_{12}=0.35.
\]

### `T3THR` threshold interaction

\[
\epsilon_{12}=0.25,\qquad \alpha_{12}=0.50.
\]

### `T4EXC` excessive interaction

\[
\epsilon_{12}=0.25,\qquad \alpha_{12}=0.70.
\]

### `T5SEX` strong excessive interaction

\[
\epsilon_{12}=1.0,\qquad \alpha_{12}=0.90.
\]

All other parameters stay at baseline unless otherwise stated.

---

## 3.2 Structural sweep truths

### Interaction-weight sweep

* `TW00` : \(\epsilon_{12}=0\)
* `TW10` : \(\epsilon_{12}=0.10\)
* `TW25` : \(\epsilon_{12}=0.25\)
* `TW50` : \(\epsilon_{12}=0.50\)
* `TW100`: \(\epsilon_{12}=1.00\)
* `TW150`: \(\epsilon_{12}=1.50\)
* `TW200`: \(\epsilon_{12}=2.00\)

### Interaction-exponent sweep

* `TA00` : \(\alpha_{12}=0\)
* `TA20` : \(\alpha_{12}=0.20\)
* `TA35` : \(\alpha_{12}=0.35\)
* `TA45` : \(\alpha_{12}=0.45\)
* `TA50` : \(\alpha_{12}=0.50\)
* `TA70` : \(\alpha_{12}=0.70\)
* `TA90` : \(\alpha_{12}=0.90\)

### Second-factor exponent sweep

* `TS75`  : \(\alpha_2=0.75\)
* `TS100` : \(\alpha_2=1.00\)
* `TS125` : \(\alpha_2=1.25\)
* `TS150` : \(\alpha_2=1.50\)
* `TS200` : \(\alpha_2=2.00\)

### Outer-exponent sweep

* `TV075` : \(\nu=0.75\)
* `TV100` : \(\nu=1.00\)
* `TV150` : \(\nu=1.50\)
* `TV200` : \(\nu=2.00\)
* `TV300` : \(\nu=3.00\)

### Range sweeps

#### First-factor range

* `TK1L` : \(\kappa_1=0.5\)
* `TK1M` : \(\kappa_1=1.0\)
* `TK1H` : \(\kappa_1=2.0\)

#### Second-factor range

* `TK2L` : \(\kappa_2=0.6\)
* `TK2M` : \(\kappa_2=1.2\)
* `TK2H` : \(\kappa_2=2.4\)

#### Coupling range

* `TK12L` : \(\kappa_{12}=0.4\)
* `TK12M` : \(\kappa_{12}=0.9\)
* `TK12H` : \(\kappa_{12}=1.5\)
* `TK12X` : \(\kappa_{12}=2.5\)

---

## 3.3 Joint \((\nu,\alpha)\) truths

These are used for the dedicated joint-smoothness block.

### `J1`

\[
\nu=1.0,\quad \alpha_2=1.1,\quad \alpha_{12}=0.35.
\]

### `J2`

\[
\nu=2.0,\quad \alpha_2=1.1,\quad \alpha_{12}=0.35.
\]

### `J3`

\[
\nu=1.0,\quad \alpha_2=1.1,\quad \alpha_{12}=0.50.
\]

### `J4`

\[
\nu=1.0,\quad \alpha_2=1.1,\quad \alpha_{12}=0.70.
\]

### `J5`

\[
\nu=1.0,\quad \alpha_2=1.5,\quad \alpha_{12}=0.35.
\]

---

## 4. Full scenario ID syntax

Use

\[
\texttt{COMP-M0-N0-[TRUTH]-[DESIGN]-[N]-[FIT]}
\]

Examples:

* `COMP-M0-N0-T2LIM-RG-N256-F1`
* `COMP-M0-N0-T2LIM-QI-N1296-F4`
* `COMP-M0-N0-TA70-CL-N4096-F5`
* `COMP-M0-N0-TV200-RG-N1296-F2`
* `COMP-M0-N0-J4-QI-N4096-F3`

---

## 5. Complete suite of MLE tests

## Block A. Baseline recovery tests

### Computational scope for Block A

* **Dense covariance benchmark**: run on `N256`; optionally on a reduced `N1296` overlap subset only
* **Operator/SPDE pipelines**: run on `N256`, `N1296`, `N4096`
* **Basis-expansion pipelines**: run on `N256`, `N1296`, `N4096`
* **Spectral pipelines**: prioritize `RG-N256`, `RG-N1296`, `RG-N4096`

Truth: `T2LIM`

Run:

* `COMP-M0-N0-T2LIM-RG-N256-F1`
* `COMP-M0-N0-T2LIM-RG-N256-F2`
* `COMP-M0-N0-T2LIM-RG-N256-F3`

Repeat across:

* `RG`, `QI`, `CL`
* `N256`, `N1296`, `N4096`

Purpose:

* baseline parameter recovery
* comparison of full versus oracle-partial estimation
* numerical stability assessment

---

## Block B. Interaction-weight sweep tests

### Computational scope for Block B

* **Dense covariance benchmark**: do not use as the default; if desired, run only a reduced overlap subset at `QI-N256`
* **Operator/SPDE pipelines**: main implementation target for this block
* **Basis-expansion pipelines**: main comparison target for this block
* **Spectral pipelines**: optional only if a compatible stationary regular-grid version of the truth is also run separately

Truths:

* `TW00`
* `TW10`
* `TW25`
* `TW50`
* `TW100`
* `TW150`
* `TW200`

Fits:

* `F1`
* `F4`
* `F5`

Core executable set:

* all truths above
* design `QI`
* size `N1296`

Examples:

* `COMP-M0-N0-TW00-QI-N1296-F1`
* `COMP-M0-N0-TW00-QI-N1296-F4`
* `COMP-M0-N0-TW00-QI-N1296-F5`
* `COMP-M0-N0-TW200-QI-N1296-F1`
* `COMP-M0-N0-TW200-QI-N1296-F4`
* `COMP-M0-N0-TW200-QI-N1296-F5`

Purpose:

* identify when interaction strength becomes estimable
* compare full Comp-SSMM against separable and limited-interaction surrogates

---

## Block C. Interaction-exponent sweep tests

### Computational scope for Block C

* **Dense covariance benchmark**: reduced overlap subset only, if at all, at `N256`
* **Operator/SPDE pipelines**: main implementation target
* **Basis-expansion pipelines**: main scalable comparison target
* **Spectral pipelines**: only on aligned regular-grid surrogate settings where appropriate

Truths:

* `TA00`
* `TA20`
* `TA35`
* `TA45`
* `TA50`
* `TA70`
* `TA90`

Fits:

* `F1`
* `F4`
* `F5`
* `F6`

Core executable set:

* all truths above
* design `QI`
* size `N1296`

Examples:

* `COMP-M0-N0-TA35-QI-N1296-F1`
* `COMP-M0-N0-TA35-QI-N1296-F5`
* `COMP-M0-N0-TA50-QI-N1296-F6`
* `COMP-M0-N0-TA90-QI-N1296-F4`

Purpose:

* test the practical threshold around \(\alpha_{12}=0.5\)
* compare constrained and unconstrained fits across interaction regimes

---

## Block D. Second-factor exponent sweep tests

### Computational scope for Block D

* **Dense covariance benchmark**: optional reduced subset at `N256`
* **Operator/SPDE pipelines**: main implementation target
* **Basis-expansion pipelines**: main scalable comparison target
* **Spectral pipelines**: secondary and only where a compatible grid-based formulation exists

Truths:

* `TS75`
* `TS100`
* `TS125`
* `TS150`
* `TS200`

Fits:

* `F1`
* `F2`
* `F4`

Core executable set:

* all truths above
* design `QI`
* size `N1296`

Purpose:

* assess identifiability of \(\alpha_2\)
* evaluate confounding with \(\alpha_{12}\) and \(\nu\)

---

## Block E. Outer-exponent sweep tests

### Computational scope for Block E

* **Dense covariance benchmark**: optional reduced subset at `N256`
* **Operator/SPDE pipelines**: main implementation target
* **Basis-expansion pipelines**: main scalable comparison target
* **Spectral pipelines**: important comparison target on regular grids, especially for stationary surrogate analyses

Truths:

* `TV075`
* `TV100`
* `TV150`
* `TV200`
* `TV300`

Fits:

* `F1`
* `F2`
* `F3`
* `F4`

Core executable set:

* all truths above
* design `QI`
* size `N1296`

Purpose:

* isolate the effect of \(\nu\)
* compare full estimation to oracle-\(\nu\) and oracle-\(\alpha\) fits

---

## Block F. Range sweep tests

### Computational scope for Block F

* **Dense covariance benchmark**: optional reduced subset at `N256`
* **Operator/SPDE pipelines**: main implementation target
* **Basis-expansion pipelines**: main scalable comparison target
* **Spectral pipelines**: secondary comparison target where the corresponding stationary/grid formulation is available

### First-factor range truths

* `TK1L`
* `TK1M`
* `TK1H`

Fits:

* `F1`
* `F2`
* `F4`

### Second-factor range truths

* `TK2L`
* `TK2M`
* `TK2H`

Fits:

* `F1`
* `F2`
* `F4`

### Coupling-range truths

* `TK12L`
* `TK12M`
* `TK12H`
* `TK12X`

Fits:

* `F1`
* `F2`
* `F4`

Core executable set:

* design `QI`
* size `N1296`

Purpose:

* assess range identifiability
* determine whether range misspecification is absorbed by smoothness or coupling terms

---

## Block G. Family-comparison tests

### Computational scope for Block G

* **Dense covariance benchmark**: use at `N256` only as default; optional reduced overlap subset at `N1296`
* **Operator/SPDE pipelines**: full main block at all sizes/designs
* **Basis-expansion pipelines**: full main block at all sizes/designs
* **Spectral pipelines**: full block mainly on `RG` cases; optional surrogate-only use elsewhere

Truths:

* `T1SEP`
* `T2LIM`
* `T3THR`
* `T4EXC`
* `T5SEX`

Fits:

* `F1`
* `F4`
* `F5`
* `F6`

Designs:

* `RG`
* `QI`
* `CL`

Sizes:

* `N256`
* `N1296`
* `N4096`

Purpose:

* main structural model-class comparison block
* compare full Comp-SSMM to simplified surrogates over major truth regimes

---

## Block H. Joint

### Computational scope for Block H

* **Dense covariance benchmark**: optional and restricted to `N256` or a very small overlap subset
* **Operator/SPDE pipelines**: primary target for this block
* **Basis-expansion pipelines**: primary scalable comparison target
* **Spectral pipelines**: secondary comparison target, mainly on regular-grid compatible formulations

\((\nu,\alpha)\) estimation tests

Truths:

* `J1`
* `J2`
* `J3`
* `J4`
* `J5`

Fits:

* `F1`
* `F2`
* `F3`

Core executable set:

* design `QI`
* size `N1296`

Extension set:

* designs `RG`, `CL`
* size `N4096`

Purpose:

* quantify the extra difficulty of jointly estimating \((\nu,\alpha_2,\alpha_{12})\)
* assess estimator dependence structure and optimizer stability

---

## Block I. Infill asymptotic tests

### Computational scope for Block I

* **Dense covariance benchmark**: restricted to `N256` as the default, with optional overlap at `N1296`
* **Operator/SPDE pipelines**: main asymptotic engine across all sizes
* **Basis-expansion pipelines**: main scalable comparison across all sizes
* **Spectral pipelines**: main regular-grid asymptotic comparison on `RG` cases

Truths:

* `T1SEP`
* `T2LIM`
* `T4EXC`

Fits:

* `F1`
* `F4`
* `F5`

Designs:

* `RG`
* `QI`
* `CL`

Sizes:

* `N256`
* `N1296`
* `N4096`

Purpose:

* empirical fixed-domain asymptotic study
* assess trends in bias, RMSE, stability, and model misspecification as the design gets denser

---

## 6. Outputs to compute for every scenario ID

For every `COMP-M0-N0-*` scenario, store across the **1000 fields**:

### 6.1 Estimation outputs per replication

* \(\hat\gamma\)
* \(\hat\epsilon_{12}\)
* \(\hat\kappa_1,\hat\kappa_2,\hat\kappa_{12}\)
* \(\hat\alpha_2,\hat\alpha_{12}\)
* \(\hat\nu\)
* negative log-likelihood at optimum
* convergence code
* Hessian status
* boundary flags
* runtime

### 6.2 Aggregate parameter summaries

Across the 1000 fields:

* mean
* bias
* empirical SD
* RMSE
* median
* 2.5%, 25%, 75%, 97.5% quantiles

### 6.3 Aggregate numerical diagnostics

Across the 1000 fields:

* success rate
* numerical warning rate
* numerical failure rate
* Hessian failure rate
* boundary estimate rate
* mean and quantiles of runtime

---

## 7. Recommended additional diagnostics

For selected blocks, also compute:

* empirical covariance / correlation matrix of estimators
* profile likelihood summaries in \(\nu\), \(\alpha_2\), \(\alpha_{12}\)
* scatter plots:

  * \((\hat\nu,\hat\alpha_2)\)
  * \((\hat\nu,\hat\alpha_{12})\)
  * \((\hat\alpha_2,\hat\alpha_{12})\)
  * \((\hat\epsilon_{12},\hat\alpha_{12})\)
  * \((\hat\kappa_{12},\hat\alpha_{12})\)

These are especially important for:

* baseline recovery
* joint \((\nu,\alpha)\) estimation
* interaction-exponent sweep

---

## 8. Minimal first executable subset

### Recommended computational interpretation of the minimal subset

* **Primary engine**: operator/SPDE and/or basis-expansion pipelines
* **Optional benchmark overlap**: dense covariance only on a reduced `N256` subset
* **Spectral comparison**: run separately on matched regular-grid stationary surrogate cases if desired

If you want a compact first batch to run before the full suite, use:

### Truths

* `T1SEP`
* `T2LIM`
* `T4EXC`
* `TV075`
* `TV100`
* `TV200`
* `J1`
* `J4`

### Fits

* `F1`
* `F2`
* `F3`
* `F4`
* `F5`

### Design

* `QI`

### Size

* `N1296`

### Replications

* `1000`

This is already a strong and coherent first MLE study.

---

## 9. Lookup tables

### 9.1 Truth code lookup

| Truth code | Meaning                                     |
| ---------- | ------------------------------------------- |
| `T1SEP`    | separable benchmark                         |
| `T2LIM`    | limited interaction baseline                |
| `T3THR`    | threshold interaction                       |
| `T4EXC`    | excessive interaction                       |
| `T5SEX`    | strong excessive interaction                |
| `TW*`      | interaction-weight sweep                    |
| `TA*`      | interaction-exponent sweep                  |
| `TS*`      | second-factor exponent sweep                |
| `TV*`      | outer-exponent sweep                        |
| `TK1*`     | first-factor range sweep                    |
| `TK2*`     | second-factor range sweep                   |
| `TK12*`    | coupling-range sweep                        |
| `J*`       | joint \((\nu,\alpha_2,\alpha_{12})\) truths |

### 9.2 Fit code lookup

| Fit code | Meaning                             |
| -------- | ----------------------------------- |
| `F1`     | full Comp-SSMM MLE                  |
| `F2`     | oracle-\(\nu\) MLE                  |
| `F3`     | oracle-\(\alpha\) MLE               |
| `F4`     | separable surrogate MLE             |
| `F5`     | limited-interaction constrained MLE |
| `F6`     | threshold-fixed surrogate MLE       |
