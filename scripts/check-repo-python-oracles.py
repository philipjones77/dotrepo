"""Small CPU checks for additional IFJ/RF77 Python reference packages.

Run with the selected interpreter and one package name. Set
OPENBLAS_NUM_THREADS=1, OMP_NUM_THREADS=1 and CUDA_VISIBLE_DEVICES=-1.
"""

import json
import math
import sys
from importlib.metadata import version

import numpy as np


def probe(name):
    if name == "fftlog-lss":
        from fftlog.fftlog import FFTLog

        transform = FFTLog(
            Nmax=2048,
            xmin=1e-5,
            xmax=1e3,
            bias=-0.5,
            window=0.5,
            hankl=True,
            ells=[0],
        )
        x = transform.x
        k, values = transform.sbt(
            x, np.exp(-0.5 * x**2), f2c=False, return_y=True, mode="exact"
        )
        k, values = np.asarray(k), np.asarray(values[0])
        selected = (k > 0.5) & (k < 3)
        truth = (2 * np.pi) ** 1.5 * np.exp(-0.5 * k[selected] ** 2)
        error = float(np.max(np.abs(values[selected] / truth - 1)))
        assert error < 5e-3, error
        return {"operation": "Gaussian spherical transform", "relative_error": error}
    if name == "hankl":
        from hankl import P2xi

        k = np.geomspace(1e-5, 1e3, 2048)
        r, values = P2xi(k, np.exp(-(k**2)), l=0)
        selected = (r > 0.5) & (r < 3)
        truth = np.exp(-(r[selected] ** 2) / 4) / (8 * np.pi**1.5)
        error = float(np.max(np.abs(values[selected] / truth - 1)))
        assert error < 5e-3, error
        return {
            "operation": "Gaussian power spectrum transform",
            "relative_error": error,
        }
    if name == "finufft":
        from finufft import nufft1d3

        x = np.linspace(-1, 1, 9)
        coefficients = np.exp(1j * x)
        frequencies = np.linspace(-2, 2, 7)
        actual = nufft1d3(x, coefficients, frequencies, eps=1e-12, nthreads=1)
        expected = np.exp(1j * frequencies[:, None] * x) @ coefficients
        error = float(np.max(np.abs(actual - expected)))
        assert error < 1e-9, error
        return {
            "operation": "Nonuniform transform against direct sum",
            "absolute_error": error,
        }
    if name == "pynufft":
        from pynufft import NUFFT

        transform = NUFFT()
        transform.plan(np.array([[0.0], [0.5], [1.0]]), (16,), (32,), (6,))
        actual = transform.forward(np.ones(16, dtype=np.complex128))
        assert np.isfinite(actual).all()
        error = float(abs(actual[0] - 16))
        assert error < 1e-2, error
        return {
            "operation": "Constant-signal zero-frequency transform",
            "absolute_error": error,
        }
    if name == "torchquad":
        from torchquad import Simpson

        value = float(
            Simpson().integrate(
                lambda x: x[:, 0] ** 2,
                dim=1,
                N=101,
                integration_domain=[[0, 1]],
                backend="numpy",
            )
        )
        assert abs(value - 1 / 3) < 1e-6, value
        return {"operation": "Simpson integral of x squared", "value": value}
    if name == "cubature":
        from cubature import cubature

        value, _ = cubature(
            lambda x: float(x[0] ** 2 + x[1] ** 2),
            2,
            1,
            np.zeros(2),
            np.ones(2),
            abserr=1e-9,
            relerr=1e-9,
        )
        assert abs(float(value[0]) - 2 / 3) < 1e-8
        return {
            "operation": "Two-dimensional polynomial integral",
            "value": float(value[0]),
        }
    if name == "scoringrules":
        from scoringrules import crps_normal

        actual = float(crps_normal(0.0, 0.0, 1.0))
        expected = (math.sqrt(2) - 1) / math.sqrt(math.pi)
        assert abs(actual - expected) < 1e-10
        return {"operation": "Gaussian CRPS against analytic value", "value": actual}
    if name == "pygam":
        from pygam import LinearGAM, s

        x = np.linspace(0, 1, 30)[:, None]
        model = LinearGAM(s(0, n_splines=5)).fit(x, np.sin(x[:, 0]))
        predictions = model.predict(x)
        error = float(np.max(np.abs(predictions - np.sin(x[:, 0]))))
        assert error < 0.1, error
        return {
            "operation": "Spline regression fit and prediction",
            "maximum_error": error,
        }
    raise ValueError(f"Unknown probe: {name}")


if __name__ == "__main__":
    package = sys.argv[1]
    details = probe(package)
    print(
        json.dumps(
            {
                "package": package,
                "version": version(package),
                "passed": True,
                "details": details,
            }
        )
    )
