---
id: story-{slug}
type: story
owner: business-analyst
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
hard-deps:
soft-deps:
  - req-{slug}
  - persona-{slug}
refs:
  - req-{slug}
  - persona-{slug}
---

# ⚠️ DEPRECATED: Story Template

**This template is deprecated as of Option A workflow implementation.**

**Use instead:** Embed scenarios directly in requirement documents (`templates/requirement.md`)

**Migration:** User narratives and acceptance criteria should now be written as scenarios within the requirement document, with orchestration metadata (priority, effort, dependencies, timeline).

**See:** `OPTION-A-WITH-ORCHESTRATION.md` for details on the new scenario-based approach.

---

# Story: {title}

## Narrative
As a **{persona or role}**,
I want to **{action or capability}**,
so that **{outcome or value}**.

## Preconditions
<!-- State the system must be in before this story begins. -->

- 
- 

## Acceptance Criteria
<!-- Testable conditions. Each must be unambiguously pass/fail. -->

- [ ] Given {context}, when {action}, then {outcome}
- [ ] Given {context}, when {action}, then {outcome}

## Error / Edge Cases
<!-- Scenarios outside the happy path that must be handled. -->

| Scenario | Expected Behavior |
|----------|-------------------|
|          |                   |

## Out of Scope
<!-- What this story explicitly does not cover. Prevents scope creep during implementation. -->

- 
