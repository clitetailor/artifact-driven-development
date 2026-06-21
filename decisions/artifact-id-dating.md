# Decision: artifact-id-dating

> Switches whether artifact IDs carry a creation-date prefix, and which types are dated.
> After the one-time template parameterization (L1), switching alternatives = manifest-only edit.
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

Two concerns bundled in this decision:

1. **Template parameterization (one-time).** Cross-references in templates switch from
   hardcoded `P-{slug}` patterns to `{<type>-id}` and `{<type>-link}` placeholders. Own
   `id:` stays as `{prefix}-{slug}`. A `folder:` field is added to each type in
   `manifest.yaml` to support `{<type>-link}`. After this refactor, prefix and folder
   changes (including dating) are manifest-only edits — no template edits needed.

2. **ID dating (per-alternative).** Artifact IDs gain an optional `{YYYY-MM-DD}-`
   creation-date prefix before the type prefix. The set of types that carry the date
   prefix depends on the chosen alternative. With parameterized templates, switching
   dating alternatives = setting `dated: true` flags in `manifest.yaml` only.

This is a **naming convention change**, not a structural change — the dependency graph,
agent ownership, lifecycle, folder structure, and frontmatter fields are unchanged. Only
the ID format, the template placeholder vocabulary, and the queries that anchor on IDs
move.

**Date semantics:** the date prefix is the **creation date**, set once when the artifact
is first created and never updated — even if the artifact is revised via `needs-review`
or re-accepted. This keeps IDs stable so `refs`/`feature`/`story` links don't break.

**Why bundled (packaging choice):** the parameterization refactor (concern 1) and the
dating switch (concern 2) are orthogonal in principle — see `../artifact-id-dating-plan.md`
Q2. They are bundled here because (a) the parameterization is what makes dating
manifest-only, so the dating decision's "what does switching cost" answer depends on it,
and (b) paying the one-time template refactor once covers both prefix-dating and future
folder/prefix changes uniformly.

---

## Alternatives

| Alternative | Dated types | Undated types | Status |
|---|---|---|---|
| `none` | — | all 15 | ✅ Implemented (default) |
| `snapshot-style` | 10 snapshot types | 5 living types | ✅ Drafted |
| `all` | all 15 | — | ✅ Drafted |

### Dated type sets per alternative

| Type | Prefix | `none` | `snapshot-style` | `all` |
|---|---|---|---|---|
| feature-brief | `fb-` | — | ✓ | ✓ |
| prd | `prd-` | — | ✓ | ✓ |
| press-release | `pr-` | — | ✓ | ✓ |
| user-story | `story-` | — | ✓ | ✓ |
| user-flow | `uf-` | — | ✓ | ✓ |
| adr | `adr-` | — | ✓ | ✓ |
| tech-design | `td-` | — | ✓ | ✓ |
| task | `task-` | — | ✓ | ✓ |
| plan | `plan-` | — | ✓ | ✓ |
| note | `note-` | — | ✓ | ✓ |
| system-architecture | `sa-` | — | — | ✓ |
| api-spec | `api-` | — | — | ✓ |
| data-design | `dd-` | — | — | ✓ |
| design-spec | `ds-` | — | — | ✓ |
| test-spec | `ts-` | — | — | ✓ |

**`snapshot-style` rationale:** date types whose creation date carries meaning —
snapshot-style artifacts that serve as point-in-time anchors for derivative works
(`prd`, `feature-brief`, `press-release`, `user-story`, `user-flow`, `tech-design`) or
frozen records (`adr`, `task`, `plan`, `note`). Leave undated the types that iterate
throughout the project lifecycle (`system-architecture`, `api-spec`, `data-design`,
`design-spec`, `test-spec`).

---

## L1 — Templates (one-time parameterization)

### Placeholder conventions

After parameterization, templates use three placeholder forms:

| Placeholder | Used for | Example expansion |
|---|---|---|
| `{prefix}-{slug}` | Own `id:` field | `prd-user-auth` or `2026-06-21-prd-user-auth` (date prefix added per manifest `dated` flag) |
| `{<type>-id}` | Cross-reference to another artifact's full concrete ID — frontmatter fields, `refs:`/`depends-on:` lists, prose, table cells, hierarchy trees | `2026-06-21-prd-user-auth` |
| `{<type>-link}` | Full markdown link to another artifact — `## References` section, inline links | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |

