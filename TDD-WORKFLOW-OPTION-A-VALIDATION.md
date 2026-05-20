# TDD Workflow Validation: Option A
> How Test-Driven Development changes with scenario-based workflow

---

## Current TDD Workflow (with standalone stories)

### Artifact Flow

```
requirement → test-plan (DESIGN phase)
    ↓             ↓
  story    → test-spec → test-suite → task (BUILD phase)
    ↓           ↓           ↓          ↓
  (what)   (how to    (grouped   (implement
           verify)     tests)     to pass)
```

### Dependency Chain

```
requirement (functional requirements)
    ↓
story (user narrative + acceptance criteria)
    ↓
test-spec (Given/When/Then test cases)
    ↓
test-suite (grouped specs + coverage targets)
    ↓
task (implementation to pass tests)
```

### Test Spec Links to Story

```yaml
# test-spec
soft-deps:
  - story-successful-login  # ← links to standalone story
  - req-user-authentication
```

**Test spec reads:**
- Story acceptance criteria → convert to test cases
- Story preconditions → test setup
- Story error/edge cases → negative test cases

---

## Option A TDD Workflow (with embedded scenarios)

### Artifact Flow

```
requirement (with scenarios) → test-plan (DESIGN phase)
    ↓                              ↓
  scenario-1, scenario-2    → test-spec → test-suite → task (BUILD phase)
  (embedded in req)             ↓           ↓          ↓
    ↓                      (how to    (grouped   (implement
  (what)                    verify)     tests)     to pass)
```

### Dependency Chain

```
requirement (functional requirements + embedded scenarios)
    ↓
  scenario-1: Successful Login (embedded)
  scenario-2: Password Reset (embedded)
    ↓
test-spec (Given/When/Then test cases)
    ↓
test-suite (grouped specs + coverage targets)
    ↓
task (implementation to pass tests)
```

### Test Spec Links to Scenario

```yaml
# test-spec
soft-deps:
  - req-user-authentication  # ← links to requirement (contains scenarios)
scenario: req-user-authentication#scenario-1  # ← NEW: specific scenario anchor
```

**Test spec reads:**
- Scenario acceptance criteria (from requirement doc) → convert to test cases
- Scenario preconditions → test setup
- Scenario error/edge cases → negative test cases

---

## Key Changes

### 1. Test-Plan Template

**Before:**
```yaml
soft-deps:
  - req-{slug}
  - story-{slug}  # ← multiple story refs
refs:
  - req-{slug}
  - story-{slug}
```

**After:**
```yaml
soft-deps:
  - req-{slug}  # ← single requirement ref (contains all scenarios)
refs:
  - req-{slug}
```

**Impact:** Test plan references requirement doc, which contains all scenarios. No change to test plan content, just fewer refs.

---

### 2. Test-Spec Template

**Before:**
```yaml
soft-deps:
  - story-{slug}  # ← links to standalone story
  - req-{slug}
refs:
  - story-{slug}
  - req-{slug}
```

**After:**
```yaml
soft-deps:
  - req-{slug}  # ← links to requirement (contains scenarios)
scenario: req-{slug}#scenario-1  # ← NEW: specific scenario anchor
refs:
  - req-{slug}
```

**Impact:** Test spec links to specific scenario within requirement doc. QA engineer reads scenario AC from requirement doc instead of separate story file.

---

### 3. Test-Suite Template

**Before:**
```yaml
soft-deps:
  - ts-{slug}
  - ts-{slug}
  - tp-{slug}
```

**After:**
```yaml
# No change — test-suite links to test-specs, not stories
soft-deps:
  - ts-{slug}
  - ts-{slug}
  - tp-{slug}
```

**Impact:** No change. Test suites group test specs regardless of story vs scenario approach.

---

## TDD Cycle Comparison

### Current Cycle (with stories)

1. **Write story** with acceptance criteria
2. **Write test-spec** defining test cases for the story
3. **Create test-suite** grouping related specs
4. **Create task** to implement code that passes tests
5. **Implement** code in task
6. **Verify** all test cases pass
7. **Update** test-spec status to `accepted`

---

### Option A Cycle (with scenarios)

1. **Write scenario** (embedded in requirement) with acceptance criteria
2. **Write test-spec** defining test cases for the scenario
3. **Create test-suite** grouping related specs
4. **Create task** to implement code that passes tests
5. **Implement** code in task
6. **Verify** all test cases pass
7. **Update** test-spec status to `accepted`

**Difference:** Step 1 writes scenario in requirement doc instead of standalone story file. All other steps identical.

---

## Example: User Authentication Feature

### Current Approach

```
Files created:
1. requirements/req-user-authentication.md
   - Functional requirements table
   - Success metrics

2. stories/story-successful-login.md
   - User narrative
   - Acceptance criteria:
     ✓ Valid credentials → redirect
     ✓ Session token created
     ✓ Invalid credentials → error

3. test-plans/tp-user-authentication.md
   - refs: req-user-authentication, story-successful-login
   - Coverage target: 90%

4. test-specs/ts-user-authentication-login.md
   - soft-deps: story-successful-login
   - Test cases:
     TC1: test_valid_credentials_redirects_to_dashboard
     TC2: test_valid_credentials_creates_session_token
     TC3: test_invalid_credentials_shows_error

5. test-suites/suite-user-authentication.md
   - soft-deps: ts-user-authentication-login

6. tasks/task-login-validation-be.md
   - soft-deps: ts-user-authentication-login
   - Implement to pass tests
```

