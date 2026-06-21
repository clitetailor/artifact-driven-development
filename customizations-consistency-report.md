# Customizations Consistency Report

### Files reviewed
- `customizations/README.md`, `FORMAT.md`
- `customizations/requirements-root.md`, `ask-threshold.md`, `artifact-id-dating.md`
- Cross-checked against: `manifest.yaml`, `AGENTS.md`, all 15 templates, `reference/` docs, `PROJECT.md`, `handbook/playbooks/setup.md`, `handbook/customization.md`, `handbook/playbooks/customize-artifacts.md`

---

### `ask-threshold.md` — CLEAN

Fully consistent with FORMAT.md, README.md, and the current `AGENTS.md` state (`always-ask-first` is active). Alternatives table has the Role column, all three per-alternative sections present, Apply/Verify/Notes all correct. No issues found.

---

### `artifact-id-dating.md` — 2 minor issues

**Issue A — Missing "role" column in Alternatives table.** FORMAT.md §Alternatives table specifies "prefix, folder, role (default/alternative), and key identifiers." This file's table has `| Alternative | Dated types | Undated types |` with no role column. `none` is the shipped default; the other two are alternatives. `ask-threshold.md` has the Role column; this one should too.

**Issue B — No per-alternative sections (structural deviation).** FORMAT.md Principle 7 says an alternative with only a table row (no per-alternative section) is "pending." This file has no `### none`, `### snapshot-style`, `### all` sections — the manifest field values are inline in the Apply section instead. The content is all there and correct (I verified all 15 type prefixes against `manifest.yaml`, the 10/5 split is accurate, the `snapshot-style` rationale lists match the table). But the structure doesn't match FORMAT.md's expected per-alternative section pattern. `handbook/customization.md` line 31-32 says manifest-only class uses "the manifest field value" as the per-alternative content — so inline-in-Apply may be acceptable, but it conflicts with Principle 7's "only a row = pending" rule.

**Everything else checks out:** dated type sets table (15 types, prefixes, ✓/— grid) all match `manifest.yaml`; placeholder reference section matches actual template content; Apply/Verify blocks are correct; orthogonality notes are accurate.

---

### `requirements-root.md` — 6 issues (most serious)

#### Issue 1 — Verify section uses stale non-placeholder patterns (BROKEN)

The L1 section was updated to use the `{<stem>-id}` / `{<stem>-link}` placeholder system (referencing `artifact-id-dating.md` → "Template placeholder reference"), but the **Verify section was not updated**. It still uses old literal patterns that don't appear in any template:

| Verify command | Problem |
|---|---|
| `rg -l "feature: {cur_prefix}-\{slug\}" templates/` | Templates use `feature: {prd-id}`, not `feature: prd-{slug}`. Always returns 0 — vacuously true, verifies nothing. |
| `rg -l "\.\./{cur_folder}/{cur_prefix}-\{slug\}\.md" templates/` | Templates use `{prd-link}` placeholder, not literal `../prds/prd-{slug}.md` paths. Always returns 0. |
| `rg -l "feature: {new_prefix}-\{slug\}" templates/  # expect: 12 files` | Wrong pattern (same as above) AND wrong count. Actual count is **10** templates (verified by grep), not 12. |

The correct Verify patterns should use `\{cur_stem-id\}` / `\{new_stem-id\}` and `\{cur_stem-link\}` / `\{new_stem-link\}`, matching the L1 token map. The count should be 10, not 12.

<ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/customizations/requirements-root.md" lines="579-590" />

#### Issue 2 — L2 "full final state" for `artifact-frontmatter.md` is stale

The prd section (which should match the current file since `prd` is the active default) doesn't match `reference/artifact-frontmatter.md` line 30:

| Customization says (line 223) | Actual file says (line 30) |
|---|---|
| `...the ID of the feature's PRD (\`prd-\` prefixed). This links the artifact to its requirements root; see \`artifact-dep-graph.md\`.` | `...the ID of the feature's PRD. This links the artifact to its requirements root; see \`artifact-dep-graph.md\`. The ID format follows the ID Naming Pattern above (dated if the type is listed in \`manifest.yaml\`'s \`dated_types:\`).` |

The customization **adds** `(\`prd-\` prefixed)` and **drops** the dating reference sentence. Applying the prd alternative (should be a no-op) would corrupt the file. All three per-alternative sections for this file have the same staleness.

<ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/customizations/requirements-root.md" lines="220-224" /> vs <ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/reference/artifact-frontmatter.md" lines="29-30" />

#### Issue 3 — L2 "full final state" for `vault-queries.md` is stale

The prd section uses old query patterns without the optional date-prefix regex. Current `vault-queries.md` was updated with `(\d{4}-\d{2}-\d{2}-)?` optional date-prefix patterns and a "Date-prefixed IDs" paragraph (line 6). The customization's per-alternative blocks predate this update:

| Customization says (line 276) | Actual file says (line 21) |
|---|---|
| `rg -l --glob '!.*' "^id: prd-user-auth" {vault-root}/` | `rg -l --glob '!.*' "id: (\d{4}-\d{2}-\d{2}-)?prd-user-auth" {vault-root}/` |

