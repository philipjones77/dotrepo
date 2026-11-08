# Lean 4 in WSL with Claude Code and Codex

Lean is used inside Ubuntu (WSL) on both PCs. Native Windows has no Lean
toolchain; Windows VS Code reaches it through Remote-WSL windows.

## What gets installed

| Component | Where | Purpose |
| --- | --- | --- |
| elan, Lean, Lake | `~/.elan` (PATH from `shared/shell/env.sh`) | Toolchain manager, compiler, build tool |
| Mathlib sandbox | `~/.local/src/lean/mathlib-sandbox` | Ready project with the prebuilt Mathlib cache (~5 GB) |
| `leanprover.lean4` | WSL VS Code server | Infoview, goals, diagnostics in the editor |
| [`lean-lsp-mcp`](https://github.com/oOo0oOo/lean-lsp-mcp) | `uv tool`, `~/.local/bin/lean-lsp-mcp` | MCP server: goals, diagnostics, hover, builds, Loogle/LeanSearch |
| [`lean4-skills`](https://github.com/cameronfreer/lean4-skills) plugin | Claude Code and Codex (user scope) | Proving workflows: `/lean4:prove`, `formalize`, `review`, `golf`, ... |
| `leanblueprint` | `uv tool` | Blueprint documents for formalization projects (needs Graphviz) |

Install or repair (idempotent), from WSL:

```bash
sudo apt-get install -y graphviz libgraphviz-dev   # once; needed by leanblueprint
bash ~/.dotrepo/wsl/install-lean.sh
```

Check or update:

```bash
bash ~/.dotrepo/wsl/lean-maintain.sh check    # versions + Mathlib proof smoke test
bash ~/.dotrepo/wsl/lean-maintain.sh update   # elan, toolchains, MCP, plugins, sandbox Mathlib
```

## Using it with the agents

- **Claude Code** (WSL CLI or the VS Code extension in a WSL window): the
  `lean-lsp` MCP server is registered at user scope, so it works in any Lean
  project. The `lean4` plugin adds `/lean4:*` commands; start with
  `/lean4:prove` or `/lean4:formalize` inside a Lake project.
- **Codex** (WSL CLI or the VS Code extension in a WSL window): the same MCP
  server is in `~/.codex/config.toml` as `[mcp_servers.lean-lsp]`, with a
  600 s tool timeout for builds. The `lean4` plugin provides the skill and
  hooks; slash commands are not fully mirrored, so ask in plain language
  ("prove `foo` using the lean4 skill").
- **ChatGPT web/desktop chat** cannot reach a local MCP server. The official
  route is OpenAI's Secure MCP Tunnel (Platform API key required; see the
  lean-lsp-mcp README). Use Codex for local Lean work.

Agents should open the project folder (where `lakefile.toml` is) and build
once with `lake build` before asking for proofs; the MCP server otherwise
times out on the first load.

Remote search tools are rate-limited (`loogle` 3 requests / 30 s). Set
`LEAN_LOOGLE_LOCAL=true` for a local Loogle index if this becomes a problem.

## New projects

```bash
cd ~/.local/src/lean
lake +leanprover-community/mathlib4:lean-toolchain new my-project math
cd my-project && lake exe cache get && lake build
```

Each Mathlib project downloads its own cache (several GB). Prefer adding new
files to an existing project for experiments.

## Third-party code

`lean4-skills` installs hooks that run automatically in Claude Code and Codex,
and `lean-lsp-mcp` runs as a local process with file access. Both are
community projects; review their changes before `lean-maintain.sh update`
if that matters for a given session.
