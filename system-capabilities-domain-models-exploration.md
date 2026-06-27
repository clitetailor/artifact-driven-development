# Exploration: system-capabilities & domain-models as Requirements Persistence Artifacts

> **Status:** Decisions made — pending implementation.
> All decisions (D1–D8) documented in §6. Change sets: §7 (State/Delta foundation), §8 (domain-record adoption).
> Open item: `## Migrations` in `data-design` (D3).
>
> **Source chats:** Chat 1 (`HAhpp6b6ampw`) — system-capabilities thread;
> Chat 2 (`tnmMCXoB6F2I`) — domain-model thread.

---

## 1. The Problem Both Artifacts Solve

In a lean artifact workflow, the requirements-root (`prd` / `feature-brief` / `press-release`)
and `user-story` are **short-lived Delta artifacts** — they capture the "why/what" for a specific
feature, then are archived after ship. The question: *where do product requirements live
long-term so a new joiner can understand what the system does today?*

The current answer in software-seedbed: requirements persist by **scattering** into long-lived
engineering artifacts — `test-spec` (acceptance criteria), `user-flow` (journeys), `data-design`
(business rules / state machines), `api-spec` (contracts). This is legible to engineers but
**invisible to Product Managers** and business stakeholders.

`system-capability` and `domain-model` are two alternative **long-lived State artifacts** that
give product requirements a dedicated, evergreen home.

---

## 2. system-capability — The Behavioral Approach

**Mindset:** "What actions can be performed, and what are the rules for those actions?"

| Attribute | Value |
|---|---|
| Lifespan | Long-lived (State) |
| Scope | Domain-organized, not feature-scoped (e.g. `billing-engine.md`, `checkout.md`) |
| Owner | Product Manager / Business Analyst |
| Audience | PMs, QA, Engineers, Customer Support |
| Language | Plain English, bulleted lists |
| Maps closely to | `user-flow` & `test-spec` |
| Best for | SaaS, e-commerce, consumer apps — cross-functional teams |

### How it persists requirements

When a feature ships, the PM opens the relevant domain's `system-capability` file and adds/updates
bullets under Core Capabilities and Business Rules. The short-lived `feature-brief` and
`user-story` are archived. The capability file becomes the permanent "system law."

> Sections: Core Capabilities, Business Rules & Invariants, Roles & Permissions, State Transitions.
> See §8 Change 7 for the full template.

### Distinctions from adjacent concepts (from Chat 1)

- **Product Wiki** = the *container/workspace* (Notion, Confluence) — chaotic, mixes project +
  system spaces. Not an artifact.
- **System Capabilities** = the *internal blueprint* — strict, factual, under-the-hood rules.
  For PMs/Eng/QA.
- **Product Manual** = the *external guide* — UI-focused how-to for end-users / support. Derived
  from system-capabilities but separate.

---

## 3. domain-model — The Structural Approach (DDD)

**Mindset:** "What are the core nouns of our business, what data do they hold, and what state
changes are mathematically allowed?"

| Attribute | Value |
|---|---|
| Lifespan | Long-lived (State) |
| Scope | Domain-organized (e.g. `order-domain.md`, `subscription.md`) |
| Owner | Co-authored by Product + Engineering |
| Audience | Engineers, Architects, technical PMs |
| Language | Strict "Ubiquitous Language" + pseudo-code / entity definitions |
| Maps closely to | Backend code & database schemas (`data-design`, `api-spec`) |
| Best for | Fintech, healthcare, complex logistics — precision-critical domains |

### Alternative Structures (from Chat 2)

1. **Event-Centric** (event-driven microservices): Commands → Events → Read Models. Best for
   Kafka/RabbitMQ/event-sourcing architectures.
2. **Pragmatic/Lightweight** (startups, CRUD apps): Glossary → Data Concepts → Business Logic.
   Avoids DDD over-engineering for simple apps.

### How it persists requirements

