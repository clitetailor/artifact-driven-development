---
id: api-{slug}
type: api-spec
owner: software-architect
status: draft
version: 1.0
feature: {root-id}
refs:
  - sa-{slug}
  - dd-{slug}
---

# API Spec: {title}

## Overview
<!-- What service or capability this spec defines. One paragraph. External contract only — entity relationships and internal data shapes belong in data-design. -->

## Base Path
`/api/v{N}/{resource}`

## Authentication
<!-- Required auth mechanism. Reference system-architecture ADR if a decision was made. -->

---

## Endpoints

### {HTTP_METHOD} {path}

**Summary:** {one-line description}

**Request**

Headers:
```
Authorization: Bearer {token}
Content-Type: application/json
```

Path parameters:
| Name | Type | Required | Description |
|------|------|----------|-------------|
|      |      |          |             |

Query parameters:
| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
|      |      |          |         |             |

Body:
```json
{
}
```

**Response — 200 OK**
```json
{
}
```

**Error Responses**

| Status | Code | Description |
|--------|------|-------------|
| 400    |      |             |
| 401    |      |             |
| 403    |      |             |
| 404    |      |             |
| 422    |      |             |
| 500    |      |             |

---

## Shared Types
<!-- External shapes only — what consumers see. TypeScript-style type definitions for request/response DTOs. -->

```typescript
// Request/response type definitions (external shapes only)
```

## Entity Mapping
<!-- Which data-design entities back each endpoint's request/response. -->

| Endpoint | Request → Entity | Response ← Entity |
|----------|-----------------|-------------------|
| POST /{resource} | {RequestDTO} → dd-{slug}.{Entity} | {Entity} → {ResponseDTO} |

## Error Codes
<!-- Application-specific error codes beyond HTTP status codes. -->

| Code | Meaning | HTTP Status |
|------|---------|-------------|
|      |         |             |

## Versioning Policy
<!-- How breaking changes will be handled. -->

## Rate Limits
<!-- Limits per endpoint or per client. -->

## References
- [sa-{slug}](../system-architectures/sa-{slug}.md)
- [dd-{slug}](../data-designs/dd-{slug}.md)
