# Software Development Process

This document outlines a reusable software development process, covering all roles and phases from discovery to deployment.

---

## Roles

| Role | Responsibilities |
|------|------------------|
| **Business Analyst** | Requirements, user research, personas, feature scoping |
| **UX-UI Designer** | User flows, wireframes, component specifications |
| **Software Architect** | ADRs, API contracts, data models, quality requirements, backend task decomposition |
| **QA Engineer** | Test plans, test specs, test suites, coverage targets |
| **Frontend Engineer** | UI implementation, component development, API integration |
| **Backend Engineer** | API development, data modeling, service implementation |
| **DevOps Engineer** | Infrastructure, CI/CD pipelines, monitoring, runbooks |

## Process Overview

```
Discovery → Requirements → Design → Test Planning → Test Specs & Task Decomposition → Implementation → Deployment
```

### Phase Summary

| Phase | BA | UX | Architect | QA | Backend | Frontend | DevOps |
|-------|----|----|-----------|----|---------| ---------|--------|
| 1. Discovery & Requirements | Lead | Support | Support | — | — | — | — |
| 2. Design | — | Lead | Lead | Test Plan | — | — | — |
| 3. Test Specs & Task Decomp | — | — | Lead | Lead | Collaborate | Collaborate | — |
| 4. Implementation | — | — | — | Review | Lead | Lead | — |
| 5. Deployment | — | — | Support | — | Support | Support | Lead |

---

## Role-Specific Processes

Detailed tasks for each role:

- [BA/UX Designer Process](./ba-ux.md)
- [Frontend Engineer Process](./frontend.md)
- [Backend Engineer Process](./backend.md)

---

## Collaboration Points

### Design ↔ QA Handoff

Vault artifacts are the handoff source of truth. The QA engineer reads accepted requirements and design artifacts to write test plans (Phase 2) and test specs (Phase 3).

- Test plan is created alongside UX and Architect work in Phase 2
- Test specs are written against specific scenarios from requirements and API contracts
- Test suites group related specs and define shared coverage targets
- If a scenario is unclear, QA files a CR to the BA before writing the spec

### Design ↔ Frontend Handoff

Vault artifacts are the handoff source of truth. The frontend engineer should read the relevant `user-flows/`, `wireframes/`, and `component-specs/` artifacts directly.

- Create user flows and wireframes before implementation tasks are broken down
- Reference artifact paths explicitly in task files so implementers read the correct specs
- Review implementation against the design artifacts during development
- If implementation reveals a gap, update the upstream artifact or file a change request

### QA ↔ Engineering (TDD Cycle)

Tasks reference test-specs via `refs`. Engineers implement against test-specs.

- Engineers run test-specs before implementation (all tests fail — red)
- Engineers implement minimum code to make tests pass (green)
- Engineers refactor while keeping tests green
- Test-spec status updated to `accepted` when all tests pass

### Frontend ↔ Backend Integration

- API contract definition (OpenAPI/Swagger)
- Request/response schema agreement
- Error handling conventions
- Authentication flow coordination

### Cross-Team Checkpoints

- Requirements review (all roles)
- API design review (Frontend + Backend)
- Test plan review (QA + Architect + BA)
- Integration testing (Frontend + Backend + QA)
- Pre-release QA (all roles)