The `domain-model` becomes the source of truth for business logic. `data-design` and `api-spec`
become *subordinate* — they translate domain entities into storage schemas and contracts
respectively. When a `tech-design` proposes a new business rule, it must explicitly propose an
update to the `domain-model`, merged simultaneously with the code PR.

> Sections (DDD-Lite): Ubiquitous Language, Core Entities, Value Objects, Business Rules &
> Invariants, Domain Events. See §8 Change 7 for the full template.

---

## 4. system-capability vs domain-model — Direct Comparison

| Dimension | system-capability | domain-model |
|---|---|---|
| Primary focus | User workflows & business outcomes | System nouns, states, strict logic |
| Language | Conversational English | Ubiquitous Language + pseudo-code |
| Readability | High (non-technical accessible) | Low (requires systems thinking) |
| Maps to | `user-flow` & `test-spec` | `data-design` & `api-spec` (backend code) |
| Owner | PM / BA | Product + Engineering co-authored |
| Best for | SaaS, e-commerce, consumer apps | Fintech, healthcare, complex logistics |
| Overlap risk | State Transitions section ↔ `data-design` | Heavily overlaps `data-design` entities/rules |

**They are peers solving the same problem from different mindsets, not complements.** Gemini
frames it as a choice: pick one based on domain complexity and team composition.

---

## 5. The Lean Workflow Paradigm (both chats)

Both artifacts are introduced as part of a broader **State vs Delta** workflow that is *not*
present in the current software-seedbed framework.

### Lifespan categorization

> **Note — resolved conflict with the existing framework `lifespan` folder-structure
> alternative.** The framework's existing `lifespan` folder alternative grouped by
> *stable-reference vs transient-working* (usage *during* development). The Gemini chat's
> State/Delta groups by *persistent-truth vs feature-scaffolding* (fate *after* ship). These
> are different axes and produced mismatched bucket assignments for `feature-brief`,
> `user-story`, `tech-design`, and `test-spec`. **Resolved — State/Delta adopted (D2, §7):**
> the four mis-bucketed types are corrected in §7 Change 3.

| Long-lived (State / System Space) | Short-lived (Delta / Project Space) |
|---|---|
| `system-architecture`, `adr`, `api-spec`, `data-design`, `design-spec`, `user-flow`, `test-spec` | `feature-brief`, `user-story`, `tech-design`, `task` |
| **+ `system-capability` or `domain-model`** (new) | |

### The four-phase "Read-Write" cycle

```
Phase 1: CONTEXT (Pull State)     — read existing State to draft Delta
Phase 2: PROPOSAL (Draft Delta)   — feature-brief, user-story, tech-design
Phase 3: EXECUTION (Build)        — tasks, code
Phase 4: PERSISTENCE (Merge back) — update State from Delta, archive Delta
```

**The Bridge Rule:** A feature is not "Done" until its logic is merged into the System Space.
The `tech-design` acts as a "Pull Request for the system blueprint" — it copies existing
schemas/contracts and highlights the delta.

### Updated dependency graph (lean, with system-capability)

```
[system-capability] ──(reads)──> [feature-brief]
[user-flow]/[design-spec] ──(reads)──> [user-story]
[system-architecture]/[api-spec]/[data-design] ──(reads)──> [tech-design]
        │
        v  (execution)
     [task]
        │
        v  (persistence — merge back)
[system-capability] <──(absorbs rules)── [user-story]
[test-spec] <──(absorbs criteria)── [user-story]
[api-spec]/[data-design] <──(absorbs contracts/schemas)── [tech-design]
[system-architecture] <──(absorbs core shifts)── [tech-design]
[adr] <──(extracts decisions)── [tech-design]
```

With `domain-model`, it replaces `system-capability` in the graph and additionally becomes
the upstream authority for `data-design` and `api-spec` (they translate from it).

---

## 6. Framework Tensions & Decisions

Framework baseline at the time of this analysis:

