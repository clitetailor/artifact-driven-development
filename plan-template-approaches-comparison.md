# Plan Templates: Semantic Differences & Approach Comparison

> Purpose: lay out what each planning model *means* as a thinking tool, and what each
> structural approach (one / two / three templates) gains and loses. Decide after reading.

---

## Part 1 — Semantic differences between the three planning models

The three templates aren't three layouts of the same information. They encode three
different planning questions, each serving a different phase of project thinking.

### `plan` — flat ordered list

**Semantic question:** "What do I do first, second, third?"

**Mental model:** Time is the only axis. Stories and tasks collapse into a single
timeline. Priority and dependencies are inline annotations on one list.

**What it optimizes for:** Execution readiness. You look at it and know the next action.

**When it's the right tool:**
- Small features where the work is mostly linear
- Solo development — no need to reason about parallelism
- When the team just needs a checklist with dependency gates
- Rapid planning where estimation precision matters less than sequencing

**What it sacrifices:** Scope sizing (no rollup), parallelism reasoning (lanes are inline
and easy to miss), story-vs-task separation (collapsed into one list).

---

### `implementation-plan` — story queue + task lanes

**Semantic question:** "Which story next, and within it, what runs in parallel?"

**Mental model:** Two-level scheduling. Stories are ordered by priority and dependency
(the queue — a story-level DAG). Within each story, backend and frontend tasks have their
own dependency graph (the lanes — a task-level DAG per story). The two levels are
explicitly separated.

**What it optimizes for:** Coordination. You can see at a glance which story is next,
which tasks within it can run in parallel, and where the blocking gates are.

**When it's the right tool:**
- Multi-person teams (especially be/fe split) — the lanes make parallelism visible
- Features with cross-story task dependencies (story-2's fe-task blocked by story-1's
  be-task — the lanes make this explicit)
- When you need to reason about who's blocked by whom, not just what's next
- Agent-assisted development — the queue gives the agent a normative rollout sequence,
  and the lanes tell it which tasks within a story can be dispatched in parallel

