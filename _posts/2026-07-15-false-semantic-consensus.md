---
layout: post
title: "False Semantic Consensus"
date: 2026-07-15 09:00:00
description: "Everyone agreed on the number. That was the problem."
thumbnail: assets/img/feat-false-semantic-consensus.webp
tags: [semantic-modeling, data-governance, data-modeling, data-ethics, dmbok]
categories: [trust-erosion]
---

![False Semantic Consensus](/assets/img/feat-false-semantic-consensus.webp)

*Everyone agreed on the number. That was the problem.*

About fifteen years ago, at a banana company in Costa Rica, I was in a formal review meeting with the General Manager and the CFO. At that company the General Manager also carries the production role, so there were two ways of seeing the same report at that table: he saw output, the CFO saw money.

The General Manager said it himself, almost in passing: he had that farm marked. He was eyeing it for the following year.

The farm was producing well. Good yield, healthy operation, the kind of farm you want more of. But in the consolidated report it showed up in red. Deficit. A candidate for the cut list, with the General Manager already looking at it.

The number wasn't miscalculated. It was misdefined.

And here's the part that should bother you: nobody had noticed. Finance, Operations, Research, Legal. Everyone had looked at that report and signed off on it. Not one person objected. They were all staring at the same word, "farm," and they were all certain they were talking about the same thing.

The report carried everyone's signature. It was also wrong. Those two facts lived together comfortably for months.

## One word, four meanings

When we pulled the thread, "farm" turned out to mean four different things, and every one of them was legitimate.

| Area | "Farm" means | Basis |
|---|---|---|
| Finance | A group of cost centers that makes accounting sense | Accounting |
| Operations / Management | The unit that has a Farm Manager | Governance |
| Research | Whatever falls inside a geographic area | Geography |
| Legal | Whatever the title deeds say | Legal |

None of these is wrong. Each area had built its definition around a real need, and each one worked perfectly inside its own world.

The trouble is that the worlds don't line up. Small accounting farms can sit under a single manager, so Finance sees two units where Operations sees one. A single mega-farm can have two managers and span one geographic zone, so Operations sees two units where Research sees one. The boundaries cross. They were never meant to match.

And here's the trap: most of the time they do line up. Of the fifteen farms in that report, in twelve or thirteen of them all four definitions pointed at exactly the same thing. Only two or three came apart. That's why nobody objected: a definition that agrees ninety percent of the time doesn't feel like an ambiguous definition. It feels like a fact.

So why did the good farm look bad? You have to get into the detail of the business, because that's where it lives.

In bananas you talk about fruit *produced* and fruit *packed*. Most of the time they're the same thing: the farm harvests its own fruit and packs it itself. But every so often one farm packs another farm's fruit. When that happens, production costs stay with the producing farm and packing costs stay with the packing one. On top of that there are costs that belong to neither and have to be spread proportionally: administration, or specialized equipment like the crop-dusting planes.

That's where it matters which definition of "farm" each cost lands under. In this report, part of the expenses was charged under one definition and the production was credited under another. The costs landed on one unit; the fruit landed on a neighbor. On paper, a productive operation looked like it was burning money and producing nothing. About $150 thousand in red. Not an enormous figure for an operation that size, but more than enough to put a farm on the losers' list.

If nobody had pulled the thread, that farm would have been closed. Hundreds of thousands of dollars in a decision made on somebody else's costs. And here's the ugly part: once it's closed, the problem goes invisible. The costs that were sinking it would have redistributed onto the neighboring farms, and the following year's report would have pointed at the next one. Closing the farm would have erased the evidence of why it was closed.

Nobody made a mistake. That's the uncomfortable part. Every area was right about its own definition. The report mixed the universes together, and no one caught it, because everyone saw the word "farm" and filled in their own meaning. The agreement was real. It just wasn't agreement about anything.

That's what apparent consensus looks like. Everyone nods. Nobody is talking about the same thing.

## The more dangerous version: no definition at all

The farm had too many definitions. The next case had none.

About five years ago, also in Costa Rica, a wholesale distributor of chemicals and packaging had been working with one of our consultants on a conventional BI project: a tabular cube for sales analysis. It had been running for many months. Almost every calculation was closed and accepted. All but one, and it was the one that sits in the denominator of half a dozen averages: the customer count. That one never closed, because internally they never agreed on what a customer was.

It sounds like a philosophy seminar. It isn't: it was the denominator.

