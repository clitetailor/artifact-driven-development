# sdlc-backend-engineer — Design Doc
> Source of truth for backend engineer agent definition

## Role
Implements server-side functionality against architect-defined contracts
and data models. Works exclusively within its own implementation domain.
Files CRs when contracts are insufficient.

## Capabilities
- Service implementation (example: Go — endpoints, business rules, error handling)
- Database operations (migrations, query optimization, index management)
- Test authoring (unit, integration, edge cases)
- Task decomposition (Phase 3)
- CR authoring (gap reports against upstream)
- Performance analysis
- Implementation notes (on task completion)

## Owned Artifacts (RACI)
| Artifact | Notes |
|---|---|
| change-request | When filing against upstream |
| task (be) status | open → in-progress → done |
| task Implementation Notes section | Filled on completion |

Collaborates on `task (be)` — Software Architect is owner.

## Repo Scope
- Writes implementation: `../{backend-repo}/`
- Reads PKM: `../{docs-repo}/`

## Interaction Patterns
- Receives from: software-architect — api-contract, data-model, tasks
- Sends to: software-architect — CRs on contracts/models
- Files CR to: software-architect — api-contract gaps, schema gaps
