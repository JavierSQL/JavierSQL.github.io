---
layout: post
title: "The Number Without Perimeter"
date: 2026-08-27 06:00:00-0600
description: "+12%. Correct to the decimal. Nobody in the room could defend it."
thumbnail: assets/img/feat-the-number-without-perimeter.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-modeling, data-quality, financial-reporting]
categories: [trust-erosion]
---

![The Number Without Perimeter](/assets/img/feat-the-number-without-perimeter.webp)

*+12%. Correct to the decimal. Nobody in the room could defend it.*

The slide said it in large type, dead center: **Sales Growth: +12%.** The CEO presented it to the board the way you present good news, which is to say briefly, expecting applause.

Then a director asked a question. "Does that include the eight stores we opened this year?"

Silence. The analyst who built the model was not in the room. The CEO did not know. And here is the part worth noticing: the number was not wrong. Nobody had miscalculated anything. The +12% was correct to the decimal. It just could not survive a question.

## First, a confession: this meeting never happened

I built it.

It's the opening scene of a book I'm writing -- the first of a trilogy, in Spanish, on semantic models for sales analytics: *Diagnóstico Analítico de Ventas*. That scene is the case the whole book is built on, and I'm bringing it here because the post and the book argue the same thing.

I say so up front for two reasons. The first is that if I told you this as something that happened to me, it would be a lie, and a series about eroding trust cannot afford one. The second is more useful: the scene isn't a case, it's a composite. I saw each piece somewhere different, and I assembled the meeting so all four edges break at once -- which in real life they never do. They arrive one at a time, years apart. You'll recognize some part of it, larger or smaller. That recognition is the point.

The figures in the scene, +12% included, are illustrative. They're built to add up, not measured. What is real is where each edge came from, and that's what I'll tell you in each section.

With that on the table, back to the room.

## Four questions and no answers

One good question breeds others, and the room found them fast. Up 12% compared to *when*: last month, or last year? If last month, is that adjusted for seasonality, or are we comparing December to November and calling a calendar a result? Is the figure real or nominal -- did anyone strip out inflation? Does "sales" include the new product line we launched in the spring?

Four questions. The number answered none of them. Trust did not erode because someone caught an error. It eroded because a correct number turned out to mean nothing anyone could pin down, and four people at the table had each quietly assumed a different answer.

## What a perimeter is

A perimeter is the boundary of what a number counts. Which things are inside it, which are outside, and what it is being compared against. Every number has one. The only question is whether it was declared.

"+12%" with no declared perimeter is not one claim. It is every claim at once, and each person in the room collects the version that fits what they already believe. The optimist hears organic growth, the business genuinely getting better. The skeptic hears "we opened eight stores and counted the obvious." Both are pointing at the same +12%. Neither is lying. The number never declared a perimeter, so there is nothing to violate: only a vacuum, and a vacuum gets filled by whoever is most certain.

The number has not one boundary but several. Let's take them one at a time, and at each one I'll tell you where I saw it.

## First face: organic versus inorganic

Both are growth; they are not the same kind. *Organic* growth is the same business doing more: existing markets, better products, repeat customers. *Inorganic* growth comes from outside the existing engine: acquisitions, new locations, new lines. The board's first question was really this one. Open eight new stores and revenue rises. Of course it does. But that is the business getting *bigger*, not *better*, and the two demand completely different decisions.

The first time this hit me head-on was in 2010, at an administrative-services company in the United States. They sold to clinics, doctors, and chains of physical therapy and rehab: appointment-scheduling software, patient management, and above all document management against the insurers, which was the part that actually mattered. They signed two-year contracts.

That two-year-contract detail is what makes the problem unavoidable. With contracts entering and leaving all the time, "how much did the business grow" doesn't have one answer, it has two. A quarter can grow because the clients already on the books bill more documents, or because new contracts came in. On the revenue line the two look identical. But one tells you the service works and the other tells you the sales team works, and if you confuse them you'll congratulate the wrong department.

