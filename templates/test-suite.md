---
id: suite-{feature}-{descriptor}
type: test-suite
owner: qa-engineer
status: draft
version: 1.0
charter: {charter-slug}
prd: {charter-slug}/{prd-slug}
refs:
  - ts-{feature}-{descriptor}
  - ts-{feature}-{descriptor}
---

# Test Suite: {title}

## Scope
<!-- What functionality this suite covers -->

## Test Specs Included

| Test Spec ID | Description | Test Level | Status |
|--------------|-------------|------------|--------|
| ts-{slug}    | {desc}      | unit       | draft  |
| ts-{slug}    | {desc}      | unit       | draft  |

## Coverage Goals

### Overall Target
- **Line Coverage**: {percentage}%
- **Branch Coverage**: {percentage}%
- **Function Coverage**: {percentage}%

### Critical Paths
<!-- Paths that MUST have 100% coverage -->
- 
- 

## Shared Test Fixtures

### Fixture: {name}
```
{fixture data or setup code}
```

**Used by**:
- ts-{slug}
- ts-{slug}

---

## Test Data Requirements

### Data Set: {name}
- **Type**: {mock | seed | fixture}
- **Location**: `{path or description}`
- **Purpose**: 

## Test Environment

### Prerequisites
- 
- 

### Configuration
```
{environment variables or config needed}
```

## Execution Order
<!-- If tests must run in specific order, document here -->
1. 
2. 

## Known Limitations
<!-- Test gaps, deferred scenarios, or technical constraints -->
- 

## Run Commands

### Run entire suite
```bash
{command}
```

### Run specific test spec
```bash
{command}
```

### Run with coverage
```bash
{command}
```

## CI/CD Integration
<!-- How this suite fits into automated testing pipeline -->
- **Trigger**: {on commit | on PR | nightly}
- **Failure Policy**: {block merge | warn only}
- **Timeout**: {duration}
