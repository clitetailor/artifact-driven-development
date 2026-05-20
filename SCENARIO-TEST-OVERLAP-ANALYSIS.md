# Scenario vs Test Artifact Overlap Analysis

---

## Question

Do scenarios in requirements, test-plans, and test-suites overlap? Should they be consolidated?

---

## Current Structure

### 1. Scenarios (in Requirements)
**Location:** `requirements/req-{slug}.md`  
**Owner:** Business Analyst  
**Purpose:** Define WHAT needs to be built

**Content:**
- User narrative (As a... I want... so that...)
- Acceptance criteria (Given/When/Then)
- Preconditions
- Error/edge cases
- **Orchestration metadata:** Priority, effort, dependencies, timeline

**Example:**
```markdown
### Scenario 1: Successful Login
**Priority:** P0
**Estimated effort:** 3 tasks (14 hours)
**Timeline:** Sprint 1

**Narrative:** As a registered user, I want to log in...

**Acceptance Criteria:**
- [ ] Given valid credentials, when user submits, then redirect to dashboard
- [ ] Given valid credentials, when user logs in, then session token created
```

---

### 2. Test Plans
**Location:** `test-plans/tp-{slug}.md`  
**Owner:** QA Engineer  
**Purpose:** Define HOW testing will be conducted (strategy)

**Content:**
- Testing strategy (unit, integration, e2e)
- Test types (functional, regression, performance, security)
- Test environment setup
- Test data strategy
- Coverage targets
- Schedule and resources
- Risk assessment

**Example:**
```markdown
## Testing Strategy

### Test Levels
| Level | Coverage Target | Approach | Tools |
|-------|----------------|----------|-------|
| Unit | 80% | Mock external deps | Jest |
| Integration | 70% | Test DB | Supertest |
| E2E | 50% | Full stack | Playwright |

## Entry Criteria
- [ ] Requirements are accepted
- [ ] API contracts are defined
```

---

### 3. Test Suites
**Location:** `test-suites/suite-{slug}.md`  
**Owner:** QA Engineer  
**Purpose:** Group and organize test specs for execution

**Content:**
- List of test-specs included
- Coverage goals (line, branch, function %)
- Shared test fixtures
- Test data requirements
- Execution order
- Run commands
- CI/CD integration

**Example:**
```markdown
## Test Specs Included
| Test Spec ID | Description | Test Level | Status |
|--------------|-------------|------------|--------|
| ts-login-validation | Login validation tests | unit | draft |
| ts-session-mgmt | Session management tests | unit | draft |

## Coverage Goals
- Line Coverage: 85%
- Branch Coverage: 80%
```

---

## Overlap Analysis

### ❌ **No Significant Overlap**

| Aspect | Scenarios (Requirements) | Test Plans | Test Suites |
|--------|-------------------------|------------|-------------|
| **Purpose** | Define WHAT to build | Define HOW to test | Organize test execution |
| **Owner** | Business Analyst | QA Engineer | QA Engineer |
| **Phase** | DEFINE (Phase 1) | DESIGN (Phase 2) | BUILD (Phase 3) |
| **Focus** | User value & acceptance | Testing strategy | Test organization |
| **Content** | User narratives, AC | Strategy, resources, schedule | Test grouping, fixtures, commands |
| **Audience** | Product team, engineers | QA team, engineers | QA engineers, CI/CD |
| **Granularity** | Feature-level scenarios | Feature-level strategy | Test-spec grouping |

---

## Detailed Comparison

### Scenarios vs Test Plans

**Scenarios contain:**
- ✅ User narrative (business value)
- ✅ Acceptance criteria (WHAT must work)
- ✅ Orchestration metadata (priority, effort, timeline)
- ❌ No testing strategy
- ❌ No test environment details
- ❌ No coverage targets
- ❌ No test resources/schedule

**Test Plans contain:**
- ❌ No user narratives
- ❌ No acceptance criteria
- ✅ Testing strategy (unit/integration/e2e approach)
- ✅ Test environment setup
- ✅ Coverage targets
- ✅ Test resources and schedule
- ✅ Risk assessment
- ✅ Entry/exit criteria

