---
layout: post
title: "The Table Is Not the Concept"
date: 2026-08-06 08:00:00-0600
description: "You can define the concept perfectly and still model it wrong."
thumbnail: assets/img/feat-the-table-is-not-the-concept.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-quality]
categories: [trust-erosion]
giscus_comments: true
---

![The Table Is Not the Concept](/assets/img/feat-the-table-is-not-the-concept.webp)

*You can define the concept perfectly and still model it wrong.*

A margin report at a manufacturer flagged a problem. Hundreds of products were selling below cost, some with no sale price at all, just an internal cost and a negative margin that made the whole product-profitability dashboard look broken. Finance opened an investigation. Somebody was pricing things to lose money, or the cost data was broken, or both.

Neither. The definition of "product" was fine. Everyone in the room could tell you exactly what a product was. The problem was the table.

The `Products` table held products, and it also held intermediate materials, work in process, samples, internal codes for things that move between plants but never reach a customer. None of those have a sale price, because none of them are sold. Run a margin report across that table and you get hundreds of "products" with no revenue and full cost. The number wasn't miscalculated. The population was the wrong shape.

This is the antipattern that hides under the previous one. You can agree on what a thing *is* and still disagree (silently, structurally) about which rows are that thing. Agreeing on the definition is the easy part. The table encodes a different answer, and the table is the one your reports actually read.

## The flag the demo got right

Here's the part that should sting, because it inverts the usual complaint.

