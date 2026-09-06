# AI Session Methodology

This methodology is for working across two Windows machines, WSL Ubuntu on both
machines, Codex, Claude Code, Claude.ai web, ChatGPT web, GitHub, and project
repos such as `arbplusJAX`, `data77`, `IntegralFunctionsJAX`, `RandomFields77`,
and `TopoSmplJAX`.

The core rule is simple: do not try to sync proprietary chat history. Sync the
portable context and outcomes through git.

## Operating Model

Use three layers of context.

1. Durable repo context: committed files that every coding agent and web chat
   can read.
2. Session capsules: compact summaries of active work that move between
   machines, web chats, and coding agents.
3. Private/local context: secrets, private paths, account details, unpublished
   data, and temporary transcripts that should not be committed.

The durable context lives in the project repo. dotrepo owns the templates,
audits, and setup scripts that keep the pattern consistent.

## What Gets Stored Where

### Commit To Project Repos

Use these files in each serious project:

```text
AGENTS.md
CLAUDE.md
docs/ai/context.md
docs/ai/sessions/YYYY-MM-DD-topic.md
docs/ai/prompts/
docs/decisions/
```

`AGENTS.md` is the canonical Codex startup file. OpenAI documents `AGENTS.md` as
the repo-specific instruction file Codex reads before work.

`CLAUDE.md` is the Claude Code equivalent for durable project memory. Anthropic
documents `CLAUDE.md` files as persistent instructions loaded at the start of
Claude Code sessions.

`docs/ai/context.md` is the short project brief for web tools. It should be safe
to paste into ChatGPT or Claude.ai.

`docs/ai/sessions/*.md` are session capsules. They are not full transcripts.
They capture the state needed to resume work.

`docs/ai/prompts/` stores reusable prompts for planning, reviews, research, and
handoffs.

`docs/decisions/` stores durable architectural decisions. When an AI chat makes
a real decision, promote it out of the chat and into this folder.

### Keep Local Only

Do not commit:

- raw chat exports
- private datasets
- API keys
- tokens
- `.env` files
- `.claude/settings.local.json`
- full transcripts containing private or irrelevant material
- machine-specific absolute paths unless they are examples

Use `.local/ai/`, `.ai-private/`, or another ignored folder for local scratch.

## Session Capsule

A session capsule is the handoff object. It is short enough to paste into a web
chat and concrete enough for Codex or Claude Code to resume in the repo.

It should contain:

- repo and branch
- machine and environment
- goal
- current status
- files changed
- commands run
- tests passed or failed
- decisions made
- blockers
- next steps
- exact prompt to resume
- links to relevant GitHub issues, PRs, or shareable chat snapshots

Use `agents/session/session-capsule.template.md`.

## Web Chat Workflow

Use ChatGPT web and Claude.ai web for high-context reasoning that does not need
direct filesystem access:

- architecture review
- research synthesis
- comparing design alternatives
- explaining unfamiliar math or library behavior
- drafting docs
- generating test plans
- reading PDFs or uploaded project context packs

Do not use web chat as the place where final engineering state lives. Anything
useful must be converted into one of:

- a code patch applied locally
- an issue or PR comment
- an ADR under `docs/decisions/`
- an update to `AGENTS.md`, `CLAUDE.md`, or `docs/ai/context.md`
- a new session capsule

## ChatGPT Project Setup

For each major repo, create a ChatGPT Project named after the repo.

Project knowledge should include:

- `README.md`
- `AGENTS.md`
- `docs/ai/context.md`
- selected architecture docs
- selected decision records
- current session capsule when needed

Project instructions should be generated from
`agents/web/chatgpt-project-instructions.template.md`.

Use ChatGPT Projects as a live context hub, but refresh uploaded files when the
repo changes materially. OpenAI documents ChatGPT Projects as a project space
that can keep chats, files, and instructions together.

## Claude.ai Project Setup

For each major repo, create a Claude Project named after the repo.

Project knowledge should include:

- `README.md`
- `AGENTS.md`
- `CLAUDE.md`
- `docs/ai/context.md`
- selected architecture docs
- selected decision records
- current session capsule when needed