| Concept | Current state |
|---|---|
| Requirements root | `feature_type: prd` — single-select peer system, all feature-scoped, BA-owned |
| Dep graph | One-way phase flow; no lifespan distinction, no merge-back step |
| `data-design` | SA-owned; holds entities, relationships, state machines, data flows, migrations |
| Lifecycle | Status labels only; no State/Delta concept |
| Folder structure | Flat, one folder per artifact type |

Five tensions (T1–T5) were identified mapping these artifacts against the framework. The analytical questions (Q1–Q7) resolved them. Both are folded here as named decisions (D1–D8): each decision cites its originating tension(s) inline.

### D1 — Category placement

**Tension (T1):** `system-capability` and `domain-model` are domain-scoped State artifacts that persist requirements *across* features. Adding them as `feature_type` alternatives would be a category error — they sit alongside the requirements phase, not inside it.

**Decision:** Add as a new **`domain-record`** category outside the `feature_type` peer system via an optional `domain_record_type:` field in `manifest.yaml` (absent = no domain-record). See §8 Changes 2–3.

> **Category name (`requirements-persistence` → `domain-record`):** Follows the ADR naming pattern (authoritative log of a domain), signals `scope: domain`, avoids over-claiming the category holds only requirements (`domain-model` also carries DDD architectural content). `requirements-persistence` rejected: "persistence" reads as a storage/DB layer term. Category labels retained: `requirements-root` (feature-scoped) and `domain-record` (domain-scoped, new). Runner-up `feature-proposal` rejected for the feature slot: its lifespan signal is redundant with the `lifespan: delta` field.

---

### D2 — State/Delta as framework concept

**Tension (T3):** Properly adopting these artifacts requires the State/Delta lifespan distinction and a Phase 4 "merge back" persistence step — neither exists in the current one-way dep graph.

**Decision:** Adopt as a **first-class framework concept**: `lifespan: state | delta` field on every `types:` entry in `manifest.yaml`. See §7 for the full change set.

---

### D3 — `data-design` boundary

**Tension (T2):** `domain-model` heavily overlaps `data-design` (entities, state transitions, business rules). `system-capability` State Transitions also overlap `data-design` state machines.

**Decision — layer boundary (option b).** `domain-model` sits *above* `data-design` as a conceptual layer. No content moves; an explicit boundary is drawn:

| `domain-model` owns | `data-design` owns |
|---|---|
| Ubiquitous Language, conceptual entities + invariants | Physical schema, columns, indexes, pipeline stages |
| Which transitions are legally allowed (business rules) | How transitions are stored (implementation) |

State machine overlap is **partial** — different layers, same subject matter. The same distinction applies to `system-capability` State Transitions vs `data-design` State Machines. Options (a) — move business rules out — and (c) — absorb `data-design` — were rejected: no free-form business rules in `data-design`; absorption would break a separately-owned artifact.

> **Open item — `## Migrations` in `data-design`:** Delta section inside a State artifact. Options: (a) label as Delta in the template (comment only); (b) extract into a `migration` type. **Deferred — separate decision pending.**

---

### D4 — Ownership model

**Tension (T4):** `domain-model` is genuinely co-authored by Product and Engineering. The current one-agent-per-type rule has no co-ownership mechanism.

**Decision — primary/contributor pattern.** New concept added to `artifact-ownership.md`:

| | `system-capability` | `domain-model` |
|---|---|---|
| Primary owner | `business-analyst` | `software-architect` |
| Contributor | — | `business-analyst` |
| BA authority | full artifact | Business Rules & Invariants; co-authors Ubiquitous Language |
| SA authority | — | Core Entities, Value Objects, Domain Events |

Updated rule: *"No agent writes an artifact it does not own or contribute to. For co-authored artifacts, the contributor writes only sections within their stated authority; the primary owner is accountable for the full artifact."*

SA is primary because `domain-model` is the engineering-heavy option and upstream authority for `data-design` + `api-spec` (both SA-owned). Option (a) — single owner — forced a false choice. Option (c) — split artifact — breaks DDD's shared-model premise.