**Verdict:** ✅ **No overlap** — Scenarios define WHAT, test plans define HOW to test

---

### Scenarios vs Test Suites

**Scenarios contain:**
- ✅ User narrative
- ✅ Acceptance criteria
- ✅ Orchestration metadata
- ❌ No test spec grouping
- ❌ No test fixtures
- ❌ No run commands
- ❌ No CI/CD integration

**Test Suites contain:**
- ❌ No user narratives
- ❌ No acceptance criteria
- ✅ Test spec grouping
- ✅ Shared test fixtures
- ✅ Coverage goals
- ✅ Run commands
- ✅ CI/CD integration
- ✅ Execution order

**Verdict:** ✅ **No overlap** — Scenarios define WHAT, test suites organize test execution

---

### Test Plans vs Test Suites

**Test Plans contain:**
- ✅ Overall testing strategy
- ✅ Test types to perform
- ✅ Environment setup (high-level)
- ✅ Coverage targets (high-level)
- ✅ Schedule and resources
- ❌ No specific test spec list
- ❌ No test fixtures
- ❌ No run commands

**Test Suites contain:**
- ❌ No overall strategy
- ✅ Specific test spec list
- ✅ Shared test fixtures
- ✅ Coverage goals (specific %)
- ✅ Run commands
- ✅ CI/CD integration
- ✅ Execution order

**Verdict:** ✅ **No overlap** — Test plans define strategy, test suites organize execution

---

## Workflow Flow

```
Phase 1: DEFINE
  ↓
Requirement (with scenarios)
  - User narratives
  - Acceptance criteria
  - Orchestration metadata
  
Phase 2: DESIGN
  ↓
Test Plan
  - Testing strategy
  - Coverage targets
  - Resources & schedule
  
Phase 3: BUILD
  ↓
Test Specs (individual test cases)
  - Given/When/Then test cases
  - Converts scenario AC to tests
  ↓
Test Suite (groups test specs)
  - Organizes test specs
  - Shared fixtures
  - Run commands
  ↓
Tasks (implementation)
  - Implements to pass tests
```

---

## Relationship Between Artifacts

### Scenarios → Test Plans
**Relationship:** Test plans reference scenarios to understand WHAT needs testing

```yaml
# test-plan
soft-deps:
  - req-user-authentication  # reads scenarios from requirement
```

**Flow:**
1. BA writes scenarios in requirement
2. QA reads scenarios to understand acceptance criteria
3. QA creates test plan defining HOW to verify those scenarios

---

### Scenarios → Test Specs
**Relationship:** Test specs convert scenario AC to executable tests

```yaml
# test-spec
scenario: req-user-authentication#scenario-1  # links to specific scenario
```

**Flow:**
1. BA writes scenario with acceptance criteria
2. QA converts each AC to test case (Given/When/Then)
3. Test spec explicitly links to scenario via `scenario` field

---

### Test Plans → Test Suites
**Relationship:** Test suites implement the strategy defined in test plans

```yaml
# test-suite
soft-deps:
  - tp-user-authentication  # optional reference to test plan
```

**Flow:**
1. Test plan defines coverage targets (e.g., 80% line coverage)
2. Test suite groups test specs to achieve those targets
3. Test suite includes run commands and CI/CD integration

---

## Recommendation

### ✅ **Keep All Three Artifact Types — No Consolidation Needed**

**Rationale:**

1. **Different purposes:**
   - Scenarios = WHAT to build (business value)
   - Test plans = HOW to test (strategy)
   - Test suites = Test organization (execution)

2. **Different owners:**
   - Scenarios = Business Analyst
   - Test plans & suites = QA Engineer

3. **Different phases:**
   - Scenarios = Phase 1 (DEFINE)
   - Test plans = Phase 2 (DESIGN)
   - Test suites = Phase 3 (BUILD)

