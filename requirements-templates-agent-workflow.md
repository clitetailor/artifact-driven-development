# Requirements Templates — Agent-Workflow Restructuring

Concrete structural changes for the three retained requirements roots (`prd`, `feature-brief`, `press-release`), grouped by type. Focus is on what genuinely helps agents (stateless, artifact-by-artifact, need explicit signals) and avoiding over-engineering.

## Cross-cutting: add to all three roots

### 1. Add `## User Stories` traceability table to prd and press-release

feature-brief has a `## User Stories` list; prd and press-release don't — yet all three are requirements roots that spawn user-stories. This is a real gap: the default root (prd) has no child-index section, and press-release is a pipeline dead end without it.

A bare list isn't enough — it can't answer "which requirements have no story yet?" A traceability table maps each functional requirement to its spawned story, enabling coverage verification.

**Add to prd and press-release:**
```markdown
## User Stories
<!-- Stories extracted from this root. Maps functional requirements to spawned stories
     for coverage verification — every requirement should have at least one story. -->

| Requirement | Story | Summary |
|-------------|-------|---------|
| FR-1 | story-{slug} | {one-line summary} |
| FR-2 | story-{slug}, story-{slug} | {one-line summary} |
```

For feature-brief, replace its existing simple list with the same table form, using `Key Req` instead of `FR-#` in the `Requirement` column (matches its `Key Requirements` section). For press-release, the `Requirement` column references the `Key Requirements` entries added in point 8.

This gives the business-analyst agent an explicit place to record what it has spawned, lets an agent grep "which requirements have no story?" for coverage checks, and gives downstream agents a single section to verify child coverage without parsing `refs`.

### 2. Restructure `## Open Questions` into a tracked table

Current: a bare list of `- `. Agents can't tell which questions block downstream work or whether they're resolved.

**Replace with:**
```markdown
## Open Questions

| # | Question | Status | Resolution | Blocks downstream? |
|---|----------|--------|------------|---------------------|
| 1 |          | open \| resolved |        | yes \| no           |
```

This lets an agent scanning the root immediately see: are there unresolved blockers before I start extracting user-stories? The "Blocks downstream?" column is the critical agent signal — it tells the next agent whether to proceed or wait.

### 3. Add `children:` to frontmatter

Currently parent→child relationships live only in body prose (`## User Stories` section). `refs` is bidirectional and ambiguous — it doesn't distinguish "these are my upstream deps" from "these are children I spawned."

**Add to frontmatter:**
```yaml
children:
  - story-{slug}
```

This makes the spawn relationship machine-queryable (grep `children:` in frontmatter → instant child index) without parsing body text. Agents can verify "has this root spawned its stories yet?" in one grep.

### 4. Add `## Pipeline Next Steps` section

Agents are stateless between sessions. The dep graph tells them what comes next, but they have to load `reference/artifact-dep-graph.md` to find out. Embedding the immediate downstream handoff in the root itself saves a lookup.

**Add to all three roots:**
```markdown
## Pipeline Next Steps
<!-- What the downstream pipeline expects to build from this root. -->
- [ ] Extract user-stories from Functional Requirements / Key Requirements
- [ ] product-designer → user-flow (from this root)
- [ ] software-architect → system-architecture (from this root)
```

This is a checklist the root-owning agent updates as children are spawned. It doubles as a progress indicator and a handoff instruction.

## Cross-cutting: remove

### 5. Remove `What's Being Said Internally` from press-release

Already established — agent intent lives in prd `Background` / `Objectives`. A fake internal quote from an agent is redundant theater. Drop the section.

### 6. Simplify press-release customer-quote attribution

Current: `> "{quote}" — {Name, Title, Company}` — the Name/Title/Company is fictional in agent context. The quote's value is the concrete value-prop commitment, not the fake attribution.

**Replace with:**
```markdown
> "{Customer quote describing the impact}" — {persona label}
```

Use the persona from Target Audience (e.g., "— SMB ops manager") instead of inventing a name and company. Keeps the forcing-function (concrete customer voice) without the fiction.

### 7. Drop `Timeline & Milestones` from prd entirely

