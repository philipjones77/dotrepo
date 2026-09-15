"""Run one tiny CPU smoke probe: python check-m-tier-python.py PACKAGE.

Select the interpreter externally. Set CUDA_VISIBLE_DEVICES=-1, JAX_PLATFORMS=cpu,
OPENBLAS_NUM_THREADS=1, OMP_NUM_THREADS=1, MKL_NUM_THREADS=1,
TF_NUM_INTRAOP_THREADS=1 and TF_NUM_INTEROP_THREADS=1 before invoking.
"""

import json
import math
import sys
import traceback
from datetime import datetime, timezone
from importlib import metadata

import numpy as np

x = np.linspace(0.05, 0.95, 12).reshape(-1, 1)
y = np.sin(6 * x).ravel()
coords = np.column_stack((x.ravel(), np.cos(3 * x.ravel())))


def finite(value):
    array = np.asarray(value)
    assert array.size and np.isfinite(array).all()
    return array


def predictions(mean, variance):
    mean, variance = finite(mean), finite(variance)
    assert mean.size == variance.size
    assert variance.min() >= -1e-8
    return {"prediction_count": int(mean.size), "minimum_variance": float(variance.min())}


def jax_cpu():
    import jax
    import jax.numpy as jnp

    jax.config.update("jax_enable_x64", True)
    assert all(d.platform == "cpu" for d in jax.devices())
    return jax, jnp


def torch_cpu():
    import torch

    torch.set_num_threads(1)
    torch.set_default_dtype(torch.float64)
    return torch


