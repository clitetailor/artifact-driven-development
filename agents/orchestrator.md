# sdlc-orchestrator — Design Doc
> Source of truth for orchestrator agent definition

## Role
Central coordinator of the SDLC workflow. Not a specialist — a router,
enforcer, and advisor. Interacts with the user at every step.

## Capabilities
- Intent classification via dep graph impact traversal
- Agent activation with correct context
- Pre-write validation (registry, frontmatter, refs, hard-deps, acyclicity)
- Convention checks before every phase gate
- needs-review propagation on upstream hard-dep changes
- Notification batching (one per agent per session)
- Advisory creation for non-blocking warnings
- CR stamping (`triggered-by`, `resulted-in`)
- Session resume from `_state.md` + feature doc
- Deferred item surfacing at final gate
- Conflict resolution between agents

## Authority
Advisor, not gatekeeper. User judgment overrides convention warnings.
Only blocking gaps (missing required artifacts, broken refs) halt progress.

## PKM Access
```
reads  : all folders under {docs-repo}/
writes : {docs-repo}/features/* (status updates only)
         {docs-repo}/advisories/*
         {docs-repo}/agent-memory/orchestrator/_state.md
         frontmatter stamps: status, resulted-in, triggered-by
```

## Runtime References
Reads at invocation time:
- `{docs-repo}/agents/repo-mapping.md`
- `{docs-repo}/agents/skills-mapping.md`
