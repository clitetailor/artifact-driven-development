# Option A Implementation Checklist
> Step-by-step guide to implement streamlined 3-tier workflow with orchestration

---

## Phase 1: Template Updates

### ☐ 1.1 Update Requirement Template

**File:** `templates/requirement.md`

**Changes:**
- [ ] Add "Scenarios" section after "Functional Requirements"
- [ ] Each scenario includes:
  - [ ] Scenario number/anchor (e.g., `### Scenario 1: {title}`)
  - [ ] Priority field (P0, P1, P2)
  - [ ] Estimated effort (task count + hours)
  - [ ] Dependencies (between scenarios)
  - [ ] Timeline hint (sprint/milestone)
  - [ ] Narrative (As a... I want... so that...)
  - [ ] Preconditions
  - [ ] Acceptance Criteria (testable conditions)
  - [ ] Error/Edge Cases table
- [ ] Add example scenarios in template
- [ ] Update frontmatter: remove `story-{slug}` from soft-deps

---

### ☐ 1.2 Update Task Template

**File:** `templates/task.md`

**Changes:**
- [ ] Add `scenario` field to frontmatter (links to req-{slug}#scenario-N)
- [ ] Add `milestone` field to frontmatter (optional sprint/phase assignment)
- [ ] Add `estimated-hours` field to frontmatter
- [ ] Update "Relevant Specs" section to include scenario reference
- [ ] Update refs example: `req-{slug}#scenario-N` instead of `story-{slug}`

---

### ☐ 1.3 Create Milestone Template

**File:** `templates/milestone.md`

**Changes:**
- [ ] Create new template file
- [ ] Include frontmatter:
  - [ ] id: milestone-{name}
  - [ ] type: milestone
  - [ ] owner: orchestrator
  - [ ] feature, start-date, end-date
- [ ] Include sections:
  - [ ] Objective
  - [ ] Scenarios Included (table)
  - [ ] Scenarios Deferred (table)
  - [ ] Task Breakdown (backend + frontend tracks)
  - [ ] Timeline (Mermaid gantt chart)
  - [ ] Dependencies
  - [ ] Risks
  - [ ] Success Criteria
  - [ ] Progress Tracking (daily notes)
  - [ ] Retrospective (filled at completion)

---

### ☐ 1.4 Archive Story Template

**File:** `templates/story.md`

**Changes:**
- [ ] Move to `templates/_deprecated/story.md`
- [ ] Add deprecation notice at top of file
- [ ] Update notice to reference new scenario approach

---

## Phase 2: Reference Documentation Updates

### ☐ 2.1 Update Artifact Vocabulary

**File:** `reference/artifact-vocabulary.md`

**Changes:**
- [ ] Remove `story` definition
- [ ] Add `scenario` definition:
  ```
  | **scenario** | User narrative embedded in requirement doc, includes AC and orchestration metadata |
  ```
- [ ] Add `milestone` definition:
  ```
  | **milestone** | Optional coordination artifact for cross-cutting timeline tracking |
  ```
- [ ] Update `requirement` definition to mention embedded scenarios

---

### ☐ 2.2 Update Dependency Graph

**File:** `handbook/artifact-dependency-graph.md`

**Changes:**
- [ ] Remove `story` from full dependency graph diagram
- [ ] Update graph to show: `requirement → api-contract/component-spec → task`
- [ ] Add `milestone` as optional informational artifact (doesn't block)
- [ ] Update dependency rules:
  - [ ] Remove story section
  - [ ] Update task hard-deps: remove story, keep requirement
- [ ] Update dependency matrix: remove story column
- [ ] Update frontmatter schema examples: remove story refs

---

### ☐ 2.3 Update Artifact Lifecycle

**File:** `reference/artifact-lifecycle.md`

**Changes:**
- [ ] Remove story lifecycle section
- [ ] Add note: scenarios version with their parent requirement
- [ ] Add milestone lifecycle (if not already present):
  - [ ] draft → accepted
  - [ ] Can be updated during sprint (version bumps)

---

### ☐ 2.4 Update Artifact Ownership

**File:** `reference/artifact-ownership.md`

**Changes:**
- [ ] Remove story ownership row
- [ ] Add milestone ownership row (owner: orchestrator)
- [ ] Update requirement ownership note to include scenario responsibility

---

## Phase 3: Registry Updates

### ☐ 3.1 Update Registry

**File:** `_registry.md`

**Changes:**
- [ ] Mark `story` as deprecated:
  ```markdown
  | story | story- | business-analyst | User narrative | **DEPRECATED** — use scenarios in requirements |
  ```
- [ ] Add `milestone` artifact type:
  ```markdown
  | milestone | milestone- | orchestrator | Timeline coordination (optional) | active |
  ```

---

## Phase 4: Handbook Updates

### ☐ 4.1 Update BA/UX Handbook

**File:** `handbook/ba-ux.md`

**Changes:**
- [ ] Update "Requirements & Information Architecture" section
- [ ] Add guidance on writing scenarios in requirement docs
- [ ] Remove references to standalone story creation
- [ ] Add scenario orchestration metadata guidance (priority, effort, deps, timeline)

---

### ☐ 4.2 Update SDLC Workflows

**File:** `handbook/sdlc-workflows.md`

**Changes:**
- [ ] Phase 1: Update BA workflow
  - [ ] Remove "BA writes stories when scenario-level decomposition is needed"
  - [ ] Add "BA writes scenarios directly in requirement docs"
  - [ ] Update convention check: remove story-specific checks
  - [ ] Update Gate 1: "requirement summary + embedded scenarios"
- [ ] Phase 2: Update design workflow
  - [ ] Update reads: `/requirements/*` (scenarios embedded)
  - [ ] Remove `/stories/*` from reads
- [ ] Phase 3: Update task decomposition
  - [ ] Update reads: scenarios from requirement docs
  - [ ] Update task creation: link to scenarios via `scenario` field
  - [ ] Add milestone creation step (optional)
  - [ ] Update Gate 3: present tasks grouped by scenario
- [ ] Phase 4: Update implementation
  - [ ] Update task refs: scenarios instead of stories
- [ ] Medium Track: Update to use scenarios
- [ ] Session Resume: Update to read scenarios from requirements

---

### ☐ 4.3 Update Agent Roles

**File:** `handbook/agent-roles.md`

**Changes:**
- [ ] Business Analyst role:
  - [ ] Remove "writes story artifacts"
  - [ ] Add "writes scenarios in requirement docs with orchestration metadata"
- [ ] Orchestrator role:
  - [ ] Update to read scenarios from requirements
  - [ ] Add milestone creation responsibility
  - [ ] Update tracking: scenario completion via task status

---

### ☐ 4.4 Update Artifact Dependency Graph Handbook

**File:** `handbook/artifact-dependency-graph.md`

**Changes:**
- [ ] Already updated in Phase 2.2 (same file as reference doc)

---

## Phase 5: Convention Updates

### ☐ 5.1 Update Test Plan Template

**File:** `templates/test-plan.md`

**Changes:**
- [ ] Update soft-deps: remove `story-{slug}`
- [ ] Update refs: remove `story-{slug}`
- [ ] Add note: test plans reference scenarios in requirement docs

---

### ☐ 5.2 Update Test Spec Template

**File:** `templates/test-spec.md`

**Changes:**
- [ ] Update soft-deps: remove `story-{slug}`, add `req-{slug}` if not present
- [ ] Update refs: reference scenarios via `req-{slug}#scenario-N`

---

## Phase 6: Migration of Existing Artifacts

### ☐ 6.1 Identify Existing Stories

**Action:**
```bash
# List all story artifacts
find stories/ -name "*.md" -not -name ".gitkeep"
```

---

### ☐ 6.2 Migrate Stories to Scenarios

**For each story artifact:**

- [ ] Identify parent requirement (check story frontmatter `feature` field)
- [ ] Open parent requirement document
- [ ] Add new scenario section in requirement doc:
  - [ ] Copy story narrative
  - [ ] Copy acceptance criteria
  - [ ] Add orchestration metadata (priority, effort, deps, timeline)
  - [ ] Assign scenario number (scenario-1, scenario-2, etc.)
- [ ] Update all task refs:
  - [ ] Find tasks referencing this story: `rg -l "story-{slug}" tasks/`
  - [ ] Update task frontmatter: `story-{slug}` → `req-{slug}#scenario-N`
  - [ ] Update task refs section
  - [ ] Add `scenario` field to task frontmatter
- [ ] Move story file to archive:
  - [ ] `mkdir -p stories/_deprecated`
  - [ ] `mv stories/story-{slug}.md stories/_deprecated/`
  - [ ] Add deprecation notice to archived file

---

### ☐ 6.3 Update Test Artifacts

**Action:**
```bash
# Find test plans/specs referencing stories
rg -l "story-" test-plans/ test-specs/
```

**For each test artifact:**
- [ ] Update refs: `story-{slug}` → `req-{slug}#scenario-N`
- [ ] Update soft-deps: remove story refs

---

## Phase 7: Validation

### ☐ 7.1 Validate Templates

- [ ] Requirement template has scenarios section with all orchestration fields
- [ ] Task template has scenario, milestone, estimated-hours fields
- [ ] Milestone template is complete and usable
- [ ] Story template is archived with deprecation notice

---

### ☐ 7.2 Validate Reference Docs

- [ ] Artifact vocabulary has no story definition
- [ ] Artifact vocabulary has scenario and milestone definitions
- [ ] Dependency graph has no story nodes
- [ ] Dependency graph shows requirement → task path
- [ ] Artifact lifecycle has no story section

---

### ☐ 7.3 Validate Handbooks

- [ ] BA handbook describes scenario writing in requirements
- [ ] SDLC workflows reference scenarios, not stories
- [ ] Agent roles updated for all agents
- [ ] No references to standalone story creation

---

### ☐ 7.4 Validate Registry

- [ ] Story marked as deprecated
- [ ] Milestone added as active artifact type

---

### ☐ 7.5 Validate Migration

- [ ] All story files moved to `_deprecated/`
- [ ] All task refs updated to use scenarios
- [ ] All test artifact refs updated
- [ ] No broken refs: `rg "story-" --glob '!_deprecated/**' --glob '!*.md'`

---

## Phase 8: Testing

### ☐ 8.1 Test with New Feature

**Create a test feature end-to-end:**
- [ ] Create feature document
- [ ] Create requirement with 2-3 embedded scenarios
- [ ] Each scenario has orchestration metadata
- [ ] Create API contracts / component specs
- [ ] Create tasks linked to scenarios
- [ ] Tasks have scenario, milestone, estimated-hours fields
- [ ] (Optional) Create milestone artifact
- [ ] Validate all refs resolve
- [ ] Validate orchestrator can track scenario completion

---

### ☐ 8.2 Test Orchestrator Queries

**Verify orchestrator can:**
- [ ] Find all scenarios for a feature (read requirement docs)
- [ ] Find all tasks for a scenario (query by scenario field)
- [ ] Calculate scenario completion (count task status)
- [ ] Generate milestone progress report
- [ ] Track dependencies between scenarios

---

### ☐ 8.3 Test Agent Workflows

**Verify each agent can:**
- [ ] Business Analyst: Write requirement with scenarios
- [ ] UX Designer: Read scenarios, create user flows
- [ ] Architect: Read scenarios, create API contracts
- [ ] Engineers: Read scenarios, create tasks
- [ ] Orchestrator: Track progress, generate reports

---

## Phase 9: Documentation

### ☐ 9.1 Update AGENTS.md

**File:** `AGENTS.md`

**Changes:**
- [ ] Update vault folder structure: note story folder deprecated
- [ ] Update artifact conventions: remove story prefix
- [ ] Update vault queries: add scenario query examples

---

### ☐ 9.2 Update README

**File:** `README.md`

**Changes:**
- [ ] Update workflow description: 3-tier instead of 4-tier
- [ ] Update artifact list: remove story, add milestone
- [ ] Add note about scenario-based approach

---

### ☐ 9.3 Create Migration Guide

**File:** `MIGRATION-GUIDE-OPTION-A.md`

**Changes:**
- [ ] Document what changed
- [ ] Document why (benefits)
- [ ] Document how to migrate existing projects
- [ ] Include before/after examples

---

## Phase 10: Cleanup

### ☐ 10.1 Archive Old Documentation

- [ ] Move old analysis docs to `_archive/` if desired
- [ ] Keep WORKFLOW-REFINEMENT-ANALYSIS.md for reference
- [ ] Keep OPTION-A-WITH-ORCHESTRATION.md for reference
- [ ] Keep ORCHESTRATION-COMPARISON.md for reference

---

### ☐ 10.2 Final Validation

- [ ] Run full vault query to ensure no broken refs
- [ ] Verify all templates are consistent
- [ ] Verify all handbooks are consistent
- [ ] Verify all reference docs are consistent

---

## Completion Criteria

- [ ] All templates updated and validated
- [ ] All reference docs updated and validated
- [ ] All handbooks updated and validated
- [ ] All existing stories migrated to scenarios
- [ ] All task refs updated
- [ ] Test feature created successfully end-to-end
- [ ] Orchestrator can track scenarios and milestones
- [ ] All agents can work with new structure
- [ ] Documentation complete

---

## Rollback Plan

If Option A doesn't work as expected:

1. Restore story template from `_deprecated/`
2. Restore story artifacts from `_deprecated/`
3. Revert all template changes (use git/jj history)
4. Revert all handbook changes
5. Revert all reference doc changes
6. Update task refs back to story refs

**Recommendation:** Test thoroughly with one feature before full migration.
