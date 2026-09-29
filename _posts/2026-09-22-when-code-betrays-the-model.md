---
layout: post
title: "When Code Betrays the Model"
date: 2026-09-22 06:00:00-0600
description: "The definition was right. The code said something else -- and nobody was reading the code."
thumbnail: assets/img/feat-when-code-betrays-the-model.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-modeling, data-quality, metric-implementation]
categories: [trust-erosion]
---

![When Code Betrays the Model](/assets/img/feat-when-code-betrays-the-model.webp)

*The definition was right. The code said something else -- and nobody was reading the code.*

An agricultural company I worked with tracked employee turnover, and the definition was textbook-clean: the number of employees who leave during a period, divided by the average headcount over that period. Nobody argued with it. There was nothing to argue with.

What made me look was not distrust of the method. It was that the numbers did not add up against each other: the year's turnover did not resemble the average of each month's turnover, and it should have. An average of averages does not stray that far from its parts. So I went to see how the denominator was computed.

It was the headcount on the first day of the period plus the headcount on the last, divided by two. A two-point average. For a company with a flat workforce, that is fine. This one was not: around 7,000 employees, close to 60% seasonal, the workforce swelling and shrinking with the harvest. Many of those seasonal workers travel to Nicaragua at year-end, so December 31 and January 1, the two exact days the calculation used as its denominator, always fell in the seasonal trough.

Watch what that does. Those two days at the edge decide the whole average. Because here year-end was always a low, the two-point average came out low, the denominator shrank, and turnover looked higher than it was. In another company, where the cutoff landed on a peak, the opposite would happen: the denominator swells and turnover looks lower. Either way the number is lying about the year, because two days at the edges cannot represent a curve that moved all twelve months. I checked it the simplest way: between 15% and 20% of the people who worked that year did not appear in either cutoff. One in five real employees never entered the denominator that claimed to count them.

The faithful version is not complicated -- average the headcount across every month, all thirteen boundary points, so the denominator reflects the period it claims to describe. The definition said "average headcount over the period." The code said "average of two days." Those are two different claims about the company, and no one had noticed, because both of them produce a believable percentage.

## A formula is a claim about the business

This failure is unlike any other in the series. Until now I have written about numbers that misled because of how they were defined, aggregated, bounded, or gamed. This one is about a number whose definition was correct and whose implementation was not.

Code does not invent meaning. It materializes it. When the code that implements a metric drifts away from the definition the business agreed on, it does not throw an error and it does not raise an alert. It just quietly starts making a different claim about the business, in a number that looks exactly as plausible as the right one would have. There is no technical failure to catch. There is only a believable figure that means something other than what was promised.

And that plausibility is the whole problem, because of how these things get reviewed. When someone validates a measure, almost nobody reads the formula against the definition. They look at the output and ask whether it seems reasonable. A turnover of 14% seems reasonable. A turnover of 19% seems reasonable too. A two-point average is invisible at the output layer, because its output is a perfectly ordinary-looking percentage. The review checks whether the number looks right, never whether the formula says what the model meant. The camouflage is built in.

## The one everybody half-remembers

The textbook version of this is margin versus markup, and you have probably seen it argued about online. The model defines gross margin precisely:

```dax
// Definition: Gross Margin % = (Sales - Cost) / Sales
```

The developer implementing the measure writes this instead:

```dax
// WRONG -- this is markup, not gross margin
Gross Margin % = DIVIDE( [Net Sales] - [Cost of Goods Sold], [Cost of Goods Sold] )
```

Both return a percentage. Both look reasonable on a dashboard. Nobody catches it, because nobody checks the formula against the definition: they check that the numbers "look fine." The error surfaces three months later, when the category team compares against an industry benchmark. The model reports 42% margin in a category where the sector runs 28%. The gap is not the market. It is the denominator.

Here is the part the online arguments miss. They fixate on the math: which denominator is correct, how to remember the difference. That is not the lesson. The lesson is that for three months, the dashboard had been making a *different claim about the business* than the one the company thought it was making, and people had been pricing, planning, and comparing on the strength of it. The fix is one line of DAX:

```dax
// CORRECT -- faithful to the model's definition
Gross Margin % = DIVIDE( [Net Sales] - [Cost of Goods Sold], [Net Sales] )
```

