# Backend API — Folder Structure & Tech Stack

Example backend structure for a Go REST API with clean architecture.

> This file is intentionally example-driven. Keep it as-is if the target project uses a similar backend stack, or rewrite it for the target backend framework.
> Example stack: Go + Gin + GORM + SQLite + Ginkgo

---

## Folder Structure

```
backend-api/
├── cmd/
│   └── server/
│       └── main.go              # Entry point: config → DB → logger → router → shutdown
├── config/
│   └── config.yaml.example      # Configuration template
├── internal/                    # Private application code (not importable externally)
│   ├── config/
│   │   └── config.go            # Viper-based config loading
│   ├── controllers/             # HTTP handlers (bind → call service → respond)
│   │   ├── auth_controller.go
│   │   ├── deployment_controller.go
│   │   ├── endpoint_controller.go
│   │   ├── function_controller.go
│   │   ├── function_draft_controller.go
│   │   ├── runtime_controller.go
│   │   ├── typedef_controller.go
│   │   └── user_controller.go
│   ├── database/
│   │   └── database.go          # SQLite connection setup and GORM AutoMigrate
│   ├── middleware/
│   │   ├── auth.go              # JWT bearer token extraction
│   │   ├── cors.go              # CORS headers
│   │   ├── logger.go            # Per-request Zap logging
│   │   └── permission.go        # RequirePermission middleware
│   ├── models/                  # GORM entities, request DTOs, response DTOs, error types
│   │   ├── deployment.go / deployment_request.go / deployment_response.go
│   │   ├── endpoint.go / endpoint_request.go / endpoint_response.go
│   │   ├── function.go / function_request.go / function_response.go
│   │   └── user.go / auth_response.go / ...
│   ├── repositories/            # Repository interfaces + SQLite implementations
│   │   ├── deployment_repository.go
│   │   ├── endpoint_repository.go
│   │   ├── function_repository.go
│   │   ├── function_version_repository.go
│   │   └── user_repository.go
│   ├── routes/
│   │   └── routes.go            # Dependency wiring and route registration
│   └── services/                # Business logic layer
│       ├── auth_service.go
│       ├── deployment_service.go
│       ├── endpoint_service.go
│       ├── function_service.go
│       ├── function_version_service.go
│       ├── playground_service.go
│       ├── runtime_service.go
│       └── user_service.go
├── pkg/                         # Public reusable packages
│   ├── anthropic/               # Anthropic API client
│   ├── sdk/                     # JS SDK registry, bundler, and built-in packages
│   └── v8isolate/               # V8 JavaScript executor with isolate pooling
│       ├── executor.go          # Main executor: run JS with timeout and memory limits
│       ├── pool.go              # IsolatePool: manages reusable V8 instances
│       ├── isolate.go           # ManagedIsolate wrapper
│       ├── preload.go           # PreloadManager: loads initialization scripts
│       └── config.go            # Pool and execution configuration structs
├── scripts/
│   └── preload/
│       ├── 00-globals.js        # Global helper functions
│       └── 01-console.js        # console.* polyfill for V8
├── migrations/                  # Database migration files
├── config.yaml                  # Active runtime configuration
├── app.db                       # SQLite database (generated at runtime)
├── go.mod                       # Module definition and dependency versions
├── CLAUDE.md                    # Development guidelines
└── AGENTS.md                    # Project overview and structure reference
```

> **Why `internal/` vs `pkg/`**: Go enforces that code under `internal/` cannot be imported by external modules. Application-specific logic (controllers, services, repositories) lives in `internal/`. Reusable, self-contained packages (V8 executor, future integrations) live in `pkg/`.

---

## Architecture

The API follows a **clean layered architecture** with strict dependency direction:

```
HTTP Request
    ↓
Middleware  (auth, CORS, logging)
    ↓
Controller  (bind input, call service, write response)
    ↓
Service     (business logic, orchestration)
    ↓
Repository  (data access interface)
    ↓
Database    (SQLite via GORM)
```

Each layer depends only on the layer below via interfaces, enabling unit testing at each level without external dependencies.

---

## Tech Stack

### HTTP & Routing

| Package | Version | Role |
|---------|---------|------|
| `github.com/gin-gonic/gin` | v1.9.1 | HTTP router, middleware chain, JSON binding |

> REST only. No gRPC. Routes follow the conventions in [api-conventions.md](./api-conventions.md).

### Database

| Package | Version | Role |
|---------|---------|------|
| `gorm.io/gorm` | v1.31.1 | ORM: model definition, query builder, migrations |
| `gorm.io/driver/sqlite` | v1.14.22 | SQLite driver for GORM |

