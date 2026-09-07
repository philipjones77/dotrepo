r"""Validate a recorded Linux CPython venv using that venv's Python executable.

Example (the script may live in /mnt/c/dev/dotrepo on the Windows host)::

    ~/.virtualenvs/jax313/bin/python check-recorded-environment.py \
        --inventory jax313-packages.json --python-version 3.13.15 \
        --output jax313-validation.json --include-gpflow

Inventories are pip-list JSON arrays with name, version, and optional
editable_project_location. --path-map accepts a JSON object mapping absolute
source directory prefixes to absolute target prefixes; the longest match wins.
No project commit or source-content equivalence is inferred from editable paths.
Matching source-tree .egg-info exposed by one PEP 610 editable installation is
reported as auxiliary metadata; unrelated or conflicting duplicates still fail.
The top-level check re-executes in Python isolated mode before loading metadata,
so PYTHONPATH or user-site packages cannot satisfy a missing venv distribution.

JAX probes require a GPU unless --jax-platform cpu is explicitly selected.
Each workload runs sequentially in a fresh, timed child process. GPflow is opt-in
and CPU-only, in a separate process from JAX; no environments are changed.
Runtime libraries may create their usual compilation caches and temporary files.
When stable TensorFlow Probability and tfp-nightly coexist, the imported payload
must match the recorded nightly version; separate dist-info records are not proof.

--allow-pip-conflict accepts one exact, reviewed pip-check diagnostic per use.
It does not make dependencies clean: passed remains false, accepted may be true,
and status reports accepted_with_reviewed_dependency_conflicts. Exit 0 means
accepted under that explicit policy; exit 1 means failed; exit 2 is invalid input.
Small deterministic workloads test execution, not sampler convergence, complete
project functionality, every installed package, or production GPU capacity.
"""

import os
import sys

# Keep metadata enumeration and worker imports in the same isolated context.
# Do this before importing the rest of the validator, including metadata APIs.
if __name__ == "__main__" and not sys.flags.isolated:
    os.execv(sys.executable, [sys.executable, "-I", os.path.abspath(__file__), *sys.argv[1:]])

import argparse
from collections import defaultdict
from datetime import datetime, timezone
import hashlib
import importlib.metadata
import json
import math
from pathlib import Path
import platform
import re
import sqlite3
import ssl
import subprocess
import tempfile
import time
import traceback
from urllib.parse import unquote, urlsplit


PROBE_MARKER = "DOTREPO_PROBE_JSON="
JAX_PROBES = {"jax", "optax", "blackjax", "numpyro"}
PROBE_PACKAGES = {
    "jax": "jax", "optax": "optax", "blackjax": "blackjax",
    "numpyro": "numpyro", "torch": "torch", "hdf5": "h5py",
    "numba": "numba", "pytensor": "pytensor", "pymc": "pymc",
    "gpflow": "gpflow", "tfp": "tensorflow-probability",
}


def canonical(name):
    return re.sub(r"[-_.]+", "-", name).lower()


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def read_inventory(path):
    raw = path.read_bytes()
    rows = json.loads(raw.decode("utf-8-sig"))
    if not isinstance(rows, list) or not rows:
        raise ValueError("Inventory must be a nonempty pip-list JSON array")
    packages = {}
    for row in rows:
        if (not isinstance(row, dict) or not isinstance(row.get("name"), str)
                or not isinstance(row.get("version"), str)
                or not row["name"].strip() or not row["version"].strip()):
            raise ValueError("Every package needs a nonempty name and version")
        name = canonical(row["name"])
        if name in packages:
            raise ValueError(f"Duplicate normalized inventory package: {name}")
        editable = row.get("editable_project_location")
        if editable is not None and (
                not isinstance(editable, str) or not Path(editable).is_absolute()):
            raise ValueError(f"Editable path for {name} must be absolute")
        packages[name] = row
    return packages, hashlib.sha256(raw).hexdigest()


def read_path_map(path):
    if path is None:
        return {}
    mapping = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(mapping, dict):
        raise ValueError("Path map must be an object of source: target directories")
    for source, target in mapping.items():
        if (not isinstance(target, str) or not Path(source).is_absolute()
                or not Path(target).is_absolute()):
            raise ValueError("Each source and target mapping must be an absolute path")
    return mapping


