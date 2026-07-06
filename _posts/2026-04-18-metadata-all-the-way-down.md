---
layout: post
title: "Metadata All the Way Down"
date: 2026-04-18 09:00:00
description: "Governing your ingestion metadata with more metadata -- and knowing which metadata is which"
thumbnail: assets/img/feat-metadata-all-the-way-down.jpg
tags: [metadata, governance, validation, yaml, microsoft-fabric]
categories: [yaml-ingestion]
giscus_comments: true
---

A tap isn't reliable because someone installed it well. It's reliable because there's a **building code** that specifies how it must be installed. There's an inspector who verifies the installation. There's a certification seal on the fitting. There's a record -- in a filing cabinet somewhere -- of who approved the permit and when. Layers of governance verifying other layers of governance. Nobody trusts a single layer. Not in plumbing. Not in metadata.

Last post, I said the YAML gets validated against a schema before it runs. Today I open that box.

In a metadata-driven system, the metadata itself is an artifact that needs governance. And that governance is provided by… more metadata. It's metadata all the way down -- but not all metadata plays the same role, and confusing the two is how these models stop feeling clean and start feeling like a filing system someone forced on a whiteboard.

The YAML from Post 1, however elegant, is worth nothing without the layers that surround it.

## The frame: origin, not use

> "It is best to think of these categories in relation to where Metadata originates, rather than how it is used." -- DMBOK v2, Ch. 12 (Metadata Management), §1.3.2 *Types of Metadata*, p. 422

The easy mistake when modeling metadata is to group it by **use**: "this helps me classify," "this helps me validate," "this helps me audit." Each grouping is tempting because it mirrors how the metadata *feels* in the moment you consume it. But the groupings cross-cut. A single tag crosses tool boundaries -- security scanners, governance dashboards, documentation systems. A single log row ends up in ops dashboards and lineage graphs, and in quality reports that don't exist yet. Use is a web, not a hierarchy.

Origin is a hierarchy. Ask a different question: *where was this metadata born?*

In our system, two origins matter:

- **Configuration metadata** -- born from the declarative contract. Lives in Git. Edited by humans. Changed via PR. Governs *what and how* you ingest. Its cadence is the cadence of engineering decisions: new entity, new source, new classification rule.
- **Operational metadata** -- born from execution. Generated as a side effect. Never hand-edited. Records *what happened* when you ingested. Its cadence is the cadence of the runtime: every run, every entity, every quarantine event.

They look similar from the outside -- both are "structured data about data." But they answer to different masters. Configuration metadata answers to code review. Operational metadata answers to the engine that produced it.

This post is about the first origin. The configuration stack has four layers, each with a distinct role. Operational metadata is a different animal with a different story, and I'll get to it in Post 4.

## The four layers

The model, in one table:

| Layer                    | What it is                                        | Where it lives          | Example                                   |
| ------------------------ | ------------------------------------------------- | ----------------------- | ----------------------------------------- |
| **L1** YAML              | The declarative contract itself                   | Git, `config/`          | `Sales_Salesforce.yml`                    |
| **L2** Tags              | Classification metadata embedded inside the YAML  | Inside the YAML file    | `security.sensitivity: "PII"`             |
| **L3** Naming convention | Metadata that governs the YAML from outside       | Filename + CI linter    | `{Domain}_{Source}.yml`                   |
| **L4** Yamale            | The metamodel that validates the YAML's structure | `ingestion_schema.yaml` | `source_type: enum("relational", "file")` |

The ordering is intentional: inside-out from the YAML.

- **L1** is the artifact. The thing you commit.
- **L2** lives *inside* the artifact. Tags are embedded in the YAML itself, riding along with every entity.
- **L3** governs the artifact *from outside*. The filename is metadata the YAML can't contain -- it's the identity of the file, not its content.
- **L4** is the *metamodel*. Metadata about the structure of the metadata. One level more abstract than anything below it.

A useful observation: stability increases as you move outward. The YAML's content changes every time you add an entity. Tags change when governance reclassifies. The naming convention barely ever changes. The Yamale schema changes only when the standard evolves -- quarterly, not weekly. This isn't accidental. The outer layers are the foundations; they're the parts you *don't* want to renegotiate often. The inner layers are the parts that need to evolve with the business.

A second observation, less obvious: the layers don't stack in the direction of "importance." They stack in the direction of "abstraction." L1 isn't more important than L4; it's more concrete. L4 isn't more important than L1; it's more abstract. Each layer does a job the others can't. Remove any one and the system degrades in a specific, predictable way:

