# Validation And Evidence Standards

This repository owns reusable standards and structures, but an automated pass must state exactly
which claim it supports. Do not use one `verified` flag to mean file existence, publication
identity, correct attachment, and reviewed content at once.

## Independent Checks

[Bibcop](../guides/bibcop-validation.md) adds advisory bibliographic style evidence, not publication
existence verification or a complete BibLaTeX schema check. Keep its findings separate from identity
and attachment outcomes.

| Claim                           | Evidence                                                                   | Not established by this check                        |
| ------------------------------- | -------------------------------------------------------------------------- | ---------------------------------------------------- |
| Structure is valid              | Parser/contract results, input hashes, tested schema                       | Publication existence or semantic accuracy           |
| Attachment exists               | Configured root, resolved path, file/directory status                      | Correct paper/package, correct version, completeness |
| Content is identical            | Full SHA-256 of both retained and incoming content                         | Same scholarly work when hashes differ               |
| Reference identity is supported | Authoritative identifiers and title/author/version evidence                | Correct local attachment or scientific validity      |
| Software belongs to a paper     | Paper's code statement and repository citation/README evidence             | Successful installation or reproduction              |
| Processing is complete          | Per-source outcome, verified destination, report, no unexplained remainder | Completion of other batches                          |

## Report Contract

Record check time, input paths and SHA-256, configured roots, scope, outcomes, errors, and
limitations. Preserve old reports as snapshots. A changed input hash invalidates any claim that an
earlier report describes current sources. Store detailed machine results under the owning `status/`
directory and reviewed summaries under `docs/status/`. Do not silently replace a previously released
asset ZIP after metadata changes.

Network exceptions, certificate errors, timeouts, and rate limits are technical failures, not
evidence that a reference is fabricated. Use certificate-verified requests and isolated TLS contexts
for concurrent workers. Revalidate affected rows after fixing a transport problem; keep the
superseded report marked as such.

## Attachment Rules

Use labelled `usera` through `userf` fields for interoperable BibLaTeX storage. Do not silently drop
an attachment when fields are full. Review or group related artifacts in an inventoried bundle
instead. Distinct bundles must have distinct destination names, with metadata referring to the
actual destination.

Supported labels include `filename`, `software`, `supplement`, `supplemental`, `appendix`,
`preprint`, `correction`, `poster`, `data`, `dataset`, `archive`, `website`, `image`, and
compatibility labels `file` and `repository`. Preserve distinct versions; do not relabel a preprint
as a published primary copy.

Publisher supplements require a reviewed parent citation. Do not identify them using a DOI from
their reference list. A parser must report unrecognized user fields explicitly so an apparently
clean audit cannot hide unexamined values.

## Maintained Checks

```powershell
python tools/validate_assets.py --report bibliography/status/validation/current/source.json
python tools/audit_repository.py --output-dir bibliography/status/validation/new-whole-tree-run
python src/automation/biblatex/audit_attachments.py
python src/automation/biblatex/biblatex_verify_reality.py
python -m unittest discover -s tools/tests -v
```

Attachment auditing is read-only. Optional `--hash-files` hashes individual files; it does not
recursively verify software directories. Paper/package relationships remain a separate review
obligation.

### Whole-Tree Inventory And Review Queue

`audit_repository.py` hashes readable files and inspects every discovered `.bib`, including inbox,
examples, vendored resources, and historical reports. Use a new output directory on each run. Its
`files-and-bib.json` records individual files, parsed entries, exact-content groups, and scan
errors; `issues.csv` provides record/file issues and proposed review actions. `summary.json`
distinguishes canonical namespaces from noncanonical snapshots and the legacy
`glossaries/library/acronyms.bib`.

VCS internals, dependency environments, caches, directory symlinks/junctions, and the selected
output tree are excluded explicitly. External attachment roots are not traversed by this inventory;
use the attachment and image audits for those. Unreadable directories remain unresolved, not
silently counted as empty. The tool neither deletes duplicate bytes nor rewrites bibliography
entries.

Reading and hashing a binary does not certify its format, renderability, safety, or scientific
content. The lightweight bibliography parser is not a complete Biber grammar/datamodel check. Run
the maintained asset/glossary contracts, Bibcop advisory checks, and downstream Biber/Bib2Gls build
as independent checks. Snapshot keys may legitimately repeat canonical keys. Metadata gaps are
review items: an undated webpage must not acquire a guessed publication year, and an original
cataloguer summary belongs in `annotation`, not `abstract`.

The reference-identity checker now refuses malformed/undecodable input and records input hashes
before and after the run. Its summary cannot mark a run complete if those hashes changed. A complete
run still means all requested records were checked, not that every identity is confirmed.
