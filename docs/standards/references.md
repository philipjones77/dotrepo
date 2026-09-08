# Shared Writing and Reference Assets

This repository consumes the references release `current_2026-09-07.zip` through
[the library lock](/docs/library/references.lock.json).
Read the [shared standards index](/docs/library/vendor/references/a032b4ad7ff9143272a6b880f96be2a377418b4f15a429766ae94115e2ea3875/standards/README.md) and the complete
[Research Writing Handbook](/docs/library/vendor/references/a032b4ad7ff9143272a6b880f96be2a377418b4f15a429766ae94115e2ea3875/standards/writing.md) when drafting or reviewing research prose.
The handbook includes the updated Philip Jones thesis profile, its British English conventions,
authorial method, appendix rules, and revision checks. That profile applies to Philip Jones's thesis
and documents that explicitly adopt it; technical documentation uses the applicable clarity,
evidence, and editing guidance with its existing project conventions.

Binding venue requirements and documented project exceptions retain their stated scope.
This refresh supplies writing guidance and an immutable asset snapshot. Runtime code, scientific
results, project tool configurations, and existing document build inputs have their own validation.
The packaged tooling templates are available for separately reviewed adoption.

## Pin and Verification

- Archive SHA-256: `a032b4ad7ff9143272a6b880f96be2a377418b4f15a429766ae94115e2ea3875`
- Manifest SHA-256: `da84c2e01f46ad27f19d6fe35322e3d46dc7e2e57949179a1249a388147da7c3`
- Retained release: [asset ZIP](/docs/library/releases/a032b4ad7ff9143272a6b880f96be2a377418b4f15a429766ae94115e2ea3875/current_2026-09-07.zip)
- Complete immutable snapshot: [consumer README](/docs/library/vendor/references/a032b4ad7ff9143272a6b880f96be2a377418b4f15a429766ae94115e2ea3875/README.md)

Run from a references source checkout with Python 3.10 or newer, substituting this repository's
actual path for `PROJECT`:

```text
python tools/reference_project.py verify --project PROJECT/docs/library
```

The pin and all vendored bytes were verified when this release was installed. This check verifies
integrity; it does not establish publication identity or test this repository's scientific code.
Commit the lock, snapshot, retained archive, and adoption documentation together when publishing.

## Updates and Existing Libraries

This pinned workflow supersedes older instructions to delete the flat library and unzip a release
into it. Existing `docs/library/global/` assets and `docs/library/local/` additions remain intact.
Those legacy directories remain flat. The explicit release upgrade permits the separate
`docs/library/vendor/` and `docs/library/releases/` trees; the immutable snapshot preserves all
namespaces in the current structured archive. This is a scoped exception to older flat-only
library layout rules, owned by repository maintainers and reviewed at the next asset upgrade.
Current bibliography loaders continue using their existing paths; adopting different bibliography
inputs requires checking citation migrations and local duplicates as part of that document change.
The shared writing handbook linked above is the active imported writing reference.

For an upgrade, obtain and review an explicit dated archive and its trusted SHA-256. Retain that
archive, run `reference_project.py install --project PROJECT/docs/library --archive ARCHIVE
--sha256 SHA256 --upgrade`, then update this guide's release links and validate the affected project.
Builds never fetch a new release. Make shared corrections in the references repository and keep
project additions separate from the immutable snapshot.
