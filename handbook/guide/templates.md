# Guide: Templates

How to create, modify, and understand artifact body templates.

Templates live in `templates/`. One file per artifact type. They are the authoritative shape for new artifacts — agents and humans both fill them in.

---

## Structure of a template

Every template has two parts:

**Frontmatter block** — YAML between `---` fences. Contains all required fields with `{placeholder}` values. See `reference/artifact-frontmatter.md` for the field spec.

**Body sections** — Markdown headings that define the artifact's shape. Each section either has a comment explaining what goes there, or a table/list structure the author fills in.

```markdown
---
id: feat-{slug}
type: feature
owner: business-analyst
status: draft
version: 1.0
feature: {feature-slug}
refs:
  - rn-{slug}
---

# Feature: {title}

## Summary
<!-- One paragraph. What this feature does and why it exists. -->

## Scope
### In Scope
-
### Out of Scope
-
```

---

## Creating a new template

Do this when adding a new artifact type (see `handbook/guide/artifacts.md` for the full checklist).

**1. Copy the closest existing template**

Pick the template whose shape most resembles the new type:
- Narrative artifact (feature, requirement) → copy `templates/feature.md`
- Structural / schema artifact (api-contract, data-model) → copy `templates/api-contract.md`
- Task-like artifact → copy `templates/task.md`
- Coordination artifact → copy `templates/change-request.md`

**2. Update the frontmatter block**
- Change `type:` to the new artifact type name (must match the `_registry.md` entry exactly)
- Change `owner:` to the agent slug that owns this type
- Remove optional fields that don't apply
- Add any type-specific optional fields (e.g., `priority:`, `created:`, `resolved:`)

**3. Rewrite the body sections**

Replace the copied sections with sections that fit the new type. Guidelines:
- Each section should have a one-line `<!-- comment -->` describing what goes there
- Prefer tables for structured data (multiple fields per entity)
- Prefer bullet lists for open-ended enumerations
- Keep sections minimal — only include what the type actually needs

**4. Use `{placeholder}` syntax consistently**

All values the author will fill in use `{slug}` style curly-brace placeholders. This makes template gaps easy to grep for:
```bash
grep -n "{" templates/{new-type}.md
```

---

## Modifying an existing template

Changes to a template only affect artifacts created after the change. Existing artifacts are not automatically updated.

**Safe to change:**
- Adding optional sections to the body
- Improving `<!-- comments -->` for clarity
- Adding optional frontmatter fields (e.g., `milestone:`)
- Reordering sections

**Requires a migration decision:**
- Removing a required section — existing artifacts will be inconsistent with the new shape; decide whether to backfill or leave them as-is
- Renaming a required frontmatter field — breaking; existing artifacts will have the old field name; update them or add an alias

When a change is breaking, file a `change-request` against the template (treat it as an artifact) to document the decision and track any backfill work needed.

---

## Template vs. artifact

Templates are shapes, not instances. Never put real product content directly in a template. If you find real content in `templates/`, move it to the appropriate artifact folder and replace it with a placeholder.

Templates are also not schemas — they are not validated programmatically. The dep graph and ownership tables in `reference/` are the machine-readable spec; templates are the human-readable fill-in form.
