set -uo pipefail
unset PYTHONHOME PYTHONPATH PYTHONOPTIMIZE
build() {
  name=$1; py=$2; pinned=$3; extra=${4:-}
  echo "== $name: venv"; [ -x /home/phili/.local/share/dotrepo/environments/20261104/$name/bin/python ] || uv venv --seed --python $py /home/phili/.local/share/dotrepo/environments/20261104/$name
  echo "== $name: locked packages"; python3 /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/install_iter.py $pinned /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/$name-lock.txt $py /home/phili/.local/share/dotrepo/environments/20261104/$name/bin/python /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/$name-changes.txt || { echo "== $name: FAILED"; return 1; }
  echo "== $name: editable projects (declared dependencies added under the lock)"; uv pip install --python /home/phili/.local/share/dotrepo/environments/20261104/$name/bin/python --constraints /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/$name-lock.txt -e /home/phili/projects/arbPlusJAX -e /home/phili/projects/IntegralFunctionsJAX -e /home/phili/projects/TopoSmplJAX -e /home/phili/projects/RandomFields77
  if [ "$extra" = full ]; then
    echo "== $name: asdex and GS-LVMOGP"; uv pip install --python /home/phili/.local/share/dotrepo/environments/20261104/$name/bin/python --no-deps "asdex @ git+https://github.com/adrhill/asdex.git@da130b048b72c03e5ac1cb154968797bc32868b8" /home/phili/.local/state/dotrepo/rf77-oracles-20260914/wheels/gs_lvmogp_oracle-0.0.0+541d49aaf019-py3-none-any.whl
  fi
  echo "== $name: uv pip check"; uv pip check --python /home/phili/.local/share/dotrepo/environments/20261104/$name/bin/python 2>&1 | tail -15
  echo "== $name: done"
}
build py314 /home/phili/.local/share/uv/python/cpython-3.14.10-linux-x86_64-gnu/bin/python3.14 /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/py314-pinned.in full
build jax314 /home/phili/.local/share/uv/python/cpython-3.14.10-linux-x86_64-gnu/bin/python3.14 /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/jax31x-pinned.in
build jax315 /home/phili/.local/share/uv/python/cpython-3.15.2-linux-x86_64-gnu/bin/python3.15 /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/jax315-pinned.in
echo ALL-BUILT
