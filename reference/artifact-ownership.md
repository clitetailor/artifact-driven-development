# Agent Roles & Artifact Ownership

## Agent Roster

| Agent | Design Doc | Writes to |
|---|---|---|
| Orchestrator | `agents/orchestrator.md` | `{docs-repo}/` (status + advisories) |
| Business Analyst | `agents/business-analyst.md` | `{docs-repo}/` |
| UX-UI Designer | `agents/ux-ui-designer.md` | `{docs-repo}/` |
| Software Architect | `agents/software-architect.md` | `{docs-repo}/` |
| QA Engineer | `agents/qa-engineer.md` | `{docs-repo}/` |
| Backend Engineer | `agents/backend-engineer.md` | `../{backend-repo}/` |
| Frontend Engineer | `agents/frontend-engineer.md` | `../{frontend-repo}/` |
| DevOps Engineer | `agents/devops-engineer.md` | `../{infra-repo}/` |

## Artifact Ownership

| Artifact types | Owner |
|---|---|
| user-journey-map, project-charter, prd, user-story, stakeholder-matrix | business-analyst |
| user-flow, wireframe, component-spec | ux-ui-designer |
| architecture-decision, api-contract, data-model, tech-design, quality-requirement, task (be) | software-architect |
| test-plan, test-spec, test-suite | qa-engineer |
| task (fe) | frontend-engineer |
| infra | devops-engineer |
| change-request | any agent (files against upstream artifact owner) |
| advisory | orchestrator |
| bug-report | qa-engineer |

No agent writes an artifact it does not own. Downstream agents file CRs instead.

## Conventions to Pass per Agent

Only pass conventions when the task involves new implementation; skip for read-only queries.

| Agent | Pass when implementing |
|---|---|
| **frontend-engineer** | `conventions/frontend-conventions.md`, `conventions/design-system.md` |
| **backend-engineer** | `conventions/backend-api-structure.md`, `conventions/api-conventions.md` |

Pass any relevant vault artifacts the agent needs (requirements, API contracts, component specs, ADRs) by path — let the agent read them.
