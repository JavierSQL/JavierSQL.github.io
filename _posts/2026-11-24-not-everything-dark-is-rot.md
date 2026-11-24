---
layout: post
title: "Not Everything Dark Is ROT"
date: 2026-11-24 06:00:00-0600
description: "A historical table, an emergency copy, a reporting ODS: a ROT cleanup would have flagged all three. All three were the history."
thumbnail: assets/img/feat-not-everything-dark-is-rot.webp
tags: [data-governance, data-management, records-management, metadata, ai-agents, rot-data, data-retention]
categories: [who-decided-that]
---

![Not Everything Dark Is ROT](/assets/img/feat-not-everything-dark-is-rot.webp)

*A historical table, an emergency copy, a reporting ODS: a ROT cleanup would have flagged all three. All three were the history.*

## A table protected by its name

At a large agricultural company in the region, the daily payroll table keeps only the last 90 days. Everything older lives in a second table. For years, that second table had a name that meant "historical". Then a DBA deleted it to free storage. The table looked like what its name said: old data, kept just in case.

It was the most important source of the data warehouse.

The table is back. Its name now ends in `_NO_BORRAR`, Spanish for "do not delete". The name is the only protection. Nobody classified the table, nobody set a retention policy, and nobody owns it on record. Someone typed three words in capital letters, right after the loss.

In [the first post of this series](/blog/2026/the-rot-weighs/), I compared ROT data (redundant, obsolete, trivial) to dark matter: mass with no light. ROT data has weight and costs money. It gives off no information that supports a decision. I also left a promise in that post: not everything dark is ROT data. This post keeps that promise.

## Two more tables I remember

The payroll table isn't the only one. Twenty-five years of BI leave a collection.

Long before the cloud, I built a sales model on an Oracle database. The company had very loose development practices. Some time before my project, a deploy damaged the production data. The person who ran the deploy made a copy of the transactional tables first. The team then spent more than sixteen hours to restore the environment.

To make sure that nobody mixed them up, that person gave the copy a name. I still remember its spirit: something like `INVOICES_BEFORE_THE_DISASTER`. The real word wasn't "disaster", and it wasn't polite. When we built the ETL, it had a fixed rule. Before a certain date, it read invoices from that table. After that date, it read from `INVOICES`. An emergency copy became the official source of history.

More recently, a client had a security incident that encrypted all its databases. The same incident encrypted the backups. The billing system came back from a backup more than three months old. Then we ran the load backwards. We updated the operational system from the ODS that we kept in the cloud for analytics. Customers, products and invoices came back. Not everything did. The client had to rebuild inventory with a physical count.

I'd like to say that we planned it. We didn't. Nobody designed that ODS as a backup. It existed to feed reports, and it saved the business by pure luck.

Look at these three tables with the eyes of the first post. A backup table is a copy. A "historical" table looks obsolete. An analytics ODS is, by design, a copy of the ERP, so it is redundant. A ROT cleanup would have flagged all three. In all three cases, they were the history.

And look at where the knowledge about them lived. It lived in a table name and in an ETL rule that one person understood. It also lived in the memory of whoever was there on the bad day. That was fine while the reader was a person. A person can ask why invoices before March come from a different table.

## The only letter judged by use

Of the three letters in ROT, you can check two against the data. Redundant: is there another copy? Obsolete: did something replace it? The third letter is harder. In records management, where the acronym comes from, *trivial* means content of little or no value to the business.

Value is hard to measure. So almost every cleanup I've seen measures something easier: does anyone use it? I'll start with that question, because it's the one people actually ask. It's a proxy, and the rest of this post is about where the proxy fails.

A note on where I'm borrowing from. *ROT* and *vital record* come from records management, the part of DAMA's framework that deals with documents and content. Records managers think about contracts, emails and files. I apply their ideas to tables, logs and Lakehouse metadata, and DAMA doesn't put them there. I think that's legitimate. It's one of the things I value most in DAMA: the knowledge areas talk to each other. An idea from one area often solves a problem in another.

