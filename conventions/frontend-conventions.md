# Frontend Conventions

Example frontend conventions for the target project.

> This file is intentionally example-driven. Keep it as-is if the target project uses a similar frontend stack, or rewrite it for the target framework.
> For CSS tokens, component classes, and visual design: see [design-system.md](./design-system.md)

---

## Example Stack

| Tool | Version | Role |
|------|---------|------|
| SvelteKit | `^2.50` | Framework, file-based routing, SSR/CSR |
| Svelte | `^5.51` | UI — runes syntax only |
| Tailwind CSS | `^4.1` | Utility CSS + `@theme` design tokens |
| TypeScript | `^5.9` | Strict types throughout |
| lucide-svelte | `^1.0` | Icons |
| Vite | `^7.3` | Dev server + bundler |

---

## Folder Layout

```
src/
  lib/
    api/
      client.ts           # apiFetch, setAccessToken, clearAccessToken, SessionExpiredError
      auth.ts             # changePassword, ApiError
      functions.ts        # fetch calls for /api/functions
      endpoints.ts        # fetch calls for /api/endpoints
      users.ts            # fetch calls for /api/users
    stores/
      auth.svelte.ts      # Global singleton — session state, login/logout/getValidToken
      toast.svelte.ts     # Global singleton — toast queue
      useFunctionDraft.svelte.ts  # Composable — instance-local draft state for the editor
    components/
      layout/             # Shared layout components (PascalCase .svelte)
      ui/                 # App-wide UI primitives
      auth/               # Auth-specific components
    types/
      auth.ts             # LoginResponse, RefreshResponse
      user.ts             # User type
    assets/
  routes/
    layout.css            # Design tokens (@theme) + global utility classes
    +layout.svelte        # Root layout — imports layout.css
    (app)/                # Standard app pages (sidebar + app shell)
      +layout.ts          # Auth guard — calls /auth/refresh, redirects to /login on failure
      functions/
      endpoints/
      settings/
    (auth)/               # Auth pages (full-screen, no sidebar)
      login/
      change-password/    # Forced flow — first-time / temp-password login
    (studio)/             # Editor workspace (breaks parent layout)
      functions/[id]/
        +layout@.svelte   # Break-out layout + loading spinner
        +page.svelte      # Full editor shell
        +page.ts
```

---

## Component Structure

### Folder conventions

- `src/lib/components/ui/` — shared primitives used across the whole app. All features import from here. No feature-specific logic.
- `src/lib/components/<feature>/` — feature-scoped components (e.g. `users/`, `auth/`). Keep feature components here rather than as loose files in the `components/` root.
- No loose `.svelte` files directly under `src/lib/components/` — everything goes into a named subfolder.

### Shared component catalog (`src/lib/components/ui/`)

| Component | Import path | Description |
|-----------|-------------|-------------|
| `AiChatPanel` | `$lib/components/ui/AiChatPanel.svelte` | AI chat side panel for the studio editor |
| `AppShell` | `$lib/components/ui/AppShell.svelte` | Top-level app shell with sidebar and main area |
| `CodeEditor` | `$lib/components/ui/CodeEditor.svelte` | Monaco-based code editor pane |
| `EnvVarsPanel` | `$lib/components/ui/EnvVarsPanel.svelte` | Environment variables editor panel |
| `MainContent` | `$lib/components/ui/MainContent.svelte` | Main content area wrapper inside AppShell |
| `Modal` | `$lib/components/ui/Modal.svelte` | Generic modal overlay with backdrop and close behaviour |
| `PlaygroundPanel` | `$lib/components/ui/PlaygroundPanel.svelte` | HTTP request/response playground panel |
| `PublishVersionModal` | `$lib/components/ui/PublishVersionModal.svelte` | Modal for publishing a new function version |
| `Sidebar` | `$lib/components/ui/Sidebar.svelte` | Primary navigation sidebar |
| `SidebarItem` | `$lib/components/ui/SidebarItem.svelte` | Single nav item used inside Sidebar |
| `Spinner` | `$lib/components/ui/Spinner.svelte` | Loading spinner indicator |
| `SplitPanel` | `$lib/components/ui/SplitPanel.svelte` | Resizable two-pane split layout |
| `StatusBadge` | `$lib/components/ui/StatusBadge.svelte` | Coloured badge displaying a status label |
| `StatusBar` | `$lib/components/ui/StatusBar.svelte` | Bottom status bar showing save state and version |
| `StudioBar` | `$lib/components/ui/StudioBar.svelte` | Top bar inside the studio editor |
| `StudioShell` | `$lib/components/ui/StudioShell.svelte` | Layout shell for the full-screen studio workspace |
| `TemplatePicker` | `$lib/components/ui/TemplatePicker.svelte` | Grid/list picker for selecting a function template |
| `TitleBar` | `$lib/components/ui/TitleBar.svelte` | Page or panel title bar with optional actions |
| `ToastStack` | `$lib/components/ui/ToastStack.svelte` | Stacked toast notification renderer |
| `VersionHistoryPanel` | `$lib/components/ui/VersionHistoryPanel.svelte` | Panel listing published function versions |