Project instructions should be generated from
`agents/web/claude-project-instructions.template.md`.

Anthropic documents Claude Projects as self-contained workspaces with chat
histories, knowledge bases, uploaded context, and project instructions.

## Moving Work Between Tools

### Codex Or Claude Code To Web

At the end of a meaningful local coding session:

1. Create or update `docs/ai/sessions/YYYY-MM-DD-topic.md`.
2. Include the exact files changed and verification commands.
3. Paste the capsule into ChatGPT or Claude.ai when asking for review or
   planning.
4. Ask for specific output: risk list, missing tests, patch sketch, docs draft,
   or decision memo.

### Web To Codex Or Claude Code

When web chat produces useful work:

1. Ask it to emit one of:
   - a unified diff
   - a file-by-file change plan
   - an ADR
   - a test plan
   - a session capsule
2. Paste that into Codex or Claude Code.
3. Apply changes in the repo.
4. Run the relevant tests locally.
5. Commit durable context and code, not raw chat transcript.

### Machine To Machine

To move from one machine to another:

1. Commit or stash useful repo changes.
2. Commit the latest session capsule if it is safe and durable.
3. Push the branch.
4. Pull on the other machine.
5. Start the next agent/web chat with the session capsule and current branch.

If the capsule contains private material, store it in a private notes location
and paste it manually instead of committing it.

## GitHub Integration

GitHub should be the shared public state for active engineering work.

Use issues for work items:

- problem statement
- acceptance criteria
- links to session capsules
- relevant decisions

Use PRs for implementation state:

- summary
- test commands
- risk notes
- follow-up checklist

Use comments to preserve useful web-review output. Do not paste long raw
transcripts; summarize the decision and link to a shareable snapshot only when
it is appropriate.

## Memory And Exports

Use memory features cautiously.

Good memory:

- preferred response style
- stable project preferences
- recurring commands
- durable constraints that are not secrets

Bad memory:

- secrets
- one-off temporary facts
- uncertain debugging guesses
- private path details that will confuse another machine

Both ChatGPT and Claude provide web-side project or memory features. Treat
exports as backup or migration material, not as the active source of truth. The
source of truth is the repo plus GitHub.

## Updating The Repo From Sessions

At the end of any valuable AI session, run this checklist:

1. Did we change code? Commit or record why not.
2. Did we learn a durable repo rule? Update `AGENTS.md` or `CLAUDE.md`.
3. Did we make an architecture decision? Add an ADR.
4. Did we define a repeatable prompt? Save it under `docs/ai/prompts/`.
5. Is work unfinished? Update the session capsule.
6. Did a web chat produce a useful result? Convert it into repo text, issue text,
   or code.

## dotrepo Responsibilities

dotrepo should provide:

- templates for `AGENTS.md`, `CLAUDE.md`, web project instructions, and session
  capsules
- scripts to audit whether each project has the required AI context files
- scripts to build a safe `web-context-pack.md` from selected repo files
- optional local-only folders for raw exports
- documentation for using ChatGPT and Claude web projects consistently

## Near-Term Implementation

1. Add templates under `agents/session/` and `agents/web/`.
2. Add project audit checks for:
   - `AGENTS.md`
   - `CLAUDE.md`
   - `docs/ai/context.md`
   - `docs/ai/sessions/`
   - `.claude/settings.json`
   - `.claude/settings.local.json` ignored or absent from git
3. Add a script that builds `web-context-pack.md` from safe project files.
4. Apply check-only audits to the five sample repos.
5. Only after review, write missing files into each project.

## Sources

- OpenAI Help Center: https://help.openai.com/en/articles/10169521-projects-in-chatgpt
- OpenAI Developers: https://developers.openai.com/codex/guides/agents-md
- Anthropic Help Center: https://support.claude.com/en/articles/9517075-what-are-projects
- Claude Code Docs: https://code.claude.com/docs/en/memory
- Anthropic Help Center: https://support.claude.com/en/articles/12123587-import-and-export-your-memory-from-claude
