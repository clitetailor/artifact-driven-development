# Test-Driven Development Workflow
> QA Engineer methodology: what test artifacts to create, when, and how they pair with implementation. For phase-by-phase orchestration, see `sdlc-workflows.md`.

## Where TDD fits

Test artifacts span the Design and Build phases. The Quality group co-evolves with Implementation: tests written first (in Phase 3), code implemented in Phase 4 to make them pass.

```
DESIGN     requirement (with scenarios) ──▶ test-plan
BUILD      requirement + api-contract ──▶ test-spec ──▶ test-suite
BUILD      task (refs test-spec) ──▶ implement ──▶ verify passes ──▶ task done
                                  └─▶ QA marks test-spec accepted when cases pass
```

Phase-level orchestration (who activates QA, gate checks, etc.) lives in `sdlc-workflows.md`. This file covers the QA-internal mechanics.

## When to Create Test Artifacts

| Artifact | Trigger | Purpose |
|---|---|---|
| `test-plan` | After requirements accepted; runs parallel with UX / Architect in Design | Overall strategy, scope, levels, coverage targets, risk |
| `test-spec` | After api-contracts + data-models accepted, **before** task decomposition | Given/When/Then for one scenario |
| `test-suite` | After related test-specs drafted, before implementation | Group specs, fixtures, coverage goals, run commands |

`test-spec` status flips to `accepted` when its cases pass in Phase 4. `test-suite` flips to `accepted` when all included specs are accepted.

## Frontmatter Pattern

Single `refs` field — no hard/soft distinction. Missing test artifacts flag advisories but never block.

```yaml
# test-plan
refs: [req-{slug}]

# test-spec
refs: [req-{slug}, tp-{slug}]              # tp optional
scenario: req-{slug}#scenario-{N}

# test-suite
refs: [ts-{slug}, ts-{slug}, tp-{slug}]    # tp optional

# task (consumes test-specs)
refs: [ts-{slug}, api-{slug}, dm-{slug}]
scenario: req-{slug}#scenario-{N}
```

## Test Levels

- **Unit** *(primary)* — individual functions/classes/components; fast; external deps mocked.
- **Integration** *(when possible)* — module interactions; may need test database or service stubs; verifies api-contracts honored.
- **E2E** *(when possible)* — complete user flows; full stack with real or staging services.

## TDD Cycle (per task)

For each task referencing test-specs:

1. Run referenced test-specs → all fail (**red**).
2. Implement minimum code to pass → all pass (**green**).
3. Refactor; verify tests still pass.
4. Update task `status: done`; fill the task's **Implementation Notes** section (approach, deviations, gaps).
5. QA marks each test-spec `accepted` when its cases pass; test-suite `accepted` when all its specs are accepted.

## Coverage Targets

Set in test-suite frontmatter and body:
- **Line** — % of code lines executed
- **Branch** — % of decision branches tested
- **Function** — % of functions called

Critical paths should have 100% coverage.

## Example Walkthrough

Feature `user-authentication`:

**Phase 2 (Design):**
1. Create `tp-user-authentication` — strategy, 90% coverage target.

**Phase 3 (Test Specs + Tasks):**
2. Create `ts-user-authentication-login` — unit tests for login scenario.
3. Create `ts-user-authentication-token` — unit tests for token generation.
4. Create `suite-user-authentication` — groups both specs, refs test-plan.
5. Create `task-user-authentication-be` with `refs: [ts-user-authentication-login, ts-user-authentication-token]`.

**Phase 4 (Implementation):**
6. Run login spec → red.
7. Implement login function.
8. Run → green.
9. Repeat for token generation.
10. QA marks both specs `accepted`.
11. Suite flips to `accepted` (all specs accepted).

## Query Examples

```bash
# Test plan for a feature
rg -l "feature: user-authentication" test-plans/

# All test specs for a feature
rg -l "feature: user-authentication" test-specs/

# Specs still in draft
rg -l "type: test-spec" test-specs/ | xargs rg -l "status: draft"

# Suite containing a specific spec
rg -l "refs:.*ts-user-login" test-suites/

# Tasks referencing a specific spec (TDD traceability)
rg -l "refs:.*ts-user-authentication" tasks/

# All accepted specs (tests confirmed passing)
rg -l "type: test-spec" test-specs/ | xargs rg -l "status: accepted"
```
