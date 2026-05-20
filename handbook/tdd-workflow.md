# Test-Driven Development Workflow

## Overview

Test artifacts span DESIGN and BUILD phases. Test plans define the overall testing strategy in DESIGN, while test specs and suites are created in BUILD before implementation tasks.

## Artifact Flow

```
requirement (with scenarios) → test-plan (DESIGN phase)
    ↓                              ↓
  scenario-1, scenario-2    → test-spec → test-suite → task (BUILD phase)
  (embedded in req)             ↓           ↓          ↓
    ↓                      (how to    (grouped   (implement
  (what)                    verify)     tests)     to pass)
```

## When to Create Test Artifacts

### test-plan
- **Trigger**: After requirements are defined, before detailed design
- **Before**: Creating test-specs
- **Owner**: qa-engineer
- **Purpose**: Define overall testing strategy, scope, resources, schedule

### test-spec
- **Trigger**: After requirement scenarios are defined and API/data contracts are defined
- **Before**: Creating implementation tasks
- **Owner**: qa-engineer
- **Purpose**: Define specific test cases with Given/When/Then format for a specific scenario

### test-suite
- **Trigger**: After multiple related test-specs exist for a feature/module
- **Before**: Implementation begins
- **Owner**: qa-engineer
- **Purpose**: Group test-specs, define coverage targets, shared fixtures

## Dependency Pattern

All test artifact dependencies are **soft-deps** to allow flexibility:

```yaml
# test-plan
soft-deps:
  - req-{slug}

# test-spec
soft-deps:
  - req-{slug}
  - tp-{slug}  # optional reference to test plan
scenario: req-{slug}#scenario-N  # specific scenario being tested

# test-suite
soft-deps:
  - ts-{slug}
  - ts-{slug}
  - tp-{slug}  # optional reference to test plan

# task (optional reference)
soft-deps:
  - ts-{slug}  # tests to satisfy
  - api-{slug}
  - dm-{slug}
scenario: req-{slug}#scenario-N  # scenario being implemented
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

## TDD Cycle

1. **Write test-spec** defining test cases for a scenario
2. **Create test-suite** grouping related specs (optional for single specs)
3. **Create task** to implement code that passes the tests
4. **Implement** code in task
5. **Verify** all test cases pass
6. **Update** test-spec status to `accepted` when tests pass

## Coverage Targets

Set in test-suite:
- **Line coverage**: Percentage of code lines executed
- **Branch coverage**: Percentage of decision branches tested
- **Function coverage**: Percentage of functions called

Critical paths should have 100% coverage.

## Example Workflow

For feature `user-authentication`:

1. Create `tp-user-authentication` (overall testing strategy, 90% coverage target)
2. Create `ts-user-authentication-login` (unit tests for login function)
3. Create `ts-user-authentication-token` (unit tests for token generation)
4. Create `suite-user-authentication` (groups both specs, references test plan)
5. Create `task-user-authentication-be` (implements to pass tests)
6. Run tests, verify coverage
7. Update test-plan, test-spec, and test-suite status to `accepted`

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
```