---

## Routing Conventions

- **File-based routing** — directory = route segment
- **Route groups** `(name)/` — group related routes without affecting URL
- **`+page.ts`** — client-side load function, exports `load: PageLoad`
- **`+layout@.svelte`** — breaks out of parent layout chain (the `@` suffix)
- **Dynamic segments** — `[id]` in directory name, accessed via `params.id`

---

## Svelte 5 Runes — Required Patterns

Use runes exclusively. No `export let`, no `$:`, no `writable()` stores.

```svelte
<script lang="ts">
  import type { PageData } from './$types';

  // Props
  let { data }: { data: PageData } = $props();

  // State
  let count = $state(0);
  let name = $state('');

  // Derived (computed)
  let doubled = $derived(count * 2);
  let hasChanges = $derived(name !== savedName);

  // Side effects
  $effect(() => {
    document.title = name;
  });
</script>

<!-- Snippets replace slots -->
{#snippet footer()}
  <p>Footer content</p>
{/snippet}

{@render footer()}
```

**Component with children:**
```svelte
<script lang="ts">
  let { children, title } = $props();
</script>
<div>
  <h2>{title}</h2>
  {@render children()}
</div>
```

---

## State Management

No external store library. All reactive state uses Svelte 5 runes.

**Component-local state** — `$state`/`$derived` declared inside a component `<script>`. Passed down via props. Default choice for anything owned by one component.

**Global singletons** (`src/lib/stores/*.svelte.ts`, no `use` prefix) — module-level `$state` shared across the whole app. Use when multiple unrelated components need to read or mutate the same state (e.g. auth session, toast queue). Import and use directly:

```ts
import { auth, can } from '$lib/stores/auth.svelte';
import { showToast } from '$lib/stores/toast.svelte';
```

**Composables** (`src/lib/stores/use*.svelte.ts`, `use` prefix) — factory functions called inside a component that create instance-local reactive state, often using `onMount`/`onDestroy`. Each call creates an independent copy:

```ts
// in +page.svelte
import { useFunctionDraft } from '$lib/stores/useFunctionDraft.svelte';
const draft = useFunctionDraft(data.function);
```

**Decision rule:** if two unrelated components need the same value → singleton store. If one component needs rich local state with lifecycle logic → composable. If state is simple and owned by one component → keep it in the component.

---

## Auth & Permissions

### Auth store

Global auth state lives in `src/lib/stores/auth.svelte.ts`. It is the single source of truth for the current user, permissions, and token expiry.

```ts
import { auth, can, mustChangePassword, getValidToken, login, logout, clearSession } from '$lib/stores/auth.svelte';

// Read state
auth.user          // AuthUser | null
auth.permissions   // string[]
auth.accessTokenExpiresAt   // Unix ms — access token expiry
auth.refreshTokenExpiresAt  // Unix ms — session cookie expiry (used by SessionExpiryBanner)

// Actions
login(response)    // populate store after POST /auth/login
logout()           // POST /auth/logout then clear store
clearSession()     // clear store synchronously, no API call

// Helpers
can('users:manage')     // permission check — replaces hasPermission
mustChangePassword      // $derived boolean
getValidToken()         // returns fresh access token, refreshes if <30s remain
```