---

### D5 — Domain-scoped artifact support

**Tension (T5):** All current artifacts are feature-scoped. `system-capability` and `domain-model` are domain-scoped — one file per business domain, updated across features.

**Decision:** Add `scope: feature | domain` field to `manifest.yaml` `types:` alongside `lifespan:`. Rules:

1. Domain-scoped types carry `domain: {slug}` frontmatter instead of `feature: {slug}`.
2. IDs use a domain slug (e.g. `sc-billing`, `dm-billing`). `dated_types:` unaffected.
3. `refs` frontmatter unchanged — feature artifacts reference domain artifacts via existing `refs:` list. Reverse tracking not added (unbounded).
4. Folder: one file per domain per type (e.g. `system-capabilities/billing.md`).

---

---

### D6 — Customization: selectivity and default

**Decision:** `domain-record` is opt-in; **field absent = none** (following `dated_types: []` precedent — no named `none` peer). **Single-select only** — `system-capability` and `domain-model` share authority-conflicting sections (D7); using both creates competing sources of truth. **No default shipped** — the two options serve different team profiles; imposing either would be wrong for half of adopting vaults.

```yaml
# domain_record_type: system-capability  # uncomment — behavioral approach (BA-owned)
# domain_record_type: domain-model        # uncomment — structural DDD approach (SA primary, BA contributor)
# Absent = no dedicated domain-record (scattered persistence — current default)
```

---

### D7 — Overlap verification

| Pairing | Section | Overlap | Resolution |
|---|---|---|---|
| `data-design` / `domain-model` | State Machines / Business Rules | Partial | Layer boundary (D3) |
| `data-design` / `domain-model` | Entity Definitions / Core Entities | Partial | Layer boundary (D3) |
| **`system-capability` / `domain-model`** | **Business Rules & Invariants** | **Significant** | Authority conflict → single-select (D6) |
| **`system-capability` / `domain-model`** | **State Transitions / Entity lifecycle + Events** | **Partial** | Authority conflict → single-select (D6) |
| `system-capability` / `data-design` | State Transitions / State Machines | Partial | Layer boundary (D3) |
| All other pairings | — | Negligible | Different layers, audiences, language |

**Key finding:** `system-capability` and `domain-model` share two authority-conflicting sections — confirmed alternatives, not complements (D6 single-select).

---

### D8 — Terminology

| Gemini term | Industry provenance | Framework adoption |
|---|---|---|
| "Domain Model" | **Established** — DDD (Evans 2003) | Adopt as-is (`domain-model`) |
| "System Capabilities" | Informal — PM/product blogs | Adopt as-is (`system-capability`) |
| "Ubiquitous Language" | **Established** — DDD (Evans 2003) | Adopt inside `domain-model` template |
| "State vs Delta" / "System Space / Project Space" | Coined by Gemini / Informal — Notion/Confluence practitioner usage (synonyms for the same axis) | Retire → `lifespan: state \| delta` (D2) |
| "Living Product Manual" | Coined by Gemini | Retire — not needed as a framework term |

**Framework coins only:** `lifespan: state | delta` (D2), `scope: feature | domain` (D5), `domain-record` (D1). `requirements-root` already exists.

Decisions D1–D8 (above) represent Option A applied — all options were considered. Options B (reframe `data-design` as persistence layer — breaks existing semantics, high migration cost) and C (add both as selectable modes — `none` peer is ill-defined per D6) were rejected. Options B and C insights are incorporated in D3 and D6 respectively.

---

## 7. Implementation: State/Delta Foundation

> **Adopted** (D2). Changes are listed in dependency order. Each change is a prerequisite
> for §8 (domain-record adoption) but independent of the `system-capability` / `domain-model`
> choice.

### The core insight

`test-spec` currently conflates two artifacts with different lifespans in one document. The
original merge was a simplification. Reversing it under State/Delta is the best-practice
answer and is what unblocks the `lifespan` folder-structure alternative.

