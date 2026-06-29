# List Formatting in Artifacts

How to choose between **bullet list**, **table**, **subsection with description**, **checkbox list**, and **numbered list** when rendering a collection of items in an artifact body or template.

## Decision Rule

Answer these questions in order. The first match wins.

1. **Does each item need a binary done/not-done state to track?** → **Checkbox list**
2. **Does item order or priority carry meaning?** → **Numbered list**
3. **How many attributes per item?**
   - **1 attribute** → **Bullet list**
   - **Multiple attributes, all short (≤ ~8 words per field)** → **Table**
   - **Multiple attributes, at least one is prose (a sentence or more)** → **Subsection with description** (or **bold-key bullets** if each item is 1–3 lines)

## When to use each format

| Format | Best for | Why |
|---|---|---|
| Bullet list | Single-field items (references, scope items, constraints) | Lowest friction; scans vertically |
| Table | Fixed schema of short fields; side-by-side comparison valuable (state transitions, ADR index, API params, alternatives) | Compact; rows comparable |
| Subsection with description | One field is prose-length (test cases, entity definitions, edge cases with detailed triggers) | Avoids cramped/wrapping table cells |
| Checkbox list | Items with binary completion state (acceptance criteria, pipeline next steps) | Tracks progress inline |
| Numbered list | Sequence or priority is itself information (key requirements) | Order is signal |

## Bold-key bullets vs subsections

Both render multi-attribute items where one field is a sentence. Choose by item weight:

- **Bold-key bullets** — items are 1–3 lines each. Lighter weight; keeps the section compact.
  ```markdown
  - **Performance:** p95 < 200ms under 1000 RPS
  - **Reliability:** 99.9% availability
  ```
- **Subsections** — items need their own multi-line body (test cases with steps, entities with field tables).
  ```markdown
  ### TC-1: {case name}
  - **Given:** ...
  - **When:** ...
  - **Then:** ...
  ```

## Rejected alternatives

- **Nested bullets for multi-attribute data** (e.g. Open Questions with status/resolution as nested bold keys) — verbose; hard to scan one attribute across many items. Use a table.
- **Tables for prose-heavy fields** — cells wrap badly, hard to read. Use a subsection.
- **Plain checkbox list for items that carry metadata** (e.g. Open Questions with status + resolution) — loses metadata downstream agents need. Use a table; track resolution state in a `Status` column.

## Canonical format by data kind

Applies to templates and to artifacts authored from them. If a template's section isn't listed here, apply the Decision Rule.

| Data kind | Format | Reason |
|---|---|---|
| Acceptance Criteria | Checkbox list | Binary tracking |
| Alternatives (ADR) | Table | Short fields, comparison |
| Architectural Decisions index | Table | Short fields, scannable |
| Business Rules / Invariants | Bullet list | Single field |
| Constraints (NFR) | Bold-key bullets | Category + sentence |
| Dependencies & Risks | Bold-key bullets | Type + sentence + mitigation |
| Edge Cases | Subsection with description | Prose trigger/behavior |
| Error Cases | Subsection with description | Prose trigger/message |
| In Scope / Out of Scope | Bullet list | Single field |
| Key Requirements (ordered) | Numbered list | Priority is signal |
| Metrics / Success Metrics | Table | Short fields, comparison |
| Open Questions | Table | Short fields, status scanning |
| Pipeline Next Steps | Checkbox list | Binary tracking |
| References | Bullet list | Single field |
| State Transitions | Table | Short fields, comparison |
| User Stories / Key Results mapping | Table | Short fields, mapping |
