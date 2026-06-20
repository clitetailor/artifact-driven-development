# Customize Artifact Decisions

> Reference this file in your AI chat to switch the default artifact types or ask-threshold policy.
> The agent will walk you through selecting and applying a decision file.

---

## For The Agent

The user has referenced this file. Follow the steps below in order.

**Important:**
- Ask one question at a time using your question/prompt tool
- Wait for the user's answer before proceeding to the next question
- The confirmation gates (Steps 1, 4) are Yes/Cancel choices; render them as a picker if your tool supports it
- For conceptual background (what each decision touches, upgrade flow, layer analysis), read `../customization.md` — do not duplicate that content here
- For the format conventions that govern decision files, read `../decisions/FORMAT.md`

Skip any question the user has already answered in their opening message.

---

## Step 1 — Identify the Decision

Agent: Which decision do you want to switch?

1. **Requirements-root type** — alternatives: `feature-brief`, `press-release` (default: `prd`) — see `../decisions/requirements-root.md`
2. **Ask-threshold policy** — alternatives: `approach-changing-only`, `read-then-confirm` (default: always-ask-first) — see `../decisions/ask-threshold.md`

If the user names a target directly (e.g. "switch to press-release"), skip to Step 2 with that choice.

---

## Step 2 — Confirm the Decision

Agent: I will apply the `{choice}` alternative from `decisions/{axis}.md`. This will rewrite templates, reference docs, and (for artifact-type switches) the `manifest.yaml` default. Already-created artifacts are not touched — they are migrated on demand. Continue? (Yes / Cancel)

If user selects **Cancel**: Exit. No changes made.

If user selects **Yes**: Proceed to Step 3.

---

## Step 3 — Apply the Decision File

Open the decision file (`decisions/{axis}.md`) and follow its **Apply** section. The general flow:

1. **Read the current state** — for requirements-root, read `manifest.yaml`'s `feature_type:` field to identify the current default. For ask-threshold, read `AGENTS.md`'s `## Communication` first bullet lead-in.
2. **If the chosen alternative is already the current state**, skip to Step 4.
3. **L1 (templates):** Run the decision file's find commands to discover target files. Apply the token map to each file returned, replacing the current default's tokens with the chosen alternative's tokens. Use your native file-edit tools.
4. **L2 (reference docs & handbook):** Apply the chosen alternative's per-alternative section. Match by prose meaning, not exact line numbers — surrounding text may have drifted.
5. **`manifest.yaml`:** Edit the `feature_type:` line directly.
6. **Run the decision file's §Verify block** — execute each grep assertion and confirm the expected counts. If any check fails, re-apply the missed edit to that file.

For **ask-threshold switches**, only `AGENTS.md` is touched — skip L1 and `manifest.yaml`.

---

## Step 4 — Verify and Report

Agent: I have applied the decision. Here is a summary of what changed:

[List the files modified, grouped by layer: templates, reference docs, manifest.yaml, AGENTS.md]

To switch to a different alternative later, apply that alternative's section from the same decision file — alternatives are peers, not inverses, so there is no "revert" step.

Is there anything else you want to customize? (Yes / Cancel)

If user selects **Yes**: Return to Step 1.

If user selects **Cancel**: Done.

---

## Notes

- Requirements-root and ask-threshold decisions are orthogonal — they touch disjoint files and can be applied in either order.
- Ask-threshold decisions touch only `AGENTS.md` (Communication + Output Style bullets), not templates or reference docs.
- For the full list of available decision files, see `../decisions/README.md`.
- For upgrade-flow implications (re-applying decisions after pulling upstream), see `../customization.md` → "Upgrade Flow".
