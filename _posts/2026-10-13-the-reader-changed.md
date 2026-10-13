---
layout: post
title: "The Reader Changed"
date: 2026-10-13 06:00:00-0600
description: "I closed Trust Erosion saying the fix is a better reader. Then the reader changed: now it's an AI agent, and it doesn't ask questions."
thumbnail: assets/img/feat-the-reader-changed.webp
tags: [data-governance, data-management, business-intelligence, master-data, metadata, ai-agents]
categories: [trust-erosion]
---

![The Reader Changed](/assets/img/feat-the-reader-changed.webp)

*I closed Trust Erosion saying the fix is a better reader. Then the reader changed: now it's an AI agent, and it doesn't ask questions.*

## A puppy named Hugo

October 8, 2026. I was watching Data Hero Summit 2026, Profisee's virtual event, from my desk in Costa Rica. I don't sell Profisee and have no relationship with the company. Malcolm Hawker, their Chief Data Officer, gave the keynote, *What Is Trust Made Of*. He works with some of the largest companies in the world. I work with mid-sized companies in Central America. We've never met, and he was describing the data platforms I see every week.

The audio failed for the first few minutes, so what I have from the opening is a screenshot. A puppy in comic-book style, a black-and-white terrier with big eyes, and a speech bubble: "Your new AI agent. Knows a lot about a lot of things. About your business? Practically nothing." His name is Hugo. (Hugo is also an acronym on the slide -- Harmonize, Unify, Govern, Orchestrate. That's the vendor part, and I'll leave it there.)

