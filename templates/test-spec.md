---
id: ts-{feature}-{descriptor}
type: test-spec
owner: qa-engineer
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
test-level: unit
scenario: req-{slug}#scenario-{N}
refs:
  - req-{slug}
---

# Test Spec: {title}

## Test Level
<!-- unit | integration | e2e -->
unit

## Target Under Test
<!-- Component, function, class, or module being tested -->
- **Type**: {function | class | component | module}
- **Location**: `{file-path}`
- **Name**: `{identifier}`

## Test Cases

### TC-1: {test case name}

**Given**:
- 

**When**:
- 

**Then**:
- 

**Test Data**:
```
{input data or fixtures}
```

**Expected Output**:
```
{expected result}
```

---

### TC-2: {test case name}

**Given**:
- 

**When**:
- 

**Then**:
- 

**Test Data**:
```
{input data or fixtures}
```

**Expected Output**:
```
{expected result}
```

---

## Edge Cases

### EC-1: {edge case name}
- **Condition**: 
- **Expected Behavior**: 

### EC-2: {edge case name}
- **Condition**: 
- **Expected Behavior**: 

## Error Cases

### ERR-1: {error case name}
- **Trigger**: 
- **Expected Error**: 
- **Error Message**: 

## Test Dependencies
<!-- External services, databases, or fixtures required -->
- 
- 

## Mocking Strategy
<!-- What needs to be mocked and why -->
- 

## Coverage Target
<!-- Expected code coverage percentage for this spec -->
{percentage}%

## Notes
<!-- Implementation hints, gotchas, or special considerations -->
