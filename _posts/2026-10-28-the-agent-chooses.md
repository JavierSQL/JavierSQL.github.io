---
layout: post
title: "The Agent Chooses"
date: 2026-10-28 06:00:00-0600
description: "For an agent, every table is one step away. Only the name is left to choose by. Who decided which tables it sees?"
thumbnail: assets/img/feat-the-agent-chooses.webp
tags: [data-governance, data-management, business-intelligence, data-quality, rot-data, ai-agents, metadata]
categories: [who-decided-that]
---

![The Agent Chooses](/assets/img/feat-the-agent-chooses.webp)

*For an agent, every table is one step away. Only the name is left to choose by. Who decided which tables it sees?*

## The table that promised too much

[Last week](/blog/2026/the-rot-weighs/) I promised to come back to *r*, and to who chooses when the one choosing isn't a person. Two weeks ago, introducing this series, I drew a map with a row waiting for this story: "the agent that picks the table by its name". Here it is: an agent that built a whole model on the wrong table, because of the table's name.

It happened at a business conglomerate in Central America (retail and distribution): an agent built an inventory model on the wrong table. Nobody told it to. The name did.

The agent was Claude, Opus 5.5, directed by one of the junior consultants at Primus. I'm saying it up front for two reasons. It's true, and this post is also being written with Claude. It would be strange to hide one and not the other.

The request was an inventory model: stock, cost, and the kardex behind them. Kardex is what we call the inventory ledger in Latin America: every movement that adds or takes a unit or its cost from the warehouse. In the source system there's a table whose name, translated, is `inventory_movements`. Read the name again. Where would you go looking for the kardex? The agent went there too. It built silver on that table, then gold, then the semantic model, and it did a clean job: readable names, sensible relationships, measures that worked.

Then the numbers reached the semantic model, and the junior himself saw that they made no sense for the operation. Credit where it's due: the agent didn't catch it. The person did.

Here's what nobody knew yet. `inventory_movements` doesn't hold all the inventory movements, as it does in most ERP systems. It holds the ones no other document explains: the physical movements inside the warehouse. A sale moves inventory too. So does a purchase. A revaluation moves its value without moving a single unit. The real kardex is a `UNION ALL` of six tables (sales, purchases, revaluations and inventory movements among them), and it doesn't live in any table. It lives in code. Each of those tables speaks its own dialect, too: in sales the cost sits in `total_cost`, which plays the role `total_amount` plays in purchases, and revaluations don't use quantity at all.

In their defense, nobody thought to compare the number of sales transactions against the number of movements. Sales wasn't even in silver. The evidence showed up in bronze, where the invoice lines outnumbered the movements by far. The truth was sitting in the one layer nobody had promoted.

The junior and Claude put together a remediation plan: rebuild the kardex in gold as a `UNION ALL`. It was partly right. The senior consultant on the project wasn't sure, and it landed on my desk.

Look at what kind of mistake this is, because it isn't the one this series has been about. `inventory_movements` isn't ROT data. It's alive, it loads every day, and every row in it is correct. Its only problem is a name that promises more than the table holds. And the right answer, the full kardex, wasn't a table at all. It had no name. Last time I closed by saying nobody drew the map. This time the right store wasn't even on it, and a store that isn't on the map isn't even one of the options. Nobody walks into it, not a person and not an agent.

One more thing, which I'll pay off later: for the first hour, I thought the junior and Claude were the ones who had it wrong.

## What I didn't tell you about the map

Last time I told you about the red and blue dots in Guadalajara. I left one piece out, because it belongs here.

A catchment area draws customers *from* somewhere, and in Mexico that somewhere had a name: the AGEB. INEGI, the national statistics institute, divides the cities into *Áreas Geoestadísticas Básicas*, units of up to a few dozen blocks each, and publishes them in surprising detail: the polygon, plus the population and the characteristics of the housing inside it. Part of my two weeks went into reading those shapefiles, loading them into the SQL Server 2008 beta, and letting the new spatial types compute centroids, areas and distances. Our customers didn't come from dots on a map. They came from AGEBs.

