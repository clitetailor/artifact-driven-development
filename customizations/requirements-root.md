# Customization: requirements-root type

> Switches the active requirements-root type in `manifest.yaml`. Pick one alternative
> below; the agent applies that value. Switching to a different alternative later = apply
> a different alternative's value.
>
> For the apply flow, see `../handbook/playbooks/customize-artifacts.md`.

---

## What changes

The `feature_type:` field in `manifest.yaml` names the active requirements-root type for
this vault. All templates and reference docs are **already option-agnostic** — they use
the generic `{feature-id}` / `{feature-link}` placeholders and resolve the active type
from this field at fill/read time. No template or reference-doc edits are needed.

This is a **manifest-only edit** — a single line change. The dependency graph, agent
ownership, lifecycle, folder structure, and frontmatter fields are unchanged. Only which
type is active moves.

**Framework shipped default:** `prd`. The reference docs depict `prd` as the example type
and note that the active type is in `manifest.yaml` — they do not change when you switch.

---

## Alternatives

| Alternative | Role | Prefix | Folder | Display name |
|---|---|---|---|---|
| `prd` | Default | `prd-` | `prds/` | PRD |
| `feature-brief` | Alternative | `fb-` | `feature-briefs/` | Feature Brief |
| `press-release` | Alternative | `pr-` | `press-releases/` | Press Release |

"Default" = the framework's shipped starting option (a static fact). The current active
type is whatever `manifest.yaml`'s `feature_type:` says right now.

---

## Per-alternative manifest values

Each alternative is realized by a single `manifest.yaml` edit — replacing the
`feature_type:` value. The values below are the full final state of that line for each
alternative.

### `prd`

```
feature_type: prd
```

### `feature-brief`

```
feature_type: feature-brief
```

### `press-release`

```
feature_type: press-release
```

---

## Apply

1. **Read `manifest.yaml`** — check the current `feature_type:` value. If it already
   matches the chosen alternative, skip to Verify.

2. **`manifest.yaml`:** Replace the `feature_type:` value with the chosen alternative's
   value from its per-alternative section above. This is the only edit needed — templates
   use `{feature-id}` / `{feature-link}` placeholders and reference docs are
   option-agnostic, so both resolve the active type from the manifest at fill/read time.

3. **Run Verify** (below) to confirm.

---

## Verify

```bash
# The chosen alternative is now active
rg "^feature_type: {new_type}" manifest.yaml
# Expected: 1 match — visually confirm the value matches the chosen alternative.

# Templates use the generic placeholder (option-agnostic — should be present regardless)
rg -l "\{feature-id\}" templates/                            # expect: 10 downstream templates
rg -l "\{feature-link\}" templates/                          # expect: 7 templates with References sections

# No template still uses a type-specific requirements-root placeholder
rg -l "\{(prd|fb|pr)-(id|link)\}" templates/                 # expect: 0 files
```

If the `feature_type:` check fails, re-edit the line. If the placeholder checks fail, a
template was missed during the option-agnostic migration — replace any residual
`{prd-id}`/`{prd-link}` (or `{fb-*}`/`{pr-*}`) with `{feature-id}`/`{feature-link}`.

---

## Notes

- **Option-agnostic design:** Templates use `{feature-id}` / `{feature-link}` (generic
  placeholders that resolve to the active type's concrete ID at fill time). Reference docs
  describe the requirements root generically and point to `manifest.yaml`'s
  `feature_type:` as the source of truth. Neither changes when you switch alternatives —
  only the manifest field moves. See `artifact-id-dating.md` → "Template placeholder
  reference" for the full placeholder system.

- **Orthogonality with `artifact-id-dating.md`:** Both are manifest-driven — they touch
  disjoint manifest fields (`feature_type:` vs. `dated_types:`) and disjoint aspects of
  the ID (type prefix vs. date prefix). Apply in any order.

- **Orthogonality with `ask-threshold.md`:** No interaction — different files entirely.

- **Already-created artifacts** (in `prds/`, `feature-briefs/`, etc.) are **not touched** —
  only the manifest field changes. Migrate existing artifacts on demand by renaming files
  and updating their `id:`/`type:`/`feature:` fields.

- The alternatives are **peers**, not inverses. Switching from one to another is always
  "apply a different alternative's value" — there is no "revert" operation.