---

### Option A Approach

```
Files created:
1. requirements/req-user-authentication.md
   - Functional requirements table
   - Success metrics
   - Scenario 1: Successful Login (embedded)
     - User narrative
     - Acceptance criteria:
       ✓ Valid credentials → redirect
       ✓ Session token created
       ✓ Invalid credentials → error

2. test-plans/tp-user-authentication.md
   - refs: req-user-authentication (contains scenarios)
   - Coverage target: 90%

3. test-specs/ts-user-authentication-login.md
   - soft-deps: req-user-authentication
   - scenario: req-user-authentication#scenario-1  ← NEW
   - Test cases:
     TC1: test_valid_credentials_redirects_to_dashboard
     TC2: test_valid_credentials_creates_session_token
     TC3: test_invalid_credentials_shows_error

4. test-suites/suite-user-authentication.md
   - soft-deps: ts-user-authentication-login

5. tasks/task-login-validation-be.md
   - soft-deps: ts-user-authentication-login
   - scenario: req-user-authentication#scenario-1  ← NEW
   - Implement to pass tests
```

**Files eliminated:** `stories/story-successful-login.md`  
**Content preserved:** Scenario embedded in requirement doc  
**Test specs:** Link to scenario via anchor instead of separate file

---

## QA Engineer Workflow Changes

### Current Workflow

**Phase 1: Test Planning (DESIGN)**
1. Read requirement doc
2. Read story artifacts
3. Create test-plan referencing requirement + stories

**Phase 2: Test Spec Creation (BUILD)**
1. Read story acceptance criteria
2. Convert each AC to test case (Given/When/Then)
3. Create test-spec with soft-dep on story
4. Group test-specs into test-suite

---

### Option A Workflow

**Phase 1: Test Planning (DESIGN)**
1. Read requirement doc (includes scenarios)
2. ~~Read story artifacts~~ ← eliminated
3. Create test-plan referencing requirement

**Phase 2: Test Spec Creation (BUILD)**
1. Read scenario acceptance criteria (from requirement doc)
2. Convert each AC to test case (Given/When/Then)
3. Create test-spec with:
   - soft-dep on requirement
   - scenario field pointing to specific scenario
4. Group test-specs into test-suite

**Key change:** QA engineer reads scenarios from requirement doc instead of separate story files. Adds `scenario` field to test-spec frontmatter for traceability.

---

## Traceability Comparison

### Current Traceability

```
requirement → story → test-spec → task
```

**Query: Find test specs for a story**
```bash
rg -l "story-successful-login" test-specs/
```

**Query: Find which story a test spec covers**
```bash
grep "soft-deps:" test-specs/ts-user-authentication-login.md
# Returns: story-successful-login
```

---

### Option A Traceability

```
requirement (with scenarios) → test-spec → task
```

**Query: Find test specs for a scenario**
```bash
rg -l "scenario: req-user-authentication#scenario-1" test-specs/
```

**Query: Find which scenario a test spec covers**
```bash
grep "scenario:" test-specs/ts-user-authentication-login.md
# Returns: req-user-authentication#scenario-1
```

**Query: Read scenario details**
```bash
# Read requirement doc, navigate to scenario-1 section
cat requirements/req-user-authentication.md | sed -n '/### Scenario 1/,/### Scenario 2/p'
```

---

## Coverage Tracking Comparison

### Current Approach

**Coverage by story:**
```bash
# Find all test specs for a story
rg -l "story-successful-login" test-specs/

# Check which are accepted
rg -l "story-successful-login" test-specs/ | xargs rg -l "status: accepted"

# Coverage: X accepted / Y total test specs for story
```

---

### Option A Approach

**Coverage by scenario:**
```bash
# Find all test specs for a scenario
rg -l "scenario: req-user-authentication#scenario-1" test-specs/

# Check which are accepted
rg -l "scenario: req-user-authentication#scenario-1" test-specs/ | xargs rg -l "status: accepted"

# Coverage: X accepted / Y total test specs for scenario
```

**Same mechanism, different query field.**

---

## Test-First Development Flow

### Current Flow

```
1. BA writes story
   └─ story-successful-login.md

2. QA writes test-spec (reads story AC)
   └─ ts-user-authentication-login.md
      soft-deps: story-successful-login

3. Engineer writes task (reads test-spec)
   └─ task-login-validation-be.md
      soft-deps: ts-user-authentication-login, story-successful-login

4. Engineer implements to pass tests
   └─ Runs tests, verifies all pass

5. QA updates test-spec status: accepted
```

---

### Option A Flow

