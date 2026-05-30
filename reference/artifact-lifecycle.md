# Status Labels

Status is an **informational label** — not an enforced state machine. Pick the value that best describes where the artifact is right now.

| Status | Typical meaning |
|---|---|
| `draft` | Being written; not ready for review |
| `ready-for-review` | Author marks complete; awaiting human approval |
| `accepted` | Approved as the current source of truth |
| `needs-review` | Was accepted, but an upstream changed — re-confirm consistency |
| `rejected` | Will not be used in its current form |
| `deprecated` | Replaced or no longer applicable; kept for history |
| `superseded` | Replaced by a newer version of the same kind (common for ADRs) |
| `applied` | Used on change-requests — the change has been incorporated |
| `withdrawn` | Used on change-requests — filer cancelled before action |
| `resolved` | Used on advisories and bug-reports — the concern/defect was addressed |
| `dismissed` | Used on advisories — explicitly decided not to act |
| `wont-fix` | Used on bug-reports — acknowledged but will not be fixed |
| `done` | Used on tasks — implementation complete |
| `in-progress` | Used on tasks — actively being worked on |
| `open` | Default starting state for change-requests, advisories, tasks |

No required transitions. Agents and humans pick the label that fits; the project manager (if any) reads it as context, not as a gate.
