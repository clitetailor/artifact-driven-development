# Spec: Artifact Simplification & Rename

> This spec documents the planned changes to simplify the artifact set, rename `registry.yaml`, and add new artifacts.

---

## 1. Rename `registry.yaml` → `manifest.yaml`

Rename the root config file from `registry.yaml` to `manifest.yaml`.

**Rationale:** "Manifest" better captures the file's role as a project declaration (what exists, what's valid). Pairs with `PROJECT.md` (human overview) — manifest = machine, PROJECT = human.

### Files with string replacements (`registry.yaml` → `manifest.yaml`)

| File | Lines |
|---|---|
| `README.md` | 43, 54, 117 |
| `AGENTS.md` | 9, 14 |
| `handbook/setup.md` | 3, 22, 28, 70, 78, 82, 88 |
| `handbook/README.md` | 4, 17 |
| `reference/README.md` | 9, 16 |
| `reference/folder-structure.md` | 3, 7, 39 |
| `reference/artifact-ownership.md` | 3 |
| `reference/artifact-lifecycle.md` | 5 |
| `reference/artifact-frontmatter.md` | 23, 59 |

---

## 2. New Root File: `PROJECT.md`

Human-readable project overview — the companion to `manifest.yaml`.

`manifest.yaml` = machine-readable project declaration (what exists, what's valid).
`PROJECT.md` = human-readable project overview (active tickets, PRD list, status).

### Sections

- **Status** — overall project state (active/paused/completed)
- **Active Tickets** — table of in-progress tickets
- **PRDs** — table of all PRDs with status
- **Architecture** — links to system-architecture and api-specs
- **Open Items** — unresolved concerns
- **References** — link to `manifest.yaml`

---

## 3. Simplify Artifact Types: 22 → 11

### 11-Artifact Core Set

| # | Artifact | Prefix | Template | Phase | Merges / Changes |
|---|---|---|---|---|---|
| 1 | `prd` | `prd-` | `templates/prd.md` | Requirements | ← project-charter + prd + stakeholder-matrix + quality-requirement |
| 2 | `user-story` | `story-` | `templates/user-story.md` | Requirements | kept as-is |
| 3 | `user-flow` | `uf-` | `templates/user-flow.md` | Design | ← user-journey-map + user-flow |
| 4 | `design-spec` | `ds-` | `templates/design-spec.md` | Design | ← wireframe + component-spec |
| 5 | `system-architecture` | `sa-` | `templates/system-architecture.md` | Architecture | ← system-architecture + architecture-decision (ADRs as sections); data flow → summary only |
| 6 | `api-spec` | `api-` | `templates/api-spec.md` | Architecture | ← api-contract (external contract only); add Entity Mapping section |
| 7 | `data-design` | `dd-` | `templates/data-design.md` | Architecture | new — internal data shapes + detailed data flows (from data-model + system-architecture data flow) |
| 8 | `tech-design` | `td-` | `templates/tech-design.md` | Development | reframed: Architecture → Architectural Context (refs only, no new architecture) |
| 9 | `task` | `task-` | `templates/task.md` | Development | add `ticket:` frontmatter field |
| 10 | `test-spec` | `ts-` | `templates/test-spec.md` | Verification | ← test-plan + test-spec |
| 11 | `ticket` | `ticket-` | `templates/ticket.md` | Coordination | new — replaces change-request, advisory, milestone, bug-report |

### Deprecated Artifacts (15 removed)

| Artifact | Where it went |
|---|---|
| `project-charter` | → prd (vision/scope/stakeholders section) |
| `user-journey-map` | → user-flow (journey overview section) |
| `stakeholder-matrix` | → prd (stakeholders section) |
| `wireframe` | → design-spec |
| `component-spec` | → design-spec |
| `architecture-decision` | → system-architecture (ADR sections) |
| `api-contract` | → api-spec (external contract only) |
| `data-model` | → data-design (internal shapes + relationships) |
| `quality-requirement` | → prd (non-functional requirements section, already in prd template) |
| `test-plan` | → test-spec (planning section) |
| `test-suite` | → code repo (not a spec artifact) |
| `bug-report` | → ticket with `kind: defect` |
| `infra` | → code repo (Terraform/Docker, not a spec artifact) |
| `change-request` | → ticket with `kind: change` |
| `advisory` | → ticket with `kind: investigation` |
| `milestone` | → prd (timeline section) / ticket grouping |

---

## 4. Overlap Resolutions

Three overlaps were identified between proposed artifacts. Resolutions below.

### Overlap 1: Data Flow — `system-architecture` ↔ `data-design`

**Problem:** `system-architecture` has a `## Data Flow` section. `data-design` also describes data flows (state machines, pipelines, transformations). Both would claim ownership.

**Resolution:** Move data flow detail to `data-design`. `system-architecture` keeps a `## Data Flow Overview` that's a high-level summary (which services talk to which), and references `data-design` for detailed flow diagrams and state machines.

| Artifact | Data flow scope |
|---|---|
| `system-architecture` | High-level: service-to-service communication, integration points |
| `data-design` | Detailed: entity state machines, pipeline stages, transformation logic |

### Overlap 2: Data Shapes — `api-spec` ↔ `data-design`

**Problem:** `api-spec` has request/response shapes (DTOs). `data-design` has entity definitions. The `UserResponse` DTO in api-spec is a projection of the `users` entity in data-design — same fields appear in both.

**Resolution:** `api-spec` owns **external shapes only** (what consumers see). `data-design` owns **internal shapes** (entities, relationships). DTOs are intentional *views* of entities, not duplication. Add an `## Entity Mapping` section to `api-spec` to make the relationship explicit:

```markdown
## Entity Mapping
<!-- Which data-design entities back each endpoint's request/response. -->

| Endpoint | Request → Entity | Response ← Entity |
|----------|-----------------|-------------------|
| POST /users | UserCreate → dd-{slug}.User | User → UserResponse |
```

### Overlap 3: Architecture Decisions — `system-architecture` ↔ `tech-design`

**Problem:** `system-architecture` absorbs ADRs as sections. `tech-design` has `## Key Decisions` (implementation-level decisions). The line between "architecture-level" and "implementation-level" is blurry.

**Resolution:** Clarify by **decision scope**, not importance:

| Scope | Owner | Example |
|---|---|---|
| System-wide — affects multiple services/features | `system-architecture` | "All services use event-driven communication" |
| Feature-scoped — affects one feature area | `tech-design` | "This feature uses Redis caching with TTL of 5min" |

`tech-design`'s `## Key Decisions` table adds a `Constrained by` column referencing the system-architecture ADR it follows.

### Structural Fix: `tech-design` Reframed

`tech-design` currently has a `## Architecture` section that overlaps with `system-architecture`. Reframe:

- **Remove** `## Architecture` (that's system-architecture's job)
- **Replace** with `## Architectural Context` (references only — which system-architecture decisions constrain this feature)
- `tech-design` becomes "how this feature is built" — it bridges system-architecture (system-level) and task (code-level)

---

## 5. New Template: `ticket.md`

Ticket is the coordination artifact — groups related changes, tracks work across artifacts.

### Ticket Kinds

| Kind | Purpose | Typical scope |
|---|---|---|
| `feature` | New capability end-to-end | Creates prd → user-flow → api-spec → tech-design → task chain |
| `change` | Modify existing spec artifacts | Updates one or more existing artifacts |
| `defect` | Fix inconsistency or error in specs | Updates artifact(s) with incorrect content |
| `investigation` | Research before committing to changes | May produce no artifact changes, only Discussion notes |
| `spike` | Time-boxed exploration | May create or update artifacts as side effect |
| `review` | Re-verify accepted artifacts after upstream shift | Sets `needs-review` status on affected artifacts |

### Ticket–Task Relationship

- **Ticket** = planning & coordination (what to do, which artifacts change, why)
- **Task** = implementation (how to build it, acceptance criteria, implementation notes)
- A ticket spawns tasks — ticket owns the "what", task owns the "how"
- `task` frontmatter gains a `ticket: ticket-{slug}` field

### Ticket Template Structure

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

Body sections:
- Summary
- Scope (table: artifact | change type | description)
- Rationale
- Impact
- Checklist (per-artifact progress)
- Discussion
- References

### Ticket Statuses

| Status | Meaning |
|---|---|
| `open` | Filed, not yet started |
| `in-progress` | Actively being worked on |
| `done` | All changes complete |
| `rejected` | Will not proceed |
| `withdrawn` | Cancelled by filer |

---

## 6. Merged Template Changes

### `prd.md` — absorbs charter, stakeholder-matrix, quality-requirement

Add sections at top:
- **Vision & Scope** (from charter: summary, in-scope, out-of-scope)
- **Success Criteria** (from charter: measurable outcomes)
- **Stakeholders** (from stakeholder-matrix: simplified table)
- **Constraints** (from charter: hard limits)

Existing sections kept:
- Problem Statement
- Functional Requirements
- Non-Functional Requirements (already present — quality-requirement content)
- User Stories
- Success Metrics
- Open Questions
- References

### `user-flow.md` — absorbs user-journey-map

Add section at top:
- **Journey Overview** (from user-journey-map: stages, emotions, pain points)

Existing sections kept.

### `design-spec.md` — new, merges wireframe + component-spec

Sections:
- **Wireframes** (visual layouts, from wireframe template)
- **Component Behavior** (interaction specs, from component-spec template)
- **Design Tokens** (shared styles, if applicable)
- References

### `system-architecture.md` — absorbs architecture-decision; data flow → summary only

Add section:
- **Architecture Decision Records** (ADR entries as subsections, each with context/decision/consequences)

Change section:
- **Data Flow** → **Data Flow Overview** (high-level service-to-service summary only; detailed flows moved to `data-design`)
- Add reference to `data-design` artifact for detailed data flows

### `api-spec.md` — new, external contract only (from api-contract)

Sections:
- **Endpoints** (from api-contract)
- **Shared Types** (request/response DTOs — external shapes only)
- **Entity Mapping** (maps DTOs to data-design entities — resolves overlap with data-design)
- **Error Codes**
- **Versioning Policy**
- **Rate Limits**
- References (includes data-design)

**Does NOT include:** entity relationships, table definitions, migrations, state machines — those belong in `data-design`.

### `test-spec.md` — absorbs test-plan

Add section at top:
- **Test Plan** (scope, approach, environment — from test-plan template)

Existing test-spec sections kept.

### `data-design.md` — new, internal data shapes + detailed data flows

Sections:
- **Overview** (what data this design manages and why)
- **Entity Definitions** (from data-model: tables/collections, columns, constraints, indexes)
- **Relationships** (entity-relationship diagram)
- **Data Flows** (detailed: state machines, pipeline stages, transformations — moved from system-architecture)
- **Migrations** (from data-model: migration sequences, up/down SQL)
- **Seed Data** (from data-model)
- References (includes api-spec for DTO→entity mapping)

### `tech-design.md` — reframed

Remove:
- **Architecture** section (system-architecture owns this)

Replace with:
- **Architectural Context** (references to system-architecture decisions that constrain this feature; no new architecture)

Change:
- **Key Decisions** table adds `Constrained by` column referencing system-architecture ADR IDs

### `task.md` — add ticket reference

Add frontmatter field:
```yaml
ticket: ticket-{slug}
```

---

## 7. `manifest.yaml` — Updated Sections

### Types

```yaml
types:
  # Requirements
  - name: prd
    prefix: prd-
    template: templates/prd.md
  - name: user-story
    prefix: story-
    template: templates/user-story.md

  # Design
  - name: user-flow
    prefix: uf-
    template: templates/user-flow.md
  - name: design-spec
    prefix: ds-
    template: templates/design-spec.md

  # Architecture
  - name: system-architecture
    prefix: sa-
    template: templates/system-architecture.md
  - name: api-spec
    prefix: api-
    template: templates/api-spec.md
  - name: data-design
    prefix: dd-
    template: templates/data-design.md

  # Development
  - name: tech-design
    prefix: td-
    template: templates/tech-design.md
  - name: task
    prefix: task-
    template: templates/task.md

  # Verification
  - name: test-spec
    prefix: ts-
    template: templates/test-spec.md

  # Coordination
  - name: ticket
    prefix: ticket-
    template: templates/ticket.md
```

### Statuses

```yaml
statuses:
  - name: draft
    description: Being written; not ready for review
  - name: ready-for-review
    description: Author marks complete; awaiting human approval
  - name: accepted
    description: Approved as the current source of truth
  - name: needs-review
    description: Was accepted, but an upstream changed — re-confirm consistency
  - name: rejected
    description: Will not be used in its current form
  - name: deprecated
    description: Replaced or no longer applicable; kept for history
  - name: open
    description: Filed, not yet started
    applies-to: [ticket, task]
  - name: in-progress
    description: Actively being worked on
    applies-to: [ticket, task]
  - name: done
    description: Implementation complete
    applies-to: [ticket, task]
  - name: withdrawn
    description: Cancelled by filer
    applies-to: [ticket]
```

---

## 8. Reference Docs — Content Updates

| File | Changes |
|---|---|
| `reference/artifact-dep-graph.md` | Rewrite phases (5+1), update dependency table for merged artifacts, remove deprecated types, add data-design dependencies |
| `reference/artifact-ownership.md` | Update ownership table to 11 types, assign ticket and data-design owners |
| `reference/artifact-frontmatter.md` | Update ID examples, add `ticket-` and `dd-` examples, remove deprecated prefixes |
| `reference/folder-structure.md` | Update folder tree — remove deprecated folders, add `tickets/`, `design-specs/`, `api-specs/`, `data-designs/` |
| `reference/coordination-decision-tree.md` | Replace CR/advisory/milestone decision paths with ticket `kind` routing |
| `reference/vault-queries.md` | Update grep patterns for new prefixes |
| `reference/artifact-vocabulary.md` | Update glossary for merged concepts, add data-design entry |

---

## 9. Agent Design Docs — Updates

| File | Changes |
|---|---|
| `agents/project-manager.md` | Use ticket instead of CR/advisory/milestone |
| `agents/business-analyst.md` | Remove charter/stakeholder-matrix references, update to merged prd |
| `agents/product-designer.md` | Update to merged design-spec, merged user-flow |
| `agents/software-architect.md` | Update to merged system-architecture, split api-spec/data-design ownership |
| `agents/qa-engineer.md` | Update to merged test-spec, remove bug-report/test-suite references |
| `agents/backend-engineer.md` | Update to api-spec (external) + data-design (internal) |
| `agents/frontend-engineer.md` | Update to merged design-spec, api-spec (external only) |
| `agents/platform-engineer.md` | Remove infra artifact reference |

---

## 10. Folder Structure Changes

### Add

| Folder | Artifact |
|---|---|
| `tickets/` | ticket |
| `design-specs/` | design-spec |
| `api-specs/` | api-spec |
| `data-designs/` | data-design |

### Remove (deprecated, empty folders)

| Folder | Was for |
|---|---|
| `user-journey-maps/` | user-journey-map |
| `project-charters/` | project-charter |
| `stakeholder-matrices/` | stakeholder-matrix |
| `wireframes/` | wireframe |
| `component-specs/` | component-spec |
| `architecture-decisions/` | architecture-decision |
| `data-models/` | data-model |
| `quality-requirements/` | quality-requirement |
| `test-plans/` | test-plan |
| `test-suites/` | test-suite |
| `bug-reports/` | bug-report |
| `infra/` | infra |
| `change-requests/` | change-request |
| `advisories/` | advisory |
| `milestones/` | milestone |

### Keep

| Folder | Artifact |
|---|---|
| `prds/` | prd |
| `user-stories/` | user-story |
| `user-flows/` | user-flow |
| `system-architectures/` | system-architecture |
| `tech-designs/` | tech-design |
| `tasks/` | task |
| `test-specs/` | test-spec |

---

## 11. Implementation Order

1. Create `PROJECT.md`
2. Create new templates: `ticket.md`, `design-spec.md`, `api-spec.md`, `data-design.md`
3. Update merged templates: `prd.md`, `user-flow.md`, `system-architecture.md`, `test-spec.md`, `task.md`, `tech-design.md`
4. Update `manifest.yaml` (rename + rewrite types/statuses sections)
5. Replace all `registry.yaml` references → `manifest.yaml` across docs
6. Update reference docs
7. Update agent design docs
8. Update folder structure (add new, remove deprecated)
9. Remove deprecated templates
10. Update `README.md` and `AGENTS.md`
