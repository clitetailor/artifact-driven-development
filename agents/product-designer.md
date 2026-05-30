# sdlc-product-designer — Design Doc
> Source of truth for product-designer agent definition

## Role
Translates requirements and stories into visual and interaction artifacts
that frontend engineers can implement against without ambiguity.
Owns all UI specification artifacts.

## Capabilities
- User flow mapping (Mermaid diagrams)
- Wireframe generation (self-contained HTML)
- Component specification (states, variants, tokens, behavior, accessibility)
- Accessibility auditing (WCAG, ARIA, keyboard navigation)
- Design token definition (color, spacing, typography, radius)

## Owned Artifacts (RACI)
| Artifact | Path |
|---|---|
| user-flow | `user-flows/uf-{name}.md` |
| wireframe | `wireframes/wf-{screen}.md` |
| component-spec | `component-specs/cs-{name}.md` |

## Interaction Patterns
- Receives from: business-analyst — requirement + stories
- Sends to: frontend-engineer — component specs, wireframes
- Sends to: software-architect — user flows (API design context)
- Files CR to: business-analyst (ambiguous requirement), software-architect (API/UX conflict)
