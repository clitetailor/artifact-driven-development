---
id: tp-{feature}-{descriptor}
type: test-plan
owner: qa-engineer
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
soft-deps:
  - req-{slug}
refs:
  - req-{slug}
---

# Test Plan: {title}

## Scope

### In Scope
<!-- Features, modules, or user flows covered by this test plan -->
- 
- 

### Out of Scope
<!-- Explicitly excluded from this test plan -->
- 
- 

## Testing Strategy

### Test Levels

| Level | Coverage Target | Approach | Tools |
|-------|----------------|----------|-------|
| Unit | {percentage}% | {description} | {test framework} |
| Integration | {percentage}% | {description} | {test framework} |
| E2E | {percentage}% | {description} | {test framework} |

### Test Types

- [ ] **Functional Testing**: Verify features work as specified
- [ ] **Regression Testing**: Ensure existing functionality remains intact
- [ ] **Performance Testing**: Validate response times and throughput
- [ ] **Security Testing**: Check authentication, authorization, data protection
- [ ] **Usability Testing**: Verify user experience and accessibility
- [ ] **Compatibility Testing**: Test across browsers/devices/platforms

## Test Environment

### Development
- **Purpose**: Developer local testing
- **Setup**: 
- **Data**: 

### Staging
- **Purpose**: Pre-production validation
- **Setup**: 
- **Data**: 

### CI/CD
- **Purpose**: Automated test execution
- **Setup**: 
- **Data**: 

## Test Data Strategy

### Data Requirements
- 
- 

### Data Generation
<!-- How test data will be created and maintained -->
- 

### Data Privacy
<!-- How sensitive data is handled in testing -->
- 

## Test Deliverables

### Test Specs
<!-- List of test-spec artifacts to be created -->
- ts-{slug}
- ts-{slug}

### Test Suites
<!-- List of test-suite artifacts to be created -->
- suite-{slug}

## Entry Criteria
<!-- Conditions that must be met before testing begins -->
- [ ] Requirements are accepted
- [ ] API contracts are defined
- [ ] Test environment is ready
- [ ] Test data is available

## Exit Criteria
<!-- Conditions that must be met to complete testing -->
- [ ] All test specs executed
- [ ] Coverage targets met
- [ ] Critical defects resolved
- [ ] Test reports generated

## Risk Assessment

### High Risk Areas
<!-- Features or components with highest risk of defects -->
- **Area**: 
  - **Risk**: 
  - **Mitigation**: 

### Testing Risks
<!-- Risks to the testing process itself -->
- **Risk**: 
  - **Impact**: 
  - **Mitigation**: 

## Schedule

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| Test plan approved | {date} | draft |
| Test specs created | {date} | pending |
| Test environment ready | {date} | pending |
| Testing complete | {date} | pending |

## Resources

### Team
- **QA Engineer**: {name}
- **Developers**: {names}
- **Product Owner**: {name}

### Tools
- **Test Framework**: 
- **CI/CD**: 
- **Test Management**: 
- **Bug Tracking**: 

## Defect Management

### Severity Levels
- **Critical**: System crash, data loss, security breach
- **High**: Major functionality broken, no workaround
- **Medium**: Functionality impaired, workaround exists
- **Low**: Minor issue, cosmetic defect

### Defect Workflow
1. 
2. 
3. 

## Reporting

### Test Reports
- **Frequency**: {daily | weekly | per build}
- **Format**: {description}
- **Distribution**: {stakeholders}

### Metrics Tracked
- Test execution rate
- Pass/fail rate
- Code coverage
- Defect density
- Defect resolution time

## Sign-off

### Approvers
- [ ] QA Lead
- [ ] Software Architect
- [ ] Product Owner
