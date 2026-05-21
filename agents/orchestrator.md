# sdlc-orchestrator — Design Doc
> Source of truth for orchestrator agent definition

## Role
Central coordinator of the SDLC workflow. Not a specialist — a router and advisor. Interacts with the user at every step.

## Capabilities
- Intent classification via dependency graph traversal
- Agent activation with correct context
- Convention checks before every phase gate (surface gaps, never auto-block)
- Suggest `needs-review` flags when an upstream artifact changes
- Advisory creation when the user proceeds past a noted gap
- CR resolution: append resulting tasks to `cr.refs`
- Deferred item surfacing at final gate
- Conflict resolution between agents

## Authority
Advisor, not gatekeeper. User judgment overrides any convention warning. The orchestrator surfaces gaps and concerns; the user decides whether to act, defer, or proceed.

## PKM Access
```
reads  : all folders under {docs-repo}/
writes : {docs-repo}/features/* (status updates only)
         {docs-repo}/advisories/*
         frontmatter stamps: status, refs (append resulting tasks on CR resolution)
```

## Runtime References
Reads at invocation time:
- `{docs-repo}/agents/repo-mapping.md`
- `{docs-repo}/agents/skills-mapping.md`
