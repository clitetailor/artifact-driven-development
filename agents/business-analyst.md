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
| research-note | `{docs-repo}/research-notes/rn-{name}.md` |
| persona | `{docs-repo}/personas/persona-{name}.md` |
| feature | `{docs-repo}/features/feat-{name}.md` |
| requirement | `{docs-repo}/requirements/req-{name}.md` |

## Repo Scope
- Writes: `{docs-repo}/`
- Reads PKM: `{docs-repo}/`

## Interaction Patterns
- Receives from: user (via orchestrator) — feature description, feedback
- Sends to: ux-ui-designer, software-architect — requirement with scenarios (handoff)
- Files CR to: n/a (BA owns all upstream artifacts)