In an agent workflow there is no real timeline — agents execute artifact-to-artifact, not on a calendar. Sequencing is dependency-based (dep graph), priority lives in user-story `priority` frontmatter, and execution order lives in the plan. A "Timeline & Milestones" section in the requirements root either duplicates these or invents fake calendar dates agents can't use.

External deadlines (compliance, partner commitments) are rare and have no natural home in a pure agent workflow; if they exist, they surface as constraints during planning, not as a timeline section in the requirements root.

**Remove the entire `## Timeline & Milestones` section from prd.** No replacement.

## Per-template: press-release needs pipeline integration

press-release currently has no `Scope`, no `Success Metrics`, no `Key Requirements`, and no `User Stories`. If it stays as a root alternative, it needs the same pipeline hooks as the others — otherwise it's a dead end (the exact problem that killed one-pager).

### 8. Add these sections to press-release:

```markdown
## Scope
### In Scope
- 
### Out of Scope
- 

## Success Metrics
| Metric | Target | Measurement Source |
|--------|--------|--------------------|
|        |        |                    |

## Key Requirements
<!-- Plain-English capabilities the product must have, extracted from The Solution above. -->
1. 
2. 
```

This preserves the working-backwards method (Problem/Solution/customer quote/Getting Started) while adding the pipeline-integration sections that let it spawn user-stories. The `Key Requirements` section explicitly bridges the narrative form to the extractable capabilities — agents extract stories from "Key Requirements," not from the prose "The Solution."

## Per-template: tighten prd

### 9. Add `## Definition of Done` to prd

Agents need explicit self-evaluation criteria before marking `status: ready-for-review`. Currently "is this prd complete?" is implicit.

**Add:**
```markdown
## Definition of Done
<!-- The business-analyst agent checks these before flipping status to ready-for-review. -->
- [ ] Problem Statement frames pain from customer perspective
- [ ] ≥1 Objective with measurable Success Signal + Target
- [ ] Scope (In/Out) explicitly bounded
- [ ] ≥1 Functional Requirement numbered
- [ ] Open Questions reviewed; blockers flagged
- [ ] User Stories section populated (or explicitly "none yet — deferred")
```

This is a self-check that prevents agents from marking incomplete work ready. feature-brief and press-release should get equivalent (shorter) versions.

### 10. Tighten `Target Audience` table

Current: `Persona | Context | Primary Need` — "Primary Need" overlaps with Problem Statement. In agent context, the useful signal is *who* and *what context they're in*, not a restatement of the problem.

**Simplify to:**
```markdown
## Target Audience

| Persona | Segment / Context |
|---------|-------------------|
|         |                   |
```

"Primary Need" is already covered by Problem Statement + Objectives. Removing it prevents agents from duplicating content across sections.

## What NOT to change

- **Frontmatter schema** (id, type, owner, status, version, refs) — solid, don't touch
- **Scope (In/Out)** — works well as-is for agents
- **Functional Requirements as numbered list** — good for traceability, keep
- **References section** — keep as-is
- **feature-brief's existing structure** — it's already the most pipeline-fit of the three; the cross-cutting additions (Open Questions table, children frontmatter, Pipeline Next Steps) apply, but no template-specific restructure needed
- **The comment placeholders** (`<!-- ... -->`) — they're light-touch guidance that helps agents without over-constraining. Keep.

## Summary of changes

| Change | Affects | Type |
|---|---|---|
| Add `## User Stories` traceability table | prd, press-release; restructure feature-brief's existing list | Add / Restructure |
| Restructure Open Questions → tracked table | all three | Restructure |
| Add `children:` frontmatter | all three | Add |
| Add `## Pipeline Next Steps` | all three | Add |
| Remove `What's Being Said Internally` | press-release | Remove |
| Simplify customer-quote attribution | press-release | Restructure |
| Drop `Timeline & Milestones` section | prd | Remove |
| Add Scope + Success Metrics + Key Requirements | press-release | Add |
| Add `## Definition of Done` | prd (full), feature-brief + press-release (short) | Add |
| Simplify Target Audience table | prd | Restructure |

The throughline: **make pipeline relationships machine-readable, make blockers explicit, and give agents self-evaluation criteria.** The three roots should share the same pipeline-hook sections (User Stories, Open Questions table, Pipeline Next Steps, children frontmatter) so downstream agents can treat them uniformly regardless of which root type spawned them.
