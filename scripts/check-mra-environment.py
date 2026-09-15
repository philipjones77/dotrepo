#!/usr/bin/env python3
"""Exercise the installed serial MRA likelihood and prediction executable."""

from __future__ import annotations

import argparse
import json
import math
import os
import re
import shutil
import struct
import subprocess
import tempfile
from pathlib import Path

import numpy as np


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--binary", type=Path)
    parser.add_argument("--template", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    executable = args.binary or shutil.which("mra-serial")
    if not executable:
        raise SystemExit("mra-serial is not on PATH; supply --binary.")
    binary = Path(executable).resolve()
    template = args.template or binary.parents[1] / "share/user_parameters.template"
    text = template.read_text()
    env = {**os.environ, "OPENBLAS_NUM_THREADS": "1", "OMP_NUM_THREADS": "1"}
    points = np.random.default_rng(3).uniform(0.1, 0.9, (24, 2))
    values = np.sin(points[:, 0] * 3) + np.cos(points[:, 1] * 2)
    query = np.array([[0.2, 0.2], [0.3, 0.6], [0.6, 0.3], [0.7, 0.7]])
    record = {
        "status": "passed",
        "training_count": 24,
        "prediction_count": 4,
        "checks": [],
    }
    with tempfile.TemporaryDirectory(prefix="dotrepo-mra-") as directory:
        work = Path(directory)
        for name, arrays in (("train", (*points.T, values)), ("query", tuple(query.T))):
            with (work / (name + ".bin")).open("wb") as stream:
                stream.write(struct.pack("<Q", len(arrays[0])))
                for array in arrays:
                    np.asarray(array, dtype="<f8").tofile(stream)
        base = {
            "DATA_FILE_NAME": str(work / "train.bin"),
            "ELIMINATION_DUPLICATES_FLAG": "false",
            "NUM_PARTITIONS_J": "2",
            "NUM_KNOTS_r": "4",
            "PRINT_DETAIL_FLAG": "false",
            "PREDICTION_LOCATION_MODE": "A",
            "PREDICTION_LOCATION_FILE": str(work / "query.bin"),
            "DUMP_PREDICTION_RESULTS_FLAG": "true",
            "PREDICTION_RESULTS_FILE_NAME": str(work / "prediction.bin"),
            "SAVE_TO_DISK_FLAG": "false",
            "ALPHA": "1",
            "BETA": ".5",
            "TAU": ".01",
        }
        for levels in (2, 3):
            check = {"levels": levels, "knots_per_region": 4}
            for mode in ("likelihood", "prediction"):
                overrides = {
                    **base,
                    "NUM_LEVELS_M": str(levels),
                    "CALCULATION_MODE": mode,
                }
                lines = []
                for line in text.splitlines():
                    key = line.split("=", 1)[0].strip()
                    lines.append(
                        key + "=" + overrides[key] if key in overrides else line
                    )
                (work / "user_parameters").write_text("\n".join(lines) + "\n")
                result = subprocess.run(
                    [str(binary)],
                    cwd=work,
                    env=env,
                    capture_output=True,
                    text=True,
                    timeout=60,
                    check=False,
                )
                if result.returncode or "Program exits with an error" in result.stdout:
                    raise RuntimeError(
                        f"MRA {mode} failed: {result.stdout[-1500:]}\n{result.stderr[-1500:]}"
                    )
                if mode == "likelihood":
                    match = re.search(
                        r"obtained loglikelihood is:\s*([-+\deE.]+)", result.stdout
                    )
                    if not match or not math.isfinite(float(match.group(1))):
                        raise AssertionError(
                            "MRA did not report a finite log likelihood"
                        )
                    check["log_likelihood"] = float(match.group(1))
            with (work / "prediction.bin").open("rb") as stream:
                count = struct.unpack("<Q", stream.read(8))[0]
                output = np.fromfile(stream, dtype="<f8")
            if count != 4 or output.size != 16 or not np.isfinite(output).all():
                raise AssertionError("MRA prediction shape or values are invalid")
            variance = output.reshape(4, 4)[3]
            if not (variance > 0).all():
                raise AssertionError("MRA prediction variances must be positive")
            check["minimum_prediction_variance"] = float(variance.min())
            record["checks"].append(check)
    payload = json.dumps(record, indent=2) + "\n"
    if args.output:
        args.output.write_text(payload)
    print(payload, end="")


if __name__ == "__main__":
    main()
