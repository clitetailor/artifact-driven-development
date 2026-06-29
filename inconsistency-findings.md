# Inconsistency Findings — `reference/artifact-dep-graph.md`

> Findings from a review of the Read-Write Cycle (State/Delta) section against the
> Dependencies graph and the creation-order table in
> `reference/artifact-dep-graph.md`. Scope is limited to internal inconsistencies
> within that file; no changes have been applied.

---

## Summary

The Dependencies graph and creation-order table (lines 136–188) are mutually
consistent and treated as the authoritative view. The inconsistencies live in the
Read-Write Cycle section (lines 43–123), which omits or mis-attributes edges that
the rest of the file asserts.

| # | Location | Issue | Severity |
|---|---|---|---|
| 1 | Lines 64, 121, 109 (graph) | Contradictory claims about whether `feature-brief`/`prd` merges back to `domain-record` | High |
| 2 | Line 98 (graph) | `test-plan` omitted between `user-story` and `test-spec` | Medium |
| 3 | Lines 87–88 vs table line 177 | `user-story → user-flow/design-spec` vs `prd → user-flow` attribution conflict | Medium |
| 4 | Lines 94–99 (Execution subgraph) | `api-spec → test-plan` edge missing (present in Dependencies graph line 166) | Low |

---

## Finding 1 — `feature-brief`/`prd` merge-back to `domain-record` is contradictory

Three statements in the file cannot all be true:

- **Line 64 (prose):** "The requirements delta in `feature-brief` / `user-story`
  **also merges back to the domain-record**."
- **Line 121 (prose):** "`requirements-root` and `task` are **retired**; `user-story`
  and `tech-design` merge back to the State artifacts they targeted..."
- **Line 109 (graph):** Only `STORYX -.absorbs rules.-> DRX` — no
  `feature-brief → domain-record` edge.

Line 64 says the requirements-root merges back; line 121 says it is retired (not
merged); the graph shows only `user-story` as the merge carrier.

**Resolution needed:** Pick one. Either (a) the requirements-root merges back and
line 121 + the graph are wrong, or (b) only `user-story` merges back and line 64 is
wrong. The Bridge Rule framing (line 61) and the phase-4 graph (lines 100–115)
suggest (b) is the intended model — line 64 is the outlier.

---

## Finding 2 — `test-plan` omitted from the Read-Write Cycle Execution subgraph

Line 98 shows:

```
STORY -.QA translates.-> TS
```

But the Dependencies graph (line 160) and the creation-order table (line 187) both
assert the chain `user-story → test-plan → test-spec`, with `test-plan` as the
explicit intermediate (`test-plan`'s prerequisite is `user-story, api-spec`;
`test-spec`'s prerequisite is `test-plan`).

The Read-Write Cycle collapses the chain and skips `test-plan`. The `test-plan`
template (`templates/test-plan.md` line 41) confirms it is the bridge that "carries
test cases, edge cases, and error cases into `test-spec`."

**Resolution:** Restore `test-plan` as an intermediate node in the Execution
subgraph: `STORY --> TP --> TS`.

---

## Finding 3 — `user-flow` / `design-spec` attribution conflict

- **Read-Write Cycle lines 87–88:** `STORY -.targets UI.-> UF` and
  `STORY -.targets UI.-> DS` — attributes UI artifacts to `user-story`.
- **Creation-order table line 177:** "user-flow | prd" — attributes `user-flow`'s
  creation prerequisite to the requirements root, not the story.

These attribute the same edge to different sources. The Dependencies graph (lines
144–145) shows `UF[user-flow] --> DS[design-spec]` inside the Design discipline with
no incoming edge from either `story` or `prd` drawn explicitly, leaving it
ambiguous.

**Resolution needed:** Decide whether `user-flow` is created from the requirements
root (table's view) or from the user-story (Read-Write Cycle's view). The
`prd.md` template's "Pipeline Next Steps" (line 86: "product-designer → user-flow
(from this root)") supports the table's view — the requirements root, not the
story, is the source. If so, the Read-Write Cycle's `STORY -.targets UI.-> UF/DS`
edges should be re-sourced to the requirements root.

---

## Finding 4 — `api-spec → test-plan` edge missing from Execution subgraph

The Dependencies graph (line 166) shows `API --> TP`. The creation-order table
(line 186) confirms: "test-plan | user-story, api-spec". The `test-plan` template
frontmatter (lines 9–10) lists both `story-id` and `api-id` in `refs`.

The Read-Write Cycle's Execution subgraph (lines 94–99) shows neither `api-spec`
nor `test-plan` feeding `test-spec`'s creation — only `STORY -.QA translates.-> TS`.

**Resolution:** Add `API --> TP` (and the restored `TP --> TS` from Finding 2) to
the Execution subgraph.

---

## Notes

- Findings 2 and 4 are straightforward omissions with clear fixes.
- Findings 1 and 3 are genuine semantic conflicts that require a design decision
  before editing; they cannot be resolved by mechanical correction.
- The Dependencies graph and creation-order table (lines 136–188) are internally
  consistent and were used as the reference for resolving the omissions.
