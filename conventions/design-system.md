# Design System

**Project** — Professional Studio aesthetic. Tool-first, keyboard-friendly, warm-dark.
Inspired by Figma, Blender, VS Code, and Linear.

> Implementation example: `frontend/src/routes/layout.css`
> Example stack: Svelte 5 + Tailwind CSS v4 + TypeScript

---

## Colors

All tokens are defined via Tailwind CSS v4 `@theme` and available as utilities
(`bg-canvas`, `text-foreground`, `border-border`, etc.).

### Background Surfaces

| Token | Utility | Hex | Usage |
|-------|---------|-----|-------|
| `--color-canvas` | `bg-canvas` | `#0D1117` | App shell, document area, deepest layer |
| `--color-panel` | `bg-panel` | `#161B22` | Sidebars, activity bar, inspector panels |
| `--color-card` | `bg-card` | `#1C2128` | Cards, modals, elevated surfaces |
| `--color-popover` | `bg-popover` | `#22272E` | Dropdowns, tooltips, context menus |

> **Why warm-dark**: `#0D1117` (GitHub Dark base) is warmer and more approachable than
> pure OLED black (`#000000`), reducing eye strain in long labeling sessions.

### Borders

| Token | Utility | Hex | Usage |
|-------|---------|-----|-------|
| `--color-border` | `border-border` | `#30363D` | Default dividers, panel edges |
| `--color-border-strong` | `border-border-strong` | `#444C56` | Interactive elements, hover/focus rings |

### Text

| Token | Utility | Hex | Contrast on canvas | Usage |
|-------|---------|-----|-------------------|-------|
| `--color-foreground` | `text-foreground` | `#E6EDF3` | 12.3:1 ✓ AAA | Headings, labels, primary content |
| `--color-muted` | `text-muted` | `#8B949E` | 5.1:1 ✓ AA | Descriptions, secondary info |
| `--color-subtle` | `text-subtle` | `#6E7681` | 4.6:1 ✓ AA | Placeholders, metadata, panel labels |

### Brand Accent

| Token | Utility | Hex | Usage |
|-------|---------|-----|-------|
| `--color-accent` | `text-accent` / `bg-accent` | `#388BFD` | CTA buttons, active states, links |
| `--color-accent-hover` | `text-accent-hover` | `#58A6FF` | Hover on accent elements |
| `--color-accent-dim` | `bg-accent-dim` | `rgba(56,139,253,.12)` | Tinted backgrounds for active rows, badges |
| `--color-accent-subtle` | `bg-accent-subtle` | `rgba(56,139,253,.08)` | Nav rail / sidebar active state — lighter tint for dense nav contexts |

### Semantic Status

| Token | Utility | Hex | Usage |
|-------|---------|-----|-------|
| `--color-success` | `text-success` / `bg-success` | `#3FB950` | Pass states, approved labels |
| `--color-success-dim` | `bg-success-dim` | `rgba(63,185,80,.12)` | Success tinted backgrounds |
| `--color-warning` | `text-warning` / `bg-warning` | `#D29922` | Caution flags, low confidence |
| `--color-warning-dim` | `bg-warning-dim` | `rgba(210,153,34,.12)` | Warning tinted backgrounds |
| `--color-error` | `text-error` / `bg-error` | `#F85149` | Failures, critical issues |
| `--color-error-dim` | `bg-error-dim` | `rgba(248,81,73,.12)` | Error tinted backgrounds |

### Anti-patterns to avoid

- No AI purple/pink gradients (`#8B5CF6`, `#EC4899`)
- No pure OLED black (`#000000`) as backgrounds
- No light gray text on dark bg (fails contrast — use `text-muted` minimum)
- No color as the only status indicator (always pair with icon or text)

---

## Typography

