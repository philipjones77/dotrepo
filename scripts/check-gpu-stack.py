#!/usr/bin/env python3
"""Record exact GPU package versions and check a small JAX GPU calculation."""

import argparse
import csv
import json
import os
import platform
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from importlib import metadata
from pathlib import Path


def command_output(command):
    result = subprocess.run(
        command, capture_output=True, text=True, timeout=20, check=False
    )
    if result.returncode:
        raise RuntimeError(
            result.stderr.strip() or f"Command exited {result.returncode}"
        )
    return result.stdout


def package_versions():
    selected = {}
    for distribution in metadata.distributions():
        name = re.sub(r"[-_.]+", "-", distribution.metadata["Name"]).lower()
        if name in {
            "jax",
            "jaxlib",
            "torch",
            "triton",
            "numpy",
            "scipy",
            "flax",
        } or name.startswith(("jax-cuda", "cuda-", "nvidia-")):
            selected[name] = distribution.version
    return dict(sorted(selected.items()))


def driver_inventory():
    executable = shutil.which("nvidia-smi")
    wsl_executable = Path("/usr/lib/wsl/lib/nvidia-smi")
    if executable is None and wsl_executable.is_file():
        executable = str(wsl_executable)
    if executable is None:
        return {"available": False, "gpus": [], "cuda_capability": None}
    rows = command_output(
        [
            executable,
            "--query-gpu=name,driver_version,compute_cap",
            "--format=csv,noheader",
        ]
    )
    banner = command_output([executable])
    capability = re.search(r"CUDA(?: UMD)? Version:\s*([0-9.]+)", banner)
    return {
        "available": True,
        "gpus": [
            dict(
                zip(
                    ("name", "driver_version", "compute_capability"),
                    (value.strip() for value in row),
                )
            )
            for row in csv.reader(rows.splitlines())
        ],
        "cuda_capability": capability.group(1) if capability else None,
        "cuda_capability_meaning": "Driver-reported CUDA capability; not the installed runtime or compiler version.",
    }


def compiler_inventory():
    tools = {}
    for name in ("nvcc", "ptxas"):
        found = shutil.which(name)
        candidates = [Path(found)] if found else []
        for distribution_name in ("nvidia-cuda-nvcc", "nvidia-cuda-nvcc-cu12"):
            try:
                distribution = metadata.distribution(distribution_name)
            except metadata.PackageNotFoundError:
                continue
            candidates.extend(
                distribution.locate_file(item)
                for item in distribution.files or []
                if Path(item).name == name
            )
        candidates = list(
            dict.fromkeys(path.resolve() for path in candidates if path.is_file())
        )
        records = []
        for path in candidates:
            output = command_output([str(path), "--version"])
            version = re.search(r"release\s+([0-9.]+),\s+V([0-9.]+)", output)
            records.append(
                {
                    "path": str(path),
                    "release": version.group(1) if version else None,
                    "version": version.group(2) if version else None,
                }
            )
        tools[name] = {"on_path": found is not None, "executables": records}
    return tools


def runtime_check():
    # These settings affect this short-lived checker only.
    os.environ["XLA_PYTHON_CLIENT_PREALLOCATE"] = "false"
    for variable in ("OPENBLAS_NUM_THREADS", "OMP_NUM_THREADS", "MKL_NUM_THREADS"):
        os.environ[variable] = "1"
    import jax
    import jax.numpy as jnp
    import numpy as np
    import torch

    jax.config.update("jax_enable_x64", True)
    device = jax.devices("gpu")[0]
    host = np.arange(16, dtype=np.float64).reshape(4, 4) / 10
    operand = jax.device_put(host, device)
    value, gradient = jax.jit(jax.value_and_grad(lambda x: jnp.sum((x @ x.T) ** 2)))(
        operand
    )
    value.block_until_ready()
    gradient.block_until_ready()
    expected_value = np.sum((host @ host.T) ** 2)
    expected_gradient = 4 * (host @ host.T) @ host
    np.testing.assert_allclose(value, expected_value, rtol=1e-12, atol=1e-12)
    np.testing.assert_allclose(gradient, expected_gradient, rtol=1e-12, atol=1e-12)
    if any(result_device.platform != "gpu" for result_device in gradient.devices()):
        raise RuntimeError("JAX result was not placed on a GPU")

    # The extension exposes the versions of libraries actually loaded by JAX.
    from jax._src.lib import cuda_versions

    versions = {}
    for component in (
        "cuda_runtime",
        "cuda_driver",
        "cudnn",
        "cublas",
        "cufft",
        "cupti",
        "cusparse",
    ):
        probe = getattr(cuda_versions, component + "_get_version", None)
        if probe is not None:
            versions[component] = int(probe())
    torch.set_num_threads(1)
    torch_cuda = {
        "build_cuda": torch.version.cuda,
        "cuda_available": torch.cuda.is_available(),
        "cudnn_runtime": torch.backends.cudnn.version(),
    }
    if not torch_cuda["cuda_available"]:
        raise RuntimeError("PyTorch cannot access CUDA")
    return {
        "status": "passed",
        "device_kind": device.device_kind,
        "device_platform": device.platform,
        "shape": [4, 4],
        "dtype": "float64",
        "calculation": "JIT value and gradient of sum((A @ A.T)**2), compared with NumPy and analytic gradient",
        "value_absolute_error": float(abs(float(value) - expected_value)),
        "gradient_max_absolute_error": float(
            np.max(np.abs(np.asarray(gradient) - expected_gradient))
        ),
        "cuda_versions": versions,
        "cuda_versions_encoding": "Native integer API versions; CUDA 13000 means 13.0, cuDNN 92400 means 9.24.0.",
        "torch": torch_cuda,
        "scope": "JAX GPU computation; PyTorch CUDA availability and library versions, without a PyTorch workload.",
    }


