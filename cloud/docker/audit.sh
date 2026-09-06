#!/usr/bin/env bash
set -euo pipefail

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

write_check() {
  printf '| docker | %s | %s | %s |\n' "$1" "$2" "${3:-}"
}

printf '# Docker Audit\n\n'
printf 'Generated: %s\n\n' "$(date -Is)"
printf '| Area | Check | Status | Detail |\n'
printf '| --- | --- | --- | --- |\n'

if has_cmd docker; then
  write_check "docker cli" "ok" "$(docker --version 2>/dev/null | head -n 1 || true)"
  write_check "docker compose" "manual-check" "$(docker compose version 2>/dev/null | head -n 1 || true)"
  if docker info --format '{{.ServerVersion}}' >/tmp/dotrepo-docker-version.$$ 2>/dev/null; then
    write_check "docker daemon" "ok" "server $(cat /tmp/dotrepo-docker-version.$$)"
  else
    write_check "docker daemon" "missing" "docker cli exists, daemon unavailable"
  fi
  rm -f /tmp/dotrepo-docker-version.$$
else
  write_check "docker cli" "optional-missing" "Install Docker Desktop/Engine when container profiles require it"
fi

if has_cmd nvidia-smi; then
  write_check "nvidia gpu" "ok" "$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -n 1 || true)"
else
  write_check "nvidia gpu" "optional-missing" "Needed only for CUDA/GPU container profiles"
fi