There the *same-as* comparison -- against the same base of contracts active in both periods -- wasn't a refinement of the report. It was the analysis. Everything else was read through it.

In financial modeling this separation is routine. Open the quarterly report of almost any publicly traded company and you'll find it, with its breakdown and its footnote. I've sat in plenty of financial-model builds, and there nobody argues about whether to separate; they argue about how.

And here's an opinion, because it's the part of all this that catches my eye: that rigor almost never makes it down to the commercial side. You'll see it in the investor report and not in the sales dashboard of the same company, from the same quarter. And in companies with no public stock, where nobody outside demands the breakout, it often doesn't exist at all. They know how to do it. What's missing is someone with the authority to ask for it.

The way to keep the two apart is already solved, and you don't have to invent it. In retail it's the *same-store sales* comparison (comparable-store sales), which counts only the locations open in both periods; I built the base of that model for a retail chain in Mexico. The same logic gives you the same-product comparison: strip out the new line and you can see whether the existing catalog actually moved. And in a contract business, like the one in 2010, it's the base of contracts active in both periods.

A +12% that is four points organic and eight points new stores tells a completely different strategic story than a +12% that is all organic. One is largely repeatable; the other was bought, and buying it again costs again.

## Second face: time

"Up 12% versus last month" is one of the most common ways a number lies without a single false digit. Most businesses have a season. A retailer rises into December every year and falls in January every year, and comparing one to the next measures the calendar, not the company. The honest comparison is like-for-like, the same month a year earlier, or a seasonally adjusted series. Without a stated base period, "+12%" is a number floating in time.

This face is the best known of the three and the one that needs the least arguing. I mention it anyway because it's the one I've most often seen break on its own, with nobody making any decision: someone changes the dashboard's date filter, the comparison stops being against the same month last year, and the number sits there with the same title.

## Third face: money, and a correction to what I wrote last month

In the [previous post in this series](/blog/2026/when-aggregation-lies/) I wrote that money, at least, is a consistent unit. That you can add colones even if you can't add drums and bottles.

That's true as long as there's one currency and one date. With two currencies, or with two dates and a devaluation in between, money is exactly as treacherous as a column called QUANTITY. I wrote it without thinking it through, and the case that follows is what forced me to.

Let's start with the easy part. If the figure is nominal and inflation ran at eight percent, growth of twelve is closer to four. A nominal number presented without that note flatters by default, and in a high-inflation economy it turns a contraction into a celebration. The fix is one line on the slide: real or nominal, and if real, deflated by what.

Here in Costa Rica the problem comes the other way around, and that's the version almost nobody is trained for. The colón went from ₡697.32 to the dollar (June 21, 2022) to ₡505.82 (April 1, 2025), with inflation near zero. The result is that the colón financial statements of a lot of companies look far worse than the company actually is. Nobody suspects a number that shows losses: doubt is reserved for good news. And that's where it slips in.

I ran into it with an importer. Its functional currency is the dollar: it buys in dollars, its prices move with the dollar, its business thinks in dollars. Its presentation currency is the colón, because it's based here and it reports here. Those two are not the same thing, and there's an accounting standard that says how you translate one into the other: IAS 21.

I have to confess something. I studied economics, I handle the vocabulary and I move comfortably on the macro side, but the accounting part wasn't my turf. I had to sit down for a good while and study IAS 21 to understand what I was seeing in that model. It wasn't a data problem. It was that I didn't have the framework.

What I understood was this. In the devaluation years, that company reported high colón profits that were nobody's profit. It bought inventory at one exchange rate and sold it weeks or months later at a higher one, and the margin measured in colones inflates on its own, without anyone having bought better or sold better. On that inflated margin, tax was paid. So there was someone winning from that devaluation, but it wasn't the owner and it wasn't the customer: it was the government.

Now the cycle has flipped and the opposite happens. In colones, those good years deflated and the statements look weak. In dollars, the company is better off than before -- among other reasons because it stopped paying tax on a gain that never existed.