`<type>` is the type's prefix stem (e.g. `prd`, `sa`, `task`, `story`, `fb`). The agent
filling the template copies the referenced artifact's full concrete ID (including date
prefix if dated) — it already knows the referenced artifact's ID.

#### Parenthetical aliases for separation disambiguation

When the same placeholder type appears multiple times in close proximity and the reader
could reasonably wonder whether the occurrences refer to the same or different artifacts,
a **parenthetical alias** annotates each occurrence with its role:

```
{<type>-id (role)}     {<type>-link (role)}
```

The text in parentheses is a human-readable label describing which specific artifact this
occurrence refers to — it is not filled in by the agent (the agent replaces the entire
`{...}` expression with the concrete ID/link). Use parenthetical aliases only at
separation-concern sites (e.g. `{task-id (be-task)} → {task-id (fe-task)}` in a critical
path, or `{story-id (story-1)}, {story-id (story-2)}` in a multi-story table cell). Sites
where a placeholder type appears once in a context need no alias — the context itself is
unambiguous.

Parentheses (not pipe) are used because the pipe character collides with markdown's table
column separator — `{story-id | story-1}` inside a table cell breaks the column count.
Parentheses are inert in both YAML frontmatter and markdown tables.

#### Placeholder contexts

| Context | Placeholder | Example expansion |
|---|---|---|
| Frontmatter field | `{prd-id}` | `feature: 2026-06-21-prd-user-auth` |
| `refs:` list | `{prd-id}` | `- 2026-06-21-prd-user-auth` |
| `depends-on:` list | `{task-id}` | `- 2026-06-21-task-token-generation-be` |
| `scenario:` with fragment | `{prd-id}#scenario-{N}` | `scenario: 2026-06-21-prd-user-auth#scenario-1` |
| Entity reference with fragment | `{dd-id}.{Entity}` | `dd-user-auth.User` |
| Markdown link (References section) | `{prd-link}` | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |
| Inline markdown link (body) | `{adr-link}` | `[2026-06-21-adr-auth-strategy](../adrs/2026-06-21-adr-auth-strategy.md)` |
| Prose / table cell | `{prd-id}` | `2026-06-21-prd-user-auth` |
| Hierarchy tree (plan.md) | `{task-id}` | `2026-06-21-task-token-generation-be` |

### What changes in each template

For each template:

1. **Own `id:` line** — unchanged. Stays as `id: {prefix}-{slug}` (or
   `id: task-{slug}-{be|fe}` for task). The agent adds the date prefix per the manifest's
   `dated` flag when creating the artifact.
2. **Cross-reference frontmatter fields** — `feature: prd-{slug}` → `feature: {prd-id}`,
   `story: story-{slug}` → `story: {story-id}`, `tech-design: td-{slug}` →
   `tech-design: {td-id}`, `scenario: prd-{slug}#scenario-{N}` →
   `scenario: {prd-id}#scenario-{N}`.
3. **`refs:` and `depends-on:` list items** — `  - prd-{slug}` → `  - {prd-id}`,
   `  - task-{slug}-{be|fe}` → `  - {task-id}`.
4. **Prose, table cells, hierarchy trees** — `prd-{slug}` → `{prd-id}`, `story-{slug}` →
   `{story-id}`, `task-{slug}-be` → `{task-id}`.
5. **Markdown links** — `[prd-{slug}](../prds/prd-{slug}.md)` → `{prd-link}`,
   `[adr-{slug}](../adrs/adr-{slug}.md)` → `{adr-link}`.
