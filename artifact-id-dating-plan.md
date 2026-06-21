# Plan: artifact-id-dating — Open Questions (Q1-Q4)

> Working document. Resolve Q1-Q4 below before revising
> `decisions/artifact-id-dating.md`. Each question lists options, pros/cons, and a
> recommendation. The current draft (`decisions/artifact-id-dating.md`, v1) uses the
> "No" answer for all four — i.e. per-alternative sections, mixed `{slug}`/`{descriptor}`,
> hardcoded prefixes, separate frontmatter/queries per alternative.
>
> Status legend: [ ] unresolved · [x] resolved

---

## Context

The dating decision (`decisions/artifact-id-dating.md`) adds an optional `YYYY-MM-DD-`
creation-date prefix to artifact IDs for dated types. The v1 draft handles this with
per-alternative sections that edit 15 templates + 3 reference docs per switch.

Four questions arose during review about whether the draft's structure is the right
shape at all — specifically, whether some of the cost can be eliminated by unifying
patterns or parameterizing templates. These questions are **orthogonal to the dating
decision itself** (which types are dated, what the date means) — they're about *how the
decision file is structured* and *what it edits*.

---

## Q1 — Standardize token map to `{slug}` only, no `{descriptor}` special case? [x] → 1A (applied)

**Current state:** `{descriptor}` appears in 2 templates
(`templates/feature-brief.md` line 2: `id: fb-{descriptor}`;
`templates/test-spec.md` line 2: `id: ts-{feature}-{descriptor}`). All other 13
templates use `{slug}`. `reference/artifact-frontmatter.md` uses `{descriptor}` as the
generic pattern term (lines 9, 52). There is **no documented semantic difference**
between `{slug}` and `{descriptor}` — they're synonyms.

### Option 1A: Yes, standardize to `{slug}`

| Pros | Cons |
|---|---|
| Token map drops from 2 rows to 1 — no special-case paragraph in the decision file | 2 template line edits + 2 lines in `artifact-frontmatter.md` |
| One find command pattern, not two | Scope expansion: this is a template normalization, not a dating change — should be called out as bundled normalization, not silently folded in |
| Consistent placeholder vocabulary across all templates | |
| `ts-{feature}-{descriptor}` → `ts-{slug}` collapse loses no information (feature tie lives in `feature:` frontmatter) | |

### Option 1B: No, keep `{descriptor}` as-is

| Pros | Cons |
|---|---|
| No template edits beyond dating | Two placeholder terms for the same concept — ongoing confusion |
| | Token map needs 2 rows + special-case paragraph |

**Recommendation: 1A (yes, standardize).** The `{descriptor}`/`{slug}` split is an
accident, not a design. Bundle it as an explicit normalization step in the decision's
L1.

---

## Q2 — Parameterize template prefixes so dating becomes manifest-only? [x] → 2B (chosen)

**Current state (v1 draft):** Templates hardcode type prefixes (`prd-{slug}`,
`task-{slug}`, etc.). Every prefix-related decision (dating, requirements-root) must
edit 15 templates per alternative switch.

The grep data: **100 prefix-slug occurrences across 15 templates**, with templates
cross-referencing up to 8 other types (e.g. `task.md` references prd, td, api, dd, sa,
story, ts, task).

### Option 2A — Type-specific prefix placeholders (`{prd-prefix}-{slug}`)

Cross-references become `{prd-prefix}-{slug}`, `{sa-prefix}-{slug}`, etc. Agent looks
up each type's prefix from manifest.

| Pros | Cons |
|---|---|
| Templates fully parameterized; L1 is a no-op for ALL prefix-related decisions | 6-8 new placeholder conventions per template (`{prd-prefix}`, `{sa-prefix}`, etc.) |
| | Agents must resolve multiple manifest lookups per template fill |
| | Heavy upfront refactor of all 15 templates (100 occurrences) |

### Option 2B — Full-ID + link placeholders for cross-references (`{prd-id}`, `{prd-link}`)

Own `id:` uses `{prefix}-{slug}`. Cross-references use two placeholders depending on
context:

- **`{<type>-id}`** — the complete concrete ID of the referenced artifact (e.g.
  `2026-06-21-prd-user-auth`). Used in frontmatter fields, `refs:` lists, prose, and
  hierarchy trees.
- **`{<type>-link}`** — the full markdown link to the referenced artifact (e.g.
  `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)`). Used in the
  `## References` section and inline markdown links.

The `{<type>-link}` placeholder eliminates ID repetition in links (the ID currently
appears twice in `[prd-{slug}](../prds/prd-{slug}.md)`) and parameterizes the folder
path, so folder renames become manifest-only edits.

**Requires:** a `folder:` field on each type in `manifest.yaml` (e.g.
`folder: prds/`). The folder mapping is currently only documented in
`reference/folder-structure.md` as prose — it would become structured data in the
manifest. This is scope expansion beyond the parameterization decision, but it enables
future folder path changes without editing templates.

