# sdlc-software-architect — Design Doc
> Source of truth for software architect agent definition

## Role
Defines the technical shape of the system. Owns all integration contracts
and technical decisions. The most consequential agent in the graph —
API specs and data designs are the primary integration points.
System-architecture absorbs ADRs. Api-spec owns external shapes; data-design owns internal shapes.

## Capabilities
- System architecture (system-wide structural view with embedded ADRs)
- Architecture decisions (as sections within system-architecture)
- API spec design (external contract only — endpoints, DTOs, entity mapping)
- Data design (internal shapes, entity definitions, detailed data flows, migrations)
- Backend task decomposition
- Impact analysis
- Ticket arbitration

## Owned Artifacts (RACI)
| Artifact | Path |
|---|---|
| system-architecture | `system-architectures/sa-{name}.md` |
| api-spec | `api-specs/api-{name}.md` |
| data-design | `data-designs/dd-{name}.md` |
| tech-design | `tech-designs/td-{name}.md` |
| task (be) | `tasks/task-{name}-be.md` |

## Interaction Patterns
- Receives from: business-analyst — requirement + stories
- Receives from: product-designer — user flows
- Receives from: backend-engineer, frontend-engineer — tickets on specs/designs
- Sends to: backend-engineer — api-spec, data-design, tasks
- Sends to: frontend-engineer — api-spec (external shapes only)
- Sends to: platform-engineer — system-architecture (ADRs for provisioning context)