def mapped_path(source, mapping):
    path = Path(source)
    for old in sorted(mapping, key=lambda item: len(Path(item).parts), reverse=True):
        if path.is_relative_to(Path(old)):
            return Path(mapping[old]) / path.relative_to(Path(old))
    return path


def installed_inventory():
    rows = defaultdict(list)
    for distribution in importlib.metadata.distributions():
        name = distribution.metadata.get("Name")
        if not name:
            raise ValueError("Installed distribution is missing its Name metadata")
        row = {"name": name, "version": distribution.version,
               "location": str(distribution.locate_file(""))}
        metadata_path = getattr(distribution, "_path", None)
        if isinstance(metadata_path, Path):
            # PathDistribution exposes the metadata directory here. If another
            # provider cannot establish that provenance, duplicates stay strict.
            row["metadata_path"] = str(metadata_path)
        direct = distribution.read_text("direct_url.json")
        if direct:
            try:
                data = json.loads(direct)
                if data.get("dir_info", {}).get("editable") is True:
                    url = urlsplit(data["url"])
                    if url.scheme != "file" or url.netloc not in ("", "localhost"):
                        raise ValueError("Editable metadata must identify a local file URL")
                    row["editable_project_location"] = unquote(url.path)
            except (KeyError, TypeError, ValueError) as error:
                row["editable_metadata_error"] = str(error)
        rows[canonical(name)].append(row)
    return dict(rows)


def canonicalize_installed_inventory(installed):
    """Return canonical rows and evidence for narrowly proven editable aliases.

    A PEP 660 editable can expose its source .egg-info on sys.path in addition
    to the installed PEP 610 .dist-info. Only one installed editable primary,
    with equal name/version source .egg-info beneath that exact project, may
    be represented once. This does not merge ordinary duplicate installations.
    Callers must still compare the returned rows with the expected inventory.
    """
    canonical_rows = {name: list(rows) for name, rows in installed.items()}
    aliases = {}
    for name, rows in installed.items():
        if len(rows) < 2:
            continue
        primaries = [row for row in rows if row.get("editable_project_location")
                     and not row.get("editable_metadata_error")]
        if len(primaries) != 1:
            continue
        primary = primaries[0]
        try:
            project = Path(primary["editable_project_location"]).resolve(strict=True)
            metadata = Path(primary["metadata_path"]).resolve(strict=True)
            location = Path(primary["location"]).resolve(strict=True)
            require(project.is_dir(), "Editable project is not a directory")
            require(metadata.is_dir() and metadata.name.endswith(".dist-info")
                    and metadata.parent == location
                    and metadata.is_relative_to(Path(sys.prefix).resolve(strict=True)),
                    "Editable primary is not installed dist-info in this interpreter")
            auxiliary = [row for row in rows if row is not primary]
            for row in auxiliary:
                source_metadata = Path(row["metadata_path"]).resolve(strict=True)
                source_location = Path(row["location"]).resolve(strict=True)
                require(canonical(row["name"]) == canonical(primary["name"]) == name
                        and row["version"] == primary["version"]
                        and not row.get("editable_project_location")
                        and not row.get("editable_metadata_error"),
                        "Conflicting duplicate distribution")
                require(source_metadata.is_dir() and source_metadata.name.endswith(".egg-info")
                        and source_metadata.is_relative_to(project)
                        and source_metadata.parent == source_location,
                        "Duplicate is not source egg-info in the editable project")
            canonical_rows[name] = [primary]
            aliases[name] = {"primary": primary, "auxiliary": auxiliary,
                             "reason": "Matching source-tree egg-info of the installed PEP 610 editable"}
        except (KeyError, TypeError, OSError, RuntimeError, ValueError):
            # Missing provenance is a duplicate failure, never an assumption.
            continue
    return canonical_rows, aliases


