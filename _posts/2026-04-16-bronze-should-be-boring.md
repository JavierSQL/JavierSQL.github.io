---
layout: post
title: "Bronze Should Be Boring"
date: 2026-04-16 09:00:00
description: "Designing a metadata-driven ingestion layer that disappears behind a YAML commit"
thumbnail: assets/img/feat-bronze-should-be-boring.jpg
tags: [bronze, ingestion, yaml, medallion, microsoft-fabric]
categories: [yaml-ingestion]
giscus_comments: true
---

![Bronze Should Be Boring](/assets/img/feat-bronze-should-be-boring.jpg)

Open a tap and water comes out. Clean, safe, drinkable. Nobody celebrates. Nobody thinks about it. But behind that unremarkable moment there are treatment plants, distribution networks, pressure monitoring systems, quality tests, and centuries of engineering. The tap is boring because the infrastructure is excellent.

Bronze should feel the same way.

If adding a new data source to your Lakehouse requires a new pipeline, a round of debugging, a deployment, and a small prayer, you don't have engineering. You have craft. Artisanal, hand-wired, one-pipeline-per-table craft that works fine at ten entities and becomes a liability at fifty.

This post explores how to make Bronze boring, and why that requires more engineering than you'd expect. It's the first in a series where we walk through the metadata-driven architecture that makes this simplicity possible. We start with the foundation: the Bronze layer and why YAML is the contract that holds it together.

## The problem: pipeline proliferation

Here's a story you've probably lived. You start a Lakehouse project with ten entities and two sources. You build a pipeline per entity and an orchestrator pipeline on top. It works. It's "agile."

A year later you have five sources, three countries, and 350 entities. You also have 350 pipelines. Each one with its own connection logic, its own error handling, its own technical columns (or not), and its own naming invented by whoever built it that day. Some have retry logic. Some don't. Some log to a control table. Some log to nowhere.

The problem is not the volume of data. It's the volume of *pipelines*. Each one is code you need to maintain, test, document, and debug. Each one is a surface area for bugs. Each one is a deployment. And every new entity becomes a 2-3 day development ticket where it should be a 15-minute commit -- because someone has to clone an existing pipeline, change fifteen things, forget to change two others, and debug in production until it works. Until it doesn't, and nobody remembers why it was built that way.

There's another way. And it starts by rethinking what Bronze actually is.


## Bronze redefined: not just "raw copy"

The classic Medallion definition is clean and tidy. Bronze is raw copy -- data as it arrives, no transformations. Silver cleans. Gold aggregates. It's a useful mental model with one practical problem: if Bronze is just a dump, the data enters without identity.

You don't know where it came from. You don't know who sent it. You don't know if it's complete. You don't know when it arrived. And more importantly, you don't know who owns it. If you wait until Silver to answer those questions, you've already let someone into your building without asking for ID, and now you're trying to figure out who they are after the fact.

Our redefinition: Bronze is a copy with full fidelity to the source, *enriched* with metadata and governance from the point of entry.

| Classic Bronze ("raw copy")   | Enriched Bronze                                                      |
| ----------------------------- | -------------------------------------------------------------------- |
| Data as-is                    | Data + technical columns (RunID, LoadDateUTC, BatchID, SnapshotDate) |
| Generic schema (staging, raw) | Schema that reflects source and domain in the name                   |
| No classification             | Security and governance tags from ingestion                          |
| Pass or fail                  | Anomalies go to quarantine, they don't break the load                |
| Unknown schema                | Schema capture and drift detection from day one                      |

"But that's not Bronze anymore -- that's Silver." No. The original data is not modified or cleaned. What gets added is *metadata*: technical columns, classification, schema naming. The data maintains its fidelity to the source. It's raw data plus rich metadata.

OK, enriched Bronze sounds good. But how do you implement it without ending up with 200 artisanal pipelines? That's where YAML comes in.

## The solution: a fixed engine plus N YAMLs

The architecture in one sentence:

> A small, fixed engine of specialized components + N YAML files = N sources ingested without writing new code.

The key insight: it's not one magic notebook that does everything. It's a **finite set of generic components**, each specialized in a single concern:

- **Ingestion by source type** -- Different components for different origins. Files (CSV, Parquet, Excel): a notebook that reads, applies schema, writes Delta. Relational databases: a pipeline with ForEach and parameterized Copy Activity. APIs: a notebook with a request-paginate-land pattern.
- **Schema capture** -- A notebook that records the data dictionary (table structure) with every ingestion. When the structure drifts from the last known version -- new column, type change, field removed -- the drift is logged to a registry so it can be reviewed before it surprises a downstream consumer.
- **Volume validation** -- A notebook that compares rows received vs. expected and flags anomalies. Rows that fail integrity rules don't break the load; they're routed to a quarantine table tagged with the reason, while the rest proceed. Quarantine is a side channel, not a failure.
- **Orchestration** -- A master pipeline that reads the YAMLs and triggers the appropriate components. Bronze has no cross-table dependencies by design: every entity lands independently. Dependency resolution is a Silver problem, not a Bronze one. Bronze takes data as-is -- duplicates, nulls, and invalid foreign keys all land intact. That's the contract. Referential integrity requires knowing that a referenced table loaded before its referencing one, and that ordering logic belongs in Silver.

