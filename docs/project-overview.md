# dotrepo Project Overview

dotrepo is the control repo for personal development operations across machines,
operating environments, AI tools, GitHub, and related code repositories.

It is not only a dotfiles repo. It should become the place that defines:

- how Windows and WSL machines are bootstrapped
- how related repositories are discovered, audited, repaired, committed, and
  pushed
- how Codex, Claude Code, Claude.ai, ChatGPT, GitHub Copilot, and GitHub should
  be used together
- how project documentation, standards, and startup knowledge are stored
- how optional tools such as Mathematica, CUDA, TeX, Git LFS, and build
  toolchains are detected and used
- how Google Colab, Google Cloud, Docker, and containers are used for portable
  execution
- how work moves between machines without losing context

## Purpose

The purpose of dotrepo is to make the development environment reproducible and
the engineering workflow coherent.

The desired outcome is that any machine can answer:

- What repositories exist and how do they relate?
- What tools should be installed?
- Which tools are optional?
- What standards apply to this project?
- What should AI tools read before changing code?
- What GitHub workflows, templates, and review rules should exist?
- What changed in another repo, and is it safe to commit and push?
- Can this project run locally, in Colab, in Docker, or on Google Cloud?

## Scope

dotrepo owns shared setup and standards. Individual project repos own their
runtime code, package metadata, tests, and project-specific documentation.

dotrepo may create or update standard files in related repos when explicitly
run through its project management scripts. Examples:

- `AGENTS.md`
- `CLAUDE.md`
- `.github/copilot-instructions.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/CODEOWNERS`
- `.github/workflows/*.yml`
- `.vscode/settings.json`
- `.dockerignore`
- `docker/*`
- `docs/cloud/*`
- `docs/ai/context.md`
- `docs/ai/sessions/*.md`
- `docs/decisions/*.md`

dotrepo should not own:

- project source code design that belongs inside a project repo
- project dependencies that belong in `pyproject.toml`, lock files, or
  repo-local environment files
- secrets, tokens, raw chat transcripts, private keys, private datasets, or
  generated outputs
- unreviewed mass rewrites across repositories

## Related Repositories

The initial managed repo set is:

- `arbplusJAX`
- `data77`
- `IntegralFunctionsJAX`
- `RandomFields77`
- `TopoSmplJAX`

The future inventory should record, for each repo:

- canonical name
- Windows path
- WSL path
- GitHub remote
- main branch
- package profile
- AI context profile
- GitHub workflow profile
- optional tools
- sibling dependencies
- documentation entry points
- preferred test commands

## AI Tool Roles

### Codex

Use Codex for local repo work:

- inspect code
- edit files
- run tests
- update docs
- manage branches
- prepare commits and PRs

Codex should read `AGENTS.md` and repo-local docs before substantial changes.

### Claude Code

Use Claude Code similarly for local coding work, especially when its tooling is
active in a repo. Claude Code should read `CLAUDE.md` and project docs.

### ChatGPT Web

Use ChatGPT web for planning, synthesis, architecture review, research, prompt
development, and high-context discussion. Use ChatGPT Projects to group repo
knowledge, instructions, and related chats.

ChatGPT web should produce durable artifacts: patch plans, decision records,
test plans, or session capsules.

### Claude.ai Web

Use Claude.ai web for deep document review, long-form reasoning, architecture
alternatives, standards drafting, and session review. Use Claude Projects to
group repo knowledge and instructions.

Claude.ai web should produce durable artifacts, not become the only place where
important decisions live.

### GitHub Copilot

Use GitHub Copilot inside GitHub and IDEs for local assistance, review help, and
incremental code suggestions. Repository instructions should live in
`.github/copilot-instructions.md` so Copilot has project-specific build, test,
and validation context.

### GitHub

Use GitHub as the durable collaboration and automation layer:

- issues define work
- branches isolate changes
- PRs explain implementation and verification
- CODEOWNERS and review rules route review
- Actions run validation
- releases publish packages or milestones

### Google Colab

Use Google Colab for clean-runtime notebooks, quick GPU/TPU checks, and public
examples. Colab setup should be scripted so a notebook can run from a fresh
runtime without hidden local state.

### Google Cloud And Docker

Use Docker and Google Cloud for reproducible CPU/GPU runs, benchmark sweeps, and
longer jobs. Docker should support local WSL workflows first, then cloud
execution. Google Cloud secrets and service-account keys must stay outside git.

## Cross-Repo Authority Model

dotrepo may correct other repos only through explicit project management
commands.

Required safeguards:

1. Discover the repo from `projects/inventory.yml`.
2. Run an audit before writing.
3. Show planned file changes.
4. Write only managed files or managed blocks unless a task explicitly allows
   broader edits.
5. Run the repo's configured verification commands.
6. Commit with a clear message naming dotrepo as the source of the standard.
7. Push only when the command or user request explicitly asks for push.

Default mode should be check-only. Write, commit, and push should be separate
flags or commands.

## Documentation Model

Each managed project should have:

```text
README.md
AGENTS.md
CLAUDE.md
.github/copilot-instructions.md
.dockerignore
docker/
docs/cloud/
docs/ai/context.md
docs/ai/sessions/
docs/decisions/
docs/standards/
```

dotrepo owns templates and audits for these files. Project repos own the
project-specific content.

## Success Criteria

dotrepo is useful when:

- a new machine can be audited and bootstrapped predictably
- a project repo can be audited for missing AI, GitHub, Python, and docs
  standards
- web AI sessions can be resumed from session capsules instead of lost chat
  history
- GitHub issues and PRs contain the durable engineering state
- project standards are consistent without erasing project-specific differences
- cross-repo changes are reviewable, testable, commit-ready, and pushable