def compare_inventory(expected, installed, mapping):
    installed, auxiliary = canonicalize_installed_inventory(installed)
    duplicates = {name: rows for name, rows in installed.items() if len(rows) != 1}
    actual = {name: rows[0]["version"] for name, rows in installed.items()}
    versions = {name: row["version"] for name, row in expected.items()}
    missing = sorted(versions.keys() - actual.keys())
    extra = sorted(actual.keys() - versions.keys())
    different = {name: {"expected": versions[name], "actual": actual[name]}
                 for name in sorted(versions.keys() & actual.keys())
                 if versions[name] != actual[name]}
    editables = {}
    for name in sorted(expected.keys() | installed.keys()):
        source = expected.get(name, {}).get("editable_project_location")
        row = installed.get(name, [{}])[0]
        actual_path = row.get("editable_project_location")
        metadata_error = row.get("editable_metadata_error")
        if source is None and actual_path is None and metadata_error is None:
            continue
        item = {"source": source, "actual": actual_path, "passed": False}
        try:
            require(metadata_error is None, f"Malformed editable metadata: {metadata_error}")
            require(source is not None, "Unexpected editable installation")
            target = mapped_path(source, mapping)
            item["expected_target"] = str(target)
            require(actual_path is not None, "Expected editable PEP 610 metadata is missing")
            require(Path(actual_path).is_absolute(), "Installed editable path is not absolute")
            target_resolved = target.resolve(strict=True)
            actual_resolved = Path(actual_path).resolve(strict=True)
            require(target_resolved.is_dir(), "Editable target is not a directory")
            item["resolved_target"] = str(target_resolved)
            item["resolved_actual"] = str(actual_resolved)
            require(actual_resolved == target_resolved, "Editable source directory differs")
            require(name in versions and actual.get(name) == versions[name],
                    "Editable package version differs")
            item["passed"] = True
        except (OSError, RuntimeError, ValueError) as error:
            item["error"] = str(error)
        editables[name] = item
    return {
        "expected_count": len(versions), "actual_count": len(actual),
        "missing": missing, "extra": extra, "different": different,
        "duplicates": duplicates, "editable_projects": editables,
        "auxiliary_editable_metadata": auxiliary,
        "exact_packages": not (missing or extra or different or duplicates),
        "editable_paths_and_versions": all(item["passed"] for item in editables.values()),
    }


def interpreter_check(expected_version):
    paths = {Path(sys.prefix).resolve(), Path(sys.base_prefix).resolve(),
             Path(sys.executable).resolve().parent}
    markers = sorted({str(parent / "conda-meta") for path in paths
                      for parent in (path, *path.parents)
                      if (parent / "conda-meta").is_dir()})
    config_path = Path(sys.prefix) / "pyvenv.cfg"
    config = {}
    if config_path.is_file():
        config = {key.strip().lower(): value.strip()
                  for line in config_path.read_text(encoding="utf-8").splitlines()
                  if "=" in line for key, value in [line.split("=", 1)]}
    checks = {
        "linux": sys.platform == "linux",
        "cpython": platform.python_implementation() == "CPython",
        "python_version": platform.python_version() == expected_version,
        "virtualenv": sys.prefix != sys.base_prefix and config_path.is_file(),
        "isolated_site_packages": config.get("include-system-site-packages", "").lower() == "false",
        "non_conda": not markers and not re.search(r"anaconda|conda-forge", sys.version, re.I),
    }
    return {"version": platform.python_version(), "expected_version": expected_version,
            "executable": sys.executable, "resolved_executable": str(Path(sys.executable).resolve()),
            "prefix": sys.prefix, "base_prefix": sys.base_prefix,
            "conda_metadata": markers, "checks": checks,
            "passed": all(checks.values())}


def classify_pip_check(returncode, stdout, stderr, allowed):
    lines = [line.strip() for line in stdout.splitlines() if line.strip()]
    conflicts = lines if returncode != 0 else []
    reviewed = [line for line in conflicts if line in allowed]
    unexpected = [line for line in conflicts if line not in allowed]
    clean = returncode == 0
    accepted = clean or (returncode == 1 and bool(conflicts)
                         and not unexpected and not stderr.strip())
    return {"exit_code": returncode, "stdout": stdout, "stderr": stderr,
            "clean": clean, "accepted": accepted, "reviewed_conflicts": reviewed,
            "unexpected_conflicts": unexpected, "explicit_allowlist": sorted(allowed)}


def jax_context(requested):
    import jax
    jax.config.update("jax_enable_x64", True)
    jax.config.update("jax_disable_jit", False)
    devices = jax.devices(requested)
    require(bool(devices), f"No {requested} JAX device available")
    require(devices[0].platform == requested,
            f"Requested {requested}, received {devices[0].platform} JAX device")
    return jax, devices[0]