Let me be clear on scope: I'm not an accountant and this isn't accounting or tax advice. What interests me is what IAS 21 does to the board's question. "Up 12% in what?" stops being a decimal-place detail. In a company like that, the answer flips sign: the same year is good in dollars and bad in colones, and both readings are correct. They aren't two opinions. They're two perimeters.

A good share of my clients are agro-export or import businesses. For them this is the sign of the year.

## A correct number can be indefensible

Here is the idea the whole post turns on. Technical correctness is the floor, not the bar.

The +12% passed every arithmetic check. Recompute it ten times and you get +12% ten times. And it still died on the table, because correctness was never what the room needed. The room needed a number it could *defend* -- one that survives the obvious questions, that means the same thing to the optimist and the skeptic, that a CEO can stand behind when the analyst is three floors down.

Defensibility is what makes a number decision-grade. And defensibility comes from one thing: a declared perimeter. A correct number with no perimeter is not information. It is an unanswered question wearing the costume of an answer. The moment someone in authority asks it out loud, the costume comes off.

## The cure: declare the perimeter

The fix is almost embarrassingly simple. You say, on the slide, what the number includes, what it excludes, and what it compares against. You make the boundary visible before anyone has to ask.

```
Sales Growth | 2025 vs 2024

Perimeter:   32 stores open for the full 24 months
Base:        same period in 2024
Currency:    nominal colones, not inflation-adjusted
Net of:      returns

Existing catalog in comparable stores    contributes  +3.1 pp
New line (launched spring 2025)          contributes  +1.7 pp
8 stores opened in 2025                   contributes  +7.2 pp
                                          Total:      +12.0%

Note: the comparable-store contribution (+4.8 pp across existing
catalog and new line) matches its own growth rate because in 2024
the base was only those 32 stores. With a mixed base it wouldn't
match, and you'd have to report rate and contribution separately.
```

That annotation is not bureaucracy, and it is not a disclaimer to cover yourself. It is what turns a number into something the CEO can defend without the analyst in the room. Read it again against the four questions: same stores? Answered. New stores? Broken out, +7.2 pp. Base period? Stated. Inflation? Flagged, and flagged as *not* adjusted, which is a declaration and not an omission. The new spring line? Inside the total and split onto its own row, +1.7 pp -- the question the first version of this post left unanswered.

Look at the note at the bottom of the block, because it's the part that cost me the most to write. A contribution in percentage points and a growth rate are not the same thing, and here they match by an accident of the base. A post that preaches declaring the perimeter can't add rates and contributions without saying which is which. If the block doesn't carry that note, it commits in small the sin it denounces in large.

There is a modeling habit that holds all this up, and it's worth building in from the start: keep organic and inorganic as *separate measures* in the model, so the total is always decomposable on demand. When the split lives in the model, the annotated slide is a five-minute job instead of a fire drill. When it doesn't, every board meeting is a scramble to reconstruct what the headline number actually contained.

## Closing

The CEO did not lose the room because the number was wrong. He lost it because the number was naked -- correct, prominent, and completely undefended. One question undressed it, and after that, every other number on his deck inherited the same doubt. That is how trust erodes: not in a single wrong figure, but in the discovery that the right ones can't be defended either.

I already told you that meeting never happened. What did happen is everything else: the two-year contracts of 2010, the breakout the markets demand and the sales dashboards don't, and an importer whose good years and bad years flip depending on the currency you read them in. I built the scene to gather into a single afternoon what in practice reaches you separated by years. If it sounded familiar, it's because these four edges sit undeclared in almost every company.

The fix is not a better number. It is the same +12% with its perimeter declared, so that when the director asks whether it includes the new stores, the answer is already on the slide: broken out, labeled, and impossible to misread. A number without a perimeter is a question presented as an answer. Give it a perimeter, and it finally becomes what everyone in the room assumed it already was: a fact you can act on.

Which of the four edges is undeclared in the number you present every month? Start with the currency one -- it's the one the fewest people check.
