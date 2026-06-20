# ADD Setup

> Reference this file in your AI chat to configure `manifest.yaml` for your project.
> The agent will walk you through the configuration step by step.

---

## For The Agent

The user has referenced this file. Follow the steps below in order.

**Important:**
- Ask one question at a time using your question/prompt tool
- Wait for the user's answer before proceeding to the next question
- Do not ask multiple questions at once, except the Step 2 metadata form (see Step 2)
- The field questions (Steps 2–3) are free-text and optional — the user skips a field by leaving it blank
- The confirmation gates (Steps 1 and 4) are the only Yes/Cancel choices; render them as a picker if your tool supports it
- Use descriptive, detailed question text as shown in the examples below

Skip any question the user has already answered in their opening message.

All answers will be saved to `manifest.yaml`.

---

## Step 1 — Onboarding Overview

Agent: I will guide you through configuring `manifest.yaml` for your project (project metadata and repository names). Artifact types, agents, skills, and statuses will keep their defaults. Continue? (Yes / Cancel)

If user selects **Cancel**: Exit the guide. No further questions.

If user selects **Yes**: Proceed to Step 2.

---

## Step 2 — Project Metadata

Agent: **Project metadata.** Collect the three fields below. If your tool can render a multi-field form, present all three together in a single prompt; otherwise, fall back to asking them one at a time in order. Every field is optional — a field left blank is skipped.

1. Project name
2. Author — name and optionally an email (e.g., "Jane Doe <jane@example.com>")
3. Project description

After collecting these fields, proceed to Step 3.

---

## Step 3 — Repository Names

Agent: **Repository names.** These are the names and paths of your repositories used throughout the framework's reference docs and agent files.

Agent: What are your repository names? Provide a comma-separated list — use the repo name alone for sibling repos (e.g., `identity,billing,notifications`), or `name:path` for repos at a custom path (e.g., `identity:../../monorepo/services/identity`). (Optional — leave blank to keep the example repos.)

After completing this question, proceed to Step 4.

---

## Step 4 — Preview and Apply Changes

Agent: I have collected all the configuration information. Here is a preview of the changes that will be made to `manifest.yaml`:

[Preview the changes by listing each field that will be updated with its new value]

Apply these changes? (Yes / Cancel)

If user selects **Cancel**: Exit without making changes. The user can re-run this guide later.

If user selects **Yes**: Apply the changes to `manifest.yaml` using the Edit tool. Update only the fields the user provided answers for; leave all other fields unchanged.

After applying changes:

Agent: Configuration complete. `manifest.yaml` has been updated with your project settings. You can now use the vault with your configured values. If you want to switch the default requirements-root type or ask-threshold policy, you can reference `handbook/playbooks/customize-artifacts.md` in chat now (before committing) or later. Would you like me to commit these changes now?

---

## Notes

- The `types`, `agents`, `skills`, and `statuses` sections in `manifest.yaml` are kept at their default values. To **switch the default** requirements-root type or ask-threshold policy, run `handbook/playbooks/customize-artifacts.md` (applies a decision file across templates, reference docs, and manifest.yaml). To **add** a new artifact type or agent, edit `manifest.yaml` directly.
- The `seedbed` section (source and ref) is assumed to be already configured and is not covered by this guide.
- Repository names are used as placeholders in `reference/` and `agents/` files. If you change them later, you may need to re-apply placeholders manually or wait for the `orchard upgrade` CLI command (Phase 3).