That matters because of the formula. Newton, the formula I used last time, only has one mass pulling on another. In 1963 David Huff, a geographer, wrote down what retail had been missing: a customer choosing among stores. He turned the attraction into a probability: not "this customer goes to that store" but "this customer goes to that store this often". He writes it like this:

**P(i→j) = (Aⱼ / Dᵢⱼ^β) / Σₖ (Aₖ / Dᵢₖ^β)**

*j* is a store. *A* is how attractive it is. *D* is the distance from the customer's origin *i* to the store (the *r* from last time, with a new letter), and *β* says how fast the attraction fades with that distance. The denominator adds up every store that customer could reach. What comes out isn't a verdict, it's a share: of the people living in *i*, how many end up at *j*.

The letter I want you to look at is *i*. It's the origin, and in our model the origin was the AGEB: a centroid to measure distance from, and a census unit that told you who lived there. Once you have that, the question changes. It stops being "how attractive is this branch?" and becomes "how attractive is this branch to the people who live here?" A pawnshop doesn't mean the same thing to every neighborhood.

(I'm taking a liberty here, and I'd rather say so. In Huff's formula *A* belongs to the store, the same for everyone. Letting it depend on who's looking is my stretch, not Huff's.)

In data, the origin is a community of consumption: people who share a vocabulary, a set of skills and a purpose. Often that's a department, not always. My list of what attracts a user to a model started with "names in business language". Fine. Which business? For the warehouse, "inventory movements" means boxes moving between locations. For accounting, it means the kardex. Same name, two communities, two meanings, and both of them are right.

**The lesson:** attractiveness isn't a property of the table. It's a property of the table and whoever is looking at it.

Which leaves the question this post is really about. What happens when whoever is looking has no profile at all?

## Every copy is a new store

Before I get there, one more thing the map taught me in 2008: cannibalism.

Monte de Piedad wanted 80 new branches, and the first temptation with a list like that is to put them where you already do well. The formula punishes that. Open a branch next to one of your own and the denominator grows for every customer in the area. The new branch takes share from the competition, sure, but it also takes share from your own branch down the street. You can lose customers to yourself. And in the formula, it holds for any store: a new one doesn't have to beat the best one to hurt it. It only has to exist and look acceptable.

Now replace branches with tables. You ask for last quarter's sales and four candidates answer to the name: `sales`, the certified table in gold; `sales_final_v2`, an analyst's copy frozen in March; `fact_sales`, from the old warehouse, which stopped loading after the migration; and `sales_bkp_2023`, a full snapshot, the heaviest of the four. Every one of them sits in the denominator. Every one takes a piece of the probability that belonged to `sales`.

In the last post I said a cluster of copies adds weight without adding attraction. Here's the other half: it competes for the attraction the good table already had. And the way it competes depends on who's choosing.

A person who knows that business doesn't see four tables. They see one table and three copies. "Those are the old ones." They pick between *the real one* and *the copies* first, and only then, if at all, among the copies. Adding a fourth copy barely moves their odds. The formula doesn't know how to do that. For Huff every alternative competes on its own, and a fourth copy takes its share from everyone, every time.

(Economists know this as the red bus / blue bus problem: add a blue bus identical to the red one and the model thinks you've created a new way to travel. The fix, from the seventies, is to group similar alternatives into nests and choose among nests first -- the *nested logit* -- which is exactly what the person with context does without thinking about it.)

So for the agent, every copy whose name doesn't give it away is a new store. For the person, every copy is one more shelf in the same old store.

Which means Huff, written in 1963 to describe shoppers, doesn't describe very well the human who knows the data. It describes the agent, facing copies with good names.

## An origin with no profile

Go back to the formula and put an agent in place of the customer.

Start with *D*.

Madrid and Barcelona taught me what *D* measures. In the 2010s I made that trip dozens of times, and I almost always took the AVE, the high-speed train. On paper the plane wins: about an hour and a quarter in the air, against two and a half hours by train. But the train let me show up five minutes before departure, at a station in the middle of the city, and work from the first minute. The plane meant an airport, security, boarding, and a laptop that stayed closed until the seatbelt sign went off. (I took the Puente Aéreo, the no-reservation shuttle, exactly once.)

I wasn't the exception. Since the AVE opened in 2008, it has taken most of that market from the plane, about three passengers in four by 2023, without shortening a single kilometer. What it shortened was the effort.

Remember the Excel file on my laptop, the asteroid that pulls harder than the lakehouse because it's right there. For a person, distance is effort, and effort can play either way: it keeps the old Excel file close, and the dead table far. For the agent, that distance disappears. Everything in the schema it was given is one step away. No ticket, no search, no colleague to ask. *D* goes to one for every table, and *β* goes with it: whatever its value, one to any power is still one. The only thing left in the formula is *A*. (When the schema is too big and the agent searches it first, *D* comes back, as a search ranking. And the ranking is decided by the same thing: the name and the description.)

A person pays for *r* in payroll. The agent doesn't pay in distance. Every table in its scope is one more thing to read, ROT data included, so it pays in tokens, and in wrong answers.

In the last post I said attraction is what makes you walk over, and light is what you find when you get there. ROT data has the first and not the second. A person who gets to `fact_sales` might notice the dates stop last year. The agent doesn't look. It reads the label and gets to work.

Then look at *i*: an origin with no profile. It doesn't belong to the warehouse or to accounting. It doesn't know which tables "are the old ones". It judges attractiveness from the only thing it can see, the schema: the names, the columns and, if someone wrote one, the description. In other words, by the average of what a name means to anyone, and that's the ground where ROT data competes best.

There's evidence that the name carries a lot of weight. Researchers took a standard text-to-SQL benchmark and rewrote the questions, swapping the words that pointed at tables and columns for natural synonyms, nothing else, and the models' accuracy dropped by roughly 20 to 30 points. (Gan and colleagues, ACL 2021, the *Spider-Syn* paper. Their phrase is that the models "rely on the lexical matching" between the question and the schema.)

That's the failure from one side: take the matching name away and they get lost. Turn it around and you get the kardex: give the wrong table the matching name, and the same reliance sends the agent straight to it.

To be fair, the newer models are better at this than that paper suggests. A 2024 study found that strong reasoning models can pick out the relevant schema even when you hand them a lot of irrelevant tables (Maamari and colleagues, "The Death of Schema Linking?"). I believe it. But irrelevant isn't the problem. `bkp_customers_old` is irrelevant, and any decent model throws it away. `fact_sales` isn't irrelevant. It answers the question. It just answers it with last year's data.

Remember the list from the last post: ROT data can match the good data on five of six attributes -- the names, ease of navigation, metadata, quality, hidden complexity -- and the one it can't fake is relevance, which doesn't show up in the schema. The agent judges exactly those five, from the schema alone. Microsoft's own guidance for Fabric data agents says as much in plain words: don't put archived staging tables in the agent's scope, and if two of the objects you selected hold similar data, tell the agent which one is authoritative. In their words: "Don't rely on naming alone."

## The wrong profile

Now the hour I promised.

When the senior brought me the remediation plan, I read it and thought the junior and Claude had gotten lost. In my head `inventory_movements` *was* the kardex. I didn't have to think about it. I studied economics, I spent my first working years in administration, and for anyone who grew up near accounting, "inventory movements" means every entry that changes the quantity or the value of what's on the shelf. That's the kardex. In that system, it means boxes moving inside the warehouse.

I had the same reading as the agent. Worse: the agent was guessing from the name, with no profile. I had a profile, from another community, and it made me sure. The agent's guess can be caught by someone who looks at the numbers. My certainty had to be caught by me.

What changed my mind wasn't an argument. It was a pattern. In every inventory model I've built, the kardex is at least as long as sales and purchases put together, because every invoice line moves something off a shelf or onto one. So I went back to bronze and profiled the data myself, and I didn't need more than the row counts. For the operation of a company that size, the table had far too few rows. Next to sales and purchases, it wasn't even close. That ended the hour.

The rest was confirmation. I took the numbers to the client's IT team, and they agreed: `inventory_movements` only held the warehouse's own movements. Later, when I got access to their code, I found the `UNION ALL`. The kardex had been there all along. It just lived in code, where no map could see it.

**The lesson:** no profile is a risk. The wrong profile can be a bigger one, because it doesn't feel like a guess.

Once I saw it, the junior and Claude had the *what* right. The kardex needed to exist as something with a name. Where I disagreed was the *where*. Their plan built it in gold, inside one model, and I want business rules to live in silver, defined once, so data scientists, agents and gold can all reuse them instead of each of them rebuilding the logic in a schema that fits only their own use. So the concept went to silver, in the business vault: built once, not ingested, with views for the data scientists and for the gold star schema. Bronze didn't change.

That's the part I care about more than the modeling. A `UNION ALL` hidden in code has zero attractiveness, because it has no name. Giving it a name puts the right store on the map. And where you put it matters: in gold, it's the private knowledge of one model. In silver, every community -- warehouse, accounting, the next agent -- walks past the same door.

Anthropic found the same thing from the inside, in [the article I recommended before this series started](https://claude.com/resources/articles/how-anthropic-enables-self-service-data-analytics-with-claude). They gave their agent grep access to thousands of SQL files, every piece of prior work they had, and accuracy moved less than a point: "our bottleneck wasn't access to prior work, it was structure." The kardex had been in code all along. Code isn't a name.

## The ROT data version, with numbers

The kardex was the case where the right answer had no name. In my experience, ROT data is the more common case: I rarely meet a company with an archival plan. And it's the worse one: the right answer has a name, and so do three impostors.

Here are the four sales tables again, with numbers. A warning before you look: **this is a mental model, not a measurement.** The scores are made up, and nobody has calibrated Huff for tables. I set *β* to 1. In Huff it's estimated from data, and 1 is the conservative choice here: a steeper decay, say Newton's square, only widens the gap. The person goes to 76%, the agent doesn't move. The point is the shape, not the decimals.

| Table | What it really is | Person with context: A / D | Agent: A (schema only), D = 1 |
|---|---|---|---|
| `sales` | Gold, certified. The right one | 8 / 1 = 8 | 4 ("sales table", generic) |
| `sales_final_v2` | Analyst's copy, frozen in March | 2 / 1 = 2 (it's in their workspace) | 3 ("final" sounds definitive) |
| `fact_sales` | Old warehouse, stopped loading | 0.5 / 2 = 0.25 ("that one's dead") | 3.5 (`fact_` looks official) |
| `sales_bkp_2023` | Full snapshot, the heaviest | 1.5 / 2 = 0.75 | 0.5 ("bkp" gives it away) |
| **Chance of the right pick** | | 8 / 11 = **73%** | 4 / 11 = **36%** |

I'm using Huff for both columns so they're comparable. For the person, *D* is effort: 1 for anything in a workspace they already open, 2 for the old warehouse and the archive, which they'd have to go find. The real person does better than 73%: they nest, and the copies barely register. The agent's 36% is what Huff actually predicts.

Set the person's *D* to 1 and they still get 67% (8 out of 12). Distance isn't what separates them. The profile is.

Look at the bottom row and then at the heaviest table. The backup, the one that weighs the most, is the least dangerous: its name gives it away. The dangerous one is `fact_sales`, small and attractive. **The dangerous ROT data isn't the heavy one. It's the attractive one.** Mass explains the cost and the exposure; attraction explains the other risk.

Now the levers, same made-up numbers, applied to the agent:

| What you do                                                                        | Agent's chance of the right pick |
| ---------------------------------------------------------------------------------- | -------------------------------- |
| Nothing                                                                            | 36%                              |
| Say `sales` is certified where the agent reads it: its description (A from 4 to 8) | 53%                              |
| Also mark `fact_sales` as deprecated (A from 3.5 to 0.5)                           | 67%                              |
| Take `fact_sales` and the backup out of the agent's scope                          | 73%                              |
| Retire `sales_final_v2` too (only `sales` is left)                                 | 100%                             |

Certifying and deprecating get the agent from 36 to 67, and stop there. That's ranking: the bad table is still in the race, just further back. Getting to the person's 73% takes eligibility: taking things out of scope, so the impostors never enter the denominator. Anthropic's version is structural: for their canonical datasets, "the agent is structurally routed to them first", by tooling, by CI and by mandate.

The 100% is the model being trivial: one store, nothing to choose. It lasts exactly as long as the scope does. Hand the agent all of silver instead of the doors you chose for it, and the denominator fills up again. The scope is a decision with an owner, not a setting.

The vendors are building those first two. Fabric shows endorsed items with a badge and lists them first in some places; Databricks lets you mark a table certified or deprecated and says that helps Genie One prioritize the assets your organization vouches for; and plenty of catalog search tools rank results by popularity. Useful, all of them. But notice the last one: if everyone uses `sales_final_v2`, popularity pushes it up. A ranking by use rewards attractive ROT data.

And it gets worse with time. Say `sales_final_v2` was the right table for six months, and everyone learned to use it. Then `sales_final_v3` shows up. What should the agent do? By name, v3 looks newer, so a curious agent jumps to it the day it appears, validated or not. By popularity, v2 stays on top for months after it stopped being right. Neither signal answers the question, because the answer is a decision: who certified v3, and when v2 retires. A version suffix is a decision nobody wrote down.

Copies aren't the only impostors. Time makes them too: last year's rows, still sitting in the right table. Those take deleting, and deleting doesn't have to be final. In the last few years I've stopped writing gold SLAs as "data since 2020". A fixed start date is a contract that fills up with ROT data a little more every year. I write them as a window instead, usually the last five to seven calendar years. On January 1, 2027, the load stops bringing 2020 into gold and removes what was there. The layer underneath doesn't change: silver, the data vault and the business vault, or the warehouse, when the architecture is a warehouse with data marts on top. The marts get the same window. The history stays where it's governed. It just leaves the shelf where users and agents shop.

Anthropic marks deprecated models in its lineage graph, and as far as their article says, it doesn't delete them. Marking something old is a decision anyone can make. Deleting it needs an owner, and so does any cut that takes something off the shelf without deleting it. Last time, the customer table got one: the product owner signed a subset for receivables. Nothing deleted, and the same eligibility move, made for a model instead of an agent.

## Your Monday worksheet

> **Probability of a right pick.** Twenty minutes, one question.
>
> 1. Pick a question your users or your agent get asked often. "Sales last quarter" works.
> 2. List every table or dataset whose *name* would answer it. Include every version, not only the latest.
> 3. Give each one an A from 0 to 10, twice: once as someone who knows the business, once reading only the schema.
> 4. For the person column, give each a D from 1 to 3 (1 = already in my workspace, 2 = I'd have to go find it, 3 = I'd need a ticket). The agent's D is 1, unless it searches the schema first; then score the search, not the distance.
> 5. Compute each table's A/D, and the right one's share in both columns.
> 6. Decide per row: make its certification visible, deprecate it, take it out of the agent's scope, or retire it. Score again.
> 7. Before you trust any table, do the check nobody did in the kardex case: compare its row count against something whose size you already know. Invoice lines against movements would have caught it in five minutes.
>
> My rule of thumb: if, by your own scores, the agent is more likely to pick a wrong table than the right one (under 50% in the agent column), don't point an agent at that area yet. The number is as rough as your scores. The comparison isn't.

And one question the worksheet can't answer for you: when you scored "as someone who knows the business", *which* business were you?

## Who decided what the agent sees?

The agent built a model on `inventory_movements` because the name promised it. Who decided that the kardex would live in code, with no name, where nothing could choose it? Who decided which tables the agent would see, and which of them it would believe? Nobody. Somebody handed it a schema, and the names did the rest.

In 2008 the map had every branch on it, and the people who knew the business argued over it. In that conglomerate the right store wasn't on the map, and the only one arguing was a junior who looked at the numbers and didn't believe them. He was right. I needed an hour to catch up.

One last thing, because it's the next post. Suppose that, to help the next agent, someone asks an LLM to write the description of `inventory_movements`. I'm fairly sure what it would write: "Contains all inventory movements." The next agent would read it and believe it, this time with a description to back it up. Who wrote that description?

*This is the second of ten posts in* Who Decided That? *The cloud and AI made it cheap to create, copy and keep data. They didn't make it any cheaper to decide.*
