# Artifact Dependency Graph
> Phases, agents, artifact dependencies, creation order. Visualized: `../handbook/sdlc-swimlane-graph.html`.

## Phases

| Phase | Question | Agents | Artifacts |
|---|---|---|---|
| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | feature-brief, user-story |
| 2 — Design | How does the user experience it? | product-designer | user-flow, design-spec |
| 3 — Architecture | How is it structured? | software-architect | adr, system-architecture, api-spec, data-design |
| 4 — Development | How is it built? | backend-engineer, frontend-engineer | tech-design, task |
| 5 — Verification | How do we know it works? | qa-engineer | test-spec |

## Phase Flow

```mermaid
graph TD
    REQ[Requirements] --> DES[Design]
    REQ --> ARC[Architecture]
    REQ --> VER[Verification]
    DES --> DEV[Development]
    ARC --> DEV
    ARC --> VER
    DEV --> VER
    VER -.-> DEV
```

Solid = produces; dashed = feedback/refines.

## Interaction Types

| Type | Symbol | Meaning |
|---|---|---|
| Produces | `A → B` | A required before B |
| Refines | `A ↩ B` | B exposes gap in A; revise A |
| Constrains | `A ⊳ B` | A bounds B's valid shape |
| Co-evolves | `A ↔ B` | iterated together |

## Dependencies

```mermaid
graph LR
    subgraph REQ[Requirements]
        FB[feature-brief] --> STORY[user-story]
    end
    subgraph DES[Design]
        UF[user-flow] --> DS[design-spec]
    end
    subgraph ARC[Architecture]
        SA[system-architecture] --> ADR[adr]
        SA[system-architecture] --> API[api-spec]
        SA --> DD[data-design]
        API ↔ DD
    end
    subgraph DEV[Development]
        TD[tech-design] --> TASK[task]
    end
    subgraph VER[Verification]
        TS[test-spec]
    end
```

| To create… | First create… |
|---|---|
| feature-brief | — |
| user-story | feature-brief |
| user-flow | feature-brief |
| design-spec | user-flow |
| system-architecture | feature-brief |
| adr | system-architecture |
| api-spec | system-architecture |
| data-design | system-architecture |
| tech-design | system-architecture, feature-brief |
| task | tech-design |
| test-spec | api-spec, user-story |
| note | — |

*Ad-hoc artifacts like `note` can be created at any time, by any agent, without phase or prerequisite restrictions.*

*`api-spec` and `data-design` co-evolve (`↔`): both depend on `system-architecture`, but they iterate together — API shapes reference data-design entities, and data-design internal shapes are constrained by API contracts.*

Cross-refs live in `refs` frontmatter. See `artifact-frontmatter.md`.
