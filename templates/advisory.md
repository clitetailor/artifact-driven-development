---
id: adv-{slug}
type: advisory
owner: orchestrator
status: open
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
hard-deps: []
soft-deps:
  - {concern-artifact-id}
refs:
  - {concern-artifact-id}
created: {YYYY-MM-DD}
---

# Advisory: {title}

## Concern
<!-- What was skipped, deferred, or flagged. Plain language. -->

## Affected Artifact
<!-- The artifact that triggered this advisory. -->
{artifact-id} — {artifact-title}

## Why It Matters
<!-- Risk if this is never resolved. Keep it concrete. -->

## Suggested Action
<!-- What should happen to close this advisory. -->

## Deferred By
<!-- User decision that created this advisory. -->
User proceeded at Gate {N} on {date} with this item unresolved.

---
<!-- Resolved when the concern is addressed.
     Update status to: resolved and add resolution note below. -->

## Resolution
**Status:** open
**Resolved:** ~
**Resolution note:** ~
