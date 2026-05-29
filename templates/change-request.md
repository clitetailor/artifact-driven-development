---
id: cr-{slug}
type: change-request
owner: {filing-agent-slug}
status: open
version: 1.0
charter: {charter-slug}
prd: {charter-slug}/{prd-slug}
priority: {minor | major}
created: {YYYY-MM-DD}
resolved: ~
refs:
  - {target-artifact-id}      # the artifact being modified
  - {related-artifact-id}     # any sibling artifacts impacted
  - {triggering-artifact-id}  # the task or doc that surfaced the gap
---

# CR: {title}

## Problem
<!-- What is missing or incorrect in the target artifact.
     Be specific — name the field, endpoint, schema, or behavior. -->

## Proposed Change
<!-- Exact description of what should change. Concrete enough for the artifact owner to apply without further discussion. -->

## Justification
<!-- Which user story, PRD requirement, or implementation constraint requires this change. Link the artifact. -->

## Impact Assessment
- **Breaking:** yes / no
- **Migration needed:** yes / no
- **Downstream affected:** {list artifact IDs or "none"}
- **Charter re-approval needed:** yes / no <!-- only relevant when target is project-charter -->

---

## Decision
<!-- Filled by the artifact owner on resolution. Leave blank when filing. -->

**Status:** ~
**Reason:** ~
**Alternative (if rejected):** ~
