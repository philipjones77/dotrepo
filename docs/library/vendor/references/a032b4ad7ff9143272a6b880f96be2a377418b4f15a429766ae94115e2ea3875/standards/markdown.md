# Markdown Standards

These rules apply to Markdown documentation across this repository family.

Use mdformat for formatting and PyMarkdown for structural linting, configured by the
[shared toolchain](tooling.md). That document defines commands, scope, and narrow exclusions; do not
add a competing Markdown formatter.

## File Placement

- Put durable project documentation under `docs/`.
- Put package or subsystem usage notes in that subsystem's local `README.md`.
- Put standards in `docs/standards/`.
- Put day-to-day workflows in `docs/guides/`.
- Put migration trackers and current-state notes in `docs/status/`.

## Style

- Use one `#` heading per file.
- Use title case for top-level headings and short section headings.
- Keep line length reasonable for review, usually under 100 characters unless a table or URL makes
  that impractical.
- Use fenced code blocks with a language tag whenever possible.
- Use backticks for paths, commands, environment variables, field names, and file extensions.
- Prefer concise paragraphs over deeply nested bullet lists.
- Leave a blank line before and after headings, lists, and fenced blocks.
- Use ATX (`#`) headings, do not skip heading levels, and use `-` for bullets.
- Preserve mathematical notation; do not autoformat scientific record libraries without checking
  that TeX commands and delimiters are unchanged.

## Links

For rendered mathematics and web releases, follow [GitHub publishing](github-publishing.md). Its
Markdown math delimiters differ deliberately from the `.tex` source convention.

- Use relative links for repository-local documents.
- Update links in the same change that moves or renames a document.
- Link to the canonical standards document instead of repeating long rules.
- Do not use machine-local absolute paths in committed Markdown unless the file is explicitly
  documenting a local operator environment.

## Tables

Use tables for routing maps, command summaries, and file placement rules. Keep table cells short
enough to remain readable in plain text.

## Code Blocks

Use language tags:

````markdown
```powershell
python src/automation/biblatex/pdf_inbox_ingest.py --include-abstract
```
````

Recommended tags include:

- `powershell`
- `bash`
- `tex`
- `bibtex`
- `json`
- `yaml`
- `markdown`

## Dates

When a document has a `Last updated` line, use ISO date format:

```markdown
Last updated: 2026-06-22
```

Do not add a timestamp unless time-of-day matters.

## Generated Markdown

Generated Markdown reports should state that they are generated and identify the script or workflow
that produced them. Hand-authored standards should not be stored under generated report folders.
