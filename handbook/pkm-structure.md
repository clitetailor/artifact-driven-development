# PKM Folder Structure
> Agent Knowledge Base — Zettelkasten-style document system.

The vault is a markdown-based PKM where every artifact is a typed, versioned document with YAML frontmatter. Agents read and write artifacts; cross-references live in the `refs` field. The system is guidance-driven: no hard enforcement on creation order.

## Where the Specs Live

| Concern | File |
|---|---|
| Folder tree | `../reference/folder-structure.md` |
| Artifact types, prefixes, features, modules | `../_registry.md` |
| Frontmatter schema + ID naming pattern | `../reference/artifact-frontmatter.md` |
| Common status labels | `../reference/artifact-lifecycle.md` |
| Agent ownership per artifact type | `../reference/artifact-ownership.md` |
| Suggested creation order | `../reference/artifact-dep-graph.md` |
| Grep recipes for navigation | `../reference/vault-queries.md` |

This document covers the parts that have **no separate reference doc**: agent memory, the change-request document format, and a few format conventions.

---

## Agent Memory Structure

Each agent has a private memory namespace not indexed by the vault.

```
/agent-memory/{agent}/
  ├── _state.md           ← current working state (1 file, overwritten each session)
  ├── _context-cache.md   ← digested summaries of consumed artifacts
  └── scratch-{task}.md   ← per-task reasoning scratchpad (deleted on task completion)
```

One namespace per agent: orchestrator, business-analyst, ux-ui-designer, software-architect, qa-engineer, backend-engineer, frontend-engineer, devops-engineer.

### `_state.md` fields

```markdown
---
agent: {agent-slug}
updated: {ISO datetime}
active-tasks: [{task-id}]
waiting-on: [{artifact-id}]
recently-completed: [{artifact-id}]
notes: [{free-form working notes}]
---
```

### `scratch-{task}.md` conventions

- `?` — unresolved question, needs input before deciding
- `✗` — option eliminated, reason preserved
- `→` — decided direction, pending formalization

Scratch notes are never linked from the artifact graph. They are deleted or archived when the task completes. Key reasoning is promoted to the artifact body on completion.

---

## Change Request Format

**Path:** `/vault/change-requests/cr-{name}.md`

```markdown
---
id: cr-{name}
type: change-request
status: open              ← open / applied / rejected / withdrawn
owner: {agent-slug}
feature: {feature-slug}
created: {date}
refs:
  - {target-artifact-id}     ← artifact being modified
  - {related-artifact-id}    ← anything else relevant (resulting tasks, related ADRs, etc.)
---

# CR: {title}

## Problem
What is missing or incorrect in the target artifact.

## Proposed Change
Exact description of what should change.

## Justification
Which requirement, constraint, or scenario motivates this change.

## Impact Assessment
- Breaking: yes/no
- Migration needed: yes/no
- Downstream affected: {list or none}

## Decision
<!-- filled by artifact owner on resolution -->
status: ~
reason: ~
alternative: ~
```

All cross-artifact links go in `refs` — including the target artifact, any resulting tasks, and any sibling artifacts impacted. Direction and role are inferred from context.

CRs are kept as permanent audit trail.

---

## Advisory Format

**Path:** `/vault/advisories/adv-{slug}.md`

A short note flagging a concern, deferred improvement, or known limitation worth remembering across sessions. Created ad-hoc by an agent or human — not auto-generated.

```markdown
---
id: adv-{slug}
type: advisory
status: open              ← open / resolved / dismissed
feature: {feature-slug}
created: {date}
refs:
  - {related-artifact-id}
---

# Advisory: {title}

## Concern
What's worth remembering.

## Why noted now
What's blocking immediate action (out of scope, deferred, low priority).

## Trigger to revisit
When this should be picked up — e.g. "when traffic exceeds 10k req/min", "when OAuth is added", "next refactor of session module".
```

To list open advisories:
```bash
rg "type: advisory" /vault | xargs rg -L "status: resolved"
```

---

## Format Conventions

### Wireframes

- One file per screen, stored in `/wireframes/`
- ASCII layout drawn inside fenced code blocks
- Human-readable in any text editor or markdown viewer
- Referenced from component specs via `refs`
- Not stored in Figma or external tools

### User Flows

- Stored in `/user-flows/`, markdown with embedded Mermaid diagrams
- Mermaid renders natively in Obsidian, GitHub, Notion
- Covers happy path, error paths, exit points

### Implementation Notes

- **Not required** per task — tasks carry their own implementation notes section (filled on completion)
- Only created for **cross-cutting insights** spanning multiple tasks
