# Tooling Templates in Assets

New asset bundles include `standards/tooling/` alongside the policy documents. The templates are
copied from maintained source files and covered by manifest hashes. Older releases may omit them. No
new top-level asset namespace is used.

Start at `standards/README.md`. Merge `pyproject.example.toml` into the consumer's root
`pyproject.toml`; do not replace existing project metadata. Review the Python version, include
paths, import paths and exclusions for the actual consumer. The references library's legacy
exclusions are not universal defaults.

Merge `.editorconfig`, `.mdformat.toml` and `.pymarkdown.json` at the consumer root. Merge
`editor-settings.example.json` into its `.vscode/settings.json`. Select that project's interpreter
separately; no personal interpreter path, installed environment or VS Code state is shipped.

Place `requirements-dev.txt`, `requirements-types.txt` and, if appropriate, `lint_repo.py` in the
consumer's `tools/` directory. Review the lint driver's Python roots and Markdown selection before
using it. Its root calculation assumes that location; it is a reference implementation, not an
automatic installer. Install lint dependencies in the consumer's native environment. Pyright also
requires Node and the consumer's runtime dependencies; these are not packaged. The library-specific
combined validation requirements are deliberately not presented as a universal environment for other
repositories.

Record the asset revision, manifest digest, adopted rules, local configuration paths and any
justified differences. Run lint, type analysis and the consumer's tests before claiming adoption is
validated. Do not edit the vendored templates silently or run automatic configuration replacement
during a document build.
