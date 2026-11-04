"""Install a pinned set into a candidate env; a package that fails to build from source is
unpinned and marked binary-only (newer wheel), then re-resolved. Every change is logged."""
import re, subprocess, sys
pinned_in, lock, py, envpy, log = sys.argv[1:6]
fixed = {"jax", "jaxlib", "jax-cuda13-plugin", "jax-cuda13-pjrt"}
pins = {l.strip().split("==")[0]: l.strip() for l in open(pinned_in) if l.strip()}
nobuild, changes = [], []
def resolve():
    for attempt in range(40):
        open(pinned_in + ".work", "w").write("\n".join(pins.values()) + "\n")
        cmd = ["uv", "pip", "compile", "--python", py, pinned_in + ".work", "-o", lock]
        for p in nobuild: cmd += ["--only-binary", p]
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode == 0:
            return
        names = re.findall(r"([A-Za-z0-9_.\-]+)==([0-9][^\s,]*)", r.stderr)
        cand = [n for n, v in names if n in pins and n not in fixed and pins[n].endswith("==" + v)]
        if not cand:
            sys.exit("UNRESOLVED\n" + r.stderr[-2000:])
        changes.append(f"{cand[0]}: unpinned to resolve (was {pins[cand[0]].split('==')[1]})"); pins[cand[0]] = cand[0]
for round_ in range(25):
    resolve()
    r = subprocess.run(["uv", "pip", "install", "--python", envpy, "-r", lock], capture_output=True, text=True)
    if r.returncode == 0:
        print("installed after", round_, "rebuild rounds"); break
    m = re.search(r"Failed to build `([A-Za-z0-9_.\-]+)==([^`]+)`", r.stderr)
    if not m:
        sys.exit("INSTALL FAILED\n" + r.stderr[-2500:])
    n = m.group(1).lower()
    key = next((k for k in pins if k.lower() == n), n)
    changes.append(f"{key}: {m.group(2)} has no wheel for this Python and its source build fails; binary-only, newer version")
    nobuild.append(key); pins[key] = key
open(log, "w").write("\n".join(changes) + "\n")
print("\n".join(changes))