I had given sessions on RFM in Colombia and in Costa Rica, and the technique caught their interest. We agreed on a proof of concept over the model they already had. Recency, Frequency, Monetary value. You score every customer on each axis, cut the base into quintiles, and you get clean segments: your best customers, your lapsing ones, the ones worth a campaign.

Before calculating a single segment I ran a box plot on the three variables. Box and whiskers, nothing more, just to see how they were distributed.

On frequency, the average sat at 7.6 purchases a year, and hanging below it were hundreds of customers with one or two purchases *in their entire history*. On value, the average purchase was measured in tens of thousands of dollars, and down there again were the same hundreds, with purchases of tens or hundreds.

A box plot shows you the shape, it doesn't tell you who they are. For that I put on the Sales Manager's hat and asked the question he would ask: who are my customers? Then I pulled the list of names and read it.

They were the company's own partners. And friends of the partners. An importer that distributes at wholesale and that every so often, as a courtesy, sells retail to somebody close.

The final numbers give the scale. Out of a little over 1,800 records in the base, barely 200 qualified as active customers. Of the remaining 1,600, more than 40% fell out under the rule we ended up writing: they weren't dormant customers, they had never been customers. The rest were real customers, just without a purchase in the last year.

Feed that into the quintile calculation and the ranges collapse. Your "top 20%" gets diluted by noise, the cutoffs drift, and the segments stop meaning anything. And watch out for the easy diagnosis: the RFM didn't fail because of a data problem. Every one of those sales actually happened and is correctly recorded. It failed because the base wasn't made of customers.

The same hole explained the calculation that never closed in the cube. They had spent months arguing about a formula when what was missing was a definition.

So who drew the line? I did. The outsider, the one who had shown up with a borrowed technique and three weeks on the project. I proposed a working definition (*a purchase in the last year and more than $1,000 in annual spend counts as an active customer; everything else stays out of the RFM*) and the project moved again.

The threshold was left low on purpose: there were a few legitimate buyers who only show up when they run short on stock, and I didn't want to lose them. Today I accept it could have gone higher. I drew it by looking at the names, hunting for whatever would clear out the bulk of the noise, not for whatever was correct. And that's the part that matters: it isn't the right definition, it's a good-enough one. Nobody asked for more than that, and nobody had written it in months.

It would be easy to dress that up as decisiveness. It wasn't, and the timing gives it away: if the guy with three weeks can draw the line, the problem was never that the line was hard. A consultant filling a definitional vacuum that has been open for months is a symptom, not a rescue. The organization was so used to its own inconsistencies that the gap felt normal. Every team ran its own customer count, got its own number, and nobody saw a problem worth that much friction. None of it was a data problem. It was governance immaturity wearing a data costume.

## The vacuum is not neutral

Here's why the empty definition matters more than the crowded one.

When nobody has signed off on what a customer is, the same data supports opposite conclusions. Which one you reach depends on what you want to be true.

Want "new customers" to look high this quarter? Don't put any restriction on the definition. Let the partner's friend who bought once count. The number climbs.

Want "average ticket size" to look high instead? Apply a strict definition. Cut the small buyers out. The average jumps.

Same database. Same quarter. Opposite stories. And nobody lied. Every number is technically defensible, because there's no agreed definition to violate. The ambiguity isn't a bug you forgot to fix. It's an alibi. It lets the organization tell whichever story is convenient and stay technically honest the whole time.

If that sounds like a modeling problem, look at where the discipline already filed it.

## I had it filed in the wrong drawer

I have to confess something here. If you had asked me at the time -- in that meeting with the General Manager, or standing in front of the distributor's box plot -- I would have told you this is a technical problem. A modeling problem, at most a data quality one. I would have filed it in that drawer without a second thought, and gone to solve it with that drawer's tools.

I came to see it differently this year, studying seriously for the CDMP certification. The DMBOK catalogs this under Data Handling Ethics, in a section called *Unclear Definitions or Invalid Comparisons*. Not data quality. Not modeling. Ethics.

> "The ethical thing to do, in presenting information, is to provide context that informs its meaning, such as a clear, unambiguous definition of the population being measured and what it means to be "on welfare." When required context is left out, the surface of the presentation may imply meaning that the data does not support. Whether this effect is gained through the intent to deceive or through simply clumsiness, it is an unethical use of data."

