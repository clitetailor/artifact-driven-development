# Artifact Tool — Use Cases

## Core CRUD

- Create an artifact from a template (fill in frontmatter, assign ID, place in correct folder)
- List artifacts by type, status, or phase
- Archive/deprecate an artifact and update downstream `refs`

## Navigation & Tracing

- Follow the `refs` chain upstream/downstream from a given artifact (e.g., trace a task back to its originating persona)
- Find all artifacts referencing a given ID (reverse lookup)
- Show the dependency graph for a feature end-to-end

## Consistency Checks

- Detect broken refs (an artifact references an ID that no longer exists)
- Find orphaned artifacts (no incoming or outgoing refs)
- Validate frontmatter completeness against `_registry.md` schemas

## Workflow Management

- List all open tasks for a milestone
- Show blockers: tasks whose upstream artifacts (req, adr) are still in draft
- Mark a task done and propagate status to sibling artifacts in the same feature

## Search & Query

- Full-text search scoped to a specific artifact type or SDLC phase
- Query by frontmatter field (e.g., all `req-` with `status: draft` under `feat-001`)

## Reporting

- Progress summary per milestone (done/in-progress/blocked counts)
- Changelog: artifacts created/updated since a given date