DAMA has a name for a kind of data that fails the usage test on purpose. A *vital record* is "a type of record required to resume an organization's operations in the event of a disaster". Nobody needs this data until the bad day. DAMA also has *critical data*, and it's easy to confuse the two. Critical data is the data most important to the business, where data quality work pays off first. A vital record can be the data you use least. If you classify by use, you get the first group right and the second group wrong.

I need to be careful here, because DAMA also warns in the other direction. It lists reasons why organizations never delete anything, and one of them is "can't foresee future needs". Suppose this post said "don't delete it, you might need it". Then it would repeat that excuse and contradict the first two posts of this series. My argument is different. *Trivial* is a classification, and you classify by function. How many people read the data today is a weak signal of its function.

## Diffuse matter

Gartner already compares data to astronomy, for something else. It calls *dark data* the information that an organization collects, processes and stores but never uses for anything beyond that. Gartner compares it to dark matter. I think the comparison is only half right. Astronomy has a better answer than the one I gave in the first post.

Ordinary matter, the kind made of atoms, comes in two forms. Some of it is bound to objects: stars, planets, the things that shine and that we can point a telescope at. The rest is diffuse: gas and dust spread between the stars and between the galaxies.

For decades, astronomers couldn't find a large part of the ordinary matter that the theory said should exist. This missing matter wasn't dark matter. It was ordinary matter in very hot, very thin gas between galaxies, too faint for the usual instruments. Somebody had to point the right instrument at it: X-rays in 2018, fast radio bursts in 2020. (The more academic readers will recognize the work of Nicastro and of Macquart.) The gas was shining all along, in a wavelength that nobody watched. Much of what Gartner calls dark data is like that gas: nobody looked at it yet.

A Lakehouse has the same two forms. The bound matter is what the business looks at: fact tables, semantic models, reports. The diffuse matter is everything around it. Run logs. Row counts. Load timestamps. Quarantine records. The YAML that configures each load. The runbooks that say what to do when a load fails.

No business user ever opens it. By the usage test, it's the most trivial data you own, and a cost review cuts it first. In Azure, a Log Analytics workspace keeps data for 30 days, unless somebody decides otherwise. In Fabric, `VACUUM` deletes old versions of a Delta table after seven days by default. Deleting is the default, and it's free.

But this matter isn't dark. It gives off light, in the sense I used in the first post: information that supports decisions. It shines in a wavelength that people who read a report don't see.

## The new reader

In [We Act on Metadata](/blog/2026/we-act-on-metadata/), I described a platform where every load writes its own record. Each run leaves a row count, a run ID and a timestamp in the control tables. In the YAML of each entity, governance declares how many rows a normal load has, with a `min_rows` and a `max_rows`. When a load falls outside that range, it goes to quarantine, and `VolumeCheckQuarantine` records it. In that post, the readers of those tables were people: operations engineers, data stewards, a governance committee.

Now there's another reader. My colleague Leda built a proof of concept on a client's Fabric platform. It uses agents that read those logs and the runbooks (notebooks in the same workspace) and post to Teams. None of it runs in production yet, at any client. A message looks like this:

> The load of `Sales_ERP.Invoices` failed at 03:12. Error: timeout on the source connection. According to runbook RB-ING-04, the recommended action is to retry with the reduced batch size and check the gateway status first.

(The entity and the runbook ID are illustrative.)

The agent doesn't execute anything. It points to the runbook, and the engineer decides. In the proof of concept, the agent saves time. It puts the engineer in front of the right page of the right runbook.

The data didn't change, and the log is the same log. Only the reader changed. Even in a proof of concept, the usage of the most trivial table in the Lakehouse went from zero to every single run. Maybe you classified it as trivial last year, because you counted its readers. That count is now wrong, and nothing in the table tells you so.

## Normal is a decision

My first outline said that the agent "detects anomalies" when it compares a load with the ones before it. That's wrong, and the difference matters for this series.

The agent doesn't know what normal looks like. A load of 12,000 rows is a number. It's an anomaly only because the YAML says that the entity normally loads between 40,000 and 60,000 rows. Somebody in governance decided that range. The decision has an owner and a date, because it changes through a pull request. The quarantine record is the trace that the platform applied the decision to this load.

