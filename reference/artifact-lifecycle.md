# Artifact Lifecycle & Status Transitions

## Standard Artifact Lifecycle

| From               | To                 | Condition                 |
|--------------------|--------------------|---------------------------|
| `draft`            | `ready-for-review` | author marks ready        |
| `ready-for-review` | `accepted`         | reviewer approves         |
| `ready-for-review` | `rejected`         | reviewer rejects          |
| `accepted`         | `needs-review`     | change requested          |
| `needs-review`     | `accepted`         | reviewer re-approves      |
| `needs-review`     | `draft`            | author reverts to draft   |

An artifact can only reach `accepted` if all `hard-deps` exist and are `accepted`.
Statuses remain authoritative workflow state. Agents must respect status-based blocking by default, and may bypass a status blocker only when the user explicitly instructs them to proceed without waiting for the blocking status transition.

## Task Lifecycle

Tasks use a separate execution lifecycle and do not go through draft/review:
```
open → in-progress → done
```
Tasks start implementation-ready. Dependency gating applies to their `hard-deps` (upstream design artifacts), not to the task's own status.

Task breakdowns use the standard artifact lifecycle. A task-breakdown cannot reach `accepted` until its source change request is `applied`.

## Change Request Lifecycle

| From     | To          | Condition                          |
|----------|-------------|------------------------------------|
| `open`   | `applied`   | artifact owner applies the change  |
| `open`   | `rejected`  | artifact owner rejects with reason |
| `open`   | `withdrawn` | filer cancels before owner acts    |

Rejection is terminal. If the filer disagrees with a rejection, they file a new CR rather than re-opening the old one.

## Advisory Lifecycle

| From    | To          | Condition                               |
|---------|-------------|-----------------------------------------|
| `open`  | `resolved`  | the concern was addressed               |
| `open`  | `dismissed` | user consciously decides not to act     |

Both are terminal. Advisories are never deleted — they remain as audit trail.

## Architecture Decision Lifecycle

Follows the standard lifecycle with two additional terminal states:

| From       | To           | Condition                              |
|------------|--------------|----------------------------------------|
| `accepted` | `deprecated` | decision no longer applicable          |
| `accepted` | `superseded` | replaced by a newer ADR                |

## Implementation Note Lifecycle

Simplified — they are optional, informational, and block nothing:
```
draft → published
```

## Type-Specific Rules

- Research notes must reach `accepted` before a persona can be accepted.
- Scenarios are embedded directly in requirement documents — never as separate artifacts. Stories are deprecated.
- Architecture decisions are optional — create only for significant technical choices.
- Infra is the terminal node — it reaches `accepted` when the deployment is approved.
