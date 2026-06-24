---
id: dd-{slug}
type: data-design
owner: software-architect
status: draft
version: 1.0
feature: {feature-id}
refs:
  - {sa-id}
  - {api-id}
---

# Data Design: {title}

## Overview
<!-- What data this design manages and why it exists. Internal data shapes + detailed data flows. -->

## Entity Definitions

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

## Data Flows
<!-- Detailed: entity state machines, pipeline stages, transformation logic.
     High-level service-to-service communication belongs in system-architecture. -->

### State Machine: {Entity}

```mermaid
stateDiagram-v2
    [*] --> {State1}
    {State1} --> {State2}: {trigger}
    {State2} --> [*]: {trigger}
```

### Pipeline: {Flow Name}

| Stage | Input | Transform | Output |
|-------|-------|-----------|--------|
|       |       |           |        |

### Transformations

| Transform | Source Entity | Target Entity | Logic |
|-----------|-------------|---------------|-------|
|           |             |               |       |

---

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

## Open Questions
<!-- Unresolved items that must be answered before implementation can start. -->
- [ ] 

## References
- {sa-link}
- {api-link}
