# Agent Roles & Artifact Ownership

For the agent identity roster (slug, name, design-doc), see `../manifest.yaml` under `agents`.

## Artifact Ownership

| Artifact types | Owner |
|---|---|
| feature-brief, prd, pitch, one-pager, press-release, user-story | business-analyst |
| user-flow, design-spec | product-designer |
| adr, system-architecture, api-spec, data-design, tech-design, task (be) | software-architect |
| plan, work-breakdown-structure, implementation-plan | project-manager |
| test-spec | qa-engineer |
| task (fe) | frontend-engineer |
| note | any |

No agent writes an artifact it does not own. Downstream agents file tasks (change/defect/review) instead.

## Conventions to Pass per Agent

Only pass conventions when the task involves new implementation; skip for read-only queries.

| Agent | Pass when implementing |
|---|---|
| **frontend-engineer** | `conventions/frontend-conventions.md`, `conventions/design-system.md` |
| **backend-engineer** | `conventions/backend-api-structure.md`, `conventions/api-conventions.md` |

Pass any relevant vault artifacts the agent needs (requirements, API specs, design specs, data designs) by path — let the agent read them.
