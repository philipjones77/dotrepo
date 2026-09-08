# Python Analysis: Pylance and Pyright

This is our reusable policy for Python repositories. It defines the target standard; this change
configures the references repository only, not other checkouts.

## Decision

**Standardize Pylance; do not ignore it globally.** Use the same analysis policy in editor and CLI,
but distinguish a diagnostic from a release gate. An editor warning is a finding to classify, not
automatic permission to change working code.

- Use Pylance for Python completion and type diagnostics in supported VS Code installations.
- Use Pyright CLI for reproducible type checks outside the editor, including CI.
- Use Ruff for lint, import organization, and formatting. Do not enable competing Python language
  servers or overlapping formatting providers in the same workspace.
- Default to `standard` type checking. Promote new reusable typed modules to named `strict` paths
  once dependencies, annotations, and tests support it. Do not silently downgrade a strict project.
- Keep shared analysis rules in `[tool.pyright]` in `pyproject.toml`. Avoid also maintaining
  `pyrightconfig.json`, which takes precedence. Editor settings own editor behavior, not a second
  conflicting ruleset.

Pylance and Pyright share an analysis engine but releases and features can differ. Pin the CLI and
record the editor version when investigating disagreements. Pylance is not the headless CI tool; use
Pyright in environments where Pylance is unsupported. See Microsoft's
[Pylance/Pyright guidance](https://github.com/microsoft/pylance-release/blob/main/USING_WITH_PYRIGHT.md).

## Per-Repository Configuration

Set the supported minimum Python version, actual maintained source/test roots, and narrowly scoped
exclusions. Choose the project's installed interpreter in VS Code; never commit personal absolute
interpreter paths. CI must install the relevant dependencies and use the intended environment. Use
`extraPaths` only for real import roots; prefer installable packages for new reusable code. Exclude
generated outputs, caches, vendored material, and explicitly unmaintained legacy tools. An excluded
module may still be analyzed when imported by included code.

Keep `reportUnnecessaryTypeIgnoreComment = "warning"` and `enableTypeIgnoreComments = false`. Use a
rule-specific `# pyright: ignore[ruleName]` with an explanation only for a verified limitation;
prefer fixing the annotation, narrowing values, or adding a tested local stub. Do not suppress
missing imports globally, replace unknown types with `Any` wholesale, or cast merely to hide errors.
See the
[configuration reference](https://github.com/microsoft/pyright/blob/main/docs/configuration.md).

For JAX, annotate public array interfaces and document shape/dtype contracts, but test transformed
behavior and numerical properties separately. Static types do not establish shape correctness,
reproducibility, device behavior, or scientific validity. See [JAX](jax.md).

## Editor Setup

Ruff owns Python formatting and import fixes. The shared editor example disables generic and isort
save actions and enables only Ruff's named actions. Other formatters may remain installed for other
workspaces; disable conflicting workspace providers rather than uninstalling tools globally.

### Enforcement and Exceptions

Ruff lint, Ruff formatting, Markdown checks and regression tests are required checks for their
maintained scope. Pyright currently remains a visible diagnostic inventory in this references
repository until its existing errors are resolved; do not call it a passing gate. Review changed
code for new diagnostics and save full-scope reports during migration. A clean consumer should
require its Pyright check immediately, rather than inherit this repository's historical debt.

Classify findings in this order: wrong interpreter/dependencies; real runtime import roots; genuine
code/type errors; third-party typing limitations; generated or unmaintained code. Correct the first
three. Use only narrowly documented exceptions for the last two. Disabling all type checking,
silencing missing imports globally, or reducing to `basic` merely to obtain green output is not the
baseline. Temporary `openFilesOnly` is an editor-performance exception, not a replacement for full
CLI checks. Strict typing is opt-in for reviewed modules; runtime, numerical and JAX transformation
tests remain necessary.

Merge [the portable settings example](../../tools/editor-settings.example.json) into workspace
settings without overwriting existing project choices. Install the Microsoft Python/Pylance and Ruff
extensions. Select the project interpreter separately. Use workspace diagnostics and default
language-server mode normally. A large repository may use `openFilesOnly` for responsiveness, but
must retain a full CLI check; unopened files have not thereby passed validation.

## Commands and Adoption

### References Repository Interpreter

The references checkout uses `.venv-lint` as its default editor environment. Its folder-relative
setting and environment discovery paths live once in `.vscode/settings.json`;
`references.code-workspace` does not override them. The folder setting allows Windows and POSIX
checkouts to use their own native environment. Create it using the [tooling setup](tooling.md)
before selecting it. It contains development tools, not necessarily every optional workflow
dependency; install the requirements for the workflow being developed separately.

VS Code stores explicit interpreter selections separately from the default setting. After changing
environments, open a Python file within this checkout, run **Python: Select Interpreter**, and
select `.venv-lint/Scripts/python.exe` on Windows or `.venv-lint/bin/python` on POSIX. If necessary,
enter the path manually and run **Developer: Reload Window**. A file outside the project or a
notebook kernel may need its own selection. Changing the default does not prove that an already-open
editor has switched interpreters. See Microsoft's
[environment guidance](https://code.visualstudio.com/docs/python/environments).

```powershell
.venv-lint/Scripts/python.exe -m pip install -r tools/requirements-types.txt
.venv-lint/Scripts/python.exe -m pyright --project pyproject.toml --pythonpath <project-python>
```

Use `--outputjson` when saving a machine-readable diagnostic inventory. In the installed Python
wrapper (1.1.411), that option also skips its optional online new-version notification check; it
does not suppress type diagnostics. The bundled JavaScript checker still requires a working Node
executable. An installed Python package alone does not establish that the checker can start or that
the project is type-clean.

Replace the interpreter placeholder with an actual executable. The Python wrapper needs Node and may
download it; provision and pin Node explicitly for reproducible CI. This optional tool is separate
from the Node-free [lint/format toolchain](tooling.md).

Adopt in each repository by inventorying current errors with its real dependencies, fixing import
resolution, then correcting annotations and behavior with tests. Enable a required CLI CI check once
its declared scope passes. Any staged rollout must name deferred directories and track their debt;
do not declare the whole repository type-clean based on an artificially empty or narrowed scope.
Version upgrades require review and rerunning type checks, lint, and tests.

The references inventory on 2026-09-05 analyzed 41 files with Pyright 1.1.411 and reported 46
errors, including existing dependency/typing issues; none were in the new bibcop wrapper or tests.
This is evidence of outstanding work, not a passing gate. No repository-wide required type CI gate
or strict-path rollout is claimed yet.

The [2026-09-07 environment validation](../status/python-environment-2026-09-07.md) records the
newer 72-file inventory and remaining diagnostics, after installing the maintained workflow
dependencies. Keep dated counts as evidence snapshots, not live TODO counts.
