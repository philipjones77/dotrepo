#!/usr/bin/env bash
# Check or update the WSL Lean setup created by install-lean.sh.
#   lean-maintain.sh check    report versions and run a Mathlib proof smoke test
#   lean-maintain.sh update   update elan, toolchains, agent tools and the sandbox's Mathlib
set -euo pipefail

SANDBOX="${LEAN_SANDBOX:-$HOME/.local/src/lean/mathlib-sandbox}"
export PATH="$HOME/.elan/bin:$HOME/.local/bin:$PATH"
failures=0
check() { local name="$1"; shift; if out="$("$@" 2>&1)"; then printf 'ok    %-22s %s\n' "$name" "$(head -1 <<<"$out")"; else printf 'FAIL  %-22s %s\n' "$name" "$(tail -1 <<<"$out")"; failures=$((failures + 1)); fi; }

case "${1:-check}" in
  update)
    elan self update
    elan toolchain update stable 2>/dev/null || elan update
    uv tool upgrade lean-lsp-mcp
    command -v leanblueprint >/dev/null && uv tool upgrade leanblueprint
    claude plugin marketplace update lean4-skills 2>/dev/null || true
    codex plugin marketplace upgrade lean4-skills 2>/dev/null || true
    # Mathlib pins its own toolchain; lake update moves both together.
    (cd "$SANDBOX" && lake update && lake exe cache get && lake build)
    ;;
  check) ;;
  *) echo "Usage: $0 [check|update]" >&2; exit 2 ;;
esac

check elan elan --version
check lean lean --version
check lake lake --version
check sandbox-toolchain cat "$SANDBOX/lean-toolchain"
check mathlib-proof sh -c "cd '$SANDBOX' && printf 'import Mathlib\nexample (a b : ℕ) : a + b = b + a := by omega\nexample (x : ℝ) : 0 ≤ x ^ 2 := by positivity\n' > /tmp/lean-smoke.lean && lake env lean /tmp/lean-smoke.lean && echo 'Mathlib proofs checked'"
check lean-lsp-mcp sh -c "'$HOME/.local/bin/lean-lsp-mcp' --help >/dev/null && uv tool list | grep '^lean-lsp-mcp'"
check claude-mcp claude mcp get lean-lsp
check claude-plugin sh -c "claude plugin list 2>/dev/null | grep -i lean4"
check codex-mcp grep -A1 '^\[mcp_servers\.lean-lsp\]' "$HOME/.codex/config.toml"
check codex-plugin sh -c "codex plugin list 2>/dev/null | grep -i lean4"
check vscode-lean4 sh -c "ls -d $HOME/.vscode-server/extensions/leanprover.lean4-*"
check leanblueprint sh -c "command -v leanblueprint"
exit $((failures > 0))
