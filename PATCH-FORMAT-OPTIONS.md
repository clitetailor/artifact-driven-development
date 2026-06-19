# Patch Format Options

> The current switch-patches use unified diff format (`git diff`), which relies on line numbers and context lines. This is error-prone when the base files drift. Since every change in the patches is a find-and-replace operation (not structural line insertion/deletion), there are formats that don't rely on line numbers at all.

## Why line numbers are the problem

A unified diff hunk looks like this:

```diff
@@ -25,7 +25,7 @@
     path: ../analytics
 
-feature_type: prd                   # default requirements-root type
+feature_type: feature-brief         # default requirements-root type
 plan_type: plan                     # default plan type
```

The `@@ -25,7 +25,7 @@` says "line 25, 7 lines of context." If someone adds a line above line 25 in a future upgrade, the hunk fails even though the actual change (`prd` → `feature-brief`) is still valid. You then have to regenerate the entire patch — re-apply changes, diff, restore — which is the error-prone workflow we hit during generation.

## The key insight

Every change in all 6 switch-patches is a **find-and-replace** operation:

- `prd` → `feature-brief` (type name)
- `prd-{slug}` → `fb-{slug}` (ID pattern)
- `../prds/` → `../feature-briefs/` (folder path)
- `PRD` → `Feature Brief` (display name)
- vocabulary entry reframe (one string → another string)

There are zero structural changes (no "insert 3 lines after line 42" or "delete lines 10-15"). This means a substitution-based format expresses everything, without line numbers.

---

## Option 1 — `sed` script (`.sh`)

A shell script with sed commands. No line numbers, pure pattern matching.

### Example: `patches/switch-to-feature-brief.sh`

```bash
#!/bin/bash
# Switch requirements-root from prd to feature-brief
# Apply from vault root: bash patches/switch-to-feature-brief.sh
# Then update manifest: yq -i '.feature_type = "feature-brief"' manifest.yaml

set -e

# manifest.yaml
sed -i 's/^feature_type: prd.*/feature_type: feature-brief         # default requirements-root type/' manifest.yaml

# reference/artifact-dep-graph.md
sed -i 's/| project-manager, business-analyst | prd, user-story |/| project-manager, business-analyst | feature-brief, user-story |/' reference/artifact-dep-graph.md
sed -i 's/ROOT\["prd"\]/ROOT["feature-brief"]/' reference/artifact-dep-graph.md
sed -i 's/^| prd | — |/| feature-brief | — |/' reference/artifact-dep-graph.md
sed -i 's/^| user-story | prd |/| user-story | feature-brief |/' reference/artifact-dep-graph.md
sed -i 's/^| user-flow | prd |/| user-flow | feature-brief |/' reference/artifact-dep-graph.md
sed -i 's/^| system-architecture | prd |/| system-architecture | feature-brief |/' reference/artifact-dep-graph.md
sed -i 's/^| tech-design | system-architecture, prd |/| tech-design | system-architecture, feature-brief |/' reference/artifact-dep-graph.md

# reference/artifact-vocabulary.md — swap default/alternative framing
sed -i 's/| \*\*prd\*\* | Product Requirements Document — the default requirements-root artifact\./| **prd** | Product Requirements Document — a requirements-root alternative to feature-brief./' reference/artifact-vocabulary.md
sed -i 's/| \*\*feature-brief\*\* | Feature Brief — a lighter requirements-root alternative to prd\./| **feature-brief** | Feature Brief — The default requirements-root artifact./' reference/artifact-vocabulary.md

# reference/artifact-frontmatter.md
sed -i "s/the feature's PRD (\`prd-\`)/the feature's Feature Brief (\`fb-\`)/" reference/artifact-frontmatter.md

# reference/folder-structure.md — swap default/alternative labels
sed -i 's|├── prds/.*default requirements-root|├── prds/                   # Product Requirements Documents (prd-) — requirements-root alternative|' reference/folder-structure.md
sed -i 's|├── feature-briefs/.*requirements-root alternative|├── feature-briefs/         # Feature Briefs (fb-) — default requirements-root|' reference/folder-structure.md

# reference/vault-queries.md
sed -i 's/PRD artifacts/Feature Brief artifacts/g' reference/vault-queries.md
sed -i 's/type: prd/type: feature-brief/' reference/vault-queries.md
sed -i 's/PRD for a feature/Feature Brief for a feature/' reference/vault-queries.md
sed -i 's/prd-user-auth/fb-user-auth/g' reference/vault-queries.md
sed -i 's/prd-user-authentication-login/fb-user-authentication-login/g' reference/vault-queries.md

# reference/coordination-decision-tree.md
sed -i 's/Add investigation notes to `prd`/Add investigation notes to `feature-brief`/' reference/coordination-decision-tree.md
sed -i 's/Derived from PRD/Derived from Feature Brief/' reference/coordination-decision-tree.md
sed -i 's/link to `prd`/link to `feature-brief`/' reference/coordination-decision-tree.md
sed -i 's/PRD (Epic level/Feature Brief (Epic level/' reference/coordination-decision-tree.md
sed -i 's/feature: prd-{slug}/feature: fb-{slug}/' reference/coordination-decision-tree.md

# PROJECT.md
sed -i 's/## PRDs/## Feature Briefs/' PROJECT.md
sed -i "s/feature's PRD/feature's Feature Brief/g" PROJECT.md
sed -i 's/default requirements-root type is prd/default requirements-root type is feature-brief/' PROJECT.md
sed -i 's/| PRD | Status/| Feature Brief | Status/' PROJECT.md
sed -i 's/<!-- prd-{slug} -->/<!-- fb-{slug} -->/' PROJECT.md

# handbook/setup.md
sed -i 's/Default is `prd`/Default is `feature-brief`/' handbook/setup.md

# 12 downstream templates — bulk token replacement
for f in templates/user-story.md templates/user-flow.md templates/test-spec.md \
         templates/task.md templates/system-architecture.md templates/tech-design.md \
         templates/design-spec.md templates/data-design.md templates/api-spec.md \
         templates/plan.md templates/work-breakdown-structure.md templates/implementation-plan.md; do
  sed -i 's/prd-{slug}/fb-{slug}/g' "$f"
  sed -i 's|\.\./prds/|../feature-briefs/|g' "$f"
done

# tech-design.md special
sed -i 's/defined in the PRD/defined in the Feature Brief/' templates/tech-design.md
```

