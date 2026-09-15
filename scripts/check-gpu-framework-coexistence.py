"""Check py313's supported PyTorch/JAX GPU + GPflow CPU import order.

Run in a fresh process; TensorFlow-first initialization can poison CUDA setup.
This is a small numerical smoke check, not full framework interoperability.
"""
import argparse
import json
import os
from pathlib import Path
import platform

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output', type=Path)
args = parser.parse_args()
os.environ['XLA_PYTHON_CLIENT_PREALLOCATE'] = 'false'
for name in ('OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS',
             'TF_NUM_INTRAOP_THREADS', 'TF_NUM_INTEROP_THREADS'):
    os.environ[name] = '1'

# Import and initialize PyTorch before importing TensorFlow or GPflow.
import torch
torch.cuda.init()
import numpy as np
import jax
import jax.numpy as jnp

assert jax.default_backend() == 'gpu'

def check_jax():
    x = jnp.arange(6., dtype=jnp.float32)
    np.testing.assert_allclose(jax.jit(jax.grad(lambda v: jnp.sum(v*v)))(x),
                               2*np.arange(6))

def check_torch():
    a = torch.tensor([[2., 1.], [1., 2.]], device='cuda', requires_grad=True)
    np.testing.assert_allclose((a @ a).detach().cpu().numpy(), [[5., 4.], [4., 5.]])
    (a*a).sum().backward()
    np.testing.assert_allclose(a.grad.cpu().numpy(), [[4., 2.], [2., 4.]])
    x = torch.arange(25., device='cuda').reshape(1, 1, 5, 5)
    w = torch.ones((1, 1, 3, 3), device='cuda')
    gpu = torch.nn.functional.conv2d(x, w)
    cpu = torch.nn.functional.conv2d(x.cpu(), w.cpu())
    np.testing.assert_allclose(gpu.cpu().numpy(), cpu.numpy())
    torch.cuda.synchronize()

check_torch()
check_jax()
import tensorflow as tf
tf.config.set_visible_devices([], 'GPU')
import gpflow

model = gpflow.models.GPR(
    (np.array([[0.], [1.], [2.]]), np.array([[0.], [1.], [0.]])),
    gpflow.kernels.SquaredExponential())
loss = float(model.training_loss().numpy())
assert np.isfinite(loss)
check_jax()
check_torch()
result = {
    'hostname': platform.node(), 'status': 'passed',
    'python': platform.python_version(), 'torch': torch.__version__,
    'jax': jax.__version__, 'tensorflow': tf.__version__, 'gpflow': gpflow.__version__,
    'device': torch.cuda.get_device_name(0),
    'import_order': ['torch (CUDA initialized)', 'jax', 'tensorflow (CPU)', 'gpflow'],
    'checks': ['PyTorch GPU matmul, gradient and convolution before/after GPflow',
               'JAX GPU JIT gradient before/after GPflow', 'GPflow CPU finite GPR loss'],
    'gpflow_loss': loss,
    'scope': 'Small numerical checks; TensorFlow GPU and arbitrary import orders are not validated.',
}
payload = json.dumps(result, indent=2) + '\n'
if args.output:
    args.output.write_text(payload)
print(payload)
