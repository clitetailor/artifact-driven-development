# Decision Format — Open Questions & Proposed Changes

> Working notes for resolving the design of the markdown-based decision format.
> Each item below is independent — resolve them in any order, mark the resolution
> in the **Resolution** block, and update `decisions/feature-brief.md` (and any
> new files) accordingly.
>
> Status legend: `[ ]` open · `[~]` in progress · `[x]` resolved

---

## OQ-1 — Revert mechanism for the symmetric default file  `[x]`

**Context:** The `feature-brief.md` prototype references `decisions/prd.md` as the revert
target, but that file doesn't exist yet. We need to decide how revert works.

**Two approaches evaluated:**

### Approach A — Reverse the steps in the decision file  ❌ REJECTED

The `feature-brief.md` file carries an explicit **Revert** section that lists the inverse
of every edit (swap `fb-` back to `prd-`, swap the default labels back, etc.). The agent
reads the same file and applies the inverse.

- Pros: one file per decision; no extra files; revert instructions live next to the apply
  instructions.
- Cons: doubles the file's content (every edit listed twice — once forward, once inverse);
  drift risk between the two halves; the agent must reliably invert each edit.

**Why rejected — conceptually wrong for peer-alternative decisions.** "Reversing" assumes
the alternative is a *delta from a default* that can be undone — apply forward, then apply
inverse to restore. But the requirements-root alternatives are **peer replacements**, not
inverses:

- `prd` bullet text = X, `feature-brief` bullet text = Y, `press-release` bullet text = Z.
- Y is not the inverse of X. Z is not the inverse of X. They are independent texts that
  occupy the same slot.
- "Reversing feature-brief" doesn't mean "undo the edit" — it means "replace Y with X,"
  which is just "apply the prd alternative." There is no reverse operation; there is only
  "switch to a different alternative."

Approach A collapses into "have a file for the default too" — which is Approach B without
the side-by-side layout. The "reverse" framing adds a concept that doesn't match reality
and misleads the agent into thinking there's an inverse operation when there isn't one.

> Approach A would only be valid for a true additive-then-removable change (e.g. "add a
> new section" / "remove that section"). None of the current decisions are that shape.

### Approach B — One file with all alternatives side-by-side  ✅ VALID

A single file per *decision axis* (e.g. `decisions/requirements-root.md`) lists every
alternative (`prd`, `feature-brief`, `press-release`, …) side-by-side. The user picks one;
the agent applies that column. Reverting = picking a different column in the same file.

- Pros: one file per axis instead of one file per alternative; the user sees the full
  decision space at once; no separate "revert" concept — switching is just picking another
  column; symmetric by construction.
- Cons: the file is larger (N alternatives × M edits); edits for alternatives the user
  didn't pick are still in the file (noise); harder to add a new alternative later (edit
  the shared file rather than drop in a new one).

**Two sub-shapes within B:**
- **B1 — one file per axis** (`decisions/requirements-root.md`) with all alternatives
  side-by-side. Larger file, but the user sees the full decision space and switching is
  always "pick a column in this file."
- **B2 — one file per alternative** (`decisions/feature-brief.md`, `decisions/prd.md`, …)
  with a shared structure. Smaller files, but switching requires opening a different file,
  and there's no single view of the decision space.

**Resolution:** **Approach B, sub-shape B1 — one file per axis, all alternatives
side-by-side.**

Rationale:
- Alternatives are peers, not inverses — "revert" is a misleading concept; switching is
  just "apply a different column." (Rejects A.)
- The user explicitly wants to see alternatives side-by-side. B1 gives that single view;
  B2 scatters it across files. (Picks B1 over B2.)
- Size concern is real (requirements-root has 5 alternatives: prd, feature-brief,
  press-release, pitch, one-pager) but manageable — the L1 token table is shared across
  alternatives; only the L2 prose blocks differ per column. Mitigation: limit the
  side-by-side to the **token table + a "prose role" column** (which type is default, which
  are alternatives) and put full prose blocks in per-alternative sections below the table
  rather than in 5-wide columns.

**Cascades:** CC-1 (file naming) is now resolved — adopt the per-axis convention
(`decisions/requirements-root.md`, `decisions/ask-threshold.md`, …).

---

## OQ-2 — Ask-threshold decision as its own file, three alternatives side-by-side  `[x]`

**Context:** Today the ask-threshold policy lives in two `.patch` files
(`switch-to-approach-changing-only.patch`, `switch-to-read-then-confirm.patch`) plus an
implicit "always ask first" default. The user wants this surfaced as an explicit decision
with all three alternatives shown side-by-side.

**Proposal:** Create `decisions/ask-threshold.md` listing:

1. **always-ask-first** (current default) — ask a clarifying question whenever intent is
   even slightly unclear, before reading or producing output.
2. **approach-changing-only** — ask only when the answer would change the approach/scope;
   infer trivial details and state the assumption in the output.
3. **read-then-confirm** — read the directly-relevant artifact, then state understood
   intent in one line and ask confirmation before producing output.

Each alternative touches only `AGENTS.md` (the `## Communication` and `## Output Style`
bullets) — no templates, reference docs, or `manifest.yaml`.

### Sub-question 1 — Does the side-by-side format fit here?  ✅ YES

OQ-1 resolved in favor of Approach B (per-axis, side-by-side). The ask-threshold axis has
exactly 3 alternatives and the edits are small (2 bullets each), so the side-by-side table
is compact and natural. No reason to deviate from the OQ-1 convention.

### Sub-question 2 — Full final state vs. diff?  → **Full final state**

The deciding rule (derived from inspecting the actual bullet text):

| Situation | Better representation | Why |
|---|---|---|
| The alternative **completely rewrites** the target (new lead-in + new body) | Full final state | Diff is 100% changed lines — pure noise |
| The alternative makes **surgical edits** within otherwise-unchanged text (token swaps, phrase replacements) | Diff | Shows exactly what moves while stable context anchors the location |

For ask-threshold: **both bullets are completely rewritten per alternative.** The bold
lead-in changes ("Ask before acting on ambiguity" → "Ask only on approach-changing
ambiguity" → "Read then confirm") and the entire body is reworded. Every line is a `-`/`+`
pair — the diff shows 100% of the bullet as changed, which is functionally identical to
full final state but carries extra visual noise (the `-` prefixes, the duplicated old text
that adds no information) and an extra cognitive step (mentally deleting the old lines).

**Full final state is strictly better here.** The agent reads the chosen column and writes
the whole bullet; no matching against existing text beyond finding the bullet's location.

> Note: this rule also applies to OQ-1's L2 prose blocks (vocabulary entries, PROJECT.md
> headings) — those are complete replacements, so they should use full final state columns
> too. OQ-1's L1 token swaps (`prd-` → `fb-`) are surgical edits within unchanged lines, so
> those stay diff-like (token table). A requirements-root decision file would use **both**:
> a token table for L1 + full-final-state columns for L2 prose.

### Sub-question 3 — Bullet coverage  ✅ RESOLVED

Inspected both patches. All three alternatives redefine **both** bullets:
- Bullet 1 (`## Communication`, first bullet — the ask-threshold rule): all three
  alternatives rewrite it.
- Bullet 2 (`## Output Style`, last bullet — "State assumptions made when inferring
  intent"): all three alternatives rewrite it (always-ask-first keeps the original wording;
  approach-changing-only and read-then-confirm each reword it to match their flow).

So the side-by-side table has **2 rows × 3 columns**, both fully populated. No sparse cells.

**Resolution:** **`decisions/ask-threshold.md`, side-by-side, full final state, 2 bullets ×
3 alternatives.**

Rationale:
- Side-by-side fits (3 alternatives, small edits) and matches the OQ-1 convention.
- Full final state wins because both bullets are 100% rewritten per alternative — diff
  would be pure noise.
- Both bullets are covered by all three alternatives — no sparse cells, no special-casing.

---

## OQ-3 — L1 (templates): summarize + command-driven find/check/apply  `[x]`

**Context:** The prototype's L1 section lists all 12 target files explicitly and gives one
illustrative example diff. The user proposes instead: **summarize what changes**, then use
**commands to find, check, and apply** the changes — without enumerating every file.

**Data verified from the actual templates:**

| Pattern | Count | Where | Notes |
|---|---|---|---|
| `feature: prd-{slug}` (frontmatter) | 12 | all 12 downstream templates | The find pattern — naturally excludes prd.md |
| `  - prd-{slug}` (refs: block entry) | 8 | 8 of the 12 downstream | Original sub-question said "~5" — actually 8 |
| `[prd-{slug}](../prds/prd-{slug}.md)` (References link) | 8 | same 8 | **Two** replacements in one line: slug prefix + path |
| `prd-{slug}` in prose/comments | several | plan, implementation-plan, wbs, test-spec | Same slug-prefix swap covers these |
| `scenario: prd-{slug}#scenario-{N}` | 1 | test-spec only | Different context, same prefix swap |
| `id: prd-{slug}` | 1 | **prd.md only** | MUST NOT be touched — this is the root template |
| `../prds/` path | 8 | same 8 with References links | Separate pattern from slug prefix |

