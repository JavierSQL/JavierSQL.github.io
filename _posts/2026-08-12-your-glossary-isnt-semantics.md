---
layout: post
title: "Your Glossary Isn't Semantics"
date: 2026-08-12 08:00:00-0600
description: "A definition tells you what a customer is. It doesn't tell you which rows qualify."
thumbnail: assets/img/feat-your-glossary-isnt-semantics.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-modeling, business-glossary, data-quality]
categories: [trust-erosion]
giscus_comments: true
---

![Your Glossary Isn't Semantics](/assets/img/feat-your-glossary-isnt-semantics.webp)

*A definition tells you what a customer is. It doesn't tell you which rows qualify.*

In 2008 I built a loyalty model for a direct-sales catalog operation. The request came from the commercial management team, with IT backing it. The salespeople were independent: they signed nothing that obliged them to buy in any given campaign, and a campaign ran about three weeks. If they did place an order, it had to clear a minimum to be shippable. There were also volume discount tiers. Loyalty there wasn't a warm feeling. It was money.

The indicator the business cared about most was a negative one, and it had a name: **NECA**, from **N**o **E**nvío **C**ampaña **A**nterior, no shipment in the previous campaign. An active salesperson we shipped nothing to last cycle.

The first thing I learned looking at that data is that a NECA doesn't mean what the name makes you think. It could be that she never ordered. It could also be that she did order and the order arrived late, or that there was no inventory at the moment of dispatch.

Which means the sales force's disloyalty indicator sometimes fired because *we* hadn't done our job.

## The definition was never the problem

Here's what makes this one slippery: there was nothing wrong with the definition. "An active salesperson is one who buys from us regularly." True. Clear. Useless.

It's useless because it doesn't tell you *when*, and it doesn't tell you under what conditions a given row qualifies. It describes the concept in the abstract and goes silent exactly where the work starts.

There's a distinction worth making sharp here, because most data glossaries live on the wrong side of it.

A **declarative description** says what something is in principle: *a customer is someone who has purchased from us.* An **operational definition** says what conditions a row must meet to count: *a customer is someone with at least one paid transaction in the last 24 months and an account in good standing.* The first reads well in a glossary. The second is the one you can actually run.

They are not the same thing, and the gap between them is where I'd argue semantics actually lives. Entities, relationships, and definitions get you a structured vocabulary. That's valuable. Naming things well is real work, and most organizations don't even do that. But a vocabulary is not a meaning. Meaning is the set of conditions under which a specific row *is* the thing the vocabulary names.

## The criterion wasn't a sentence. It was a machine.

What we delivered in 2008 wasn't a better-worded definition. We delivered a graph with one path in and two paths out, every transition carrying its own date.

The path in had four gates: contract signing, credit review and approval, first order, second order. Only then did you enter the core of active salespeople, the ones buying across consecutive recent campaigns. Nobody is a customer for signing, and nobody is one for buying once.

There were two exits, and that's the part that took work. The first runs on shipment: NECA, then RENECA, then inactive at one, two or more consecutive campaigns without an order. The second runs on payment: a salesperson who does order, who wants to buy, but who never settled the previous invoice and therefore gets nothing dispatched.

In the data those two look identical. No shipment this campaign.

In the business they are not the same thing, and the proof is the phone. You call a NECA so she'll place an order. With the ones blocked on payment, you have to fix the payment. It isn't the same management call, so it isn't the same concept. We redefined NECA and RENECA on non-shipment while excluding the credit-blocked ones, so they wouldn't land in the same pile.

That's the part I want to underline, because it's precisely what a glossary can't do: **the membership condition ended up defined by the action it served.** Not by the shape of the data, which was the same in both cases.

And RENECA didn't exist before that project. We coined it. The business ran a telemarketing effort against the NECAs and wrote them off as lost on the second strike, with no name in between. Naming the second strike was the modeling act: as long as she was called "lost," there was no way to treat her as anything other than lost.

## The table of non-events

Something that recurs in the tabular models I build is the non-event table: business events that should have happened, or were expected to happen, and didn't. The promotional product that never sold. The active customer who didn't buy. The NECA.

A fact records itself. Somebody invoiced, somebody shipped, and the row is there. A non-event has no row. It exists only if you first declared the rule that makes it missing, which is why it's the place where a missing membership condition costs you the most. Without a criterion there is no absence. There's nothing.

And there's a second thing, which is the one that bit us. The rule says a shipment was due. It doesn't say **who** owed it. When the warehouse had no inventory, the non-event was ours and the report charged it to her.

## Why a definition isn't enough: necessary vs. sufficient

There's a precise way to say what's missing. A glossary entry carries **necessary** conditions: if something is a customer, then it has purchased from you. That lets you reason in one direction only. What you need to look at a row and decide is **necessary and sufficient** conditions: meet these criteria and you are a member, without anyone else weighing in. (Anyone coming from ontology engineering will recognize OWL's distinction between a primitive class and a defined class here; data modeling has no pair of terms that clean for the same idea.)

A glossary, at best, gives you the necessary half. And almost nobody writes down the other one.

Leave it out and the gap doesn't disappear. Someone downstream fills it (an analyst, a dashboard, increasingly an LLM), making the call your model declined to make. They'll pick a threshold, guess at a boundary, assume an intent. Sometimes they guess the way you would have. Often they won't. And every guess is a place where the number on someone's screen stops meaning what they think it means.

## Six years later, three answers

About twelve years ago I was working on a POC for a client in the United States. The heart of what we were building was an analytical tabular model, and the client had asked us to add "a bit of data science" to it. A churn model struck me as the valuable thing we could give them, so I built one on their real data.

I spent several minutes explaining the difference between analytics and data science. In a tabular model you classify the customer with rules: I dropped someone from the active list once they had gone longer without buying than the 85th percentile of the inter-purchase interval for that base. Computed across the whole base, not per customer. We only segmented that calculation when the differences were large and obvious, wholesaler against retailer, importer against domestic. A churn model doesn't work that way. It shifts the time axis to the last purchase and looks at the events before it, to forecast whether that point is the end.

The project sponsor cut in with something that had a point: the customer stopped being a customer the day after the last purchase. True, I said. And also useless, because we have no signal of that until well afterward. We drop them from the list when the rule fires, not when the fact occurred, because until then we don't know whether they'll come back.

And then the sales manager, who had let me talk that whole time, said: no, they stopped being customers on this date.

He knew there had been a falling out with that account and that they weren't going to renew the contract. It was in the CRM, which we weren't reading. To me that account was an interesting row in a table, a case study that worked for the demo. To him it was a client they wanted, and losing them had hurt. I never verified the date he gave. From the way he said it in that room, it didn't occur to anyone to ask him for proof.

Three answers. All three right.

And the first two didn't disagree because their thresholds differed, which is the comfortable explanation. They disagreed because **each discipline anchors the time axis at a different origin.** The activity rule anchors on the calendar and asks whether the expected event happened inside the window. The churn model moves the origin to each customer's last purchase and looks backward. These aren't two thresholds on one axis. They're two coordinate systems, which is how they can land months apart with neither one being wrong.

## Three operational definitions, all valid

"Churned" doesn't have one operational definition. It has several, and each is correct for a different purpose.

| Definition        | Membership condition                                                     | Built for           |
| ----------------- | ------------------------------------------------------------------------ | ------------------- |
| Activity rule     | More days without buying than the 85th percentile inter-purchase interval | Segmentation        |
| Churn model       | Shifts the axis to the last purchase and forecasts whether it was the last | Prediction        |
| CRM event         | Falling out on record, told us they won't renew                          | Renewal forecasting |

None of these is the right one in the abstract. The right one depends on what you're about to decide. Building a win-back campaign? The activity rule is fine. Forecasting next quarter's renewals? The CRM event matters more than any purchase gap. The operational definition encodes a decision about use, which is exactly why it can't be inherited from a glossary that doesn't know what you're deciding.

Notice that the two projects fail in opposite directions, and that those are the only two ways to fail here. In 2008 there was **one pile with two concepts inside it**, and the fix was to split it. In the POC there was **one concept with three legitimate criteria**, and the fix was to declare which one applied to which decision. In both cases the glossary was well written and no help at all.

Juha Korpela made the case on his Common Sense Data publication that entities, relationships, and definitions are how you build semantics: ["Building Semantics with Conceptual Models."](https://commonsensedata.substack.com/p/building-semantics-with-conceptual) It's a good post, and this is my pushback on that one claim. That POC room is exactly what the claim runs into. The conceptual model named "customer" cleanly. It still couldn't give three competent people the same date.

## It isn't only the exit. It's the door, too.

Churn is the timing version of the problem: *when* does a row stop being a customer. There's a mirror version at the other end (*who counts as one in the first place*), and the first post in this series pulled that thread. A distributor's base was full of rows nobody would have called customers: internal sales, one-time twenty-dollar buyers, favors booked as orders. There the failure was starker than this one, because no definition existed at all. Here there is a definition, agreed and quotable, and it still cannot tell you which rows are in. Same gap, both ends. The exit needs a membership condition the definition never supplies, and so does the door. Leave either implicit and every metric on top (active-customer counts, retention rates, average revenue per customer) inherits rows a query never thinks to question.

## The cure is the harder work

The fix isn't a better sentence in the glossary. It's capturing the things a glossary structurally can't hold:

- **Membership conditions** -- the necessary *and* sufficient criteria for a row to count.
- **Lifecycle states with dated transitions** -- active, dormant, churning, lost, won back. A customer isn't a boolean, and often isn't a single-track staircase either.
- **Exit paths, plural**, when there is more than one. If two rows identical in the data demand two different phone calls, they're two concepts and they need two conditions.
- **Boundary cases** -- the account that told you before any threshold tripped; the delinquent one; the seasonal buyer who always pauses and always returns.
- **For non-events, who owed the event.** A shipment that didn't happen has to say whose failure it was, or the report will charge it to whoever was waiting.

Two more things these two projects make unavoidable.

When several operational definitions are legitimate, say which one applies to which decision. Not because the others are wrong, but because leaving it implicit is how three right answers turn into one wrong number.

And a correct membership condition can still trigger the wrong action. "Second strike and we write her off" was a decidable rule, clean and applicable, exactly the kind of thing I've been asking for through this whole post. And it was wrong, because it didn't look at the value of the salesperson. Some of them were worth working well past the second strike. Writing down the sufficient criterion is the job; having it also be the right criterion for the action is a second job, and it doesn't come included.

If you're building classification logic on top of this (segmentation, scoring, anything a model or an agent will act on), build it on the operational definition. The declarative one classifies nothing. It was never meant to.

## Closing

A definition tells you what a customer is. Semantics tells you which row qualifies as one. Those are different jobs, and the glossary only does the first.

Naming your entities and relationships well is worth doing. It's just the beginning of the work, not the end of it: the structured vocabulary, not the meaning. The meaning is in the conditions: who's in, who's out, when they cross the line, and which line you're drawing for which decision. That's modeling work, not writing work, and it doesn't fit in a cell.

One detail from that room took me a while to digest. The falling out the sales manager remembered had happened **before** the purchases dried up. His date wasn't a third opinion about a past event. It was the earliest and most precise of the three signals, and the only one neither of my models could see, because it was written in a system we weren't reading. What I took away from that POC wasn't the churn model. We had been reading the CRM as a source of activity. It is also an input to the membership condition.

When did we lose the account? The honest answer isn't a date. It's another question: *lost for what?*
