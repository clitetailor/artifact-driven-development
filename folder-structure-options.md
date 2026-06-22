# Folder Structure Options

Exploration of grouping axes for the 15 artifact-type folders currently flat at vault root.
Framework folders (`agents/`, `conventions/`, `reference/`, `handbook/`, `templates/`)
are out of scope here — only artifact-folder grouping is compared.

## Current structure (baseline)

All 15 artifact-type folders sit flat at vault root alongside 6 framework folders:

```
{vault-root}/
├── feature-briefs/         press-releases/       adrs/                api-specs/
├── prds/                   user-stories/         system-architectures/ data-designs/
├── user-flows/             design-specs/         tech-designs/        tasks/
├── plans/                  test-specs/           notes/
├── agents/  conventions/  reference/  handbook/  templates/
└── manifest.yaml  AGENTS.md  README.md  PROJECT.md
```

20 root entries total. The question: can artifact folders be grouped to reduce root clutter
and add navigational meaning?

---

## Option A — SDLC phase grouping

Groups artifact folders by SDLC phase, matching `reference/artifact-dep-graph.md`'s 5 phases
and `manifest.yaml`'s comment dividers.

```
{vault-root}/
├── requirements/
│   ├── feature-briefs/
│   ├── prds/
│   ├── press-releases/
│   └── user-stories/
├── design/
│   ├── user-flows/
│   └── design-specs/
├── architecture/
│   ├── adrs/
│   ├── system-architectures/
│   ├── api-specs/
│   └── data-designs/
├── development/
│   ├── tech-designs/
│   ├── tasks/
│   └── plans/
├── verification/
│   └── test-specs/
├── general/
│   └── notes/
├── agents/  conventions/  reference/  handbook/  templates/
└── manifest.yaml  AGENTS.md  README.md  PROJECT.md
```

### Real-world precedent

- **attractor-guided-engineering-template**: `docs/requirements/`, `docs/design/`, `docs/architecture/`
- **BANA development lifecycle**: URD → PRD → ADR → Plan → test-cases spine

Both are documentation frameworks, not AI-agent SDLC frameworks.

### Strengths

- **Zero ambiguous placements** — every type maps to exactly one phase, no judgment calls
- **1:1 match with the dep-graph** — phase flow diagram becomes the folder structure
- **Manifest divider precedent** — `manifest.yaml` already has `# Requirements`, `# Design`,
  `# Architecture`, `# Development`, `# Verification`, `# General` comment dividers matching A exactly
- Intuitive SDLC mental model

### Weaknesses

- **Weak AI-agent-framework precedent** — documentation frameworks use phase grouping; AI-agent
  SDLC frameworks (BMAD, ClaudeKit, Spec-Kit) do not
- **Doesn't match agent context-loading** — a task needs architecture (phase 3) + tech-design
  (phase 4) + task (phase 4) + test-spec (phase 5), spanning 3 phase folders with no clean
  "load this folder" instruction
- **Most top-level buckets** — 6 artifact buckets, 12 root entries total
- Cross-phase refs (e.g. tech-design → system-architecture + prd) span folders

---

## Option P2 — product / technical / delivery grouping

Groups artifact folders by whether they're product-facing, technical-facing, or delivery/execution.

```
{vault-root}/
├── product/
│   ├── feature-briefs/
│   ├── prds/
│   ├── press-releases/
│   ├── user-stories/
│   ├── user-flows/
│   └── design-specs/
├── technical/
│   ├── adrs/
│   ├── system-architectures/
│   ├── api-specs/
│   ├── data-designs/
│   └── tech-designs/
├── delivery/
│   ├── tasks/
│   ├── plans/
│   └── test-specs/
├── general/
│   └── notes/
├── agents/  conventions/  reference/  handbook/  templates/
└── manifest.yaml  AGENTS.md  README.md  PROJECT.md
```

### Real-world precedent