| | `test-plan` (to be re-introduced) | `test-spec` (to be reframed) |
|---|---|---|
| **Lifespan** | Delta — short-lived | State — long-lived |
| **Scope** | Per-feature | Domain |
| **Content** | Scope, strategy, environment, test levels, tools | Test cases, edge cases, error cases, mocking strategy |
| **Fate after ship** | Archived with `feature-brief` / `user-story` | Updated in place when behavior changes |
| **Upstream deps** | `user-story`, `api-spec` | `test-plan`, `api-spec`, `user-story` |

---

### Change 1 — Add `lifespan` field to `manifest.yaml` `types:`

Add a `lifespan: state | delta` field to each entry in `types:`. This makes State/Delta
machine-readable and first-class without touching status labels or lifecycle semantics.

**Assignments:**

| Lifespan | Types |
|---|---|
| `state` | `system-architecture`, `adr`, `api-spec`, `data-design`, `design-spec`, `user-flow`, `test-spec` |
| `delta` | `feature-brief`, `prd`, `press-release`, `user-story`, `tech-design`, `task`, `plan`, `test-plan` *(new)* |
| `state or delta` | `note` (ad-hoc — no restriction) |

> The table shows the end-state after all §7 changes. The Change 1 manifest edit tags
> only types that exist at that point; `test-plan` is tagged when Change 2 creates it.

This is the prerequisite that unblocks all other changes.

---

### Change 2 — Split `test-spec` back into `test-plan` + `test-spec`

**`test-plan`** — new Delta artifact:
- Prefix: `tp-`, folder: `test-plans/`, template: `templates/test-plan.md`
- Owner: `qa-engineer`
- Content: the current `test-spec` `## Test Plan` section (scope, strategy, environment,
  testing strategy table, test environment)
- Statuses: `draft`, `ready-for-review`, `accepted`, `deprecated` (same as other Delta roots)
- `feature:` frontmatter field (feature-scoped, archived with the feature)

**`test-spec`** — reframed as State artifact:
- Prefix, folder, owner unchanged (`ts-`, `test-specs/`, `qa-engineer`)
- Remove `## Test Plan` section from template; it moves to `test-plan`
- Reframe as domain-scoped: one `ts-checkout.md` updated across features,
  not one per feature
- Add `domain:` frontmatter field (replaces the per-feature `feature:` field)

---

### Change 3 — Fix the `lifespan` folder-structure alternative

Four bucket reassignments in `handbook/customizations/folder-structure.md`:

| Artifact | Current bucket | Corrected bucket | Reason |
|---|---|---|---|
| `feature-brief` | `specs/` | `delivery/` | Delta — archived after ship |
| `user-story` | `specs/` (default) | `delivery/` | Delta — archived after ship; resolves the judgment call |
| `tech-design` | `specs/` | `delivery/` | Delta — archived after ship |
| `test-spec` | `delivery/` | `specs/` | State — living regression suite |
| `test-plan` *(new)* | — | `delivery/` | Delta — per-feature QA plan |

The `user-story` judgment call in the current doc is resolved by State/Delta — no longer
borderline.

---

### Change 4 — Update `reference/artifact-dep-graph.md`

1. Split Phase 5 — Verification into two rows:

   | Phase | Artifacts | Lifespan |
   |---|---|---|
   | 5a — Test Planning | `test-plan` | Delta |
   | 5b — Verification | `test-spec` | State |

2. Add the four-phase Read-Write cycle description (Pull State → Draft Delta → Execute →
   Merge back to State) as a new section, with bidirectional persistence arrows in the
   Mermaid graph.

3. Update the dependency table:

   | To create… | First create… |
   |---|---|
   | `test-plan` | `user-story`, `api-spec` |
   | `test-spec` | `test-plan` (first time for a domain); updated in place thereafter |

   > Unchanged rows are omitted. `test-spec` retains its existing `api-spec` and `user-story`
   > deps from the current graph; only the new `test-plan` prerequisite is shown above.

