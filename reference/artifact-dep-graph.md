# Artifact Dependency Graph
> Disciplines, agents, artifact dependencies, creation order.

## Disciplines

| Discipline | Question | Agents | Artifacts | Lifespan | Scope |
|---|---|---|---|---|---|
| 0 — Domain Record | What does this domain do today? | business-analyst / software-architect | system-capability *or* domain-model | State | Domain |
| 1 — Requirements | What are we building and for whom? | project-manager, business-analyst | prd, user-story | Delta | Feature |
| 2 — Design | How does the user experience it? | product-designer | user-flow, design-spec | State | Feature |
| 3 — Architecture | How is it structured? | software-architect | adr, system-architecture, api-spec, data-design, tech-design | State + Delta (tech-design) | Feature |
| 4 — Development | How is it built? | backend-engineer, frontend-engineer, project-manager | task, plan | Delta | Feature |
| 5a — Test Planning | How will we verify this feature? | qa-engineer | test-plan | Delta | Feature |
| 5b — Verification | How do we know it works? | qa-engineer | test-spec | State | Domain |

> Discipline 0 is active by default with `system-capability`; `domain-model` is the alternative,
> selected via `../manifest.yaml`'s `domain_record:` field. The domain-record artifact is the
> long-lived home for product/business requirements in that domain; `feature-brief` /
> `user-story` pull from it (Context & Ideation) and merge back to it (Merge & Archive). See
> `../handbook/customizations/domain-record.md`.

## Discipline Flow

```mermaid
graph TD
    DR["Domain Record"] -.-> REQ
    REQ[Requirements] --> DES[Design]
    REQ --> ARC[Architecture]
    REQ --> VER[Verification]
    DES --> DEV[Development]
    ARC --> DEV
    ARC --> VER
    DEV --> VER
    VER -.-> DEV
    VER -.-> DR
```

Solid = produces; dashed = feedback/refines. `DR -.-> REQ` = read State before drafting
requirements (Context & Ideation step); `VER -.-> DR` = merge back to domain-record after ship
(Merge & Archive step). The active domain-record type is in `../manifest.yaml`'s `domain_record:`
field (`system-capability` by default).

## Read-Write Cycle (State / Delta)

