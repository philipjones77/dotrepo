"""Check interpreter, exact installed distribution set, and representative workloads."""
import argparse
import importlib.metadata
import json
import platform
import re
import sqlite3
import ssl
import subprocess
import sys
from pathlib import Path


def canonical(name):
    return re.sub(r"[-_.]+", "-", name).lower()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inventory", type=Path, required=True)
    parser.add_argument("--python-version", required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    expected = {canonical(p["name"]): p["version"] for p in json.loads(args.inventory.read_text(encoding="utf-8-sig"))}
    actual = {canonical(p.metadata["Name"]): p.version for p in importlib.metadata.distributions()}
    result = {
        "python": platform.python_version(), "executable": sys.executable,
        "base_prefix": sys.base_prefix, "prefix": sys.prefix,
        "expected_packages": len(expected), "actual_packages": len(actual),
        "missing": sorted(expected.keys() - actual.keys()),
        "extra": sorted(actual.keys() - expected.keys()),
        "different": {p: {"expected": expected[p], "actual": actual[p]}
                      for p in expected.keys() & actual.keys() if expected[p] != actual[p]},
        "checks": {}, "errors": [],
    }
    checks = result["checks"]
    checks["python_version"] = platform.python_version() == args.python_version
    checks["standard_cpython"] = (sys.prefix != sys.base_prefix and
                                  not (Path(sys.base_prefix) / "conda-meta").exists())
    checks["exact_packages"] = actual == expected
    try:
        context = ssl.create_default_context()
        checks["tls_validation"] = context.check_hostname and context.verify_mode == ssl.CERT_REQUIRED
        with sqlite3.connect(":memory:") as connection:
            checks["sqlite"] = connection.execute("select 6 * 7").fetchone()[0] == 42
        dependency = subprocess.run([sys.executable, "-m", "pip", "check"], capture_output=True, text=True)
        checks["dependencies"] = dependency.returncode == 0
        result["pip_check"] = (dependency.stdout + dependency.stderr).strip()
        if "pyyaml" in expected:
            import yaml
            checks["yaml"] = yaml.safe_load("answer: 42")["answer"] == 42
        if "jax" in expected:
            import jax
            import jax.numpy as jnp
            import numpy as np
            values = jnp.array([1., 2., 3.])
            value = jax.jit(lambda x: jnp.dot(x, x))(values)
            gradient = jax.grad(lambda x: jnp.dot(x, x))(values)
            checks["jax_jit_and_gradient"] = float(value) == 14 and bool(np.array_equal(gradient, [2, 4, 6]))
            result["jax_devices"] = [str(d) for d in jax.devices()]
        if "torch" in expected:
            import torch
            checks["torch_matmul"] = float(torch.tensor([1., 2., 3.]) @ torch.tensor([1., 2., 3.])) == 14
        if "pyvista" in expected:
            import pyvista as pv
            checks["vtk_mesh"] = pv.Sphere().n_points > 0
        if "scipy" in expected:
            import numpy as np
            from scipy.linalg import solve
            checks["scipy_solve"] = bool(np.allclose(solve([[2., 0.], [0., 4.]], [4., 8.]), [2., 2.]))
    except Exception as error:
        result["errors"].append(f"{type(error).__name__}: {error}")
    result["passed"] = all(checks.values()) and not result["errors"]
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, indent=2))
    return 0 if result["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