---

### Change 5 — Update `reference/artifact-vocabulary.md`

- **`test-spec`:** Remove "Absorbs test-plan." Add: "Long-lived, domain-scoped regression
  suite. Updated in place across feature deliveries. Owned by qa-engineer."
- **`test-plan`:** Add new entry: "Per-feature QA planning artifact. Covers scope, strategy,
  environment, and test levels for a specific feature delivery. Archived after ship. Owned by
  qa-engineer."

---

### Change 6 — Update `reference/artifact-ownership.md`

Add `test-plan` row:

```
| test-plan | qa-engineer |
```

---

### Change 7 — New `templates/test-plan.md`

Content: the current `test-spec` `## Test Plan` section extracted as a standalone template,
with `feature:` frontmatter (not `domain:`), and `## Pipeline Next Steps` pointing to
`test-spec` creation/update.

---

### What does NOT change

- `test-spec` prefix (`ts-`), owner (`qa-engineer`), status labels — unchanged.
- All other artifact types and their templates — unchanged.
- The requirements-root peer system — untouched; State/Delta is orthogonal.
- The `system-capability` / `domain-model` decision — the framework-level decision is made
  (D6: opt-in, single-select); the vault's selection between the two remains open. These
  changes are prerequisites, not the same decision.

---

### Sequencing

```
1. Change 1  — Add lifespan field to manifest types:         [unblocks everything]
2. Change 2  — Split test-spec → test-plan + test-spec       [requires Change 1]
3. Change 7  — New test-plan template                        [requires Change 2]
4. Change 3  — Fix lifespan folder-structure alternative     [requires Change 2]
5. Change 4  — Update dep graph                              [requires Change 2]
6. Change 5  — Update vocabulary                             [requires Change 2]
7. Change 6  — Update ownership                              [requires Change 2]
   — then —
8. ~~Resume Q2/Q7 (data-design overlap analysis)~~  ✓ resolved → D3
9. ~~Resume Q6  (customization default)~~            ✓ resolved → D6
   — then —
10. Implement §8 change set (domain-record artifacts)
```

---

## 8. Implementation: Domain-Record Adoption

> Applies after §7 (State/Delta foundation) is fully implemented.
> Prerequisite: vault has decided to adopt either `system-capability` or `domain-model` via
> the `domain_record_type:` field (see Change 2 below). Changes apply to whichever artifact
> the vault selects; shared structural changes (scope field, ownership model) apply regardless.

### Change 1 — Add `scope:` field to all `manifest.yaml` `types:` entries

Add `scope: feature | domain` to every entry in `types:`. This makes the scope axis
machine-readable alongside `lifespan:` (from §7 Change 1).

**Assignments for all existing types:**

| `scope: feature` | `scope: domain` |
|---|---|
| `feature-brief`, `prd`, `press-release`, `user-story`, `user-flow`, `design-spec`, `adr`, `system-architecture`, `api-spec`, `data-design`, `tech-design`, `task`, `plan`, `test-plan` *(new — §7)*, `note` | `test-spec` *(§7 reframe)*, `system-capability` *(new)*, `domain-model` *(new)* |

> Note: `test-spec` is re-scoped to `domain` as part of §7 Change 2 (reframed as
> domain-scoped). The `scope:` field formalises that here.

**Frontmatter rule:** domain-scoped types carry `domain: {slug}` instead of `feature: {slug}`.

---

### Change 2 — Add `domain_record_type:` field to `manifest.yaml`

Add as a commented-out optional field below `feature_type:`:

```yaml
# domain_record_type: system-capability  # uncomment — behavioral approach (BA-owned)
# domain_record_type: domain-model        # uncomment — structural DDD approach (SA primary, BA contributor)
# Absent = no dedicated domain-record; requirements persist scattered (current default)
```

