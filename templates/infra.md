---
id: infra-{slug}
type: infra
owner: devops-engineer
status: draft
version: 1.0
feature: {feature-slug}
module: {feature-slug}/{module-slug}
refs:
  - adr-{slug}
  - qr-{slug}
  - task-{slug}-be
  - task-{slug}-fe
---

# Infra: {title}

## IaC Specification

### Services / Resources

| Resource | Type | Size / Tier | Region | Notes |
|----------|------|-------------|--------|-------|
|          |      |             |        |       |

### Networking
<!-- VPC, subnets, ingress rules, load balancer config. -->

### Secrets Management
<!-- Which secrets are required. Where they are stored. How they are injected. -->

| Secret | Store | Injection Method |
|--------|-------|-----------------|
|        |       |                 |

---

## CI/CD Pipeline

### Stages

| Stage | Trigger | Action | Gate Condition |
|-------|---------|--------|---------------|
|       |         |        |               |

### Rollback Trigger
<!-- Condition under which the pipeline automatically rolls back. -->

---

## Monitoring & Alerting

### Metrics to Track

| Metric | Source | Alert Threshold | Severity |
|--------|--------|----------------|----------|
|        |        |                |          |

### Dashboards
<!-- What panels / views should exist. Tool-agnostic. -->

---

## Rollout Strategy
<!-- canary | blue-green | direct -->

**Strategy:** {strategy}

| Phase | Traffic % | Promotion Criteria | Rollback Trigger |
|-------|-----------|--------------------|-----------------|
|       |           |                    |                 |

---

## Runbook

### Deployment Steps
1. 
2. 

### Health Check
<!-- How to verify the deployment is healthy after rollout. -->

### Rollback Steps
1. 
2. 

### Escalation Path
<!-- Who to page if rollback fails or the incident is unresolved after N minutes. -->

---

## Environment Config

| Variable | Environment | Value Source | Description |
|----------|-------------|--------------|-------------|
|          |             |              |             |
