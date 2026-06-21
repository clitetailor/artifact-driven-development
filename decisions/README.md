# Decisions Index

Customization decisions for the vault. Each file lists all alternatives for one decision
axis side-by-side — pick an alternative, and the agent applies it.

For the step-by-step apply flow, see `../handbook/playbooks/customize-artifacts.md`.
For the mechanism (how applying works, upgrade flow, combining decisions), see
`../handbook/customization.md`.
For the format conventions that govern decision files, see [`FORMAT.md`](./FORMAT.md).

## Available decisions

| File | Decision axis | Alternatives | Status |
|---|---|---|---|
| [`requirements-root.md`](./requirements-root.md) | Requirements-root type | `prd`, `feature-brief`, `press-release` | ✅ Drafted |
| [`ask-threshold.md`](./ask-threshold.md) | Ask-threshold policy | `always-ask-first`, `approach-changing-only`, `read-then-confirm` | ✅ Drafted |
| [`artifact-id-dating.md`](./artifact-id-dating.md) | Artifact ID dating policy | `none`, `snapshot-style`, `all` | ✅ Drafted |

## Notes

- Decision axes are **orthogonal** — they touch disjoint files and can be applied in any
  order.
- Alternatives within an axis are **peers**, not inverses. Switching from one to another
  is always "apply a different alternative's section in the same file" — there is no
  "revert" operation.