def probe_jax(name, requested):
    import numpy as np
    jax, device = jax_context(requested)
    import jax.numpy as jnp
    details = {"device": str(device), "platform": device.platform, "float64": True}
    with jax.default_device(device):
        if name == "jax":
            matrix = jnp.array([[4., 1.], [1., 3.]], dtype=jnp.float64)
            vector = jnp.array([1., 2.], dtype=jnp.float64)
            solve = jax.jit(jnp.linalg.solve)(matrix, vector).block_until_ready()
            gradient = jax.jit(jax.grad(lambda x: x @ matrix @ x))(vector).block_until_ready()
            np.testing.assert_allclose(solve, [1. / 11., 7. / 11.], rtol=1e-12)
            np.testing.assert_allclose(gradient, [12., 14.], rtol=1e-12)
            require(solve.dtype == jnp.float64 and gradient.dtype == jnp.float64,
                    "JAX silently reduced precision")
            require(all(d.platform == requested for d in solve.devices() | gradient.devices()),
                    "JAX results did not execute on the requested device")
            details.update(solve=np.asarray(solve).tolist(), gradient=np.asarray(gradient).tolist())
        elif name == "optax":
            import optax
            values = jnp.array([1., 2., 3.], dtype=jnp.float64)
            optimizer = optax.sgd(0.1)
            updates, _ = optimizer.update(jax.grad(lambda x: x @ x)(values), optimizer.init(values))
            after = optax.apply_updates(values, updates).block_until_ready()
            np.testing.assert_allclose(after, [0.8, 1.6, 2.4], rtol=1e-12)
        elif name == "blackjax":
            import blackjax
            kernel = blackjax.hmc(lambda x: -0.5 * (x @ x), step_size=0.15,
                                  inverse_mass_matrix=jnp.ones(2), num_integration_steps=5)
            state = kernel.init(jnp.array([0.1, -0.1], dtype=jnp.float64))
            step = jax.jit(kernel.step)
            positions, accepted, divergent = [], 0, 0
            for key in jax.random.split(jax.random.key(77), 16):
                state, info = step(key, state)
                positions.append(np.asarray(state.position.block_until_ready()))
                accepted += int(info.is_accepted)
                divergent += int(info.is_divergent)
            require(bool(np.isfinite(positions).all()) and accepted > 0 and divergent == 0,
                    "BlackJAX short Gaussian HMC chain is nonfinite, stuck, or divergent")
            details.update(steps=16, accepted=accepted, divergent=divergent,
                           convergence_assessed=False)
        elif name == "numpyro":
            import numpyro
            import numpyro.distributions as dist
            from numpyro.infer import MCMC, NUTS

            def model():
                mean = numpyro.sample("mean", dist.Normal(0., 1.))
                numpyro.sample("observed", dist.Normal(mean, 1.),
                               obs=jnp.array([-0.2, 0., 0.3], dtype=jnp.float64))

            sampler = MCMC(NUTS(model, max_tree_depth=5), num_warmup=32,
                           num_samples=16, num_chains=1, chain_method="sequential",
                           progress_bar=False)
            sampler.run(jax.random.key(77))
            samples = np.asarray(sampler.get_samples()["mean"])
            divergent = int(np.asarray(sampler.get_extra_fields()["diverging"]).sum())
            require(samples.shape == (16,) and bool(np.isfinite(samples).all())
                    and float(samples.std()) > 0 and divergent == 0,
                    "NumPyro short NUTS chain is nonfinite, stuck, or divergent")
            details.update(warmup=32, samples=16, divergent=divergent,
                           convergence_assessed=False)
    return details


