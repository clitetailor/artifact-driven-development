# Plan: Replace PRDs with Feature Briefs

Rename the `prd` artifact type to `feature-brief` across the entire framework. This is a mechanical rename — the artifact's purpose and content stay the same; only the label, prefix, folder, and template name change.

---

## Summary of Changes

| Aspect | Before | After |
|--------|--------|-------|
| Artifact type name | `prd` | `feature-brief` |
| ID prefix | `prd-` | `fb-` |
| Folder | `prds/` | `feature-briefs/` |
| Template file | `templates/prd.md` | `templates/feature-brief.md` |
| Frontmatter field | `prd: {charter-slug}/{prd-slug}` | `feature-brief: {fb-slug}` |
| Feature type pattern | `charter/prd` | `feature-brief` |
| Display name (prose) | PRD / Product Requirements Document | Feature Brief |

---

## Phase 1 — Core Declarations

### 1.1 `manifest.yaml`

- `feature_type: charter/prd` → `feature_type: feature-brief` (remove charter from pattern)
- Type entry:
  ```yaml
  # Before
  - name: prd
    prefix: prd-
    template: templates/prd.md

  # After
  - name: feature-brief
    prefix: fb-
    template: templates/feature-brief.md
  ```

### 1.2 `templates/prd.md` → `templates/feature-brief.md`

- Rename file: `templates/prd.md` → `templates/feature-brief.md`
- Replace the entire template contents with this new, lean structure that discards old heavy concepts (like Stakeholders and macro-level Vision) and focuses on actionable, feature-scoped requirements:

  ```markdown
  ---
  id: fb-{descriptor}
  type: feature-brief
  owner: business-analyst
  status: draft
  version: 1.0
  refs:
    - {related-artifact-id}
  ---
  
  # Feature Brief: {title}
  
  ## Problem Statement
  <!-- What specific user friction or business need does this feature address? -->
  
  ## Proposed Solution
  <!-- High-level overview of how we are solving the problem. -->
  
  ## Success Metrics
  <!-- How do we know this feature is successful? (e.g., "Increase conversion by 2%") -->
  
  | Metric | Target |
  |--------|--------|
  |        |        |
  
  ## Scope
  
  ### In Scope
  - 
  
  ### Out of Scope
  - 
  
  ## Key Requirements
  <!-- Plain English capabilities this feature must have. -->
  - 
  
  ## Constraints & Guidelines
  <!-- Feature-specific non-functional requirements (e.g., strict latency targets, compliance rules). -->
  - 
  
  ## Dependencies & Risks
  <!-- What external teams, APIs, or approvals are blocking this? What are the business risks? -->
  - 
  
  ## User Stories
  <!-- Links to story artifacts extracted from the requirements above. -->
  - story-{slug} — {one-line summary}
  
  ## Open Questions
  - 
  
  ## References
  - [{related-artifact-id}](../{folder}/{related-artifact-id}.md)
  ```

### 1.3 Folder rename

- `prds/` → `feature-briefs/`
- Move `.gitkeep` into the new folder; remove the old folder.

---

## Phase 2 — Reference Docs

### 2.1 `reference/artifact-vocabulary.md`

- Row `**charter**`: delete this entire row.
- Row `**prd**`: rename to `**feature-brief**`, update definition text:
  - Before: `Product Requirements Document — scoped to one charter (or sub-area), captures *what* the system must do with ID-tagged requirements. Absorbs project-charter (vision/scope/stakeholders), stakeholder-matrix, and quality-requirement content. Owned by business-analyst.`
  - After: `Feature Brief — captures *what* the system must do for a specific feature, along with success metrics and constraints. Owned by business-analyst.`
- Row `**user-story**`: update "extracted from a PRD" → "extracted from a feature brief"

### 2.2 `reference/artifact-dep-graph.md`

