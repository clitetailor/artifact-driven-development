# API Conventions

Backend API conventions for the target project.

> Adapt request/response details to the target backend stack and transport model.
> For database schema and entity relationships: see the relevant `data-models/dm-*.md` artifact for the feature you are working on.
> For backend code layout and architecture: see [backend-api-structure.md](./backend-api-structure.md)

---

## Endpoints

- **Method + resource noun:** `GET /users`, `POST /users`, `PUT /users/:id`
- **Plural resource names:** `/users`, `/endpoints`, `/deployments`
- **Kebab-case paths:** `/auth/change-password`, `/users/:id/status`
- **Nested only when ownership is clear:** `/endpoints/:id/deployments` (deployments belong to an endpoint)
- **Actions as sub-resources when REST verbs don't fit:** `PATCH /users/:id/status` not `POST /users/:id/deactivate`

---

## Request Format

- `Content-Type: application/json` on all requests with a body
- Request body is a flat JSON object — no envelope wrapper
- Optional fields: omit entirely (do not send `null`) to leave unchanged on PATCH/PUT

---

## Response Format

All responses are JSON. Use a named wrapper key matching the resource:

```json
// Single resource
{ "user": { "id": "...", "email": "..." } }

// Collection
{ "users": [ ... ] }

// No body (delete, logout, change-password)
// → 204 No Content, empty body
```

Include `created_at` and `updated_at` on all persistent resources. Never return `password_hash` or other internal fields.

---

## Error Format

All error responses use a consistent envelope:

```json
{
  "error": {
    "code": "snake_case_error_code",
    "message": "Human-readable description."
  }
}
```

- `code` is a stable machine-readable string used by the frontend for specific handling
- `message` is for developer debugging — not shown verbatim to end users
- For validation errors with multiple fields, use `details`:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "One or more fields are invalid.",
    "details": [
      { "field": "email", "message": "Invalid email format." },
      { "field": "role", "message": "Invalid role value." }
    ]
  }
}
```

---

## HTTP Status Codes

| Status | When to use |
|--------|-------------|
| `200 OK` | Successful GET, PUT, PATCH with a response body |
| `201 Created` | Successful POST that creates a resource |
| `204 No Content` | Successful DELETE, logout, or action with no response body |
| `400 Bad Request` | Validation error, malformed body, business rule violation |
| `401 Unauthorized` | Missing, expired, or invalid token |
| `403 Forbidden` | Authenticated but missing required permission |
| `404 Not Found` | Resource does not exist |
| `409 Conflict` | Uniqueness violation (e.g. duplicate email) |
| `500 Internal Server Error` | Unexpected server error — log and return generic message |

---

## Authentication

Protected endpoints require a Bearer access token in the `Authorization` header:

```
Authorization: Bearer <access_token>
```

Middleware validates the JWT signature and expiry before the handler runs. On failure:

| Condition | Status | Code |
|-----------|--------|------|
| Header absent or malformed | 401 | `token_missing` |
| Token expired | 401 | `token_expired` |
| Token signature invalid | 401 | `token_invalid` |

---

## Permission Enforcement

### Declaring required permissions

Every protected handler declares the permission it requires. The permission check runs in middleware after JWT validation — handlers never check permissions themselves.

```go
// Route registration
r.With(RequirePermission("users:manage")).Get("/users", handler.ListUsers)
r.With(RequirePermission("users:manage")).Post("/users", handler.CreateUser)
r.With(RequirePermission("schemas:write")).Post("/schemas", handler.CreateSchema)
```

### Middleware

```go
func RequirePermission(permission string) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            claims := ClaimsFromContext(r.Context())
            if !roleHasPermission(claims.Role, permission) {
                respondError(w, http.StatusForbidden, "forbidden", "You do not have permission to perform this action.")
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

### Role→permission map

The map is defined once in the auth package and is the single source of truth for what each role can do. Never hardcode role names in handlers or outside this map.

```go
var rolePermissions = map[Role][]Permission{
    RoleAdmin:    {PermUsersManage, PermSchemasRead, PermSchemasWrite, /* ... */},
    RoleEngineer: {PermSchemasRead, PermSchemasWrite, PermEvaluationsRun, /* ... */},
    RoleLabeler:  {PermDocumentsRead, PermDocumentsWrite, PermLabelingWrite, /* ... */},
    RoleCustomer: {PermReportsRead},
}

func roleHasPermission(role Role, permission Permission) bool {
    perms, ok := rolePermissions[role]
    if !ok {
        return false
    }
    for _, p := range perms {
        if p == permission {
            return true
        }
    }
    return false
}
```

See [authentication/requirements.md](../authentication/requirements.md) for the full permission catalog and role→permission matrix.

---

## Pagination

For collections that may grow large, use cursor-based pagination:

```
GET /documents?limit=20&cursor=<opaque_cursor>
```

```json
{
  "documents": [ ... ],
  "pagination": {
    "next_cursor": "<opaque_cursor>",
    "has_more": true
  }
}
```

- Default `limit`: 20. Max `limit`: 100.
- `next_cursor` is absent (not null) when `has_more` is false.
- For small, bounded collections (e.g. users, roles), pagination is not required.