```
1. BA writes scenario (embedded in requirement)
   └─ requirements/req-user-authentication.md
      Scenario 1: Successful Login

2. QA writes test-spec (reads scenario AC from requirement)
   └─ ts-user-authentication-login.md
      soft-deps: req-user-authentication
      scenario: req-user-authentication#scenario-1

3. Engineer writes task (reads test-spec)
   └─ task-login-validation-be.md
      soft-deps: ts-user-authentication-login
      scenario: req-user-authentication#scenario-1

4. Engineer implements to pass tests
   └─ Runs tests, verifies all pass

5. QA updates test-spec status: accepted
```

**Difference:** Step 1 writes scenario in requirement instead of separate file. Step 2-5 identical except for reference format.

---

## Validation Results

### ✅ TDD Workflow Still Works

| Capability | Current | Option A | Status |
|------------|---------|----------|--------|
| Test plan creation | ✓ | ✓ | ✅ Works |
| Test spec creation | ✓ | ✓ | ✅ Works |
| Test suite grouping | ✓ | ✓ | ✅ Works |
| AC → test case conversion | ✓ | ✓ | ✅ Works |
| Test-first development | ✓ | ✓ | ✅ Works |
| Coverage tracking | ✓ | ✓ | ✅ Works |
| Traceability | ✓ | ✓ | ✅ Works |

---

### ✅ Benefits in Option A

1. **Fewer refs to maintain** — test-plan refs one requirement instead of multiple stories
2. **Better context** — QA reads scenario AC directly in requirement doc (sees full functional context)
3. **Shorter dependency chain** — requirement → test-spec (no story in middle)
4. **Explicit scenario link** — `scenario` field makes traceability clearer
5. **No duplication** — scenario AC not duplicated in story + requirement

---

### ⚠️ Minor Changes Required

1. **Test-plan template** — remove `story-{slug}` from soft-deps
2. **Test-spec template** — add `scenario` field, remove `story-{slug}` from soft-deps
3. **TDD workflow doc** — update artifact flow diagram to show scenarios instead of stories
4. **QA engineer workflow** — read scenarios from requirement docs instead of story files

---

## Migration Impact on Existing Tests

### Existing Test Artifacts

**If you have existing test-specs referencing stories:**

```yaml
# Old test-spec
soft-deps:
  - story-successful-login
  - req-user-authentication
```

**Migration steps:**
1. Identify which scenario the story became (e.g., scenario-1)
2. Update test-spec:
   ```yaml
   soft-deps:
     - req-user-authentication
   scenario: req-user-authentication#scenario-1
   ```
3. Verify test-spec still passes (AC unchanged, just location)

**No test code changes needed** — only frontmatter refs change.

---

## Updated TDD Workflow Doc

### Recommended Changes to `handbook/tdd-workflow.md`

**Line 10-16 (Artifact Flow):**
```diff
- requirement → test-plan (DESIGN phase)
-     ↓             ↓
-   story    → test-spec → test-suite → task (BUILD phase)
-     ↓           ↓           ↓          ↓
-   (what)   (how to    (grouped   (implement
-            verify)     tests)     to pass)

+ requirement (with scenarios) → test-plan (DESIGN phase)
+     ↓                              ↓
+   scenario-1, scenario-2    → test-spec → test-suite → task (BUILD phase)
+   (embedded in req)             ↓           ↓          ↓
+     ↓                      (how to    (grouped   (implement
+   (what)                    verify)     tests)     to pass)
```

**Line 26-30 (test-spec trigger):**
```diff
- - **Trigger**: After story is accepted and API/data contracts are defined
+ - **Trigger**: After requirement scenarios are defined and API/data contracts are defined
```

**Line 42-65 (Dependency Pattern):**
```diff
  # test-plan
  soft-deps:
    - req-{slug}
-   - story-{slug}

  # test-spec
  soft-deps:
-   - story-{slug}
    - req-{slug}
    - tp-{slug}  # optional reference to test plan
+ scenario: req-{slug}#scenario-N  # specific scenario being tested

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
+ scenario: req-{slug}#scenario-N  # scenario being implemented
```

**Line 86-92 (TDD Cycle):**
```diff
- 1. **Write test-spec** defining test cases for a story
+ 1. **Write test-spec** defining test cases for a scenario
  2. **Create test-suite** grouping related specs (optional for single specs)
  3. **Create task** to implement code that passes the tests
  4. **Implement** code in task
  5. **Verify** all test cases pass
  6. **Update** test-spec status to `accepted` when tests pass
```

---

## Conclusion

### ✅ TDD Workflow Fully Compatible with Option A

**No fundamental changes** to test-driven development process:
- Test plans still define strategy
- Test specs still convert AC to test cases
- Test suites still group specs
- Tasks still implement to pass tests
- Coverage tracking still works

**Only changes:**
- QA reads scenarios from requirement docs (not separate story files)
- Test specs link to scenarios via `scenario` field
- Fewer refs to maintain (one requirement instead of multiple stories)
- Better context (scenarios near functional requirements)

**Migration effort:** Low — update templates + frontmatter refs, no test code changes.

**Recommendation:** Option A is fully compatible with TDD workflow and provides better traceability with the new `scenario` field.