Without the range, the agent sees only a number. It writes a confident message, or it says nothing at all. Without the quarantine history, nobody can say if this is the first short load this month or the tenth.

So part of the diffuse matter that the agent reads is a governance decision, written down in a file. The rest is the record that someone applied the decision. Both look trivial: a config file and a table of exceptions.

The names in the first three stories did the same job. Someone wrote them in the only place that people found. `_NO_BORRAR` is a classification. `INVOICES_BEFORE_THE_DISASTER` is a business rule with a date. They worked because a person read them and asked. An agent doesn't ask. It reads only what someone kept.

## The next step (a scenario)

This part is a scenario. Not even the proof of concept does it. I expect these agents to grow in two directions.

First, for some tasks, the agent will act on its own. It will retry a load with a smaller batch, or reload a partition. Today, that low-risk work waits for an engineer at 03:12.

Second, the same kind of agent will answer people who aren't engineers. A sales manager asks for last week's sales by region. The agent sees that Tuesday's load from one country came in at a third of its normal volume, and that the load is in quarantine. A good answer says: "This number is probably incomplete. One load is under review." A bad answer gives the number.

The good answer needs three pieces of diffuse matter: the log, the range and the quarantine record. If the range lives in an engineer's head, the agent has nothing to compare against. Suppose a 30-day policy deleted the quarantine history. Then the agent can't tell if this is the first short load from that country, or the fifth since September. Those two answers mean different things to the manager.

And when the agent acts, there's a fourth piece. Who reloaded that partition at 03:12? The agent did. The record of its action, and of the runbook it followed, is now the only way to reconstruct the decision later. That record is a log. It will look trivial too.

There's a public case of what happens when that kind of log isn't there. In 2023, attackers got into U.S. government email accounts in Microsoft's cloud. The State Department detected the intrusion because it paid for a premium license. That license included a specific audit log, `MailItemsAccessed`. The Department of Commerce didn't have that license. When it tried to look back, it couldn't. According to the Cyber Safety Review Board, Microsoft "could only provide these logs and data going forward". A log that very few organizations ever read decided who could investigate.

The property of retention that worries me most is that it isn't retroactive. Microsoft's own documentation for its 10-year audit retention says so in plain words: the policy "isn't retroactive". Deleting happens on a schedule, automatically. Keeping is a decision, and it protects only what comes after the day you make it.

## Trivial after 48 hours

Bill Inmon saw part of this in 2016. In *Data Lake Architecture*, he divides the lake into ponds by type of data: analog, application and text. A raw pond sits at the entrance, and an archival pond sits at the end. He separates the types because each type has a different life.

Analog data is what machines measure every millisecond. Inmon expects "99.9% of the data to be normal and of little business value". His answer is data reduction, and he says what drives it: "probability of future usage". That's a usage test too, but it looks forward. He also warns that the descriptor data around the measurements is "often as valuable (or even more valuable)" than the measurements. That is diffuse matter again.

Ahias, a colleague at Primus, worked with a mining company that had hundreds of sensors. Each sensor reported several thousand readings per second, as small JSON files. The files were small, but they added up to gigabytes every day. After 48 hours, the raw readings were trivial. Nobody would ever look at one reading from a Tuesday at 03:12:07. Every hour, the platform kept the minimum, maximum, average and median of each sensor. Those aggregates never became trivial. They show trends, anomalies and seasonality.

So the same data was trivial and vital at the same time, at two different grains. Whether data is trivial depends on its grain and on its age.

The fifth question at the end of this post asks about the catch. When the raw readings are gone, the four aggregates are all you have. Suppose that next year an engineer needs the 95th percentile, or a five-minute window to catch a short vibration. Nobody can compute it, because the raw data can't come back. Someone has to choose the aggregates before the delete. In this case, the choice came from the business. I wasn't part of that decision, and I don't know if anyone ever missed a number. But someone made the choice once, and from then on, that choice decided for everyone.

