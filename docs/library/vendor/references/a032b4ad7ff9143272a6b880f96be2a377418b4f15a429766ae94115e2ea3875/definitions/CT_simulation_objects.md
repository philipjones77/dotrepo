# Simulation Objects

---

*Status*: WORKING  
*Version*: v2.1
*Date*: 2026-04-08  

**Base Documents**

* `architecture.md`  
* `project_overview.md`  
* `CT_project_governance.md`  
* `CT_dependency_governance.md`  
* `spec_standard.md`  
* `common_notation_objects.md`  

**Depends Upon:**

* `CT_io_objects.md`
* `CT_model_structure_objects.md`
* `CT_observation_structure_objects.md`
* `CT_parameter_group_objects.md`
* `CT_simulation_specs.md`

**Is Relied Upon By:**

* examples under `examples/`
* downstream benchmarking

---

## 0. Preamble

### 0.1 Type of file

`details`

### 0.2 Scope and intent

This file provides **concrete instances** of simulation requests/results as
described in `CT_simulation_specs.md`.

These are *examples* and are not intended to be exhaustive.

---

## 1. Example: 1D Matérn latent field on a regular grid

### 1.1 SimulationRequest

```json
{
  "request_id": "sim-1d-matern-grid-v1",
  "model_id": "NP-M-HM-SF01-01-GG",
  "kernel_id": "matern_iso",
  "sampling_design_id": "SD-1D-GRID-32",
  "parameter_values": {
    "variance": 1.0,
    "lengthscale": 0.2,
    "nu": 1.5
  },
  "method_id": "spectral_fft",
  "random_seed": 0,
  "n_draws": 1,
  "return_latent": true,
  "return_observations": false
}
```

### 1.2 SimulationResult skeleton

```json
{
  "request_id": "sim-1d-matern-grid-v1",
  "model_id": "NP-M-HM-SF01-01-GG",
  "kernel_id": "matern_iso",
  "sampling_design_id": "SD-1D-GRID-32",
  "method_id": "spectral_fft",
  "random_seed_used": 0,
  "latent_draws": "<array of length n_points>",
  "ordering_convention": "observation structure point ordering"
}
```

---

## 2. Example: Prior predictive simulation with observations

### 2.1 SimulationRequest with observations

```json
{
  "request_id": "sim-prior-predictive-v1",
  "model_id": "NP-M-HM-SF01-01-GG",
  "kernel_id": "matern_iso",
  "sampling_design_id": "SD-1D-GRID-32",
  "parameter_values": {
    "variance": 1.0,
    "lengthscale": 0.2,
    "nu": 1.5,
    "tau2": 0.01
  },
  "method_id": "spectral_fft",
  "random_seed": 42,
  "observation_seed": 123,
  "n_draws": 100,
  "return_latent": true,
  "return_observations": true
}
```

### 2.2 SimulationResult skeleton with observations

```json
{
  "request_id": "sim-prior-predictive-v1",
  "model_id": "NP-M-HM-SF01-01-GG",
  "kernel_id": "matern_iso",
  "sampling_design_id": "SD-1D-GRID-32",
  "method_id": "spectral_fft",
  "random_seed_used": 42,
  "observation_seed_used": 123,
  "latent_draws": "<array of shape (100, 32)>",
  "observation_draws": "<array of shape (100, 32)>",
  "ordering_convention": "observation structure point ordering"
}
```

**Interpretation**:

* Latent draws: 100 realizations of $Y \\sim \\text{GP}(0, C(\\cdot,\\cdot))$ on 32 grid points
* Observation draws: For each latent realization, $Z_i \\mid Y(x_i) \\sim \\mathcal{N}(Y(x_i), \\tau^2)$ independently
* This represents prior predictive samples: what data we'd expect to see before observing any actual measurements

---

## 3. Implementation adapter example (current repository)

The current implementation does not yet provide a full registry for
`sampling_design_id` and `domain_id`. Instead, simulation is driven by a
concrete `job_spec` payload consumed by:

