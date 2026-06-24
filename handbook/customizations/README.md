# Customizations Index

Customization switches for the vault. Each file lists all alternatives for one
customization axis side-by-side — pick an alternative, and the agent applies it.

For the step-by-step apply flow, see `../playbooks/customize-vault.md`.
For the mechanism (how applying works, upgrade flow, combining customizations), see
`../customization.md`.
For the format conventions that govern customization files, see [`FORMAT.md`](./FORMAT.md).

## Available customizations

| File | Customization axis | Alternatives |
|---|---|---|
| [`requirements-root.md`](./requirements-root.md) | Requirements-root type | `prd`, `feature-brief`, `press-release` |
| [`artifact-id-dating.md`](./artifact-id-dating.md) | Artifact ID dating policy | `none`, `snapshot-style`, `all` |
| [`folder-structure.md`](./folder-structure.md) | Folder-structure layout | `flat`, `phase`, `product-technical-delivery`, `lifespan` |

## Notes

- Customization axes are **orthogonal** — they touch disjoint files and can be applied in any
  order.
- Alternatives within an axis are **peers**, not inverses. Switching from one to another
  is always "apply a different alternative's section in the same file" — there is no
  "revert" operation.
