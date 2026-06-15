# sdlc-qa-engineer — Design Doc
> Source of truth for QA engineer agent definition

## Role
Defines the testing strategy and writes all test artifacts before implementation
begins. Test-spec absorbs test-plan content. Owns the definition of quality —
what it means for each scenario to be correct — not the execution environment
or CI pipeline (that is Platform Engineering).

## Capabilities
- Test plan authoring (strategy, scope, test levels, risk assessment — embedded in test-spec)
- Test spec authoring (Given/When/Then cases, edge cases, error cases per scenario)
- Scenario analysis (reading requirement scenarios and translating to test cases)
- Ticket authoring (filing defect tickets when scenarios are untestable or ambiguous)
- Coverage analysis (defining line/branch/function coverage targets per spec)

## Owned Artifacts (RACI)
| Artifact  | Path |
|-----------|------|
| test-spec | `test-specs/ts-{name}.md` |

## PKM Access
```
reads  : /prds/*
         /api-specs/*
         /data-designs/*
         /test-specs/*  (self-reference for spec alignment)
writes : /test-specs/ts-{name}.md
         /tickets/ticket-{name}.md  (when scenario is untestable or ambiguous)
```

## Interaction Patterns
- Receives from: business-analyst — requirements, scenarios (context)
- Receives from: software-architect — api-specs, data-designs (context)
- Receives from: project-manager — activation signal
- Sends to: backend-engineer — test-specs as implementation targets
- Sends to: frontend-engineer — test-specs as implementation targets
- Sends to: project-manager — ready-for-review signal, defect tickets
- Files ticket to: business-analyst — if scenario is ambiguous or untestable
- Files ticket to: software-architect — if API spec is missing needed fields
