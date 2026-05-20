# Test-Driven Development Workflow

## Overview

Test artifacts span DESIGN and BUILD phases. The QA Engineer is activated in
Phase 2 (test-plan) and Phase 3 (test-specs, test-suites) before implementation
tasks are decomposed. Engineers implement code in Phase 4 to pass the specs.

## Artifact Flow

```
DESIGN (Phase 2)
  requirement (with scenarios) ──○──▶ test-plan
                                         │
                                        ○│ (soft)
BUILD (Phase 3)                          ▼
  requirement + api-contract ───○──▶ test-spec ──○──▶ test-suite
                                                           │
                                                          ○│ (soft, referenced in task)
BUILD (Phase 3–4)                                          ▼
  task (implement to pass) ◄─────────────────────────────────
  implement → verify test-spec passes → task status: done
  QA marks test-spec: accepted when all cases pass
```

## SDLC Phase Anchors

| Artifact   | Phase created | Trigger                                               | Owner       |
|------------|---------------|-------------------------------------------------------|-------------|
| test-plan  | Phase 2       | After requirements accepted; runs parallel with UX/Arch | qa-engineer |
| test-spec  | Phase 3       | After api-contracts + data-models accepted            | qa-engineer |
| test-suite | Phase 3       | After related test-specs drafted                      | qa-engineer |
| test-spec  | Phase 4       | Status → `accepted` when implementation passes        | qa-engineer |
| test-suite | Phase 4       | Status → `accepted` when all included specs accepted  | qa-engineer |

## Orchestration Integration

### Phase 2 — Test Plan Creation

Orchestrator activates QA Engineer alongside UX-UI Designer and Software Architect.

```
[ORCH] Activates qa-engineer after requirements → accepted
[AGNT] QA reads: /requirements/*, /personas/*
[AGNT] QA writes: /test-plans/tp-{feature}.md
         ← strategy, scope, test levels, coverage targets
         ← risk assessment, entry/exit criteria
         ← list of test-specs to produce in Phase 3

Convention check before Gate 2:
  ✓ test-plan exists for the feature
  ⚠ test-plan missing → advisory only, does not block Gate 2
```

### Phase 3 — Test Spec + Suite Creation (before task decomp)

QA Engineer runs first in Phase 3 so tasks can reference test-specs as soft-deps.

```
[ORCH] Activates qa-engineer first in Phase 3
[AGNT] QA reads: /requirements/*, /api-contracts/*, /test-plans/*
[AGNT] QA writes: /test-specs/ts-{name}.md  (one per scenario)
[AGNT] QA writes: /test-suites/suite-{name}.md

Convention check before task decomp:
  ✓ test-spec exists for each scenario in accepted requirements
  ✓ test-suite exists grouping related specs for the feature
  ⚠ missing test-spec → advisory, does not block task decomposition

[ORCH] Activates arch/backend/frontend for task decomposition
[AGNT] Tasks include: soft-deps: [ts-{slug}]  (tests this task satisfies)
```

### Phase 4 — TDD Implementation Cycle

Engineers follow the red-green-refactor cycle per task.

```
For each task with test-spec soft-deps:
  1. Run test-spec test cases → all fail (red)
  2. Implement minimum code to pass → all pass (green)
  3. Refactor, verify tests still pass
  4. Update task: status → done; fill implementation-notes

[AGNT] QA confirms test results for each test-spec:
  → test cases passing → test-spec status: accepted
  → all specs in suite accepted → test-suite status: accepted

Convention check before Gate 4:
  ⚠ test-specs still in draft → advisory (tests not confirmed passing)
```

## When to Create Test Artifacts

### test-plan
- **Trigger**: After requirements accepted, before Gate 2
- **Parallel with**: UX-UI Designer, Software Architect (Phase 2)
- **Owner**: qa-engineer
- **Purpose**: Define overall testing strategy, scope, resources, coverage targets

### test-spec
- **Trigger**: After api-contracts and data-models accepted (Phase 3 start)
- **Before**: Task decomposition (so tasks can ref test-specs)
- **Owner**: qa-engineer
- **Purpose**: Given/When/Then cases for a specific requirement scenario

