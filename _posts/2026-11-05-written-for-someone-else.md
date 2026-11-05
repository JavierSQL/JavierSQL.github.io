---
layout: post
title: "Written for Someone Else"
date: 2026-11-05 06:00:00-0600
description: "Eighty-two measure descriptions, all written by an agent, all approved. Most said nothing. Who were they written for?"
thumbnail: assets/img/feat-written-for-someone-else.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, metadata, ai-agents, rot-data]
categories: [who-decided-that]
---

![Written for Someone Else](/assets/img/feat-written-for-someone-else.webp)

*Eighty-two measure descriptions, all written by an agent, all approved. Most said nothing. Who were they written for?*

## Eighty-two descriptions

[Last time](/blog/2026/the-agent-chooses/) I guessed what an LLM would write if someone asked it to describe a table. I didn't have to guess for long.

On October 14 I reviewed the semantic model of a client. The client is a regional company with operations in several countries, and each country has its own currency. My own team at Primus built the model, and it was still in development. The team asked Claude to write the description of every column and every measure. Claude did this through the Power BI Authoring MCP server, which lets it read and edit a semantic model. The model had 443 columns and 82 measures, and every one had a description. A coverage report on that model would say 100%.

My team did what the tool makes easy. I would probably do the same in their seat. They asked for descriptions, got descriptions, and moved to the next ticket. This post isn't about them.

Here is one of the descriptions, translated from Spanish:

> **Accounts with Balance:** Count of distinct customer accounts with an outstanding balance as of the current cutoff.

Read it again. What did you learn? Nothing that the name didn't already tell you. My guess last time had the same shape: "Contains all inventory movements." I guessed the sentence. I didn't guess that 41 measures would look like it.

I counted the 82 measures one by one. 41 restated the name as a sentence, like that one. 28 added something true, but nothing a user could use. 13 said something false about the business. The three groups add up to 82. Broken references and stale numbers are a different kind of error, and they appear in all three groups. None of the 82 told a user when to use the measure, or what number it should match.

The accountants and the business users approved these descriptions. I return to that later.

## Before I go on

This post covers one model, one client, one tool, and one reviewer: me. I don't grade Claude against other tools. I didn't run a controlled experiment. Models from the same family that I use every day wrote these descriptions. I use them for this series too. This post doesn't say that AI is bad.

When I prepared this post, the research pointed at a specific danger: a fluent, plausible description that is false. Published work covers exactly that danger. (Terrenzi and Ayvaz published a preprint this July. They scored metadata that an LLM wrote on two axes: retrieval utility and semantic grounding. The version that was easiest to find was the least faithful. Only about half of its claims had support. Search improved through "unsupported semantic expansion rather than … more accurate dataset representation". Another LLM was the judge, not a person, which is its own small irony.) I expected to find that danger. I found it in 13 of 82. The bigger problem was in the other 69, and I didn't expect it.

## Six patterns

I classified the 82 in two ways. The three groups tell how wrong a description is. The six patterns below tell what a description contains. One description can contain several patterns. The 41 are the tautologies. Most of the 28 are mechanics and history. Broken references and DEV numbers can appear in any group. The columns followed the same patterns. In the branch dimension, almost all column descriptions were tautologies.

| Pattern | What it looks like | Why it fails the user |
|---|---|---|
| Tautology | "Taxable amount of the movements converted to dollars" | Repeats the name |
| DAX narration | "in the current filter context" appears about 40 times. "returns blank if there is more than one currency" appears about 35 times | The reader is the developer who wrote the DAX. Even the useful warnings use the developer's words |
| Numbers measured in DEV | "4,700,329 rows", "509,842 documents" | DEV has only part of the history. The numbers were wrong on day one and get older with every load |
| Development history | "Replaces the Transactions table" | The user never saw the old table |
| Broken references | Points to measures like [Total USD] or [Debit] | These measures don't exist. About 15 descriptions do this, in all three groups |
| No shared vocabulary | "Collected", "applied", "invoiced", "local currency" | Each measure defines these words again, with different wording each time |

If you read [the first post of this series](/blog/2026/the-rot-weighs/), you saw this table before, under another name: ROT. ROT is data that is redundant, obsolete or trivial. The DEV numbers and the development history were obsolete on the day someone wrote them. The broken references point at measures from early versions of the model. Those measures never reached production, so they were obsolete before anyone could use them. The tautologies are trivial: true, and empty. This is ROT metadata. This time it sits in the field that says *documented*.

Three patterns fill most of the field: the tautologies, the DAX narration, and the development history. The tautologies waste the reader's time. They also break a rule that DAMA wrote years ago: "do not define a term by using the term". The model breaks it 41 times. The DAX narration and the development history have the same cause.

## Who was in the room

