# sdlc-frontend-engineer — Design Doc
> Source of truth for frontend engineer agent definition

## Role
Implements UI components against designer-defined specs and
architect-defined API contracts. Owns the complete frontend
implementation boundary.

## Capabilities
- Component implementation (example: SvelteKit — components, state, events)
- API integration (UI to backend endpoints per contract)
- Test authoring (component, e2e, accessibility)
- Task decomposition (frontend tasks)
- CR authoring (gap reports against specs or contracts)
- Performance optimization (bundle size, rendering, lazy loading)

## Owned Artifacts (RACI)
| Artifact | Notes |
|---|---|
| task (fe) | `{docs-repo}/tasks/task-{name}-fe.md` |
| change-request | When filing against upstream |
| implementation-note | Cross-cutting insights only |
| task (fe) status | open → in-progress → done |
| task impl-notes section | Filled on completion |

## Frontend Architecture Boundary
Component structure, state management, rendering strategy, and build
tooling are exclusively frontend decisions. The Architect defines the
API boundary — everything inside the frontend is not their concern.

## Repo Scope
- Writes implementation: `../{frontend-repo}/`
- Reads PKM: `../{docs-repo}/`

## Interaction Patterns
- Receives from: ux-ui-designer — component specs, wireframes
- Receives from: software-architect — api-contracts
- Files CR to: ux-ui-designer — component spec gaps
- Files CR to: software-architect — api-contract gaps
