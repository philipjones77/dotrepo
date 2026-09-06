# Startup Knowledge

This file defines what humans and AI tools should read first when working in
dotrepo.

## First Read

Read these files in order:

1. `README.md`
2. `docs/project-overview.md`
3. `docs/usefulness-plan.md`
4. `docs/ai-session-methodology.md`
5. `docs/ai-github-standards.md`
6. `docs/cloud-container-standards.md`
7. `docs/machine-environment-setup.md`
8. `status/setup-status.md`
9. `docs/related-repos.md`

## dotrepo Rules

- Treat dotrepo as the source for shared setup, standards, templates, and audits.
- Keep project-specific runtime code and dependency truth in the project repos.
- Keep secrets and raw transcripts out of git.
- Use check-only audits before writing into other repos.
- Separate write, commit, and push steps unless the user explicitly requests the
  full sequence.
- Prefer managed files and managed blocks for cross-repo updates.
- Preserve project-specific differences; standardize policy and structure, not
  every implementation detail.
- Treat Docker, Colab, and Google Cloud as explicit project capabilities, not
  assumptions.
- Record setup capability status in `status/setup-status.md` and keep generated
  machine-specific audit reports local unless sanitized.

## Cross-Repo Work Startup

Before modifying another repo from dotrepo:

1. Identify the repo in `docs/related-repos.md` or `projects/inventory.yml`.
2. Check git status in dotrepo and the target repo.
3. Read the target repo's `AGENTS.md`, `CLAUDE.md`, and README if present.
4. Run the dotrepo audit in check-only mode when available.
5. Apply only the intended standard/template changes.
6. Run target repo verification.
7. Show the diff.
8. Commit and push only when explicitly requested.

## Web AI Startup

For ChatGPT or Claude.ai:

1. Open the repo's web project.
2. Upload or refresh safe project context files.
3. Paste the latest session capsule for active work.
4. Ask for a concrete artifact: review findings, patch plan, ADR, test plan, or
   handoff prompt.
5. Promote useful output back into git or GitHub.

## GitHub Startup

For GitHub work:

1. Check the relevant issue or PR.
2. Confirm branch and base branch.
3. Review CI status.
4. Confirm PR template fields are complete.
5. Add session-capsule or decision links when useful.
6. Use GitHub Copilot instructions for repo-aware Copilot behavior.
