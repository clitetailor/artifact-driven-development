---
id: tp-{slug}
type: test-plan
owner: qa-engineer
status: draft
version: 1.0
feature: {feature-id}
refs:
  - {story-id}
  - {api-id}
---

# Test Plan: {title}

## Scope

### In Scope
<!-- Features, modules, or user flows covered -->
- 
- 

### Out of Scope
<!-- Explicitly excluded -->
- 
- 

## Testing Strategy

| Level | Coverage Target | Approach | Tools |
|-------|----------------|----------|-------|
| Unit | {percentage}% | {description} | {test framework} |
| Integration | {percentage}% | {description} | {test framework} |
| E2E | {percentage}% | {description} | {test framework} |

## Test Environment
<!-- Development, staging, CI/CD setup. -->

## Pipeline Next Steps
<!-- After this plan is accepted, create or update the domain's test-spec (ts-{domain}). -->
- Create `ts-{domain}` the first time a domain receives tests; update it in place thereafter.
- Carry test cases, edge cases, and error cases into `test-spec` as the long-lived regression suite.

## Open Questions
- [ ] 

## References
- {story-link}
- {api-link}