| Pros | Cons |
|---|---|
| One placeholder per reference context — no ID repetition in links | Two placeholder types instead of one (`{<type>-id}` + `{<type>-link}`) |
| Folder path parameterized — future folder renames are manifest-only edits | Requires adding `folder:` field to `manifest.yaml` types (scope expansion) |
| Agent already knows the referenced artifact's full ID — just copies it | Bigger conceptual shift: `{slug}` = "fill in slug" vs `{prd-id}` = "fill in full ID" |
| More correct than current approach: today `feature: prd-{slug}` assumes agent fills just slug, but with dating the agent would need to fill `2026-06-21-prd-user-auth` as `{slug}` — which is wrong | Agent must construct full markdown link when filling `{<type>-link}` (ID + folder + `.md`) |
| Immune to prefix changes (dating, requirements-root) AND folder changes — full ID and link resolved at fill time | Still a 100-occurrence refactor |
| Template reader sees clean `{prd-link}` instead of complex link syntax | Less transparent — reader can't see the link structure in the template |

#### Folder mapping (required for `{<type>-link}`)

The type → folder mapping currently lives only in `reference/folder-structure.md` as
prose. To support `{<type>-link}`, it must become structured data in `manifest.yaml`:

| Type | Folder |
|---|---|
| feature-brief | `feature-briefs/` |
| prd | `prds/` |
| press-release | `press-releases/` |
| user-story | `user-stories/` |
| user-flow | `user-flows/` |
| design-spec | `design-specs/` |
| adr | `adrs/` |
| system-architecture | `system-architectures/` |
| api-spec | `api-specs/` |
| data-design | `data-designs/` |
| tech-design | `tech-designs/` |
| task | `tasks/` |
| plan | `plans/` |
| test-spec | `test-specs/` |
| note | `notes/` |

Folder names are **not derivable** from the prefix or type name by any simple rule
(`sa-` → `system-architectures/`, not `sas/`), so the mapping must be explicit.

#### Placeholder contexts

| Context | Placeholder | Example expansion |
|---|---|---|
| Frontmatter field | `{prd-id}` | `feature: 2026-06-21-prd-user-auth` |
| `refs:` list | `{prd-id}` | `- 2026-06-21-prd-user-auth` |
| `scenario:` with fragment | `{prd-id}#scenario-{N}` | `scenario: 2026-06-21-prd-user-auth#scenario-1` |
| Markdown link (References section) | `{prd-link}` | `[2026-06-21-prd-user-auth](../prds/2026-06-21-prd-user-auth.md)` |
| Prose/table cell | `{prd-id}` | `2026-06-21-prd-user-auth` |
| Hierarchy tree (plan.md) | `{task-id}` | `2026-06-21-task-token-generation-be` |

### Option 2C — Keep current approach (hardcoded prefixes, token map handles dating)

| Pros | Cons |
|---|---|
| No template refactor needed | Every prefix-related decision must edit 15 templates |
| Templates stay simple and readable | Switching alternatives is a 15-file operation, not 1-file |
| Decision file carries the cost, not the templates | Folder paths hardcoded in templates — folder renames require editing all 15 templates (via token map) |

**Note — 2C hybrid (parameterize folders only):** A middle ground exists — keep
prefixes hardcoded (token map handles dating/prefix changes) but parameterize only
folder paths using `{<type>-folder}` in link expressions:

```
[prd-{slug}](../{prd-folder}/prd-{slug}.md)
```

This makes folder renames manifest-only (requires `folder:` field in `manifest.yaml`,
same scope expansion as 2B) while keeping prefix changes as 15-template token-map edits.
**Rejected because:** it mixes two change mechanisms in the same markdown link
expression — with dating applied, the link becomes
`[{date}-prd-{slug}](../{prd-folder}/{date}-prd-{slug}.md)` — the ID part is
token-mapped, the folder part is parameterized. This is workable but conceptually muddy
("why is the folder parameterized but the ID isn't?") and harder to teach. Once the
upfront parameterization cost is paid, 2B covers both prefixes and folders uniformly —
no reason to pay the cost twice (once for folders via hybrid, again for prefixes later).

**Chosen: 2B (full-ID + link placeholders).** One placeholder per reference context, no
ID repetition in links, and folder paths parameterized for future renames. The
`folder:` field addition to `manifest.yaml` is scope expansion but enables a preference
the user has stated: updating artifact folder paths in the future without editing
templates. The packaging question — whether to bundle this refactor into
`artifact-id-dating.md` or split it into a separate
`template-prefix-parameterization.md` decision — is orthogonal to the approach choice
and can be decided separately.

---

## Q3 — Unified frontmatter pattern or per-alternative sections? [x] → 3A (implied by 2B)

