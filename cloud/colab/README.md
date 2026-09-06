# Colab Standard

Colab is an execution environment, not a source of truth. Source code, setup
commands, and notebooks should live in the project repo and be verified from a
fresh Colab runtime.

Each Colab-capable project should provide:

```text
tools/colab_bootstrap.py
examples/colab/
docs/cloud/colab.md
```

Minimum checks:

- clone or install the project from GitHub
- install declared extras
- verify Python version
- verify JAX import when the project uses JAX
- report CPU/GPU/TPU backend
- run one smoke example

The bootstrap must not require secrets, private local paths, or checked-in
credentials.
