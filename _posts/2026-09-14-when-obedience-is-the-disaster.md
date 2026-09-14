---
layout: post
title: "When Obedience Is the Disaster"
date: 2026-09-14 06:00:00-0600
description: "Nobody gamed the number. They obeyed it perfectly. That was the disaster."
thumbnail: assets/img/feat-when-obedience-is-the-disaster.webp
tags: [data-governance, data-management, business-intelligence, data-quality, data-ethics, perverse-incentives]
categories: [trust-erosion]
---

![When Obedience Is the Disaster](/assets/img/feat-when-obedience-is-the-disaster.webp)

*Nobody gamed the number. They obeyed it perfectly. That was the disaster.*

My daughter got pregnant this year, which in our public health system (Costa Rica's social security, the CCSS) means she gets priority for dental care. Good policy. Pregnancy and untreated dental infection are a bad combination, and the system is right to move expectant mothers to the front of the line.

So she went. In March, to a CCSS clinic in Pérez Zeledón. She has eight cavities, the small ordinary kind. A dentist with a free afternoon could handle the lot in one sitting. Instead she was given ten appointments: one per cavity, plus the checkup and the cleaning booked separately. Ten separate trips, ten separate slots, each requiring her employer to grant separate permission to leave work, each consuming a morning a pregnant woman would rather spend almost any other way.

No dentist in that clinic is lazy or dishonest. The cavities are real. Every appointment treats something that genuinely needs treating. Nobody is padding a number with fake work. And yet the result is absurd: a treatment plan optimized for inefficiency, ten visits where one or two would do, because the thing the system measures is *appointments attended*. Not cavities resolved, not mouths made healthy, not patient hours saved. Appointments. So appointments are what the system produces, in abundance, through the only rational response available to the people inside it.

Now count what those eight extra visits cost the institution that ordered the metric. The drilling is the short part of an appointment. Around it sits the slot on a calendar, the record pulled and filed, the room turned over, the instruments sterilized, the disposables opened and discarded: gloves, needle, bib, burs. Do it once and you have paid for one setup. Do it ten times and you have paid for ten to deliver the dentistry of two. Then multiply that across a public system and the arithmetic turns ugly in the direction that hurts most, which is the queue. Every fragmented treatment plan eats slots that other patients were waiting for.

The number went up. The institution's actual capacity to treat people went down, and it went down *because of* the number.

## Obeying the metric, not bending it

That is a perverse incentive, and it is a different animal from the one in [the post before this](/blog/2026/goodharts-law-in-practice/). The two get confused constantly. "But this is Goodhart again." No. It looks like Goodhart, but it is not: in Goodhart the instrument lies; here the instrument tells the plain truth (the ten appointments happened, the count is exact) and the goal is what bleeds. So let me put the distinction where you can see it, and admit up front that this one is mine. Most writing on the subject uses the two names interchangeably: cases of Goodhart get filed as perverse incentives, and perverse incentives get filed as Goodhart, until the words stop doing separate work. I think the line is thin and worth keeping.

Goodhart is about the **instrument**. A sound metric gets a reward attached and stops representing reality. The occupancy rate no longer tells you what the hotel is doing. Whether anybody acted in bad faith is a separate question, and usually unanswerable.

The perverse incentive is about the **goal**. Here the instrument keeps working perfectly. Ten appointments really did happen, and the count is exact. Nothing about the measurement drifted an inch from the truth. What the reward damaged was the thing the measurement stood in for. And it damaged it in the way that matters most: it turned back on the institution that set the incentive up. The health service paid for eight extra setups and lengthened its own waiting list to score better on its own number.

A vanity metric, [a couple of posts back](/blog/2026/the-metric-as-mirror-not-window/), does neither. It corrupts no instrument and damages no goal. It was never pointed at anything that mattered, and it hangs on the wall being admired.

Which is why this one has nobody to blame. The dentists are not gaming anything. They are *obeying* the metric, in perfect good faith, doing real and necessary work the whole time. The system asked for appointments, and conscientious professionals delivered appointments. The harm is not in anyone's character. It is built into the incentive itself, and it would happen with a staff of saints.

Steven Kerr named it in 1975, in a management paper whose title says the whole thing: ["On the Folly of Rewarding A, While Hoping for B."](https://web.mit.edu/curhan/www/docs/Articles/15341_Readings/Motivation/Kerr_Folly_of_rewarding_A_while_hoping_for_B.pdf) You hope for B: healthy patients, efficiently treated. You reward A: appointment volume. And then you act surprised when you get a mountain of A and very little B. The folk version is the cobra effect: the often-told story of a colonial government that put a bounty on cobras to thin the population, and got an enthusiastic local industry breeding cobras for the reward. The bounty worked exactly as designed. It just was not designed to do what anyone actually wanted.

You do not need someone cheating. You need a measure pointed at the wrong thing and a room full of reasonable people doing their honest best to move it.

## It punishes the conscientious

Here is the signature of a perverse incentive, the tell that distinguishes it from ordinary gaming: it punishes the people who do the right thing.

A dentist who could have batched my daughter's cavities into two efficient visits (the one actually serving the goal) would have posted lower appointment numbers than the one who stretched them across ten. On the dashboard, the conscientious dentist looks *worse*. The metric does not just fail to reward good practice. It actively penalizes it. The better you serve the real goal, the worse you score on the proxy.

The same mechanism, with the same cruelty, I ran into once without looking for it. I did not come to that project to audit any metric. I came to model the new land-registry system for the Dominican Republic (the one that would be fed by what this team was capturing), and because I was the "SQL expert," they also asked me to help with a performance problem on the team's server. The perverse incentive turned up there, with my hands in the engine for another reason.

Thirty clerks per shift, two shifts, worked through scanned images of old title books, pulling the legal substance out of each record: buyers, sellers, creditors. The data-quality control was serious: every record was keyed blind by two clerks who could not see each other's work; if they matched, it passed; if not, a third broke the tie, and every batch of 2,000 was sampled and had to confirm at 98%. The *quality* of the data was well nailed down. *Productivity* was not: a clerk was measured on volume of records evaluated, and the records varied enormously. Some were dense with information that took real effort to transcribe correctly. Many carried only minor annotations. Some were blank.

Sit with what that incentive does. A clerk who drew a dense record (exactly the one the whole project existed to capture) did ten minutes of careful, error-prone transcription for one unit of "record evaluated." One who drew a blank page clicked twice, marked it empty, and booked the same unit in five seconds. Same credit, a fraction of the work, and none of the value the project was actually for.

But the part I did not see coming was on the server. The next case was handed to each clerk by a SQL view: a heavy, slow, and -- this is what matters -- non-deterministic query. Every time it ran it returned a different record at the top. Troubleshooting the performance, I found why the machine was suffering: a single clerk was firing that view twenty or twenty-five times a minute. They were not working twenty records a minute. They were re-rolling the dice -- run it, see if the case is easy, if not, run it again -- until a blank or near-blank one came up. The view was their slot machine.

Nobody had hacked anything. They pressed a button the system handed them, until the system handed them something easy. I sat down with the team's director and the programmer to look at the results, and there was the cruel part: the clerks who consumed the view the most, the ones who re-rolled it hardest, were exactly the ones the dashboard crowned as *top performers*. The board was rewarding, by name, the people doing the least real work. The diligent clerks, the ones who carefully worked the hard records, posted the worst numbers. The metric rewarded skimming and punished exactly the careful capture that mattered most.

## Where the perverse incentive breaks the instrument too

That land-records case is worth a second look, because it shows the boundary between the perverse incentive and the Goodhart gaming before it.

The incentive was perverse by design: measuring records while ignoring difficulty made skimming the rational strategy before anyone did anything clever. A clerk who simply took cases as they came and happened to draw easy ones would have scored well without a single dishonest act. That is the pure perverse incentive, and it harms the goal all on its own.

But then some clerks started re-running the view to fish for easy cases. Watch what that does to the instrument. Until then, "records evaluated" was an honest count that simply failed to weight difficulty. Once clerks are re-rolling the assignment until an easy case comes up, the count stops representing coverage of the archive at all: it measures how well somebody re-rolls the dice. The goal was already being damaged; now the number has stopped reporting reality too. That is the step across the line into the Goodhart territory we mapped last time. This is how it usually goes. Perverse incentives are the on-ramp. You point a metric at the wrong thing, good people respond rationally, and the most metric-aware among them eventually notice that the rational response can be sharpened into a deliberate one. Nobody starts out cheating. They start out obeying, and the obedience teaches them where the seams are.

## You measured the activity, not the goal

Strip these cases down and they are the same mistake. Somebody measured the activity instead of the outcome, because the activity is easy to count and the outcome is hard.

Appointments are trivial to count. Restored dental health across a population is hard to measure. So the system counts appointments and quietly lets them stand in for health. Records are trivial to count. Knowledge faithfully captured from a crumbling archive is hard to measure. So the project counts records and lets them stand in for the knowledge. Call length is trivial to count; whether the customer's problem actually got solved is not. So a call center tracks average handle time and lets speed stand in for resolution. And the agent who patiently works a hard call to the end posts worse numbers than the one who hurries the caller off the line. The conscientious one looks slow. Worse, the rushed call often comes back as a second call, so the very metric meant to tame the workload quietly multiplies it. In every case the easy proxy did more than fail to capture the goal: it pulled behavior directly away from it, because the proxy and the goal pointed in different directions and the proxy was the one with the reward attached.

Donald Campbell put the warning almost as a law: the more any quantitative indicator is used to make decisions, the more it will distort and corrupt the very process it was meant to monitor. Not "might." Will. The pressure of the reward bends the behavior toward the number and away from the thing the number was a proxy for. Measuring the activity is how you guarantee you get the activity -- and only sometimes, by luck, the goal underneath it.

## The cure: reward B, even when A is easier to count

The fix is the hardest kind, because it asks you to measure the thing you actually want instead of the thing that is convenient.

Reward the outcome, not the activity. If you cannot measure the outcome directly (and often you genuinely cannot), then at least pair the activity metric with something that moves the other way when the activity is being optimized at the goal's expense. Appointment volume next to patient-visits-per-resolved-case, so that fragmenting care shows up as the inefficiency it is. Records evaluated next to a difficulty or completeness weighting, so the dense record is worth more than the blank one and the diligent clerk stops looking like the slow one.

And before you attach a reward to any number, run Kerr's question over it explicitly: what is the B I am hoping for, what is the A I am about to reward, and are they the same thing? If they are not (if it is possible to maximize A while starving B), then you have just built a machine that will, in perfect good faith, give you exactly the wrong result. Build it anyway and the most conscientious people on your team will be the ones it punishes first.

## Closing

Nobody in either of these stories did anything wrong, and that is the entire point. The dentists treated real cavities. The clerks evaluated real records. The numbers were honest, the work was honest, and the outcome was a system that booked ten appointments where two would do, and skimmed an archive for its easy records while its richest ones went quietly untouched.

This is the failure no audit turns up, because everyone is doing exactly what was asked. There is nobody to fire and no fraud to catch. The metric was not bent and it was not wrong. It was obeyed, faithfully, by good people, all the way to a result nobody wanted -- including the institution that asked for it. The cruelest part is who pays for it: not the cynic who works the system, but the conscientious professional who serves the real goal and watches the dashboard call it underperformance.

You get what you measure. Not what you meant -- what you measured. And if those two ever come apart, the people who suffer first are the ones still trying to deliver what you meant.
