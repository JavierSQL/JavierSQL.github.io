---
layout: post
title: "The Metric as Mirror, Not Window"
date: 2026-09-01 06:00:00-0600
description: "The number said the ER was excellent. Sitting in that waiting room, it told me nothing I needed to know."
thumbnail: assets/img/feat-the-metric-as-mirror-not-window.webp
tags: [data-governance, data-management, business-intelligence, semantic-modeling, data-quality, data-ethics, vanity-metrics]
categories: [trust-erosion]
---

![The Metric as Mirror, Not Window](/assets/img/feat-the-metric-as-mirror-not-window.webp)

*The number said the ER was excellent. Sitting in that waiting room, it told me nothing I needed to know.*

My daughter was in surgery. It was 2017, in San José, Costa Rica. Scheduled, routine, the kind the surgeon does before lunch and forgets by dinner. That does not make the waiting room any easier when you are the father in it.

The hospital was private and, by every sign I could read, good. The waiting area sat next to the emergency room, and on the wall by the admissions desk there was a poster. A KPI, framed and proud: *99.5% of patients admitted in under 30 minutes. Target: 95%.*

I am a data person. The brain does not switch off, not even when it should. So while I waited for my daughter to come out, I did what I always do with a number on a wall: I asked what it actually measured. But let me be honest about what I had and what I did not. I had the unease -- the number nagged at me -- and I had the question. I did not have the frame. The distinction between a mirror and a window, which is what this whole post is about, did not occur to me in that chair; I went and found it years later, building a methodology of my own and writing this series. That day I only knew a perfect number was no use to me, and I could not have told you why.

Nothing happened that day. No collapse, no body count. My daughter came out fine. This is not that kind of post. It is the quieter kind: a perfect number, a frightened parent, and the slow realization that the two had nothing to do with each other.

## What the number was measuring

Start with the literal reading. The hospital was clocking how long it took to *administratively admit* a patient. From the moment you walk in to the moment your record exists in the system: name captured, ID photographed, a number printed. Under thirty minutes, 99.5% of the time. Beating a 95% target by four and a half points.

That is a real measurement. Somebody built the timestamp logic, somebody pulls the report, somebody presents it to a committee that nods. The number is almost certainly true.

Now ask what it leaves out. It does not measure how long until a doctor sees you. It does not measure time to diagnosis, time to treatment, time to the medication that stops the pain. It does not measure whether you got better. A patient could be admitted in eleven minutes, beautifully, then wait four hours bleeding in a chair -- and the KPI would still read 99.5%. The clock stops the instant the paperwork clears.

So the metric measures the speed of printing a number and photographing an ID. It does not measure care. And in an emergency room, care is the only thing anyone walked in for.

## The mirror and the window

Here is the distinction I keep coming back to.

A window shows you the world. You look through it and see what is actually out there: the weather, the street, whether it is safe to go outside. A mirror shows you yourself, and it shows you flattered, in the light you chose.

That admissions KPI was a mirror. It reflected the hospital's competence back at the hospital. *Look how fast we process people.* And the reflection was accurate. They probably were fast. The mirror was not lying about the face it showed.

It just was never going to show me the thing I needed. Sitting in that chair, I did not care how quickly the next patient's ID got photographed. I cared whether the people behind those doors knew what they were doing with the patients already inside. The metric on the wall could hit 99.5% forever and tell me nothing about that. A perfect mirror, and not a single pane of window in it.

This is what a vanity metric is. Eric Ries, in *The Lean Startup*, drew the line between vanity metrics and actionable ones: numbers that go up but imply no learning and demand no action. The admissions KPI is the purest version I have ever seen framed and hung on a wall. It goes up. Nobody learns anything. No decision changes. It exists to be admired.

## The part that makes it dangerous

You might expect me to say the hospital was cheating. It was not. That is exactly what makes this worth writing about.

There is a different failure, and I will get to it in the next post. There the metric starts out sound: watch it passively and it reports the business honestly. Then somebody attaches a reward to it, and it stops representing reality. Bad faith may be in there and may not, and it matters less than you would expect, because anything you pay by the unit will start hunting for cheaper units, intention or no intention.

The vanity metric never had that moment. No good number went bad under pressure. Admission speed was never going to tell you about care, before any reward existed and before anyone thought to optimize it. Watch it as passively as you like and it still points somewhere adjacent to what you came for. That is the distinction worth holding on to, because it survives where *was anybody cheating* does not: one failure is a sound metric corrupted by a target, and this one is a metric that was never aimed at the goal.

Nobody at that hospital sat down to deceive me. The admissions team genuinely was efficient. Management genuinely had a number to be proud of. The committee genuinely saw improvement. Everyone was honest, and the result was still a poster that measured the wrong thing in plain sight.

That is why it is more insidious than the cheat. A number bent under incentive can be caught, because it stops matching the world and the mismatch leaves a trail. But a vanity metric is true. You cannot catch it by checking the math, because the math is right. It survives precisely because it is honest, accurate, and beside the point. The mirror does not lie about your face. It just only ever shows your face, and calls that the room.

## Why the wall is full of mirrors

Once you hold the mirror-and-window distinction, you start seeing mirrors everywhere, and not only on dashboards. Brazil against Japan, halftime, Japan up 1-0 against every expectation. A commentator reaches for the number that explains it: the Japanese team has run five kilometers more than Brazil. The stat is real and flattering. It also points at exactly the wrong thing. The other man in the booth, an old player, will not let it stand -- in football you do not win by running, you win by scoring. The five kilometers measure effort, heart, how badly the team wanted it. They do not measure goals, and goals are the only thing on the scoreboard. What makes the moment worse is that at that exact minute the mirror agreed with the world: Japan *was* winning. That is when a vanity metric is most dangerous. Not when it contradicts the result, but when it happens to match it, because that is the moment it gets mistaken for the reason.