**Two critical edge cases a blanket command would miss or break:**
1. A blanket `sed 's/prd-/fb-/g'` across all files containing `prd-{slug}` would **wrongly
   edit prd.md's `id:` line**. The find pattern `rg -l "feature: prd-\{slug\}"` is the
   safety gate — it returns exactly the 12 downstream files and excludes prd.md (which has
   `id:`, not `feature:`).
2. The References link `[prd-{slug}](../prds/prd-{slug}.md)` needs **two** swaps: `prd-` →
   `fb-` (slug) AND `../prds/` → `../feature-briefs/` (path). A single slug-prefix sed
   leaves `../prds/fb-{slug}.md` — broken path.

### Sub-question 1 — Drop the explicit list; agent decides how to apply vs. just run commands?  ✅ VALID REFRAMING

The user reframes: don't keep the explicit 12-file list (all related references need
updating, so listing them is redundant if find commands catch them). The real question is
whether the agent should **decide how to apply** replacements (interpretively, using Edit)
vs. **just run commands** (sed across matched files).

**Finding: commands to find, agent judgment to apply. Neither alone is sufficient.**

- **Pure command execution (sed) is insufficient** because of the two edge cases above:
  - A blanket `prd-` → `fb-` sed would wrongly edit prd.md if it's in the target set. The
    find pattern prevents this, but only if the agent uses the *right* find pattern —
    which is itself a judgment call.
  - The path swap `../prds/` → `../feature-briefs/` is a separate pattern that a single
    slug-prefix sed misses. The agent must know to run a second replacement.
- **Pure agent judgment (Edit per file) is sufficient but slow** — 12 files × multiple
  edits each, when the patterns are uniform and mechanical.
