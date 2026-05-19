---
id: cr-{slug}
type: change-request
owner: {filing-agent-slug}
status: open
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
priority: {minor | major}
from: {filing-agent-slug}
to: {owning-agent-slug}
created: {YYYY-MM-DD}
resolved: ~

target:
  - {artifact-id}
also-affects: []
triggered-by: []
resulted-in: []

refs:
  - {artifact-id}
---

# CR: {title}

## Problem
<!-- What is missing or incorrect in the target artifact.
     Be specific — name the field, endpoint, schema, or behavior. -->

## Proposed Change
<!-- Exact description of what should change. Concrete enough for the artifact owner to apply without further discussion. -->

## Justification
<!-- Which story, requirement, or implementation constraint requires this change. Link the artifact. -->

## Impact Assessment
- **Breaking:** yes / no
- **Migration needed:** yes / no
- **Downstream affected:** {list artifact IDs or "none"}

---

## Decision
<!-- Filled by the artifact owner on resolution. Leave blank when filing. -->

**Status:** ~
**Reason:** ~
**Alternative (if rejected):** ~