### Pros
- Simplest to write and understand
- No line numbers — survives line drift
- No tooling needed beyond `sed` (available everywhere)
- Easy to update: change one sed command if a string changed upstream

### Cons
- **Silently misses** if the search string was reworded upstream (sed exits 0 even if no match)
- No built-in verification that all substitutions were applied
- Shell quoting can be tricky (backticks, single quotes, em-dashes)

---

## Option 2 — Substitution manifest (YAML) + apply script

A YAML file declaring `find`/`replace` pairs per file group, plus a small apply script that runs the substitutions and **verifies** each one matched.

### Example: `patches/switch-to-feature-brief.yaml`

```yaml
name: switch-to-feature-brief
description: Switch requirements-root from prd to feature-brief
manifest_update:
  feature_type: feature-brief

substitutions:
  # --- manifest.yaml ---
  - files: [manifest.yaml]
    find: 'feature_type: prd'
    replace: 'feature_type: feature-brief         # default requirements-root type'

  # --- reference/artifact-dep-graph.md ---
  - files: [reference/artifact-dep-graph.md]
    find: '| project-manager, business-analyst | prd, user-story |'
    replace: '| project-manager, business-analyst | feature-brief, user-story |'
  - files: [reference/artifact-dep-graph.md]
    find: 'ROOT["prd"]'
    replace: 'ROOT["feature-brief"]'
  - files: [reference/artifact-dep-graph.md]
    find: '| prd | — |'
    replace: '| feature-brief | — |'
  - files: [reference/artifact-dep-graph.md]
    find: '| user-story | prd |'
    replace: '| user-story | feature-brief |'
  - files: [reference/artifact-dep-graph.md]
    find: '| user-flow | prd |'
    replace: '| user-flow | feature-brief |'
  - files: [reference/artifact-dep-graph.md]
    find: '| system-architecture | prd |'
    replace: '| system-architecture | feature-brief |'
  - files: [reference/artifact-dep-graph.md]
    find: '| tech-design | system-architecture, prd |'
    replace: '| tech-design | system-architecture, feature-brief |'

  # --- reference/artifact-vocabulary.md (swap default/alternative) ---
  - files: [reference/artifact-vocabulary.md]
    find: '**prd** | Product Requirements Document — the default requirements-root artifact.'
    replace: '**prd** | Product Requirements Document — a requirements-root alternative to feature-brief.'
  - files: [reference/artifact-vocabulary.md]
    find: '**feature-brief** | Feature Brief — a lighter requirements-root alternative to prd.'
    replace: '**feature-brief** | Feature Brief — The default requirements-root artifact.'

  # --- reference/artifact-frontmatter.md ---
  - files: [reference/artifact-frontmatter.md]
    find: "the feature's PRD (`prd-`)"
    replace: "the feature's Feature Brief (`fb-`)"

  # --- reference/folder-structure.md (swap labels) ---
  - files: [reference/folder-structure.md]
    find: 'prds/                   # Product Requirements Documents (prd-) — default requirements-root'
    replace: 'prds/                   # Product Requirements Documents (prd-) — requirements-root alternative'
  - files: [reference/folder-structure.md]
    find: 'feature-briefs/         # Feature Briefs (fb-) — requirements-root alternative'
    replace: 'feature-briefs/         # Feature Briefs (fb-) — default requirements-root'

  # --- reference/vault-queries.md ---
  - files: [reference/vault-queries.md]
    find: 'PRD artifacts'
    replace: 'Feature Brief artifacts'
    global: true
  - files: [reference/vault-queries.md]
    find: 'type: prd'
    replace: 'type: feature-brief'
  - files: [reference/vault-queries.md]
    find: 'PRD for a feature'
    replace: 'Feature Brief for a feature'
  - files: [reference/vault-queries.md]
    find: 'prd-user-auth'
    replace: 'fb-user-auth'
    global: true
  - files: [reference/vault-queries.md]
    find: 'prd-user-authentication-login'
    replace: 'fb-user-authentication-login'

  # --- reference/coordination-decision-tree.md ---
  - files: [reference/coordination-decision-tree.md]
    find: 'Add investigation notes to `prd`'
    replace: 'Add investigation notes to `feature-brief`'
  - files: [reference/coordination-decision-tree.md]
    find: 'Derived from PRD'
    replace: 'Derived from Feature Brief'
  - files: [reference/coordination-decision-tree.md]
    find: 'link to `prd`'
    replace: 'link to `feature-brief`'
  - files: [reference/coordination-decision-tree.md]
    find: 'PRD (Epic level'
    replace: 'Feature Brief (Epic level'
  - files: [reference/coordination-decision-tree.md]
    find: 'feature: prd-{slug}'
    replace: 'feature: fb-{slug}'

  # --- PROJECT.md ---
  - files: [PROJECT.md]
    find: '## PRDs'
    replace: '## Feature Briefs'
  - files: [PROJECT.md]
    find: "feature's PRD"
    replace: "feature's Feature Brief"
    global: true
  - files: [PROJECT.md]
    find: 'default requirements-root type is prd'
    replace: 'default requirements-root type is feature-brief'
  - files: [PROJECT.md]
    find: '| PRD | Status'
    replace: '| Feature Brief | Status'
  - files: [PROJECT.md]
    find: '<!-- prd-{slug} -->'
    replace: '<!-- fb-{slug} -->'

  # --- handbook/setup.md ---
  - files: [handbook/setup.md]
    find: 'Default is `prd`'
    replace: 'Default is `feature-brief`'

  # --- 12 downstream templates (bulk) ---
  - files:
      - templates/user-story.md
      - templates/user-flow.md
      - templates/test-spec.md
      - templates/task.md
      - templates/system-architecture.md
      - templates/tech-design.md
      - templates/design-spec.md
      - templates/data-design.md
      - templates/api-spec.md
      - templates/plan.md
      - templates/work-breakdown-structure.md
      - templates/implementation-plan.md
    find: 'prd-{slug}'
    replace: 'fb-{slug}'
    global: true
  - files:
      - templates/user-story.md
      - templates/user-flow.md
      - templates/test-spec.md
      - templates/system-architecture.md
      - templates/tech-design.md
      - templates/plan.md
      - templates/work-breakdown-structure.md
      - templates/implementation-plan.md
    find: '../prds/'
    replace: '../feature-briefs/'
    global: true

  # --- tech-design.md special ---
  - files: [templates/tech-design.md]
    find: 'defined in the PRD'
    replace: 'defined in the Feature Brief'
```

