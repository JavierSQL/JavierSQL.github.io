---
layout: post
title: "The Table Is Not the Concept"
date: 2026-08-06 08:00:00-0600
description: "You can define the concept perfectly and still model it wrong."
thumbnail: assets/img/feat-the-table-is-not-the-concept.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-quality]
categories: [trust-erosion]
---

![The Table Is Not the Concept](/assets/img/feat-the-table-is-not-the-concept.webp)

*You can define the concept perfectly and still model it wrong.*

**Brazil, 2018.** A European electronics and entertainment chain: electronic parts, books, and music CDs that were not the ones on the radio. Tens of thousands of product codes. I don't remember the exact number, but it cleared a hundred thousand without effort.

I was building a POC for Microsoft. Multidimensional technology, and the goal of those exercises was almost always the same: let the client run ad-hoc queries over their own data at the speed of thought, then decide whether that was worth having.

Worth explaining how a POC works, because the genre matters for what follows. It's not a product. It's a couple of weeks to show something that *feels* like the client's own -- their products, their own numbers -- and getting there takes a lot of deliberate shortcuts. Nothing went through QA. And you warn them, every time, in those words: these numbers are not trustworthy yet.

You also warn them and it changes nothing. If you get almost everything right and one thing wrong, people jump on the one thing. As they should.

There is another feature of the format that took me years to see. The ten days of building are spent with IT. IT executes, knows the tables, knows where every field lives, and does not know whether a number is reasonable. Nobody on that side is going to tell you "that margin can't be right." The person with that judgment is the business, and the business shows up at the final meeting. The one human capable of looking at a total and knowing it is wrong arrives after the model is built.

In that meeting, browsing margin by category, the head of online sales -- I think that was the title -- stopped the demo. The numbers did not add up for him. Hundreds of products selling below cost. Some with no sale price at all, just an internal cost and a negative margin that made the whole product-profitability dashboard look broken.

The room's first hypothesis was the obvious one: somebody is pricing things to lose money, or the cost data is broken, or both.

Neither. The definition of "product" was fine. Everyone in the room could tell you exactly what a product was. The problem was the table.

The `Products` table held products, and it also held hundreds of codes that are not sold to anyone. What exactly each of those codes was, I don't remember, and for the report it did not matter: none of them had a sale price because none of them were sold, and all of them carried cost. Run a margin report across that table and you get hundreds of "products" with no revenue and full cost. The number wasn't miscalculated. The population was the wrong shape.

At a retailer the intruder list is short. At a manufacturer -- and I come back to one later, because that is where I found the real fix -- the product table is really an item table: raw materials, work in process, finished goods, all living under the same name and the same key.

And it was not the only table in that demo with the same problem. The orders were not all orders either. Thousands of abandoned transactions, and not abandoned by a customer who changed their mind: to monitor that the site was up, an agent ran a purchase every fifteen minutes and left it half-finished. Legitimate rows, legitimate purpose, wrong table. Two tables, the same failure, the same afternoon.

I had no criterion to question either one, and that is the uncomfortable part. I had spent years building models like that and had never asked whether the rows in a product table were products. I loaded the table I was given, aggregated it, and showed it.

This is the antipattern that hides under the previous one. You can agree on what a thing *is* and still disagree (silently, structurally) about which rows are that thing. Agreeing on the definition is the easy part. The table encodes a different answer, and the table is the one your reports actually read.

## The flag the demo got right

Here's the part that should sting, and it lands on me first.

