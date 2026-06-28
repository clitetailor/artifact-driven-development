# Agent Roles & Artifact Ownership

For the agent identity roster (slug, name, design-doc), see `../manifest.yaml` under `agents`.

## Artifact Ownership

| Artifact types | Owner |
|---|---|
| feature-brief, prd, press-release, user-story | business-analyst |
| user-flow, design-spec | product-designer |
| adr, system-architecture, api-spec, data-design, tech-design, task (be) | software-architect |
| plan | project-manager |
| test-spec, test-plan | qa-engineer |
| task (fe) | frontend-engineer |
| system-capability | business-analyst |
| domain-model | software-architect (primary), business-analyst (contributor) |
| note | any |

No agent writes an artifact it does not own or contribute to. For co-authored artifacts, the
contributor writes only sections within their stated authority; the primary owner is
accountable for the full artifact. Downstream agents file tasks (change/defect/review) instead.

### `domain-model` section authority

| Section | Authority |
|---|---|
| Ubiquitous Language | Co-authored — both must agree on terms |
| Core Entities, Value Objects, Domain Events | `software-architect` (primary) |
| Business Rules & Invariants | `business-analyst` (contributor) |

## Conventions to Pass per Agent

Only pass conventions when the task involves new implementation; skip for read-only queries.

| Agent | Pass when implementing |
|---|---|
| **frontend-engineer** | `conventions/frontend-conventions.md`, `conventions/design-system.md` |
| **backend-engineer** | `conventions/backend-api-structure.md`, `conventions/api-conventions.md` |

Pass any relevant vault artifacts the agent needs (requirements, API specs, design specs, data designs) by path — let the agent read them.
