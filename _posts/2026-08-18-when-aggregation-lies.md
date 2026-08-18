---
layout: post
title: "When Aggregation Lies"
date: 2026-08-18 06:00:00-0600
description: "The general manager wanted his quantity column. The model kept returning a blank. The thirty minutes that followed were not about the formula."
thumbnail: assets/img/feat-when-aggregation-lies.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-modeling, data-quality, unit-of-measure]
categories: [trust-erosion]
giscus_comments: true
---

![When Aggregation Lies](/assets/img/feat-when-aggregation-lies.webp)

*The general manager wanted his quantity column. The model kept returning a blank. The thirty minutes that followed were not about the formula.*

This happens to me about once a month, and that's a conservative count. Big clients and small ones, production models and half-hour demos. Somebody sums a column called QUANTITY, and somebody divides revenue by that sum to get an average price. Both operations are the most normal thing in the world. Neither one is right.

What makes the time I want to tell you about memorable is that I watched it from outside.

Costa Rica, 2021 or 2022. An importer of chemicals and packaging material. Ricardo, one of our mentors, was presenting a new version of the sales analytics model to the client. The general manager wanted his quantity column, the one he had used for years. In the new model that column went blank whenever the things underneath it were not addable to each other, and in that catalog they almost never were. Living in there together: chemicals sold by the pound, chemicals sold by the 55-gallon drum (an *estañón*, where I come from), empty bottles counted by the unit, and sacks whose weight changed from one product to the next. None of it lives on the same scale. So the general manager asked for a number and the dashboard handed him an empty cell.

I was Ricardo's boss and I was in the room. I said nothing. I decided to watch him work.

(A parenthesis about the word *mentor*, because at Primus Data it's a title and not a term of endearment. We separate mentoring from consulting in what we sell: from a consultant you buy the solution, from a mentor you also buy the transfer of the knowledge. I mention it because it explains what happened next better than any praise I could write about Ricardo. The thirty minutes that followed weren't a personality trait. They were the job.)

## The thirty minutes

The easy path was in plain sight and took two minutes: drop the condition from the measure. The sum exists, the engine computes it without complaint, the general manager leaves happy, and the meeting ends twenty minutes early.

Ricardo spent half an hour explaining why the quantity lied and why the average price lied. He wasn't defending a formula. He was defending a meaning, which is the part of the work you can't delegate to the engine.

That's the scene I care about in all of this, and it's the reason this post exists. The technical half of this problem is four lines of code. What's hard is holding an empty cell in front of someone who has spent years making decisions with the number that used to fill it.

Because the sentences that number authorized sound impeccable. *We sold two million more in quantity than last year.* That does not mean we sold more. *The average price line is trending down.* That does not mean we're selling cheaper. Each one has a subject, a verb, a figure, and a comparison against the prior period. They're grammatically perfect and they're claims about nothing.

## Adding a drum to a thousand bottles

Here is the thing that took me years to say cleanly: *the sum looked like math, but it was a claim.*

When you write `1 + 1 + 1 = 3`, the result is only true if the three ones are the same kind of thing. A drum of chemical, plus a thousand empty bottles, plus one sack does not equal three of anything. There is no unit in which that 3 is a quantity. It is three labels counted as if they were three measurements.

The plus sign carries a hidden assumption every time you use it: *these things are commensurable, same kind, same unit, addable.* In honest arithmetic you declare that assumption out loud. In a spreadsheet, the plus sign makes the claim silently, and nobody in the room signs off on it. You did not decide that a drum and a thousand bottles belong in the same total. The SUM function decided for you, and it does not ask.

So "quantity = 3" is not an imprecise number. It is an *undefined operation* wearing the costume of a defined one. Adding a drum to a thousand bottles is the same category of nonsense as adding a drum to a Tuesday. The spreadsheet will return a number either way. The number is the lie.