One line. A quarter of decisions made on a different business than the one in the room. And notice where the betrayal lived: the same place it lived in the turnover case. The numerator was honest. The denominator was the lie. In the everyday case that is exactly the pattern: the numerator behaves and the denominator does the quiet damage. The boldest inventions can flip it, though, and move the lie into the numerator itself.

## When the formula goes public

Inside a company, a betrayed formula costs you a few wrong decisions and an awkward meeting. When the formula is reported to investors, it can cost you a lawsuit.

In 2004, Netflix reported subscriber churn. Their formula divided cancellations in the quarter by the sum of the beginning subscribers and the gross new subscribers added that quarter. Read that denominator again: it included the new subscribers. So in any quarter where Netflix was adding a lot of customers (which was most of them), the denominator ballooned and the churn rate came out low. Lower than the experience of customers actually leaving would suggest. The definition of churn that other companies used, telecoms like Sprint and Nextel, divided cancellations by the *average* number of subscribers over the period.

When Netflix disclosed the actual cancellation numbers for prior quarters in July 2004, the gap was visible, and a shareholder suit followed, alleging the company had understated its churn through the calculation method itself. I am not telling you how that litigation resolved, and it does not matter for the point. The point is that a choice of denominator (the kind of thing that lives unremarked in a spreadsheet, decided once by whoever built the measure) became the basis of a securities-fraud allegation. The formula was a claim about the business, and claims a company makes to investors are legally load-bearing.

It gets sharper when the formula is not a mistake but an invention. Groupon walked into its 2011 IPO with a metric it called Adjusted Consolidated Segment Operating Income. The trick was in what it left out: it amortized online-marketing costs as if they were a capital investment rather than the cost of buying the quarter's customers. That one move turned a $420 million operating loss into $60 million of "income" -- until the SEC pushed back and the metric came out before the company went public.

WeWork did the same surgery on profitability. Its "Community-Adjusted EBITDA" subtracted the usual interest and taxes, and then kept subtracting -- rent, marketing, general and administrative overhead -- until a business losing money on every building read as profitable. The denominator games hide in plain percentages; these inventions rewrite the numerator itself, adding back the very costs that define whether the business works. Markets and regulators have learned to treat a creative formula as exactly what it is: a claim about the business, dressed up as a measurement.

## The cure: read the formula against the promise

You do not fix this with better arithmetic. You fix it by changing what gets reviewed.

**Validate the formula against the definition, not against the output.** The output will always look plausible -- that is the trap, not the exception. Someone has to put the DAX or the SQL next to the model's stated definition and confirm, line by line, that they make the same claim. At the agricultural company, no one had put those two things side by side; the day I finally did, the distance between "average over the period" and "average of two days" showed up in an afternoon. "Average headcount" in the definition has to be the same average the code computes. "Gross margin" has to divide by sales, because that is what the word was promised to mean. This is boring work and it is the only work that catches the betrayal.

**Treat the model as the contract.** When the code cannot implement the definition exactly (a data limitation, a performance ceiling), the move is to go back to the definition and change it, in the open, where everyone can see the new promise. You do not quietly patch the code to do something the definition does not describe. A silent patch is how a contract gets rewritten without anyone signing it, and it is indistinguishable, three months later, from the bug it pretends not to be.

**Make the definition and the code traceable to each other.** The measure should carry its definition with it: a description, documentation, the model under version control so the formula's history is visible. Then a reviewer can check the promise against the implementation, and so can an auditor a year later, and so, if it ever comes to that, can the expert witness reading your measure in a deposition. A formula you cannot trace back to a definition is a claim nobody can defend.

## Closing

This is where the series began, turned inside out. [The first post](/blog/2026/false-semantic-consensus/) was about a definition that everyone agreed on and no two people actually shared: meaning that was missing. This one is about a definition that everyone agreed on, that was captured and signed and correct, and that the code quietly ignored: meaning that was present, and then rewritten in translation, in the one place nobody was reading.

A formula is not a technical detail to be delegated and forgotten. It is the most precise claim your organization makes about itself, and it is written in a language most of the people who depend on it cannot read. That gap (between the people who decide what a number means and the people who implement what it actually computes) is where the betrayal lives, silent and plausible, until the day it is a benchmark that does not match, a board that cannot defend its growth number, or a court reading your churn formula back to you.

So read the formula against the promise. And when you want to know what a metric is really claiming, do what almost nobody does: read the part no one else bothers to (the denominator, or the quiet adjustment slipped into the numerator) because the numerator everyone quotes tells you what they measured, and that quiet part tells you what they meant.