## Value fades. Risk has two sides

The sensors show the first of two forces that are always in play. Value fades. As data gets older, the business context around it matters less, and most data drifts toward trivial.

Uber's engineers wrote that down as a formula. [Their legal redlining agent](https://www.uber.com/us/en/blog/building-ubers-redlining-agent/) learns from past decisions of the legal team. When it picks examples for its context, it weights each one by age: `exp(-λ × age_days)`, with a half-life "currently set to 365 days". The goal, in their words, is to adapt "without over-indexing on outdated precedents". Look at the parameter. Somebody decided that a decision from last year counts half. It's a decision with a number. And because it lives in an agent, someone can find it and change it.

The other force is risk, and it has two sides. If you delete too early, you lose a vital record, a proof, or the log that tells you what happened. If you keep too long, the data becomes a liability. You have more to protect, more to hand over in a lawsuit, and more to lose in a breach. DAMA warns in both directions. Risk is probability times impact, and every organization decides how much risk it will accept.

The retention date is where those forces cross. Value goes down. The risk of keeping goes up. The risk of deleting usually goes down. Somebody has to look at that crossing and sign it.

## This isn't "keep everything"

The answer isn't to keep every log forever. That's the excuse that DAMA lists, and it's the hoarding that the first two posts of this series argued against.

The answer is a small set of diffuse matter. Name it, classify it by function and protect it. Keep it for a stated period, make it immutable if you can, and test it. The test matters, because nobody can trust a restore that nobody tried. When you name that set, the rest of the ROT can go without fear. Retiring ROT without that list is gambling. Keeping everything because you don't have the list is hoarding. Both come from the same gap: you decide without knowing what a thing is for.

`_NO_BORRAR` is the right instinct in the worst possible place. It's a classification that nobody can query, with no owner and no date.

## Before you call it trivial

Here are five questions for any table, log or file that a cleanup is about to delete. The first three aren't new. Archivists appraise records by their operational, legal and fiscal, and evidential value, and the practice is decades old. I translated those values to tables and logs. The fifth question starts from DAMA's way to value data, which counts the cost to replace it if you lose it. Two things come from this series: the fourth question, and one condition on the fifth. The source that you rebuild from can't fail on the same day.

> 1. **Resume.** If this disappeared during an outage, could the business keep operating, or be rebuilt? (DAMA's vital record.)
> 2. **Prove.** Would you need it to prove a payment, an access or a decision to an auditor, a regulator or a court?
> 3. **Reconstruct.** Does it record who did what, and when? Include what your agents did. If yes, how long can an incident go unnoticed? Keep it longer than that.
> 4. **Judge.** Does a person or an agent use it to decide whether to trust other data? Row counts, load times, quarantine records and the ranges that define normal all count. Ask who reads it now, not who read it last year.
> 5. **Replace.** If you delete it and you're wrong, can you rebuild it from another source? Only count a source that wouldn't fail on the same day. A backup encrypted in the same attack doesn't count.
>
> - No "yes" in the first four: it's trivial. Delete it without guilt.
> - A "yes" in the first four, and a "yes" in the fifth: it's a copy. Protect the source and let the copy go.
> - A "yes" in the first four, and a "no" in the fifth: it isn't trivial. Classify it and protect it. Give the decision an owner and a date, and write down why. Write it in a place that an agent can read, not in the table name.

## Who decided it was trivial?

Who decided that the historical payroll table was trivial? A DBA did, from its name, on a day when storage was tight. Who decided what a normal load looks like? Governance did, in a YAML file, with an owner and a date. That decision has an owner. Who decided how long the platform keeps the log that proves it? In most platforms I've seen, nobody. The default decided.

The first three posts of this series were about data that weighs, competes and disguises itself. This one opens the second part: deciding what to keep. And to decide what to keep, you need someone who owns the date.

The next post is about that date, and about who gets to set it.

*This is the fourth of ten posts in* Who Decided That? *The cloud and AI made it cheap to create, copy and keep data. They didn't make it any cheaper to decide.*
