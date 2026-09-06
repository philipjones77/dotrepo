# GitHub Copilot Repository Instructions

This repository is managed by dotrepo standards.

Before proposing changes:

- Read `README.md`.
- Read `AGENTS.md` when present.
- Read `CLAUDE.md` when present.
- Read `docs/ai/context.md` when present.
- Preserve existing architecture and naming conventions.
- Prefer small, reviewable changes.
- Keep secrets, tokens, private data, raw chat transcripts, and generated outputs
  out of git.

Validation:

- Use the repo's documented test commands.
- If a command is unavailable, say what was attempted and why it failed.
- For Python projects, prefer repo-local `pyproject.toml` dependency metadata.
- Do not invent global dependency pins when the project already owns them.

Pull requests should include:

- summary
- tests run
- risks
- follow-up work
- AI assistance note when relevant