### test-suite
- **Trigger**: After related test-specs are drafted (Phase 3)
- **Before**: Implementation begins
- **Owner**: qa-engineer
- **Purpose**: Group test-specs, define coverage targets, shared fixtures, run commands

## Dependency Pattern (Frontmatter)

All test artifact dependencies are **soft-deps** to allow flexibility:

```yaml
# test-plan
soft-deps:
  - req-{slug}

# test-spec
soft-deps:
  - req-{slug}
  - tp-{slug}            # optional reference to test plan
scenario: req-{slug}#scenario-{N}   # specific scenario being tested

# test-suite
soft-deps:
  - ts-{slug}
  - ts-{slug}
  - tp-{slug}            # optional reference to test plan

# task (optional reference to tests it must pass)
soft-deps:
  - ts-{slug}            # test specs this task satisfies
  - api-{slug}
  - dm-{slug}
scenario: req-{slug}#scenario-{N}   # scenario being implemented
```

## Test Levels

### Unit Tests (Primary)
- Test individual functions, classes, components
- Fast execution, no external dependencies
- Mock external services and databases

### Integration Tests (When Possible)
- Test interaction between modules
- May require test database or service stubs
- Verify API contracts are honored

### E2E Tests (When Possible)
- Test complete user flows
- Full stack with real or staging services
- Verify user stories end-to-end

## TDD Cycle (Per Task)

1. **Write test-spec** defining test cases for a scenario (Phase 3)
2. **Create test-suite** grouping related specs (Phase 3, optional for single specs)
3. **Create task** to implement code that passes the tests (Phase 3)
4. **Run tests** — all fail (red) before implementation
5. **Implement** minimum code in task (Phase 4)
6. **Run tests** — all pass (green)
7. **Refactor** — clean code, verify tests still pass
8. **Update** task status → done, fill implementation-notes
9. **QA marks** test-spec → accepted; test-suite → accepted when all specs pass

## Coverage Targets

Set in test-suite frontmatter and body:
- **Line coverage**: Percentage of code lines executed
- **Branch coverage**: Percentage of decision branches tested
- **Function coverage**: Percentage of functions called

Critical paths should have 100% coverage.

## Example Workflow

For feature `user-authentication`:

**Phase 2:**
1. Create `tp-user-authentication` (overall testing strategy, 90% coverage target)

**Phase 3:**
2. Create `ts-user-authentication-login` (unit tests for login scenario)
3. Create `ts-user-authentication-token` (unit tests for token generation scenario)
4. Create `suite-user-authentication` (groups both specs, refs test plan)
5. Create `task-user-authentication-be` (soft-dep: ts-user-authentication-login, ts-user-authentication-token)

**Phase 4:**
6. Run `ts-user-authentication-login` → all tests fail (red)
7. Implement login function
8. Run tests → all pass (green)
9. Repeat for token generation
10. QA marks `ts-user-authentication-login` → accepted
11. QA marks `ts-user-authentication-token` → accepted
12. QA marks `suite-user-authentication` → accepted (all specs accepted)

## Query Examples

```bash
# Find test plan for a feature
rg -l --glob '!.*' "feature: user-authentication" test-plans/

# Find all test specs for a feature
rg -l --glob '!.*' "feature: user-authentication" test-specs/

# Find all test suites
rg -l --glob '!.*' "type: test-suite" test-suites/

# Find test specs that are still draft
rg -l --glob '!.*' "type: test-spec" test-specs/ | xargs rg -l "status: draft"

# Find which test suite contains a specific test spec
rg -l --glob '!.*' "soft-deps:.*ts-user-login" test-suites/

# Find all test artifacts (plan, specs, suites) for a feature
rg -l --glob '!.*' "feature: user-authentication" test-plans/ test-specs/ test-suites/

# Find tasks that reference a specific test spec (TDD traceability)
rg -l --glob '!.*' "soft-deps:.*ts-user-authentication" tasks/

# Find all accepted test specs (tests confirmed passing)
rg -l --glob '!.*' "type: test-spec" test-specs/ | xargs rg -l "status: accepted"
```