The number of engine components is **small and bounded** -- five, seven, maybe ten in complex environments. It doesn't grow with data volume or source count. What scales is the *configuration*: adding source number 201 doesn't require a new component, just a new YAML the existing components already know how to read. New concerns like PII detection, freshness checks, or sample preview slot in as new notebooks wired to the same contract -- not as new pipelines per source.

### Why YAML (and not JSON, a UI, or SQL metadata tables)

This isn't an article about YAML syntax. It's about the *properties* you need in your configuration format. Three axes:

**1. Governability -- Configuration lives in Git, not in a database**

YAML in Git inherits all the code-review machinery you already use: PRs, diffs, blame, rollback, approval gates as strict as governance requires. "Who edited row 47 in `dbo.PipelineConfig` on Tuesday at 3am?" is a hard question. "Who edited `Sales_Salesforce.yml`?" is `git blame`.

This is not a new pattern. It's Infrastructure as Code -- declarative configuration, version control, automated deployment, repeatability -- applied to ingestion instead of infrastructure. The same fundamentals that made server provisioning predictable with Terraform make data-source provisioning predictable here. How it plugs into DevOps practice (pre-deploy validation, approval pipelines, rollback) is the topic of the next post.

**2. Extensibility -- The contract evolves without breaking**

Adding a new section to a YAML doesn't break existing YAMLs that don't use it. `template_version: "1.0"` evolves to `"2.0"`, and the engine knows which version to process. Adding a column to a config table, by contrast, means ALTER TABLE, a deployment, and coordinating with everything that reads it. One is a commit; the other is a project.

**3. Usability -- Human readable, machine readable, AI readable**

A new data engineer opens the YAML and understands what it does without documentation -- no SQL knowledge required, no database access, no UI to learn. Copy an existing one, change five lines, submit a PR. And an argument nobody was making two years ago: YAML is structured plain text, the ideal format for an LLM to read, generate, and modify. Ask a model to produce an `INSERT INTO` with 15 nullable columns versus a YAML following a template -- the difference in reliability is dramatic. We didn't design this with AI agents in mind, but the structure accommodates them naturally: an agent can read existing YAMLs, review Git history to understand which changes correlated with incidents, and propose a new entity -- committing the file and opening a PR on request. The contract is already machine-readable.

**The alternatives, briefly:**
- **JSON** -- Modern tooling (JSON5, schema-aware editors) narrows the gap, but long configs still drown in quotes and brackets, and diffing nested JSON is an eye test.
- **UI (web portals)** -- Not versionable, not diffable, not scriptable. Config trapped in the platform.
- **SQL metadata tables** -- Excellent for *operational* metadata (logs, status, metrics) -- but for declarative configuration they mix concerns: the same place where you write config is where the runtime executes.

### Core design principles

Four principles that drive everything downstream:

1. **GitOps as source of truth** -- YAML is edited only in Git. Every change via PR. The Lakehouse contains deployed artifacts, not editable ones.
2. **Filename-as-metadata** -- The filename *is* metadata. `Sales_Salesforce.yml` means domain=Sales, source=Salesforce, and the Lakehouse schema is derived from the name. This is the riskiest bet in the design -- and the one that pays the most; see the deep-dive below.
3. **One YAML per source-domain** -- Clear granularity. Not a mega-YAML with everything, not one YAML per individual table.
4. **Pure declarativity** -- The YAML never contains logic. Only parameters. "The YAML describes *what* gets ingested; the engine decides *how*."

### What a YAML looks like

Here's what a real ingestion YAML looks like, trimmed to the essentials:

```yaml
# File: Sales_Salesforce.yml
# Implicit metadata from filename: domain=Sales, source=Salesforce
# Automatic destination schema: Sales_Salesforce

config:
  template_version: "1.0"
  source_type: relational
  source_system:
    owner: "Revenue-Ops"
  tags:
    security.sensitivity: "confidential"
    governance.data_owner: "Sales"

entities:
  - name: Opportunities
    table: Salesforce.Opportunity
    tags:
      security.sensitivity: "restricted"       # overrides global tag
      security.classification: "PII"   
    post_ingestion_tasks:
      volume_check:
        enabled: true
        min_rows: 500
      schema_capture:
        enabled: true

  - name: Products
    table: Salesforce.Product
    tags:
      security.sensitivity: "internal"
    post_ingestion_tasks:
      volume_check:
        enabled: false
      schema_capture:
        enabled: true
```

Everything you need to know about these two entities fits on a screen. The domain, the source, the governance owner, the security classification, the volume thresholds, the schema capture flag -- all declared, no code. Adding a third entity is five more lines and a pull request.

Entity-level tags override global ones -- `Opportunities` inherits `confidential` from the file header, then `restricted` takes precedence. The narrower the scope wins. Security classifications can be tightened at the entity level without touching the global default.

This YAML gets validated against a schema before it runs. That's the topic of the next post.

### Filename-as-metadata: the bet that pays