No default value shipped. Field follows the `dated_types: []` convention — absence = `none`.

---

### Change 3 — Add `system-capability` and `domain-model` to `manifest.yaml` `types:`

```yaml
  # Domain-record (domain-scoped State artifacts — opt-in via domain_record_type:)
  - name: system-capability
    prefix: sc-
    folder: system-capabilities/
    template: templates/system-capability.md
    scope: domain
    lifespan: state

  - name: domain-model
    prefix: dm-
    folder: domain-models/
    template: templates/domain-model.md
    scope: domain
    lifespan: state
```

**ID scheme:** domain slug, not feature slug (e.g. `sc-billing`, `dm-checkout`). The
`dated_types:` mechanism is unaffected.

---

### Change 4 — Update `reference/artifact-ownership.md`

**4a — Extend the ownership rule (one-line addition):**

Current: *"No agent writes an artifact it does not own."*

Updated: *"No agent writes an artifact it does not own or contribute to. For co-authored
artifacts, the contributor writes only sections within their stated authority; the primary
owner is accountable for the full artifact."*

**4b — Add new rows to the ownership table:**

```
| system-capability                    | business-analyst                                    |
| domain-model                         | software-architect (primary), business-analyst (contributor) |
```

**Section authority for `domain-model`:**

| Section | Authority |
|---|---|
| Ubiquitous Language | Co-authored — both must agree on terms |
| Core Entities, Value Objects, Domain Events | `software-architect` (primary) |
| Business Rules & Invariants | `business-analyst` (contributor) |

---

### Change 5 — Update `reference/artifact-dep-graph.md`

**5a — Add domain-record as a State layer node:**

Add a new phase row above Phase 1 (Requirements):

| Phase | Artifact | Lifespan | Scope |
|---|---|---|---|
| 0 — Domain Record (optional) | `system-capability` or `domain-model` | State | Domain |

**5b — Add bidirectional Read-Write edges for domain-record:**

- `feature-brief` / `user-story` **reads from** `domain-model` / `system-capability` (pulls
  current State before drafting a Delta)
- `feature-brief` / `user-story` **merges back to** `domain-model` / `system-capability`
  after feature ships (persistence step)

**5c — Add `domain-model` subordination edges (conditional on `domain-model` selection):**

- `domain-model` → `data-design` (entity definitions + business rules are the upstream
  authority; `data-design` implements them in storage)
- `domain-model` → `api-spec` (domain entities + events are the upstream authority;
  `api-spec` translates them into contracts)

**5d — Update the dependency table:**

| To create… | First create… |
|---|---|
| `system-capability` | No hard prerequisite — start at domain inception |
| `domain-model` | No hard prerequisite — start at domain inception |
| `data-design` (when `domain-model` adopted) | `domain-model` for the same domain |
| `api-spec` (when `domain-model` adopted) | `domain-model` for the same domain |

---

### Change 6 — Update `reference/artifact-vocabulary.md`

**Add `system-capability`:**
> Long-lived, domain-scoped State artifact. Captures what the system can do, its business
> rules, roles/permissions, and state transitions in plain English. One file per business
> domain, updated across features. Owned by `business-analyst`. Alternative to `domain-model`.

**Add `domain-model`:**
> Long-lived, domain-scoped State artifact. Defines the Ubiquitous Language, core entities,
> value objects, business rules & invariants, and domain events for a business domain using
> DDD-Lite structure. One file per domain, updated across features. Upstream authority for
> `data-design` and `api-spec` when adopted. Co-authored: `software-architect` (primary),
> `business-analyst` (contributor). Alternative to `system-capability`.

**Update `data-design`:**
> Add boundary note: *"When `domain-model` is adopted, entity definitions and business rules
> are the authority of `domain-model`; `data-design` implements them in physical storage
> schema, indexes, and migrations."*

---

### Change 7 — New templates

**`templates/system-capability.md`:**