**Primary font**: [Plus Jakarta Sans](https://fonts.google.com/share?selection.family=Plus+Jakarta+Sans:wght@300;400;500;600;700)
**Monospace font**: [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono) — code, API keys, JSON

```css
/* Already imported in layout.css */
--font-sans: 'Plus Jakarta Sans', system-ui, ui-sans-serif, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', ui-monospace, monospace;
```

### Type Scale

| Class | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `.text-studio-xs` | 11px | 400 | 1.5 | Badges, metadata, panel section labels |
| `.text-studio-sm` | 13px | 400 | 1.6 | Body text, form inputs (default) |
| `.text-studio-base` | 14px | 400/500 | 1.6 | Panel body text, descriptions |
| `.text-studio-md` | 16px | 500 | 1.5 | Section titles, group headers |
| `.text-studio-lg` | 18px | 600 | 1.4 | Panel headers, modal titles |
| `.text-studio-xl` | 22px | 700 | 1.3 | Page titles |
| `.text-studio-2xl` | 28px | 700 | 1.2 | Hero / empty state headings |

> **Why 13px body**: Studio tools (VS Code, Figma, Blender) use 13–14px for dense
> information layouts. This maximizes visible content without sacrificing readability.

### Panel labels

Use `.label-panel` for uppercase section headers inside panels:

```svelte
<p class="label-panel">Document Progress</p>
```

---

## Spacing

### Layout Dimensions

| Token | Value | Usage |
|-------|-------|-------|
| `--spacing-titlebar` | 48px (`3rem`) | Global nav/titlebar height |
| `--spacing-statusbar` | 24px (`1.5rem`) | Status bar height |
| `--spacing-activity` | 48px (`3rem`) | Activity bar width |
| `--spacing-sidebar` | 240px (`15rem`) | Sidebar default width |
| `--spacing-inspector` | 260px (`16.25rem`) | Right inspector width |
| `--spacing-toolbar` | 40px (`2.5rem`) | Workspace toolbar height |
| `--spacing-panel-header` | 36px (`2.25rem`) | Panel section header height |

### Border Radius

| Token | Utility | Value | Usage |
|-------|---------|-------|-------|
| `--radius-xs` | `rounded-xs` | 3px | Badges, chips, tiny elements |
| `--radius-sm` | `rounded-sm` | 4px | Buttons, inputs, tags |
| `--radius-md` | `rounded-md` | 6px | Cards, panels, dropdowns |
| `--radius-lg` | `rounded-lg` | 8px | Modals, document pages |
| `--radius-xl` | `rounded-xl` | 12px | Command palette, large cards |
| `--radius-2xl` | `rounded-2xl` | 16px | Feature cards |

### Z-Index Scale

| Token | Value | Layer |
|-------|-------|-------|
| `--z-base` | 10 | Sticky headers, panel dividers |
| `--z-toolbar` | 20 | Floating toolbars, dropdowns |
| `--z-modal` | 30 | Dialogs, drawers, side sheets |
| `--z-overlay` | 40 | Backdrop overlays |
| `--z-toast` | 50 | Toast notifications, command palette |

---

## Components

### Icon Button (`.icon-btn`)

36×36px, meets 44×44px touch target via padding context. Always requires `aria-label`.

```svelte
<button class="icon-btn" aria-label="Open settings">
  <SettingsIcon size={16} />
</button>
```

### Toolbar Button (`.toolbar-btn` / `.toolbar-btn-primary`)

28px height, used in workspace toolbars.

```svelte
<!-- Secondary -->
<button class="toolbar-btn">
  <BoltIcon size={12} />
  Auto-extract
</button>

<!-- Primary CTA -->
<button class="toolbar-btn toolbar-btn-primary">
  <CheckIcon size={12} />
  Save &amp; Complete
</button>
```

### Form Input (`.studio-input`)

```svelte
<label for="vendor-id">Vendor ID</label>
<input id="vendor-id" class="studio-input" type="text" />
```

### Status Badges

```svelte
<span class="badge badge-success">Done</span>
<span class="badge badge-warning">Review</span>
<span class="badge badge-error">Failed</span>
<span class="badge badge-muted">Pending</span>
<span class="badge badge-accent">Active</span>
```

### Label Chips (OCR annotation tags)

```svelte
<span class="label-chip badge-accent">vendor_name</span>
<span class="label-chip badge-success">invoice_date</span>
<span class="label-chip badge-warning">address</span>
<span class="label-chip badge-muted">unassigned</span>
```

### Skeleton Loader (`.skeleton`)

```svelte
<div class="skeleton h-8 w-full rounded-sm"></div>
```

### Animations

| Class | Usage |
|-------|-------|
| `.toast-enter` | Toast notifications sliding in |
| `.panel-enter` | Panel/sidebar appearing |
| `.skeleton` | Shimmer loading state |

All animations respect `prefers-reduced-motion` via the global reset in `layout.css`.

---

## Layout Architecture

### Application Shell

The app shell uses a **sidebar rail** layout. The sidebar doubles as primary navigation and collapses to icon-only mode (48px) via the toggle button or `Ctrl/Cmd + \`.

**Expanded (default):**
```
┌──────────────────────────────────────────────────────────┐
│ [≡] Project             [Tabs]──────────────[Search][User]  │
├────────────────┬─────────────────────────────────────────┤
│                │                                         │
│ Workspace      │                                         │
│  Dashboard     │   Main Workspace                        │
│  Labeling      │   (Canvas / Table / Editor)             │
│  Datasets      │                                         │
│                │                                         │
│ Configure      │                                         │
│  Schemas …     │                                         │
├────────────────┴─────────────────────────────────────────┤
│  Status Bar (24px)                                       │
└──────────────────────────────────────────────────────────┘
   240px                      1fr
```

**Collapsed (`Ctrl/Cmd + \` or toggle button):**
```
┌──────────────────────────────────────────────────────────┐
│ [≡] Project             [Tabs]──────────────[Search][User]  │
├────┬─────────────────────────────────────────────────────┤
│ 🏠 │                                                     │
│ 🏷 │   Main Workspace                                    │
│ 🗄 │   (Canvas / Table / Editor)                         │
│ …  │                                                     │
├────┴─────────────────────────────────────────────────────┤
│  Status Bar (24px)                                       │
└──────────────────────────────────────────────────────────┘
  48px                        1fr
```

### Sidebar Collapse Behaviour

| State | Sidebar width | Icons | Labels | Section titles |
|-------|--------------|-------|--------|----------------|
| Expanded | 240px | Visible | Visible (`font-weight: 500`) | Visible (`.label-panel`) |
| Collapsed | 48px | Centered | Hidden (`max-width: 0`) | Hidden (`max-height: 0`) |

- Toggle: hamburger button (always 48px wide, aligned with icon column) or `Ctrl/Cmd + \`
- Transitions gated on `.app-shell--ready` to prevent startup animation
- Collapsed state persisted in `localStorage` (`project:sidebar-collapsed`)
- Initial state applied via inline script in `app.html` using `data-sidebar-collapsed` attribute on `<html>` — eliminates SSR flash

### Breakpoints

| Breakpoint | Layout |
|-----------|--------|
| `≥ 768px` | Sidebar rail (240px expanded / 48px collapsed) + main workspace |
| `< 768px` | Sidebar hidden; overlay drawer via hamburger (full 240px, `z-index: var(--z-modal)`) |

---

## Icon Library

**Lucide Icons** — consistent 24×24 viewBox, 1.5px stroke, rounded linecaps.

```bash
pnpm add lucide-svelte
```

```svelte
<script>
  import { Settings, FileText, ChevronRight } from 'lucide-svelte';
</script>

<Settings size={16} />        <!-- inline, table cells -->
<FileText size={20} />        <!-- toolbar, panel headers -->
<ChevronRight size={24} />    <!-- activity bar, primary actions -->
```

**Icon sizes**: 16px (inline), 20px (toolbar), 24px (activity bar), 32px (empty states).

**Never use emojis as icons.** Reserve color icons for semantic status only.

---

## Keyboard Navigation

| Shortcut | Action |
|----------|--------|
| `Ctrl/Cmd + K` | Open Command Palette |
| `Ctrl/Cmd + \` | Toggle sidebar |
| `Ctrl/Cmd + B` | Toggle inspector panel |
| `Ctrl/Cmd + /` | Show keyboard shortcuts |
| `Alt + ←/→` | Previous / Next document |
| `F2` | Rename selected item |
| `Escape` | Close modal / cancel action |
| `Space` | Toggle preview / selection |
| `Delete` | Delete selected (with confirm) |

All interactive elements must support keyboard interaction alongside click events.

---

## Accessibility Checklist

- [ ] All text: 4.5:1 contrast minimum (WCAG AA)
- [ ] Focus rings: use `:focus-visible` (already global in `layout.css`)
- [ ] Icon-only buttons: `aria-label` required
- [ ] Form inputs: associated `<label>` with `for` attribute
- [ ] Skip-to-content link at top of shell
- [ ] Tables: `<th scope="col">` headers
- [ ] Modals: focus trap + `role="dialog"` + `aria-labelledby`
- [ ] Touch targets: 44×44px minimum
- [ ] `prefers-reduced-motion`: global reset already applied in `layout.css`
- [ ] Color is never the only status indicator (pair with icon + text)
