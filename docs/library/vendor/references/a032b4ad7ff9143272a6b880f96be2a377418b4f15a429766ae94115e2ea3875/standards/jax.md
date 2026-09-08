# JAX Programming Standard

Use the [Python standard](python.md) and [toolchain](tooling.md) as the baseline. These are
conventions for JAX projects consuming this repository's standards; the references automation does
not require JAX and CI does not claim to test JAX kernels. Pin JAX/jaxlib and accelerator
dependencies in each consuming project, with its supported device/dtype matrix.

## Functions, State, and Randomness

Write pure numerical functions: return new results/state rather than mutating Python objects or
capturing changing globals. Keep file IO, logging, validation with Python exceptions, and data
loading outside transformed functions. Represent structured state as documented PyTrees with stable
structure. Do not use a mutable class instance as a static JIT argument.

Pass PRNG keys explicitly. Prefer typed keys from `jax.random.key(seed)` in new code; document
legacy key interoperability where required. Split a fresh key for each independent draw. Never reuse
a consumed key. Return the next key when a function owns a sequence of draws. Use `fold_in` with
documented indices for reproducible independent streams, including device/process distinctions when
distributed.

```python
import jax
import jax.numpy as jnp


def add_normal_noise(key: jax.Array, values: jax.Array) -> tuple[jax.Array, jax.Array]:
    """Return the next key and noisy floating-point values of the same shape/dtype."""
    next_key, noise_key = jax.random.split(key)
    noise = jax.random.normal(noise_key, values.shape, dtype=values.dtype)
    return next_key, values + noise
```

The example assumes real floating-point input and unit noise scale. Public application APIs should
document their distribution, scale, shapes, dtypes, and supported domains explicitly.

## Arrays, Shapes, and Dtypes

Use `jax.Array` in type hints and `jax.numpy` inside transformed numerical code. NumPy is
appropriate at host IO/test boundaries; do not convert tracers to NumPy or Python scalars. Document
axes and broadcasting contracts, for example `observations: (sample_count, feature_count)` and
`precision_matrix: (feature_count, feature_count)`. Array annotations alone do not enforce shapes.

Use immutable updates (`array.at[index].set(...)` or `.add(...)`). Choose floating-point precision
and integer types intentionally. If an application needs 64-bit arithmetic, configure
`jax_enable_x64` at its entry point before creating arrays/compiling; a shared library must not
silently change global JAX configuration. Test the supported precision explicitly rather than
assuming requested float64 survived with x64 disabled. Avoid repeated host/device transfers inside
loops.

## Transformations and Control Flow

Use `jit` around stable computational boundaries, not freshly created functions inside a loop.
Static arguments should be small, immutable structural choices; marking large/changing data static
causes recompilation and can be invalid. Keep output shapes static under JIT. Avoid data-dependent
Python branching, dynamic-length boolean indexing, and Python scalar conversion of traced values.

Use `lax.cond` for traced scalar predicates and `lax.scan` for suitable recurrent computations. Use
`lax.while_loop` only with awareness of its autodiff limitations, notably reverse-mode
differentiation. Use `vmap` for independent batch axes and document `in_axes`/`out_axes`; it is not
a replacement for dependent iterations. Do not assume every transformation composition is valid
without testing it.

Ordinary `print` observes tracing, not necessarily each execution. Use `jax.debug.print` only for
temporary compiled debugging, and remove or gate it before benchmarking. Consider `checkify` for
runtime checks inside transformed code; document its use and overhead rather than raising Python
exceptions on tracers.

## Numerical Reliability

Use stable operations (`logsumexp`, appropriate factorizations, solves) instead of naive
exponentials or matrix inversion. State positive-definiteness and conditioning assumptions; if
regularization/jitter is used, make its scale and scientific meaning explicit. Do not silently
change a model to hide a failed factorization.

Ensure expressions are valid over differentiated domains. A `where` masking an invalid `log`,
division, or square root does not necessarily prevent NaN gradients: make inactive expressions
numerically safe before selection. Do not mask numerical failures as valid likelihoods.

Test eager and JIT results against small trusted examples with dtype-appropriate tolerances. Where
supported, test `vmap`, gradients against finite differences or analytic results, shape contracts,
reproducible key handling, and finite values at boundary cases. Record unsupported transformations.
Require CPU tests; add accelerator tests for supported devices and avoid claiming cross-device
bitwise identity for floating-point results.

## Performance Evidence

Separate compilation, host/device transfer, and steady-state execution measurements. Warm up
compiled functions and synchronize all relevant array outputs with `block_until_ready()` before
stopping a timer; dispatch alone is asynchronous. Record JAX/jaxlib versions, hardware/backend,
shapes, dtypes, compilation settings, repetitions, and whether transfers were included. Measure
before introducing sharding or buffer donation; document ownership because donated buffers must not
be reused.

## Official References

- [JIT and pure functions](https://docs.jax.dev/en/latest/jit-compilation.html)
- [Random numbers and keys](https://docs.jax.dev/en/latest/random-numbers.html)
- [Common JAX pitfalls](https://docs.jax.dev/en/latest/notebooks/Common_Gotchas_in_JAX.html)
- [Benchmarking JAX](https://docs.jax.dev/en/latest/benchmarking.html)
- [Structured control flow](https://docs.jax.dev/en/latest/control-flow.html)