**What it sacrifices:** Simplicity (more structure than a solo dev needs), scope sizing
(no rollup — you'd have to sum the Est. Hours column manually).

---

### `work-breakdown-structure` — deliverable hierarchy + effort rollup

**Semantic question:** "How big is this, and what's it made of?"

**Mental model:** Structure is the primary axis, not time. The PRD decomposes into
stories, stories decompose into tasks — a tree. Each node carries estimated hours, and
`Σ` marks roll up the sums. Execution order is a lightweight afterthought (one ordered
list referencing tree nodes), not the centerpiece.

**What it optimizes for:** Scope sizing and stakeholder communication. You can answer
"how big is the P0 slice?" at a glance from the Effort Rollup table. The tree makes the
decomposition auditable — a stakeholder can see if anything is missing or under-specified.

**When it's the right tool:**
- Estimation-heavy contexts — when "how big" matters more than "what order"
- Scope negotiation — the rollup table gives you a number to push back with
- Stakeholder reporting — "P0 is 40h, P1 is 20h, here's the breakdown"
- Early in a project when decomposition quality matters more than execution sequencing
- PMI-influenced organizations where WBS is the expected planning artifact

**What it sacrifices:** Execution readiness (the Execution Order section is deliberately
lightweight — it's not a normative sequence), parallelism reasoning (no lanes), agent
coordination (no task-level DAG — the tree shows structure, not scheduling).

---

### Semantic axis summary

| Axis | `plan` | `ip` | `wbs` |
|---|---|---|---|
| Primary question | What order? | What order + what's parallel? | How big + what's it made of? |
| Temporal vs structural | Temporal | Temporal (two-level) | Structural |
| Flat vs layered vs hierarchical | Flat | Layered (queue + lanes) | Hierarchical (tree) |
| Execution vs estimation | Execution | Execution + coordination | Estimation + scope |
| Solo vs team vs stakeholder | Solo | Team (be/fe) | Stakeholder / PM |
| Story-task separation | Collapsed | Explicit (two levels) | Explicit (tree levels) |
| Parallelism visibility | Inline (easy to miss) | Explicit (lanes) | None |
| Effort rollup | None | None (manual sum) | Built-in (table + `Σ`) |
| Agent dispatch guidance | Implicit (read the list) | Strong (queue = rollout, lanes = parallel) | Weak (tree = structure, not schedule) |

**Key insight:** `plan` and `ip` answer the same question (what order?) at different
richness levels — `ip` is a strict superset of `plan`'s information. `wbs` answers a
*different question* (how big?) — it's not a richer or poorer version of `plan`, it's a
different planning act.

---

## Part 2 — Benefits of each structural approach

### Approach A — One template (merge all three, WBS as patch)

All three planning models live in `templates/plan.md`. The default body is the unified
plan+IP structure. WBS is a body-variant patch in `decisions/plan-type.md` that swaps the
sequencing sections for the hierarchy + rollup sections.

**Benefits:**

1. **Single source of truth for plan scaffolding.** Critical Path, Estimates vs Actuals,
   Risks, References — the bookkeeping footer exists in exactly one place. No duplication,
   no drift between copies.
2. **One "plan" concept in the vault.** Users who don't care about planning theory see one
   template and one artifact type. Simpler mental model: "you write a plan, and optionally
   switch its shape."
3. **One file to maintain.** Bug fixes, wording improvements, new shared sections — edit
   once, all variants inherit.
4. **Less folder clutter.** One `plans/` folder instead of three. One entry in
   `manifest.yaml`'s `types:` list.
5. **The decision file becomes the single switch.** Changing planning approach is one
   operation (apply the WBS patch or revert to default), not a choice between three
   separate templates.

**Costs:**

1. **Loses the temporal-vs-structural distinction at the type level.** Both shapes are
   `type: plan`. You can't tell from frontmatter whether a plan was sequenced or
   structured — you have to read the body.
2. **Breaks the current invariant** ("plan decisions don't touch templates"). The WBS
   patch edits `templates/plan.md`'s body — a new kind of operation the decision framework
   wasn't designed for.
3. **Requires a new `FORMAT.md` patch flavor** ("L1.5 — body patch") to describe section
   swaps, which don't fit the existing L1 (token concretize) / L2 (prose dereify) split.
4. **Vault queries by type can't distinguish WBS from plan.** `rg "type: work-breakdown-
   structure"` returns nothing — WBS plans are `type: plan`. You'd need a new convention
   (e.g. a `plan_variant:` frontmatter field) to recover filtering.
5. **Patch is fragile under upstream drift.** If upstream rewrites the Story Queue or Task
   Lanes section, the WBS patch's "replace this block" instruction may not locate the
   target. The current decision framework's drift-tolerance is built on token patterns and
   prose matching, not section-boundary matching.
6. **Existing WBS and IP artifacts need migration.** Files in `work-breakdown-structures/`
   and `implementation-plans/` must be renamed, moved, and re-frontmatter'd — or left
   orphaned with types that no longer exist in `manifest.yaml`.
7. **Hides the planning-model choice behind a patch step.** A new user browsing
   `templates/` sees one plan template and may never discover that a structural
   alternative exists — it's buried in a decision file they have to know to look for.

---

### Approach B — Two templates (merge IP into `plan`, keep WBS separate)

`plan` and `ip` fuse into one `templates/plan.md` (IP's richer structure wins, naming
normalized). `templates/work-breakdown-structure.md` stays as a separate template. The
decision file shrinks from 3 alternatives to 2.

**Benefits:**

1. **Captures the real overlap.** `plan` and `ip` are 85% conceptually shared — IP is a
   strict superset of plan's information. Merging them eliminates genuine redundancy
   without forcing unrelated structures together.
2. **Preserves the temporal-vs-structural distinction at the type level.** `type: plan`
   (temporal) vs `type: work-breakdown-structure` (structural) — you can tell the planning
   model from frontmatter alone, and vault queries by type keep working.
3. **Preserves the current invariant** ("plan decisions don't touch templates"). The
   decision file stays a pure relabeling operation — no body patching, no new
   `FORMAT.md` flavor needed.
4. **`FORMAT.md` stays clean.** The L1/L2 framing accommodates two templates without
   extension — the decision file just relabels which is "default" vs "alternative."
5. **No migration needed for WBS artifacts.** Existing `work-breakdown-structures/` files
   keep their type, folder, and identity. Only `implementation-plans/` artifacts need
   migration (to `plans/` as `type: plan`).
6. **Each template is self-contained and independently editable.** The WBS template can
   evolve (e.g. add a RACI matrix) without touching the plan template, and vice versa.
7. **Upgrade resilience.** The decision file's drift-tolerance (token patterns + prose
   matching) works as designed — no section-boundary matching to break.
8. **Discoverability.** A new user browsing `templates/` sees two planning templates and
   can compare them directly — the structural alternative isn't hidden behind a patch.

**Costs:**

1. **Four bookkeeping sections duplicated** (Critical Path, Estimates vs Actuals, Risks,
   References — ~15 lines). Bug fixes or wording changes need to be applied to both
   templates.
2. **Two folders, two `manifest.yaml` entries, two reference-doc rows.** More moving parts
   than Approach A, though fewer than the status quo.
3. **The flat-list planning style is lost.** `plan`'s `## Order` (single flat list with
   inline `→`/`∥`/`[Pn]` notation) is superseded by IP's Story Queue + Task Lanes. Solo
   developers who preferred the simpler flat list now get the richer IP structure whether
   they need it or not. (This is the trade-off you already accepted by choosing to unify
   plan + IP.)

