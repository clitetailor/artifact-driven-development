# Early User-Story Drafting — Implications

Findings from examining how `user-story` can be drafted before `tech-design`, `task`, and `plan` in the dependency graph. Covers implications for the user-story and tech-design templates, and the lifecycle interaction between them.

## Why user-stories can be drafted early

From `reference/artifact-dep-graph.md`, the creation order is:

```
prd → user-story → system-architecture → tech-design → plan
```

At PRD drafting time, none of these exist yet: no user-stories, no architecture, no tech-design, no plan. The PRD is the first artifact in the chain.

User-stories require only `prd` because they are **requirements decomposition, not technical decomposition**:

| Artifact | Question it answers | Input needed |
|---|---|---|
| user-story | WHAT + WHY (in user terms) | prd only |
| tech-design | HOW (technical approach) | system-architecture + prd |
| task | WHAT TO DO (implementation steps) | tech-design |
| plan | WHEN + IN WHAT ORDER | tech-design + user-story |

A user-story says: "As a {persona}, I want {capability}, so that {value}" + testable acceptance criteria. None of this requires knowing the technical implementation. The BA decomposes the PRD's functional requirements into user-valued units — a requirements activity, not an engineering one.

The plan is the convergence point: it needs WHAT to build (stories) and HOW to build it (tech-design) before sequencing execution. This is why plan is 4 hops downstream from PRD. The dep graph is correct here.

## Implications

### 1. Acceptance criteria may need revision after tech-design

Tech-design might reveal that an acceptance criterion is technically infeasible, needs adjustment, or implies a different testing approach. When tech-design is accepted, affected user-stories should flip to `status: needs-review`.

This is already handled by the lifecycle system (`needs-review` exists for exactly this — "was accepted, but an upstream changed"). But agents need to know to trigger it. Currently nothing in tech-design's template says "flag affected user-stories as needs-review."

**Action:** tech-design template should add a checklist item: "Flag affected user-stories as needs-review if acceptance criteria must change."

### 2. `estimated-hours` in user-story is a guess

At PRD time, the BA estimates effort without technical context. These estimates are unreliable. The plan's "Estimates vs Actuals" table is the trustworthy version — but it's populated much later.

**Action:** user-story template should mark `estimated-hours` as provisional via a comment, so agents don't treat it as reliable.

### 3. `depends-on` between stories is incomplete

At PRD time, the BA knows *business* dependencies (story A must come before story B because of user flow). But *technical* dependencies (story A's API needed by story B's frontend) only emerge after tech-design. So `depends-on` may need updates post-tech-design.

**Action:** same as #1 — when tech-design reveals technical dependencies between stories, affected stories should be updated and flagged `needs-review`.

### 4. user-story's `Execution Checklist (Sub-Tasks)` section is premature

The current user-story template has:
```markdown
## Execution Checklist (Sub-Tasks)
- [ ] {sub-task 1}
- [ ] {sub-task 2}
```

Sub-tasks are technical implementation steps — they can't be known at user-story drafting time (before tech-design). This section can only be filled later, likely by the engineer working from tech-design. It's in the wrong artifact or at the wrong time.

The `task` template already has its own `Execution Checklist (Sub-Tasks)` section, making user-story's version redundant.

**Action:** remove `## Execution Checklist (Sub-Tasks)` from the user-story template. Implementation sub-tasks belong in `task`, not `user-story`.

### 5. Plan requires both tech-design AND user-story — correct and load-bearing

The plan is the convergence point: it needs to know WHAT to build (stories) and HOW to build it (tech-design) before sequencing execution. This is why plan is 4 hops downstream from PRD. The dep graph is correct here — no action needed.

## Lifecycle interaction: tech-design → user-story

The `needs-review` trigger from tech-design → user-story is correct per the lifecycle but not explicitly instructed anywhere. When tech-design is accepted:

- Affected user-stories' acceptance criteria may need revision (implication 1)
- Inter-story `depends-on` may need updates (implication 3)
- Both cases should flip affected stories to `status: needs-review`

This interaction should be documented either in `reference/artifact-lifecycle.md` or in the tech-design template's Definition of Done / checklist.

## Summary of actions (outside requirements-templates report scope)

| Action | Affects | Type |
|---|---|---|
| Add "flag affected user-stories as needs-review" checklist item | tech-design template | Add |
| Mark `estimated-hours` as provisional | user-story template | Comment |
| Remove `Execution Checklist (Sub-Tasks)` section | user-story template | Remove |
| Document tech-design → user-story `needs-review` trigger | artifact-lifecycle.md or tech-design template | Add |
