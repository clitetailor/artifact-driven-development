# Decisions Index

Customization decisions for the vault. Each file lists all alternatives for one decision
axis side-by-side — pick a column, and the agent applies it.

For the step-by-step apply flow, see `../handbook/playbooks/customize-artifacts.md`.
For the mechanism (how applying works, upgrade flow, combining decisions), see
`../handbook/customization.md`.

## Available decisions

| File | Decision axis | Alternatives | Status |
|---|---|---|---|
| [`requirements-root.md`](./requirements-root.md) | Requirements-root type | `prd`, `feature-brief`, `press-release` (implemented); `pitch`, `one-pager` (not yet implemented) | ✅ Drafted |
| [`ask-threshold.md`](./ask-threshold.md) | Ask-threshold policy | `always-ask-first`, `approach-changing-only`, `read-then-confirm` | ✅ Drafted |
| `plan-type.md` | Plan type | `plan`, `work-breakdown-structure`, `implementation-plan` | ❌ Not yet migrated from patches |

## Working documents

| File | Purpose |
|---|---|
| [`_design-notes.md`](_design-notes.md) | Design notes and resolution log for the patches-to-decisions migration |

## Notes

- `decisions/feature-brief.md` is an earlier per-alternative prototype, now superseded by
  [`requirements-root.md`](./requirements-root.md). It is kept as a reference for the
  design process.
- Decision axes are **orthogonal** — they touch disjoint files and can be applied in any
  order.
- Alternatives within an axis are **peers**, not inverses. Switching from one to another
  is always "apply a different column in the same file" — there is no "revert" operation.
