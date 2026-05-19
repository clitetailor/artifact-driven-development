---
id: dm-{slug}
type: data-model
owner: software-architect
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
hard-deps:
soft-deps:
  - adr-{slug}
  - api-{slug}
refs:
  - adr-{slug}
  - api-{slug}
---

# Data Model: {title}

## Overview
<!-- What data this model manages and why it exists. -->

## Tables / Collections

### `{table_name}`

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id     |      | no       |         | Primary key |
|        |      |          |         |             |

**Constraints:**
- 

**Indexes:**

| Name | Columns | Type | Purpose |
|------|---------|------|---------|
|      |         |      |         |

---

## Relationships

```
{table_a} ──< {table_b}   (one-to-many)
{table_c} >──< {table_d}  (many-to-many via {join_table})
```

## Migrations

### Migration: {migration-name}
**Sequence:** {N}
**Reversible:** yes / no

```sql
-- up
{sql}

-- down
{sql}
```

**Notes:** {anything a future engineer needs to know before running or rolling back}

## Seed Data
<!-- Required seed rows. Leave empty if none. -->
