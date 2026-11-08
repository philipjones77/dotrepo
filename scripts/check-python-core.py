"""Run core numerical probes independently of declared package version bounds."""
import argparse
import json
import os
from pathlib import Path
import platform
import traceback
from importlib import metadata

os.environ.setdefault('XLA_PYTHON_CLIENT_PREALLOCATE', 'false')
os.environ.setdefault('OPENBLAS_NUM_THREADS', '1')
os.environ.setdefault('OMP_NUM_THREADS', '1')
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--require-gpu', action='store_true')
parser.add_argument('--output', type=Path)
args = parser.parse_args()
checks = []

def check(name, operation):
    try:
        checks.append(dict(name=name, passed=True, detail=operation()))
    except Exception as error:
        checks.append(dict(name=name, passed=False, error=str(error), traceback=traceback.format_exc()))

def scientific():
    import numpy as np
    from scipy.linalg import solve
    from scipy.integrate import quad
    a = np.array([[4., 1.], [1., 3.]])
    np.testing.assert_allclose(a @ solve(a, [1., 2.]), [1., 2.])
    assert abs(quad(lambda x: x*x, 0, 1)[0] - 1/3) < 1e-12
    return dict(numpy=np.__version__, scipy=metadata.version('scipy'))

def jax_core():
    import numpy as np
    import jax
    import jax.numpy as jnp
    jax.config.update('jax_enable_x64', True)
    devices = jax.devices()
    if args.require_gpu:
        assert any(d.platform == 'gpu' for d in devices), devices
    x = jnp.array([1., 2., 3.])
    np.testing.assert_allclose(jax.jit(jax.grad(lambda t: jnp.sum(t*t)))(x), [2, 4, 6])
    np.testing.assert_allclose(jax.hessian(lambda t: jnp.sum(t*t))(x), 2*np.eye(3))
    np.testing.assert_allclose(jnp.fft.ifft(jnp.fft.fft(x)).real, x, atol=1e-12)
    return dict(version=jax.__version__, devices=[str(d) for d in devices])

def ecosystem():
    import jax
    import jax.numpy as jnp
    import numpy as np
    import diffrax
    from flax import linen as nn
    layer = nn.Dense(2)
    params = layer.init(jax.random.key(0), jnp.ones((1, 3)))
    assert layer.apply(params, jnp.ones((1, 3))).shape == (1, 2)
    solution = diffrax.diffeqsolve(diffrax.ODETerm(lambda t, y, args: -y),
                                  diffrax.Tsit5(), t0=0, t1=1, dt0=.05, y0=jnp.array(1.))
    assert abs(float(solution.ys[-1])-np.exp(-1)) < 1e-5
    return 'Flax layer and Diffrax ODE passed'

check('numpy-scipy', scientific)
check('jax', jax_core)
check('ecosystem', ecosystem)
report = dict(python=platform.python_version(), passed=all(c['passed'] for c in checks), checks=checks,
              scope='Core runtime probes; dependency metadata and checkpointing require separate checks.')
serialized = json.dumps(report, indent=2) + '\n'
if args.output:
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(serialized, encoding='utf-8')
print(serialized, end='')
raise SystemExit(0 if report['passed'] else 1)