```markdown
---
id: sc-{domain}
type: system-capability
owner: business-analyst
status: draft
version: 1.0
domain: {domain-slug}
refs: []
---

# System Capability: {Domain Name}

## Core Capabilities
<!-- What users and the system can do in this domain. Plain English, bulleted. -->
- 

## Business Rules & Invariants
<!-- Strict laws that must never break. Each rule is unambiguous and testable. -->
- 

## Roles & Permissions
<!-- Who can perform which actions. -->

| Role | Can | Cannot |
|------|-----|--------|
|      |     |        |

## State Transitions
<!-- Entity lifecycle changes allowed in this domain. -->

| Entity | From | Event | To |
|--------|------|-------|----|
|        |      |       |    |

## Open Questions
- [ ]
```

**`templates/domain-model.md`:**

```markdown
---
id: dm-{domain}
type: domain-model
owner: software-architect
contributor: business-analyst
status: draft
version: 1.0
domain: {domain-slug}
refs: []
---

# Domain Model: {Domain Name}

## Ubiquitous Language
<!-- Exact terms used in this domain. No synonyms. Both business and engineering must agree. -->

| Term | Definition |
|------|------------|
|      |            |

## Core Entities
<!-- Things with identity and lifecycle. Include allowed state transitions. -->

### `{EntityName}`
**Identity:** {what makes it unique}
**Lifecycle states:** {state1} → {state2} → {state3}
**Allowed transitions:**

| From | Event | To | Guard |
|------|-------|----|-------|
|      |       |    |       |

## Value Objects
<!-- Defined entirely by their attributes. No identity. Immutable. -->

### `{ValueObjectName}`
**Attributes:** {attr1}, {attr2}
**Invariants:** {rules that must hold}

## Business Rules & Invariants
<!-- Unbreakable laws. Written in Ubiquitous Language. Owned by business-analyst. -->
- 

## Domain Events
<!-- Significant happenings that other domains or systems may react to. -->

| Event | Trigger | Payload |
|-------|---------|---------|
|       |         |         |

## Open Questions
- [ ]
```

---

### Change 8 — New `handbook/customizations/domain-record.md`

New customization doc following the pattern of `handbook/customizations/requirements-root.md`.
Content covers:
- What `domain-record` is and when to adopt it
- How to choose between `system-capability` and `domain-model` (decision guide)
- How to activate: uncomment `domain_record_type:` in `manifest.yaml`
- What changes when adopted: new types in manifest, dep graph update, ownership update
- Migration note: existing requirements scattered in `test-spec`/`data-design`/`api-spec`
  do not need to be migrated immediately — adopt incrementally per domain

---

### What does NOT change

- All §7 changes — prerequisite, unaffected.
- `data-design` prefix (`dd-`), owner (`software-architect`), template structure — unchanged
  (boundary is conceptual, not structural).
- The `feature_type` peer system — untouched; `domain-record` is a separate optional layer.
- `api-spec` prefix, owner, template — unchanged; `domain-model` only adds an upstream
  dependency when adopted, it doesn't change `api-spec` itself.

---

### Sequencing

```
After §7 is complete:
1. Change 1  — Add scope: field to manifest types:           [unblocks Change 3]
2. Change 2  — Add domain_record_type: field to manifest     [independent]
3. Change 3  — Add sc + dm types to manifest                 [requires Change 1]
4. Change 4  — Update artifact-ownership.md                  [requires Change 3]
5. Change 5  — Update artifact-dep-graph.md                  [requires Change 3]
6. Change 6  — Update artifact-vocabulary.md                 [requires Change 3]
7. Change 7  — New templates (sc + dm)                       [requires Change 3]
8. Change 8  — New handbook/customizations/domain-record.md  [requires all above]
```

---

*These notes are exploratory. Decisions are made but no framework files were modified yet.
Source chats: `../_Gemini - direct access to Google AI.htm` (Chat 1) and
`../_Gemini - direct access to Google AI 2.htm` (Chat 2) in the parent directory.*
