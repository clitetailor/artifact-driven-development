# Artifact Creation Order — Quick Reference
> Suggested order for creating artifacts. Not enforced.

## Graph

```mermaid
graph TD
    RN[research-note] --> PERSONA[persona]
    RN --> FEAT[feature]
    PERSONA --> FEAT
    FEAT --> REQ[requirement]
    PERSONA --> REQ

    REQ --> QR[quality-requirement]
    REQ --> ADR[architecture-decision]
    REQ --> UF[user-flow]
    UF --> WF[wireframe]
    WF --> CS[component-spec]

    REQ --> API[api-contract]
    API --> DM[data-model]

    REQ --> TP[test-plan]
    TP --> TS[test-spec]
    TS --> SUITE[test-suite]

    CS --> TASK_FE[task-fe]
    API --> TASK_FE
    API --> TASK_BE[task-be]
    DM --> TASK_BE

    TASK_BE --> INFRA[infra]
    TASK_FE --> INFRA
    QR --> INFRA
```

## Creation Order Table

| To create… | First create one or more of… |
|---|---|
| persona | research-note |
| feature | (none — entry point) |
| requirement | feature |
| quality-requirement | requirement |
| architecture-decision | requirement |
| user-flow | requirement |
| wireframe | user-flow |
| component-spec | wireframe |
| api-contract | requirement |
| data-model | api-contract |
| test-plan | requirement |
| test-spec | requirement (+ test-plan) |
| test-suite | test-spec |
| task (backend) | api-contract, data-model, requirement |
| task (frontend) | component-spec, api-contract |
| infra | tasks complete + quality-requirement |
| change-request | target artifact |
| advisory | (none — note of a future concern) |
| milestone | (none — coordination overlay) |

All cross-references live in the `refs` frontmatter field. See `artifact-frontmatter.md`.
