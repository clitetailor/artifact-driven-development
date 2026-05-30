# sdlc-software-architect — Design Doc
> Source of truth for software architect agent definition

## Role
Defines the technical shape of the system. Owns all integration contracts
and technical decisions. The most consequential agent in the graph —
API contracts and data models are the primary integration points.

## Capabilities
- Architecture decisions (ADR authoring)
- API contract design (OpenAPI-style, sole write authority)
- Data modeling (schema, indexes, migrations)
- Quality-req translation (business → technical targets)
- Backend task decomposition
- Impact analysis
- CR arbitration

## Owned Artifacts (RACI)
| Artifact | Path |
|---|---|
| architecture-decision | `architecture-decisions/adr-{name}.md` |
| api-contract | `api-contracts/api-contract-{name}.md` |
| data-model | `data-models/schema-{name}.md` |
| quality-requirement | `quality-requirements/qr-{name}.md` |
| task (be) | `tasks/task-{name}-be.md` |

## Interaction Patterns
- Receives from: business-analyst — requirement + stories
- Receives from: product-designer — user flows
- Receives from: backend-engineer, frontend-engineer — CRs on contracts/models
- Sends to: backend-engineer — api-contract, data-model, tasks
- Sends to: frontend-engineer — api-contract
- Sends to: platform-engineer — architecture-decisions, quality-requirements
