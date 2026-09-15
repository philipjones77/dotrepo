import argparse
import json
import traceback
from pathlib import Path

import numpy as np

parser = argparse.ArgumentParser(
    description="Small Dynamax and BayesNF CPU numerical checks; installs nothing."
)
parser.add_argument("--output", type=Path)
args = parser.parse_args()
results = []


def record(name, fn):
    try:
        details = fn()
        result = {"name": name, "status": "passed", "details": details}
    except Exception as exc:  # noqa: BLE001 -- Preserve each oracle failure in the receipt.
        result = {
            "name": name,
            "status": "failed",
            "error": str(exc),
            "traceback": traceback.format_exc()[-4000:],
        }
    results.append(result)
    if args.output:
        args.output.write_text(json.dumps(results, indent=2) + "\n")
    print(json.dumps(result), flush=True)


def dynamax_check():
    import jax
    from dynamax.linear_gaussian_ssm import LinearGaussianSSM

    model = LinearGaussianSSM(state_dim=2, emission_dim=1)
    params, _props = model.initialize(jax.random.PRNGKey(0))
    _states, emissions = model.sample(params, jax.random.PRNGKey(1), num_timesteps=8)
    logp = float(model.marginal_log_prob(params, emissions))
    assert np.isfinite(logp)
    return {"log_probability": logp, "steps": 8}


def bayesnf_check():
    import jax
    import pandas as pd
    from bayesnf import BayesianNeuralFieldMAP

    table = pd.DataFrame(
        {
            "time": np.arange(8, dtype=float),
            "x": np.linspace(0, 1, 8),
            "y": np.sin(np.arange(8)),
        }
    )
    model = BayesianNeuralFieldMAP(
        feature_cols=["time", "x"], target_col="y", timetype="float", depth=1, width=4
    )
    model.fit(table, jax.random.PRNGKey(0), ensemble_size=1, num_epochs=2)
    predictions = model.predict(table)
    leaves = jax.tree_util.tree_leaves(predictions)
    assert leaves and all(np.isfinite(np.asarray(x)).all() for x in leaves)
    return {
        "training_epochs": 2,
        "prediction_shapes": [list(np.asarray(x).shape) for x in leaves],
    }


record("Dynamax state-space likelihood", dynamax_check)
record("BayesNF MAP fit and prediction", bayesnf_check)

raise SystemExit(0 if all(r["status"] == "passed" for r in results) else 1)
