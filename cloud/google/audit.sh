#!/usr/bin/env bash
set -euo pipefail

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

write_check() {
  printf '| google-cloud | %s | %s | %s |\n' "$1" "$2" "${3:-}"
}

printf '# Google Tooling Audit\n\n'
printf 'Generated: %s\n\n' "$(date -Is)"
printf '| Area | Check | Status | Detail |\n'
printf '| --- | --- | --- | --- |\n'

if ! has_cmd gcloud; then
  write_check "gcloud cli" "optional-missing" "Install Google Cloud CLI when Google Cloud profiles require it"
else
  write_check "gcloud cli" "ok" "$(gcloud --version 2>/dev/null | head -n 1 || true)"
  sdk_root="$(gcloud info --format='value(installation.sdk_root)' 2>/dev/null || true)"
  write_check "sdk root" "ok" "$sdk_root"

  account="$(gcloud config get-value account 2>/dev/null || true)"
  if [ -n "$account" ] && [ "$account" != "(unset)" ]; then
    write_check "active account" "ok" "configured"
  else
    write_check "active account" "missing" "run gcloud auth login or application-default login"
  fi

  project="$(gcloud config get-value project 2>/dev/null || true)"
  if [ -n "$project" ] && [ "$project" != "(unset)" ]; then
    write_check "active project" "ok" "$project"
  else
    write_check "active project" "manual-check" "no default project configured"
  fi
fi

if has_cmd gemini; then
  write_check "gemini cli" "legacy" "$(gemini --version 2>/dev/null | head -n 1 || true)"
else
  write_check "gemini cli" "legacy-missing" "Use Antigravity CLI for individual/free Google AI coding workflows"
fi

if has_cmd agy; then
  write_check "antigravity cli" "ok" "$(agy --version 2>/dev/null | head -n 1 || true)"
else
  write_check "antigravity cli" "missing" "Run cloud/google/install-antigravity.sh"
fi

if has_cmd npm; then
  write_check "npm" "ok" "$(npm --version 2>/dev/null | head -n 1 || true)"
elif [ -x "$HOME/miniforge3/envs/gemini-cli/bin/npm" ]; then
  write_check "npm" "ok" "$($HOME/miniforge3/envs/gemini-cli/bin/npm --version 2>/dev/null | head -n 1 || true) in gemini-cli env"
else
  write_check "npm" "optional-missing" "Required for npm-managed Gemini CLI installs"
fi

for dir in "$HOME/.gemini" "$HOME/.config/gemini"; do
  if [ -e "$dir" ]; then
    write_check "gemini state" "manual-check" "$dir"
  fi
done