* `src/src_continuous/randomfields77_continuous/simulation/engine.py::simulate_latent`
* `src/src_continuous/randomfields77_continuous/simulation/pipeline.py::run_simulation_pipeline`

### 2.1 Concrete `job_spec` for the example above

```json
{
  "kernel_id": "matern_iso",
  "method_id": "spectral_fft",
  "random_seed": 0,
  "kernel_params": {
    "variance": 1.0,
    "lengthscale": 0.2,
    "nu": 1.5
  },
  "domain_spec": {
    "name": "E1",
    "blocks": [
      {
        "name_k": "x",
        "manifold_type_k": "euclidean",
        "manifold_underlying_type_k": "euclidean",
        "usage_k": "space",
        "axes_k": [{"axis_name": "x", "axis_kind": "space", "units": "m"}],
        "coord_rep_k": "cartesian",
        "domain_metric_k": {"metric_type": "euclidean"},
        "anisotropy_k": null,
        "restriction_spec_k": null
      }
    ]
  },
  "sampling_spec": {
    "pointset_id": "U-grid-32",
    "layout_kind": "regular_grid",
    "layout_metadata": {
      "grid_axes": [[0.0, 0.032258, 0.064516, 0.096774, 0.129032, 0.161290]]
    },
    "points": [[0.0], [0.032258], [0.064516], [0.096774]]
  }
}
```

Notes:

* The `grid_axes` and `points` arrays are shown truncated for readability.
* In practice, `grid_axes[0]` must list all grid coordinates and `points` must
  list all `(n, d)` points.

### 2.2 Runnable constructor snippet

The snippet below constructs a complete `job_spec` (including full axes and
point lists) for a 1D grid, and runs the pipeline using the NumPy backend.

```python
import numpy as np

from randomfields77_continuous.simulation.pipeline import run_simulation_pipeline

x = np.linspace(0.0, 1.0, 32, dtype=float)

domain_spec = {
    "name": "E1",
    "blocks": [
        {
            "name_k": "x",
            "manifold_type_k": "euclidean",
            "manifold_underlying_type_k": "euclidean",
            "usage_k": "space",
            "axes_k": [{"axis_name": "x", "axis_kind": "space", "units": "m"}],
            "coord_rep_k": "cartesian",
            "domain_metric_k": {"metric_type": "euclidean"},
            "anisotropy_k": None,
            "restriction_spec_k": None,
        }
    ],
}

sampling_spec = {
    "pointset_id": "U-grid-32",
    "layout_kind": "regular_grid",
    "layout_metadata": {"grid_axes": [x.tolist()], "grid_ordering": "C"},
    "points": (x[:, None]).tolist(),
}

job_spec = {
    "kernel_id": "matern_iso",
    "method_id": "spectral_fft",
    "random_seed": 0,
    "kernel_params": {"variance": 1.0, "lengthscale": 0.2, "nu": 1.5},
    "domain_spec": domain_spec,
    "sampling_spec": sampling_spec,
}

out = run_simulation_pipeline(job_spec, backend="numpy", output_root="./_out", persist_level="summary")
print(out["run_id"], out["metrics"])
```

---

## 4. v2 model-driven examples

The model-driven simulation engine
(`src/src_continuous/randomfields77_continuous/simulation/`) takes a
`RandomFieldModel` containing a `DomainSpec` (1/2/3-input, including meshes),
a `KernelSpec`, a `MeanFunctionSpec`, a `MarginalSpec`, an `ObservationSpec`,
and a `MethodSpec` (`method_id` × `path ∈ {dense, operator}` × `method_kwargs`),
and returns a `SimulationResult` carrying *both* `latent_field` and
`observation_field` arrays of shape `(n_samples, n_points)`.

### 4.1 Cholesky-dense, 1-D Euclidean, constant mean, Gaussian nugget