Vanity metrics are not rare accidents. They breed, and the reasons they breed are structural.

They are easy to measure. An admission timestamp is trivial to capture. A clinical outcome is hard, slow, and contested. So you measure the easy thing and let it stand in for the hard thing.

They flatter everyone in the chain. The admissions staff look efficient. Management looks like it is managing. The committee looks like it is improving the institution. A number that makes everyone in the room look good does not get questioned in that room.

And they rarely make anyone uncomfortable. The metrics worth tracking in an ER (time to treatment, diagnostic error rate, what happened to the patient after they left) are the ones that can embarrass somebody. The mirror metrics never do. They are safe. That is their job.

So the dashboard fills with them. Likes that never convert. Course pass rates with no evidence of learning. A count of active projects with no link to value delivered. Each one easy, flattering, comfortable. Each one a mirror that somebody mistook for a window.

## The culture that asks for mirrors

So far I have described this as if mirrors appear by accident: the easy number was there, the hard one was not. Often that is true. But there is a version where the mirror is no accident at all: it is what the organization demanded. Some cultures do not forgive bad news. Walk into the executive meeting with a red number and you become the problem, not the number. People learn that fast, and the dashboards drift toward green. Not because anyone falsified anything, but because the metrics that can only ever look good are the safe ones to present. A culture that punishes the messenger ends up with no messengers. Only mirrors.

This usually travels with low BI maturity, and the two feed each other. An organization that never learned to use data to find problems uses it to confirm comfort instead. The numbers smile, the reports applaud, and the ship can be taking on water the entire time, because nothing on that wall was ever built to show the waterline.

Here is the hard part for anyone trying to fix this from below. You can pair every metric with the right outcome, build the cleanest window in the building, and it will not survive a culture that does not want to look through it. The repair does not start in the semantic model. It starts in the executive mindset: in a leadership that decides bad news is information, not insubordination, and rewards the person who brings the window over the person who polishes the mirror. Until that changes, the mirrors win. The mirrors are what the room is asking for.

## What we leave out is the whole story

The trap is not in the number on the wall. It is in the number that is not there.

William Bruce Cameron put it better than I can, back in 1963: *"Not everything that can be counted counts, and not everything that counts can be counted."* The ER measured what was countable: the admission timestamp, clean and cheap. It left out what counted (whether the patient got better) because that is expensive and messy and slow to know.

This is the ethical weight of a vanity metric, and it is a different weight than the one from [the opening post](/blog/2026/false-semantic-consensus/). The lie of an ambiguous definition is that two things wear the same name. The lie of a vanity metric is quieter: it is a true number standing in front of the question that matters, blocking the view. Nothing in it is false. Everything important is simply out of frame.

When you report the mirror and stay silent about the window, you are making a choice about what the organization is allowed to see. Usually nobody decides that on purpose. It happens because the easy number was available and the hard one was not. But the effect is the same as if someone had chosen it: a hospital that knows, to one decimal place, how fast it admits people, and does not have the same confidence about whether it heals them.

## The cure: pair the mirror with a window

You do not fix a vanity metric by deleting it. Admission speed is not worthless. In a mass-casualty event it might matter a great deal. You fix it by refusing to let it stand alone.

The order matters, and it is the reverse of how most of us work. The two moves below are technical, and a technical fix either lands on a culture or it does not land at all. So the culture goes first.

That part is organizational change work, not modeling work, and it is out of scope here. I am not going to pretend a post about metrics can teach you how to move people. What I will do is point at the map. Kotter's change model is the one most of us reach for, and for this problem the first step is the one that counts: establish a sense of urgency. Which happens to be the exact step a wall of mirrors is built to prevent. All those green numbers are a complacency machine, and their job is to make everyone feel that nothing needs changing. The metric you need to fix is also what blocks the conditions for fixing it.

Break that loop first. Get someone with authority to feel the gap between the number and the room. Do that and the two moves below are a Tuesday afternoon. Skip it and you will build the cleanest window in the building and watch nobody walk up to it.

First, pair every vanity-prone metric with the outcome it is quietly substituting for. Admission speed sits next to time-to-treatment and to a clinical outcome measure. On its own, admission speed is a mirror. Sitting beside the thing it was pretending to represent, it becomes one input to a window: a fast intake is good *if* it feeds a fast treatment, and now you can see whether it does.

Second, apply one diagnostic question to anything on your dashboard: *what decision changes if this number moves?* If admission speed drops from 99.5% to 96%, what does anyone do differently? If the honest answer is nothing (if the number only ever gets reported and admired), you are looking at a mirror. Frame it as decoration or take it off the wall, but stop pretending it is telling you about the world.

## Closing

My daughter came out of surgery fine, and the hospital was good -- I want to be clear about that, because this is not a story about an incompetent institution. It is a story about a competent one measuring the wrong thing in full view, with the best of intentions and a 99.5% to show for it. The mirror was not wrong. It was just never going to answer the only question I had in that chair: whether the people behind those doors could take care of my daughter. A mirror cannot tell you that. It can only ever show you how good you look while you wait.

The most flattering number in any dashboard is the one that measures something real and adjacent to nothing that matters. It will pass every audit, because it is true. It will survive every review, because it makes the room look good. And it will keep you from asking the harder question for exactly as long as you let it hang there, catching the light.