> AutoMigrate runs at startup. The database file (`app.db`) is generated in the project root.

### Configuration

| Package | Version | Role |
|---------|---------|------|
| `github.com/spf13/viper` | v1.18.0 | YAML config loading with environment variable overrides |

> Config is loaded once at startup into typed structs. Environment variables take precedence over `config.yaml`.

### Logging

| Package | Version | Role |
|---------|---------|------|
| `go.uber.org/zap` | v1.26.0 | Structured, leveled logging. Used in middleware and services |

### JavaScript Execution

| Package | Version | Role |
|---------|---------|------|
| `rogchap.com/v8go` | v0.9.0 | V8 engine bindings. Runs user-defined extraction scripts in isolated contexts |

> V8 isolates are managed via `pkg/v8isolate`. Each execution gets its own context with configurable memory and timeout limits. Isolates are pooled and reused to reduce GC overhead.

### Utilities

| Package | Version | Role |
|---------|---------|------|
| `github.com/google/uuid` | v1.6.0 | UUID generation for entity IDs |

### Testing

| Package | Version | Role |
|---------|---------|------|
| `github.com/onsi/ginkgo/v2` | v2.28.1 | BDD test framework (`Describe` / `It` / `BeforeEach`) |
| `github.com/onsi/gomega` | v1.39.1 | Matcher library for Ginkgo assertions |
| `github.com/golang/mock` | v1.6.0 | Mock generation via `//go:generate mockgen` directives |

> Unit tests use in-memory repositories and GoMock-generated service mocks. Integration tests run against the real SQLite driver.

---

## Key Files

| File | Purpose |
|------|---------|
| `cmd/server/main.go` | Bootstrap sequence and graceful shutdown handler |
| `internal/routes/routes.go` | Single place where all dependencies are instantiated and wired |
| `internal/services/runtime_service.go` | Runtime invocation: resolve endpoint → load function version → execute V8 |
| `pkg/v8isolate/executor.go` | V8 execution with per-run timeout, memory cap, and context injection |
| `pkg/v8isolate/pool.go` | IsolatePool lifecycle: min/max instances, idle timeout, checkout/return |
| `internal/config/config.go` | Typed config structs loaded by Viper |

---

## Anti-Patterns

- **Do not import `internal/` from outside the module.** Go will reject it at compile time.
- **Do not add business logic to controllers.** Controllers only handle HTTP concerns: binding, calling a service, and writing the response.
- **Do not instantiate dependencies inside services or repositories.** All dependencies are injected via constructors in `routes.go`.
- **Do not bypass the repository interface.** Services must call the repository interface, not a concrete type, to remain testable.
- **Do not run V8 code outside `pkg/v8isolate`.** Always go through the pooled executor to enforce resource limits and isolation.

---

## Adding a New Endpoint

1. Add a handler method on the controller struct in `internal/controllers/`
2. Add request/response types in `internal/models/` if needed (separate `_request.go` / `_response.go` files)
3. Add business logic to the service in `internal/services/`
4. Register the route in `internal/routes/routes.go` → `SetupRoutes()`

**Route ordering — critical:** Register static sub-paths **before** wildcard params. The `/:id` pattern captures any literal string including `"templates"`, `"generate"`, etc.

```go
functions := api.Group("/functions")
{
    functions.GET("/templates", functionController.ListTemplates) // BEFORE /:id
    functions.GET("", functionController.List)
    functions.POST("", functionController.Create)
    functions.GET("/:id", functionController.GetByID)
    functions.PATCH("/:id", functionController.Update)
    functions.DELETE("/:id", functionController.Delete)
}
```

---

## Error Handling

Use `models.FunctionValidationError` for all JSON error responses:

```go
ctx.JSON(http.StatusNotFound, models.FunctionValidationError{
    Error: models.FunctionErrorDetail{
        Code:    "NOT_FOUND",
        Message: "Function not found",
    },
})
```

Wire pattern in controllers:
- `repositories.ErrFunctionNotFound` sentinel → 404
- `*services.FunctionValidationErr` (field-level errors) → 400 with `Details` array
- All other errors → 500

Error response shape:
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable summary",
    "details": [{ "field": "name", "message": "must be unique" }]
  }
}
```

---

## Existing Routes

See `internal/routes/routes.go` → `SetupRoutes()` for the full, authoritative route table. Route groups: `/api/auth`, `/api/functions`, `/api/endpoints`, `/api/users`, `/api/type-definitions`, `/v1/run`.
