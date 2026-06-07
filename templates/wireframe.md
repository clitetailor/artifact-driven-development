---
id: wf-{slug}
type: wireframe
owner: ux-ui-designer
status: draft
version: 1.0
charter: {charter-slug}
prd: {charter-slug}/{prd-slug}
refs:
  - uf-{slug}
---

# Wireframe: {Screen Title}

## Layout

```
┌─────────────────────────────────────────┐
│ ← Back                    [Action]      │  ← Header
├─────────────────────────────────────────┤
│                                         │
│  {Section heading}                      │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ Label                           │    │
│  │ ┌─────────────────────────────┐ │    │
│  │ │ input placeholder           │ │    │
│  │ └─────────────────────────────┘ │    │
│  │                                 │    │
│  │ Label                           │    │
│  │ ┌─────────────────────────────┐ │    │
│  │ │ input placeholder           │ │    │
│  │ └─────────────────────────────┘ │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌───────────────┐  ┌───────────────┐   │
│  │    Cancel     │  │  [ Primary ]  │   │  ← CTAs
│  └───────────────┘  └───────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

## Annotations

| # | Element | Notes |
|---|---------|-------|
| 1 | Header | Back nav returns to {previous screen}. Action button is {label}. |
| 2 | {Section heading} | {What this section contains and why it's here.} |
| 3 | Primary CTA | {What it does. What it triggers.} |

## States Shown
- [ ] default
- [ ] loading
- [ ] error
- [ ] empty

States not shown here — see component spec cs-{slug}.

## References
- [uf-{slug}](../user-flows/uf-{slug}.md)