4. **Different audiences:**
   - Scenarios = Product team, engineers, QA
   - Test plans = QA team, stakeholders
   - Test suites = QA engineers, CI/CD systems

5. **Complementary, not redundant:**
   - Scenarios provide the "what" that test plans strategize about
   - Test plans provide the strategy that test suites execute
   - Test suites provide the organization that scenarios don't need

---

## Potential Confusion Points

### ❓ "Don't scenarios and test plans both define scope?"

**Answer:** Different types of scope:
- **Scenario scope:** What user functionality is included/excluded
- **Test plan scope:** What testing activities are included/excluded

**Example:**
- Scenario: "In scope: email/password login. Out of scope: OAuth"
- Test plan: "In scope: unit + integration tests. Out of scope: load testing"

---

### ❓ "Don't scenarios and test suites both have acceptance criteria?"

**Answer:** Different types of criteria:
- **Scenario AC:** Business acceptance (user-facing behavior)
- **Test suite coverage goals:** Technical acceptance (code coverage %)

**Example:**
- Scenario AC: "Given valid credentials, then user is logged in"
- Test suite goal: "Line coverage: 85%, branch coverage: 80%"

---

### ❓ "Can I skip test plans and just use test suites?"

**Answer:** Not recommended for complex features:
- Test plans define the **strategy** (what types of tests, what coverage, what risks)
- Test suites define the **execution** (which test specs, how to run them)
- Without test plans, you lose strategic planning and risk assessment
- For very simple features, test plans can be minimal (but still useful)

---

## Best Practices

### 1. Scenarios (in Requirements)
✅ **Do:**
- Write user-facing acceptance criteria
- Include orchestration metadata (priority, effort, timeline)
- Focus on business value and user outcomes
- Keep scenarios at feature/module level

❌ **Don't:**
- Include testing strategy details
- Specify test coverage percentages
- Define test fixtures or run commands
- Write implementation-level test cases

---

### 2. Test Plans
✅ **Do:**
- Define overall testing strategy
- Set coverage targets and quality gates
- Identify risks and mitigation strategies
- Reference scenarios to understand what to test

❌ **Don't:**
- Duplicate scenario acceptance criteria
- List individual test cases (that's test-specs)
- Include test fixtures (that's test-suites)
- Write user narratives (that's scenarios)

---

### 3. Test Suites
✅ **Do:**
- Group related test-specs
- Define shared fixtures and test data
- Provide run commands and CI/CD integration
- Set specific coverage goals

❌ **Don't:**
- Duplicate testing strategy (that's test-plans)
- Write user narratives (that's scenarios)
- Define individual test cases (that's test-specs)
- Include business acceptance criteria

---

## Summary

| Artifact | Purpose | Phase | Owner | Keep? |
|----------|---------|-------|-------|-------|
| **Scenarios** | Define WHAT to build | DEFINE | BA | ✅ Yes |
| **Test Plans** | Define HOW to test | DESIGN | QA | ✅ Yes |
| **Test Suites** | Organize test execution | BUILD | QA | ✅ Yes |

**Verdict:** ✅ **No overlap — all three artifacts serve distinct purposes**

---

## Example: User Authentication Feature

### Scenario (in Requirement)
```markdown
### Scenario 1: Successful Login
**Priority:** P0
**Timeline:** Sprint 1

**Narrative:** As a registered user, I want to log in...

**Acceptance Criteria:**
- [ ] Given valid credentials, then redirect to dashboard
- [ ] Given valid credentials, then session token created
```

### Test Plan
```markdown
## Testing Strategy
- Unit tests: 80% coverage, mock database
- Integration tests: 70% coverage, test database
- E2E tests: 50% coverage, full stack

## Risks
- Session token expiry edge cases
- Concurrent login attempts
```

### Test Suite
```markdown
## Test Specs Included
- ts-login-validation (unit)
- ts-session-mgmt (unit)
- ts-login-e2e (e2e)

## Shared Fixtures
- Mock user database
- Test session store

## Run Commands
```bash
npm test -- suite-user-authentication
```
```

**All three artifacts work together without duplication.**