Artifacts split into two lifespans (see `../manifest.yaml`'s `lifespan:` field):

- **State** (long-lived, System Space) — `system-architecture`, `adr`, `api-spec`, `data-design`,
  `design-spec`, `user-flow`, `test-spec`, and `system-capability` / `domain-model` (the active
  type per `domain_record:`).
  The evergreen truth of what the system is today.
- **Delta** (short-lived, Project Space) — `feature-brief`, `prd`, `press-release`, `user-story`,
  `tech-design`, `task`, `plan`, `test-plan`. Feature scaffolding, archived after ship.

A feature delivery moves through four phases:

1. **Context & Ideation** — read existing State artifacts to ground the proposal and find gaps.
2. **Proposal & Slicing** — `feature-brief` / `user-story` / `tech-design` capture the delta.
3. **Execution** — `task`s and code realize the delta.
4. **Merge & Archive** — update State from the shipped Delta, then archive the Delta.

**The Bridge Rule:** a feature is not "Done" until its logic is merged into the System Space.
`tech-design` acts as a "PR for the system blueprint" — it copies existing schemas/contracts and
highlights the delta, then merges back on ship. The requirements delta in `feature-brief` /
`user-story` also merges back to the domain-record.

```mermaid
graph LR
    classDef state fill:#d4edda,stroke:#28a745,color:#155724
    classDef delta fill:#ffe8cc,stroke:#fd7e14,color:#7a4a00

    subgraph P1["1 · Context & Ideation"]
        ROOT["requirements-root"]:::delta
        DR["domain-record"]:::state
        ROOT -.reads gaps.-> DR
    end
    subgraph P2["2 · Proposal & Slicing"]
        STORY[user-story]:::delta
        TD[tech-design]:::delta
        UF[user-flow]:::state
        DS[design-spec]:::state
        SA[system-architecture]:::state
        ADR[adr]:::state
        API[api-spec]:::state
        DD[data-design]:::state
        ROOT --> STORY
        STORY --> TD
        STORY -.targets UI.-> UF
        STORY -.targets UI.-> DS
        TD -.proposes tech.-> SA
        SA --> ADR
        TD -.proposes contracts.-> API
        TD -.proposes schema.-> DD
    end
    subgraph P3["3 · Execution"]
        TASK[task]:::delta
        TS[test-spec]:::state
        TD --> TASK
        STORY -.QA translates.-> TS
    end
    subgraph P4["4 · Merge & Archive"]
        STORYX["user-story ✅"]:::delta
        TDX["tech-design ✅"]:::delta
        DRX["domain-record"]:::state
        UFX["user-flow"]:::state
        DSX["design-spec"]:::state
        SAX["system-architecture"]:::state
        APIX["api-spec"]:::state
        DDX["data-design"]:::state
        STORYX -.absorbs rules.-> DRX
        STORYX -.absorbs UI & flows.-> UFX
        STORYX -.absorbs UI & flows.-> DSX
        TDX -.absorbs core shifts.-> SAX
        TDX -.absorbs contracts.-> APIX
        TDX -.absorbs schema.-> DDX
    end
```

**Legend** — 🟢 green = State (System Space, long-lived) · 🟠 orange = Delta (Project Space, archived after ship).
Solid = produces within a space; dashed = reads (Context & Ideation) or merges back (Merge & Archive) across the lifespan
boundary. In phase 4 the Delta artifacts are closed/archived while their content is absorbed into State:
`requirements-root` and `task` are retired; `user-story` and `tech-design` merge back to the State artifacts
they targeted in phase 2 (domain-record, user-flow, design-spec, system-architecture/adr, api-spec,
data-design). `test-spec` is written in place during execution and lives on as State.

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
    subgraph DR[Domain Record]
        SC["system-capability"]
    end
    subgraph REQ[Requirements]
        ROOT["prd"] --> STORY[user-story]
    end
    subgraph DES[Design]
        UF[user-flow] --> DS[design-spec]
    end
    subgraph ARC[Architecture]
        SA[system-architecture] --> ADR[adr]
        SA --> API[api-spec]
        SA --> DD[data-design]
        API <--> DD
        SA <--> TD[tech-design]
    end
    subgraph DEV[Development]
        TD --> TASK[task]
        TD --> PLAN["plan"]
        STORY --> PLAN
    end
    subgraph VER[Verification]
        TP[test-plan] --> TS[test-spec]
    end

    ROOT --> SA
    ROOT --> TD
    STORY --> TP
    API --> TP

    %% Domain-record (shipped default: system-capability) — no creation-order prerequisites,
    %% no upstream-authority edges over other artifacts
```

| To create… | First create… |
|---|---|
| system-capability | No hard prerequisite — start at domain inception |
| prd | — |
| user-story | prd |
| user-flow | prd |
| design-spec | user-flow |
| system-architecture | prd (or tech-design if bottom-up) |
| adr | system-architecture (or tech-design if bottom-up) |
| api-spec | system-architecture (or tech-design if bottom-up) |
| data-design | system-architecture (or tech-design if bottom-up) |
| tech-design | prd (and optionally system-architecture if top-down) |
| task | tech-design |
| plan | tech-design, user-story |
| test-plan | user-story, api-spec |
| test-spec | test-plan (first time for a domain); updated in place thereafter |
| note | — |

*Ad-hoc artifacts like `note` can be created at any time, by any agent, without discipline or prerequisite restrictions.*

*Requirements-root alternatives are customization selectable — see `../handbook/customization.md` and `../handbook/customizations/README.md`. An alternative shares the default type's dependencies shown above. The graph depicts `prd` (the framework's shipped default); the active type for this vault is in `../manifest.yaml`'s `requirements_root:` field — substitute it throughout when reading.*

*Domain-record alternatives are customization selectable — see `../handbook/customization.md` and `../handbook/customizations/README.md`. An alternative shares the default type's dependencies shown above. The graph depicts `system-capability` (the framework's shipped default); the active type for this vault is in `../manifest.yaml`'s `domain_record:` field — substitute it throughout when reading.*

*`api-spec` and `data-design` co-evolve (`↔`): both depend on `system-architecture`, but they iterate together — API shapes reference data-design entities, and data-design internal shapes are constrained by API contracts.*

Cross-refs live in `refs` frontmatter. See `artifact-frontmatter.md`.