### Apply script: `patches/apply-substitution.py`

```python
#!/usr/bin/env python3
"""Apply a substitution manifest (YAML) to the vault."""
import sys, yaml, pathlib

def apply_manifest(manifest_path, vault_root):
    with open(manifest_path) as f:
        manifest = yaml.safe_load(f)

    errors = []
    applied = 0

    for sub in manifest['substitutions']:
        find = sub['find']
        replace = sub['replace']
        global_replace = sub.get('global', False)
        count = sub.get('count', 1 if not global_replace else -1)

        for file_rel in sub['files']:
            file_path = pathlib.Path(vault_root) / file_rel
            content = file_path.read_text()

            if find not in content:
                errors.append(f"MISS: '{find[:60]}...' not found in {file_rel}")
                continue

            if global_replace:
                new_content = content.replace(find, replace)
            else:
                new_content = content.replace(find, replace, 1)

            file_path.write_text(new_content)
            applied += 1

    # Update manifest.yaml via yq
    if 'manifest_update' in manifest:
        for key, value in manifest['manifest_update'].items():
            print(f"  yq -i '.{key} = \"{value}\"' manifest.yaml")

    print(f"\nApplied {applied} substitutions.")
    if errors:
        print(f"\n{len(errors)} MISS(es) — search strings not found:")
        for e in errors:
            print(f"  {e}")
        sys.exit(1)
    else:
        print("All substitutions verified.")

if __name__ == '__main__':
    apply_manifest(sys.argv[1], '.')
```

