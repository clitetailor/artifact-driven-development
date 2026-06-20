---
id: pr-{slug}
type: press-release
owner: business-analyst
status: draft
version: 1.0
children: []
refs:
  - {related-artifact-id}
---

# Press Release: {title}

> Written "working backwards" — as if the product has already launched. This frames the customer outcome first and surfaces gaps in the value proposition before implementation begins.

**{City, State} — {Date}** — {One-sentence announcement of the product and the customer benefit.}

{2-3 sentence lede: who it is for, what it does, and why it matters now. Expand on the headline benefit.}

## The Problem
<!-- Describe the customer pain in their own words. Be specific about the friction, wasted time, or unmet need. -->

## The Solution
<!-- How the product works from the customer's perspective. Focus on the experience, not the implementation. -->

## What Customers Are Saying
<!-- A realistic quote from a hypothetical customer describing the impact. -->

> "{Customer quote describing the impact}" — {persona label}

## Scope

### In Scope
- 

### Out of Scope
- 

## Success Metrics
<!-- How we know the product is successful post-launch. -->

| Metric | Target | Measurement Source |
|--------|--------|--------------------|
|        |        |                    |

## Key Requirements
<!-- Plain-English capabilities the product must have, extracted from The Solution above. -->
1. 
2. 

## Getting Started
<!-- How a customer obtains or starts using the product. Availability, pricing tier, region, or rollout notes. -->

## User Stories
<!-- Stories extracted from this root. Maps key requirements to spawned stories
     for coverage verification — every requirement should have at least one story. -->

| Key Req | Story | Summary |
|---------|-------|---------|
| KR-1 | story-{slug} | {one-line summary} |
| KR-2 | story-{slug}, story-{slug} | {one-line summary} |

## Open Questions

| # | Question | Status | Resolution | Blocks downstream? |
|---|----------|--------|------------|---------------------|
| 1 |          | open \| resolved |        | yes \| no           |

## Pipeline Next Steps
<!-- What the downstream pipeline expects to build from this root. -->
- [ ] Extract user-stories from Key Requirements
- [ ] product-designer → user-flow (from this root)
- [ ] software-architect → system-architecture (from this root)

## Definition of Done
<!-- The business-analyst agent checks these before flipping status to ready-for-review. -->
- [ ] Problem and Solution framed from customer perspective
- [ ] ≥1 Success Metric with Target
- [ ] Scope (In/Out) explicitly bounded
- [ ] ≥1 Key Requirement numbered
- [ ] Customer quote articulates concrete value
- [ ] Open Questions reviewed; blockers flagged
- [ ] User Stories section populated (or explicitly "none yet — deferred")

## References
- [{related-artifact-id}](../{folder}/{related-artifact-id}.md)