**Current state (v1 draft):** Three separate ID Naming Pattern sections in
`reference/artifact-frontmatter.md` — one per alternative (`none`, `snapshot-style`,
`all`), each with full final state.

### Option 3A — Unified (one section, references manifest)

```
## ID Naming Pattern

`{prefix}-{slug}` — where `{prefix}` comes from `../manifest.yaml` under `types`.
For types with `dated: true`, the ID is `{YYYY-MM-DD}-{prefix}-{slug}`.
Date is creation date only — never updated on revision.
```

| Pros | Cons |
|---|---|
| One section to maintain, not three | Slightly less explicit — reader must check manifest to know which types are dated |
| Frontmatter doc doesn't change when switching alternatives | More accurate, not less: the unified approach says "depends on manifest" — which is the actual truth |
| Consistent with "manifest is source of truth" principle | |
| Decision file's L2 frontmatter section becomes minimal/no-op | |

### Option 3B — Per-alternative (current v1 approach)

| Pros | Cons |
|---|---|
| Each alternative's state is fully explicit | Three sections to maintain |
| Reader sees the exact pattern without manifest lookup | Frontmatter doc changes on every alternative switch |
| | Inconsistent with "manifest is source of truth" |

**Chosen: 3A (unified), implied by Q2 → 2B.** With 2B, the ID pattern is
manifest-driven by construction: `{prefix}-{slug}` with optional date prefix per the
`dated` flag. This is one pattern, not three — the only thing that changes between
alternatives is which types have `dated: true` in the manifest (manifest data, not
pattern description). Writing three versions of the same pattern would be redundant and
inconsistent with the manifest being the source of truth. 3B has no practical rationale
once 2B is adopted.

---

## Q4 — Unified vault-queries or per-alternative query sets? [x] → 4A (applied)

**Current state (v1 draft):** Per-alternative query updates — `^id:` anchors switch to
`id:.*` wildcards for dated types, with separate query sections per alternative.

### Option 4A — Unified with precise regex (`(\d{4}-\d{2}-\d{2}-)?`)

Always use `id: (\d{4}-\d{2}-\d{2}-)?prefix-` for ID-anchored queries. Optionally
matches a date prefix.

| Pros | Cons |
|---|---|
| Queries work regardless of which alternative is active | More complex pattern than `^id:` |
| vault-queries.md doesn't change when switching alternatives | Self-documenting: the optional date group tells the reader "this type might be dated" |
| No false positives (unlike `id:.*`) | |
| `type:` and `status:` queries completely unaffected | |

### Option 4B — Unified with loose wildcard (`id:.*`)

Always use `id:.*prefix-` for ID-anchored queries.

| Pros | Cons |
|---|---|
| Simpler pattern | Precision loss: `id:.*prd-` could match `id: fb-something-prd-related` (theoretical, prevented by naming conventions) |
| Queries work regardless of which alternative is active | |

### Option 4C — Per-alternative (current v1 approach)

| Pros | Cons |
|---|---|
| Each alternative's queries are explicit | vault-queries.md changes on every alternative switch |
| | Three query sets to maintain |

**Recommendation: 4A (unified with precise regex).** The `(\d{4}-\d{2}-\d{2}-)?` pattern
matches both dated and undated IDs without false positives. The decision file's L2
vault-queries section becomes a one-time edit, stable across alternative switches.

---

## How the four interact

| Q1 | Q2 | Q3 | Q4 | Result |
|---|---|---|---|---|
| No | No (2C) | No (3B) | No (4C) | v1 draft as-is: per-alternative sections, 15-template token map, mixed placeholders |
| Yes | No (2C) | Yes (3A) | Yes (4A) | v1 draft with unified frontmatter/queries + `{slug}` standardization; templates still edited per alternative |
| Yes | Yes (2B) ✓ | Yes (3A) ✓ | Yes (4A) ✓ | Parameterized templates + unified frontmatter/queries; switching alternatives = manifest-only edit; folder renames = manifest-only edit |

Q2 is resolved → 2B. The chosen path requires a one-time parameterization refactor
(100 occurrences across 15 templates) plus a `folder:` field addition to
`manifest.yaml` to support `{<type>-link}` placeholders. The packaging question
(bundle into `artifact-id-dating.md` vs split into separate
`template-prefix-parameterization.md`) remains open and orthogonal.

---

## Next steps

1. Resolve Q1-Q4 (mark each [x] with chosen option).
2. If Q2 = 2A or 2B: decide whether to bundle the parameterization refactor into
   `artifact-id-dating.md` or split it into a separate
   `template-prefix-parameterization.md` decision (orthogonal packaging choice). Then
   revise `decisions/artifact-id-dating.md` accordingly.
3. If Q2 = 2C: revise `decisions/artifact-id-dating.md` in place to adopt Q1/Q3/Q4
   choices, keeping the 15-template token map.
4. Apply the resulting decision(s) to the vault.
