# Workflow Refinement Analysis
> Identifying overlaps in feature → requirement → story → task workflow

---

## Current State: Overlap Analysis

### 1. Feature vs Requirement Overlap

**Duplicated fields:**
- **Scope (In/Out)** — both define boundaries
- **Success Metrics** — both track measurable outcomes
- **User Context** — both reference personas
- **Open Items/Questions** — both track unresolved issues

**Current distinction:**
- Feature = high-level product capability
- Requirement = scoped PRD for one feature

**Problem:** A feature with only one requirement creates redundant documentation. 80% of content is duplicated.

---

### 2. Requirement vs Story Overlap

**Duplicated fields:**
- **User Context** — both link to personas
- **Acceptance Criteria** — functional requirements vs story AC are semantically identical
- **Scope boundaries** — both define what's included/excluded

**Current distinction:**
- Requirement = functional spec (table of requirements)
- Story = user narrative + testable criteria

**Problem:** Stories are marked "optional" but acceptance criteria appear in both. When do you write a story vs just use requirement acceptance criteria?

---

### 3. Story vs Task Overlap

**Duplicated fields:**
- **Acceptance Criteria** — both have testable pass/fail conditions
- **Scope (Included/Excluded)** — both define boundaries
- **Preconditions** — story has explicit section, task implies it

**Current distinction:**
- Story = user-facing scenario
- Task = agent-sized implementation unit

**Problem:** Task acceptance criteria often restate story acceptance criteria at implementation level. Creates 3 layers of AC (requirement → story → task).

---

### 4. Task-breakdown Artifact

**Purpose:** Coordinates phased CR task sets

**Problem:** Adds coordination overhead. Tasks could reference CRs directly without intermediate breakdown artifact.

---

## Proposed Approaches

### Option A: Streamlined (3-tier)

**Structure:**
```
Feature (vision + scope)
  ↓
Requirement (functional spec with embedded scenarios)
  ↓
Task (implementation unit)
```

**Changes:**
1. **Eliminate** standalone `story` artifacts
2. **Embed** user narratives directly in requirement documents as "Scenarios" section
3. **Requirement template** becomes:
   - Problem Statement
   - Functional Requirements (table)
   - **Scenarios** (user narratives with AC) ← replaces stories
   - Success Metrics
   - Constraints
4. **Task-breakdown** kept only for CR-driven work
5. **Feature** remains lightweight: vision, scope, metrics, personas

**Dependency graph:**
```
feature
  ↓
requirement (with embedded scenarios)
  ↓
api-contract / component-spec
  ↓
task
```

**Pros:**
- Eliminates one artifact type (story)
- Scenarios stay close to functional requirements
- Clearer: requirement = complete functional spec
- Reduces hard-dep chain length

