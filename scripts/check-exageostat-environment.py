#!/usr/bin/env python3
"""Run a small CPU ExaGeoStat fit and prediction using only Python's stdlib."""

import argparse
import json
import math
import os
from pathlib import Path
import re
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--executable", type=Path,
                        default=Path.home() / ".local/bin/exageostat-cpu")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--log", type=Path)
    args = parser.parse_args()
    executable = args.executable.expanduser().resolve()
    environment = dict(os.environ, OPENBLAS_NUM_THREADS="1", OMP_NUM_THREADS="1",
                       STARPU_NCUDA="0", STARPU_NOPENCL="0")
    with tempfile.TemporaryDirectory(prefix="exageostat-check-") as directory:
        working = Path(directory)
        dataset = working / "observations.csv"
        rows = []
        for index in range(64):
            x = (index % 8 + 0.5) / 8
            y = (index // 8 + 0.5) / 8
            value = math.sin(4 * x) + math.cos(3 * y) + 0.05 * math.sin(17 * index)
            rows.append(f"{x:.17g},{y:.17g},{value:.17g}")
        dataset.write_text("\n".join(rows) + "\n", encoding="utf-8")
        command = [str(executable), "--N=64", "--dts=16", "--cores=2",
                   "--gpus=0", "--computation=exact", "--dimension=2D",
                   "--kernel=UnivariateMaternStationary",
                   f"--data-path={dataset}", "--initial-theta=1:0.3:0.7",
                   "--lb=0.1:0.05:0.1", "--ub=2:2:2",
                   "--max-mle-iterations=8", "--tolerance=7", "--seed=42",
                   "--zmiss=8", "--mspe", "--log=true",
                   f"--log-path={working}", f"--file-log-path={working / 'fit.log'}"]
        result = subprocess.run(command, cwd=working, env=environment,
                                text=True, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, timeout=180)
    if args.log:
        args.log.write_text(result.stdout, encoding="utf-8")
    checks = {}
    labels = {"log_likelihood": "Final Log Likelihood Value",
              "mspe": "Mean Square Error MSPE",
              "iterations": "Number of MLE Iterations"}
    for key, label in labels.items():
        match = re.search(re.escape(label) + r":\s*([^\s]+)", result.stdout)
        checks[key] = float(match.group(1)) if match else None
    success = (result.returncode == 0 and
               all(value is not None and math.isfinite(value) for value in checks.values()) and
               checks["mspe"] >= 0 and checks["iterations"] >= 1)
    receipt = {"status": "passed" if success else "failed",
               "executable": str(executable).replace(str(Path.home()), "~"),
               "exit_code": result.returncode,
               "workload": "64-point Matérn exact CPU maximum likelihood and 8 held-out predictions",
               "cores": 2, "gpus": 0, "seed": 42, "metrics": checks,
               "scope": "Finite fit and prediction smoke test; no large-scale, GPU, MPI or low-rank validation."}
    if not success:
        receipt["failure_output_tail"] = result.stdout[-6000:].replace(
            str(Path.home()), "~").replace(directory, "<temporary-workload>")
    encoded = json.dumps(receipt, indent=2) + "\n"
    if args.output:
        args.output.write_text(encoded, encoding="utf-8")
    print(encoded, end="")
    return 0 if success else 1


if __name__ == "__main__":
    raise SystemExit(main())
