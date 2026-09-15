#!/usr/bin/env sh
# Source installed repository-oracle settings. This file launches no runtimes.

if [ -f "$HOME/.local/opt/repo-oracles/ifj-env.sh" ]; then
  _dotrepo_source_ifj_oracles() {
    if [ -n "${ZSH_VERSION:-}" ]; then
      # The installed POSIX snippet uses optional unmatched Wolfram globs.
      # Scope sh semantics to this function, preserving the caller's options.
      emulate -L sh
    fi
    . "$HOME/.local/opt/repo-oracles/ifj-env.sh"
  }
  _dotrepo_source_ifj_oracles
  unset -f _dotrepo_source_ifj_oracles
fi

if [ -x "$HOME/.virtualenvs/uqpy312/bin/python" ]; then
  export RF77_UQPY_PYTHON="${RF77_UQPY_PYTHON:-$HOME/.virtualenvs/uqpy312/bin/python}"
fi

# mra-serial is usable standalone; RF77's binary protocol is not compatible yet.
# Keep RF77_MRA_BINARY an explicit caller choice until that bridge is reconciled.

if [ -x "$HOME/.virtualenvs/py313/bin/python" ]; then
  export RETICULATE_PYTHON="${RETICULATE_PYTHON:-$HOME/.virtualenvs/py313/bin/python}"
fi

if [ -d "$HOME/.cache/toposmpljax/private_data/models/validated" ]; then
  export TOPOSMPLJAX_SMPL_ROOT="${TOPOSMPLJAX_SMPL_ROOT:-$HOME/.cache/toposmpljax/private_data/models/validated}"
fi

if [ -d "$HOME/.local/state/dotrepo/repo-oracles-20260914/toposmpljax/private-smplx-compatibility-view" ]; then
  export SMPLX_MODEL_PATH="${SMPLX_MODEL_PATH:-$HOME/.local/state/dotrepo/repo-oracles-20260914/toposmpljax/private-smplx-compatibility-view}"
fi
