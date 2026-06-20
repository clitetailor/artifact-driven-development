# Decision File Format

Conventions for files in `decisions/`. Each decision axis (e.g. requirements-root type,
ask-threshold policy) has one file listing all alternatives side-by-side.

---

## File structure

Every decision file follows this structure:

1. **Header** — what the decision switches, how to apply, how to switch later.
2. **What changes** — one-paragraph summary of the scope (which files, which fields).
3. **Alternatives table** — compact overview: one row per alternative with prefix, folder,
   role (default/alternative), and key identifiers. This is the catalog, not the content.
4. **Per-alternative sections** — full final state of every changed line for each
   alternative. This is what the agent applies.
5. **Apply** — step-by-step instructions: how to locate targets, which tool to use, what
   order to work in.
6. **Verify** — grep assertions with expected counts. Run after applying to catch misses.
7. **Notes** — orthogonality with other decisions, migration caveats, known issues.

---

## Principles

### 1. Per-axis, not per-alternative

One file per decision axis, not one file per alternative. All alternatives for an axis
live in the same file so the user sees the full decision space at once.

### 2. Alternatives are peers, not inverses

Alternatives are independent options that occupy the same slot — not deltas from a
default that can be "undone." Switching from one to another is always "apply a different
alternative's section." There is no "revert" operation.

### 3. "Default" is static; current state is dynamic

"Default" means the shipped starting option — a static fact about the seedbed. The
current state is whatever the target file says right now, determined by reading it
(e.g. `manifest.yaml`'s `feature_type:` field, or `AGENTS.md`'s Communication bullet
lead-in). If the chosen alternative is already the current state, skip to Verify.

### 4. Representation: full final state vs. token table

- **Complete rewrites** (entire bullet/paragraph replaced) → **full final state** in a
  code block. Diff would be 100% changed lines — pure noise.
- **Surgical edits** (token swaps within unchanged text) → **token table** with
  find/replace pairs + find commands. Diff-like, but parameterized.

A single decision file may use both: token table for L1 (mechanical swaps), full final
state for L2 (prose relabeling).

### 5. L1 (templates): find commands, not hardcoded file lists

Use `rg -l` (or `grep -rl` fallback) to discover target files at apply time. Don't
hardcode a file list — it goes stale when templates are added or removed. The find
pattern is also the safety gate: e.g. `rg -l "feature: prd-{slug}"` returns exactly the
downstream templates and excludes the root template (which has `id:`, not `feature:`).

The agent chooses the tool (sed, Edit, or a mix) — the file specifies *what* to replace,
not *how*.

### 6. L2 (reference docs): summary with "does not change" line

The L2 section starts with a summary describing what changes and **what does not change**.
The "does not change" line bounds the agent's edit scope and catches edge cases where a
blanket sed would over-edit (e.g. generic "PRD" mentions in other artifact definitions
that use the term as an industry word, not as the default type name).

### 7. §Verify replaces `.rej` checking

Every decision file ends with a Verify section containing grep assertions with expected
counts. This replaces the old `patch --dry-run` + `.rej` file checking. Assertions
include:
- "Should be gone" checks (residual old tokens → 0 hits)
- "Should be present" checks (new tokens → expected count)
- Edge-case checks (generic mentions that should NOT have changed → still present)

### 8. No `patch` or `yq`

Decision files use the agent's native file-edit tools (Edit, Read). No `patch -p1`, no
`--fuzz`, no `.rej`/`.orig` cleanup, no separate `yq` step for `manifest.yaml`. One
mechanism for all files.

---

## Illustrative diffs

When a decision file includes an illustrative ` ```diff ` block (e.g. to show the shape
of an L1 token swap), the warning "illustrative, not load-bearing" lives next to that
diff. The token table and find commands are the source of truth — the diff is a visual
aid, not something to hunt for exact lines.

---

## Adding a new decision axis

1. Create `decisions/<axis>.md` following the structure above.
2. Add a row to `decisions/README.md`'s "Available decisions" table.
3. If the decision axis replaces an existing `patches/` mechanism, update all files that
   reference the old mechanism (see `handbook/customization.md` and
   `handbook/playbooks/customize-artifacts.md`).

## Adding a new alternative to an existing axis

1. Add a row to the axis file's Alternatives table.
2. Add a per-alternative section with full final state for every changed file.
3. Update the "does not change" line in the L2 summary if the new alternative introduces
   new edge cases.