Read the DAX narration, the development history, and the DEV numbers together. "In the current filter context." "Replaces the Transactions table." "4,700,329 rows." Who needs to know that?

The developer needs to know it. The developer was in the session with Claude. That person just wrote the DAX, renamed the table, and loaded DEV. The agent wrote for the person in the room, and the room was a development session. The descriptions are the log of the conversation that built the model. The log sits in the field where the definition should go.

The main defect is in the context. The model may share part of it. Nobody in that session knew what a collections analyst must read before using the measure. Nobody said it. The session had the DAX but not the business. (Microsoft's own Copilot for measure descriptions works the same way. [Its documentation](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-measure-copilot-descriptions) says that Copilot writes the description "based on the DAX formula". [The MCP server's own example prompt](https://learn.microsoft.com/en-us/power-bi/developer/mcp/power-bi-authoring-mcp) asks for "the logic behind the DAX in plain business terms".)

The 13 false descriptions have the same cause, seen from the other side. They failed where the name didn't help, or where the business uses a word in its own way. The agent guessed from the schema. The schema doesn't carry what that company means by that word. I don't show any of the 13, on purpose. The false ones are the ones that would identify the client. A wrong guess about a local term is local.

## What nobody wrote, because nobody decided it

The review continued past the descriptions. While I read them, I kept a second list. It holds rules that the model applies, or should apply, and that no description mentions.

- One balance measure used the filter "greater than zero". The correct filter is "not zero". A customer can have open credit notes or advances in their favor, and those are balances too. The developer read *balance* as *invoices*, because a balance is almost always invoices. The definition said one thing and the DAX said another. I wrote about this kind of quiet betrayal in [When Code Betrays the Model](/blog/2026/when-code-betrays-the-model/). Nobody recorded the rule, and I couldn't find who approved the version in the code.
- Which exchange rate applies: the rate on the invoice date, or the rate on the payment date? Nobody recorded the answer.
- Some documents keep a few cents in favor of the customer, or against the customer. Does a rule write off these amounts? Nobody recorded the answer. I don't know it either.
- Business days and holidays come from one country only. The model has no calendar for the other countries.

Read that list again. Each item on it is a decision. Somebody made some of these decisions at some point, and nobody recorded them. Nobody made the others. The code picked an option, and the code isn't a person. An agent can't describe a decision that nobody made. It can only describe the DAX that somebody happened to write. (This is the same problem as [a number without a perimeter](/blog/2026/the-number-without-perimeter/), one level higher.)

## The approval

The accountants and the users approved the descriptions earlier that week, without a single comment.

I don't know how they read them. I don't think the problem is them either. They received 82 measures, 443 columns, and paragraphs about filter context and blank values. That volume doesn't invite reading. You scroll, see that every field has text, and sign. I suspect that is what happened, because I would probably do the same. The requirement was met.

The approval worries me more than the tautologies. A model with 30% coverage and no descriptions on the rest is honest. You know what you don't know. A model with 100% coverage and a signature on it looks finished. The record shows the approval. It doesn't show whether anyone decided anything.

When I planned this series, the question for this post was: how many definitions in your catalog did an LLM write without human approval? This case answered with zero. Somebody approved every one of the 82. So the question was wrong. The useful question is: what is an approval worth when nobody can tell whether someone read the text?

(DAMA warned about this from the other side. When you reverse-engineer metadata from old systems, the biggest risk is "not knowing how much care was taken to develop and refine the definitions in the first place". That used to be a legacy problem. Now we create it for our own future, in the catalog we build this quarter.)

## People learn to ignore. Agents don't.

Ricardo, a colleague at Primus, likes to bring the factory floor into our design reviews. He uses two ideas. The first is Shigeo Shingo's *poka-yoke*: design the process so that the mistake is hard to make, or easy to see. The second is James Reason's two kinds of error. An active error fails immediately: the line stops, and somebody notices. A latent error stays quiet in the system. It fails later, in another place, in front of someone who had no part in it.

These descriptions are latent errors. In Reason's version, a latent condition comes from a decision far from the scene, by a designer or a manager. Here the latent condition comes from my second list: decisions that nobody made, under text that says nothing is missing. Nothing breaks today.

The users will be fine, more or less. One day they will show a wrong number to their boss. They learn what "Invoice Collected" really means in that company. They also learn a second lesson: the descriptions aren't worth reading. Then the analyst leaves the company, and the knowledge leaves too. Which balance excludes the credit notes? Which person in Credit and Collections can answer? The new analyst opens the model, and only the descriptions remain. At that moment, the latent error fails.

The LLM agent is that new analyst, every morning. Each session starts from zero. The agent opens the model. It reads that the movements table has 4,700,329 rows, or that a measure reconciles against [Total USD]. It believes both statements, because descriptions exist for that purpose. Both statements are false. The count comes from a trimmed DEV, and the measure doesn't exist. The new analyst gets burned once and stops trusting the field. The agent gets the same text in every session, with the catalog's approval and no sign of error. It doesn't learn the way the analyst did. At best, someone writes the lesson for the agent. But to record that lesson was the job of the description from the start.

Exclude the stale numbers and the broken references. The other 69 descriptions can't fool the agent. They cost it something quieter: tokens. This text doesn't lie about the business, and it doesn't help either. You pay for it once when you write it. You pay again every time an agent loads the model, forever. Nobody decided that it should be there.

## What a description should say

The rewrite of the descriptions gave me a recipe. It is crude, but it works, and it has five lines:

1. **What it is in the business**, in the company's own vocabulary. This line gives meaning.
2. **When to use it, when not to use it, and what to use instead.** This line gives the perimeter.
3. **The trap**: sentinel values, filters that remove rows, currency. This line also gives the perimeter.
4. **What it reconciles against**: the report or the ERP figure that it must match. This line gives a check.
5. **Who decides**: the owner of the rule. Write the owner where the owner changes. Usually that is on the table, once for all its measures. Write it on a single measure only when that measure is the exception.

The same owner on 82 measures is noise. But without an owner, nobody could answer questions about the "greater than zero" filter.

Ricardo's ideas apply to the recipe too. The fixed order is a standard. Meaning goes first so a reader can stop early. The owner goes last because you need the owner only when something looks wrong. [Microsoft's own guidance](https://learn.microsoft.com/en-us/power-bi/create-reports/copilot-evaluate-data) agrees about meaning first. It adds that Copilot reads only the first 200 characters. Line four makes the description checkable. Line five gives the next "greater than zero" filter a person who must approve it.

Here is one measure, before and after. I changed the names and the ERP field.

> **Invoice Collected**
>
> **Before (written by the agent):** Total amount collected and applied directly against invoices in the settlements of the current filter context. Returns blank if there is more than one currency in context.
>
> **After:** Principal of credit invoices that customers paid at the cashier with a cash receipt, in the invoice's currency and by receipt date. It doesn't include interest ([Interest Settled]), change given back, cash sales, or applied credit notes, which aren't collections. Use it to measure portfolio recovery by period, branch or customer. For everything that came into the cashier by any means of payment, use [Cash Received]. Limits: with several currencies on the report it shows blank (filter one currency); it has no dollar or local-currency version. Source: the ERP's settlements table, invoice total field. By invoice, it matches [Applied Collections], except for interest and reversals. ERP control figure: **to be defined with Credit and Collections.**

The currency warning survived. The agent wrote it too: "Returns blank if there is more than one currency in context." The fact is the same, but the reader is different. The agent's version tells you what the DAX does. The new version tells you what to do about it.

The last line shows that half of line four is still open. The description names the measure that it matches, but not the ERP figure. The description states this gap openly. It also names who must close the gap: Credit and Collections, the owner from line five. We write the owner on the table. It appears here only because it has work pending. The agent's description doesn't mention any gap, because the DAX shows no gap.

How did we write the "after"? We used AI, but in a different way from the 82. First I wrote two or three pages of business context: where the company operates, how it sells and collects, and its technical limits. This context is my reading of the business as a data architect. DAMA describes this role as the bridge between business strategy and technology. Then an agent profiled the main attributes with SQL. We gave the AI the recipe, the context, and the profile. We asked it for questions instead of descriptions. It returned about 45 questions. The senior developer and I answered a little over 20. We didn't know the answers to the other 20 or so. An hour with the data stewards and IT answered all but four. Those four went to research. The result is the version that we will release soon. This time, the business was in the room.

The "after" is about five times longer, so it costs about five times the tokens. Copilot reads little more than its first sentence, which is why the meaning goes there. The analyst and the agent read the rest. Those tokens buy something. Text that doesn't help wastes tokens, in every session.

## My own house

At Primus Data, most business rules live in silver, in two metadata tables. One table holds the rules, and the other holds their dependencies. Each rule has governance columns: domain, entity, owner, and dates. It also has three fields: a name, a description in business terms for the user, and the logic in code or pseudocode for the developer. We maintain these tables as part of the deliverable. If you write a stored procedure, a view or a notebook, you also ship the inserts and updates to the rules repository.

We built the repository for governance. Its purpose is to keep the business request and our code in agreement. Recently it got a second job. Agents read the rules to understand what the code does, without reading the code.

Our repository has two fields: one for the user, one for the developer. The agent that wrote the 82 descriptions had one field and two readers. It wrote for the reader in the room. We already have separate fields for the two readers, but only in silver.

My own practice has a gap. The "greater than zero" filter wasn't in silver. The developer applied it in DAX, in the semantic model, one layer beyond the reach of our practice. The repository never saw the filter. So nobody approved it, and nothing described it. I didn't see that gap before this review.

The fix is to change what the AI reads when it writes descriptions. A description from the DAX is a guess. A description from rules that the business approved is a translation. The tool stays the same, and only the source changes. The agent stops inventing meaning. It carries a decision that somebody made, with the owner already attached. The rules repository already does this for our semantic models. A developer and an AI work together on it, not an agent alone. The filter in DAX shows the limit: the method works only for the rules that reach the repository.

When a rule isn't in the repository, the AI has a different job. It asks questions instead of writing descriptions. We wrote the "after" this way, and the questions found more than descriptions. Our goal was to fix text. But four or five answers changed rules in the repository, and the code changed with them. These were requirements that we refined late. The four open questions look similar. In those places, the software doesn't do what the stewards believed. The product owners must decide what to change: the data model, the software, or the business process. These are items from my second list, and they appeared on schedule.

Terrenzi and Ayvaz found the same lever in their research. When the model rewrote metadata from a profile of the actual data, supported claims increased from about half to more than 80%. Grounding works. Our repository gives grounding one level higher: in what somebody decided the data means.

"Approved by whom?" is a fair question here, after what I said about the 82. A developer writes each rule from the requirement and from the code. The product owner approves the rules in small batches, one entity or one group of measures at a time. Each batch follows a code review with the data stewards. The rules live in SQL, and the approved version lives in a versioned document. At the end of every sprint, an agent checks that the two still agree. Somebody can sign a small batch without reading it too. But that is much harder after an hour of argument about those same rules with the stewards.

## Your Monday worksheet

> **Who wrote this definition?** Thirty minutes, one model.
>
> 1. Pick the ten measures that your users or your agent use most often. Sort by use, not alphabetically.
> 2. Mark each measure with one of five labels:
>    - **tautology**: repeats the name.
>    - **mechanics**: explains the DAX or the pipeline.
>    - **history**: tells how someone built it.
>    - **false**: says something false about the business.
>    - **useful**.
>
>    Separately, flag anything **stale**: DEV numbers, or references to measures that don't exist. Stale text fools an agent.
> 3. For the useful ones, check the first four lines of the recipe: meaning, when to use it, the trap, and what it reconciles against. Count how many have all four.
> 4. Add four properties as metadata, not as prose: `author_type` (human, AI, AI-edited), `reviewed_by`, `reviewed_on`, and `owner`. In Power BI, use an annotation. In other tools, use a tag. An Accept button isn't enough:
>    - No tool that I found records who checked the text.
>    - An agent that edits through MCP never sees the button.
>    - Git history (if your model is in TMDL) shows the developer, not the business.
>
>    `owner` and `reviewed_by` are different people. The reviewer checked the text. The owner decides the rule. Put `owner` on each dimension. Put it once on the table that holds the process's measures. Put it on a measure only when another person owns that rule. For example, in a collections model, a customer count can belong to the owner of the customer, not to collections.
> 5. Optional, for the developers: at the top of the DAX of each measure with a business rule, add a one-line comment. The comment says who approves changes. Users never see it, and Copilot ignores DAX comments when it writes descriptions. But the agent that edits the model reads the expression. So the warning reaches the reader who was in the room.
> 6. Report coverage as two numbers. The first counts descriptions that a person who knows the business reviewed. The second counts everything else. Only the first number counts. (DAMA's metric for documentation quality already has two parts. The automatic part is "the percentage of attributes that have definitions". The manual part is a "random or complete survey". Coverage reports run only the easy part.)
> 7. Put every DAX rule that filters, derives or converts into a rules repository, with its owner. If you have no repository, start one in SQL, Excel or Markdown. With the right prompt, an AI can read your SQL, notebooks and DAX and find the business rules in them. The result is a first draft for the owners to decide on. If a rule isn't in the repository, nobody decided it.
> 8. Before an agent reads the model, give every measure it will see a name in `reviewed_by`. Also give it an `owner`, its own or from its table.
>
> My rule of thumb: if fewer than half of the ten have the first four lines, the coverage number is decoration.
>
> The last post of this series asks what that owner owes you once an agent reads their rules.

## Who wrote that description?

Who decided that the description of "Accounts with Balance" would repeat its name? Nobody. Who decided that the balance would exclude the customer's credit notes? A developer, without knowing they were deciding. Nobody approved it. Who approved 82 descriptions? Everyone, including me. It was my team's delivery. The record doesn't say what each of them decided. The requirement was met.

The first post was about data that weighs. The second post was about data that competes for the agent's attention. This post closes the first part of the series. Its subject is data in disguise: documented, approved, at 100%, and written for someone else.

The next post looks at the other side: not everything that looks like ROT data is ROT.

*This is the third of ten posts in* Who Decided That? *The cloud and AI made it cheap to create, copy and keep data. They didn't make it any cheaper to decide.*