def probe_cpu(name, torch_version, tfp_version="", tfp_distribution=""):
    import numpy as np
    matrix = np.array([[4., 1.], [1., 3.]], dtype=np.float64)
    vector = np.array([1., 2.], dtype=np.float64)
    if name == "torch":
        import torch
        require(torch.__version__ == torch_version, "Imported PyTorch version differs from source")
        if torch_version.endswith("+cpu"):
            require(torch.version.cuda is None, "Source requires the CPU-only PyTorch build")
        values = torch.tensor([1., 2., 3.], device="cpu", dtype=torch.float64, requires_grad=True)
        loss = values @ values
        loss.backward()
        np.testing.assert_allclose(values.grad.numpy(), [2., 4., 6.], rtol=1e-12)
        solve = torch.linalg.solve(torch.from_numpy(matrix), torch.from_numpy(vector))
        np.testing.assert_allclose(solve.numpy(), [1. / 11., 7. / 11.], rtol=1e-12)
        return {"version": torch.__version__, "device": str(solve.device),
                "cuda_build": torch.version.cuda, "source_cpu_build_required": torch_version.endswith("+cpu")}
    if name == "hdf5":
        import h5py
        with tempfile.TemporaryDirectory(prefix="dotrepo-hdf5-") as temp:
            path = Path(temp) / "roundtrip.h5"
            with h5py.File(path, "w") as handle:
                handle.create_dataset("matrix", data=matrix, compression="gzip")
            with h5py.File(path, "r") as handle:
                np.testing.assert_array_equal(handle["matrix"][:], matrix)
        return {"hdf5_version": h5py.version.hdf5_version, "gzip_roundtrip": True}
    if name == "numba":
        import numba
        solve = numba.njit(lambda a, b: np.linalg.solve(a, b))
        np.testing.assert_allclose(solve(matrix, vector), [1. / 11., 7. / 11.], rtol=1e-12)
        require(bool(solve.nopython_signatures), "Numba did not compile in nopython mode")
        return {"compiled_signatures": [str(signature) for signature in solve.nopython_signatures]}
    if name == "pytensor":
        import pytensor
        import pytensor.tensor as pt
        x = pt.dvector("x")
        fn = pytensor.function([x], pt.dot(x, x), mode="NUMBA")
        np.testing.assert_allclose(fn(vector), 5., rtol=1e-12)
        linker = type(fn.maker.mode.linker).__name__
        require("numba" in linker.lower(), f"Unexpected PyTensor linker: {linker}")
        return {"mode": "NUMBA", "linker": linker, "result": float(fn(vector))}
    if name == "pymc":
        import pymc as pm
        with pm.Model() as model:
            mean = pm.Normal("mean", 0., 1.)
            pm.Normal("observed", mean, 1., observed=np.array([-0.2, 0., 0.3]))
        value = float(model.compile_logp(mode="NUMBA")({"mean": np.array(0., dtype=np.float64)}))
        expected = -0.5 * (4 * math.log(2 * math.pi) + 0.2 ** 2 + 0.3 ** 2)
        np.testing.assert_allclose(value, expected, rtol=1e-12)
        return {"mode": "NUMBA", "compiled_logp": value, "analytic_logp": expected}
    if name == "gpflow":
        import tensorflow as tf
        tf.config.set_visible_devices([], "GPU")
        import gpflow
        require(not tf.config.get_visible_devices("GPU"), "TensorFlow must stay on CPU for this probe")
        x = np.array([[0.], [0.5], [1.]], dtype=np.float64)
        y = np.sin(x)
        with tf.device("/CPU:0"):
            model = gpflow.models.GPR((x, y), kernel=gpflow.kernels.SquaredExponential(),
                                     noise_variance=0.05)
            with tf.GradientTape() as tape:
                loss = model.training_loss()
            gradients = tape.gradient(loss, model.trainable_variables)
            mean, variance = model.predict_f(x)
        require(math.isfinite(float(loss)) and bool(gradients), "GPflow loss or gradient is invalid")
        require(all(g is not None and bool(np.isfinite(g.numpy()).all()) for g in gradients),
                "GPflow produced a missing or nonfinite gradient")
        require(mean.shape == y.shape and bool(np.isfinite(mean.numpy()).all())
                and bool(np.isfinite(variance.numpy()).all()) and bool((variance.numpy() >= 0).all()),
                "GPflow regression prediction is invalid")
        covariance = np.exp(-0.5 * (x - x.T) ** 2) + 0.05 * np.eye(len(x))
        cross = np.exp(-0.5 * (x - x.T) ** 2)
        np.testing.assert_allclose(mean.numpy(), cross @ np.linalg.solve(covariance, y), atol=1e-6)
        return {"tensorflow": tf.__version__, "gpflow": gpflow.__version__,
                "device": loss.device, "loss": float(loss), "prediction_shape": list(mean.shape),
                "visible_gpus": [], "optimization_run": False}
    if name == "tfp":
        import tensorflow_probability as tfp
        from packaging.version import Version
        require(bool(tfp_version), "Expected TensorFlow Probability payload version is missing")
        require(Version(tfp.__version__) == Version(tfp_version),
                f"Imported TFP payload {tfp.__version__} differs from recorded {tfp_distribution} {tfp_version}; stable/nightly files share one namespace")
        return {"imported_version": tfp.__version__, "expected_version": tfp_version,
                "expected_distribution": tfp_distribution, "module_file": str(tfp.__file__),
                "cpu_only_process": os.environ.get("CUDA_VISIBLE_DEVICES") == "-1",
                "scope": "Payload import/version; GPflow has a separate optional regression probe"}
    raise ValueError(f"Unknown probe: {name}")