The usual complaint is that vendor demos skip the hard part: the happy path runs, the data is clean, and the messy reality you live in never shows up on the slide. I was the one giving those demos. The complaint is about me. But open AdventureWorks (Microsoft's sample database, the one in every tutorial) and look at the `Product` table. There's a column called `FinishedGoodsFlag`. The distinction is modeled. The toy database of the company I was working for knew, out of the box, that not every row in a product table is a sellable product.

In Brazil there was no flag to ignore. The distinction existed in people's heads, with perfect clarity, and existed in no column.

And where the flag does exist, real production databases drop it. It sits there, or a column like it, and nobody populates it, nobody filters on it, and over a few years the table fills with finished goods, intermediates, samples, and obsolete codes, all flat, all equally "products." The sample database got the modeling right and I forgot. That's the opposite of what I usually argue: the tool handed you the distinction and the discipline threw it away.

Look at it through the arithmetic, which is where it shows. An intermediate material has a cost and no price. A sample has neither. A warehouse code may not even have a presentable name. Count them as products and your product count inflates. Average a margin across them and the average is fiction. Build a catalog from them and half of it is unsellable. The concept "product we sell" never changed. The *extension* -- the actual rows in the table -- quietly stopped matching it.

Nobody defined "product" wrong. The table just admitted things the concept excludes, and the person who knew where the door was wasn't in the room yet.

## The opposite failure: the table that erases the difference

The product table failed by lumping distinct kinds into one undifferentiated pile. The next failure is its mirror image: collapsing genuinely distinct concepts into a single type because they happen to share some columns.

Take a university. Professors and students share attributes -- an ID, a name, an email, a date of birth. So the tempting move is a single `Person` table that holds both. Cleaner, fewer tables, less duplication. And when the design isn't disciplined, and often it isn't, that's where it stops: the difference between a professor and a student stops existing anywhere in the schema.

A professor and a student are not the same thing, even though both are people. They have different relationships to the institution, different lifecycles, different rules, different everything that matters once you move past name and email. The overlap ends at the columns. Flatten them into `Person` and you've optimized for the columns they share and thrown away the meaning of what each one *is*.

So the obvious repair is to specialize: keep `Professor` and `Student` as their own tables with a foreign key up to `Person`, shared attributes in the parent, distinction preserved. That is the answer I would have given you, and it is the answer I wrote in this section first. It is wrong, and what shows it to be wrong is the same rule that condemns the merge.

Subtypes are supposed to be **non-overlapping** and **exhaustive**: every instance of the parent falls into exactly one subtype, and none falls outside it. (Simsion and Witt make the case in *Data Modeling Essentials*, and it is worth reading their version.) That is a strict constraint, and it earns its keep, because a clean partition is what lets you say anything about the parent at all.

Now run the university against it. Is a person exactly one of professor or student? No. The graduate teaching assistant is both at the same time, and that is not an edge case to be handled, it is an entire population with its own office. Is every person one of the two? Also no: the registrar, the janitor, the alum, the applicant who was rejected, the parent paying the tuition.

The partition fails both tests, and that failure is the most useful thing in the whole exercise. It is telling you that the things you called subtypes were never *kinds* of the parent at all. `Professor` and `Student` are not species of person. They are **roles** a person holds with respect to the institution: acquired on a date, held for a period, held alongside other roles, given up and sometimes taken up again. A subtype is what something *is*. A role is what something is *doing*, for now, in relation to somebody else.

Model the role and everything that was fighting you goes quiet. `Person` holds the human being: the name, the ID, the date of birth, the facts that stay true whether or not the university exists. `Enrollment` and `Appointment` hold the roles, each with its own start, its own end, its own rules, its own lifecycle. The teaching assistant gets two rows and no contradiction. The janitor gets a third kind of role without distorting either of the first two. Nobody has to be misfiled to fit in the table.

"So I never subtype people." No. The supertype was never the enemy. Run the same test on a different pair and it passes, using almost the same word.

Most legal systems split a legal subject into a **natural person** and a **legal person** -- *persona física* and *persona jurídica* in the civil-law tradition I work in. The human being on one side, the entity brought into existence by registration on the other. That partition is non-overlapping and it isn't a matter of taste or convenience: a subject is a human being or it is a legal fiction, never both, on any day, in any jurisdiction. Nothing drifts across. And the subtypes carry real weight, which is the tell that they are earning their place: a date of birth and a national ID on one side, an incorporation date and a tax registration on the other, none of it shared and none of it sitting there nullable because the other kind has no use for it. Exhaustiveness is the half your jurisdiction can bend, so check it rather than assume it -- trusts and autonomous patrimonies are where the surprises live. Non-overlapping holds regardless.

The one-person business looks like the counter-example and turns out to be the argument. It feels like it should be both at once. It isn't: the legal subject is the human being, and "the business" is a role that human being holds. The apparent exception is the role model arriving by another road.

So the difference was never generalization versus specialization. It was the level of abstraction, and the test is what found it. Professor and student were the wrong subtypes because they were never kinds of anything. Natural and legal person are the right ones because they are nothing else.

And notice what the legitimate subtype buys you. Once a company is modeled as what it *is* -- a legal person -- you are free to model separately what it is *doing* to you. Which you will need, because organizations break the overlap rule as reliably as people do. A company in your data is a customer and a supplier and a competitor, often inside the same quarter. Type it as one of the three and you will be maintaining the exception for as long as the model lives. Those aren't *kinds* of company. They are roles it holds toward you, and the roles are the part you actually have data about.

The same instinct has its cousin in the world of lookup tables: a single all-purpose table where every code and category in the system fits. Convenient for the person building it, ruinous for everyone reading it. (Veterans will recognize the One True Lookup Table -- Paul Keister coined the term, Joe Celko made the critique famous.) It isn't quite the same failure, because a lookup table isn't an entity table. But the instinct is: one table to rule them all.

The version I have had to take apart most often has a name and a file number. In JD Edwards, the User Defined Codes: `F0004` holds the headers for each code type and `F0005` holds the values. More than 85% of what you go looking for when you are building a dimensional model lives in there. Everything the business classifies -- things of completely different natures -- shares one table, one composite key, and one description column. The operational system works fine. The person who has to reconstruct what each thing is, years later, with nobody left to ask, is you.

And listen to how the domain says it, which is the cheapest test there is. Nobody at a university says "she is a professor-type person." They say she *teaches*, and he *enrolls*. The business was speaking in roles the whole time; the model is what stopped listening. When "professor" and "student" become an undifferentiated "person," the schema got simpler and the meaning leaked out, and a `Person` table that can't tell you who teaches and who enrolls is a weak spot hiding in plain sight. (The academically inclined will recognize Eric Evans's domain language; his formulation is that persistent use of a shared language forces the model's weak spots into the open.)

## Same axis, opposite ends

Step back and the two failures are the same mistake pointing in opposite directions.

|                   | What it does                                             | The cost                                               |
| ----------------- | -------------------------------------------------------- | ------------------------------------------------------ |
| The product table | Won't specialize -- lumps distinct kinds together        | Counts and margins include things that aren't products |
| The person table  | Types a role as if it were a kind of thing                | Loses the meaning of professor vs. student             |

One refuses to draw a line that exists. The other erases a line that matters. Both flatten a real taxonomy into a single, undifferentiated table, and both leave you with a table whose shape no longer matches the concept it claims to hold.

There's old language for what's going on. The *intension* of a concept is what it means: what makes something a product, or a professor. The *extension* is the actual population: which rows exist, and of what kind. Agreeing on the intension does nothing for the extension. You can write the perfect definition and still build a table that disagrees with it.

Because here's the thing a table actually is: a claim about what exists. Every row asserts "this is one of these." Flatten the table and you've made a claim you never meant to make (that intermediates are products, that professors are interchangeable with students), and every query downstream takes that claim at face value.

## Every metric inherits the shape of the table

This is why it isn't a cosmetic problem. A metric is only as honest as the population underneath it. Product count, average margin, headcount, active-customer totals -- none of them are computed from the definition in your glossary. They're computed from the rows in the table. If the table's shape is wrong, the metric is wrong, and not because anyone made an arithmetic error. The error was committed at design time and inherited ever since.

And like most of these problems, it survives because it looks normal. The table was always shaped this way. Nobody remembers deciding it; it's just how the system works. That's not a technical fact, it's modeling debt that hardened into a convention nobody re-examines.

## The cure: model the ontology, not the convenience

Both failures get fixed by the same discipline: model the concept's real boundaries instead of the columns that happen to overlap.

For the product table, that means specializing. Finished good, intermediate material, sample: distinct types under a common parent, each with its own rules about what it is and what you can do with it. The `FinishedGoodsFlag` is the minimum viable version of this; an actual product type hierarchy is the real fix. Either way, the rule is the same: a margin report should query "finished goods," not "everything that ended up in the products table."

And there is a way out that almost nobody considers, and it is the cheaper of the two: change the name.

The table is called `Products` and it holds items. You can fight the population for years, or you can admit that the name is lying and that the common parent you are looking for already exists in your data, you just never named it. At some clients that parent is `Items`. At others, where what gets sold is not always a thing, it is `Products and Services`. The exercise is short and fairly uncomfortable: **what name would make the table you already have true?** If the answer is a more generic name than the one you gave it, the table isn't dirty. It's mislabeled, and it has been making an unreviewed claim for years.

And once renamed, the concept you cared about comes back as what it always was: a declared subset. A product is the item the business decided to sell. That's where the price list comes in.

In the operational system you will almost never get to rename anything: `F0004` will be called `F0004` until the company changes ERP. In the analytics layer you can, and that is where it gets done.

A worked item hierarchy looks roughly like this, and what matters about each row is not the name: it is the claim it makes.

| Type | What each row claims | Who knows it |
| ---- | -------------------- | ------------ |
| Raw material | bought, not sold | purchasing and production |
| Work in process | neither bought nor sold | production |
| Finished good | could be sold | production, product engineering |
| Sample or display | given away, not invoiced | marketing |
| Service | sold, not inventoried | sales |

And notice what is not on that list: "sellable product." It isn't a type. A finished good with a current list price is sellable; the same good with no price, or an expired one, is not; and next month it can be sellable again. It has dates. It gets acquired and it gets given up. That's a state, not a species, and modeling it as a subtype is the person-table mistake all over again, on the other side of this post. Types go in the item hierarchy. Sellable comes from the price list.

It is worth measuring the tooling against that rule, because the industry is finally building for this. Microsoft has been putting an Ontology item into Fabric: entity types, properties, relationships, bound to data sitting in OneLake. The diagnosis behind it is exactly right, and it is the diagnosis of this post -- a concept deserves to be modeled above any single table.

The implementation, as of August 2026, is in preview, and it lands on the wrong side of this argument in two places. An entity type takes one static data binding, and you cannot combine static data from more than one source into it. Nor is there a step where you narrow a source to a subset of its rows: you choose a table and you get the table. So bind `Product` to that `Products` table and your `Product` entity type will hold the intermediates and the samples, faithfully. Generate the ontology from a semantic model and you get one entity type per table, by design. And there is no subtype -- an entity type takes a name and some properties, with no parent -- so "finished good under product" is not a thing you can currently say.

Half the cure does survive, and it isn't the half I expected. Relationships carry attributes, including validity, which is the role model working as intended.

The workaround is the part worth sitting with. You build tables filtered and modeled on purpose, purely to feed the ontology. That works. And notice what it means: the modeling did not move up into the semantic layer. It stayed down in the table, where it always was, and the ontology inherited whatever shape you handed it.

None of which is a verdict. Microsoft ships a minimum viable version and adds to it, this is early in that cycle, and I expect these gaps to close -- the direction is good news for anyone who has spent years arguing that concepts belong above tables. It is just too early to get much leverage out of it. And no version of it, however complete, is going to excuse you from the modeling.

We did exactly that, by hand, years before there was an ontology item to feed. In Brazil the repair was fast and deliberately dirty: we had to leave the client playing with the tool that same week. In the analytics layer, only include products that had ever been invoiced.

```sql
select distinct ProductCode from Sales
```

It worked. The codes that were not sold went away, and the margin report stopped reporting crimes.

It also had a side effect I had not thought about. A product that is perfectly sellable but has not sold yet is not in that list. New items, seasonal items, the ones the catalog is betting on next quarter: all of them dropped out of a report about the products we sell. The POC went on with that limitation, the client knew about it, and for what was being evaluated there it was enough. But look at what had happened. I had fixed a population that was too wide by making it too narrow. The extension still did not match the concept. It just missed in the other direction.

That mistake is worth naming, because it is an easy one to repeat. Filtering by sales history defines the concept by its *extension* -- by what happened -- when what I needed was its criterion. Having sold is evidence that a product is sellable. It is not what makes it sellable.

What finally fixed it was a different table, and I did not learn it in Brazil. It was years later, at another client in Costa Rica: a more formal project, with no POC excuse, and a manufacturer, which is the hard version, where the product table also carries raw material and work in process. There the membership condition was in the price list. A product with a price is one the business has decided to sell, whether or not anybody has bought it yet. That is a membership condition, maintained by people who maintain it for their own reasons, and it says what `FinishedGoodsFlag` was always trying to say. The population stopped being a residue of past transactions and became a statement about intent.

For the person table, it means running the partition test before you decide where anything goes. Non-overlapping, exhaustive: can every instance land in exactly one bucket, and does every instance land somewhere? Natural person against legal person passes. Professor against student does not. If it passes, specialize -- distinct subtypes under a common parent, shared attributes in the parent, and the supertype is legitimate precisely because the subtypes survive it. If it fails, stop building subtypes. You were never looking at kinds of a thing. Model the roles: the party in one place, each role it holds as its own entity with its own dates and its own rules. The test takes a minute and it tells you which of the two models you are actually in.

That's the whole rule, and it cuts three ways: **specialize what genuinely differs; generalize only what is genuinely the same; and when neither fits because the categories keep overlapping, you are holding a role, not a kind.** Model the boundaries of the concept, not the convenience of the schema.

## Closing

The definition lives in the dictionary. The meaning lives in the shape of the table.

You can run a flawless workshop, get every stakeholder to agree on what a product is and what a person is, write it all down in a clean glossary -- and still ship a model that quietly contradicts every word of it. Because the agreement was about what the concepts *mean*, and the table is a statement about which rows *are* those concepts. Those are different claims, and only one of them is what your reports read every morning.

A table that respects the concept's real boundaries tells the truth by construction. A table that flattens them tells a lie nobody chose to tell -- and keeps telling it, row after row, until someone opens a margin report and finds a crime scene that was never a crime.

**Before you close the tab:** count how many rows in your product table have a sale price. Then take the last supertype you modeled and run the partition test -- non-overlapping, exhaustive. Both exercises take a minute, and both will tell you something you would rather not know.