**Cons:**
- Larger requirement documents
- Scenarios not independently versionable
- Less granular traceability (can't link task → specific story)

**When to use each:**
- **Feature:** One per major product capability
- **Requirement:** One per feature (or per module if feature is large)
- **Task:** One per implementation unit (API endpoint, UI component, etc.)

---

### Option B: Minimal (2-tier)

**Structure:**
```
Feature (complete functional spec)
  ↓
Task (implementation unit)
```

**Changes:**
1. **Eliminate** both `requirement` and `story` artifacts
2. **Feature template** becomes comprehensive:
   - Summary
   - Problem Statement
   - Functional Requirements (table with priority)
   - User Scenarios (embedded narratives)
   - Success Metrics
   - Constraints
   - User Context (personas)
3. **Tasks** derive directly from feature via intermediate design artifacts (API contracts, component specs)
4. **Task-breakdown** eliminated — tasks reference feature + design specs directly

**Dependency graph:**
```
feature
  ↓
api-contract / component-spec
  ↓
task
```

**Pros:**
- Maximum consolidation
- Shortest hard-dep chain
- Feature = single source of truth
- Fewer artifacts to maintain

**Cons:**
- Very large feature documents
- Hard to decompose large features
- Loss of granularity for complex features
- All acceptance criteria in one place (harder to navigate)

**When to use each:**
- **Feature:** One per product capability (must be comprehensive)
- **Task:** One per implementation unit

---

### Option C: Current with Clear Boundaries

**Structure:** Keep all four artifact types but clarify when to create each

**Changes:**
1. **Feature** = Product vision document
   - High-level scope and success metrics
   - Links to personas
   - **No functional requirements** — just vision
   - **Always created** for every product capability

2. **Requirement** = Functional specification
   - Detailed functional requirements table
   - Constraints and dependencies
   - **No user narratives** — just requirements
   - **Always created** for every feature

3. **Story** = Scenario-level detail
   - User narrative + acceptance criteria
   - **Only created when:**
     - Requirement needs scenario-level decomposition
     - Multiple user paths exist for same requirement
     - UX flow is complex enough to warrant separate doc
   - **Optional** — skip if requirement AC is sufficient

4. **Task** = Implementation unit
   - Links to API/component specs
   - Implementation-level acceptance criteria
   - **Always created** for every implementation unit

**Decision criteria added:**

| Artifact | Create When | Skip When |
|----------|-------------|-----------|
| Feature | Always (one per capability) | Never |
| Requirement | Always (one per feature or module) | Never |
| Story | Requirement has multiple user paths OR complex UX flow | Requirement AC is sufficient |
| Task | Always (one per implementation unit) | Never |

**Pros:**
- Preserves existing structure
- Adds clarity via decision criteria
- Flexible — stories optional when not needed
- Maintains granular traceability

**Cons:**
- Still has overlap when all artifacts used
- Requires judgment calls on when to create stories
- Most complex option (4 artifact types)
- Longest hard-dep chains

---

## Recommendation Matrix

| Criterion | Option A (3-tier) | Option B (2-tier) | Option C (Current) |
|-----------|-------------------|-------------------|-------------------|
| **Simplicity** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Granularity** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Traceability** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Document size** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **Maintenance** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| **Flexibility** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |

---

## Impact on Dependency Graph

### Current Graph (4-tier)
```
feature
  ↓
requirement
  ↓
story (optional)
  ↓
api-contract / component-spec
  ↓
task
```

**Hard-dep chain length:** 5 levels

---

### Option A Graph (3-tier)
```
feature
  ↓
requirement (with scenarios)
  ↓
api-contract / component-spec
  ↓
task
```

**Hard-dep chain length:** 4 levels
**Change:** Story removed from graph; scenarios embedded in requirement

---

### Option B Graph (2-tier)
```
feature (comprehensive)
  ↓
api-contract / component-spec
  ↓
task
```

**Hard-dep chain length:** 3 levels
**Change:** Requirement and story merged into feature

---

## Agent Role Impact

### Option A (3-tier)

**Business Analyst:**
- Writes features (unchanged)
- Writes requirements **with embedded scenarios** (new responsibility)
- No longer writes standalone stories

**UX Designer:**
- Writes user-flows (unchanged)
- Contributes scenario narratives to requirement docs (new workflow)

**Software Architect / Engineers:**
- Read requirement scenarios instead of story artifacts
- Task creation unchanged

---

### Option B (2-tier)

**Business Analyst:**
- Writes comprehensive feature docs (expanded responsibility)
- No requirement or story artifacts

**UX Designer:**
- Contributes scenarios directly to feature docs

**Software Architect / Engineers:**
- Read feature docs directly
- Task creation unchanged

---

### Option C (Current with boundaries)

**No role changes** — just clearer decision criteria

---

## Migration Path

### If choosing Option A (3-tier):

1. Update `templates/requirement.md` to add "Scenarios" section
2. Archive `templates/story.md` (keep for reference)
3. Update `reference/artifact-vocabulary.md` to remove story definition
4. Update `handbook/artifact-dependency-graph.md` to remove story from graph
5. Update `_registry.md` to mark story as deprecated
6. Migrate existing stories into requirement documents as scenarios

---

### If choosing Option B (2-tier):

1. Expand `templates/feature.md` to include functional requirements + scenarios
2. Archive `templates/requirement.md` and `templates/story.md`
3. Update `reference/artifact-vocabulary.md` to remove requirement and story
4. Update `handbook/artifact-dependency-graph.md` to remove both from graph
5. Update `_registry.md` to mark both as deprecated
6. Migrate existing requirements + stories into feature documents

---

### If choosing Option C (Current with boundaries):

1. Add decision criteria table to `reference/artifact-vocabulary.md`
2. Update each template with "When to create this artifact" section
3. Add examples of when to skip optional artifacts
4. No migration needed — existing artifacts remain valid

---

## Recommended Approach

**Option A (Streamlined 3-tier)** is the best balance:

**Rationale:**
1. **Eliminates clear redundancy** — story vs requirement overlap is most problematic
2. **Preserves granularity** — feature and requirement remain separate for large features
3. **Maintains traceability** — scenarios still exist, just embedded
4. **Reduces maintenance** — one fewer artifact type to manage
5. **Clearer workflow** — feature → requirement → task is intuitive
6. **Shorter dep chains** — 4 levels instead of 5

**Story artifacts are the weakest link:**
- Marked "optional" in current vocabulary
- Overlap heavily with both requirements and tasks
- Create 3-layer AC redundancy (req → story → task)
- Embedding scenarios in requirements keeps context together

---

## Next Steps

1. **Decision:** Choose Option A, B, or C
2. **Update templates** based on chosen option
3. **Update reference docs** (vocabulary, dependency graph, lifecycle)
4. **Update agent handbooks** with new workflow
5. **Migrate existing artifacts** if needed
6. **Test workflow** with one feature end-to-end
