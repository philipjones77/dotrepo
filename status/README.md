# Status Model

dotrepo uses these setup statuses for machines, environments, and related repos.

| Status | Meaning |
| --- | --- |
| `ok` | Present and usable for the audited profile |
| `missing` | Required for the audited profile and absent |
| `optional-missing` | Optional for this profile and absent |
| `manual-check` | Present or relevant, but needs human confirmation |
| `not-applicable` | Not expected for this profile |
| `planned` | Standard is documented, implementation is not built yet |
| `blocked` | Cannot be completed without external setup or credentials |

Generated audit output should normally stay local under `.local/status/`.
Commit only sanitized status summaries that are useful across machines.