- Phase table (line 8): `prd, user-story` → `feature-brief, user-story`
- Mermaid diagram: `PRD[prd]` → `FB[feature-brief]`
- Dependency table: every `prd` entry → `feature-brief`
  - `prd | —` → `feature-brief | —`
  - `user-story | prd` → `user-story | feature-brief`
  - `user-flow | prd` → `user-flow | feature-brief`
  - `system-architecture | prd` → `system-architecture | feature-brief`
  - `tech-design | system-architecture, prd` → `tech-design | system-architecture, feature-brief`

### 2.3 `reference/artifact-frontmatter.md`

- Lines 14 and 26: Remove the `charter: {charter-slug}` field entirely from the required frontmatter block and its explanation.
- Line 26: `prds/prd-{slug}.md` → `feature-briefs/fb-{slug}.md`
- Line 33: `PRD artifacts may carry: prd` → `Feature Brief artifacts may carry: feature-brief`
- Line 33: `{charter-slug}/{prd-slug}` → `{fb-slug}` (drop charter-slug prefix — feature type no longer uses charter path)
- Line 33: `path from the manifest` → `slug from the manifest` (no longer a path)
- Line 55: ID naming pattern `id: {prefix}-{charter}-{descriptor}` → `id: {prefix}-{descriptor}` (remove charter from ID naming convention). Update explanation text accordingly.
- Line 61 (examples): `prd-user-authentication-login` → `fb-user-authentication-login`

### 2.4 `reference/artifact-ownership.md`

- Ownership table: `prd, user-story` → `feature-brief, user-story`

### 2.5 `reference/folder-structure.md`

- Line 8: `PRDs` → `Feature Briefs`
- Line 9: `prds/  # Product Requirements Documents (prd-)` → `feature-briefs/  # Feature Briefs (fb-)`

### 2.6 `reference/coordination-decision-tree.md`

- Line 17: `Defining a new PRD` → `Defining a new feature brief`
- Line 17: `User Stories (in prd or as story- artifacts)` → `User Stories (in feature-brief or as story- artifacts)`
- Line 24: `Creates prd → user-flow → api-spec → tech-design → task chain` → `Creates feature-brief → user-flow → api-spec → tech-design → task chain`
- Line 78: `in prd or story- artifacts` → `in feature-brief or story- artifacts`

### 2.7 `reference/vault-queries.md`

- Line 4: `Charters and PRDs are discovered via live scan` → `Feature briefs are discovered via live scan`
- Line 4: `orchard query --pattern 'charter/prd'` → `orchard query --pattern 'feature-brief'`
- Lines 7-9: Remove `# All artifacts for a charter` query example.
- Lines 15-17: Remove `# All accepted artifacts for a charter` query example.
- Line 25: `^id: prd-user-authentication-login` → `^id: fb-user-authentication-login`

---

## Phase 3 — Agent Docs

### 3.1 `agents/business-analyst.md`

- Lines 7-8: `Owns all pre-design artifacts. PRD absorbs charter, stakeholder-matrix, and quality-requirement content.` → `Owns all pre-design artifacts, primarily the feature-brief and user stories.`
- Capabilities (lines 15-17): Remove the three bullets for "Vision & scope definition", "Stakeholder identification", and "Non-functional requirements".
- Owned Artifacts table: `prd | prds/prd-{charter}-{descriptor}.md` → `feature-brief | feature-briefs/fb-{descriptor}.md`

### 3.2 `agents/qa-engineer.md`

- Line 24: `reads  : /prds/*` → `reads  : /feature-briefs/*`

---

## Phase 4 — Artifact Templates (frontmatter & body references)

Every template that has a `prd:` frontmatter field or references `prd-` IDs / `../prds/` paths needs updating.

### 4.1 `templates/task.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`

### 4.2 `templates/user-flow.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`
- References line 72: `../prds/req-{slug}.md` → `../feature-briefs/req-{slug}.md`

