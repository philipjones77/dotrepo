"""Check equivalent matrix/operator calculations; this is not a speed benchmark."""
import json
import os
from importlib.metadata import version

os.environ.setdefault('XLA_PYTHON_CLIENT_PREALLOCATE', 'false')
os.environ.setdefault('OMP_NUM_THREADS', '2')

import numpy as np
import scipy.linalg as la
import scipy.sparse as sp
import scipy.sparse.linalg as sla
import pylops
import pyamg
import sparse
import tensorly as tl
import sympy
import mpmath as mp
from flint import fmpq_mat, arb_mat, ctx

checks = []
rng = np.random.default_rng(77)
m = rng.normal(size=(32, 32))
a = m.T @ m + 4 * np.eye(32)
b = rng.normal(size=32)
x = la.solve(a, b, assume_a='pos')
assert la.norm(a @ x - b) / la.norm(b) < 1e-12
checks.append('dense SPD solve')
for fmt in ('csr', 'csc', 'coo', 'bsr', 'dia'):
    matrix = getattr(sp, fmt + '_array')(a)
    assert np.allclose(matrix @ x, b)
checks.append('CSR CSC COO BSR DIA products')
assert np.allclose(sla.spsolve(sp.csc_array(a), b), x)
checks.append('sparse direct solve')
operator = sla.LinearOperator(a.shape, matvec=lambda v: a @ v,
                              rmatvec=lambda v: a.T @ v, dtype=a.dtype)
solution, info = sla.cg(operator, b, rtol=1e-11)
assert info == 0 and np.allclose(solution, x)
checks.append('matrix-free conjugate gradient')
p = pylops.MatrixMult(a)
u, v = rng.normal(size=(2, 32))
assert np.allclose(p @ v, a @ v)
assert np.allclose(np.vdot(u, p @ v), np.vdot(p.H @ u, v))
assert np.allclose((p.H * p) @ v, a.T @ a @ v)
checks.append('PyLops product adjoint composition')
t = la.toeplitz(np.arange(1., 9.))
assert np.allclose(la.matmul_toeplitz((t[:, 0], t[0]), v[:8]), t @ v[:8])
assert np.allclose(np.kron(a[:2, :2], a[:3, :3]), tl.tenalg.kronecker([a[:2, :2], a[:3, :3]]))
checks.append('Toeplitz and Kronecker structure')
lap = pyamg.gallery.poisson((12, 12), format='csr')
rhs = np.ones(lap.shape[0])
sol = pyamg.smoothed_aggregation_solver(lap).solve(rhs, tol=1e-10)
assert la.norm(lap @ sol - rhs) / la.norm(rhs) < 1e-8
checks.append('multigrid Poisson solve')
tensor = rng.normal(size=(3, 4, 2))
assert np.allclose(sparse.COO.from_numpy(tensor).todense(), tensor)
assert np.allclose(tl.fold(tl.unfold(tensor, 1), 1, tensor.shape), tensor)
checks.append('sparse tensor and unfold/fold')
q = fmpq_mat([[2, 1], [1, 3]])
assert q * q.inv() == fmpq_mat([[1, 0], [0, 1]])
ctx.prec = 128
ball = arb_mat([[2, 1], [1, 3]])
identity = ball * ball.inv()
assert all(identity[i, j].contains(int(i == j)) for i in range(2) for j in range(2))
checks.append('FLINT exact rational and Arb interval inverse')
symbolic = sympy.Matrix([[2, 1], [1, 3]])
assert symbolic * symbolic.inv() == sympy.eye(2)
mp.mp.dps = 60
high = mp.matrix([[2, 1], [1, 3]])
assert mp.norm(high * mp.inverse(high) - mp.eye(2)) < mp.mpf('1e-55')
checks.append('symbolic and high precision inverse')
import jax
jax.config.update('jax_enable_x64', True)
import jax.numpy as jnp
gpu = jax.devices('gpu')
assert gpu, 'A working JAX GPU is required on this machine'
with jax.default_device(gpu[0]):
    ja, jb = jnp.asarray(a), jnp.asarray(b)
    jx = jax.jit(jnp.linalg.solve)(ja, jb)
    assert np.allclose(np.asarray(jx), x, rtol=1e-10, atol=1e-12)
    gradient = jax.grad(lambda z: jnp.vdot(z, ja @ z).real)(jb)
    assert np.allclose(np.asarray(gradient), 2 * a @ b)
checks.append('JAX GPU float64 solve and operator gradient')
import lineax as lx
with jax.default_device(gpu[0]):
    result = lx.linear_solve(lx.MatrixLinearOperator(ja, tags=lx.positive_semidefinite_tag),
                            jb, solver=lx.Cholesky())
    assert np.allclose(np.asarray(result.value), x, rtol=1e-10, atol=1e-12)
checks.append('Lineax GPU Cholesky operator solve')
from sksparse.cholmod import cholesky
factor, permutation = cholesky(sp.csc_matrix(a), lower=True)
assert np.allclose((factor @ factor.T).toarray(), a[permutation][:, permutation])
checks.append('SuiteSparse CHOLMOD sparse Cholesky')
print(json.dumps({'passed': checks, 'count': len(checks), 'gpu': str(gpu[0]),
                  'versions': {p: version(p) for p in ('numpy', 'scipy', 'pylops', 'pyamg',
                      'sparse', 'tensorly', 'python-flint', 'sympy', 'mpmath', 'jax')}}, indent=2))
