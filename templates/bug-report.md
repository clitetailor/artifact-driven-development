---
id: bug-{slug}
type: bug-report
owner: qa-engineer
status: open
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
severity: {critical | high | medium | low}
created: {YYYY-MM-DD}
resolved: ~
refs:
  - {affected-artifact-id}   # the artifact (api-contract, component-spec, etc.) whose behaviour is wrong
  - {task-fix-id}            # task created to fix this bug (fill once created; omit until then)
---

# Bug: {title}

## Summary
<!-- One-sentence description of the defect. -->

## Environment
- **Branch / version:** {branch-or-tag}
- **Platform / browser:** {platform}
- **Reproducibility:** always | intermittent | one-off

## Steps to Reproduce
1. 
2. 
3. 

## Expected Behaviour
<!-- What should happen. -->

## Actual Behaviour
<!-- What actually happens. Include error messages, stack traces, screenshots. -->

## Root Cause (optional)
<!-- Fill in once identified. Leave blank if unknown. -->

---

## Fix

### Resolution Path
<!-- Check one: -->
- [ ] Fix task created → `{task-fix-id}`
- [ ] Resolved directly (no separate task)

### Fix Notes
<!-- Brief description of what was changed to resolve the bug. Fill on resolution. -->

---

**Status:** open
**Resolved:** ~
**Resolution note:** ~
