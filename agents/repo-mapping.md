# Agent Repo Mapping
> Canonical source of truth — hooked into AGENTS.md later

| Agent | Slash Command | Writes code to | Reads PKM from |
|---|---|---|---|
| orchestrator | `/sdlc-orchestrator` | `{docs-repo}/` (status + advisories) | `{docs-repo}/` |
| business-analyst | `/sdlc-business-analyst` | `{docs-repo}/` | `{docs-repo}/` |
| ux-ui-designer | `/sdlc-ux-ui-designer` | `{docs-repo}/` | `{docs-repo}/` |
| software-architect | `/sdlc-software-architect` | `{docs-repo}/` | `{docs-repo}/` |
| backend-engineer | `/sdlc-backend-engineer` | `../{backend-repo}/` | `../{docs-repo}/` |
| frontend-engineer | `/sdlc-frontend-engineer` | `../{frontend-repo}/` | `../{docs-repo}/` |
| devops-engineer | `/sdlc-devops-engineer` | `../{infra-repo}/` | `../{docs-repo}/` |

## Notes

- All agents read PKM artifacts from `{docs-repo}/` regardless of where they write code
- `backend-engineer` and `frontend-engineer` also read from `{backend-repo}/` and
  `{frontend-repo}/` respectively when needed for implementation context
- `devops-engineer` reads from `{backend-repo}/` and `{frontend-repo}/` for deployment context
- No agent writes outside its designated repo boundary