`Sales_Salesforce.yml` looks like a naming convention. It's a governance contract.

The natural instinct when registering a new source is to name it by origin: `Salesforce.yml`, `SAP.yml`, `Oracle.yml`. The source is unambiguous. Assigning a domain is not. Someone has to decide whether Salesforce data belongs to Sales, Revenue, or Customer Success, and those are different teams with different interests. That's exactly why we require it.

The filename forces a political question up front: who owns this data? Not later, not in a spreadsheet, not "we'll figure it out in Silver." Before the YAML can merge, someone has answered. The alternative -- letting data land anonymously in Bronze and arguing about ownership six months later, when a dashboard is wrong and no one knows who to escalate to -- is the default in most organizations, and it's also what erodes trust in the Lakehouse faster than any technical failure.

Requiring a domain gives you three things that source-only naming never could:

- **An owner and a steward, mandatory and named.** Every domain maps to a Product Owner and a Steward -- real people, not "IT." When an ingestion breaches its SLA, there's someone to notify. When a column's definition is disputed, there's someone to arbitrate. Accountability is encoded in the architecture, not relegated to a wiki page that nobody maintains.
- **Schema-level security.** The domain becomes the Lakehouse schema: `Sales_Salesforce`, `Finance_SAP`, `HR_Workday`. That's not cosmetic. Access can be granted to the `Sales` schema as a unit, and the whole domain is governed by the same ACL regardless of how many sources feed it. Try doing that when your schema is called `raw` or `staging`.
- **Natural clustering of entities that belong together.** Sales entities -- Opportunities, Products, Accounts -- share release calendars, business definitions, and consumption patterns. Grouping them by domain reflects the reality that they make sense together, and that ingesting them out of sync creates inconsistencies the business will feel downstream.

The risk is real. A typo in the filename, a renamed domain mid-project, a name that doesn't exist in the business glossary: any of these breaks the contract. The mitigation is boring: a CI check validates every new filename against an allow-list of approved domains and sources before the PR can merge. One linter, a few lines of code. The convention stops being a convention and becomes an enforceable contract.

Bronze stops being IT's problem. That's the bet that pays.

## The result: the tap works

Numbers from representative implementations -- order of magnitude, not SLAs:

- **Adding a new entity** -- typically under 15 minutes for a standard relational table; more for an API with pagination quirks or a file with a messy schema. YAML only, no code.
- **Configuration rollback** -- under 10 minutes. Revert the PR, redeploy the YAML.
- **100% of configuration versioned in Git.** This one isn't approximate: every change has an author, a reviewer, and a timestamp, because there's no other way to change config.

Two targets the architecture is designed for, and has to keep earning:

**Junior-engineer ergonomics.** Someone new to the project should be able to add a source by copying an existing YAML, changing what's different, and opening a PR -- without reading notebook code or touching PySpark. When that stops being true, the engine is leaking complexity back into the configuration.

**3am legibility.** When a load fails at 3am, the on-call engineer should open the YAML for the failing entity and understand what was supposed to happen, without digging into pipeline code. The configuration *is* the documentation.

When someone asks what your Bronze layer does, the best answer is: "nothing interesting." Boring Bronze isn't the goal; it's the consequence of engineering that's actually done. The excitement should live in what you build *on top*: Silver, Gold, semantic models, dashboards. Bronze is the invisible infrastructure that makes all of that possible.

## Honest tradeoffs

**Secrets and credentials -- out of scope by design.** The YAML never carries secrets. No hardcoded connection strings, no tokens, no API keys. If a source needs authentication, the YAML points to a Key Vault entry; the engine resolves it at runtime through a service principal. The moment a secret lands in Git, your audit trail becomes a liability instead of an asset. Ingestion config in Git, secrets in Key Vault -- two systems, zero overlap.

**The engine is a single point of failure.** Two hundred artisanal pipelines fail independently; a shared engine with a bug affects all two hundred sources at once. The mitigation surface is also shared (one fix heals all two hundred), but the blast radius is not symmetric -- invest in the engine's test coverage accordingly. A secondary effect: Fabric's per-pipeline logs become less useful when every entity runs under the same orchestrator object. You need your own control tables. That's Post 4.

## What's next

But making something boring requires solving problems that are not boring at all.

**Next: Metadata All the Way Down** -- Who validates the YAML? Who validates the validator? In a metadata-driven system, the metadata itself needs governance. It's metadata all the way down.

**The Scheduler's Contract** -- The engine runs. But when? And what guarantees that the data is fresh enough for downstream consumers? Latency as a contract, not a hope.

**Battle Scars** -- The YAML looked perfect in the PR. Then Spark 3.x rejected dates from 1753. Operational lessons and scars from production.

**Runbooks as Infrastructure** -- Every scar has a fix. That fix becomes a runbook: versioned, auditable, deployable on demand.

**Living Metadata** -- We capture metadata with every ingestion. But metadata that nobody reads is dead metadata. How to turn it into decisions.

---

*First post in the "YAML Metadata-Driven Ingestion" series. These patterns come from several enterprise Lakehouse implementations -- platform-agnostic, though our reference stack is Microsoft Fabric.*
