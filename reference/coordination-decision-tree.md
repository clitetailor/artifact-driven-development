# Coordination Artifact Decisions
> When to create tickets and which kind to use.

---

## Decision Matrix

| Situation | Create ticket kind | Skip |
|---|---|---|
| New capability end-to-end | `feature` | — |
| Modify existing spec artifacts | `change` | — |
| Fix inconsistency or error in specs | `defect` | — |
| Research before committing to changes | `investigation` | — |
| Time-boxed exploration | `spike` | — |
| Re-verify accepted artifacts after upstream shift | `review` | — |
| Simple change owner can apply directly | — | Ticket not needed |
| Defining a new PRD | User Stories (in prd or as story- artifacts) | — |

---

## Ticket Kinds

### `feature`
New capability end-to-end. Creates prd → user-flow → api-spec → tech-design → task chain. Typical scope: multiple artifacts across phases.

### `change`
Modify existing spec artifacts. Updates one or more existing artifacts. Typical scope: targeted updates to accepted artifacts.

### `defect`
Fix inconsistency or error in specs. Updates artifact(s) with incorrect content. Replaces the former bug-report artifact.

### `investigation`
Research before committing to changes. May produce no artifact changes, only Discussion notes. Replaces the former advisory artifact for research purposes.

### `spike`
Time-boxed exploration. May create or update artifacts as side effect.

### `review`
Re-verify accepted artifacts after upstream shift. Sets `needs-review` status on affected artifacts.

---

## Ticket–Task Relationship

- **Ticket** = planning & coordination (what to do, which artifacts change, why)
- **Task** = implementation (how to build it, acceptance criteria, implementation notes)
- A ticket spawns tasks — ticket owns the "what", task owns the "how"
- `task` frontmatter includes a `ticket: ticket-{slug}` field

---

## Ticket Frontmatter

```yaml
---
id: ticket-{slug}
type: ticket
kind: feature | change | defect | investigation | spike | review
owner: {agent-slug}
status: open
version: 1.0
charter: {charter-slug}
refs:
  - {artifact-id-1}
  - {artifact-id-2}
created: {YYYY-MM-DD}
closed: ~
---
```

Direction of the relationship (target vs resulting task vs sibling) is inferred from context, not from typed fields.

---

## Pattern

```
User Stories (user value, in prd or story- artifacts)
  ↓
Tickets (coordination — what to do, which artifacts change)
  ↓
Tasks (implementation — how to build it)

Tickets file against any artifact at any time.
```
