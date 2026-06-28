# Customization: domain-record type

> Opts the vault into a long-lived, domain-scoped State artifact that gives product
> requirements a dedicated, evergreen home — instead of scattering them across
> `test-spec`, `data-design`, and `api-spec`. Pick one alternative below; the agent
> applies that value. Switching to a different alternative later = apply a different
> alternative's value.
>
> For the apply flow, see `../playbooks/customize-vault.md`.

---

## What changes

The `domain_record:` field in `manifest.yaml` opts the vault into a domain-record type.
Absent (the shipped default) means no dedicated domain-record — requirements persist
scattered across `test-spec` / `data-design` / `api-spec` (the current behavior). Setting
it to `system-capability` or `domain-model` activates that type and adds it to the
framework's dependency graph, ownership table, and vocabulary.

Unlike `requirements-root` (a manifest-only edit), activating a domain-record also
introduces two new artifact types (`system-capability`, `domain-model`) into the vault's
`types:` list — but the framework ships both types pre-registered in `manifest.yaml`, so
no `types:` edit is needed at apply time. Only the `domain_record:` selector line moves.

**Framework shipped default:** absent (no domain-record). The reference docs depict the
framework without a domain-record and note that the active type is in `manifest.yaml` —
they are already updated to describe both alternatives and the opt-in field.

---

## Alternatives

| Alternative | Role | Prefix | Folder | Display name | Owner | Mindset |
|---|---|---|---|---|---|---|
| *(absent)* | Default | — | — | — | — | Requirements persist scattered |
| `system-capability` | Alternative | `sc-` | `system-capabilities/` | System Capability | business-analyst | Behavioral — "what actions can be performed, and what are the rules?" |
| `domain-model` | Alternative | `dm-` | `domain-models/` | Domain Model | software-architect (primary), business-analyst (contributor) | Structural (DDD) — "what are the core nouns, their data, and allowed state changes?" |

"Default" = the framework's shipped starting option (a static fact). The current state is
whatever `manifest.yaml`'s `domain_record:` says right now (absent = no domain-record).

The two alternatives are **single-select** — they share authority-conflicting sections
(Business Rules & Invariants; State Transitions / entity lifecycle). Using both creates
competing sources of truth. There is no `none` peer; absence = none (following the
`dated_types: []` convention).

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

Each alternative is realized by a single `manifest.yaml` edit — setting (or commenting
out) the `domain_record:` line. The values below are the full final state of that line for
each alternative.

### *(absent — default)*

```
# domain_record: system-capability  # uncomment — behavioral approach (BA-owned)
# domain_record: domain-model        # uncomment — structural DDD approach (SA primary, BA contributor)
# Absent = no dedicated domain-record; requirements persist scattered (current default)
```

### `system-capability`

```
domain_record: system-capability
```

### `domain-model`

```
domain_record: domain-model
```

---

## What changes when adopted

Activating a domain-record introduces a new State layer to the workflow (Phase 0 in
`reference/artifact-dep-graph.md`):

- **Context (Pull State):** `feature-brief` / `user-story` read the domain-record before
  drafting a Delta — the domain's current capabilities/entities ground the proposal.
- **Persistence (Merge back):** after ship, the requirements delta in
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

1. **Read `manifest.yaml`** — check the current `domain_record:` value (or absence). If it
   already matches the chosen alternative, skip to Verify.

2. **`manifest.yaml`:** Uncomment (or replace) the `domain_record:` line with the chosen
   alternative's value from its per-alternative section above. The `system-capability` and
   `domain-model` types are already registered in `types:` — no `types:` edit is needed.

3. **Run Verify** (below) to confirm.

---

## Verify

```bash
# The chosen alternative is now active
rg "^domain_record: {new_type}" manifest.yaml
# Expected: 1 match — visually confirm the value matches the chosen alternative.
# (For the absent/default state, expect 0 matches — the line stays commented.)

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

- **Opt-in by design:** absence = no domain-record. The framework ships both types
  pre-registered so activation is a one-line manifest edit, but neither is active by
  default — the two alternatives serve different team profiles and imposing either would be
  wrong for half of adopting vaults.

- **Single-select:** `system-capability` and `domain-model` are alternatives, not
  complements. They share authority-conflicting sections (Business Rules & Invariants;
  State Transitions / entity lifecycle). Using both creates competing sources of truth.

- **Orthogonality with `requirements-root.md`:** Both are manifest-driven selector fields,
  but they select disjoint categories — `requirements_root:` selects the feature-scoped
  requirements-root type (`prd` / `feature-brief` / `press-release`); `domain_record:`
  selects the domain-scoped State artifact (`system-capability` / `domain-model`). Apply
  in any order; they do not interact.

- **Orthogonality with `folder-structure.md`:** The new type folders
  (`system-capabilities/`, `domain-models/`) follow the active folder-structure
  alternative's placement rule. Under `flat` they sit at root; under `lifespan` they land
  in `specs/` (both are State artifacts). Re-apply `folder-structure.md` if you switch
  layouts after activating a domain-record.

- **Incremental migration:** Existing requirements scattered across `test-spec`,
  `data-design`, and `api-spec` do **not** need to be migrated immediately. Adopt the
  domain-record incrementally — start with one domain at domain inception or at the next
  feature ship in that domain, and let the merge-back step populate it over time. Do not
  bulk-migrate historical artifacts.

- **Already-created artifacts** (in `test-specs/`, `data-designs/`, etc.) are **not
  touched** — only the manifest field changes. The domain-record is populated going
  forward via the Persistence step.

- The alternatives are **peers**, not inverses. Switching from one to another is always
  "apply a different alternative's value" — there is no "revert" operation. Switching from
  an active alternative back to absent is "comment out the `domain_record:` line."
