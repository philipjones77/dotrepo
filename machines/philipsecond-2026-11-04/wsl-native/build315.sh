set -uo pipefail
unset PYTHONHOME PYTHONPATH PYTHONOPTIMIZE
[ -x /home/phili/.local/share/dotrepo/environments/20261104/jax315/bin/python ] || uv venv --seed --python /home/phili/.local/share/uv/python/cpython-3.15.2-linux-x86_64-gnu/bin/python3.15 /home/phili/.local/share/dotrepo/environments/20261104/jax315
python3 /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/install_iter.py /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/jax315-pinned.in /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/jax315-lock.txt /home/phili/.local/share/uv/python/cpython-3.15.2-linux-x86_64-gnu/bin/python3.15 /home/phili/.local/share/dotrepo/environments/20261104/jax315/bin/python /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/jax315-changes.txt || exit 1
uv pip install --python /home/phili/.local/share/dotrepo/environments/20261104/jax315/bin/python --constraints /tmp/claude-1001/-home-phili/2e5e786a-76bd-426d-ba04-0120560f3b9a/scratchpad/py314/jax315-lock.txt -e /home/phili/projects/arbPlusJAX -e /home/phili/projects/IntegralFunctionsJAX -e /home/phili/projects/TopoSmplJAX
uv pip check --python /home/phili/.local/share/dotrepo/environments/20261104/jax315/bin/python 2>&1 | tail -6
echo JAX315-BUILT
