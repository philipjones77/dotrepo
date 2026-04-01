#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
packages_file="${repo_root}/node/global-packages.txt"

if ! command -v npm >/dev/null 2>&1; then
  printf '[dotrepo] npm not found; skipping global package install\n'
  exit 0
fi

mapfile -t packages < <(grep -Ev '^\s*(#|$)' "$packages_file" || true)

if [ "${#packages[@]}" -eq 0 ]; then
  printf '[dotrepo] No tracked global npm packages to install\n'
  exit 0
fi

npm install -g "${packages[@]}"
