#!/usr/bin/env python3
"""Compare installed smplx with SMPLJAX using a private view of local model assets."""

import argparse
import gc
import hashlib
import json
import os
import pickle
import time
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("model", choices=("smpl", "smplx"))
parser.add_argument(
    "--models-root",
    type=Path,
    default=Path(
        os.environ.get(
            "TOPOSMPLJAX_SMPL_ROOT",
            "~/.cache/toposmpljax/private_data/models/validated",
        )
    ).expanduser(),
)
parser.add_argument(
    "--state-dir",
    type=Path,
    default=Path("~/.local/state/dotrepo/smpl-oracle-checks").expanduser(),
)
args = parser.parse_args()
os.umask(0o077)

os.environ.update(
    {
        "CUDA_VISIBLE_DEVICES": "-1",
        "JAX_PLATFORMS": "cpu",
        "JAX_ENABLE_X64": "1",
        "XLA_PYTHON_CLIENT_PREALLOCATE": "false",
        "OPENBLAS_NUM_THREADS": "1",
        "OMP_NUM_THREADS": "1",
        "MKL_NUM_THREADS": "1",
        "PYTHONDONTWRITEBYTECODE": "1",
        "PYTHONNOUSERSITE": "1",
    }
)

import jax.numpy as jnp
import numpy as np
import smplx
import torch
from smpljax.body_models import SMPLJAXModel
from smpljax.reference_smplx import (
    infer_spec,
    ref_forward_kwargs,
    sample_inputs,
    to_model_data,
)

torch.set_num_threads(1)
family = args.model
assert family in ("smpl", "smplx")
scratch = args.state_dir.expanduser()
scratch.mkdir(mode=0o700, parents=True, exist_ok=True)
view = scratch / "private-smplx-compatibility-view"
view.mkdir(mode=0o700, parents=True, exist_ok=True)
source = args.models_root.expanduser() / family / (family.upper() + "_NEUTRAL.npz")
hash_obj = hashlib.sha256()
with source.open("rb") as stream:
    for chunk in iter(lambda: stream.read(1024 * 1024), b""):
        hash_obj.update(chunk)
with np.load(source, allow_pickle=False) as archive:
    payload = dict(archive)
changes = []
for new, old in {
    "f": "faces_tensor",
    "hands_componentsl": "left_hand_components",
    "hands_componentsr": "right_hand_components",
    "hands_meanl": "left_hand_mean",
    "hands_meanr": "right_hand_mean",
}.items():
    if old in payload:
        payload[new] = payload[old]
        changes.append(old + " -> " + new)
if payload["posedirs"].ndim == 2:
    vertices = payload["v_template"].shape[0]
    payload["posedirs"] = (
        payload["posedirs"].reshape(-1, vertices, 3).transpose(1, 2, 0)
    )
    changes.append("posedirs (P,V*3) -> (V,3,P), reshape/transpose only")
target = view / (family.upper() + "_NEUTRAL." + ("pkl" if family == "smpl" else "npz"))
if target.exists() or target.is_symlink():
    raise RuntimeError(
        "Private compatibility output already exists; preserve and inspect before reusing"
    )
with target.open("xb") as stream:
    if family == "smpl":
        pickle.dump(payload, stream, protocol=4)
    else:
        np.savez(stream, **payload)
target.chmod(0o600)
del payload
gc.collect()
start = time.monotonic()
kwargs = {"model_path": str(view), "gender": "neutral", "num_betas": 10}
if family == "smplx":
    kwargs.update(num_expression_coeffs=10, use_pca=False, flat_hand_mean=True)
ref = (smplx.SMPL if family == "smpl" else smplx.SMPLX)(**kwargs)
ref.eval()
spec = infer_spec(ref, model_type=family)
model = SMPLJAXModel(data=to_model_data(ref_model=ref, spec=spec))
sample = sample_inputs(spec=spec, batch_size=1, seed=7)
ref_args = ref_forward_kwargs(spec=spec, sample=sample)
for key in tuple(ref_args):
    if key.endswith("_pose") or key == "global_orient":
        ref_args[key] = ref_args[key].reshape(1, -1)
with torch.no_grad():
    reference = ref(**ref_args)
ours = model(**{name: jnp.asarray(values) for name, values in sample.items()})
metrics = {}
for name in ("vertices", "joints"):
    actual = np.asarray(getattr(ours, name))
    expected = getattr(reference, name).detach().cpu().numpy()
    np.testing.assert_allclose(actual, expected, atol=5e-5, rtol=5e-5)
    metrics[name] = {
        "shape": list(actual.shape),
        "max_absolute_error": float(np.max(np.abs(actual - expected))),
    }
receipt = {
    "status": "passed",
    "model": family,
    "gender": "neutral",
    "reference": "official installed smplx "
    + str(smplx.__version__ if hasattr(smplx, "__version__") else "package"),
    "source": str(source).replace(str(Path.home()), "~"),
    "source_sha256": hash_obj.hexdigest(),
    "compatibility_view": str(target).replace(str(Path.home()), "~"),
    "conversion": changes,
    "model_downloads": False,
    "original_assets_modified": False,
    "comparison": metrics,
    "seconds": round(time.monotonic() - start, 2),
    "scope": "One existing neutral model with nonzero shape/pose/translation, plus expression for SMPL-X; upstream forward vs SMPLJAXModel.",
}
(scratch / (family + "-runtime.json")).write_text(json.dumps(receipt, indent=2) + "\n")
print(json.dumps(receipt, indent=2))
