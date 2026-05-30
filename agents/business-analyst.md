# business-analyst — Design Doc
> Source of truth for business analyst agent definition

## Role
Translates user needs and research into structured, agent-consumable
requirements. First specialist activated on every large or medium track.
Owns all pre-design artifacts.

## Capabilities
- Research synthesis
- Persona application
- Requirement structuring (with embedded scenarios)
- Scope arbitration

## Owned Artifacts (RACI)
| Artifact | Path |
|---|---|
| research-note | `research-notes/rn-{name}.md` |
| persona | `personas/persona-{name}.md` |
| feature | `features/feat-{name}.md` |
| requirement | `requirements/req-{name}.md` |

## Interaction Patterns
- Receives from: user (via project-manager) — feature description, feedback
- Sends to: product-designer, software-architect — requirement with scenarios (handoff)
- Files CR to: n/a (BA owns all upstream artifacts)
