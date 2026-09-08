# Lint and Formatting Toolchain

This is the canonical tool policy for maintained Python and Markdown. Use the same configuration in
editors, local commands, and CI. Formatting does not establish scientific correctness, citation
existence, or safe intake; see [validation and evidence](validation.md).

## Install and Run

Python source targets Python 3.10 or newer. Use Python 3.12 or newer for the development tool
environment; the development tools and workflow dependencies are separate. No Node.js installation
is needed for this lint/format stack; the optional Pyright type checker has a separate Node
dependency.

From the repository root, on Windows:

```powershell
python -m venv .venv-lint
.venv-lint/Scripts/python.exe -m pip install -r tools/requirements-dev.txt
.venv-lint/Scripts/python.exe tools/lint_repo.py
.venv-lint/Scripts/python.exe tools/lint_repo.py --fix
```

On POSIX use `.venv-lint/bin/python` instead. The default command checks without editing. `--fix`
applies Ruff's safe fixes and both formatters; it does not enable unsafe fixes or automatically
repair Markdown lint failures. Review the diff and rerun the check after fixing remaining findings.

```powershell
.venv-lint/Scripts/python.exe tools/lint_repo.py --language python
.venv-lint/Scripts/python.exe tools/lint_repo.py --language markdown
.venv-lint/Scripts/python.exe tools/lint_repo.py --list-markdown
```

`tools/requirements-dev.txt` pins the direct tool versions. This is not a fully hashed transitive
dependency lock. Upgrade pins together in a reviewed change, run the checks and regression tests,
and review any changed formatting. CI uses the same entry point and installs these pins.

For the maintained regression tests as well as lint/type tools, use the combined environment
specification. It includes the bibliography, image, and intake dependencies; a lint-only install
does not supply these runtime packages.

```powershell
.venv-lint/Scripts/python.exe -m pip install -r tools/requirements-validation.txt
.venv-lint/Scripts/python.exe -m pip check
.venv-lint/Scripts/python.exe -m unittest discover -s tools/tests -v
```

This specification reuses existing workflow constraints; it is not a fully pinned runtime lock and
does not install external TeX, Java, or OCR executables. Optional legacy tools may require
additional dependencies. Install their requirements in the same resolver invocation if sharing this
environment, so their constraints are checked together.

## One Owner per Task

| Task                                      | Owner                   | Canonical configuration  |
| ----------------------------------------- | ----------------------- | ------------------------ |
| Python lint, imports, safe modernization  | Ruff check              | `pyproject.toml`         |
| Python formatting                         | Ruff format             | `pyproject.toml`         |
| Markdown formatting, including GFM tables | mdformat + mdformat-gfm | `.mdformat.toml`         |
| Markdown structure/style                  | PyMarkdown              | `.pymarkdown.json`       |
| Text encoding, indentation, newlines      | EditorConfig            | `.editorconfig`          |
| Local documentation file links            | Repository link checker | `tools/validate_docs.py` |

Do not run Black, isort, autopep8, YAPF, Prettier, markdownlint, or another overlapping formatter on
these files as part of the standard pipeline. Existing global editor installations can remain:
disable their format-on-save/code actions for this workspace and select Ruff for Python and mdformat
for Markdown. Do not disable a language server merely because it provides completion or type
diagnostics. Follow the [Pylance/Pyright policy](python-analysis.md): standard analysis by default,
strict paths by deliberate adoption. Type checking is not yet a repository-wide passing gate here.

Ruff enforces `E4`, `E7`, `E9`, `F`, `I`, `B`, and `UP`: core errors, undefined/unused names, import
ordering, common bug patterns, and modern Python syntax. Formatting uses 100 columns, four-space
Python indentation, double quotes, LF, and formatted Python docstring examples. Long indivisible
strings may exceed the formatter target; no blanket `E501` gate is claimed.

Markdown uses a 100-column wrapping target and stable existing ordered-list numbers. PyMarkdown
leaves line-length checking off because tables, URLs, and mathematical expressions need exceptions.
Inline HTML is allowed for established documentation constructs. Duplicate sibling headings are
prohibited; the same heading in different parent sections is allowed.

## Scope and Exclusions

Python checks run on `src/` and `tools/`. Ruff's normal exclusions plus `extend-exclude` in
`pyproject.toml` protect inboxes, status output, resources, virtual environments, historical cleaner
code (`tools/papers_cleanup/`, `tools/rgtools.py`), and examples/experiments/papers. These
exclusions do not imply that legacy code is safe, maintained, or behavior-tested. New maintained
code belongs in the checked trees. Code outside those trees is not silently covered by this command.

Markdown selection lives in `tools/lint_repo.py`: active prose under `docs/`, `src/`, `tools/`, and
`latex/`, plus the listed root/subsystem READMEs. Historical/status/inbox/legacy-cleaner trees are
excluded. Scientific definition and notation records, templates, external resources, and other
library contents are not automatically reformatted: mathematical syntax requires separate review.
The list command prints the actual current file scope. New `.md` files in selected trees are
included automatically.

Use the narrowest justified exception:

- Generated or third-party trees: add a named path exclusion with an ownership/reason comment; do
  not add `*.py` or `*.md` exclusions that hide maintained work.
- One Python line: `# noqa: RULECODE` with an adjacent reason, not an unqualified `# noqa`.
- A required file-wide exception: use `lint.per-file-ignores`. The TLS bootstrap scripts
  deliberately initialize native trust before importing requests; their import sorting is disabled.
  Existing CLI import bootstrap exceptions permit `E402` in the named automation/tool patterns, not
  everywhere.
- Layout-sensitive Markdown: use `<!-- mdformat off -->` and `<!-- mdformat on -->` around the
  smallest region. A formatter exception is not a linter exception.
- A necessary Markdown rule exception: use PyMarkdown's named-rule inline configuration, for example
  `<!-- pyml disable-next-line no-emphasis-as-heading -->`, with an explanatory comment. Do not
  globally disable a rule to accommodate one document.

Review exclusions when promoting legacy code; move it into maintained scope and add behavior tests
before claiming that promotion is complete. Formatting exemptions are not permission to skip
identity, data integrity, security, or numerical validation.

## Reuse in Another Repository

Copy the root tool configurations and `tools/requirements-dev.txt` from the same source revision.
Adapt path exclusions and the lint driver's file selection to the receiving repository; do not copy
our legacy exclusions unquestioningly. These files are included in source bundles. New asset
archives also carry [curated templates](tooling-assets.md) in `standards/tooling/`, but not an
installed development environment. Keep one authoritative config per tool rather than additional
conflicting package-level copies.

## Upstream References

- [Ruff configuration and exclusions](https://docs.astral.sh/ruff/configuration/)
- [mdformat configuration](https://mdformat.readthedocs.io/en/stable/users/configuration_file.html)
- [PyMarkdown user guide](https://pymarkdown.readthedocs.io/en/latest/user-guide/)

See [Python](python.md), [JAX](jax.md), and [Markdown](markdown.md) for conventions beyond
formatting.
