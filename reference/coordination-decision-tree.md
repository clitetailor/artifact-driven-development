# Coordination Artifact Decisions
> When to create scenarios, change-requests, and milestones.

For worked examples, see `../handbook/coordination-examples.md`.

---

## Decision Matrix

| Situation | Create | Skip |
|---|---|---|
| Defining a new charter or PRD | User Stories (in prd or as story- artifacts) | — |
| Gap in an accepted artifact | Change Request | — |
| Sprint or phase with multiple scenarios + timeline pressure | Milestone | — |
| Simple change owner can apply directly | — | Change Request not needed |
| Single scenario or 1–2 tasks | — | Milestone not needed |
| Concern or future improvement worth remembering | Advisory | — |

---

## When to Create Each

### User Story
**Always.** Defined inside the PRD (`prds/prd-{slug}.md`) or as a standalone `user-stories/story-{slug}.md` artifact. Format: "As a [role], I want [goal], so that [benefit]" with Given/When/Then acceptance criteria. Carries optional orchestration hints (priority, effort, timeline).

### Change Request
**When an existing artifact needs to change.** Filed at `change-requests/cr-{slug}.md`. Documents what should change and why; the target artifact's owner applies the change. CRs may produce tasks (listed in `refs`) or be doc-only.

Three cases specific to the new artifact types:
- **CR against `project-charter`** — scope or success-criteria changes may require sponsor re-approval; mark `Charter re-approval needed: yes` in the Impact Assessment.
- **CR against `user-story`** — preferred over filing against the parent PRD when only one story's AC or narrative is wrong; narrower blast radius.
- **CR against `user-journey-map`** — use when new research contradicts persona assumptions or journey stage mapping; may cascade to charter scope.

### Milestone
**Optional.** Useful when coordinating a sprint or phase with multiple user stories, timeline pressure, or cross-team work. Stored at `milestones/milestone-{slug}.md`. Aggregates stories, tasks, and CRs via `refs`.

### Advisory
**Optional, ad-hoc.** A noted-for-future tracker — write one when you spot a deferred improvement, known limitation, or concern worth remembering across sessions. Stored at `advisories/adv-{slug}.md`.

---

## Coordination Frontmatter

All cross-artifact links live in `refs`. Example milestone:

```yaml
---
id: milestone-sprint-1
type: milestone
status: open
charter: user-authentication
start-date: 2026-05-20
end-date: 2026-06-03
refs:
  - prd-user-authentication-login
  - story-user-login
  - task-login-be
  - task-session-be
  - cr-add-rate-limiting
---
```

Example change-request:

```yaml
---
id: cr-add-rate-limiting
type: change-request
status: applied
owner: software-architect
charter: user-authentication
refs:
  - api-user-authentication        # target
  - task-rate-limit-middleware-be  # resulting task
  - task-rate-limit-tests-be       # resulting task
---
```

Direction of the relationship (target vs resulting task vs sibling) is inferred from context, not from typed fields.

---

## Pattern

```
User Stories (user value, in prd or story- artifacts)
  ↓
Tasks (implementation)
  ↓
Milestone (optional coordination overlay)

Change-requests file against any artifact at any time.
Advisories note concerns at any time.
```
