# Customize Artifact Decisions

> Reference this file in your AI chat to switch the default artifact types or ask-threshold policy.
> The agent will walk you through selecting and applying a switch-patch.

---

## For The Agent

The user has referenced this file. Follow the steps below in order.

**Important:**
- Ask one question at a time using your question/prompt tool
- Wait for the user's answer before proceeding to the next question
- The confirmation gates (Steps 1, 4) are Yes/Cancel choices; render them as a picker if your tool supports it
- For conceptual background (what each patch touches, upgrade flow, layer analysis), read `../customization.md` — do not duplicate that content here

Skip any question the user has already answered in their opening message.

---

## Step 1 — Identify the Decision

Agent: Which decision do you want to switch?

1. **Requirements-root type** — alternatives: `feature-brief`, `pitch`, `one-pager`, `press-release` (default: `prd`)
2. **Plan type** — alternatives: `work-breakdown-structure`, `implementation-plan` (default: `plan`)
3. **Ask-threshold policy** — alternatives: `approach-changing-only`, `read-then-confirm` (default: always ask first)

If the user names a target directly (e.g. "switch to pitch"), skip to Step 2 with that choice.

---

## Step 2 — Confirm the Patch

Agent: I will apply `patches/switch-to-{choice}.patch`. This will rewrite templates, reference docs, and (for artifact-type switches) the `manifest.yaml` default. Already-created artifacts are not touched — they are migrated on demand. Continue? (Yes / Cancel)

If user selects **Cancel**: Exit. No changes made.

If user selects **Yes**: Proceed to Step 3.

---

## Step 3 — Check and Apply

First, verify the patch will apply cleanly:

```bash
git apply --check patches/switch-to-{choice}.patch
```

- If `--check` passes: apply with `git apply --3way patches/switch-to-{choice}.patch`
- If `--check` fails: apply with `--3way` directly — it falls back to a 3-way merge using embedded blob IDs and handles context drift from upstream upgrades. If `--3way` also fails on a specific file, report the conflict to the user and ask whether to resolve manually or abort.

For **artifact-type switches only** (requirements-root or plan), also update `manifest.yaml`:

```bash
yq -i '.feature_type = "{choice}"' manifest.yaml   # for requirements-root
yq -i '.plan_type = "{choice}"' manifest.yaml       # for plan
```

For **ask-threshold switches**, skip the `yq` step — `manifest.yaml` is not involved.

---

## Step 4 — Verify and Report

Agent: I have applied the switch-patch. Here is a summary of what changed:

[List the files modified, grouped by layer: templates, reference docs, manifest.yaml, AGENTS.md]

To revert this decision later: `git apply -R patches/switch-to-{choice}.patch` restores the default. To switch to a different alternative, revert first, then apply the new patch.

Is there anything else you want to customize? (Yes / Cancel)

If user selects **Yes**: Return to Step 1.

If user selects **Cancel**: Done.

---

## Notes

- Requirements-root and plan switches are orthogonal — they touch disjoint lines and can be applied in either order.
- Ask-threshold patches touch only `AGENTS.md` (Communication + Output Style bullets), not templates or reference docs.
- For the full list of available patches, see `../customization.md` → "Available Switch-Patches" and "Ask-Threshold Switch-Patches" tables.
- For upgrade-flow implications (re-applying patches after pulling upstream), see `../customization.md` → "Upgrade Flow".