def worker(args):
    started = time.monotonic()
    try:
        detail = (probe_jax(args.probe, args.jax_platform) if args.probe in JAX_PROBES
                  else probe_cpu(args.probe, args.torch_source_version,
                                 args.tfp_source_version, args.tfp_source_distribution))
        result = {"status": "passed", "details": detail}
    except Exception as error:
        result = {"status": "failed", "error": f"{type(error).__name__}: {error}",
                  "traceback": traceback.format_exc()}
    result["seconds"] = round(time.monotonic() - started, 3)
    print(PROBE_MARKER + json.dumps(result), flush=True)
    return 0 if result["status"] == "passed" else 1


def run_probe(name, args, expected):
    env = os.environ.copy()
    env["XLA_PYTHON_CLIENT_PREALLOCATE"] = "false"
    if name in JAX_PROBES and args.jax_platform == "gpu":
        # JAX_PLATFORMS=gpu requires both CUDA and ROCm in some JAX releases.
        # Discover installed backends, then explicitly require jax.devices('gpu').
        env.pop("JAX_PLATFORMS", None)
    else:
        env["JAX_PLATFORMS"] = "cpu"
    if name not in JAX_PROBES or args.jax_platform == "cpu":
        env["CUDA_VISIBLE_DEVICES"] = "-1"
    env["TF_NUM_INTRAOP_THREADS"] = "2"
    env["TF_NUM_INTEROP_THREADS"] = "2"
    tfp_distribution = "tfp-nightly" if "tfp-nightly" in expected else "tensorflow-probability"
    command = [sys.executable, "-I", str(Path(__file__).resolve()), "--probe", name,
               "--jax-platform", args.jax_platform, "--torch-source-version",
               expected.get("torch", {}).get("version", ""), "--tfp-source-distribution",
               tfp_distribution, "--tfp-source-version", expected.get(tfp_distribution, {}).get("version", "")]
    try:
        completed = subprocess.run(command, capture_output=True, text=True,
                                   errors="replace", timeout=args.timeout, env=env)
        lines = [line[len(PROBE_MARKER):] for line in completed.stdout.splitlines()
                 if line.startswith(PROBE_MARKER)]
        result = json.loads(lines[-1]) if lines else {
            "status": "failed", "error": "Child exited without a result (possible native crash)"}
        result.update(exit_code=completed.returncode, stdout=completed.stdout, stderr=completed.stderr)
        if completed.returncode != 0:
            result["status"] = "failed"
        return result
    except subprocess.TimeoutExpired as error:
        return {"status": "failed", "error": f"Probe exceeded {args.timeout} seconds",
                "stdout": decode_output(error.stdout), "stderr": decode_output(error.stderr)}