Read that last line twice. *Intent to deceive or simply clumsiness* -- the DMBOK puts them on the same side of the ethical ledger. You don't get a pass for not meaning to. The example it uses to make the point is a census figure: 108.6 million people "on welfare" set next to 101.7 million with full-time jobs. The comparison looks damning until you notice the two numbers count different populations: one counts anyone in a household that received a benefit, the other counts individuals. Two definitions, dressed up as one comparison. Invalid, and convincing.

That's the farm report. That's the customer count. The mechanism is identical: a number that looks like a fact but rests on an undeclared definition.

And there's what took me so long to see. While the problem lived in the technical drawer, what was at stake was the accuracy of the report, and that's enough to justify a ticket. Moved to the ethical drawer, what's at stake is whether the organization has the right to present that number as a fact. That is not the same conversation, and it isn't held with the same people.

There's a flip side worth naming, because it rescues the working definition I drew for the distributor. The same DMBOK section on bias says that excluding "poor customers," the ones you're not pursuing further, is legitimate analysis, *as long as the analyst documents the criteria used to define the population.* Excluding the partners' friends wasn't the sin. Excluding them in silence would have been. The line I drew was defensible the moment I wrote it down and dated it. The instinct and the discipline land in the same place: the problem was never the exclusion. It was the silence.

## An awkward disclaimer before the cure

I have to admit something about what follows. "Business glossary" is not a term that shouts *put your time and your money here*. There is no ROI case that defends itself in front of a budget committee. Nobody walks out excited from the meeting where the glossary got approved. I have watched the sponsor's face when that line shows up in the budget, and I understand it.

And still. Without those definitions, business terms stop working as a communication mechanism. "Farm," "customer," "margin" become noise shaped like a word: everyone hears their own, and the meeting ends with everybody agreeing.

There's a twist that makes this more urgent than it was fifteen years ago. Whoever didn't invest in this layer is going to see the impact of these misunderstandings accelerated, not reduced, by LLMs. You'll ask the model how many customers you have and it will give you a number, confidently and in good English. The problem isn't that the LLM doesn't understand. It's that the business never defined what a customer is, not for the humans and not for the machine. The model doesn't invent the consensus the organization never built. It inherits it, and repeats it faster.

## The cure: name it and declare it

Both cases get fixed with the same move. You pull the ambiguity out of the silence. It just takes two different shapes depending on which problem you have.

When there are too many legitimate definitions -- the farm -- you name all of them out loud and model the hierarchy that reconciles them. We split the term into *Financial Farm* and *Operational Farm*, then built a structure in the semantic model that relates accounting cost to operational output, so the expenses and the production finally land on the same unit. But the model only encodes that decision; it doesn't make it. Someone still had to declare, in the open, that "farm" was two concepts and not one. That is semantic engineering, not a footnote clarifying which "farm" you meant. If the meaning varies, the name has to vary with it -- and someone has to say so out loud.

When there's no definition at all -- the customer -- you write a working definition: explicit, dated, signable. Note the word *working*. It isn't a permanent ruling carved into the warehouse. The business can revise it next quarter when it learns something new. What makes it governance isn't the rule itself: two purchases, a thousand dollars, those numbers can move. What makes it governance is that someone declared it, in writing, with a date, and put their name on it. The act of declaring is the whole point. Whether a declared definition is then sharp enough to decide, row by row, who actually passes it -- that is a finer problem, and a different one.

One concept, one name.

## The lesson

If you remember one thing, make it this: false semantic consensus isn't a disagreement waiting to be settled. It's the absence of one being mistaken for agreement. Everyone looks at the same number and feels aligned, and the alignment is real -- it's just alignment on the digits, never on what they mean.

The farm taught me the crowded version: four right answers that don't compose. The distributor taught me the empty version: no answer, and a silence of months that everyone had learned to live with. Different shapes, same root. The sin was never the ambiguity. Ambiguity is normal; every meaningful term in a business carries some. The sin is leaving it undeclared and calling the result a number.

A model that names its ambiguities resolves them. One that hides them amplifies them. The most expensive illusion in any reporting system is a room full of people staring at the same figure, certain they agree -- when the only thing they ever agreed on was the figure itself.

**Your next steering meeting:** take the metric your company looks at most, the one on the first slide. Ask three different areas, separately, what counts and what doesn't count inside that number. Separately, not in the same room: in the same room they reach agreement, and that is exactly the problem.

If all three answers come back identical, tell me. I want to know how they pulled it off.