- Remove L2 and you have to catalog after the fact.
- Remove L3 and identity drifts from content.
- Remove L4 and structural typos slip past review into runtime.
- Remove L1 and ingestion collapses back to one pipeline per source -- the problem the series opened with.

Let's walk the four layers with the problem each one solves.

## Layer 1: The YAML as contract

Post 1 covered L1 in depth. What it didn't answer is *what governs the contract itself* -- and each of the next three layers resolves a different question L1 alone can't:

- How do we classify the content (PII, ownership, sensitivity)? → **L2 Tags**
- How do we keep the YAML's identity consistent with its content? → **L3 Naming convention**
- How do we make sure the YAML is well-formed before it runs? → **L4 Yamale** (an open-source YAML schema validator -- more on it below)

## Layer 2 -- Tags: metadata-in-transit

Tags travel *inside* the YAML, but their destination isn't the ingestion engine -- it's the external governance system.

```yaml
config:
  tags:
    security.sensitivity: "confidential"
    governance.data_owner: "Sales"

entities:
  - name: Opportunities
    tags:
      security.sensitivity: "restricted"       # overrides global tag
      security.classification: "PII"   
```

The pattern is inheritance with override. The `config.tags` block defines defaults that apply to every entity in the YAML. An individual entity can override a specific tag when it needs to -- Opportunities is PII even if the rest of the source is merely confidential. The common case is cheap (one declaration covers everything); the special case is explicit (one line where it matters).

Why this matters: classification isn't a step that happens later. It's born with the configuration. By the time an entity lands in Bronze, it already carries its governance label. There's no "we'll tag it after we profile it" phase -- and anyone who's worked in a large enterprise knows that phase is where classification goes to die.

The metaphor: a letter inside an envelope. The YAML is the envelope -- edited in Git, copied into the Lakehouse at deploy as a read-only artifact, opened there by the engine at runtime. The tags are the letter inside: once the engine lands the data, the tags ride along with it to the security scanner, the governance dashboard, the compliance report. The envelope stops at the Lakehouse; the letter keeps going.

The honest tension: deciding which tags are global and which are per-entity is a conversation with governance, not a code decision. It takes longer than engineering teams expect. Once that conversation converges, the inheritance pattern protects the outcome -- but skipping the conversation produces either a YAML where everything is tagged "confidential" (useless) or a YAML where every entity redeclares every tag (brittle).

**Another traveler: template version.** Not every piece of metadata inside the YAML is a tag. `template_version: "1.0"` is a versioning field -- also embedded in L1, also metadata-in-transit, but its destination is the engine, not a governance system. When the contract needs to grow -- a new section, a new required field -- you publish `"2.0"` and the engine learns to process both. Existing YAMLs don't break; new ones adopt the current version. Semantic versioning for your metadata contracts: the same discipline that lets APIs evolve without breaking clients lets your ingestion contract evolve without breaking the YAMLs already in production.

## Layer 3: The filename as a governance contract

Post 1 introduced filename-as-metadata as a design principle. Here it earns its place as a governance layer.

The mechanism: `Sales_Salesforce.yml` is not a name -- it's a contract. Domain=Sales, source=Salesforce. The Lakehouse schema is **derived** from the filename, never configured manually. The YAML doesn't duplicate those attributes. It *can't* contradict them. The identity of the file and the content of the file are reconciled by construction, not by review.

Why this is governance: it eliminates an entire category of inconsistency -- the kind where the YAML says one thing, the filename says another, and you only find out when a downstream query returns zero rows. Removing a whole class of bugs by making them unrepresentable is worth more than any amount of validation that catches them after the fact.

Patterns observed across projects:

| Pattern                       | Example                 | When it fits                                           |
| ----------------------------- | ----------------------- | ------------------------------------------------------ |
| `{Domain}_{Source}`           | `Sales_Salesforce.yml`  | One implementation per source (the common case)        |
| `{Source}_{Domain}`           | `ERP_Finance.yml`       | Orgs where the source is the primary navigational axis |
| `{Source}_{Country}_{Domain}` | `SAP_MX_Accounting.yml` | Multi-country, same source, regional implementations   |

The invariant: domain and source are always explicit. Country is optional and project-specific. The schema name is always *derived*, never *configured*. That last rule is what turns a convention into a contract -- if you can't override the schema name in the YAML, the filename wins by construction.