### Usage

```bash
# Apply:
python3 patches/apply-substitution.py patches/switch-to-feature-brief.yaml
yq -i '.feature_type = "feature-brief"' manifest.yaml

# Dry-run (check only, no writes) — would need a --check flag added
```

### Pros
- **No line numbers** — survives line drift
- **Verification built in** — reports which search strings weren't found (catches upstream rewording)
- Readable and auditable — you can see every substitution at a glance
- Easy to update: change one `find`/`replace` pair if a string changed upstream
- The `global: true` flag handles bulk token replacement cleanly
- `manifest_update` section documents the yq command needed

### Cons
- Needs a small apply script (~30 lines of Python)
- Needs `pyyaml` installed
- Still silently passes if a substitution matches the wrong occurrence (no context anchoring) — but this is the same risk as sed

---

## Option 3 — `git apply --3way` (keep patch format, better resilience)

Keep the unified diff `.patch` files, but apply with `git apply --3way` instead of plain `git apply`.

### How it works

When context lines don't match, `--3way` falls back to a 3-way merge using the blob IDs embedded in the patch header (`index abc1234..def5678 100644`). This resolves content drift around the changed lines automatically, as long as the exact changed line itself hasn't been modified.

### Usage

```bash
git apply --3way patches/switch-to-feature-brief.patch
```

### Pros
- No format change — keep existing `.patch` files
- Better resilience than plain `git apply`
- No extra tooling

### Cons
- **Still line-based at core** — if the exact changed line was reworded, it still fails
- **Doesn't solve the maintenance problem** — regenerating a patch after base changes still requires the apply-diff-restore cycle
- The patch files are still hard to read and manually edit

---

## Comparison

| | sed script | YAML manifest | git apply --3way |
|---|---|---|---|
| Line numbers | none | none | yes (but 3way fallback) |
| Survives line drift | yes | yes | mostly |
| Survives content rewording | silently misses | **reports miss** | fails loudly |
| Verification | none | built-in | implicit (apply succeeds/fails) |
| Readability | medium | **high** | low |
| Tooling needed | sed (everywhere) | python + pyyaml | git |
| Update on base change | edit one sed command | edit one find/replace pair | regenerate entire diff |
| Expresses structural changes | no | no (but could extend) | yes |

## Recommendation

**Option 2 (YAML manifest)** is the best fit for this use case because:

1. Every patch change is a find-and-replace — the manifest format expresses this directly
2. Built-in verification catches upstream rewording (the main failure mode for sed scripts)
3. Most readable — you can audit all substitutions in one file
4. Easy to maintain — update one `find`/`replace` pair when a string changes upstream
5. The `manifest_update` field documents the yq command alongside the substitutions

The only downside (pyyaml dependency) is minimal — it's a standard Python package.

If pyyaml is a concern, **Option 1 (sed script)** is the fallback — same line-number-free approach, simpler tooling, but add a verification step (grep for the new values after applying) to catch silent misses.