def probe(name):
    if name == "scikit-learn":
        from sklearn.gaussian_process import GaussianProcessRegressor
        from sklearn.gaussian_process.kernels import RBF

        model = GaussianProcessRegressor(kernel=RBF(0.3), alpha=0.01, optimizer=None).fit(x, y)
        mean, std = model.predict(x, return_std=True)
        return {"operation": "12-point Gaussian-process regression fit and prediction", **predictions(mean, std**2)}
    if name == "linear_operator":
        torch = torch_cpu()
        from linear_operator.operators import DenseLinearOperator

        A = torch.tensor([[4., 1.], [1., 3.]])
        result = DenseLinearOperator(A).solve(torch.tensor([1., 2.]))
        assert torch.allclose(result, torch.tensor([1., 7.]) / 11)
        return {"operation": "2-by-2 positive-definite linear operator solve", "solution": result.tolist()}
    if name == "gpytorch":
        torch = torch_cpu()
        import gpytorch as gp

        tx, ty = torch.tensor(x), torch.tensor(y)
        likelihood = gp.likelihoods.GaussianLikelihood()

        class Model(gp.models.ExactGP):
            def __init__(self):
                super().__init__(tx, ty, likelihood)
                self.mean_module = gp.means.ZeroMean()
                self.covar_module = gp.kernels.ScaleKernel(gp.kernels.RBFKernel())

            def forward(self, inputs):
                return gp.distributions.MultivariateNormal(self.mean_module(inputs), self.covar_module(inputs))

        model = Model()
        loss = -gp.mlls.ExactMarginalLogLikelihood(likelihood, model)(model(tx), ty)
        loss.backward()
        gradients = [v.grad for v in model.parameters() if v.grad is not None]
        assert gradients and all(torch.isfinite(gradient).all() for gradient in gradients)
        assert math.isfinite(float(loss.detach()))
        model.eval()
        likelihood.eval()
        with torch.no_grad():
            p = likelihood(model(tx))
            result = predictions(p.mean.numpy(), p.variance.numpy())
        return {"operation": "Exact GP marginal likelihood, gradients, and posterior prediction", "loss": float(loss.detach()), **result}
    if name == "gpboost":
        import gpboost as gp

        model = gp.GPModel(gp_coords=x, cov_function="exponential", num_parallel_threads=1)
        model.fit(y=y, params={"maxit": 30, "trace": False})
        result = model.predict(gp_coords_pred=x, predict_var=True)
        return {"operation": "12-point native GP covariance fit and posterior prediction", **predictions(result["mu"], result["var"])}
    if name == "pymc":
        import pymc as pm

        with pm.Model() as model:
            gp = pm.gp.Marginal(cov_func=pm.gp.cov.ExpQuad(1, ls=0.3))
            gp.marginal_likelihood("observations", X=x, y=y, sigma=0.1)
        value = float(model.compile_logp()({}))
        assert math.isfinite(value)
        return {"operation": "Compile and evaluate 12-point GP marginal log likelihood", "log_probability": value}
    if name == "numpyro":
        jax, jnp = jax_cpu()
        import numpyro
        import numpyro.distributions as dist
        from numpyro.infer.util import log_density

        def model():
            amplitude = numpyro.sample("amplitude", dist.LogNormal(0, 1))
            kernel = amplitude * jnp.exp(-0.5 * ((x - x.T) / 0.3)**2) + 0.01 * jnp.eye(len(x))
            numpyro.sample("observations", dist.MultivariateNormal(jnp.zeros(len(x)), covariance_matrix=kernel), obs=jnp.asarray(y))

        loss = lambda amplitude: log_density(model, (), {}, {"amplitude": amplitude})[0]
        value, gradient = jax.value_and_grad(loss)(jnp.array(1.0))
        finite([value, gradient])
        return {"operation": "12-point GP model joint log density and amplitude gradient", "log_probability": float(value), "gradient": float(gradient)}
    if name == "blackjax":
        jax, jnp = jax_cpu()
        import blackjax

        logdensity = lambda position: -0.5 * jnp.sum(position**2)
        kernel = blackjax.hmc(logdensity, step_size=0.1, inverse_mass_matrix=jnp.ones(2), num_integration_steps=3)
        state = kernel.init(jnp.array([0.2, -0.1]))
        for key in jax.random.split(jax.random.key(17), 3):
            state, info = kernel.step(key, state)
            finite(state.position)
            assert not bool(info.is_divergent)
        return {"operation": "Three CPU HMC transitions for a two-dimensional Gaussian", "final_position": np.asarray(state.position).tolist(), "convergence_assessed": False}
    if name == "pyro-ppl":
        torch = torch_cpu()
        import pyro
        import pyro.contrib.gp as gp

        pyro.clear_param_store()
        tx, ty = torch.tensor(x), torch.tensor(y)
        model = gp.models.GPRegression(tx, ty, gp.kernels.RBF(input_dim=1), noise=torch.tensor(0.1))
        mean, variance = model(tx, full_cov=False, noiseless=True)
        return {"operation": "12-point Pyro GP regression posterior", **predictions(mean.detach().numpy(), variance.detach().numpy())}
    if name == "gpflow":
        import tensorflow as tf
        tf.config.set_visible_devices([], "GPU")
        import gpflow

        model = gpflow.models.GPR((x, y[:, None]), gpflow.kernels.SquaredExponential(), noise_variance=0.1)
        with tf.GradientTape() as tape:
            loss = model.training_loss()
        grads = tape.gradient(loss, model.trainable_variables)
        assert all(g is not None and np.isfinite(g.numpy()).all() for g in grads)
        assert math.isfinite(float(loss))
        mean, variance = model.predict_f(x)
        return {"operation": "12-point GP marginal likelihood, gradients, and posterior prediction", "loss": float(loss), **predictions(mean.numpy(), variance.numpy())}
    if name == "gpjax":
        jax, jnp = jax_cpu()
        import gpjax as gp

        data = gp.Dataset(X=jnp.asarray(x), y=jnp.asarray(y[:, None]))
        prior = gp.gps.Prior(mean_function=gp.mean_functions.Zero(), kernel=gp.kernels.RBF())
        posterior = prior * gp.likelihoods.Gaussian(num_datapoints=len(x))
        loss = float(gp.objectives.conjugate_mll(posterior, data))
        assert math.isfinite(loss)
        distribution = posterior.predict(jnp.asarray(x), train_data=data)
        mean = distribution.mean() if callable(distribution.mean) else distribution.mean
        variance = distribution.variance() if callable(distribution.variance) else distribution.variance
        return {"operation": "12-point GPJax marginal likelihood and conditioned posterior", "log_probability": loss, **predictions(mean, variance)}
    if name == "stheno":
        from stheno import GP, EQ

        prior = GP(EQ())
        posterior = prior | (prior(x, 0.01), y[:, None])
        mean, lower, upper = posterior(x).marginal_credible_bounds()
        finite(mean)
        assert np.all(finite(lower) <= finite(upper))
        return {"operation": "12-point Stheno conditioning and credible bounds", "prediction_count": int(np.asarray(mean).size)}
    if name == "tinygp":
        jax, jnp = jax_cpu()
        from tinygp import GaussianProcess, kernels

        model = GaussianProcess(kernels.ExpSquared(scale=0.3), jnp.asarray(x.ravel()), diag=0.01)
        result = model.condition(jnp.asarray(y))
        value = float(model.log_probability(jnp.asarray(y)))
        assert math.isfinite(value)
        return {"operation": "12-point tinygp conditioning and log probability", "log_probability": value, **predictions(result.gp.loc, result.gp.variance)}
    if name in ("GPy", "emukit"):
        import GPy

        model = GPy.models.GPRegression(x, y[:, None], GPy.kern.RBF(1), noise_var=0.1)
        if name == "emukit":
            from emukit.model_wrappers import GPyModelWrapper
            model = GPyModelWrapper(model)
        mean, variance = model.predict(x)
        return {"operation": "12-point GPy GP regression posterior" + (" through Emukit wrapper" if name == "emukit" else ""), **predictions(mean, variance)}
    if name == "celerite2":
        from celerite2 import GaussianProcess, terms

        model = GaussianProcess(terms.RealTerm(a=1.0, c=1.0))
        model.compute(x.ravel(), diag=np.full(len(x), 0.01))
        mean, variance = model.predict(y, x.ravel(), return_var=True)
        value = float(model.log_likelihood(y))
        assert math.isfinite(value)
        return {"operation": "12-point semiseparable GP likelihood and posterior", "log_probability": value, **predictions(mean, variance)}
    if name == "george":
        import george

        model = george.GP(george.kernels.ExpSquaredKernel(0.3))
        model.compute(x.ravel(), 0.1)
        mean, variance = model.predict(y, x.ravel(), return_var=True)
        value = float(model.log_likelihood(y))
        assert math.isfinite(value)
        return {"operation": "12-point george GP likelihood and posterior", "log_probability": value, **predictions(mean, variance)}
    if name == "PyKrige":
        from pykrige.ok import OrdinaryKriging

        model = OrdinaryKriging(coords[:, 0], coords[:, 1], y, variogram_model="linear", variogram_parameters={"slope": 1.0, "nugget": 0.1}, verbose=False)
        mean, variance = model.execute("points", coords[:3, 0], coords[:3, 1])
        return {"operation": "Two-dimensional ordinary kriging at three locations", **predictions(mean, variance)}
    if name == "scikit-gstat":
        from skgstat import Variogram

        model = Variogram(coords, y, model="exponential", n_lags=4, normalize=False)
        parameters = finite(model.parameters)
        finite(model.transform(np.array([0.1, 0.5])))
        return {"operation": "Fit and evaluate empirical exponential variogram", "parameters": parameters.tolist()}
    if name == "gstools":
        import gstools as gs

        model = gs.Gaussian(dim=2, var=1, len_scale=0.3)
        krig = gs.krige.Simple(model, cond_pos=coords.T, cond_val=y)
        mean, variance = krig(coords[:3].T)
        return {"operation": "Two-dimensional simple kriging at three locations", **predictions(mean, variance)}
    if name == "verde":
        import verde

        model = verde.Spline(damping=1e-3).fit((coords[:, 0], coords[:, 1]), y)
        result = finite(model.predict((coords[:3, 0], coords[:3, 1])))
        return {"operation": "Damped two-dimensional spline fit and prediction", "prediction_count": int(result.size)}
    if name == "botorch":
        torch = torch_cpu()
        from botorch.models import SingleTaskGP

        model = SingleTaskGP(torch.tensor(x), torch.tensor(y[:, None]))
        posterior = model.posterior(torch.tensor(x))
        return {"operation": "12-point BoTorch SingleTaskGP conditioned posterior", **predictions(posterior.mean.detach().numpy(), posterior.variance.detach().numpy())}
    if name == "smt":
        from smt.surrogate_models import KRG

        model = KRG(theta0=[0.3], print_global=False, n_start=1)
        model.set_training_values(x, y[:, None])
        model.train()
        return {"operation": "12-point SMT kriging surrogate training and prediction", **predictions(model.predict_values(x), model.predict_variances(x))}
    raise ValueError(name)


if len(sys.argv) != 2 or sys.argv[1] in ("-h", "--help"):
    print(__doc__)
    raise SystemExit(0 if len(sys.argv) == 2 else 2)
name = sys.argv[1]
result = {"package": name, "started_at": datetime.now(timezone.utc).isoformat(), "passed": False}
try:
    result["version"] = metadata.version(name)
    result["details"] = probe(name)
    result["passed"] = True
except Exception as error:
    result["error"] = {"type": type(error).__name__, "message": str(error)}
    result["traceback"] = traceback.format_exc()
result["finished_at"] = datetime.now(timezone.utc).isoformat()
print("MTIER_RESULT=" + json.dumps(result), flush=True)
raise SystemExit(0 if result["passed"] else 1)
