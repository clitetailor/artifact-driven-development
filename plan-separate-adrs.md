# Plan: Separate Architecture Decision Records (ADRs)

## Objective
Extract Architecture Decision Records (ADRs) from being embedded within the `system-architecture` template into a standalone, first-class artifact type. This aligns with standard software engineering practices (immutable historical logs) and allows ADRs to participate fully in the artifact dependency graph.

## Rationale
Currently, ADRs are absorbed as subsections within `templates/system-architecture.md`. 
- **The Problem:** `system-architecture.md` is a living document representing the *current* state of the system, while ADRs are immutable historical records. Mixing them creates friction, merge conflicts, and bloats the architecture document.
- **The Solution:** Treat each ADR as an individual artifact (`adr-{slug}.md`). This allows for parallel reviews, granular statuses (`proposed`, `accepted`, `superseded`), and precise referencing (`refs: [adr-001]`) from downstream artifacts like `tech-design.md` or `task.md`.

## Execution Steps

### 1. Update `manifest.yaml`
Register the new `adr` artifact type under the Architecture section.

```yaml
  # Architecture
  - name: adr
    prefix: adr-
    template: templates/adr.md
```

### 2. Create `templates/adr.md`
Create a new template for individual ADR artifacts based on industry-standard formatting (Michael Nygard's format).

**Proposed Structure:**
- Frontmatter: `id`, `type: adr`, `owner: software-architect`, `status`, `version`, `refs`
- Title: `# ADR: {title}`
- **Context:** The problem or constraint that forced a decision.
- **Decision:** The choice made.
- **Consequences:** Positive and negative trade-offs.
- **Supersedes / Superseded By:** (Optional) Links to related ADRs.

### 3. Update `templates/system-architecture.md`
- Remove the entire `## Architecture Decision Records` section (lines 59-75 approx).
- Add an `## Architectural Decisions` or `## Related Artifacts` section to link out to accepted ADRs, ensuring the architecture document remains a pure reflection of the current system state, backed by standalone decisions.

### 4. Update `reference/artifact-ownership.md` (If applicable)
Ensure that the `software-architect` is listed as the owner of the `adr` artifact type in any relevant reference documentation.

### 5. Update `templates/tech-design.md`
Ensure that the `## Architectural Context` section explicitly guides authors to reference standalone `adr-{slug}` artifacts rather than system-architecture subsections.

## Acceptance Criteria
- [ ] `adr` is recognized as a valid type by the `manifest.yaml`.
- [ ] `templates/adr.md` exists and follows standard ADR structure.
- [ ] `templates/system-architecture.md` no longer contains embedded ADR templates.
- [ ] A test commit via `jj commit` successfully validates the changes.
