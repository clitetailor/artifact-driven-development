# customization file Format

Conventions for files in `handbook/customizations/`. Each customization axis (e.g. requirements-root type,
ask-threshold policy) has one file listing all alternatives side-by-side.

---

## File structure

Every customization file follows this structure:

1. **Header** — what the customization switches, how to apply, how to switch later.
2. **What changes** — one-paragraph summary of the scope (which files, which fields).
   Axes that move existing files declare a `**Migration model:**` line here; Step 2 surfaces
   it instead of the default on-demand line.
3. **Alternatives table** — compact overview: one row per alternative with prefix, folder,
   role (default/alternative), and key identifiers. This is the catalog, not the content.
   No status column — see Principle 7 below.
4. **Per-alternative sections** — full final state of every changed line for each
   alternative (or just the manifest field value, for axes that touch only
   `manifest.yaml`). This is what the agent applies.
5. **Apply** — step-by-step instructions: how to locate targets, which tool to use, what
   order to work in.
6. **Verify** — grep assertions with expected counts, run after applying to catch misses.
   Three assertion types: "should be gone" (residual old tokens → 0 hits), "should be
   present" (new tokens → expected count), and edge-case (generic mentions that should
   NOT have changed → still present).
7. **Notes** — orthogonality with other customizations, migration caveats, known issues.

### Layers

A customization axis touches one or more **layers** — kinds of edits it makes to the
vault. Each axis declares which layers it uses in its **What changes** section. The four
layers are:

- **L1 — templates:** placeholder swaps across downstream templates. Present only for
  axes that touch templates.
- **L2 — reference docs & handbook:** prose relabeling across reference docs. Present only
  for axes that touch reference docs.
- **manifest.yaml:** one or more field edits. Present for axes that touch `manifest.yaml`.
- **AGENTS.md:** bullet replacements. Present only for axes that touch `AGENTS.md`.

When a layer is absent, the customization file omits its section entirely — there is no
"this axis does not use L1" placeholder. Principles 5 and 6 below govern L1 and L2 *when
they are present*.

---

## Principles

### 1. Per-axis, not per-alternative

One file per customization axis, not one file per alternative. All alternatives for an axis
live in the same file so the user sees the full customization space at once.

### 2. Alternatives are peers, not inverses

Alternatives are independent options that occupy the same slot — not deltas from a
default that can be "undone." Switching from one to another is always "apply a different
alternative's section." There is no "revert" operation.

### 3. "Default" is static; current state is dynamic

"Default" means the shipped starting option — a static fact about the seedbed. The
current state is whatever the target file says right now, determined by reading it
(e.g. `manifest.yaml`'s `requirements_root:` field, or `AGENTS.md`'s Communication bullet
lead-in). If the chosen alternative is already the current state, skip to Verify.

### 4. Representation: full final state vs. token table

- **Complete rewrites** (entire bullet/paragraph replaced) → **full final state** in a
  code block. Diff would be 100% changed lines — pure noise.
- **Surgical edits** (token swaps within unchanged text) → **token table** with
  find/replace pairs + find commands. Diff-like, but parameterized.

A single customization file may use both: token table for surgical edits (e.g. L1
placeholder swaps), full final state for complete rewrites (e.g. L2 prose relabeling).

### 5. L1 (templates, when present): find commands, not hardcoded file lists

Applies only to axes with an L1 layer. Use `rg -l` (or
`grep -rl` fallback) to discover target files at apply time. Don't hardcode a file list —
it goes stale when templates are added or removed. The find pattern is also the safety
gate: e.g. `rg -l "{<type>-id}"` returns exactly the downstream templates that reference a
given type and excludes that type's own root template (which uses `{related-artifact-id}`,
not `{<type>-id}`).

The agent chooses the tool (sed, Edit, or a mix) — the file specifies *what* to replace,
not *how*.

### 6. L2 (reference docs, when present): summary with "does not change" line

Applies only to axes with an L2 layer. The L2 section starts
with a summary describing what changes and **what does not change**. The "does not change"
line bounds the agent's edit scope and catches edge cases where a blanket sed would
over-edit (e.g. generic "PRD" mentions in other artifact definitions that use the term as
an industry word, not as the default type name).

### 7. Status is structural, not a field

An alternative's readiness is shown by its presence in the file, not by a status column:

- An alternative with a **per-alternative section** (full final state of changed lines, or
  the manifest field value) is **ready to apply**.
- An alternative with **only a row in the Alternatives table** (no per-alternative section)
  is **pending** — listed as a known option but not yet fleshed out.

Verification is a **gate before adding the per-alternative section**, not a recorded state:
run the §Verify block against a test apply, confirm it passes, then commit the section.
Once the section exists, it is assumed verified — there is no `Drafted` vs `Verified`
distinction to maintain.

The **applied state** (which alternative is currently active in the vault) lives in
`manifest.yaml` (e.g. `requirements_root:`, `domain_record:`, `dated_types:`) or `AGENTS.md` (the
`## Communication` first bullet lead-in) — never in a status field. Read the target file
to determine the current state; do not record it in the customization file.

---

## Illustrative diffs

When a customization file includes an illustrative ` ```diff ` block (e.g. to show the shape
of an L1 token swap), the warning "illustrative, not load-bearing" lives next to that
diff. The token table and find commands are the source of truth — the diff is a visual
aid, not something to hunt for exact lines.

---

## Adding a new customization axis

1. Create `handbook/customizations/<axis>.md` following the structure above. The file is
   self-contained — its **What changes** section declares which layers it uses, and its
   **Apply** section carries the apply procedure. No framework-doc updates are needed.
2. Add a row to `handbook/customizations/README.md`'s "Available customizations" table.

## Adding a new alternative to an existing axis

1. Add a row to the axis file's Alternatives table.
2. Add a per-alternative section with full final state for every changed file (or just the
   manifest field value, for axes that touch only `manifest.yaml`).
3. If the axis has an L2 layer, update the "does not change" line in the L2 summary if the
   new alternative introduces new edge cases.