def decode_output(value):
    return value.decode("utf-8", errors="replace") if isinstance(value, bytes) else value or ""


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--inventory", type=Path)
    parser.add_argument("--python-version")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--path-map", type=Path)
    parser.add_argument("--allow-pip-conflict", action="append", default=[], metavar="EXACT_MESSAGE")
    parser.add_argument("--include-gpflow", action="store_true")
    parser.add_argument("--jax-platform", choices=("gpu", "cpu"), default="gpu")
    parser.add_argument("--timeout", type=int, default=360, help="Timeout per subprocess, in seconds")
    parser.add_argument("--probe", choices=tuple(PROBE_PACKAGES), help=argparse.SUPPRESS)
    parser.add_argument("--torch-source-version", default="", help=argparse.SUPPRESS)
    parser.add_argument("--tfp-source-version", default="", help=argparse.SUPPRESS)
    parser.add_argument("--tfp-source-distribution", default="", help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.probe:
        return worker(args)
    if args.inventory is None or args.output is None or args.python_version is None:
        parser.error("--inventory, --python-version, and --output are required")
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    if args.output.resolve() in {args.inventory.resolve(), Path(__file__).resolve(),
                                args.path_map.resolve() if args.path_map else None}:
        parser.error("Output must not overwrite the inventory, path map, or validator")
    result = {"started": datetime.now(timezone.utc).isoformat(), "checks": {}, "errors": [],
              "runtime": {}, "passed": False, "accepted": False, "status": "failed",
              "limits": ["Small runtime checks do not establish full project regression coverage or sampler convergence.",
                         "Editable paths and metadata versions do not establish matching source content or commits.",
                         "GPU validation does not establish capacity for production workloads."]}
    exit_code = 1
    try:
        expected, inventory_hash = read_inventory(args.inventory)
        mapping = read_path_map(args.path_map)
        result["inventory"] = {"path": str(args.inventory.resolve()), "sha256": inventory_hash,
                               "path_map": mapping}
        result["interpreter"] = interpreter_check(args.python_version)
        result["packages"] = compare_inventory(expected, installed_inventory(), mapping)
        checks = result["checks"]
        checks["interpreter"] = result["interpreter"]["passed"]
        checks["exact_packages"] = result["packages"]["exact_packages"]
        checks["editable_paths_and_versions"] = result["packages"]["editable_paths_and_versions"]
        context = ssl.create_default_context()
        checks["tls_verification_enabled"] = context.check_hostname and context.verify_mode == ssl.CERT_REQUIRED
        with sqlite3.connect(":memory:") as connection:
            checks["sqlite"] = connection.execute("select 6 * 7").fetchone()[0] == 42
        try:
            pip = subprocess.run([sys.executable, "-I", "-m", "pip", "check"], capture_output=True,
                                 text=True, errors="replace", timeout=args.timeout)
            result["pip_check"] = classify_pip_check(pip.returncode, pip.stdout, pip.stderr,
                                                     set(args.allow_pip_conflict))
        except subprocess.TimeoutExpired as error:
            result["pip_check"] = {"clean": False, "accepted": False, "error": "pip check timed out",
                                   "stdout": decode_output(error.stdout), "stderr": decode_output(error.stderr)}
        checks["dependency_policy"] = result["pip_check"]["accepted"]
        for probe, package in PROBE_PACKAGES.items():
            if package not in expected and not (probe == "tfp" and "tfp-nightly" in expected):
                result["runtime"][probe] = {"status": "not_applicable", "reason": "Not in source inventory"}
            elif probe == "gpflow" and not args.include_gpflow:
                result["runtime"][probe] = {"status": "not_run", "reason": "Enable separate CPU probe with --include-gpflow"}
                result["limits"].append("GPflow runtime was not tested; its dependency metadata is still checked.")
            elif not checks["interpreter"]:
                result["runtime"][probe] = {"status": "failed", "error": "Wrong interpreter; scientific probe not run"}
            else:
                print(f"Checking {probe}...", flush=True)
                result["runtime"][probe] = run_probe(probe, args, expected)
            if result["runtime"][probe]["status"] not in ("not_applicable", "not_run"):
                checks["runtime_" + probe] = result["runtime"][probe]["status"] == "passed"
        result["accepted"] = all(checks.values())
        result["passed"] = result["accepted"] and result["pip_check"]["clean"]
        result["status"] = ("passed" if result["passed"] else
                            "accepted_with_reviewed_dependency_conflicts" if result["accepted"] else "failed")
        exit_code = 0 if result["accepted"] else 1
    except (ValueError, OSError) as error:
        result["errors"].append(f"{type(error).__name__}: {error}")
        exit_code = 2
    except Exception as error:
        result["errors"].append(f"{type(error).__name__}: {error}")
        result["traceback"] = traceback.format_exc()
    result["finished"] = datetime.now(timezone.utc).isoformat()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"status": result["status"], "passed": result["passed"],
                      "accepted": result["accepted"], "output": str(args.output.resolve()),
                      "failed_checks": [name for name, value in result["checks"].items() if not value]}))
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
