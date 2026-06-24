# AGENTS.md Improvements Report

This document outlines the recent restructuring of the `AGENTS.md` file and proposes further improvements to enhance the human-agent collaboration workflow.

## 1. Summary of Recent Changes

The `AGENTS.md` file was restructured to focus on token efficiency, clear communication, and defined operating modes:

1. **Token Efficiency: Reading & Editing**: Consolidated the old "Reading Discipline" and "Editing & Prompt Discipline" sections into one focused on optimizing token usage and efficient document updates.
2. **Optimize Communication**: Added explicit rules to prevent "black-box" thinking. The agent must now surface key reasoning, propose best practices instead of silently complying, and show rejected alternatives. This section also references `handbook/customizations/ask-threshold.md` for the clarification threshold.
3. **Operating Modes**: Introduced two distinct modes:
    *   **Interactive Mode**: The agent works interactively to clarify intent. If research yields **more than 3 valuable questions or findings**, the agent must pause, summarize them, and report back to the user before continuing.
    *   **Autonomous Mode**: Once requirements are clear, the agent automatically performs tasks without asking, stopping only when done or if a fatal flaw (e.g., security risk) is encountered.
4. **Output Style**: Refined the guidelines to emphasize short, concise responses that provide necessary alignment verification without unnecessary preamble.

---

## 2. Suggested Future Improvements

To make this human-agent collaboration even more robust, consider adding the following guidelines to `AGENTS.md` or related handbook files:

### A. Standardized "Interactive Pause" Format
Establish a strict template for the agent to use when hitting the ">3 findings/questions" threshold in Interactive mode.
**Draft Rule:**
> *When pausing in Interactive Mode, use this exact format:*
> * `**Key Findings:**` (Brief bullet points of what was discovered)*
> * `**Clarifications Needed:**` (The 3+ questions)*
> * `**Proposed Next Steps:**` (What the agent will do once unblocked)*

### B. State/Mode Signaling
Instruct agents to explicitly prefix their messages so the user knows exactly which mode they are operating in at any given time.
**Draft Rule:**
> *Always start your responses with `[Interactive]` or `[Autonomous]` to indicate your current operating state.*
> * **Default Mode:** You must default to `[Interactive]` mode.*
> * **Switching to Autonomous:** Even if the user explicitly requests autonomous mode, you must explicitly ask the user for confirmation to switch to this mode. You should also state your understanding of the task if it helps ensure alignment before making the switch.*

### C. Graceful Failure & Escalation Protocol
Since Autonomous Mode runs until everything is resolved or a "fatal flaw" is hit, document exactly what the agent should do when a failure occurs.
**Draft Rule:**
> *If a fatal flaw or blocker is hit in Autonomous Mode, immediately switch to Interactive Mode. If you are currently working on a specific task artifact (`tasks/task-*`), update its status to `blocked`. Otherwise, report the exact error trace directly to the standard conversational output. Only write the error report to a file if the user explicitly requested it.*

### D. Context Checkpoints for Token Efficiency
If a session runs too long, the agent might start losing context or wasting tokens. Add a rule for managing long sessions.
**Draft Rule:**
> *If the context gets too long or a task spans multiple complex steps, generate a `session-summary.md` containing the current state, and prompt the user to start a new chat session using that summary.*