## Layer 4 -- Yamale: the unit test for your metadata

Post 1 said the YAML gets validated against a schema. This is how.

The problem it solves: without validation, a typo -- `source_tipe: relational` instead of `source_type` -- passes silently and fails at runtime, in production, after the PR is merged and everyone's moved on. The YAML was "valid" by YAML grammar. It just didn't mean what the engine expected it to mean.

Yamale in one sentence: a declarative schema defining the valid structure of your YAML -- types, enums, required fields, optional fields, nested shapes. Written in YAML itself, because the metamodel of the metadata wants to look like the metadata.

```yaml
config:
  template_version: str(required=True)
  source_type: enum("relational", "file", required=True)
  source_system: map(required=True)
  tags: map(required=False)

entities: list(required=True)
entities.*.name: str(required=True)
entities.*.query: str(required=False)
entities.*.path: str(required=False)
entities.*.tags: map(required=False)
```

Where it runs: in the GitOps flow, pre-deploy. If Yamale fails, the YAML never reaches the Lakehouse. It's a **gate**, not a log. The feedback lands in the PR, while the author is still in context, not in production weeks later when they've forgotten the change entirely.

Yamale is the unit test for your metadata. If the YAML is the contract between configuration and execution, Yamale is the linter of the contract.

The honest limitation: Yamale validates *structure*, not *conditional semantics*. It can say "query must be a string." It can't say "if source_type is relational, then query is required, but if source_type is file, then path is required." Rules with an `if` in them can't live in a schema -- at least not without turning the schema into a second programming language.

The solution: two-layer validation. Yamale validates structure pre-deploy. The notebook validates conditional rules at runtime. Each layer does what it knows how to do, and neither layer pretends to be the other. The trade-off is conscious: Yamale stays simple and declarative; the conditional rules live in the engine where `if` statements are cheap.

A question worth asking: where do you put the cut between declarative and imperative validation? There's no universal answer -- but there is a principle: *if the rule can be expressed without logic, it goes in the schema. If it needs an `if`, it goes in code.* That line is the one that keeps schemas from rotting into ad hoc DSLs.

## The four layers in one picture

{% include figure.liquid loading="eager" path="assets/img/yaml-four-layers.png" class="img-fluid rounded z-depth-1" zoomable=true %}
<div class="caption">The four layers of metadata governance: the YAML artifact (L1) carries tags and template_version (L2), is named from outside by the filename (L3), and validated pre-deploy by the Yamale metamodel (L4).</div>

Four layers, four roles. L2 rides inside L1 as classification payload. L3 names L1 from outside. L4 validates L1's shape from above. Each one does something the other three can't.

*Each layer originates somewhere different. That's what keeps their roles from collapsing into one.*

## Trust built layer by layer

None of these layers were planned on day one. Each emerged from a real problem. The typo that took down an overnight load. The YAML that passed review while an entity was quietly renamed from lowercase to Pascal Case -- valid YAML, silent zero rows downstream. The schema that kept pointing to a two-character status field after the source renamed it to three -- data flowed, nothing broke, everything was wrong. The tag that existed only in a spreadsheet and was forgotten when the entity went to production. Each bruise was an argument for a layer.

Back to the metaphor from Post 1: Bronze should be boring. Now you know what it takes to make it boring *reliably*. The tap isn't just functional -- you can demonstrate *why* it works, *who* approved it, and *what happens* if something changes. That's not bureaucracy. That's what it looks like when trust is an engineered property instead of a social one.

"Metadata all the way down" sounds like a philosophical joke. In production, it's a survival strategy.

## What's next

**Post 3 -- The Scheduler's Contract:** Freshness as a contract. One engine, N entities, one scheduler. How frequency, priority, and dependency are configured -- not coded -- and why the scheduler creates a new failure mode the engine had to design for: the zombie lock.

**Post 4 -- Battle Scars:** The YAML looked perfect in the PR. Then Spark 3.x rejected a date from year 8 -- corruption that had been hiding for months, a pipeline crashed and left a lock that blocked everything for six hours, and the YAML in Git turned out not to be the one running in the Lakehouse. Operational lessons and production scars.

---

*This is the second post in the series "YAML Metadata-Driven Ingestion." The patterns described here have evolved across several enterprise Lakehouse implementations and are platform-agnostic, though our reference platform is Microsoft Fabric.*