6. **Generic reference pattern** (root templates `prd`/`feature-brief`/`press-release`) —
   `[{related-artifact-id}](../{folder}/{related-artifact-id}.md)` stays as-is (already
   parameterized; the agent fills in the referenced artifact's full ID and folder).

**Not changed:**

- **Own-id pattern references in prose** — e.g. "author an `adr-{slug}.md` first" in
  `tech-design.md`, "Each ADR is a standalone artifact (`adr-{slug}.md`)" in
  `system-architecture.md`. These describe creating/naming a new artifact of that type,
  not cross-referencing an existing one. They use the type's own-id pattern
  (`{prefix}-{slug}`), not the cross-ref placeholder.
- **Links to non-artifact files** — e.g. `wireframes/ds-{slug}.html` in `design-spec.md`.
  Here `ds-{slug}` is the design-spec's own slug used as a filename stem, not a
  cross-reference to another artifact.

### Illustrative example

> **Warning:** this diff is illustrative — it shows the shape of the change for one file.
> Match by the placeholder conventions above, not by hunting for these exact lines.

`templates/user-story.md`:

```diff
 ---
-id: story-{slug}
+id: story-{slug}
 type: user-story
 owner: business-analyst
 status: open | in-progress | done
 version: 1.0
-feature: prd-{slug}
+feature: {prd-id}
 priority: {P0 | P1 | P2}
 estimated-hours: {N}  # provisional — set by BA without technical context; refined later by plan
 depends-on:
-  - story-{slug}
+  - {story-id}
 refs:
-  - prd-{slug}
+  - {prd-id}
 ---
```

```diff
 ## Notes
-- **Dependencies:** None | story-{slug}
+- **Dependencies:** None | {story-id}

 ## References
-- [prd-{slug}](../prds/prd-{slug}.md)
+- {prd-link}
```

Parenthetical alias example — `templates/plan.md` Task Lanes (separation concern: two different
tasks on the same line, plus a third referenced across lines):

```diff
-### story-{slug} — {title}
-be: task-{slug}-be-1 → task-{slug}-be-2
-fe: task-{slug}-fe (blocked by be-2)
+### {story-id (P0 story)} — {title}
+be: {task-id (be-task-1)} → {task-id (be-task-2)}
+fe: {task-id (fe-task)} (blocked by be-2)
```

### After parameterization

Dating becomes manifest-only. To switch alternatives, set `dated: true` flags in
`manifest.yaml` — no template edits. The agent filling a template reads the manifest to
determine whether to add a date prefix to the own `id:`, and copies the full concrete ID
(including date if present) for cross-references.

---

## L2 — Reference docs & manifest

### `manifest.yaml` — `folder:` field (one-time)

Add a `folder:` field to each type, supporting `{<type>-link}` placeholder expansion. The
folder mapping currently lives only in `reference/folder-structure.md` as prose; it
becomes structured data in the manifest. Folder names are **not derivable** from the
prefix or type name by any simple rule (`sa-` → `system-architectures/`, not `sas/`), so
the mapping must be explicit.

| Type | Prefix | Folder |
|---|---|---|
| feature-brief | `fb-` | `feature-briefs/` |
| prd | `prd-` | `prds/` |
| press-release | `pr-` | `press-releases/` |
| user-story | `story-` | `user-stories/` |
| user-flow | `uf-` | `user-flows/` |
| design-spec | `ds-` | `design-specs/` |
| adr | `adr-` | `adrs/` |
| system-architecture | `sa-` | `system-architectures/` |
| api-spec | `api-` | `api-specs/` |
| data-design | `dd-` | `data-designs/` |
| tech-design | `td-` | `tech-designs/` |
| task | `task-` | `tasks/` |
| plan | `plan-` | `plans/` |
| test-spec | `ts-` | `test-specs/` |
| note | `note-` | `notes/` |

### `manifest.yaml` — `dated:` flags (per-alternative)

Add `dated: true` to each type in the chosen alternative's column above. Remove
`dated: true` to revert. This is the **only** edit needed to switch alternatives after
the one-time parameterization is applied.

### `reference/artifact-frontmatter.md` — ID Naming Pattern (unified)

One section, references manifest — not three per-alternative sections:

```
## ID Naming Pattern

`{prefix}-{slug}` — where `{prefix}` comes from `../manifest.yaml` under `types`.
For types with `dated: true`, the ID is `{YYYY-MM-DD}-{prefix}-{slug}`.
Date is creation date only — never updated on revision.

- No auto-incrementing integers
- Date prefix is **creation date only** — never updated on revision or re-acceptance
  (keeps IDs stable so `refs`/`feature`/`story` links don't break)
- Prefix list and `dated` flag are authoritative in `../manifest.yaml` under `types`

Examples: `fb-user-authentication-login`, `api-user-authentication`, `dd-user-authentication`, `2026-06-21-task-token-generation-be`.
```

Also update the `feature` field description in Optional Fields:

```
Downstream artifacts (user-story, user-flow, system-architecture, tech-design, test-spec, and plan) carry: `feature` — the ID of the feature's PRD. This links the artifact to its requirements root; see `artifact-dep-graph.md`. The ID format follows the ID Naming Pattern above (dated if the requirements-root type has `dated: true`).
```

### `reference/vault-queries.md` (already applied)

Uses `id: (\d{4}-\d{2}-\d{2}-)?prefix-` regex — works regardless of which alternative is
active. No per-alternative changes needed.

**Does not change:**
- Folder structure (`folder-structure.md`) — folders and their prefix annotations are
  unchanged; only filenames within folders shift when dating is applied.
- Dependency graph (`artifact-dep-graph.md`) — dependencies are unchanged.
- Artifact vocabulary (`artifact-vocabulary.md`) — type definitions are unchanged.
- Agent ownership (`artifact-ownership.md`) — ownership is unchanged.
- Lifecycle (`artifact-lifecycle.md`) — status labels are unchanged.
- The `type:` frontmatter field and all `type:`-based grep queries — these search for
  the type name, not the ID, so the date prefix has no effect.

---

## Apply

### One-time parameterization (do once)

1. **L1 — Templates:** Apply the placeholder conventions above to all 15 templates.
   Work file-by-file; each template's cross-references map to `{<type>-id}` or
   `{<type>-link}` per the context table. Own `id:` lines and own-id-pattern prose
   references are unchanged.

2. **L2 — `manifest.yaml`:** Add `folder:` field to each type per the folder mapping
   table above.

3. **L2 — `reference/artifact-frontmatter.md`:** Replace the ID Naming Pattern section
   and the `feature` field description in Optional Fields with the unified versions
   above.

### Per-alternative switch (do each time you switch alternatives)

4. **Read `manifest.yaml`** — check which types already have `dated: true`. If the
   chosen alternative is already the current state, skip to Verify.

5. **L2 — `manifest.yaml`:** Add or remove `dated: true` flags on each type to match
   the chosen alternative's column in the dated type sets table.

6. **Run Verify** (below) to catch misses.

---

## Verify

Run these assertions after applying. The one-time parameterization assertions hold
regardless of which dating alternative is active.

### One-time parameterization assertions

```bash
# Templates: no residual hardcoded cross-ref patterns (own id: lines excepted)
# Cross-ref frontmatter fields should use {<type>-id}, not P-{slug}
rg -l "feature: prd-\{slug\}" templates/
# Expected: 0 (was 6: every downstream template)
rg -l "story: story-\{slug\}" templates/
# Expected: 0 (was 1: task.md)
rg -l "tech-design: td-\{slug\}" templates/
# Expected: 0 (was 1: task.md)

# Cross-ref refs/depends-on list items should use {<type>-id}
rg -l "^  - prd-\{slug\}" templates/
# Expected: 0
rg -l "^  - task-\{slug\}-\{be" templates/
# Expected: 0

# Markdown links should use {<type>-link}, not [P-{slug}](../folder/P-{slug}.md)
rg -l "\[prd-\{slug\}\]\(\.\./prds/prd-\{slug\}\.md\)" templates/
# Expected: 0
rg -l "\[adr-\{slug\}\]\(\.\./adrs/adr-\{slug\}\.md\)" templates/
# Expected: 0

# Own id: lines should still use {prefix}-{slug} (unchanged)
rg -l "^id: prd-\{slug\}" templates/
# Expected: 1 (templates/prd.md)
rg -l "^id: task-\{slug\}-\{be" templates/
# Expected: 1 (templates/task.md)

# manifest.yaml: every type has a folder: field
rg -c "folder:" manifest.yaml
# Expected: 15
```

### Per-alternative assertions

```bash
# `none`: no type has dated: true
rg -c "dated: true" manifest.yaml
# Expected: 0

# `snapshot-style`: exactly 10 types have dated: true
rg -c "dated: true" manifest.yaml
# Expected: 10
# Living types lack the flag
rg -A2 "name: system-architecture" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: api-spec" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: data-design" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: design-spec" manifest.yaml | rg "dated: true"
# Expected: 0 hits
rg -A2 "name: test-spec" manifest.yaml | rg "dated: true"
# Expected: 0 hits

# `all`: exactly 15 types have dated: true
rg -c "dated: true" manifest.yaml
# Expected: 15

# artifact-frontmatter.md: unified pattern present (no per-alternative sections)
rg "For types with .dated: true." reference/artifact-frontmatter.md
# Expected: ≥1 hit
rg "No timestamps" reference/artifact-frontmatter.md
# Expected: 0 hits (rule replaced by creation-date rule)
rg "creation date only" reference/artifact-frontmatter.md
# Expected: ≥1 hit

# vault-queries.md: optional date-prefix regex present (already applied)
rg "\\(\\\\d\{4\}-\\\\d\{2\}-\\\\d\{2\}-\\)\?" reference/vault-queries.md
# Expected: ≥1 hit
```

---

## Notes

- **Orthogonality with `requirements-root.md`:** This decision is orthogonal to the
  requirements-root decision. With parameterized templates, the requirements-root
  switch is also manifest-only (changing `feature_type` and which type owns the
  requirements-root prefix). The two decisions touch disjoint aspects of the ID (date
  prefix vs. type prefix) and both are now manifest-driven after parameterization.

- **Orthogonality with `ask-threshold.md`:** No interaction — different files entirely.

- **`plan` is the weakest fit in the `snapshot-style` dated set.** Plans get
  re-sequenced as work progresses — more living than the other dated types. Kept dated
  on the "frozen record" rationale; the creation date may go stale faster here than
  elsewhere. Acceptable trade-off for chronological sortability in the `plans/` folder.

- **Considered and rejected — `derivative-only` alternative:** Dating only types with
  outgoing `Produces` edges in the dep graph (prd, user-story, user-flow,
  system-architecture, api-spec, data-design, design-spec, tech-design). Rejected
  because it leaves `adr`, `task`, and `note` undated — the three types where a creation
  date is most human-meaningful (ADR = point-in-time decision; task = "when was this
  done?"; note = scratchpad timestamp). The `snapshot-style` alternative covers both
  derivative anchors and frozen records.

- **Considered and rejected — 2A (type-specific prefix placeholders):** `{prd-prefix}-{slug}`
  per cross-reference. Rejected because it requires 6-8 new placeholder conventions per
  template and multiple manifest lookups per fill, while still leaving folder paths
  hardcoded. 2B's full-ID + link approach parameterizes both prefixes and folders with
  one placeholder per context.

- **Considered and rejected — 2C hybrid (parameterize folders only):** Keep prefixes
  hardcoded (token map handles dating) but parameterize folder paths via
  `{<type>-folder}`. Rejected because it mixes two change mechanisms in the same
  markdown link expression — with dating applied, the link becomes
  `[{date}-prd-{slug}](../{prd-folder}/{date}-prd-{slug}.md)` — the ID part is
  token-mapped, the folder part is parameterized. Once the upfront parameterization
  cost is paid, 2B covers both prefixes and folders uniformly; no reason to pay the cost
  twice.

- **Migration caveat for existing vaults:** If the vault already contains artifacts with
  un-dated IDs, applying this decision changes templates and conventions but does **not**
  retroactively rename existing artifact files. Existing artifacts keep their un-dated
  IDs; new artifacts created from updated templates get dated IDs. A separate migration
  pass (not covered by this decision) would be needed to rename existing files and
  update all `refs`/`feature`/`story` links pointing at them.

- **Placeholder vocabulary:** Templates use `{prefix}-{slug}` for own IDs,
  `{<type>-id}`/`{<type>-link}` for cross-references, and `{slug}`/`{title}`/`{N}` etc.
  for other fill-in fields — consistent with existing placeholder conventions. The
  agent filling the template resolves `{<type>-id}` to the referenced artifact's full
  concrete ID (which it already knows) and `{<type>-link}` to the full markdown link
  (ID + folder from manifest + `.md`).