The customization also omits the "Date-prefixed IDs" paragraph and the `# Uses optional date-prefix regex` comment lines. Applying any alternative would regress the file. All three per-alternative sections have the same staleness.

<ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/customizations/requirements-root.md" lines="263-287" /> vs <ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/reference/vault-queries.md" lines="4-35" />

#### Issue 4 — L2 "full final state" for `setup.md` references a line that no longer exists

The prd section (line 291-293) shows:
```
Agent: Which pattern should identify a feature? (Default is `prd` — ...)
```
This line **does not exist** in `handbook/playbooks/setup.md`. The setup flow was rewritten — the feature-type question was removed and replaced with a pointer to `customize-artifacts.md` (lines 72, 78). All three per-alternative sections for setup.md are stale.

<ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/customizations/requirements-root.md" lines="289-293" /> vs <ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/handbook/playbooks/setup.md" lines="72-78" />

#### Issue 5 — Missing edit: `artifact-dep-graph.md` line 83

`reference/artifact-dep-graph.md` line 83 says:
```
*Requirements-root alternatives (`feature-brief`, `press-release`) are customization selectable — see `../handbook/customization.md` and `../customizations/README.md`. An alternative shares the default type's dependencies shown above (the graph depicts the `prd` default).*
```

When switching alternatives, this line needs two changes: (a) the alternatives list (`feature-brief`, `press-release` → `prd`, `press-release` when switching to feature-brief) and (b) "the graph depicts the `prd` default" → "the graph depicts the `feature-brief` default". **None of the three per-alternative sections show this edit.** The dep-graph sections only show the phase row, mermaid node, and dependency table — they miss this note entirely.

<ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/reference/artifact-dep-graph.md" lines="83-83" />

#### Issue 6 — Missing edit: `artifact-vocabulary.md` feature-brief row in press-release section

When switching to `press-release`, the feature-brief row currently says "a lighter requirements-root alternative to **prd**" and should change to "a lighter requirements-root alternative to **press-release**". The `press-release` per-alternative section (lines 438-441) only shows the prd and press-release rows — it omits the feature-brief row update.

(The `feature-brief` section correctly omits the press-release row because press-release's current text — "a requirements-root alternative using..." — doesn't mention prd by name, so it doesn't need to change. But feature-brief's text *does* mention prd by name, so it must change when press-release becomes default.)

<ref_snippet file="D:/Private/Code/playground/add-framework/software-seedbed/customizations/requirements-root.md" lines="436-441" />

#### Minor: Missing "role" column in Alternatives table

Same as artifact-id-dating.md Issue A — the table has `| Alternative | Prefix | Folder | Display name |` with no role column. `prd` is the shipped default (labeled "(default)" in the per-alternative section heading but not in the table).

---

### Cross-file consistency — OK

- `README.md` table lists all 3 axes with correct alternatives ✓
- `handbook/customization.md` mechanism-class table lists all 3 axes correctly ✓
- `handbook/playbooks/customize-artifacts.md` describes all 3 mechanism classes correctly ✓
- `manifest.yaml` current state (`feature_type: prd`, `dated_types: []`) matches the "default" alternatives ✓
- `AGENTS.md` current state matches `always-ask-first` ✓
- L1 header "10 downstream files" matches actual grep count (10 templates with `{prd-id}`) ✓
- L2 "9 files" count matches the per-alternative file list ✓
- All 15 type prefixes in `artifact-id-dating.md` match `manifest.yaml` ✓
- `artifact-id-dating.md` snapshot-style 10/5 split is internally consistent ✓
- Orthogonality claims are accurate (axes touch disjoint files) ✓

---

### Summary by severity

| Severity | File | Issue |
|---|---|---|
| **Broken** | requirements-root.md | Verify section uses stale patterns — would silently pass without checking anything; count wrong (12 vs 10) |
| **Corrupting** | requirements-root.md | L2 blocks for `artifact-frontmatter.md` stale — applying would drop dating sentence, add spurious `(\`prd-\` prefixed)` |
| **Corrupting** | requirements-root.md | L2 blocks for `vault-queries.md` stale — applying would regress date-prefix regex patterns |
| **Stale** | requirements-root.md | L2 blocks for `setup.md` reference a line that no longer exists |
| **Incomplete** | requirements-root.md | Missing edit for `artifact-dep-graph.md` line 83 (alternatives list + "depicts the `prd` default") |
| **Incomplete** | requirements-root.md | Missing feature-brief row update in press-release section of `artifact-vocabulary.md` |
| **Format** | requirements-root.md, artifact-id-dating.md | Missing "role" column in Alternatives table (FORMAT.md requires it) |
| **Format** | artifact-id-dating.md | No per-alternative sections — content is inline in Apply, conflicts with Principle 7 |

The root cause for issues 1–4: the `artifact-id-dating.md` customization (and the broader placeholder/dating system) was added after `requirements-root.md` was written, and the reference docs (`artifact-frontmatter.md`, `vault-queries.md`, `setup.md`) were updated to reflect dating — but `requirements-root.md`'s L2 "full final state" blocks and Verify section were never regenerated to match. The customization file drifted from the files it claims to control.
