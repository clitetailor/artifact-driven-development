# Customize Artifact Decisions

> Reference this file in your AI chat to switch a customization axis (requirements-root
> type, ask-threshold policy, artifact-id-dating, or any other available axis). The agent
> will walk you through selecting and applying a customization file.

---

## For The Agent

The user has referenced this file. Follow the steps below in order.

**Important:**
- Ask one question at a time using your question/prompt tool
- Wait for the user's answer before proceeding to the next question
- The confirmation gates (Steps 1, 4) are Yes/Cancel choices; render them as a picker if your tool supports it
- For conceptual background (layers, what each axis touches, upgrade flow), read `../customization.md` — do not duplicate that content here
- For the format conventions that govern customization files, read `../customizations/FORMAT.md`
- For the catalog of available axes and their alternatives, read `../customizations/README.md`

Skip any question the user has already answered in their opening message.

---

## Step 1 — Identify the Decision

Agent: Read `../customizations/README.md` and present the available customization axes
with their alternatives. Ask: Which axis do you want to switch, and which alternative?

For each axis, list its alternatives from the axis file's Alternatives table. The current
applied state for each axis is read from `manifest.yaml` (e.g. `feature_type:` for
requirements-root, `dated_types:` for artifact-id-dating) or `AGENTS.md` (the
`## Communication` first bullet lead-in for ask-threshold).

If the user names a target directly (e.g. "switch to press-release", "use snapshot-style
dating"), skip to Step 2 with that choice.

---

## Step 2 — Confirm the Decision

Agent: I will apply the `{choice}` alternative from `handbook/customizations/{axis}.md`. This is the
`{axis}` axis — it will touch `{files listed in the axis's What changes section}`.
Already-created artifacts are not touched — they are migrated on demand. Continue?
(Yes / Cancel)

If user selects **Cancel**: Exit. No changes made.

If user selects **Yes**: Proceed to Step 3.

---

## Step 3 — Apply the customization file

Open the customization file (`handbook/customizations/{axis}.md`) and follow its **Apply** section.
The Apply section is self-contained — it lists the steps in order, naming each target
file in prose (e.g. `**manifest.yaml**:`, `**AGENTS.md**:`, `**Filesystem**:`). The first
step reads the current state; if the chosen alternative is already active, the Apply
section says to skip to Verify.

Follow the Apply section's steps in order. If a §Verify check fails, re-apply the missed
edit to that file.

---

## Step 4 — Verify and Report

Agent: I have applied the decision. Here is a summary of what changed:

[List the files modified, grouped as the axis's Apply section lists them]

To switch to a different alternative later, apply that alternative's section from the same
customization file — alternatives are peers, not inverses, so there is no "revert" step.

Is there anything else you want to customize? (Yes / Cancel)

If user selects **Yes**: Return to Step 1.

If user selects **Cancel**: Done.

---

## Notes

- Customization axes are orthogonal when they touch disjoint files. All current axes are
  pairwise orthogonal and can be applied in any order. Confirm orthogonality for a new
  axis by comparing its declared file set against existing axes' file sets.
- For the full list of available customization files, see `../customizations/README.md`.
- For what each axis touches (the layer catalog), see `../customizations/FORMAT.md` →
  "Layers" and each axis's **What changes** section.
- For upgrade-flow implications (re-applying decisions after pulling upstream), see
  `../customization.md` → "Upgrade Flow".