A column called QUANTITY looks clean, and row by row it is: every number is a real quantity, genuinely measured, in its own unit. The trouble starts when you stack them. One row counts kilos, the next liters, the next pieces, and underneath all of them sits a label, the product type, that nobody decided to sum across on purpose. (The more academic reader will recognize Stevens' levels of measurement here: you count labels, you don't add them. What sent me down this line of thinking was a Joe Celko piece on nominal scales, and I've distrusted every column named after a generic noun ever since.)

Then a second number gets built on top of that sum, and it's the one that reaches the meeting. Average price is revenue divided by that quantity, and a ratio is only as sound as its denominator. The denominator here is a pile of different units pretending to be one, so the average price that looks so precise is measuring nothing at all.

The old folk version says it better than any textbook: you cannot add apples and oranges. The phrase survives because it is a reminder, not a prohibition. You *can* add fruit, if you first agree what "a fruit" is. The whole problem lives in that "if."

## Why this lie is worse than an error

A wrong number announces itself eventually. A formula that divides by the wrong column throws an error, or returns something absurd on its face, and someone catches it. The aggregation lie does none of that. It produces a clean, plausible, precise-looking number, and precision is persuasive.

That average price came with decimals. It sat in a tidy column next to last year's figure. It fed a percentage change, which fed a sentence, and that sentence sounded like a fact. Nobody doubted it. And they didn't doubt it precisely because it looked so much like every other true number they had ever acted on. The lie does not look like a mistake. It looks like rigor.

And that is how it requisitions resources. A meeting that opens with a moved average is not headed toward "let's double-check the math." It's headed toward "let's understand the cause." Did the supplier mix change? Did a price adjustment slip through? Is demand shifting toward premium lines? I have watched teams get within minutes of spending weeks reverse-engineering a movement in a number that was never a measurement. The aggregation lie does not just sit on a dashboard. It hands out assignments.

## The cure: declare the unit before you add

The fix is not "stop aggregating." Aggregating is the entire point of a reporting system. The fix is to make the hidden claim explicit: to agree on a unit of equivalence before the plus sign runs.

And here it pays to look again at that importer's sacks, because they are the hard case hiding in the list. Bottles against drums is an obvious clash: nobody really believes those are the same thing. Sacks are different. Every sack is a sack, the column looks homogeneous, and yet a sack of one product doesn't weigh what a sack of another does. Summing sacks looks legitimate and isn't, which is the dangerous version of this problem: the one that gives you no signal.

The cleanest example I know of how that gets solved comes from Dole. They export bananas in boxes that do not all weigh the same, which is the sack problem at export scale. Sum "boxes" and you are back in drum-plus-thousand-bottles territory, because a box is not a consistent unit. So they defined one. The *Dole Box* is a fixed quantity of banana, and every shipment is converted into it: units multiplied by their weight, divided by the standard box weight. Now the sum means something, because everyone agreed on the unit before they summed.

That is the whole discipline in one move. Dole did not ban the total. They earned it. They declared the unit of equivalence in the open, so the addition rests on an agreement instead of an accident.

## Make the model refuse to lie

The other move lives in the model itself, and it was the one on screen the day of that meeting: making the semantic layer decline to add what is not addable.

The rule is simple to encode. Only sum a quantity when there is a single unit of measure in scope. In DAX, that's a few lines:

```dax
Quantity =
IF(
    DISTINCTCOUNT( SalesLines[UnitOfMeasure] ) = 1,
    SUM( SalesLines[Quantity] ),
    BLANK()
)
```

Slice to a single unit, pounds only, bottles only, and the measure sums and returns a real number. Mix units, and it returns blank. Not a wrong total. Nothing. The model declines to answer a malformed question.

A blank is more honest than a confident wrong number. The empty cell sends someone to ask "what unit are we in?" instead of sending a team to hunt a cause that was never there.

**Technical note, for whoever implements this.** The unit has to be counted over the rows you are summing, not over the catalog. If the measure counts distinct units on the product dimension, it is measuring the entire catalog rather than what's in the visual: it will blank out cells where only one product type was actually sold, and it will let mixed totals through. That's why the unit column above lives on the sales line. That's also where it tends to live for real: the same product sells by the unit at retail and by the case at wholesale. If in your model the unit of measure only exists on the product, force the count against the facts:

```dax
UnitsInScope =
CALCULATE( DISTINCTCOUNT( Products[UnitOfMeasure] ), SalesLines )
```

This is illustrative, not a finished pattern. In a real model you might surface a message, or force a breakdown by unit of measure, instead of blanking. The point is the stance: the rule ends up written in the place where the plus sign was breaking it silently.

And here's the warning Ricardo's scene makes plain: the blank doesn't win the argument, it starts it. A model that refuses to lie hands a human being the work of explaining why. If you don't have someone willing to stand in front of the general manager for half an hour, that condition will last until the first Friday somebody is in a hurry.

## "Everybody does this wrong. So what's the alternative?"

Those were the client's two questions at the end, and they're the right ones. The first is easy: yes, everybody does it wrong, which is why this post is about an operation all of us run several times a day. The second is the one that matters, because taking someone's number away without handing them another isn't data governance, it's obstruction.

The answer is called **PVM analysis**, for price, volume, and mix. I didn't invent it and it isn't new: it's an old tool from financial and commercial analysis. It decomposes the change in revenue (or margin) between two periods by where the change came from, instead of collapsing it into a single ratio:

- **Price effect.** How much of the change comes from the same products selling at a different price.
- **Volume effect.** How much comes from selling more or less of the same things.
- **Mix effect.** How much comes from a change in the composition of what was sold, with no price moving at all.

There is the phantom, with a name on it. An average price that rises without any price rising is **mix effect**, reported as if it were price effect. PVM doesn't repair the ratio. It relieves the ratio of a job it couldn't do: it splits into three figures what the ratio was blending into one.

And this is the part that makes PVM the right ending for this post rather than a tangent. PVM is computed per product, or per comparable family, and only then aggregated. What gets summed at the end isn't quantities, it's **effects in money**, and money is a consistent unit. PVM works because it aggregates in currency what should never have been aggregated in "quantity."

Which means PVM doesn't rescue you from this post. It presupposes it. It needs a volume defined inside a perimeter where the unit is one single thing, and if you never declared that perimeter, your mix effect comes out contaminated all the same, only now with three more decimals and a technical name that sounds like somebody checked.

I built my first PVM about twenty years ago, for BTICINO in Costa Rica. Both things came out of that job at the same time: the decomposition as the answer to the manager's question, and the habit of making my quantity calculations conditional, in SQL, in MDX, and today in DAX. Honestly, I can't tell you which came first. I don't know whether I learned to decompose because I distrusted the average, or whether I started distrusting the average because I had seen the decomposition. I can't remember the first time a summed QUANTITY column made me wince, either. All I know is that by the time Ricardo walked into that meeting, the blank was already house practice, and he didn't have to invent it. He inherited it.

## Closing

Every sum is a claim about commensurability. The honest version states the claim and puts a name on the unit: the Dole Box, the comparable family, the agreed standard. The dishonest version, almost always by accident, buries the claim in a column called QUANTITY and lets the plus sign decide on the organization's behalf. One declares. The other hides. Both return a number with decimals.

The general manager was convinced. That model is still in production, and the measure still hides the value when it's asked to sum things that don't add up. I tell it not because it's a happy ending, but because the price of that ending was thirty minutes of a mentor explaining meaning instead of two minutes adjusting a formula, and that bill almost always gets paid the other way around.

I have to admit the bias, because at this point it gets in my way: on this subject I'm stubborn. I have seen it so many times that it looks obvious to me, and I struggle to understand how people don't see it. I know that difficulty of mine is part of the problem and not part of the solution, because the person who walks into a meeting convinced something is obvious doesn't explain: he gets impatient. Ricardo's thirty minutes worked precisely because he still had the patience to explain it.

So if you're about to sum a column named QUANTITY, the question isn't whether the number will come out. It will. The question is in what unit, and who signed off that those things were the same thing.

And you? If you have an average in production that nobody has ever audited, look at the denominator before you look at the trend. Tell me what you found.
