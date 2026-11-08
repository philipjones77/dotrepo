#!/usr/bin/env sh
# Machine defaults only; preserve an explicitly activated environment.
if [ -x "$HOME/.virtualenvs/py314/bin/python" ]; then
  if [ -z "${VIRTUAL_ENV:-}" ]; then
    case ":$PATH:" in
      *":$HOME/.virtualenvs/py314/bin:"*) ;;
      *) PATH="$HOME/.virtualenvs/py314/bin:$PATH" ;;
    esac
    export PATH
  fi
  export UV_PYTHON="${UV_PYTHON:-${VIRTUAL_ENV:-$HOME/.virtualenvs/py314}/bin/python}"
  export PIPX_DEFAULT_PYTHON="${PIPX_DEFAULT_PYTHON:-$HOME/.virtualenvs/py314/bin/python}"
  export RETICULATE_PYTHON="${RETICULATE_PYTHON:-$HOME/.virtualenvs/py314/bin/python}"
fi
if [ -x "$HOME/.virtualenvs/jax314/bin/python" ]; then
  export IFJ_PYTHON="${IFJ_PYTHON:-$HOME/.virtualenvs/jax314/bin/python}"
  export ARBPLUSJAX_PYTHON="${ARBPLUSJAX_PYTHON:-$HOME/.virtualenvs/jax314/bin/python}"
fi
# Allocate GPU memory on demand on this shared WSL workstation.
export XLA_PYTHON_CLIENT_PREALLOCATE="${XLA_PYTHON_CLIENT_PREALLOCATE:-false}"

# Prefer a machine-selected toolkit; otherwise detect the pip CUDA 13 toolkit.
# Set DOTREPO_CUDA_HOME in shell.local.sh for CUDA 12 or a system toolkit.
_dotrepo_cuda_home="${DOTREPO_CUDA_HOME:-${CUDA_HOME:-$HOME/.virtualenvs/py314/lib/python3.14/site-packages/nvidia/cu13}}"
if [ -x "$_dotrepo_cuda_home/bin/nvcc" ]; then
  export CUDA_HOME="$_dotrepo_cuda_home"
  export CUDA_PATH="$CUDA_HOME"
  case ":$PATH:" in
    *":$CUDA_HOME/bin:"*) ;;
    *) export PATH="$CUDA_HOME/bin:$PATH" ;;
  esac
fi
unset _dotrepo_cuda_home
