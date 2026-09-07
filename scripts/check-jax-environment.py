"""Exercise a scientific Python environment; require GPU with --require-gpu."""
import argparse
import importlib
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

os.environ.setdefault("XLA_PYTHON_CLIENT_PREALLOCATE", "false")
parser = argparse.ArgumentParser()
parser.add_argument("--require-gpu", action="store_true")
args = parser.parse_args()
subprocess.run([sys.executable, "-m", "pip", "check"], check=True)
import jax
import jax.numpy as jnp
import numpy as np

jax.config.update("jax_enable_x64", True)
devices = jax.devices()
if args.require_gpu:
    assert any(d.platform == "gpu" for d in devices), devices
x = jnp.array([1., 2., 3.], dtype=jnp.float64)
np.testing.assert_allclose(jax.jit(lambda a: a @ a)(x).block_until_ready(), 14.)
np.testing.assert_allclose(jax.jit(jax.grad(lambda a: a @ a))(x), [2., 4., 6.])
np.testing.assert_allclose(jax.hessian(lambda a: a @ a)(x), 2 * np.eye(3))
np.testing.assert_allclose(jax.vmap(lambda a: a @ a)(jnp.stack([x, 2*x])), [14., 56.])
a = jnp.array([[4., 1.], [1., 3.]])
b = jnp.array([1., 2.])
np.testing.assert_allclose(jax.jit(jnp.linalg.solve)(a, b), np.linalg.solve(a, b))
np.testing.assert_allclose(jnp.fft.ifft(jnp.fft.fft(x)).real, x, atol=1e-12)
from jax.experimental.sparse import BCOO
np.testing.assert_allclose(BCOO.fromdense(a) @ b, a @ b)
modules = ['scipy', 'pandas', 'matplotlib', 'h5py', 'flint', 'optax',
           'flax', 'numpyro', 'blackjax', 'diffrax', 'equinox',
           'ipykernel', 'jupyterlab', 'arbplusjax', 'integralfunctionsjax', 'common']
for name in modules:
    importlib.import_module(name)
import optax
optimizer = optax.sgd(0.1)
updates, _ = optimizer.update(jax.grad(lambda a: a @ a)(x), optimizer.init(x))
np.testing.assert_allclose(optax.apply_updates(x, updates), 0.8 * x)
from flax import linen as nn
layer = nn.Dense(2)
params = layer.init(jax.random.key(0), jnp.ones((1, 3)))
assert layer.apply(params, jnp.ones((1, 3))).shape == (1, 2)
import diffrax
solution = diffrax.diffeqsolve(diffrax.ODETerm(lambda t, y, args: y),
    diffrax.Tsit5(), t0=0., t1=1., dt0=0.05, y0=jnp.array(1.))
np.testing.assert_allclose(solution.ys[-1], np.e, rtol=1e-6)
import torch
if args.require_gpu:
    assert torch.cuda.is_available()
    t = torch.tensor([1., 2., 3.], device='cuda', requires_grad=True)
    loss = t @ t
    loss.backward()
    assert loss.item() == 14.
    np.testing.assert_allclose(t.grad.cpu().numpy(), [2., 4., 6.])
from flint import arb
assert arb(2).sqrt() ** 2 == arb(2) or (arb(2).sqrt() ** 2).contains(2)
import h5py
import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot as plt
with tempfile.TemporaryDirectory() as temp:
    with h5py.File(Path(temp)/'data.h5', 'w') as f:
        f['x'] = np.asarray(x)
    with h5py.File(Path(temp)/'data.h5', 'r') as f:
        np.testing.assert_array_equal(f['x'][:], x)
    plt.plot(np.asarray(x)); plt.savefig(Path(temp)/'plot.png'); plt.close()
    assert (Path(temp)/'plot.png').stat().st_size > 0
print(json.dumps({'python': sys.version.split()[0], 'executable': sys.executable,
                  'jax': jax.__version__, 'devices': [str(d) for d in devices],
                  'checks': 'pip, GPU/JIT, gradients/Hessian, vmap, solve, FFT, sparse, imports, Optax, Flax, Diffrax, PyTorch GPU, Arb, HDF5, plot'}, indent=2))
