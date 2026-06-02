# Agent Roles & Artifact Ownership

For the agent identity roster (slug, name, design-doc), see `../registry.yaml` under `agents`.

## Artifact Ownership

| Artifact types | Owner |
|---|---|
| user-journey-map, project-charter, prd, user-story, stakeholder-matrix | business-analyst |
| user-flow, wireframe, component-spec | product-designer |
| system-architecture, architecture-decision, api-contract, data-model, tech-design, quality-requirement, task (be) | software-architect |
| test-plan, test-spec, test-suite | qa-engineer |
| task (fe) | frontend-engineer |
| infra | platform-engineer |
| change-request | any agent (files against upstream artifact owner) |
| advisory | project-manager |
| bug-report | qa-engineer |

No agent writes an artifact it does not own. Downstream agents file CRs instead.

## Conventions to Pass per Agent

Only pass conventions when the task involves new implementation; skip for read-only queries.

| Agent | Pass when implementing |
|---|---|
| **frontend-engineer** | `conventions/frontend-conventions.md`, `conventions/design-system.md` |
| **backend-engineer** | `conventions/backend-api-structure.md`, `conventions/api-conventions.md` |

Pass any relevant vault artifacts the agent needs (requirements, API contracts, component specs, ADRs) by path — let the agent read them.
