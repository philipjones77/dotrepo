# Python Programming Standard

These conventions apply to new and substantially revised maintained code. See
[source placement](source-code.md) and the [toolchain](tooling.md) for executable checks. Formatting
and linting cover only part of this standard; architecture, naming clarity, contracts, and numerical
reasoning require review.

## Names and Layout

- Use `snake_case` for modules, functions, methods, and variables; `PascalCase` for classes and
  exception types; `UPPER_SNAKE_CASE` for true module constants. Use a single leading underscore for
  internal APIs.
- Prefer domain names such as `precision_matrix`, `citation_key`, and `sample_count` to `data`,
  `tmp`, and `obj`. Avoid ambiguous `l`, `O`, and `I`. Short `i`, `j`, `x`, or `mu` are acceptable
  in small mathematical kernels when the docstring maps them to the notation registry.
- Do not encode types in names. Use `_path` for a filesystem path and `_url` for a remote address
  where the distinction matters. Include units (`timeout_seconds`) when a quantity could be misread.
- Use four spaces and a 100-column target. Let Ruff choose wrapping and quotes; do not align columns
  manually or insert decorative separator banners.
- Start modules with a concise purpose docstring and meaningful IO/side-effect boundaries. Add a
  shebang only for directly executable scripts. UTF-8 coding headers are unnecessary. Avoid author,
  change-history, and last-edited headers; Git records history. Preserve required
  copyright/licenses.
- Order module docstring, future imports, standard-library imports, third-party imports, local
  imports, constants/types, functions/classes, then the `__main__` guard. Document exceptional
  bootstrap ordering, such as the native certificate trust initialization, in code and lint
  configuration.

## Interfaces and Documentation

Use Python 3.10+ annotations on public functions and nontrivial internal boundaries: `list[str]`,
`Path | None`, and useful result types rather than unstructured dictionaries or `Any`. Use
dataclasses for stable structured records. Avoid speculative abstractions and mutable default
arguments.

Use NumPy-style docstrings for scientific/public APIs with parameters, returns, shapes, units,
assumptions, and relevant exceptions. A short sentence is sufficient for a self-explanatory helper.
Comments should explain intent, constraints, or non-obvious numerical choices, not narrate syntax.

```python
from pathlib import Path


def read_source(path: Path) -> str:
    """Read a UTF-8 metadata source without modifying it.

    Parameters
    ----------
    path : Path
        Local metadata file; remote URLs are not accepted.

    Returns
    -------
    str
        Decoded source text.

    Raises
    ------
    OSError
        If the file cannot be read.
    UnicodeDecodeError
        If the source is not valid UTF-8.
    """
    return path.read_text(encoding="utf-8")
```

## Design and Safety

Separate pure parsing, matching, classification, and numerical functions from filesystem/network/CLI
effects. Importing a module must not launch a workflow, rewrite files, configure global logging, or
start network requests. Put argument parsing and orchestration behind `main()` and a `__main__`
guard.

Use `pathlib.Path`, explicit encodings, context managers, and configurable paths. Derive repository
defaults from the module location, not the current working directory; avoid hard-coded personal
paths. Pass subprocess arguments as a list, check return codes, and do not interpolate untrusted
shell text.

Validate input at boundaries and raise specific exceptions with actionable context. Catch only
errors the caller can meaningfully handle; never convert an unexpected error into apparent success.
Use logging for workflow diagnostics and reserve stdout for intended CLI results. Do not log secrets
or unnecessary personal data. Set network timeouts, bounded retries, and verified TLS.

For library writes, implement explicit planning/apply boundaries, validate exact destinations,
preserve distinct editions, prevent overwrites, and record provenance and outcomes. Use atomic file
replacement where feasible, with recoverable prior content for material changes. A failed or partial
operation must remain visibly incomplete. Never treat a missing local copy or network failure as
evidence of a nonexistent reference.

Keep dependencies local to the workflow that needs them; optional dependencies must fail with useful
installation guidance. Share helpers only after behavior tests establish their contracts. Do not add
global configuration changes to reusable libraries.

## Testing and Scientific Code

Test public behavior, failure cases, empty/malformed inputs, deterministic ordering, and
idempotence. Use temporary directories and synthetic records; ordinary tests must not access the
user's library or require a live network. Keep live integration tests separately identified and
report what actually ran.

Numerical tests must state tolerances and cover shape/dtype, finite outputs, known small solutions,
domain constraints, and invariants. Prefer stable decompositions and linear solves to explicit
matrix inverses. Name array dimensions and connect formulas to canonical notation rather than
creating a second private notation standard. See [JAX](jax.md) for traced numerical code.

The current offline regression suite is `python -m unittest discover -s tools/tests -v`. Its
dependencies are documented by CI; installing lint tools alone does not install all workflow/test
dependencies. Syntax compilation and a passing linter are not substitutes for behavior tests.

## References

- [PEP 8: Python style](https://peps.python.org/pep-0008/)
- [PEP 257: docstrings](https://peps.python.org/pep-0257/)
- [NumPy docstring guide](https://numpydoc.readthedocs.io/en/latest/format.html)