Most of the time, the vendor demo skips the hard part. The happy path runs, the data is clean, and the messy reality you live in never shows up on the slide. Not here. Open AdventureWorks (Microsoft's sample database, the one in every tutorial) and look at the `Product` table. There's a column called `FinishedGoodsFlag`. The demo modeled the distinction. It knew, out of the box, that not every row in a product table is a sellable product.

Then real production databases drop it. The flag exists, or a column like it, and nobody populates it, nobody filters on it, and over a few years the table fills with finished goods, intermediates, samples, and obsolete codes, all flat, all equally "products." The demo got the modeling right and the practitioners forgot. That's the opposite of what I usually argue: the tool handed you the distinction and the discipline threw it away.

The mechanism is simple. An intermediate material has a cost and no price. A sample has neither. Count them as products and your product count inflates. Average a margin across them and the average is fiction. Build a catalog from them and half of it is unsellable. The concept "product we sell" never changed. The *extension* -- the actual rows in the table -- quietly stopped matching it.

Nobody defined "product" wrong. The table just admitted things the concept excludes, and no one was watching the door.

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

There's a name for the lookup-table cousin of this instinct. Joe Celko spent years warning about the One True Lookup Table: the urge to fold every code and category into a single all-purpose table. (Paul Keister coined the term; Celko made the critique famous.) A lookup table isn't an entity table, so it isn't quite the same failure. But the instinct is: one table to rule them all, convenient for the person building it and ruinous for everyone reading it.

Eric Evans comes at it from the other direction. The whole point of a model, in Domain-Driven Design, is to serve the language the domain experts actually speak. When your model fuses two concepts the business keeps separate (when "professor" and "student" become an undifferentiated "person"), you've stopped speaking the domain's language. The model got simpler and the meaning leaked out. As Evans puts it, persistent use of the shared language will force the model's weak spots into the open. A `Person` table that can't tell you who teaches and who enrolls is a weak spot hiding in plain sight. Listen to how the domain says it, too: nobody at a university says "she is a professor-type person." They say she *teaches*, and he *enrolls*. The business was speaking in roles the whole time.

## Same axis, opposite ends

Step back and the two failures are the same mistake pointing in opposite directions.

|                   | What it does                                       | The cost                                               |
| ----------------- | -------------------------------------------------- | ------------------------------------------------------ |
| The product table | Won't specialize -- lumps distinct kinds together  | Counts and margins include things that aren't products |
| The person table  | Types a role as if it were a kind of thing          | Loses the meaning of professor vs. student             |

One refuses to draw a line that exists. The other erases a line that matters. Both flatten a real taxonomy into a single, undifferentiated table, and both leave you with a table whose shape no longer matches the concept it claims to hold.

There's old language for what's going on. The *intension* of a concept is what it means: what makes something a product, or a professor. The *extension* is the actual population: which rows exist, and of what kind. Agreeing on the intension does nothing for the extension. You can write the perfect definition and still build a table that disagrees with it.

Because here's the thing a table actually is: a claim about what exists. Every row asserts "this is one of these." Flatten the table and you've made a claim you never meant to make (that intermediates are products, that professors are interchangeable with students), and every query downstream takes that claim at face value.

## Every metric inherits the shape of the table

This is why it isn't a cosmetic problem. A metric is only as honest as the population underneath it. Product count, average margin, headcount, active-customer totals -- none of them are computed from the definition in your glossary. They're computed from the rows in the table. If the table's shape is wrong, the metric is wrong, and not because anyone made an arithmetic error. The error was committed at design time and inherited ever since.

And like most of these problems, it survives because it looks normal. The table was always shaped this way. Nobody remembers deciding it; it's just how the system works. That's not a technical fact, it's modeling debt that hardened into a convention nobody re-examines.

## The cure: model the ontology, not the convenience

Both failures get fixed by the same discipline: model the concept's real boundaries instead of the columns that happen to overlap.

For the product table, that means specializing. Finished good, intermediate material, sample: distinct types under a common parent, each with its own rules about what it is and what you can do with it. The `FinishedGoodsFlag` is the minimum viable version of this; an actual product type hierarchy is the real fix. Either way, the rule is the same: a margin report should query "finished goods," not "everything that ended up in the products table."

It is worth measuring the tooling against that rule, because the industry is finally building for this. Microsoft has been putting an Ontology item into Fabric: entity types, properties, relationships, bound to data sitting in OneLake. The diagnosis behind it is exactly right, and it is the diagnosis of this post -- a concept deserves to be modeled above any single table.

The implementation, as of August 2026, is in preview, and it lands on the wrong side of this argument in two places. An entity type takes one static data binding, and you cannot combine static data from more than one source into it. Nor is there a step where you narrow a source to a subset of its rows: you choose a table and you get the table. So bind `Product` to that `Products` table and your `Product` entity type will hold the intermediates and the samples, faithfully. Generate the ontology from a semantic model and you get one entity type per table, by design. And there is no subtype -- an entity type takes a name and some properties, with no parent -- so "finished good under product" is not a thing you can currently say.

Half the cure does survive, and it isn't the half I expected. Relationships carry attributes, including validity, which is the role model working as intended.

The workaround is the part worth sitting with. You build tables filtered and modeled on purpose, purely to feed the ontology. That works. And notice what it means: the modeling did not move up into the semantic layer. It stayed down in the table, where it always was, and the ontology inherited whatever shape you handed it.

None of which is a verdict. Microsoft ships a minimum viable version and adds to it, this is early in that cycle, and I expect these gaps to close -- the direction is good news for anyone who has spent years arguing that concepts belong above tables. It is just too early to get much leverage out of it. And no version of it, however complete, is going to excuse you from the modeling.

We did exactly that, by hand, years before there was an ontology item to feed. The first version of the filter was the obvious one: in the analytics layer, only include products that had ever been invoiced.

```sql
select distinct ProductCode from Sales
```

It worked. The intermediates went away, the samples went away, and the margin report stopped reporting crimes.

It also had a side effect I had not thought about. A product that is perfectly sellable but has not sold yet is not in that list. New items, seasonal items, the ones the catalog is betting on next quarter: all of them dropped out of a report about the products we sell. The consequence was mild and we lived with it for a while, but look at what had happened. I had fixed a population that was too wide by making it too narrow. The extension still did not match the concept. It just missed in the other direction.

That mistake is worth naming, because it is an easy one to repeat. Filtering by sales history defines the concept by its *extension* -- by what happened -- when what I needed was its criterion. Having sold is evidence that a product is sellable. It is not what makes it sellable.

What finally fixed it was a different table: the price list. A product with a price is one the business has decided to sell, whether or not anybody has bought it yet. That is a membership condition, maintained by people who maintain it for their own reasons, and it says what `FinishedGoodsFlag` was always trying to say. The population stopped being a residue of past transactions and became a statement about intent.

For the person table, it means running the partition test before you decide where anything goes. Non-overlapping, exhaustive: can every instance land in exactly one bucket, and does every instance land somewhere? Natural person against legal person passes. Professor against student does not. If it passes, specialize -- distinct subtypes under a common parent, shared attributes in the parent, and the supertype is legitimate precisely because the subtypes survive it. If it fails, stop building subtypes. You were never looking at kinds of a thing. Model the roles: the party in one place, each role it holds as its own entity with its own dates and its own rules. The test takes a minute and it tells you which of the two models you are actually in.

That's the whole rule, and it cuts three ways: **specialize what genuinely differs; generalize only what is genuinely the same; and when neither fits because the categories keep overlapping, you are holding a role, not a kind.** Model the boundaries of the concept, not the convenience of the schema.

## Closing

The definition lives in the dictionary. The meaning lives in the shape of the table.

You can run a flawless workshop, get every stakeholder to agree on what a product is and what a person is, write it all down in a clean glossary -- and still ship a model that quietly contradicts every word of it. Because the agreement was about what the concepts *mean*, and the table is a statement about which rows *are* those concepts. Those are different claims, and only one of them is what your reports read every morning.

A table that respects the concept's real boundaries tells the truth by construction. A table that flattens them tells a lie nobody chose to tell -- and keeps telling it, row after row, until someone opens a margin report and finds a crime scene that was never a crime.
