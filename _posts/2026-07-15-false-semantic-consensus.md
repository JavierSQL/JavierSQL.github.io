---
layout: post
title: "False Semantic Consensus"
date: 2026-07-15 09:00:00
description: "Everyone agreed on the number. That was the problem."
thumbnail: assets/img/feat-false-semantic-consensus.webp
tags: [semantic-models, data-governance, data-modeling, data-ethics, dmbok]
categories: [trust-erosion]
giscus_comments: true
---

![False Semantic Consensus](/assets/img/feat-false-semantic-consensus.webp)

*Everyone agreed on the number. That was the problem.*

A farm was producing well. Good yield, healthy operation, the kind of asset you want more of.

In the consolidated report it showed up in red. Deficit. A candidate for the cut list. Operations had already started treating it as a problem farm: the one that drags the numbers down, the one somebody should look into.

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

So why did the good farm look bad? The report charged its expenses under one definition of "farm" and credited its production under another. The costs landed on one unit; the output landed on a neighbor. On paper, a productive operation looked like it was burning money and producing nothing.

Nobody made a mistake. That's the uncomfortable part. Every area was right about its own definition. The report mixed the universes together, and no one caught it, because everyone saw the word "farm" and filled in their own meaning. The agreement was real. It just wasn't agreement about anything.

That's what apparent consensus looks like. Everyone nods. Nobody is talking about the same thing.

## The more dangerous version: no definition at all

The farm had too many definitions. The next case had none.

A wholesale distributor of chemicals and packaging hired us for a customer segmentation project: a standard RFM model. Recency, Frequency, Monetary value. You score every customer on each axis, cut the base into quintiles, and you get clean segments: your best customers, your lapsing ones, the ones worth a campaign.

Six months in, the project had stalled on a question nobody could answer: *what counts as a customer?*

It sounds like a philosophy seminar. It's not. RFM cuts the base into quintiles: the top 20% by frequency, the next 20%, and so on. That math only works if the base is actually made of customers. This base wasn't. It was full of people who weren't customers in any useful sense. Internal sales. A few hundred one-time buyers who'd spent $20 to $50 once and never came back. Favors to friends, booked as orders. Feed those into the quintile calculation and the ranges collapse. Your "top 20%" gets diluted by noise, the cutoffs drift, and the segments stop meaning anything.

So who drew the line? I did. The outside consultant. I proposed a working definition (*at least two purchases a year and at least $1,000 in annual spend counts as a customer; everything else stays out of the RFM*) and the project moved again.

It would be easy to dress that up as decisiveness. It wasn't. A consultant filling a six-month-old definitional vacuum is a symptom, not a rescue. The organization was so used to its own inconsistencies that the gap felt normal. Every team ran its own customer count, got its own number, and nobody saw a problem worth six months of friction. It was never a data problem. It was governance immaturity wearing a data costume.

## The vacuum is not neutral

Here's why the empty definition matters more than the crowded one.

When nobody has signed off on what a customer is, the same data supports opposite conclusions. Which one you reach depends on what you want to be true.

Want "new customers" to look high this quarter? Don't put any restriction on the definition. Let every $20 one-time buyer count. The number climbs.

Want "average ticket size" to look high instead? Apply a strict definition. Cut the small buyers out. The average jumps.

Same database. Same quarter. Opposite stories. And nobody lied. Every number is technically defensible, because there's no agreed definition to violate. The ambiguity isn't a bug you forgot to fix. It's an alibi. It lets the organization tell whichever story is convenient and stay technically honest the whole time.

If that sounds like a modeling problem, look at where the discipline already filed it.

## This is an ethics problem, not a technical one

The DMBOK catalogs this under Data Handling Ethics, in a section called *Unclear Definitions or Invalid Comparisons*. Not data quality. Not modeling. Ethics.

> "The ethical thing to do, in presenting information, is to provide context that informs its meaning, such as a clear, unambiguous definition of the population being measured and what it means to be "on welfare." When required context is left out, the surface of the presentation may imply meaning that the data does not support. Whether this effect is gained through the intent to deceive or through simply clumsiness, it is an unethical use of data."

Read that last line twice. *Intent to deceive or simply clumsiness* -- the DMBOK puts them on the same side of the ethical ledger. You don't get a pass for not meaning to. The example it uses to make the point is a census figure: 108.6 million people "on welfare" set next to 101.7 million with full-time jobs. The comparison looks damning until you notice the two numbers count different populations: one counts anyone in a household that received a benefit, the other counts individuals. Two definitions, dressed up as one comparison. Invalid, and convincing.

That's the farm report. That's the customer count. The mechanism is identical: a number that looks like a fact but rests on an undeclared definition.

There's a flip side worth naming, because it rescues the working definition I drew for the distributor. The same DMBOK section on bias says that excluding "poor customers," the ones you're not pursuing further, is legitimate analysis, *as long as the analyst documents the criteria used to define the population.* Excluding the $20 buyers wasn't the sin. Excluding them in silence would have been. The line I drew was defensible the moment I wrote it down and dated it. The instinct and the discipline land in the same place: the problem was never the exclusion. It was the silence.

## The cure: name it and declare it

Both cases get fixed with the same move. You pull the ambiguity out of the silence. It just takes two different shapes depending on which problem you have.

When there are too many legitimate definitions -- the farm -- you name all of them out loud and model the hierarchy that reconciles them. We split the term into *Financial Farm* and *Operational Farm*, then built a structure in the semantic model that relates accounting cost to operational output, so the expenses and the production finally land on the same unit. But the model only encodes that decision; it doesn't make it. Someone still had to declare, in the open, that "farm" was two concepts and not one. That is semantic engineering, not a footnote clarifying which "farm" you meant. If the meaning varies, the name has to vary with it -- and someone has to say so out loud.

When there's no definition at all -- the customer -- you write a working definition: explicit, dated, signable. Note the word *working*. It isn't a permanent ruling carved into the warehouse. The business can revise it next quarter when it learns something new. What makes it governance isn't the rule itself: two purchases, a thousand dollars, those numbers can move. What makes it governance is that someone declared it, in writing, with a date, and put their name on it. The act of declaring is the whole point. Whether a declared definition is then sharp enough to decide, row by row, who actually passes it -- that is a finer problem, and a different one.

One concept, one name.

## Closing

If you remember one thing, make it this: false semantic consensus isn't a disagreement waiting to be settled. It's the absence of one being mistaken for agreement. Everyone looks at the same number and feels aligned, and the alignment is real -- it's just alignment on the digits, never on what they mean.

The farm taught me the crowded version: four right answers that don't compose. The distributor taught me the empty version: no answer, and a six-month silence that everyone had learned to live with. Different shapes, same root. The sin was never the ambiguity. Ambiguity is normal; every meaningful term in a business carries some. The sin is leaving it undeclared and calling the result a number.

A model that names its ambiguities resolves them. One that hides them amplifies them. The most expensive illusion in any reporting system is a room full of people staring at the same figure, certain they agree -- when the only thing they ever agreed on was the figure itself.
