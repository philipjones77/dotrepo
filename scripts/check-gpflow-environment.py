"""Small deterministic CPU runtime checks for an installed GPflow package stack."""

import json
import math
import platform
import sys
import traceback
from datetime import datetime, timezone
from importlib import metadata
from pathlib import Path

report = {
    "started_at": datetime.now(timezone.utc).isoformat(),
    "python": platform.python_version(),
    "scope": "CPU smoke checks only; no GPU or full project regression validation.",
    "checks": {},
    "passed": False,
}


def prediction(model, x):
    mean, variance = model.predict_f(x)
    assert mean.shape == variance.shape == x.shape
    assert np.isfinite(mean.numpy()).all()
    assert np.isfinite(variance.numpy()).all()
    assert (variance.numpy() >= 0).all()
    return {"shape": list(mean.shape), "minimum_variance": float(variance.numpy().min())}


def finite_gradients(loss_function, variables):
    with tf.GradientTape() as tape:
        loss = loss_function()
    gradients = tape.gradient(loss, variables)
    assert gradients and all(g is not None and np.isfinite(g.numpy()).all() for g in gradients)
    assert math.isfinite(float(loss))
    return loss, gradients


try:
    import numpy as np
    import tensorflow as tf

    tf.config.set_visible_devices([], "GPU")
    tf.config.threading.set_inter_op_parallelism_threads(1)
    tf.config.threading.set_intra_op_parallelism_threads(1)

    import gpflow
    import tensorflow_probability as tfp
    from gpflow.keras import tf_keras

    report["versions"] = {
        name: metadata.version(name)
        for name in ("gpflow", "numpy", "scipy", "tensorflow", "tensorflow-probability", "tf-keras", "setuptools")
    }
    assert not tf.config.get_visible_devices("GPU")
    report["visible_gpus"] = []
    report["checks"]["imports"] = {"passed": True}
    gpflow.config.set_default_float(np.float64)
    tf.random.set_seed(17)
    x = np.linspace(-1, 1, 12, dtype=np.float64).reshape(-1, 1)
    y = np.sin(3 * x) + 0.1 * np.cos(5 * x)

    with tf.device("/CPU:0"):
        model = gpflow.models.GPR(
            (x, y), gpflow.kernels.SquaredExponential(variance=0.7, lengthscales=0.8),
            noise_variance=0.2,
        )
        before = float(model.training_loss())
        loss, _ = finite_gradients(model.training_loss, model.trainable_variables)
        assert "CPU:0" in loss.device
        result = gpflow.optimizers.Scipy().minimize(
            model.training_loss, model.trainable_variables, method="L-BFGS-B",
            options={"maxiter": 120},
        )
        after = float(model.training_loss())
        assert result.success, str(result.message)
        assert result.nit > 0 and math.isfinite(after) and after < before - 1e-3
        report["checks"]["gpr"] = {
            "passed": True, "loss_before": before, "loss_after": after,
            "optimizer_success": bool(result.success), "iterations": int(result.nit),
            "predictions": prediction(model, x),
        }

        data = (tf.constant(x), tf.constant(y))
        svgp = gpflow.models.SVGP(
            kernel=gpflow.kernels.SquaredExponential(variance=0.7, lengthscales=0.8),
            likelihood=gpflow.likelihoods.Gaussian(variance=0.2),
            inducing_variable=x[::3].copy(), num_data=len(x),
        )
        closure = svgp.training_loss_closure(data, compile=True)
        optimizer = tf_keras.optimizers.Adam(learning_rate=0.03)
        variables = svgp.trainable_variables
        before = float(closure())
        finite_gradients(closure, variables)

        @tf.function
        def step():
            with tf.GradientTape() as tape:
                loss = closure()
            gradients = tape.gradient(loss, variables)
            optimizer.apply_gradients(zip(gradients, variables))
            return loss

        for _ in range(20):
            assert math.isfinite(float(step()))
        after = float(closure())
        assert after < before - 1e-3
        finite_gradients(closure, variables)
        report["checks"]["svgp_adam"] = {
            "passed": True, "compiled_training": True, "steps": 20,
            "loss_before": before, "loss_after": after, "predictions": prediction(svgp, x),
        }

        nat_model = gpflow.models.SVGP(
            kernel=gpflow.kernels.SquaredExponential(variance=0.7, lengthscales=0.8),
            likelihood=gpflow.likelihoods.Gaussian(variance=0.2),
            inducing_variable=x[::3].copy(), num_data=len(x),
        )
        nat_closure = nat_model.training_loss_closure(data, compile=True)
        before = float(nat_closure())
        gpflow.optimizers.NaturalGradient(gamma=0.1).minimize(
            nat_closure, [(nat_model.q_mu, nat_model.q_sqrt)]
        )
        after = float(nat_closure())
        assert math.isfinite(after) and after < before - 1e-3
        report["checks"]["natural_gradient"] = {
            "passed": True, "steps": 1, "loss_before": before, "loss_after": after,
            "predictions": prediction(nat_model, x),
        }
    report["passed"] = True
except Exception as error:
    report["error"] = {"type": type(error).__name__, "message": str(error)}
    report["traceback"] = traceback.format_exc()
finally:
    report["finished_at"] = datetime.now(timezone.utc).isoformat()
    text = json.dumps(report, indent=2) + "\n"
    if len(sys.argv) > 1:
        Path(sys.argv[1]).write_text(text, encoding="utf-8")
    print(text, flush=True)

raise SystemExit(0 if report["passed"] else 1)
