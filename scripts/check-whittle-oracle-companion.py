import argparse
import json
from importlib.metadata import version
from pathlib import Path

import numpy as np
from debiased_spatial_whittle.grids.base import RectangularGrid
from debiased_spatial_whittle.inference.likelihood import DebiasedWhittle
from debiased_spatial_whittle.inference.periodogram import (
    ExpectedPeriodogram,
    Periodogram,
)
from debiased_spatial_whittle.models.univariate import Matern32Model

parser = argparse.ArgumentParser(
    description="Small Debiased Spatial Whittle CPU reference check; installs nothing."
)
parser.add_argument("--output", type=Path)
args = parser.parse_args()

grid = RectangularGrid(shape=(4, 4), delta=(1.0, 1.0))
model = Matern32Model()
model.rho = 1.0
model.sigma = 1.0
pg = Periodogram()
ep = ExpectedPeriodogram(grid, pg)
dw = DebiasedWhittle(pg, ep)
y = np.random.default_rng(1).normal(size=(4, 4))
nll = float(dw(y, model))
expected = np.asarray(ep(model))
assert np.isfinite(nll)
assert expected.shape == (4, 4)
assert np.isfinite(expected).all() and (expected > 0).all()
receipt = {
    "status": "passed",
    "package": "debiased-spatial-whittle",
    "version": version("debiased-spatial-whittle"),
    "numpy": np.__version__,
    "python": "Selected interpreter",
    "grid": [4, 4],
    "negative_log_likelihood": nll,
    "expected_periodogram_min": float(expected.min()),
    "integration": "Standalone companion reference. RF77 W01 currently imports in-process and has no companion interpreter setting.",
}
if args.output:
    args.output.write_text(json.dumps(receipt, indent=2) + "\n")
print(json.dumps(receipt, indent=2))
