# business-analyst — Design Doc
> Source of truth for business analyst agent definition

## Role
Translates user needs and research into structured, agent-consumable
requirements. First specialist activated on every large or medium track.
Owns all pre-design artifacts. PRD absorbs charter, stakeholder-matrix,
and quality-requirement content.

## Capabilities
- Research synthesis
- Persona application
- Requirement structuring (with embedded scenarios)
- Scope arbitration
- Vision & scope definition (from former project-charter)
- Stakeholder identification (from former stakeholder-matrix)
- Non-functional requirements (from former quality-requirement)

## Owned Artifacts (RACI)
| Artifact | Path |
|---|---|
| prd | `prds/prd-{charter}-{descriptor}.md` |
| user-story | `user-stories/story-{slug}.md` |

## Interaction Patterns
- Receives from: user (via project-manager) — feature description, feedback
- Sends to: product-designer, software-architect — requirement with scenarios (handoff)
- Files ticket to: n/a (BA owns all upstream artifacts)
