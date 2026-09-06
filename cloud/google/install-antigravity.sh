#!/usr/bin/env bash
set -euo pipefail

install_script="${DOTREPO_ANTIGRAVITY_INSTALL_SCRIPT:-https://antigravity.google/cli/install.sh}"

curl -fsSL "$install_script" | bash

if ! command -v agy >/dev/null 2>&1; then
  echo "Antigravity CLI was installed, but agy is not on PATH" >&2
  echo "Ensure \$HOME/.local/bin is on PATH, then restart the shell." >&2
  exit 1
fi

agy --version