- **The right split:** find commands locate targets; the token map tells the agent what to
  replace; the agent chooses the tool (sed for bulk mechanical swaps, Edit for edge cases
  or if sed isn't available); the §Verify block catches misses regardless of method.

**Resolution:** Drop the explicit 12-file list. Provide find commands + token map. Let the
agent decide whether to use sed, Edit tool, or a mix. The find pattern
`rg -l "feature: prd-\{slug\}"` is the safety gate that scopes to the 12 downstream
templates and excludes prd.md.

### Sub-question 2 — Fallback to grep  ✅ VALID WITH CAVEAT

**Finding: assume `rg` for consistency with the vault; grep fallback is practical for L1
but inconsistent if only applied to decision files.**

- The vault already standardizes on `rg` — `reference/vault-queries.md` and `AGENTS.md`
  both use `rg` in their query recipes, with no grep fallback. Adding fallbacks only to
  decision files creates an inconsistency.
- For L1's simple literal patterns (`feature: prd-{slug}`, `../prds/`), `grep -rl` works
  identically to `rg -l`. The fallback `rg -l "..." templates/ || grep -rl "..." templates/`
  is practical and portable.
- For more complex patterns (if any arise in other decisions), `rg` (Rust regex) and
  `grep` (POSIX BRE/ERE) diverge — the fallback would need pattern translation.

**Resolution:** Provide `rg` as the primary command, with a `grep -rl` fallback noted in
the decision file header (once, not per-command). This matches the user's preference for
portability while keeping the file readable. If the vault later adopts grep fallbacks
vault-wide, the decision files are already consistent.

> Caveat: if portability is a real concern, it should be addressed vault-wide (add grep
> fallbacks to `vault-queries.md` too), not just in decision files. This is a CC-level
> concern, not an OQ-3 concern — flagged for CC-2 or a new CC item.

### Sub-question 3 — For refs: block edit, find slugs and let agent decide?  ✅ VALID BUT PREMISE CORRECTED

**Finding: the refs: block edit is NOT a special case. It's covered by the same
slug-prefix swap. The agent doesn't need to decide anything special for refs: blocks.**

The original sub-question stated the refs: block edit applies to "~5 of 12 templates." The
data shows it's actually **8 of 12**. More importantly:

- The refs: block entry `  - prd-{slug}` → `  - fb-{slug}` is just another instance of the
  slug-prefix swap. A blanket `sed 's/prd-{slug}/fb-{slug}/g'` on the 12 downstream files
  handles all 8 refs: entries correctly.
- The 4 files without refs: entries (task, design-spec, data-design, api-spec) simply
  don't match — sed replaces existing occurrences; it doesn't add new ones.
- No special find pattern or agent judgment is needed to distinguish "files with refs:
  entries" from "files without." The same slug-prefix swap covers both cases.

**The only things that need special treatment in L1 are:**
1. **Excluding prd.md** — handled by the find pattern `feature: prd-{slug}` (not `prd-{slug}`
   broadly).
2. **The path swap** `../prds/` → `../feature-briefs/` — a separate replacement pattern,
   not covered by the slug-prefix swap.

**Resolution:** No special handling for refs: blocks. The L1 section needs exactly two
replacement patterns: (a) slug prefix `prd-{slug}` → `fb-{slug}` and (b) link path
`../prds/` → `../feature-briefs/`. Both are applied to the files found by
`rg -l "feature: prd-\{slug\}" templates/`. The agent applies them with whatever tool it
chooses (sed, Edit, or mix).

**Overall OQ-3 resolution:**
- Drop the explicit 12-file list. Use find commands to locate targets.
- Two find commands: `rg -l "feature: prd-\{slug\}" templates/` (scopes to 12 downstream,
  excludes prd.md) and `rg -l "\.\./prds/" templates/` (scopes to 8 with link paths).
- Two replacement patterns: slug prefix swap + link path swap.
- Let the agent decide whether to use sed, Edit tool, or a mix.
- `rg` primary, `grep -rl` fallback noted in the file header.
- No special handling for refs: blocks — covered by the slug-prefix swap.
- §Verify block catches any misses (grep for residual `prd-` in the 12 downstream files).

---

## OQ-4 — L2 (reference docs): add a summary at the top  `[x]`

**Context:** The prototype's L2 section jumps straight into per-file diffs. The user wants
a **brief summary at the top** so both user and agent get the shape of the changes before
diving into each file.

**Draft of the summary** (this is the content that would sit at the top of the L2 section,
before the per-file blocks — it's the concrete text of the summary the Context proposes
adding, not a separate option):

> **L2 — Reference docs & handbook (8 files).** This layer re-labels which requirements-root
> type is "the default" vs. "an alternative." The pattern is uniform: wherever `prd` is
> presented as the default and `feature-brief` as an alternative, swap those two roles.
> Other alternatives (`pitch`, `one-pager`, `press-release`) keep their "alternative"
> framing unchanged.
>
> Eight files are touched, in three flavors:
> - **Default-swap prose** (vocabulary, PROJECT.md, folder-structure, setup.md) — reword
>   which type is called "default."
> - **Graph/table relabeling** (dep-graph, coordination-decision-tree) — replace `prd` with
>   `feature-brief` in dependency tables and mermaid nodes.
> - **Query/example updates** (vault-queries, frontmatter) — replace `prd` example ids and
>   `type: prd` scan queries with `feature-brief` / `fb-` equivalents.

**Trade-offs:**
- Pros: a reader (human or agent) gets the mental model in 10 seconds before reading 8
  diffs; the "three flavors" grouping tells the agent *why* each file changes, which
  improves drift-tolerant matching.
- Cons: adds ~15 lines; risks drifting out of sync with the per-file blocks if those are
  edited later without updating the summary.

**Sub-question:** Should the summary also carry a one-line "what does *not* change"
(pitch/one-pager/press-release rows, agent ownership, lifecycle) to bound the agent's
edit scope? The prototype's Notes section touches this — decide whether to hoist it up.

### Data verified from the actual reference docs

All 29 `prd`/`PRD` mentions across the reference docs, sorted into three buckets:

**MUST change (26 mentions, 7 files):** prd presented as the default type — dep-graph
(table, mermaid, phase row, defaults note), vocabulary (prd + feature-brief definition
rows), frontmatter, coordination-decision-tree, vault-queries, folder-structure (`prds/`
line), PROJECT.md, setup.md. These are what the L2 section targets.

**MUST NOT change — NOT at risk (1 mention):** `artifact-ownership.md` L9
(`feature-brief, prd, press-release, user-story | business-analyst`). This file is a list
of all types per owner — prd is one of several, not "the default." It's also **not in the
L2 target list**, so the agent won't open it. Low risk.

**MUST NOT change — AT RISK (3 mentions, the edge cases):**

| File | Line | Text | Why at risk |
|---|---|---|---|
| `artifact-vocabulary.md` | L9 | `user-story` def: "extracted from a **PRD**" | Same file as the prd/feature-brief row swap. A blanket `sed 's/PRD/Feature Brief/g'` on this file would wrongly change it. |
| `artifact-vocabulary.md` | L17 | `task` def: "the feature's **PRD**" | Same file, same risk. |
| `folder-structure.md` | L10 | "active tasks, **PRDs**, status" | Same file as the `prds/` line swap. "PRDs" here is a generic plural describing PROJECT.md's content, not the default type name. |

The existing `.patch` files intentionally leave all three untouched. A blanket sed would
not. These are the cases where a "does not change" line earns its keep.

### Three approaches evaluated

#### Approach A — Summary-level "does not change" line  ✅ VALID

Add to the L2 summary:

> **Does not change:** other requirements-root alternatives (pitch, one-pager,
> press-release) keep their "alternative" framing; agent ownership and lifecycle are
> unchanged; generic mentions of "PRD" in other artifact definitions (e.g. "extracted from
> a PRD" in user-story, "the feature's PRD" in task) are NOT changed — only the
> rows/entries that present prd as the default type are swapped.

- Pros: one place to bound the agent's edit scope; catches the sed-blast risk; forces an
  explicit decision about the 3 edge cases; a human reader gets the full picture
  (what changes + what doesn't) in the summary.
- Cons: summary grows from ~15 to ~20 lines; the edge-case list is file-specific but lives
  at the summary level (slight mismatch in granularity); needs updating if new edge cases
  appear in other alternatives.

#### Approach B — Per-file "does not change" notes  ✅ VALID

Add to each per-file block that has edge cases:

> For `artifact-vocabulary.md`: Swap the `prd` and `feature-brief` rows. Do NOT change
> "PRD" mentions in the `user-story` or `task` rows — those use "PRD" as a generic industry
> term, not as the default type name.

- Pros: the note lives next to the file it applies to (right granularity); no summary-level
  clutter; the agent sees it exactly when it's working on that file.
- Cons: a human reader skimming the summary doesn't see the boundary; if the agent uses sed
  on a file without reading the per-file block carefully, it misses the note; the 3 edge
  cases are spread across 2 files, so the note appears in 2 places.

#### Approach C — Both (summary + per-file)  ✅ VALID BUT REDUNDANT

Summary has a brief one-liner; per-file blocks have the specific notes.

- Pros: defense in depth — the summary catches the careless agent, the per-file note catches
  the careful one who somehow missed the summary.
- Cons: DRY violation — the same information in two places; if one is updated and the other
  isn't, they drift; most verbose option.

### Comparison

| Dimension | A (summary) | B (per-file) | C (both) |
|---|---|---|---|
| Catches sed-blast risk | ✅ (if agent reads summary first) | ⚠️ (only if agent reads per-file block before sed) | ✅ |
| Human skimming the summary | ✅ sees the boundary | ❌ doesn't see it | ✅ |
| Granularity match | ⚠️ summary-level, edge cases are file-specific | ✅ file-level | ✅ both |
| DRY | ✅ one place | ✅ one place | ❌ two places |
| Maintenance cost | low (update summary) | low (update per-file block) | medium (update both) |
| Verbosity | +5 lines to summary | +2 lines per edge-case file | +7 lines total |

### Recommendation

**Approach A (summary-level "does not change" line).**

Rationale:
- The sed-blast risk is the real danger, and it's best caught at the summary level — the
  agent reads the summary before diving into per-file blocks. If the note is only in the
  per-file block (B), an agent that decides to sed a file without carefully reading its
  block misses the boundary.
- The granularity mismatch (summary-level note for file-specific edge cases) is minor —
  the note names the specific files and lines, so it's not vague.
- The human-skimming benefit matters: a reader who looks at the L2 summary should see both
  "what changes" and "what doesn't" to understand the decision's scope without reading 8
  per-file blocks.
- C (both) is redundant — the information is identical in both places, and the DRY cost
  outweighs the defense-in-depth benefit for a file that's edited rarely.

**Resolution:**
- **Add the summary: yes.** The three-flavors grouping is the right cut (it maps to the
  three kinds of edits the agent makes, giving it the "why" for each file).
- **Include the "does not change" line: yes, at the summary level (Approach A).** It bounds
  the agent's edit scope and catches the 3 edge cases where a blanket sed would over-edit.
- **Three-flavors grouping: yes.** Default-swap prose, graph/table relabeling, and
  query/example updates correctly categorize the 8 target files.

---

## Cross-cutting — things to decide once, then apply to all decision files

These aren't separate questions so much as conventions to set before drafting more files.

### CC-1 — File naming  `[x]` (resolved via OQ-1)

**Resolution:** Adopt the **per-axis** convention — one file per decision axis, all
alternatives side-by-side. Examples:
- `decisions/requirements-root.md` (alternatives: prd, feature-brief, press-release, pitch,
  one-pager)
- `decisions/ask-threshold.md` (alternatives: always-ask-first, approach-changing-only,
  read-then-confirm)
- `decisions/plan-type.md` (alternatives: plan, work-breakdown-structure,
  implementation-plan) — if/when migrated

The existing `decisions/feature-brief.md` prototype is **per-alternative** and will be
folded into `decisions/requirements-root.md` when that file is drafted. Keep the prototype
around as a reference until the per-axis file exists.

Rationale: driven by OQ-1 (Approach B, sub-shape B1). Per-axis files give the single
side-by-side view the user wants; per-alternative files scatter the decision space.

### CC-2 — Where the index lives  `[x]`

The customize-artifacts playbook (`handbook/playbooks/customize-artifacts.md`) and
`handbook/customization.md` currently point at `patches/`. They'll need to point at
`decisions/` and list available decisions. Two options evaluated:

#### Option A — `decisions/README.md` index  ✅ CHOSEN

A README.md in `decisions/` lists available decision files in a file→purpose table, plus
a pointer to `handbook/playbooks/customize-artifacts.md` for the apply flow. The playbook
and `customization.md` both point at this README for the catalog.

#### Option B — Inline the list in `handbook/customization.md`

Keep the list in `customization.md` (where the "Available Switch-Patches" tables live
today); the playbook continues pointing at `customization.md`. No separate index file.

### Verification of Option A (chosen)

**Vault convention check:** The vault already uses README.md indexes for documentation
directories — `reference/README.md` and `handbook/README.md` both follow the pattern of a
file→purpose table + cross-reference pointers. `decisions/` is a documentation directory,
so a README.md fits the existing convention. (`patches/` and `templates/` lack READMEs, but
`patches/` is being replaced by `decisions/`, and `templates/` is a pure file store
enumerated by `manifest.yaml` — neither needs an index.)

**Co-location:** The list of decisions lives in the same directory as the decision files.
Adding a new decision = create the file + add one row to the README in the same directory.
With Option B, adding a new decision = create the file in `decisions/` + update the list
in `handbook/customization.md` — a different directory. Option A is more co-located.

**DRY:** Currently `customization.md` has two inline tables (Available Switch-Patches +
Ask-Threshold Switch-Patches) and `customize-artifacts.md` points at `customization.md`
for the list. With Option A, the list lives in one place (`decisions/README.md`) and both
`customization.md` and `customize-artifacts.md` point at it. Option B preserves the status
quo where `customization.md` is the single list-holder — also DRY, but the list is not
co-located with the files.

**Separation of concerns:** Option A lets `customization.md` become purely about the
*mechanism* (how to apply, upgrade flow, combining decisions), while the README becomes the
*catalog* (what's available). Currently `customization.md` mixes both. Option B keeps them
mixed.

**Pointer flow (no circularity):**
`customize-artifacts.md` (playbook) → `decisions/README.md` (catalog) → individual decision
files → decision files reference the playbook for the apply flow. Hub-and-spoke; no cycles.
Verified against the prototype `decisions/feature-brief.md`, which references
`handbook/playbooks/customize-artifacts.md` but not `customization.md`.

**Staleness risk:** The README can drift from the actual files (file exists but isn't
listed, or listed but doesn't exist). This is the same risk as `reference/README.md` and
`handbook/README.md`, which the vault already accepts. A grep-based check
(`ls decisions/*.md` vs the README table) can verify, but this is a verification step, not
a design blocker.

**One indirection cost:** A reader of `customization.md` must follow a link to see the
list. But this matches the existing `handbook/README.md` → `customization.md` pattern, so
it's consistent with vault conventions.

**Resolution:** **Option A — `decisions/README.md`.**

Rationale: matches the existing README.md convention for documentation directories
(`reference/`, `handbook/`); co-locates the list with the files it indexes; separates
catalog (README) from mechanism (`customization.md`); DRY (one list, pointed at by both
the playbook and `customization.md`); no circular references.

**Migration steps (when implementing):**
1. Create `decisions/README.md` with a file→purpose table for each decision axis, plus a
   pointer to `handbook/playbooks/customize-artifacts.md` for the apply flow.
2. Update `handbook/customization.md`: remove the "Available Switch-Patches" and
   "Ask-Threshold Switch-Patches" tables; replace with a pointer to `decisions/README.md`.
   Keep the mechanism sections (Applying, Combining, Upgrade Flow, Changing a Decision).
3. Update `handbook/playbooks/customize-artifacts.md`: change the pointer in the Notes
   section from `../customization.md` → "Available Switch-Patches" to
   `../../decisions/README.md`.
4. Update `handbook/README.md`: add `decisions/` to the "Where the Specs Live" table
   (Concern: "Available decision axes" → `../decisions/README.md`).

### CC-3 — Keep `.patch` files or remove them  `[x]`

Three options evaluated:

#### Option A — Remove  ✅ CHOSEN

`decisions/` fully replaces `patches/`. The `patches/` directory is deleted; all references
to patches/switch-patches across the vault are updated to point at `decisions/`.

#### Option B — Keep as-is

Both `patches/` and `decisions/` coexist; users pick which mechanism to use.

#### Option C — Generate from `decisions/`

`decisions/` is the source of truth; `.patch` files are produced by a script for CI/upgrades.

### Verification of Option A (chosen)

**Consistency with prior resolutions:** The "loses deterministic replay" concern was
already weighed and accepted in OQ-1, OQ-3, and OQ-4 — drift tolerance and readability won
over replay determinism. The §Verify block in each decision file replaces the `.rej` check
as the verification mechanism. Option A is consistent with the direction already chosen;
Options B and C would reintroduce a mechanism the prior resolutions moved away from.

**Migration scope — 8 files reference patches/switch-patches and need updating:**

| File | Matches | What changes |
|---|---|---|
| `handbook/customization.md` | 17 | Whole mechanism section is patch-based — rewrite to decision-file flow; remove the two "Available Switch-Patches" tables (CC-2 moves them to `decisions/README.md`); rewrite Upgrade Flow from "re-apply patch with `--fuzz=3`" to "re-apply decision file" |
| `handbook/playbooks/customize-artifacts.md` | 5 | Step 3 apply commands (`patch -p1 --fuzz=3`), Step 4 revert commands (`patch -R`), `.rej`/`.orig` handling — all replaced with "apply the chosen column from the decision file" |
| `README.md` | 5 | Prerequisites table drops `patch` and `diff` as required tools (net simplification — fewer external deps, addresses the original Windows/MSYS pain point); setup walkthrough step 5 changes from "apply a switch-patch from `patches/`" to "apply a decision from `decisions/`" |
| `AGENTS.md` | 1 | Line 37: "Switch this threshold via patches in `patches/`" → "via decisions in `decisions/`" (this is also the line the ask-threshold decision file edits) |
| `reference/artifact-dep-graph.md` | 1 | Line 83: "switch-patch selectable" → "decision selectable" or similar |
| `PROJECT.md` | 1 | Line 25: "selected via switch-patches" → "selected via decisions" |
| `handbook/README.md` | 2 | Descriptions of `customization.md` and `customize-artifacts.md` mention "switch-patches" — reword to "decisions" |
| `decisions/feature-brief.md` | 1 | Line 110, inside a quoted comment that the decision itself edits — will be fixed when the per-axis `requirements-root.md` is drafted |

**Overlap with CC-2:** 3 of the 8 files (`customization.md`, `customize-artifacts.md`,
`handbook/README.md`) are already in CC-2's migration scope. The additional files CC-3 adds
are: `README.md`, `AGENTS.md`, `reference/artifact-dep-graph.md`, `PROJECT.md`. The two
migrations should be done together to avoid a half-migrated state.

**Upgrade-flow replacement:** The current "Upgrade Flow" section in `customization.md`
describes re-applying patches after pulling upstream. With Option A, this becomes
"re-apply the decision file" — the agent re-runs the apply instructions on the new base,
then runs the §Verify block. Less deterministic than `patch --fuzz=3` but more
drift-tolerant (semantic matching vs. 3-line context window), which is the trade-off
already accepted in OQ-3/OQ-4.

**Prerequisites simplification:** `patch` and `diff` drop off the required-tools list in
`README.md`. This is a concrete benefit — it removes the Windows/MSYS `patch` portability
issue that was one of the original pain points motivating this whole redesign.

**Revert replacement:** `patch -R` revert is replaced by "apply a different column in the
decision file" (per OQ-1 resolution). No capability lost — the OQ-1 resolution already
established that alternatives are peers, not inverses, so "revert" was always "switch to a
different alternative."

**One thing not preserved:** mechanical dry-run (`patch --dry-run`). The §Verify block
catches misses *after* applying, not before. This is the accepted trade-off from OQ-3 —
the find commands + token map + verify assertions replace pre-apply dry-run with
post-apply verification.

**Resolution:** **Option A — Remove `patches/` entirely.**

Rationale: consistent with the OQ-1/OQ-3/OQ-4 direction (drift tolerance and readability
over replay determinism); removes the Windows/MSYS `patch` portability pain; eliminates the
two-sources-of-truth risk; the §Verify block replaces `.rej` checking; revert becomes
"apply a different column" per OQ-1. Migration touches 8 files, 3 of which overlap with
CC-2 — do both migrations together.

**Migration steps (when implementing, alongside CC-2):**
1. Delete `patches/` directory and all 6 `.patch` files.
2. Update the 8 files listed above (3 overlap with CC-2: `customization.md`,
   `customize-artifacts.md`, `handbook/README.md`; 4 new: `README.md`, `AGENTS.md`,
   `reference/artifact-dep-graph.md`, `PROJECT.md`; 1 self-fixing: `decisions/feature-brief.md`).
3. Rewrite `customization.md` → "Upgrade Flow" section: "re-apply patch with `--fuzz=3`"
   → "re-apply the decision file, then run its §Verify block."
4. Rewrite `customize-artifacts.md` → Steps 3 & 4: patch apply/revert commands → "apply
   the chosen column from the decision file"; remove `.rej`/`.orig` handling.
5. Update `README.md` → prerequisites table: drop `patch` and `diff` rows; update setup
   walkthrough step 5 to reference `decisions/` instead of `patches/`.

### CC-4 — Illustrative-diff convention  `[x]` (largely mooted by OQ-1/OQ-2/OQ-3)

The prototype warns "example diffs are illustrative, not load-bearing." The original
question was where this warning should live — once in a header note (DRY, but easy to
miss) or repeated at each example diff (verbose, but unmissable).

**Relevance check after OQ resolutions:**

The prototype `feature-brief.md` has **21 ` ```diff ` blocks** (2 in L1, 19 in L2). After
the OQ-1/OQ-2/OQ-3/OQ-4 resolutions, the per-axis `requirements-root.md` file would have:

| Section | Prototype | After OQ resolutions | ` ```diff ` blocks remaining |
|---|---|---|---|
| L1 | 2 illustrative diffs | Token table (markdown table, not a diff block) + find commands + 1 illustrative example | **1** |
| L2 prose (9 files) | 19 per-file diffs | Full-final-state side-by-side columns (per OQ-1/OQ-2 representation rule) | **0** |
| **Total** | **21** | | **1** |

And `ask-threshold.md` (OQ-2): full final state, **0 diff blocks** — CC-4 doesn't apply to
it at all.

**Why the question dissolves:**

CC-4's header-vs-per-diff question was designed for a file with 21 diff blocks. With only
1 diff block remaining (the L1 illustrative example in requirements-root-type files), the
question is trivial:
- "Once in header" — overkill for a single diff.
- "Repeated per diff" — with 1 diff, this is just "put the warning next to that one diff."

**The token table doesn't need the warning:** it's diff-*like* (find/replace pairs) but
it's a markdown table showing patterns, not a ` ```diff ` code block showing specific lines
that might drift. The OQ-3 resolution already established the token map + find commands as
the source of truth, with the example diff as secondary — so the warning's purpose (don't
hunt for exact lines) is already covered by that framing.

**Resolution:** **Mooted.** Put the warning next to the single L1 illustrative diff (the
"repeated per diff" option, which with 1 diff is just "next to the diff"). No header-level
note needed. The question doesn't apply to ask-threshold (no diffs) or to L2 (full final
state, not diffs).

**If future decision axes introduce more illustrative diffs:** the same rule applies —
warn next to each diff. The header-vs-per-diff trade-off only becomes meaningful if a
single decision file accumulates many illustrative diffs again, which the OQ-1/OQ-2
representation rule (full final state for complete rewrites) structurally prevents.

---

## Resolution log

| ID | Status | Resolution | Date |
|---|---|---|---|
| OQ-1 | `[x]` | Approach B, sub-shape B1 (per-axis, side-by-side). Rejects A — alternatives are peers, not inverses. | 2026-06-20 |
| OQ-2 | `[x]` | `decisions/ask-threshold.md`, side-by-side, full final state, 2 bullets × 3 alternatives. | 2026-06-20 |
| OQ-3 | `[x]` | Drop explicit list; find commands + 2 replacement patterns (slug prefix + link path); agent chooses tool; rg primary with grep fallback; refs: blocks not special-cased. | 2026-06-20 |
| OQ-4 | `[x]` | Add summary yes; "does not change" line at summary level (Approach A); three-flavors grouping confirmed. 3 edge cases identified where blanket sed would over-edit. | 2026-06-20 |
| CC-1 | `[x]` | Per-axis convention (`decisions/<axis>.md`). Driven by OQ-1. | 2026-06-20 |
| CC-2 | `[x]` | `decisions/README.md` index. Matches vault convention (reference/, handbook/ both have READMEs); co-locates list with files; separates catalog from mechanism. | 2026-06-20 |
| CC-3 | `[x]` | Remove `patches/` entirely. Consistent with OQ-1/OQ-3/OQ-4 direction; drops `patch`/`diff` from prerequisites (fixes Windows pain); 8 files need reference updates (3 overlap with CC-2). | 2026-06-20 |
| CC-4 | `[x]` | Mooted by OQ-1/OQ-2/OQ-3. Only 1 illustrative diff remains (L1 example in requirements-root); ask-threshold has 0. Put warning next to the single diff; no header note needed. | 2026-06-20 |
