# Plan: Update Design Specs for HTML Wireframes

## Objective
Update the `design-spec` workflow to support creating wireframes in HTML while keeping component specifications in Markdown. This ensures we maintain the framework's single `design-spec` artifact type and dependency tracking, while allowing for richer, interactive wireframes.

## Proposed Structure
HTML wireframes will act as supporting files (attachments) to the official `design-spec` markdown artifacts.

```text
{vault-root}/
└── design-specs/
    ├── ds-{slug}.md         <-- The official artifact (frontmatter, component behaviors, design tokens)
    └── wireframes/          <-- Subfolder for supporting visual files
        └── ds-{slug}.html   <-- The interactive/visual HTML wireframe
```

## Action Items

### 1. Update `templates/design-spec.md`
Modify the template to instruct authors on how to link to the external HTML wireframe, replacing the default ASCII box example.

**Changes:**
- Update the `## Wireframes` section.
- Remove the ASCII box placeholder.
- Add standard link syntax: `👉 **[View Wireframe HTML](wireframes/ds-{slug}.html)**`
- Keep the `#### Annotations` and `#### States Shown` sections so the markdown file remains the source of truth for behavior and context.

### 2. Create the `design-specs/wireframes/` Directory
Ensure the directory structure exists for future use. Note: Git doesn't track empty directories, so we may need to add a `.gitkeep` file if we want to commit the directory structure immediately.

### 3. (Optional) Update Documentation
If necessary, update `reference/folder-structure.md` to document the purpose of the `design-specs/wireframes/` directory, ensuring future agents and users understand where to place these files.

## Benefits
- **Zero Framework Changes:** The artifact dependency graph (`artifact-dep-graph.md`), `manifest.yaml`, and agent instructions remain completely unchanged.
- **Maintain Frontmatter Integrity:** YAML frontmatter stays in the `.md` file, ensuring compatibility with `orchard query` and other scripts.
- **High Cohesion:** Everything related to a design spec stays within the `design-specs/` folder.
