---
id: api-{slug}
type: api-contract
owner: software-architect
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
hard-deps:
soft-deps:
  - adr-{slug}
  - story-{slug}
  - qr-{slug}
refs:
  - adr-{slug}
  - story-{slug}
  - qr-{slug}
---

# API Contract: {title}

## Overview
<!-- What service or capability this contract defines. One paragraph. -->

## Base Path
`/api/v{N}/{resource}`

## Authentication
<!-- Required auth mechanism. Reference ADR if a decision was made. -->

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

```typescript
// TypeScript-style type definitions for shared request/response shapes
```

## Versioning Policy
<!-- How breaking changes will be handled. -->

## Rate Limits
<!-- Limits per endpoint or per client. Reference QR doc if defined there. -->
