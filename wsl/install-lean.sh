#!/usr/bin/env bash
# Install Lean 4 in WSL with a Mathlib project and Claude Code / Codex integration.
# Idempotent: rerun to complete or repair a partial installation.
# Graphviz (for leanblueprint) needs sudo once:
#   sudo apt-get install -y graphviz libgraphviz-dev
set -euo pipefail

SANDBOX="${LEAN_SANDBOX:-$HOME/.local/src/lean/mathlib-sandbox}"
MCP_BIN="$HOME/.local/bin/lean-lsp-mcp"
export PATH="$HOME/.elan/bin:$HOME/.local/bin:$PATH"
log() { printf '\n== %s\n' "$*"; }

log "elan, Lean and Lake"
if ! command -v elan >/dev/null; then
  # --no-modify-path: shared/shell/env.sh already adds ~/.elan/bin, and the
  # shell startup files are repository symlinks.
  curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
    | sh -s -- -y --no-modify-path --default-toolchain stable
fi
elan --version
lean --version
lake --version

log "Mathlib project: $SANDBOX"
if [ ! -f "$SANDBOX/lakefile.toml" ] && [ ! -f "$SANDBOX/lakefile.lean" ]; then
  mkdir -p "$(dirname "$SANDBOX")"
  (cd "$(dirname "$SANDBOX")" && lake +leanprover-community/mathlib4:lean-toolchain new "$(basename "$SANDBOX")" math)
fi
(cd "$SANDBOX" && lake exe cache get && lake build)

log "VS Code extensions (WSL server): Lean 4, lakefile TOML, inline diagnostics"
server="$(ls -dt "$HOME"/.vscode-server/bin/*/bin/code-server 2>/dev/null | head -1 || true)"
if [ -n "$server" ]; then
  for ext in leanprover.lean4 tamasfe.even-better-toml usernamehw.errorlens; do "$server" --install-extension "$ext"; done
else
  echo "No VS Code server yet; open a WSL window and rerun."
fi

log "lean-lsp-mcp (MCP server for agents)"
uv tool install --upgrade lean-lsp-mcp
"$MCP_BIN" --help >/dev/null

log "Claude Code: MCP server and lean4 plugin"
if ! claude mcp get lean-lsp >/dev/null 2>&1; then
  claude mcp add --scope user lean-lsp -- "$MCP_BIN"
fi
claude plugin marketplace add cameronfreer/lean4-skills || true
claude plugin install lean4@lean4-skills || true

log "Codex: MCP server and lean4 plugin"
config="$HOME/.codex/config.toml"
mkdir -p "$(dirname "$config")"
if ! grep -q '^\[mcp_servers\.lean-lsp\]' "$config" 2>/dev/null; then
  cp -p "$config" "$config.bak-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true
  # Builds and first file loads can exceed the default timeouts.
  printf '\n[mcp_servers.lean-lsp]\ncommand = "%s"\nstartup_timeout_sec = 60\ntool_timeout_sec = 600\n' "$MCP_BIN" >> "$config"
fi
codex plugin marketplace add cameronfreer/lean4-skills --ref main || true
codex plugin add lean4@lean4-skills || true

log "leanblueprint"
if command -v dot >/dev/null && dpkg -s libgraphviz-dev >/dev/null 2>&1; then
  uv tool install --upgrade leanblueprint
else
  echo "Skipped: run 'sudo apt-get install -y graphviz libgraphviz-dev', then rerun."
fi

log "Done. Verify with: bash ~/.dotrepo/wsl/lean-maintain.sh check"