- **BANA Module Docs**: product/business docs (`modules/`) vs engineering docs (`developer/`) —
  but as a **two-bucket** split, with test-cases on the product side (contradicts P2's delivery bucket)
- **skill-harness**: `docs/artifacts/source/{product, business, data, research, ux}/` — domain
  grouping, a finer-grained cousin of product/technical, not a binary split

No real-world framework does product/technical/delivery as three peer buckets.

### Strengths

- **Human-intuitive axis** — "is this product-facing or technical?" is a natural question for
  new contributors
- Fewer buckets than A (4 vs 6)

### Weaknesses

- **Weakest real-world precedent** — no framework does this three-bucket shape; BANA's two-bucket
  split contradicts P2's delivery bucket (BANA puts test-cases on product side)
- **Four forced placements** — types that don't cleanly fit either bucket:
  - `tasks/` — derived from api-spec (technical) *or* design-spec (product); split-owned (be/fe)
  - `plans/` — rolls up requirements-root → stories → tasks; spans product and technical by definition
  - `test-specs/` — depends on api-spec (technical) *and* user-story (product)
  - `notes/` — no phase, no owner, no product/technical signal
- **Intuition breaks under forced fits** — when `plans/` (half product) sits in `delivery/`,
  the product/technical axis is undermined
- Doesn't match agent context-loading or dep-graph phases

---

## Option L1 — pure flat two-bucket (BMAD/ClaudeKit faithful)

Groups artifacts by lifespan: stable reference vs transient working. Flat files within each
bucket — no type subfolders. Most faithful to BMAD and ClaudeKit's actual structures.

```
{vault-root}/
├── specs/                       # stable reference — flat files
│   ├── prd-user-auth.md
│   ├── adr-001-use-jwt.md
│   ├── sa-platform.md
│   ├── api-user-authentication.md
│   ├── story-user-login.md
│   └── ...
├── delivery/                    # transient working — flat files
│   ├── task-implement-login.md
│   ├── plan-user-auth.md
│   ├── ts-user-authentication.md
│   └── ...
├── notes/                       # ad-hoc — flat files
│   └── note-meeting-2026-06-21.md
├── agents/  conventions/  reference/  handbook/  templates/
└── manifest.yaml  AGENTS.md  README.md  PROJECT.md
```

### Real-world precedent

- **BMAD**: `_bmad-output/planning-artifacts/` (flat: prd.md, architecture.md, epics.md) vs
  `_bmad-output/implementation-artifacts/` (flat: sprint-status.yaml, {story-key}.md)
- **ClaudeKit**: `docs/` (flat: system-architecture.md, code-standards.md) vs
  `plans/` (flat: {feature}-YYYYMMDD.md)

Both use flat peer files within each bucket — no type subfolders.

### Strengths

- **Most faithful to BMAD/ClaudeKit** — flat peer files within each lifespan bucket
- **Cleanest root** — 3 artifact buckets, 9 root entries total
- Prefixes (`prd-`, `adr-`, `task-`) carry type signal; `type:` grep queries already search
  the whole vault, so type discovery still works without type folders

### Weaknesses

- **Loses type-level folder navigation** — `ls specs/` shows 30+ mixed-type files; no way to
  browse "all ADRs" by folder
- **Seedbed has multiple artifacts per type** (unlike BMAD's single PRD/architecture), so flat
  files get unwieldy fast
- **Breaks folder-scoped queries** in `reference/vault-queries.md` — queries like
  `{vault-root}/tasks/` and `{vault-root}/test-specs/` would need to become whole-vault `type:`
  queries
- User-story placement still a judgment call (specs/ or delivery/)

---

## Option L2 — two-bucket with type subfolders (hybrid)

Same lifespan axis as L1, but preserves type-level subfolders within each bucket. Combines
BMAD/ClaudeKit's lifespan split with the seedbed's type-folder navigation.

```
{vault-root}/
├── specs/                       # stable reference
│   ├── feature-briefs/
│   ├── prds/
│   ├── press-releases/
│   ├── user-stories/            # (judgment call — see below)
│   ├── user-flows/
│   ├── design-specs/
│   ├── adrs/
│   ├── system-architectures/
│   ├── api-specs/
│   ├── data-designs/
│   └── tech-designs/
├── delivery/                    # transient working
│   ├── tasks/
│   ├── plans/
│   └── test-specs/
├── notes/                       # ad-hoc
├── agents/  conventions/  reference/  handbook/  templates/
└── manifest.yaml  AGENTS.md  README.md  PROJECT.md
```

### The user-story judgment call

User-story is genuinely borderline:

- **Reference signals** (→ `specs/user-stories/`): owned by business-analyst (requirements owner);
  persists as the definition of "what done means"; Given/When/Then AC are spec-like; peer of prd
  in the dep-graph's Requirements phase
- **Working signals** (→ `delivery/user-stories/`): has `open`/`in-progress`/`done`/`withdrawn`
  states like tasks; consumed during implementation; BMAD precedent places stories in
  implementation-artifacts

Default placement: `specs/user-stories/` — the seedbed's user-stories are requirements artifacts
(owned by business-analyst, with AC), not implementation artifacts like BMAD's stories (which are
closer to the seedbed's tasks). Defensible either way.

### Real-world precedent

- **BMAD**: lifespan split (planning-artifacts vs implementation-artifacts) — L2 adopts the
  top-level axis
- **ClaudeKit**: lifespan split (docs vs plans) — L2 adopts the top-level axis
- L2's type subfolders are a seedbed-specific addition (BMAD/ClaudeKit don't need them because
  they have fewer artifact types)

### Strengths

- **Strongest AI-framework precedent** — adopts the lifespan axis from BMAD and ClaudeKit, the
  two frameworks specifically researched
- **Matches agent context-loading** — `specs/` = always-load (architecture, api-spec, data-design,
  conventions, tech-design); `delivery/` = just-in-time-load (current task, plan, test-spec).
  An agent can be told "load `specs/` for upstream, load specific files in `delivery/` for your
  current unit of work"
- **Builds on existing seedbed instinct** — `notes/` is already a lifespan-aware bucket
  (transient scratchpad); L2 extends this instinct to the whole structure
- **Preserves type-level navigation** — `ls specs/adrs/` still works; type-based browsing intact
- **Fewest ambiguous placements** — one judgment call (user-story), which is genuinely borderline
- **3 artifact buckets, 9 root entries** — cleanest root alongside L1
- **Smallest query impact** — only 3 folder-scoped queries in `vault-queries.md` need path prefixes;
  type-based grep queries (`type: api-spec`) are unaffected

### Weaknesses

- **One judgment call** — user-story placement (specs/ or delivery/) is defensible either way;
  A has zero judgment calls
- **Doesn't match dep-graph 1:1** — collapses 5 phases into 2 buckets; A preserves 1:1
- **No manifest divider precedent** — manifest's `# Requirements`, `# Architecture` etc. dividers
  match A, not L2
- **3-level paths** for some artifacts (e.g. `specs/architecture/adrs/adr-001.md`)

---

## Comparison table

| Dimension | A (phase) | P2 (product/technical/delivery) | L1 (flat lifespan) | L2 (hybrid lifespan) |
|---|---|---|---|---|
| **AI-framework precedent** | Weak (doc frameworks) | Weakest (none do 3-bucket) | Strong (BMAD, ClaudeKit) | **Strong (BMAD, ClaudeKit)** |
| **Top-level artifact buckets** | 6 | 4 | 3 | **3** |
| **Root entries (with framework)** | 12 | 10 | 9 | **9** |
| **Ambiguous placements** | **0** | 4 (all awkward) | 1 (borderline) | 1 (borderline) |
| **Matches dep-graph 1:1** | **Yes** | No | No | No |
| **Matches agent context-loading** | No | No | **Yes** | **Yes** |
| **Builds on existing seedbed instinct** | No | No | Yes (notes/) | **Yes (notes/)** |
| **Preserves type-folder navigation** | Yes | Yes | **No** | Yes |
| **Manifest divider precedent** | **Yes** | No | No | No |
| **Human-intuitive axis** | Medium | High (but undermined) | Medium | Medium |
| **Folder-scoped query impact** | High (all paths change) | High (all paths change) | High (queries break) | **Low (3 queries, prefix only)** |
| **Real-world frameworks** | attractor, BANA spine | BANA (2-bucket only) | BMAD, ClaudeKit | BMAD, ClaudeKit (+ seedbed hybrid) |

## Lifespan categorization (for L1/L2)

| Type | Prefix | Bucket | Rationale |
|---|---|---|---|
| feature-brief | fb- | specs | Requirements root — read across entire feature lifecycle |
| prd | prd- | specs | Requirements root — same |
| press-release | pr- | specs | Requirements root — same |
| user-story | story- | specs (default) | Owned by business-analyst; AC are spec-like; peer of prd in dep-graph. *Judgment call — could go in delivery/* |
| user-flow | uf- | specs | UX flow — persists as design reference for implementation |
| design-spec | ds- | specs | UX spec — persists as design reference |
| adr | adr- | specs | Immutable decision record — persists forever once accepted |
| system-architecture | sa- | specs | System structure — read across all features |
| api-spec | api- | specs | API contract — read by every task implementing against it |
| data-design | dd- | specs | Data shapes — read by every task implementing against it |
| tech-design | td- | specs | Feature-scoped technical design — bridges architecture and tasks; persists as reference |
| task | task- | delivery | Implementation unit — open → in-progress → done, then historical |
| plan | plan- | delivery | Deliverable hierarchy — consumed during planning, then historical |
| test-spec | ts- | delivery | Verification artifact — consumed during testing, then historical |
| note | note- | notes | Scratchpad — no lifespan pattern, any agent any time |

## Impact assessment (for any option)

| File | Change required |
|---|---|
| `manifest.yaml` | `folder:` fields update for all 15 types (e.g. `folder: specs/prds/` for L2) |
| `reference/folder-structure.md` | Full rewrite of the tree diagram |
| `reference/vault-queries.md` | Folder-scoped queries get path prefixes (3 queries for L2; more for A/P2; queries break for L1) |
| `reference/artifact-ownership.md` | No change — ownership is by type, not folder |
| `reference/artifact-dep-graph.md` | No change — dependencies are by type, not folder |
| `reference/artifact-vocabulary.md` | No change — definitions are by type |
| `templates/` | No change — templates reference types, not folders |
| `AGENTS.md` | No change — references `reference/` docs, not artifact folders |
| `handbook/customizations/` | Potential new customization axis: `folder-structure.md` with alternatives |

**L2 has the smallest impact** because type-based grep queries (`type: api-spec`) already search
the whole vault and are unaffected; ownership, dep-graph, vocabulary, templates, and AGENTS.md are
all type-based, not folder-based; only 3 folder-scoped queries need path prefixes.

---

## Research sources

Real-world frameworks examined for folder-structure mindset:

| Framework | Grouping axis | Relevance |
|---|---|---|
| **BMAD-METHOD** | Lifespan (planning-artifacts vs implementation-artifacts) | Direct precedent for L1/L2 |
| **ClaudeKit Engineer** | Lifespan (docs vs plans) | Direct precedent for L1/L2 |
| **Spec-Kit (GitHub)** | Feature (all types for one feature co-located) | Different axis — feature-centric |
| **PRPs-agentic-eng** | Lifecycle status of one artifact type | Different axis — single-type |
| **attractor-guided-engineering** | SDLC phase | Precedent for A |
| **BANA Module Docs** | Product vs engineering (two-bucket) | Partial precedent for P2 (contradicts delivery bucket) |
| **skill-harness** | Domain (product/business/data/research/ux) | Different axis — domain-centric |
| **XDLC wizards** | Flat root docs, one file per concern | No subfolder grouping |
| **MCKRUZ/claude-code-sdlc** | Per-phase flat files | No subfolder grouping |
| **ai-open-sdlc-kit** | Artifacts as GitHub issue comments | No folder structure |
| **sdlc-harness** | Artifacts as knowledge-graph nodes | No folder structure |
| **oh-my-opencode** | Agent orchestration | No artifact-folder mindset |