Never mutate `auth.*` fields directly outside the store. Use the store actions.

### Checking permissions in components

Use `can()` — never read `auth.user.role` directly in templates or logic.

```svelte
<script lang="ts">
  import { can } from '$lib/stores/auth.svelte';
</script>

{#if can('users:manage')}
  <button>Add User</button>
{/if}
```

Permission strings are the exact values from the permission catalog in `authentication/requirements.md`.

### Route guards

Protect routes in server load functions where possible. Prefer `+layout.server.ts` and `+page.server.ts`, read `session` from `parent()`, redirect unauthenticated users to `/login`, and redirect unauthorized users to `/403`.

```ts
// src/routes/(app)/settings/users/+page.server.ts
import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ parent }) => {
  const { session } = await parent();

  if (!session) redirect(302, '/login');
  if (!session.permissions.includes('users:manage')) redirect(302, '/403');
};
```

Route guards are UX only — all enforcement is server-side. Never rely on them as a security boundary.

### API client — attaching the access token

The access token lives in a module-level variable in `client.ts` (not `localStorage`). `apiFetch` attaches it as a Bearer header automatically. All requests go to `API_BASE` — no Vite proxy.

```ts
import { apiFetch } from '$lib/api/client';

// All domain API files call apiFetch — never fetch directly
const res = await apiFetch('/users', { method: 'GET' });
```

Never hardcode `API_BASE` or set `Content-Type: application/json` in domain API files — `apiFetch` handles both.

**Exception — raw `fetch`:** `getValidToken()` in the auth store calls `POST /auth/refresh` directly to avoid infinite recursion (it runs before a valid token exists).

### Silent token refresh

When `apiFetch` receives a `401`, it calls `refreshAndRetry` which attempts one silent refresh via `POST /auth/refresh`. On success it retries the original request. On failure it throws `SessionExpiredError` — callers are responsible for redirecting to `/login`.

```ts
// client.ts — simplified
async function refreshAndRetry(path: string, init: RequestInit): Promise<Response> {
  const res = await fetch(`${API_BASE}/auth/refresh`, { method: 'POST', credentials: 'include' });
  if (!res.ok) {
    clearAccessToken();
    throw new SessionExpiredError();
  }
  const data = await res.json();
  setAccessToken(data.access_token);
  return apiFetch(path, init);
}
```

`SessionExpiredError` is exported from `$lib/api/client` for callers that need to handle it explicitly.

---

## API Client

API modules live in `src/lib/api/`. One file per domain (e.g. `functions.ts`, `users.ts`, `auth.ts`).

**Rules:**
- Always call `apiFetch` from `$lib/api/client` — never call `fetch` directly except inside `getValidToken()` in the auth store (see exception above)
- Never import or reference `API_BASE` in domain API files — `apiFetch` handles the base URL
- Never set `Content-Type` manually — `apiFetch` sets it automatically (and omits it for `FormData`)
- Throw `Error` on non-OK responses; parse the error message from `body?.error?.message`

**Adding a new endpoint:**

```ts
import { apiFetch } from './client';

export async function listTemplates(): Promise<Template[]> {
  const res = await apiFetch('/functions/templates');
  if (!res.ok) {
    const body = await res.json().catch(() => null);
    throw new Error(body?.error?.message ?? `Request failed: ${res.status}`);
  }
  return res.json();
}
```

---

## Existing Editor Shell

`src/routes/(studio)/functions/[id]/+page.svelte` is the main editor page. It owns:

- **Draft state** — managed by `useFunctionDraft` composable from `$lib/stores/useFunctionDraft.svelte`; exposes `name`, `code`, `envVars`, `hasChanges`, `save()`, `restore()`
- **Save/auto-save** — `save()` calls `updateFunction()`; auto-save fires every 30s
- **`SplitPanel`** — left: code editor pane; right: side panel with tabs
- **Side panel tabs** — `ai-chat` | `env-vars` | `playground` (togglable, collapse on re-click)
- **Status bar** — unsaved indicator, last-saved label, version

New panels, overlays, and editor components integrate into this file or as child components rendered within it. The `code` and `envVars` state from the composable is the source of truth passed down.