def compare(expected, actual, require_driver_match, inventory_only):
    differences = []

    def check(field, left, right):
        if left != right:
            differences.append({"field": field, "expected": left, "actual": right})

    check("python.version", expected["python"]["version"], actual["python"]["version"])
    for name in sorted(expected["packages"].keys() | actual["packages"].keys()):
        check(
            "packages." + name,
            expected["packages"].get(name),
            actual["packages"].get(name),
        )
    for name in ("nvcc", "ptxas"):
        previous = sorted(
            {item["version"] for item in expected["compiler"][name]["executables"]}
        )
        current = sorted(
            {item["version"] for item in actual["compiler"][name]["executables"]}
        )
        check("compiler." + name + ".versions", previous, current)
    if require_driver_match:
        previous = sorted(
            {item["driver_version"] for item in expected["driver"]["gpus"]}
        )
        current = sorted({item["driver_version"] for item in actual["driver"]["gpus"]})
        check("driver.versions", previous, current)
    if not inventory_only:
        # Driver capability can differ across hardware; compare loaded runtime libraries.
        previous = expected.get("runtime", {}).get("cuda_versions", {})
        current = actual.get("runtime", {}).get("cuda_versions", {})
        for name in sorted((previous.keys() | current.keys()) - {"cuda_driver"}):
            check(
                "runtime.cuda_versions." + name, previous.get(name), current.get(name)
            )
        for name in ("build_cuda", "cudnn_runtime"):
            check(
                "runtime.torch." + name,
                expected.get("runtime", {}).get("torch", {}).get(name),
                actual.get("runtime", {}).get("torch", {}).get(name),
            )
    return differences


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--expected",
        type=Path,
        help="Compare exact package/compiler/runtime versions with this receipt",
    )
    parser.add_argument("--output", type=Path, help="Write the JSON receipt here")
    parser.add_argument(
        "--require-driver-match",
        action="store_true",
        help="Also require the same host driver version",
    )
    parser.add_argument(
        "--inventory-only",
        action="store_true",
        help="Collect and compare installed versions without loading GPU runtimes",
    )
    args = parser.parse_args()
    report = {
        "schema_version": 1,
        "captured_at": datetime.now(timezone.utc).isoformat(),
        "hostname": platform.node(),
        "platform": {
            "system": platform.system(),
            "release": platform.release(),
            "machine": platform.machine(),
        },
        "python": {"version": platform.python_version(), "executable": sys.executable},
        "packages": package_versions(),
        "driver": {},
        "compiler": {},
        "runtime": {"status": "not_requested"},
        "failures": [],
    }
    for section, operation in (
        ("driver", driver_inventory),
        ("compiler", compiler_inventory),
    ):
        try:
            report[section] = operation()
        except Exception as error:  # noqa: BLE001 - Persist probe failures in the JSON receipt.
            report["failures"].append(
                {"section": section, "error": f"{type(error).__name__}: {error}"}
            )
    if not args.inventory_only:
        try:
            report["runtime"] = runtime_check()
        except Exception as error:  # noqa: BLE001 - GPU failures must produce JSON and a nonzero exit.
            report["runtime"] = {"status": "failed"}
            report["failures"].append(
                {"section": "runtime", "error": f"{type(error).__name__}: {error}"}
            )
    if args.expected:
        try:
            expected = json.loads(args.expected.read_text(encoding="utf-8"))
            differences = compare(
                expected, report, args.require_driver_match, args.inventory_only
            )
            report["comparison"] = {
                "status": "different" if differences else "matched",
                "differences": differences,
                "driver_version_required": args.require_driver_match,
                "runtime_compared": not args.inventory_only,
            }
        except Exception as error:  # noqa: BLE001 - Persist malformed-manifest and comparison failures.
            report["failures"].append(
                {"section": "comparison", "error": f"{type(error).__name__}: {error}"}
            )
    failed = bool(report["failures"] or report.get("comparison", {}).get("differences"))
    report["status"] = (
        "failed"
        if failed
        else ("inventory_recorded" if args.inventory_only else "passed")
    )
    serialized = json.dumps(report, indent=2).replace(str(Path.home()), "~") + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(serialized, encoding="utf-8")
    print(serialized, end="")
    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())
