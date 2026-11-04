"""Fresh-interpreter CPU checks for a candidate environment (after dotrepo's 2026-09-19 JAX handoff)."""
import json, sys, importlib, time, os
os.environ.setdefault("JAX_PLATFORMS", "cpu")
out = {"python": sys.version.split()[0]}
import jax, jaxlib, numpy as np
jax.config.update("jax_enable_x64", True)
import jax.numpy as jnp
out["jax"] = f"{jax.__version__}/{jaxlib.__version__}"
A = jnp.asarray(np.random.default_rng(0).random((5, 5)))
f = lambda X: jnp.sum(jnp.sin(X) ** 2)
out["jit_value_err"] = float(abs(jax.jit(f)(A) - f(A)))
out["grad_err"] = float(jnp.max(jnp.abs(jax.grad(f)(A) - jnp.sin(2 * A))))
M = A @ A.T + 5 * jnp.eye(5); b = jnp.arange(5.0)
out["solve_residual"] = float(jnp.max(jnp.abs(M @ jnp.linalg.solve(M, b) - b)))
x = jnp.asarray(np.random.default_rng(1).random(64))
out["fft_roundtrip"] = float(jnp.max(jnp.abs(jnp.fft.ifft(jnp.fft.fft(x)).real - x)))
out["hessian_ok"] = bool(np.isfinite(np.asarray(jax.hessian(f)(A[0]))).all())
mods = sys.argv[1].split(",") if len(sys.argv) > 1 else []
for name in mods:
    t = time.time()
    try:
        m = importlib.import_module(name)
        out[f"import:{name}"] = f"ok {getattr(m, '__version__', '')} {time.time() - t:.1f}s"
    except Exception as e:
        out[f"import:{name}"] = f"FAIL {type(e).__name__}: {str(e)[:160]}"
if "flax" in mods:
    try:
        import flax.linen as nn
        layer = nn.Dense(3); p = layer.init(jax.random.PRNGKey(0), jnp.ones((2, 4)))
        out["flax_dense"] = float(jnp.sum(jax.jit(layer.apply)(p, jnp.ones((2, 4))) ** 0)) == 6.0
    except Exception as e:
        out["flax_dense"] = f"FAIL {e!r}"[:200]
if "optax" in mods:
    try:
        import optax
        params = jnp.array([3.0]); opt = optax.sgd(0.1); st = opt.init(params)
        loss = lambda p: jnp.sum(p ** 2); g = jax.grad(loss)(params)
        upd, st = opt.update(g, st); out["optax_reduces_loss"] = bool(loss(optax.apply_updates(params, upd)) < loss(params))
    except Exception as e:
        out["optax_reduces_loss"] = f"FAIL {e!r}"[:200]
if "gpflow" in mods:
    try:
        import gpflow
        X = np.linspace(0, 1, 20)[:, None]; Y = np.sin(6 * X)
        m = gpflow.models.GPR((X, Y), kernel=gpflow.kernels.Matern52())
        gpflow.optimizers.Scipy().minimize(m.training_loss, m.trainable_variables, options={"maxiter": 50})
        out["gpflow_gpr_fit_loss"] = float(m.training_loss())
    except Exception as e:
        out["gpflow_gpr_fit_loss"] = f"FAIL {type(e).__name__}: {str(e)[:200]}"
print(json.dumps(out, indent=1))