```python
import numpy as np
from randomfields77_continuous.models import (
    DomainSpec, KernelSpec, MeanFunctionSpec, MarginalSpec, ObservationSpec,
    MethodSpec, RandomFieldModel,
)
from randomfields77_continuous.models import DomainBlock
from randomfields77_continuous.simulation import simulate

block = DomainBlock(name="x", geometry="euclidean",
                    points=np.linspace(0.0, 1.0, 32).reshape(-1, 1))

model = RandomFieldModel(
    model_id="HMMf5-GGZN-Base0",  # catalog reference; mean/observation derived
    domain_spec=DomainSpec(blocks=(block,)),
    kernel_spec=KernelSpec(kernel_id="matern_three_half",
                           params={"variance": 1.0, "lengthscale": 0.2}),
    mean_spec=MeanFunctionSpec(kind="constant", params={"mu": 0.0}),
    marginal_spec=MarginalSpec(kind="gaussian"),
    observation_spec=ObservationSpec(forward_kind="identity",
                                     noise_kind="gaussian",
                                     noise_params={"sigma": 0.1}),
    method_spec=MethodSpec(method_id="cholesky", path="dense"),
    simulation_kind="both",
)

result = simulate(model, n_samples=64, seed=0)
assert result.latent_field.shape == (64, 32)
assert result.observation_field.shape == (64, 32)
```

### 4.2 SPDE on a 2-D triangular mesh

```python
verts = np.array([[0.,0.],[1.,0.],[1.,1.],[0.,1.],[0.5,0.5]], dtype=float)
cells = np.array([[0,1,4],[1,2,4],[2,3,4],[3,0,4]], dtype=int)
mesh = DomainBlock(name="omega", geometry="mesh", vertices=verts, cells=cells)

model = RandomFieldModel(
    domain_spec=DomainSpec(blocks=(mesh,)),
    kernel_spec=KernelSpec(kernel_id="matern_three_half",
                           params={"variance": 1.0}),
    method_spec=MethodSpec(method_id="spde", path="dense",
                           method_kwargs={"kappa": 4.0, "alpha": 2.0}),
    simulation_kind="latent",
)
```

### 4.3 3-input domain (space × time × covariate)

```python
b_space = DomainBlock(name="space", geometry="euclidean",
                      points=np.linspace(0,1,8).reshape(-1,1))
b_time  = DomainBlock(name="time",  geometry="euclidean",
                      points=np.linspace(0,2,6).reshape(-1,1))
b_cov   = DomainBlock(name="z",     geometry="euclidean",
                      points=np.linspace(0,1,4).reshape(-1,1))

model = RandomFieldModel(
    domain_spec=DomainSpec(blocks=(b_space, b_time, b_cov)),
    kernel_spec=KernelSpec(kernel_id="squared_exponential",
                           params={"variance": 1.0, "lengthscale": 0.5}),
    method_spec=MethodSpec(method_id="cholesky", path="operator",
                           method_kwargs={"rank": 64}),
    simulation_kind="latent",
)
```

### 4.4 Variance-gamma marginal via subordination

```python
model = RandomFieldModel(
    domain_spec=DomainSpec(blocks=(block,)),
    kernel_spec=KernelSpec(kernel_id="matern_three_half",
                           params={"variance": 1.0, "lengthscale": 0.3}),
    marginal_spec=MarginalSpec(
        kind="subordinated",
        params={"subordinator": "gamma", "shape": 2.0, "scale": 1.0, "drift": 0.0}),
    method_spec=MethodSpec(method_id="cholesky", path="dense"),
    simulation_kind="latent",
)
```

---

## 5. Change log

* v0.6.0 (2026-04-08): added v2 model-driven examples for Cholesky/SPDE/3-input/
  variance-gamma marginal alongside the existing v1 `run_simulation_pipeline`
  examples.
* v0.5.0 (2026-01-24): added prior predictive simulation example with both latent
  and observation fields; updated all examples to include `return_latent`,
  `return_observations` fields; aligned with spec v0.5.0 observation simulation
  support.
* v0.4.0 (2026-01-20): rewrote to spec-standards format and aligned objects with
  the implemented simulation pipeline adapters.
