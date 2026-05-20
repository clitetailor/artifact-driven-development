# TDD Workflow: Current vs Option A — Quick Summary

---

## Side-by-Side Comparison

### Current Workflow (with stories)

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1: Requirements (BA)                                  │
├─────────────────────────────────────────────────────────────┤
│ 1. Write requirement/req-user-authentication.md             │
│    - Functional requirements table                          │
│                                                             │
│ 2. Write stories/story-successful-login.md                  │
│    - User narrative                                         │
│    - Acceptance criteria ← QA reads this                    │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 2: Test Planning (QA)                                 │
├─────────────────────────────────────────────────────────────┤
│ 3. Write test-plans/tp-user-authentication.md               │
│    soft-deps:                                               │
│      - req-user-authentication                              │
│      - story-successful-login ← refs story                  │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 3: Test Specs (QA) — TEST-FIRST                       │
├─────────────────────────────────────────────────────────────┤
│ 4. Write test-specs/ts-user-authentication-login.md         │
│    soft-deps:                                               │
│      - story-successful-login ← reads story AC              │
│      - req-user-authentication                              │
│                                                             │
│    Test cases (converted from story AC):                    │
│      TC1: test_valid_credentials_redirects                  │
│      TC2: test_session_token_created                        │
│      TC3: test_invalid_credentials_error                    │
│                                                             │
│ 5. Write test-suites/suite-user-authentication.md           │
│    soft-deps: ts-user-authentication-login                  │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 4: Implementation (Engineer)                          │
├─────────────────────────────────────────────────────────────┤
│ 6. Write tasks/task-login-validation-be.md                  │
│    soft-deps:                                               │
│      - ts-user-authentication-login ← must pass these       │
│      - story-successful-login                               │
│                                                             │
│ 7. Implement code to pass tests                             │
│    - Run tests (all fail initially)                         │
│    - Write code                                             │
│    - Run tests (all pass)                                   │
│                                                             │
│ 8. QA updates test-spec status: accepted                    │
└─────────────────────────────────────────────────────────────┘
```

---

### Option A Workflow (with scenarios)

```
┌─────────────────────────────────────────────────────────────┐
│ PHASE 1: Requirements (BA)                                  │
├─────────────────────────────────────────────────────────────┤
│ 1. Write requirement/req-user-authentication.md             │
│    - Functional requirements table                          │
│    - Scenario 1: Successful Login (embedded)                │
│      - User narrative                                       │
│      - Acceptance criteria ← QA reads this                  │
│      - Priority, effort, timeline                           │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 2: Test Planning (QA)                                 │
├─────────────────────────────────────────────────────────────┤
│ 2. Write test-plans/tp-user-authentication.md               │
│    soft-deps:                                               │
│      - req-user-authentication ← refs requirement only      │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 3: Test Specs (QA) — TEST-FIRST                       │
├─────────────────────────────────────────────────────────────┤
│ 3. Write test-specs/ts-user-authentication-login.md         │
│    soft-deps:                                               │
│      - req-user-authentication ← reads scenario AC from req │
│    scenario: req-user-authentication#scenario-1 ← NEW       │
│                                                             │
│    Test cases (converted from scenario AC):                 │
│      TC1: test_valid_credentials_redirects                  │
│      TC2: test_session_token_created                        │
│      TC3: test_invalid_credentials_error                    │
│                                                             │
│ 4. Write test-suites/suite-user-authentication.md           │
│    soft-deps: ts-user-authentication-login                  │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ PHASE 4: Implementation (Engineer)                          │
├─────────────────────────────────────────────────────────────┤
│ 5. Write tasks/task-login-validation-be.md                  │
│    soft-deps:                                               │
│      - ts-user-authentication-login ← must pass these       │
│    scenario: req-user-authentication#scenario-1 ← NEW       │
│                                                             │
│ 6. Implement code to pass tests                             │
│    - Run tests (all fail initially)                         │
│    - Write code                                             │
│    - Run tests (all pass)                                   │
│                                                             │
│ 7. QA updates test-spec status: accepted                    │
└─────────────────────────────────────────────────────────────┘
```

---

## What Changed?

| Aspect | Current | Option A |
|--------|---------|----------|
| **Files created** | 8 files | 7 files (-1 story file) |
| **BA writes** | Requirement + Story | Requirement (with scenario) |
| **QA reads AC from** | Separate story file | Requirement doc (scenario section) |
| **Test-plan refs** | Requirement + Story | Requirement only |
| **Test-spec refs** | Story + Requirement | Requirement only |
| **Test-spec traceability** | `soft-deps: story-{slug}` | `scenario: req-{slug}#scenario-N` |
| **Task traceability** | `soft-deps: story-{slug}` | `scenario: req-{slug}#scenario-N` |
| **AC duplication** | Yes (req + story) | No (scenario in req) |

---

## What Stayed the Same?

✅ Test-first development cycle (write tests before code)  
✅ Test spec structure (Given/When/Then)  
✅ Test suite grouping  
✅ Coverage tracking  
✅ TDD cycle (test → implement → verify)  
✅ Test execution process  
✅ QA engineer role and responsibilities  

---

## Key Insight

**The TDD workflow is identical except for WHERE the QA engineer reads acceptance criteria:**

- **Current:** Read from `stories/story-{slug}.md`
- **Option A:** Read from `requirements/req-{slug}.md` (scenario section)

**Everything else (test creation, test execution, coverage tracking) is unchanged.**

---

## Traceability Examples

### Current: Find tests for a story

```bash
# Find test specs covering story-successful-login
rg -l "story-successful-login" test-specs/
# → ts-user-authentication-login.md

# Find tasks implementing story-successful-login
rg -l "story-successful-login" tasks/
# → task-login-validation-be.md
```

---

### Option A: Find tests for a scenario

```bash
# Find test specs covering scenario-1
rg -l "scenario: req-user-authentication#scenario-1" test-specs/
# → ts-user-authentication-login.md

# Find tasks implementing scenario-1
rg -l "scenario: req-user-authentication#scenario-1" tasks/
# → task-login-validation-be.md
```

**Same traceability, different query field.**

---

## Validation Result

### ✅ TDD Workflow Fully Compatible

**Option A maintains all TDD capabilities:**
- Test-first development ✓
- AC → test case conversion ✓
- Test suite organization ✓
- Coverage tracking ✓
- Traceability ✓

**Benefits:**
- Fewer files to maintain
- No AC duplication
- Better context (scenarios near requirements)
- Explicit scenario traceability via `scenario` field

**Migration effort:** Low — update templates, no test code changes
