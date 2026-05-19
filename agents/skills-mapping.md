# Skills Mapping
> Composable skill registry — update this file as skills are integrated

## Registered Skills

| Skill | Source | Status | Applied to |
|---|---|---|---|
| brainstorming | TBD | deferred | ideation phases |
| tdd | TBD | deferred | test-driven implementation |
| impeccable | pbakaus/impeccable | deferred | output quality pass |

## Integration Notes

When a skill is integrated:
1. Update the `Status` column to `active`
2. Add the install path or plugin reference to `Source`
3. Update each relevant SKILL.md `## Skill Composition` section if behavior changes
4. Skills apply within each agent's scope boundary — they do not expand artifact ownership

## Tooling Note

- `.claude/skills/` remains the source set for the existing Claude-oriented SDLC skills in this repo.
- `.codex/skills/` contains Codex-compatible conversions of the same SDLC skills for local Codex use.
- Keep the paired Claude and Codex skill definitions aligned when behavior, scope boundaries, or routing rules change.
- Treat the Codex copies as compatibility mirrors, not independent forks, unless the repo explicitly decides to diverge them.
