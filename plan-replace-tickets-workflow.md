# Plan: Replace Tickets Workflow with Lean 3-Tier Hierarchy

## Objective
Replace the generic `ticket` artifact and coordination workflow with a lean, 3-tier execution model based on modern engineering practices (similar to Linear/GitHub Issues). This reduces artifact bloat, prevents "ticket" context fragmentation for AI agents, and explicitly separates product-driven work (`user-story`) from technical-driven work (`task`).

## The Lean 3-Tier Hierarchy

1. **Epic Level: `feature-brief` & `tech-design`**
   - Serve as the "Epic" grouping mechanism.
   - `feature-brief.md` defines the *What and Why*.
   - `tech-design.md` defines the *How*.

2. **Execution Level: `user-story` & `task`**
   - Sit at the same hierarchical level directly beneath the feature brief / tech design.
   - `user-story.md`: Represents product/user-facing work (e.g., "As a user, I want to reset my password").
   - `task.md`: Represents technical, chore, or architecture-driven work (e.g., "Set up Redis cache").

3. **Sub-Task Level: Checklists inside Tasks/Stories**
   - We **will not** introduce a separate `sub-task.md` artifact type.
   - Granular execution steps (sub-tasks) are represented simply as Markdown checklists (`- [ ]`) within the `task.md` or `user-story.md`.
   - Agents check off these boxes as they complete the work.

## Required Changes

### 1. Delete the Ticket Artifact
- [ ] Delete `templates/ticket.md`
- [ ] Remove the `ticket:` field from `templates/task.md` frontmatter
- [ ] Remove `ticket` from `manifest.yaml` types

### 2. Update `user-story.md` Template
- [ ] Remove `charter:` from frontmatter (deprecated in previous PRD refactor).
- [ ] Ensure frontmatter includes `feature-brief: {fb-slug}` for Epic linking.
- [ ] Add an `## Execution Checklist` section to represent Sub-Tasks.

### 3. Update `task.md` Template
- [ ] Ensure frontmatter includes `feature-brief: {fb-slug}` and `tech-design: {td-slug}`.
- [ ] Replace `ticket: {slug}` with standard reference linking.
- [ ] Add an `## Execution Checklist` section to represent Sub-Tasks.

### 4. Update Reference Documentation
- [ ] **`reference/artifact-vocabulary.md`**: Remove `ticket` definitions. Add definitions for how `user-story` and `task` relate to `feature-brief` as a pseudo-Epic.
- [ ] **`reference/artifact-dep-graph.md`**: Update the phase groupings to show that Tasks and User Stories are the lowest-level nodes, tracked via internal checklists.
- [ ] **`reference/coordination-decision-tree.md`**: Remove instructions to "Create a ticket". Replace with "Create a task or user-story and add checklist items".
- [ ] **`reference/folder-structure.md`**: Remove `tickets/` directory. Ensure `tasks/` and `user-stories/` are documented correctly.

### 5. Update Agent Handbooks
- [ ] **`agents/project-manager.md`**: Update workflows to orchestrate work via User Stories and Tasks instead of coordinating via Tickets.
- [ ] **`agents/software-architect.md`** & **`agents/frontend-engineer.md`**: Instruct them to use the Markdown checklists inside Tasks as their sub-task execution plan.

## Expected Template Structures

### `user-story.md` (Updated)
```markdown
---
id: story-{slug}
type: user-story
owner: business-analyst
status: open | in-progress | done
version: 1.0
feature-brief: fb-{slug}
priority: {P0 | P1 | P2}
estimated-hours: {N}
depends-on:
  - story-{slug}
refs:
  - ujm-{slug}
---

# User Story: {title}

## Narrative
As a **{persona}**, I want to **{action}**, so that **{value}**.

## Acceptance Criteria
- [ ] Given {context}, when {action}, then {outcome}

## Execution Checklist (Sub-Tasks)
<!-- Agents: Check off these items as work is completed. -->
- [ ] {sub-task 1}
- [ ] {sub-task 2}
```

### `task.md` (Updated)
```markdown
---
id: task-{slug}
type: task
owner: {agent-role}
status: open | in-progress | done
version: 1.0
feature-brief: fb-{slug}
tech-design: td-{slug}
priority: {tier-number}
estimated-hours: {N}
depends-on:
  - task-{slug}
refs:
  - api-{slug}
---

# Task: {title}

## Scope
### Included
- {scope item}

## Acceptance Criteria
- [ ] {testable condition}

## Execution Checklist (Sub-Tasks)
<!-- Agents: Check off these items as work is completed. -->
- [ ] {sub-task 1}
- [ ] {sub-task 2}
```