![Comic-style slide from Malcolm Hawker's keynote: Hugo, a black-and-white terrier puppy, with the caption "Your new AI agent. Knows a lot about a lot of things. About your business? Practically nothing."](/assets/img/the-reader-changed-hugo.webp)

I didn't need the audio. Hugo is ungrounded. He'll bring you something every time you throw the ball, with total enthusiasm, and he has no way of knowing whether it was the ball.

A few slides later the sound was back, and so was Hugo's work: "The answers looked perfect. And they were quietly, confidently wrong."

I smiled. A week earlier I had closed a series on that same idea, minus the dog. Nobody borrowed from anybody. When someone looking at global corporations and someone looking at a distributor in Costa Rica describe the same failure on their own, it stops being an opinion. It's how modern data platforms work now.

## The fix I proposed

*Trust Erosion* ended on October 1st. Ten posts taking apart numbers that lied: a definition everyone signed and nobody shared, a table that stopped matching its concept, a sum of things that couldn't be summed, a metric gamed for a bonus. I closed the series with one sentence, and I still believe it: *the fix was never a better number. The fix is a better reader.* The engineers who interrogated the sensor before trusting it. The analyst who asks what the dashboard is wired to.

Hugo doesn't ask questions. An agent has no posture. It doesn't feel the small discomfort you feel when a number is too round, and it can't tell that a reading should bother it. It reads labels and fetches.

So my fix has a problem. The reader changed.

Hawker said it better than I would have: "AI didn't create this problem. AI is magnifying it." I've been saying the same thing from the other end for years: every technology wave gives us a fresh chance to repeat the same old mistakes. This wave repeats them faster, at scale, with perfect formatting.

## Why the source matters

The center of the keynote was an article Anthropic published on June 3: [*How Anthropic Enables Self-Service Data Analytics with Claude*](https://claude.com/resources/articles/how-anthropic-enables-self-service-data-analytics-with-claude). Hawker's point was *who* wrote it. Not a consultancy selling data governance, not an MDM vendor: the company that builds the model, trying to get its own analytics agents to stop giving wrong answers. And where did they end up? At data foundations. So that's two of us, from very different vantage points, and a third from inside the model.

It's a product article too. It sits on Anthropic's site, filed under Claude Code, and the jump it reports comes from a feature they sell. But look at what the feature does. Skills don't make the model smarter; they tell it which tables are canonical, who owns which definition and what to read first. Without them, their own model never got past 21% on their evals. With them, it stays above 95%. A model company telling you the model alone isn't enough is worth more than a data vendor telling you the same.

Two disclosures before I recommend it. I'm a consultant who makes a living from data foundations, and I write these posts with Claude. Discount accordingly. Even so: if you work with data and generative AI, this article is required reading. It isn't new. It's the clearest field report I've seen on what an agent needs before you can trust it.

## What they found

They name three failures. The first, which they call "by far the most common", is that the agent can't map a business concept to the single correct table. The second is staleness: sources, definitions and schemas change, and the agent's knowledge quietly falls behind. The third is retrieval: the right answer is in the model, documented, and the agent simply doesn't find it.

The finding I keep going back to is an experiment. They gave the agent grep access to thousands of SQL files -- dashboards, transformations, analysts' notebooks -- every piece of prior work they had. Accuracy moved less than a point. Their conclusion: "our bottleneck wasn't access to prior work, it was structure."

More access didn't help. Naming things did.

They also test like engineers: evals pinned to a snapshot date so the answer can't drift under them, and no domain goes live until its agent clears a threshold (they started at about 90%). That's data quality with a different name. It deserves its own post, and I'll leave it out of this one.

## The same stack, in our vocabulary

Here's the part the speakers saw and I agree with: almost nothing in the article is new to data management. It just doesn't use our words. Below is the map. The third column is where I wrote about it from the human side, in *Trust Erosion*. The fourth is where I'll write about it from the agent's side, in the series that starts next week.

| What Anthropic calls it | What data management calls it | *Trust Erosion* (the human reader) | *Who Decided That?* (the agent reader) |
|---|---|---|---|
| Concept-entity ambiguity | Business glossary, metadata, master data | [False Semantic Consensus](https://javierloria.com/blog/2026/false-semantic-consensus/) · [The Table Is Not the Concept](https://javierloria.com/blog/2026/the-table-is-not-the-concept/) · [Your Glossary Isn't Semantics](https://javierloria.com/blog/2026/your-glossary-isnt-semantics/) | The agent that picks the table by its name |
| Canonical datasets, the agent "structurally routed to them first" | System of record, trusted source | [The Number Without Perimeter](https://javierloria.com/blog/2026/the-number-without-perimeter/) | Authority as an eligibility rule, not a ranking signal |
| Data staleness: accuracy drifted from ~95% to ~65% over a month | Metadata currency | -- | -- |
| Deprecated models in the lineage graph | ROT data, retirement | -- | Why nobody deletes, and why the old table still competes |
| LLM-generated metric definitions that "encoded the very ambiguities we were trying to eliminate" | Metadata stewardship | [The Metric as Mirror, Not Window](https://javierloria.com/blog/2026/the-metric-as-mirror-not-window/) | One AI documents, another AI chooses |
| A provenance footer: source tier, freshness, owner | Lineage, data owner | [The Number Without Perimeter](https://javierloria.com/blog/2026/the-number-without-perimeter/) | When the agent is wrong, who answers |
| Business context: a knowledge graph of docs, roadmaps and decision logs | Business metadata | -- | *Who Decided That?*: the whole series |
| Harvesting every stakeholder correction into a fix for the domain owner | Issue management, data quality | [The Discipline of Distrust](https://javierloria.com/blog/2026/the-discipline-of-distrust/) | When the agent is wrong, who answers |

Notice the decision logs. Anthropic had to write down who decided what, so the agent could read it. Hugo knows nothing about your business because, in most companies, those decisions were never written anywhere.

Look at the last row, because it's the one that settles my problem with Hugo. Anthropic kept the better reader. A scheduled agent scans their stakeholder channels every few hours for people correcting an answer, drafts a one-line fix to the documentation, and opens a pull request tagged to the person who owns that domain. Look closer, though, and that person is no longer optional. The whole correction loop starts when somebody in that channel reads a well-formatted answer and doesn't believe it. At 95%, that's one answer in twenty, and it lands in front of someone who asked precisely because they didn't want to check. Anthropic didn't replace the better reader. They made the system depend on one.

## Meaning and truth

Hawker's frame for the whole keynote was two words. Trustworthy AI needs *meaning* and *truth*, and in his view the industry is buying the first and forgetting the second. *Meaning* is what a customer is: does "active customer" mean someone who logged in, or someone under contract? *Truth* is which customers are real: are these 200 records 200 companies, or 80 wearing new names? You need both. One slide put it bluntly: "Meaning without truth is confusion."

The fourth session of the day, *Your AI Agent Is Confidently Wrong About Your Biggest Customer*, turned that into a case. An agent is asked for a brief on a key account. It queries the CRM, the call recordings, the customer success platform, and comes back with a confident, well-formatted answer that would have cost a renewal. It couldn't tell that four differently named companies were one corporate family, or that seven CRM records were four customers.

I agree with the split. I disagree with two things: the word *truth*, and the order. Since I'm about to tag him, I'd rather say why than nod along.

My first *Trust Erosion* post had the mirror image. A chemicals distributor in Costa Rica, about 1,800 records in the customer base, and barely 200 of them were active customers. Every sale in that base had happened and was correctly recorded. By Hawker's split, the records were true. The count was still wrong, because nobody had decided what a customer was. So I'd add the other half to his slide: truth without meaning is a perfectly clean list of things nobody defined.

Then the order. Hawker's build path goes from identity resolution to shared business concepts. I'd go the other way, and the fourth session's own case is why. Is "four differently named companies are one customer" a fact about the records, or a decision about the definition? It depends on whether your customer is the legal entity that signs the invoice or the corporate family that negotiates the renewal. Match those records before you decide, and the algorithm decides for you. You can't resolve the identity until you've settled the meaning. In the distributor, the definition of an active customer came first, and nobody had deduplicated anything yet.

That's why I'd call the second layer *identity*, not *truth*. DAMA's own master data chapter warns that "golden record" is a misleading term and prefers *trusted source*: a source you've decided to trust, not one that holds the truth. Truth sounds like something you discover. Identity is something somebody decides, and writes down, and answers for.

(We agree on the layers and on his main point: without identity, the agent fails. We disagree on the name of one and on which you build first.)

**The lesson:** meaning comes first, identity second, and both are decisions before they're data.

## What I think is missing

The article is honest about its context, so this isn't a criticism of what they built. It's a list of what that context gave them and yours probably won't.

They have one repository. Nearly all their data code -- models, semantic layer, documentation, dashboards -- lives together, and about 90% of their data-model changes update the agent's documentation in the same pull request. Your logic probably lives in an ERP you don't own and in code nobody has read in years. I've just watched an agent build a whole model on the wrong table, and the table's name was the reason. That story gets its own post.

They have a mandate. Their governance, in their words, "only holds if the canonical models and metric definitions are enforced by tooling (the agent is structurally routed to them first), by CI, and by mandate." Somebody at Anthropic could say: this is the table, use it. In most companies I work with, nobody has the authority to say that, or nobody wants to spend it.

They deprecate, but the article never says they delete. Their lineage graph tells the agent which models are deprecated. That's good, and it's more than most companies do. But a deprecated table is still a table. It still answers to its name, and the next agent, or the next analyst with a notebook, can still find it. Marking something old is a decision anyone can make. Deleting it needs an owner.

They list access controls and data privacy among the design questions and stop there. Two questions the next agent will raise stay open: what it should never have been allowed to read, and what happens when a document it reads gives it an order.

Then there's the vocabulary. They rebuilt master data, metadata management and data quality and called them canonical datasets, reference docs and evals. That's fine for Anthropic. For your CFO it can be expensive: reading it, they may not recognize that the governance budget they keep postponing is their AI readiness budget.

## Somebody decided

Here's what the article proves, I think, without meaning to. Anthropic's agents reach 95% because somebody decided: which table is canonical, who owns each definition, where a correction goes, what the agent reads first. The model didn't make those decisions. People did, and wrote them down.

Now ask the same question about your data. Who decided that the old sales table would stay? Who wrote the description the agent reads? Who approved what it can see? Who answers when it's wrong?

In most companies, the answer to all four is the same. Nobody.

That's the next series. It's called *Who Decided That?*, ten posts in four parts: the ROT data the agent competes with, deciding what to keep, what the model reads, and who answers. The cloud and AI made it cheap to create, copy and keep data. They didn't make it any cheaper to decide.

Trust Erosion asked who reads the number. This one asks who decided what the agent reads.

## Before you point an agent at your data

> Five questions. If you can't answer one, that's where to start.
>
> 1. For the domain you want the agent in, how many canonical datasets do you have, and who declared them canonical?
> 2. For each metric the agent will use, is the owner a person or "the team"?
> 3. What share of the agent's answers go through your semantic model rather than raw tables?
> 4. When someone corrects the agent, where does that correction go? If the answer is "the chat history", it goes nowhere.
> 5. Who in your company can *mandate* that the canonical table is the one everybody uses?
>
> Anthropic's own advice for starting from zero is short: a handful of canonical datasets, a few dozen evals, and a thin layer of documentation the agent reads first. None of that is a model problem.
