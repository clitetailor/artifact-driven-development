# Software Development Process

This document outlines a reusable software development process, covering all roles and phases from discovery to deployment.

---

## Roles

| Role | Responsibilities |
|------|------------------|
| **BA/UX Designer** | Requirements, user research, wireframes, visual design |
| **Frontend Engineer** | UI implementation, component development, integration |
| **Backend Engineer** | API development, data modeling, infrastructure |

## Process Overview

```
Discovery → Requirements → Design → Implementation → Testing → Deployment → Iteration
```

### Phase Summary

| Phase | BA/UX | Frontend | Backend |
|-------|-------|----------|---------|
| 1. Discovery & Research | Lead | Support | Support |
| 2. Requirements & Architecture | Lead | Collaborate | Collaborate |
| 3. User Flows & Task Analysis | Lead | Review | Review |
| 4. Wireframing | Lead | Review | — |
| 5. Design System & Visual Design | Lead | Collaborate | — |
| 6. API Design | Support | Collaborate | Lead |
| 7. Implementation | Handoff | Lead | Lead |
| 8. Testing & QA | Visual QA | Frontend QA | Backend QA |
| 9. Deployment | — | Support | Lead |
| 10. Iteration | Feedback | Iterate | Iterate |

---

## Role-Specific Processes

Detailed tasks for each role:

- [BA/UX Designer Process](./ba-ux.md)
- [Frontend Engineer Process](./frontend.md)
- [Backend Engineer Process](./backend.md)

---

## Collaboration Points

### Design ↔ Frontend Handoff

Vault artifacts are the handoff source of truth. The frontend engineer should read the relevant `user-flows/`, `wireframes/`, and `component-specs/` artifacts directly.

- Create user flows and wireframes before implementation tasks are broken down
- Reference artifact paths explicitly in task files so implementers read the correct specs
- Review implementation against the design artifacts during development
- If implementation reveals a gap, update the upstream artifact or file a change request

### Frontend ↔ Backend Integration
- API contract definition (OpenAPI/Swagger)
- Request/response schema agreement
- Error handling conventions
- Authentication flow coordination

### Cross-Team Checkpoints
- Requirements review (all roles)
- API design review (Frontend + Backend)
- Integration testing (Frontend + Backend)
- Pre-release QA (all roles)
