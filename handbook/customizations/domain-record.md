# Customization: domain-record type

> Selects the vault's long-lived, domain-scoped State artifact that gives product
> requirements a dedicated, evergreen home — instead of scattering them across
> `test-spec`, `data-design`, and `api-spec`. The framework ships with `system-capability`
> active by default; `domain-model` is the opt-in alternative. Switching alternatives
> later = apply a different alternative's value.
>
> For the apply flow, see `../playbooks/customize-vault.md`.

---

## What changes

The `domain_record:` field in `manifest.yaml` selects the vault's domain-record type. The
shipped default is `system-capability` — a dedicated domain-record is active out of the box.
Setting it to `domain-model` switches to that type instead. Both types are already part of
the framework's dependency graph, ownership table, and vocabulary.

Unlike `requirements-root` (a manifest-only edit), the domain-record also introduces its
artifact type into the vault's `types:` list — but the framework ships both types
(`system-capability`, `domain-model`) pre-registered in `manifest.yaml`, so no `types:` edit
is needed at apply time. Only the `domain_record:` selector line moves.

**Framework shipped default:** `system-capability`. The reference docs depict the framework
with `system-capability` active and note that the active type is in `manifest.yaml` — they
are already updated to describe both alternatives and the selector field.

---

## Alternatives

| Alternative | Role | Prefix | Folder | Display name | Owner | Mindset |
|---|---|---|---|---|---|---|
| `system-capability` | Default | `sc-` | `system-capabilities/` | System Capability | business-analyst | Behavioral — "what actions can be performed, and what are the rules?" |
| `domain-model` | Alternative | `dm-` | `domain-models/` | Domain Model | software-architect (primary), business-analyst (contributor) | Structural (DDD) — "what are the core nouns, their data, and allowed state changes?" |

"Default" = the framework's shipped starting option (a static fact). The current state is
whatever `manifest.yaml`'s `domain_record:` says right now.

The two alternatives are **single-select** — they share authority-conflicting sections
(Business Rules & Invariants; State Transitions / entity lifecycle). Using both creates
competing sources of truth. There is no `none` peer; the vault always has exactly one
domain-record type active.

---

## How to choose

| Signal | → `system-capability` | → `domain-model` |
|---|---|---|
| Domain complexity | SaaS, e-commerce, consumer apps | Fintech, healthcare, complex logistics |
| Team composition | Cross-functional (PMs, QA, support) | Engineering-heavy, architects, technical PMs |
| Readability priority | High — non-technical accessible | Low — systems thinking required |
| Language | Plain English, bulleted lists | Ubiquitous Language + pseudo-code |
| Maps closely to | `user-flow` & `test-spec` | `data-design` & `api-spec` (backend code) |
| Owner model | Single owner (business-analyst) | Co-authored (SA primary, BA contributor) |

Pick `system-capability` when the priority is a legible, evergreen "system law" for
cross-functional readers. Pick `domain-model` when the domain is precision-critical and
engineering needs a strict upstream authority for `data-design` and `api-spec`.

---

## Per-alternative manifest values

Each alternative is realized by a single `manifest.yaml` edit — setting the
`domain_record:` line. The values below are the full final state of that line for each
alternative.

### `system-capability` *(default)*

```
domain_record: system-capability
# domain_record: domain-model        # switch — structural DDD approach (SA primary, BA contributor)
```

### `domain-model`

```
domain_record: domain-model
```

---

## Workflow role

The domain-record adds a State layer to the workflow (Discipline 0 in
`reference/artifact-dep-graph.md`):

- **Context & Ideation:** `feature-brief` / `user-story` read the domain-record before
  drafting a Delta — the domain's current capabilities/entities ground the proposal.
- **Merge & Archive:** after ship, the requirements delta in
  `feature-brief` / `user-story` merges back into the domain-record. The Delta artifacts
  are then archived (frozen as history); the domain-record lives on as the evergreen truth.

When `domain-model` is adopted, it additionally becomes the **upstream authority** for
`data-design` and `api-spec` in the same domain — they translate domain entities + events
into storage schemas and contracts respectively. `data-design`'s entity definitions and
business rules defer to `domain-model`; `data-design` owns only the physical schema,
columns, indexes, and pipeline stages.

Ownership updates (see `reference/artifact-ownership.md`):

- `system-capability` → `business-analyst` (single owner)
- `domain-model` → `software-architect` (primary) + `business-analyst` (contributor, with
  section-level authority: Business Rules & Invariants; co-authors Ubiquitous Language)

---

## Apply

1. **Read `manifest.yaml`** — check the current `domain_record:` value. If it already
   matches the chosen alternative, skip to Verify.

2. **`manifest.yaml`:** Replace the `domain_record:` line with the chosen alternative's
   value from its per-alternative section above. The `system-capability` and `domain-model`
   types are already registered in `types:` — no `types:` edit is needed.

3. **Run Verify** (below) to confirm.

---

## Verify

```bash
# The chosen alternative is now active
rg "^domain_record: {new_type}" manifest.yaml
# Expected: 1 match — visually confirm the value matches the chosen alternative.

# The chosen type is registered in types:
rg -A1 "name: {new_type}$" manifest.yaml
# Expected: 1 match — the type block is present.

# The template exists
test -f templates/{new_type}.md && echo "template present" || echo "template MISSING"
# Expected: template present.

# The customization doc references the field correctly
rg "domain_record:" handbook/customizations/domain-record.md
# Expected: multiple matches.
```

If the `domain_record:` check fails, re-edit the line. If the template check fails, copy it
from the seedbed upstream (`templates/system-capability.md` or `templates/domain-model.md`).

---

## Notes

- **Shipped default:** `system-capability` is active out of the box. The framework ships
  both types pre-registered so switching is a one-line manifest edit; the default serves
  the common cross-functional team profile, and `domain-model` is available for
  precision-critical domains that need a structural DDD authority.

- **Single-select:** `system-capability` and `domain-model` are alternatives, not
  complements. They share authority-conflicting sections (Business Rules & Invariants;
  State Transitions / entity lifecycle). Using both creates competing sources of truth.
  The vault always has exactly one active.

- **Orthogonality with `requirements-root.md`:** Both are manifest-driven selector fields,
  but they select disjoint categories — `requirements_root:` selects the feature-scoped
  requirements-root type (`prd` / `feature-brief` / `press-release`); `domain_record:`
  selects the domain-scoped State artifact (`system-capability` / `domain-model`). Apply
  in any order; they do not interact.

- **Orthogonality with `folder-structure.md`:** The type folders
  (`system-capabilities/`, `domain-models/`) follow the active folder-structure
  alternative's placement rule. Under `flat` they sit at root; under `lifespan` they land
  in `specs/` (both are State artifacts). Re-apply `folder-structure.md` if you switch
  layouts after switching domain-record types.

- **Incremental migration:** Existing requirements scattered across `test-spec`,
  `data-design`, and `api-spec` do **not** need to be migrated immediately. Populate the
  domain-record incrementally — start with one domain at domain inception or at the next
  feature ship in that domain, and let the merge-back step populate it over time. Do not
  bulk-migrate historical artifacts.

- **Already-created artifacts** (in `test-specs/`, `data-designs/`, etc.) are **not
  touched** — only the manifest field changes. The domain-record is populated going
  forward via the Merge & Archive step.

- The alternatives are **peers**, not inverses. Switching from one to another is always
  "apply a different alternative's value" — there is no "revert" operation, only switching
  to the other alternative.