### 4.3 `templates/tech-design.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`
- Frontmatter line 13 (refs): `prd-{charter}-{descriptor}` → `fb-{descriptor}`
- References line 57: `prd-{charter}-{descriptor}](../prds/prd-{charter}-{descriptor}.md` → `fb-{descriptor}](../feature-briefs/fb-{descriptor}.md`
- **Structural Refactor:** Add the Observability and Deployment sections so engineering handles the Success Metrics and Risks defined in the Feature Brief. Inject these new sections right after the "Key Decisions" table and before "Implementation Plan":

  ```markdown
  ## Observability & Instrumentation
  <!-- How are we tracking the Success Metrics defined in the Feature Brief? What logs/events are we emitting? -->
  - **Events:** `event_name` (Properties: `prop1`, `prop2`)
  - **Monitors/Alerts:** {What should page us if this feature breaks?}
  
  ## Deployment & Rollout Strategy
  <!-- Feature flags, environment variables, dark launches, and migration steps. -->
  - **Feature Flag:** `flag-name` (default: false)
  - **Rollout Plan:** {e.g., Enable for internal users -> 10% -> 100%}
  - **Rollback Plan:** {How do we revert if it causes an incident?}
  ```

### 4.4 `templates/system-architecture.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`

### 4.5 `templates/api-spec.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`

### 4.6 `templates/data-design.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`

### 4.7 `templates/design-spec.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`

### 4.8 `templates/test-spec.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 8: `prd: {charter-slug}/{prd-slug}` → `feature-brief: {fb-slug}`
- References line 137: `../prds/req-{slug}.md` → `../feature-briefs/req-{slug}.md`

### 4.9 `templates/user-story.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Frontmatter line 13 (refs): `prd-{charter}-{descriptor}` → `fb-{descriptor}`
- References line 49: `prd-{charter}-{descriptor}](../prds/prd-{charter}-{descriptor}.md` → `fb-{descriptor}](../feature-briefs/fb-{descriptor}.md`

### 4.10 `templates/ticket.md`

- Remove `charter: {charter-slug}` from frontmatter.
- Line 28 comment: `PRD requirement` → `feature brief requirement`

---

## Phase 5 — Root Files

### 5.1 `PROJECT.md`

- Section heading (line 21): `## PRDs` → `## Feature Briefs`
- Table header (line 23): `| PRD | Status | Summary |` → `| Feature Brief | Status | Summary |`
- Comment placeholder (line 25): `<!-- prd-{slug} -->` → `<!-- fb-{slug} -->`

### 5.2 `README.md`

- Line 36: `prd- — product requirements (absorbs charter, stakeholder-matrix, quality-requirement)` → `fb- — feature brief (problem statement, scope, metrics, requirements)`
- Line 60: `Human-readable project overview (active tickets, PRDs, status)` → `Human-readable project overview (active tickets, feature briefs, status)`
- Line 75: `prds/, user-stories/, …` → `feature-briefs/, user-stories/, …`

---

## Phase 6 — Handbook

### 6.1 `handbook/setup.md`

- Line 62: `Default is \`charter/prd\` — a feature is anything matching that pattern` → `Default is \`feature-brief\` — a feature is anything matching that pattern`

---

## Execution Order

1. **Phase 1** — Core declarations (manifest, template file rename, folder rename)
2. **Phase 2** — Reference docs (7 files)
3. **Phase 3** — Agent docs (2 files)
4. **Phase 4** — Artifact templates (10 files)
5. **Phase 5** — Root files (2 files)
6. **Phase 6** — Handbook (1 file)

Phases 2–6 are independent of each other and can be done in parallel after Phase 1.

---

## Verification

After all changes:

- [ ] `rg -i "prd"` returns zero matches across the entire vault (excluding `_sources/` and `LICENSE`)
- [ ] `rg -i "PRD"` returns zero matches across the entire vault (excluding `_sources/` and `LICENSE`)
- [ ] `feature-briefs/` folder exists with `.gitkeep`
- [ ] `templates/feature-brief.md` exists, `templates/prd.md` does not
- [ ] `manifest.yaml` lists `name: feature-brief`, `prefix: fb-`, `template: templates/feature-brief.md`, `feature_type: feature-brief`
- [ ] All frontmatter `prd:` fields across templates are now `feature-brief:`
- [ ] All `../prds/` path references across templates are now `../feature-briefs/`
- [ ] No remaining `charter/prd` or `charter/feature-brief` pattern references — feature type is simply `feature-brief`