---

### Approach C — Three templates (status quo, no merge)

All three templates stay separate. No merge happens. The decision file stays as-is (3
alternatives, pure relabeling).

**Benefits:**

1. **Maximum flexibility.** Each planning model is self-contained and independently
   editable. No merge complexity, no reconciliation of naming or structure.
2. **All three semantic distinctions preserved at the type level.** `type: plan` (flat
   temporal), `type: implementation-plan` (layered temporal), `type: work-breakdown-
   structure` (structural). Vault queries can filter to any of the three.
3. **Zero migration.** No artifacts move, no frontmatter changes, no folders merge.
4. **The decision file is the lightest possible operation** — pure relabeling, no template
   body editing, no `FORMAT.md` extension.
5. **Each template can target its audience precisely.** The solo-dev flat list, the team
   queue+lanes, and the stakeholder hierarchy each have their own optimized template
   without compromise.

**Costs:**

1. **`plan` and `ip` are 85% redundant.** Maintaining both means duplicating 6 of 7
   sections (Goal, Unparented Tasks, Critical Path, Estimates vs Actuals, Risks,
   References). Bug fixes and wording improvements must be applied to both.
2. **The flat-list style (`plan`'s `## Order`) overlaps heavily with IP's Story Queue +
   Task Lanes** — same information, less explicit expression. Users must choose between
   two temporal templates that differ only in richness, which is a subtle distinction to
   navigate.
3. **Three folders, three `manifest.yaml` entries, three reference-doc rows.** The most
   moving parts of any approach.
4. **The decision file's 3-alternative structure is heavier than it needs to be** if two
   of the alternatives are near-duplicates.

---

### Approach D — One template, WBS as base, sequencing as optional sections

All three planning models merge into one `templates/plan.md`. The base body is WBS's
structural model (Deliverable Hierarchy + Effort Rollup + Execution Order). The temporal
sequencing sections from plan/IP (Story Queue, Task Lanes, Unparented Tasks) are
**optional sections** wrapped in HTML comments — present in the template but inactive.
The user or agent uncomments the sections they need based on task count and team size.

**Core semantic argument:** structure is more fundamental than sequence. You need to know
what the work IS (decomposition, sizing) before you sequence it. Sequencing is a
refinement that depends on team size and task complexity. So the base should be structural
(WBS), and temporal sequencing should be optional add-ons. This inverts the current
seedbed default, which is temporal-first (plan) with structure as an alternative (WBS).

#### Proposed template structure

```
---
id: plan-{slug}
type: plan
owner: project-manager
status: draft
version: 1.0
feature: prd-{slug}
refs:
  - prd-{slug}
  - story-{slug}
  - td-{slug}
---

# Plan: {title}

## Goal
<!-- One paragraph: what "done" looks like for this plan. Ties back to prd-{slug} Success Metrics. -->

## Deliverable Hierarchy
<!-- Tree: prd-{slug} → stories → tasks. Each node carries estimated-hours.
     Order children by priority then depends-on. Σ marks rolled-up sums.
     This is the structural core — what the work IS. Always present. -->

- prd-{slug} ({title}) — Σ {N}h
  - story-{slug} — {title} — Σ {N}h [P0]
    - task-{slug}-be — {title} — {N}h
    - task-{slug}-fe — {title} — {N}h
  - story-{slug} — {title} — Σ {N}h [P1]
    - task-{slug}-be — {title} — {N}h

## Effort Rollup
<!-- Sum by slice. Answers "how big is this?" at a glance. Always present. -->

| Slice | Stories | Tasks | Estimated Hours |
|---|---|---|---|
| P0 (launch blocker) | {N} | {N} | {N}h |
| P1 (important) | {N} | {N} | {N}h |
| P2 (nice to have) | {N} | {N} | {N}h |
| **Total** | | | **{N}h** |

## Execution Order
<!-- Lightweight ordered list referencing tree nodes. Always present — this is the
     default sequencing. For richer sequencing (priority/depends-on/why reasoning),
     uncomment Story Queue below. -->

1. story-{slug} (P0, no deps)
2. story-{slug} (P0, depends-on story-{slug})
3. story-{slug} (P1)

<!-- OPTIONAL: Story Queue — uncomment when:
     - ≥3 stories with cross-dependencies, OR
     - priority contention needs explicit "why this position" reasoning
     Augments Execution Order with a detailed table. Execution Order stays as the
     quick-reference summary; Story Queue adds the reasoning layer.

## Story Queue
| # | Story | Priority | Depends-on | Est. Hours | Why this position |
|---|---|---|---|---|---|
| 1 | story-{slug} | P0 | — | {N}h | Unblocks story-2's fe-task |
| 2 | story-{slug} | P0 | story-{slug} | {N}h | Needs API from story-1 |
| 3 | story-{slug} | P1 | — | {N}h | Independent, can slip |
-->

<!-- OPTIONAL: Task Lanes — uncomment when:
     - team has ≥2 parallel roles (e.g. be + fe), OR
     - cross-task dependencies exist across roles within a story
     `→` = sequential; `∥` = parallel; `(blocked by X)` = wait gate.

## Task Lanes

### story-{slug} — {title}
be: task-{slug}-be-1 → task-{slug}-be-2
fe: task-{slug}-fe (blocked by be-2)

### story-{slug} — {title}
be: task-{slug}-be
fe: task-{slug}-fe (parallel with be)
-->

<!-- OPTIONAL: Unparented Tasks — uncomment when:
     spike / change / defect / review tasks exist against this brief
     with no `story:` field. Slotted by depends-on + estimated-hours.

## Unparented Tasks
| Task | Type | Depends-on | Est. Hours |
|---|---|---|---|
| task-{slug} | spike | — | {N}h |
-->

## Critical Path
<!-- Longest dependency chain through the tree, with summed hours = total elapsed estimate. -->

story-{slug} → task-{slug}-be → task-{slug}-fe — {N}h elapsed

## Estimates vs Actuals
<!-- Filled incrementally as the coding agent completes tasks.
     Delta = actual − estimated. Positive = agent slower; negative = agent faster.
     Agent Notes: what the agent did differently than the human plan assumed. -->

| Task | Estimated | Actual | Delta | Agent Notes |
|---|---|---|---|---|
| task-{slug}-be | {N}h | {N}h | {±N}h | |
| task-{slug}-fe | {N}h | — | — | in-progress |

## Risks & Open Questions
<!-- Decomposition risks: under-specified stories, missing tasks, scope creep nodes.
     If Task Lanes present, also: cross-story task deps, API freeze dates,
     agent-context limits on long chains. -->

-

## References
- [prd-{slug}](../prds/prd-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
```

#### Section classification

| Section | Status | Trigger |
|---|---|---|
| Goal | Core | Always |
| Deliverable Hierarchy | Core | Always — structural decomposition is the foundation |
| Effort Rollup | Core | Always — sizing is always relevant |
| Execution Order | Core | Always — minimal sequencing, lightweight |
| Story Queue | Optional | ≥3 stories with cross-deps, or priority contention needs explicit reasoning |
| Task Lanes | Optional | Team has ≥2 parallel roles (be+fe), or cross-task deps across roles |
| Unparented Tasks | Optional | Spikes/defects/reviews exist with no `story:` field |
| Critical Path | Core | Always |
| Estimates vs Actuals | Core | Always |
| Risks & Open Questions | Core | Always (comment adapts if Task Lanes present) |
| References | Core | Always |

#### Benefits

1. **Structure-first philosophy.** Decomposition and sizing come before sequencing —
   matches PMI/WBS tradition and the natural planning order (what IS the work → how big is
   it → what order → who does what). The current seedbed has this backwards (temporal
   default, structural alternative).
2. **Progressive disclosure.** Solo/small-project users get a lean plan: hierarchy + rollup
   + execution order + bookkeeping. Team/complex-project users uncomment Story Queue and
   Task Lanes for richer sequencing. One template scales from simple to complex.
3. **Single source of truth.** All bookkeeping sections (Critical Path, Estimates, Risks,
   References) exist in exactly one place. No duplication, no drift.
4. **One "plan" concept in the vault.** Simpler mental model: you write a plan, and
   optionally add sequencing detail based on your team and task complexity.
5. **No patch framework needed.** Unlike Approach A, there's no body-swap patch — the
   optional sections are already in the template, just commented out. The decision file
   shrinks to a pure relabel (or becomes unnecessary if there's only one type).
6. **The decision file may become obsolete.** If there's only one plan type, the
   `plan-type` decision axis disappears entirely — one fewer decision to maintain.
7. **One file to maintain.** Bug fixes, wording improvements, new shared sections — edit
   once, all users inherit.

#### Costs

1. **Forces structural decomposition on everyone.** Solo devs working on a linear 3-task
   feature must still produce a Deliverable Hierarchy tree and Effort Rollup table, even
   when a flat list would suffice. The "optional" framing helps with sequencing, but the
   structural core is mandatory.
2. **Loses the flat-list planning style entirely.** `plan`'s `## Order` (single flat list
   with inline `→`/`∥`/`[Pn]` notation) is gone. The simplest temporal expression is now
   WBS's Execution Order (a list referencing tree nodes), which requires the tree to
   exist first.
3. **Loses type-level distinction.** All plans are `type: plan`. Vault queries can't
   distinguish a structural plan from a temporal one — you'd need to read the body to see
   which optional sections were uncommented.
4. **HTML-comment-wrapped optional sections are a new template pattern.** Existing
   templates use HTML comments for inline guidance only, never for hiding entire sections.
   Users must view raw markdown to discover optional sections — they're invisible in
   rendered markdown.
5. **Execution Order + Story Queue coexistence is mildly redundant.** When Story Queue is
   uncommented, Execution Order (the lightweight list) and Story Queue (the detailed table)
   both present sequencing. The comment says "Execution Order stays as quick-reference
   summary," but some users may find the duplication confusing.
6. **Migration needed for all existing artifacts.** Files in `work-breakdown-structures/`
   and `implementation-plans/` must be renamed to `plan-*.md`, moved to `plans/`, and
   re-frontmatter'd. IP artifacts also need their Story Queue / Task Lanes content
   preserved as uncommented optional sections in the new format.
7. **The template is longer and more complex.** A new user opening `templates/plan.md`
   sees a tree, a rollup table, an execution order, three commented-out optional sections,
   and four bookkeeping sections — more to parse than any of the current three templates
   individually.

---

#### Duplication analysis

Yes — there is significant duplication. The Deliverable Hierarchy is the structural source
of truth, and several other sections are **projections** of it (same information, different
view) rather than independent data. Here's the precise overlap map:

**What each section carries:**

| Section | Information content |
|---|---|
| Deliverable Hierarchy | Story IDs, task IDs, estimates, priority (`[Pn]`), story-level ordering (children ordered by priority then depends-on), `Σ` rollup sums |
| Effort Rollup | Aggregation of hierarchy estimates by priority slice (P0/P1/P2 counts + hours) |
| Execution Order | Story IDs, priority, depends-on — in the same order the hierarchy already presents them |
| Story Queue | Story IDs, priority, depends-on, est. hours, **"why this position" reasoning** |
| Task Lanes | Task IDs per story, **task-level dependencies and parallelism** (`be-1 → be-2`, `fe blocked by be-2`) |
| Unparented Tasks | Task IDs **not in the hierarchy** (no `story:` field), type, depends-on, est. hours |

**Duplication map:**

| Section pair | Overlap | What's genuinely unique |
|---|---|---|
| Hierarchy → Execution Order | **Full** — children already ordered by priority then depends-on | Nothing (readability only — flat list vs tree) |
| Hierarchy → Effort Rollup | **Full** — rollup is derived from hierarchy's estimates + `Σ` marks | Nothing (aggregation is mechanical) |
| Hierarchy → Story Queue | **Most** — story IDs, priority, depends-on, est. hours all in hierarchy | "Why this position" reasoning only |
| Hierarchy → Task Lanes | **Partial** — task IDs are in hierarchy under stories | Task-level dependencies and parallelism (not in hierarchy) |
| Hierarchy → Unparented Tasks | **None** — mutually exclusive (unparented = no `story:` field, not in tree) | Everything (these tasks don't exist in the hierarchy) |
| Execution Order → Story Queue | **Full** — Story Queue is a superset | Est. hours, "why this position" |
| Execution Order → Task Lanes | None — different granularity (story vs task) | — |
| Story Queue → Task Lanes | None — different granularity | — |

**Key findings:**

- **Execution Order is fully redundant** with the hierarchy. The hierarchy's comment already
  says "Order children by priority then depends-on" — reading the tree top-to-bottom IS the
  execution order. The flat list adds no information, only readability.
- **Effort Rollup is fully redundant** with the hierarchy. It's a mechanical aggregation of
  estimates already present in the tree with `Σ` marks. Useful for stakeholder reporting,
  but not independent data.
- **Story Queue is mostly redundant** with the hierarchy. Its only unique value is "why this
  position" — the reasoning behind the ordering, not the ordering itself.
- **Task Lanes is partially redundant** (task IDs overlap) but carries genuinely unique
  information: task-level dependencies and parallelism, which the hierarchy doesn't express.
- **Unparented Tasks is not redundant** — it covers tasks that are explicitly NOT in the
  hierarchy (no `story:` field).

---

#### Simplification options

**Option D-S1: Drop redundant projections, keep unique-value sections**

Drop the two fully redundant sections (Execution Order, Effort Rollup as core). Rename
Story Queue to clarify its unique value. Keep the sections that carry genuinely unique
information.

Changes:
- **Drop Execution Order** — the hierarchy's ordering IS the execution order. Update the
  hierarchy's comment to make this explicit: "Children are ordered by priority then
  depends-on — this IS the execution order; read top-to-bottom."
- **Make Effort Rollup optional** — derived from hierarchy, useful for stakeholder
  reporting on larger projects but unnecessary for small ones (the `Σ` marks suffice).
- **Rename Story Queue → Sequencing Rationale** — clarify that its unique value is the
  "why this position" reasoning, not the ordering itself (the hierarchy already provides
  the ordering).
- **Keep Task Lanes (optional)** — genuinely unique: task-level deps and parallelism.
- **Keep Unparented Tasks (optional)** — genuinely unique: not in hierarchy.

Result: **6 core + 4 optional** (down from 8 core + 3 optional)

| Section | Status | Trigger |
|---|---|---|
| Goal | Core | Always |
| Deliverable Hierarchy | Core | Always — structural + temporal source of truth (ordering IS execution order) |
| Critical Path | Core | Always |
| Estimates vs Actuals | Core | Always |
| Risks & Open Questions | Core | Always |
| References | Core | Always |
| Effort Rollup | Optional | Stakeholder reporting needed, or ≥3 priority slices with significant effort |
| Sequencing Rationale | Optional | ≥3 stories with cross-deps, or priority contention needs explicit "why" reasoning |
| Task Lanes | Optional | Team has ≥2 parallel roles (be+fe), or cross-task deps across roles |
| Unparented Tasks | Optional | Spikes/defects/reviews exist with no `story:` field |

**Revised template structure (D-S1):**

```
---
id: plan-{slug}
type: plan
owner: project-manager
status: draft
version: 1.0
feature: prd-{slug}
refs:
  - prd-{slug}
  - story-{slug}
  - td-{slug}
---

# Plan: {title}

## Goal
<!-- One paragraph: what "done" looks like for this plan. Ties back to prd-{slug} Success Metrics. -->

## Deliverable Hierarchy
<!-- Tree: prd-{slug} → stories → tasks. Each node carries estimated-hours.
     Children are ordered by priority then depends-on — this IS the execution
     order; read top-to-bottom. Σ marks rolled-up sums.
     This is the structural + temporal source of truth. -->

- prd-{slug} ({title}) — Σ {N}h
  - story-{slug} — {title} — Σ {N}h [P0]
    - task-{slug}-be — {title} — {N}h
    - task-{slug}-fe — {title} — {N}h
  - story-{slug} — {title} — Σ {N}h [P1]
    - task-{slug}-be — {title} — {N}h

<!-- OPTIONAL: Effort Rollup — uncomment when:
     - stakeholder reporting needs a sizing summary, OR
     - ≥3 priority slices with significant effort
     Derived from the hierarchy's Σ marks — not independent data.

## Effort Rollup
| Slice | Stories | Tasks | Estimated Hours |
|---|---|---|---|
| P0 (launch blocker) | {N} | {N} | {N}h |
| P1 (important) | {N} | {N} | {N}h |
| P2 (nice to have) | {N} | {N} | {N}h |
| **Total** | | | **{N}h** |
-->

<!-- OPTIONAL: Sequencing Rationale — uncomment when:
     - ≥3 stories with cross-dependencies, OR
     - priority contention needs explicit "why this position" reasoning
     The hierarchy already provides the ordering; this section adds the WHY.

## Sequencing Rationale
| # | Story | Priority | Depends-on | Est. Hours | Why this position |
|---|---|---|---|---|---|
| 1 | story-{slug} | P0 | — | {N}h | Unblocks story-2's fe-task |
| 2 | story-{slug} | P0 | story-{slug} | {N}h | Needs API from story-1 |
| 3 | story-{slug} | P1 | — | {N}h | Independent, can slip |
-->

<!-- OPTIONAL: Task Lanes — uncomment when:
     - team has ≥2 parallel roles (e.g. be + fe), OR
     - cross-task dependencies exist across roles within a story
     `→` = sequential; `∥` = parallel; `(blocked by X)` = wait gate.

## Task Lanes

### story-{slug} — {title}
be: task-{slug}-be-1 → task-{slug}-be-2
fe: task-{slug}-fe (blocked by be-2)

### story-{slug} — {title}
be: task-{slug}-be
fe: task-{slug}-fe (parallel with be)
-->

<!-- OPTIONAL: Unparented Tasks — uncomment when:
     spike / change / defect / review tasks exist against this brief
     with no `story:` field. Slotted by depends-on + estimated-hours.

## Unparented Tasks
| Task | Type | Depends-on | Est. Hours |
|---|---|---|---|
| task-{slug} | spike | — | {N}h |
-->

## Critical Path
<!-- Longest dependency chain through the tree, with summed hours = total elapsed estimate. -->

story-{slug} → task-{slug}-be → task-{slug}-fe — {N}h elapsed

## Estimates vs Actuals
<!-- Filled incrementally as the coding agent completes tasks.
     Delta = actual − estimated. Positive = agent slower; negative = agent faster.
     Agent Notes: what the agent did differently than the human plan assumed. -->

| Task | Estimated | Actual | Delta | Agent Notes |
|---|---|---|---|---|
| task-{slug}-be | {N}h | {N}h | {±N}h | |
| task-{slug}-fe | {N}h | — | — | in-progress |

## Risks & Open Questions
<!-- Decomposition risks: under-specified stories, missing tasks, scope creep nodes.
     If Task Lanes present, also: cross-story task deps, API freeze dates,
     agent-context limits on long chains. -->

-

## References
- [prd-{slug}](../prds/prd-{slug}.md)
- [story-{slug}](../user-stories/story-{slug}.md)
- [td-{slug}](../tech-designs/td-{slug}.md)
```

**What D-S1 eliminates vs original D:**
- Execution Order (fully redundant with hierarchy's ordering)
- Effort Rollup as core (demoted to optional — derived data)
- Story Queue's redundant columns (renamed to Sequencing Rationale, scoped to "why" only)

**What D-S1 preserves:**
- All genuinely unique information (task-level deps, unparented tasks, sequencing reasoning)
- The structure-first philosophy
- The progressive disclosure pattern (core for simple, optional for complex)

**Option D-S2: Merge "why" into hierarchy, drop all story-level projections**

More aggressive — fold the sequencing rationale into the hierarchy itself as inline notes,
eliminating the need for any story-level projection section.

Changes:
- Drop Execution Order (redundant, same as D-S1)
- Drop Story Queue / Sequencing Rationale entirely — add "why" as inline notes in the
  hierarchy's story nodes
- Make Effort Rollup optional (same as D-S1)
- Keep Task Lanes (optional), Unparented Tasks (optional)

Result: **6 core + 3 optional** (down from 8 core + 3 optional)

Example hierarchy with inline "why":
```
- prd-{slug} ({title}) — Σ {N}h
  - story-{slug} — {title} — Σ {N}h [P0] <!-- first: unblocks story-2's fe-task -->
    - task-{slug}-be — {title} — {N}h
    - task-{slug}-fe — {title} — {N}h
  - story-{slug} — {title} — Σ {N}h [P0] <!-- depends on story-1: needs API -->
    - task-{slug}-be — {title} — {N}h
  - story-{slug} — {title} — Σ {N}h [P1] <!-- independent, can slip -->
    - task-{slug}-be — {title} — {N}h
```

**Trade-off:** trees are for structure, not scheduling rationale. Inline "why" comments
clutter the structural view and are easy to miss when scanning the tree. The hierarchy
becomes a hybrid structural+rationale document, which muddies its primary purpose. D-S1
keeps the rationale in a separate optional section where it belongs.

**Option D-S3: Hierarchy as single source of truth, everything else optional**

Most aggressive — the hierarchy is the ONLY core structural section. Everything else
(even Effort Rollup) is optional. The hierarchy carries structure, ordering, estimates,
and priority. All other sections are enrichments or bookkeeping.

Changes:
- Same as D-S1, but also make Critical Path optional (it's derivable from the hierarchy +
  Task Lanes if present)

Result: **5 core + 5 optional**

**Trade-off:** Critical Path is genuinely useful as a quick-reference even on small
projects — it's the single number that answers "how long will this take?" Demoting it to
optional means small projects lose the elapsed-time estimate unless they uncomment it.
Not recommended — the value-to-cost ratio is poor.

---

#### Recommendation within Approach D

**D-S1 is the cleanest simplification.** It eliminates the two fully redundant sections
(Execution Order, Effort Rollup-as-core) without losing any information, clarifies Story
Queue's unique value by renaming it to Sequencing Rationale, and preserves the genuinely
unique optional sections (Task Lanes, Unparented Tasks). The hierarchy becomes the single
structural + temporal source of truth, with optional sections as enrichments rather than
redundant projections.

D-S2 is tempting (fewer sections) but muddies the hierarchy's purpose by mixing structural
and scheduling-rationale concerns. D-S3 is too aggressive — Critical Path is worth keeping
as core.

**Revised Approach D section count:**
- Original D: 8 core + 3 optional = 11 sections
- D-S1: 6 core + 4 optional = 10 sections
- Net: -1 section, and the remaining sections carry less redundant information

---

## Part 3 — Side-by-side comparison

| Criterion | A: One template (plan+IP base, WBS patch) | B: Two templates (plan+IP merged, WBS separate) | C: Three templates (status quo) | D: One template (WBS base, sequencing optional) |
|---|---|---|---|---|
| Templates in `templates/` | 1 (`plan`) | 2 (`plan`, `wbs`) | 3 (`plan`, `ip`, `wbs`) | 1 (`plan`) |
| Folders | 1 (`plans/`) | 2 (`plans/`, `work-breakdown-structures/`) | 3 | 1 (`plans/`) |
| `manifest.yaml` type entries | 1 | 2 | 3 | 1 |
| Base planning model | Temporal (plan+IP) | Temporal (plan+IP) + Structural (WBS) | All three independent | Structural (WBS) |
| Sequencing model | Story Queue + Task Lanes (core) | Story Queue + Task Lanes (in `plan`); Execution Order (in `wbs`) | Each template has its own | Execution Order (core) + Story Queue + Task Lanes (optional) |
| Bookkeeping sections duplicated | 0 | 4 (in `wbs`) | 4 (in `ip`) + 4 (in `wbs`) = 8 | 0 |
| Planning-model distinction at type level | Lost (both `type: plan`) | Temporal vs structural | Flat vs layered vs structural | Lost (all `type: plan`) |
| Vault queries by plan type | Broken (need new convention) | Work for plan vs wbs | Work for all three | Broken (one type only) |
| Decision file touches templates? | **Yes** (body patch — new) | No (pure relabel) | No (pure relabel) | No (optional sections pre-built in template) |
| `FORMAT.md` extension needed? | Yes (new "body patch" flavor) | No | No | No (but new HTML-comment optional-section pattern in template) |
| Decision file needed at all? | Yes (WBS patch) | Yes (relabel default) | Yes (relabel default) | **Possibly no** — one type, optional sections are self-documenting |
| Current invariant preserved? | Broken | Preserved | Preserved | Broken (one type only) but no patch needed |
| Upgrade resilience | Fragile (section-boundary matching) | Drift-tolerant (token + prose) | Drift-tolerant | Drift-tolerant (no patch — sections are in template) |
| Migration needed | WBS + IP artifacts → `plans/` | IP artifacts → `plans/` | None | WBS + IP artifacts → `plans/` (IP content preserved as uncommented optional sections) |
| Discoverability of alternatives | Hidden (in decision file) | Visible (two templates) | Visible (three templates) | Hidden (in HTML comments — invisible in rendered markdown) |
| Maintenance effort per shared-section change | 1 file | 2 files | 3 files | 1 file |
| Flat-list planning style | Lost (IP wins) | Lost (IP wins) | Preserved | Lost (WBS Execution Order replaces it) |
| Scales from simple to complex? | No — one shape per template | Partly (two templates, two complexity levels) | Yes (three templates, three levels) | **Yes — optional sections scale with need** |
| Forces structural decomposition on simple work? | No (temporal base) | No (temporal base in `plan`) | No (each template matches its use case) | **Yes — tree + rollup always required** |
| Template complexity for new users | Medium (IP structure) | Medium (plan) + Medium (wbs) | Low (plan) + Medium (ip) + Medium (wbs) | Medium (D-S1: tree + 4 bookkeeping; optional sections hidden in comments) |
| Section redundancy | Low (IP superset of plan) | Low (plan and wbs share only bookkeeping) | High (plan↔ip 85% overlap) | **D-S1 eliminates redundancy** (hierarchy is source of truth; projections are optional or dropped) |
| Best for users who... | Want one concept, don't care about planning theory | Want temporal vs structural as an explicit choice | Want maximum planning-model flexibility | Want structure-first planning that scales with team size and task complexity |

---

## Part 4 — The decision hinge

The choice reduces to two questions:

### Question 1: Is structure-first or time-first the right default?

- **Structure-first (WBS as base)** → Approach D. Decomposition and sizing come before
  sequencing. Matches PMI tradition and the natural planning order. But forces everyone
  through structural decomposition even for simple linear work.

- **Time-first (plan/IP as base)** → Approaches A or B. Sequencing comes first; structure
  is optional or separate. Lighter for simple work, but sizing/decomposition is deferred
  or omitted.

### Question 2: Should the planning model be a type-level choice or a body-level choice?

- **Type-level choice** (separate types, separate templates) → Approaches B or C. Vault
  queries can filter by planning model. Each template is self-contained. But shared
  sections are duplicated.

- **Body-level choice** (one type, shape varies in the body) → Approaches A or D. One
  type, one template. No duplication. But vault queries can't distinguish planning models,
  and the variant is hidden in a patch (A) or in HTML comments (D).

### Approach selection guide

| If you believe... | Choose |
|---|---|
| Structure is fundamental; sequencing is a refinement that scales with team/complexity | **D (refined: D-S1)** |
| Temporal and structural are different planning acts that deserve separate types | **B** |
| All three planning models deserve their own type and template | **C** |
| One plan concept is enough; WBS is just a body variant of plan | **A** |

### Richness vs kind distinction (still relevant)

The flat-list-vs-layered distinction (plan vs IP) is a **richness** difference — IP
contains all of plan's information plus more. Merging is clean; the loser is just the
simpler expression. Approaches A, B, and D all merge these two.

The temporal-vs-structural distinction (plan/IP vs WBS) is a **kind** difference — they
answer different questions. Approach B preserves this as a type-level choice. Approaches A
and D collapse it — A makes WBS masquerade as a body variant of plan, D makes plan/IP
masquerade as optional add-ons to WBS. Approach C preserves all three distinctions.
