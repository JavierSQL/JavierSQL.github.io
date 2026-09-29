---
layout: post
title: "The Discipline of Distrust"
date: 2026-09-29 06:00:00-0600
description: "Every number in this series lied. The fix was never a better number -- it was a better reader."
thumbnail: assets/img/feat-the-discipline-of-distrust.webp
tags: [data-governance, data-management, business-intelligence, data-quality, data-ethics, data-culture]
categories: [trust-erosion]
---

![The Discipline of Distrust](/assets/img/feat-the-discipline-of-distrust.webp)

*Every number in this series lied. The fix was never a better number -- it was a better reader.*

On April 1, 2026, four astronauts were strapped into the Orion capsule on top of a fully fueled rocket at Kennedy Space Center, counting down to the first crewed flight to the Moon since 1972. And in the final stretch of that countdown, an instrument started reporting bad news.

A temperature sensor on one of the launch abort system's batteries read higher than it should have. Out of family, in the language of the room. On a vehicle carrying people, with the abort system being the one thing meant to save their lives if the rocket fails, a battery running hot is not a number you wave away.

So watch what NASA did, because it is the whole post. They did not act on the reading. They interrogated it. A high temperature could mean two completely different things: the battery is actually overheating, or the sensor is lying about a battery that is fine. Those two possibilities demand opposite responses (one scrubs the launch, the other ignores the alarm), and the whole decision came down to telling them apart under time pressure: four lives and a few billion dollars riding on getting it right.

They judged it an instrumentation problem. Not the battery -- the sensor. The mission management team accepted the change, the hold resumed, and at 6:35 that evening the rocket flew. ([NASA's launch-day log has the play-by-play.](https://www.nasa.gov/blogs/missions/2026/04/01/live-artemis-ii-launch-day-updates/))

## The move almost nobody makes

What NASA did has a name in engineering, but it does not have a name in most boardrooms, because most boardrooms do not do it. They separated the signal from the source of the signal.

"The sensor says the battery is hot" is not the same statement as "the battery is hot." One is a reading. The other is reality. Between them sits an instrument that can be wrong, and the entire question is whether you trust it on this particular reading, at this particular moment. NASA held those two statements apart and tested the gap. Most organizations collapse it on instinct: the number said X, therefore X, now let's go figure out what to do about X.

This was not luck or a one-time stroke of caution. NASA does it as a matter of discipline. Back in 2022, during an Artemis I countdown, a sensor on engine 3 read about 40 degrees Fahrenheit too warm. Same fork in the road: bad engine, or bad sensor? They determined the [sensor was faulty, not the engine](https://www.fierceelectronics.com/sensors/bad-temperature-sensor-engine-3-traced-scrubbed-artemis-i-launch), and treated the reading accordingly. Twice now, at the worst possible moment to be wrong, the same posture: distrust the instrument, verify, then decide.

## The whole series, in one sentence

I have spent this series taking apart numbers that lied.

A definition everyone signed off on and no two people shared. A table whose rows quietly stopped matching the concept they claimed. A sum of things that could not be summed, sitting in a column with a confident decimal. A growth number with no declared perimeter, correct and indefensible. A flattering metric that measured the wrong thing in plain sight. A metric gamed for someone's bonus, and another obeyed in perfect good faith, all the way to harm. A formula that quietly claimed something other than the definition it was built from. Different mechanisms, but one family underneath them all: a number that looks like a fact and rests on something nobody declared.

And here is what every one of those posts was really about, even when I was writing about definitions or denominators or perimeters. The failure was almost never the number. It was a reader who took the reading at face value. The customer count, the average price, the +12%, the flattering KPI, the occupancy rate, the ten appointments where two would do -- each of them would have been caught by one person in the room doing what NASA did with that battery sensor: asking, before acting, whether the instrument was telling the truth.

The fix was never a better number. There is no better number waiting to be built. The fix is a better reader.

## The opposite posture

There is a failure on the other side of this, and it is just as expensive. To see it, I have to take you from a launch pad to a museum.

I was at the Museum of Flight in Seattle, walking through the first jet Air Force One: a Boeing VC-137 that flew presidents from Eisenhower to Nixon. The guide told us a story that the museum tells too, so I am fairly sure it is real. President Lyndon Johnson was famously fussy about the cabin temperature, and he badgered the flight crew about it constantly. So they did something about it. They installed a thermostat in the conference room.

It was not connected to anything. ([The museum's own blog tells the story.](https://blog.museumofflight.org/quirks-of-the-first-jet-powered-air-force-one)) Johnson would turn the dial, feel that he had taken charge of his environment, and never notice that the temperature did not change. The version we got on the tour added that the actual adjustments happened up front, on a quiet word from the cabin crew to the cockpit. A perfect placebo: the full sensation of control, wired to nothing.

Johnson trusted an instrument that was wired to nothing. NASA distrusted an instrument that was wired to a battery and happened to be wrong. Hold those two side by side, because together they are the whole story.

## The dashboard as placebo knob

Most of this series warned you about instruments that lie. The placebo knob is the warning I had not gotten to yet: the instrument that is not connected to anything.

I see them everywhere. In vendor demos, in the pitches of service providers, in hotels, in agribusiness, in banking. Placebo knobs, often enough that to me they are just normal. But the case that will not leave me is a private university in Costa Rica, in 2024.

They brought me in as a consultant to lead the process, and we walked the entire hard road. The university's team mapped its value chain, we ran workshops for each of the seven primary activities and the seven support ones, requirements sessions with the people involved, balance analysis across indicators. The nearly 70 indicators in the final report were not mine to bring: their own people built them, guided by me and on sound principles, each one tied to a real activity of the institution. It was real work.

The board took it apart. They cut more than 50 of those indicators and wired up knobs in their place. Maintenance Cost per square meter -- a number you can drive down by letting the buildings decay, whether or not anyone ever complained about their condition. Number of Courses Offered, regardless of whether a single student enrolled. Social media followers, which is the perfect knob because it climbs on its own: new students arrive every year, almost nobody unfollows you, and the needle moves without anyone in the room having moved anything. You can turn any of the three without touching a single one of the levers that decide whether a university survives: enrollment, retention, learning. The room watches the green and feels it is steering. What actually moves the institution is decided by someone else, somewhere else, on signals that never reached that board.

I never fully understood that ending. The people who hired me were the CFO and IT; the work was dismantled by the board of directors. Why an organization pays for the long road -- the workshops, the off-sites, the consulting -- only to wipe the slate clean with metrics that climb on their own, is something I still cannot explain. I suspect, I do not know.

And beauty makes it worse, not better. A polished dashboard deepens the placebo: confidence in the instrument rises while its connection to reality does not. The most dangerous version of the placebo knob is the one with good design and a quarterly cadence and an executive who has learned to relax when the numbers are green.

## The third posture

Verify and pretend do not exhaust the options. There is a third thing an organization can do with an instrument, and it is the most expensive of the three, because it is the one you reach for when the instrument is working.

Go back to NASA, forty years earlier.

On the evening of January 27, 1986, engineers at Morton Thiokol, the contractor that built the shuttle's solid rocket boosters, got on a teleconference with NASA to argue against launching Challenger the next morning. The forecast was 26 to 29 degrees Fahrenheit. Their recommendation was unanimous: do not launch below 53.

They were not guessing, and they were not new to the argument. Roger Boisjoly sat on the seal task force at Thiokol, and six months earlier he had put the risk in writing to his vice president of engineering. The memo ends like this:

> "It is my honest and very real fear that if we do not take immediate action to dedicate a team to solve the problem, with the field joint having the number one priority, then we stand in jeopardy of losing a flight along with all the launch pad facilities."

That was July 31, 1985. In October he wrote again. This time the subject was the team assigned to the problem: it was not getting management support, and "even NASA perceives that the team is being blocked in its engineering efforts to accomplish its task." The signal was inside the building, in writing, twice.

Now here is what happened on that call, and it is not what people remember. Nobody suppressed anything. Thiokol's managers asked for a caucus and went offline without their own engineers. In that room, someone told the vice president of engineering to take off his engineering hat and put on his management hat. Boisjoly, testifying to the Rogers Commission the following month: "it was clearly a management decision from that point." Thiokol came back on the line and told NASA the data were inconclusive.

Inconclusive. That is the entire move.

The engineers were not overruled and they were not silenced. Their reading was reclassified. It went from a recommendation to a maybe, and a maybe is something you are allowed to launch through. Seven people died the next morning, seventy-three seconds after liftoff.

Put that next to April 2026. Same agency, four decades later, four people on top of a fueled rocket and an instrument saying something nobody wanted to hear. The question in that room was "is it the battery, or is it the sensor?" -- and they went and found out. In 1986 the same question got answered by people who did not go and find out. "The data are inconclusive" is the courteous way to say "the sensor is probably wrong."

So I want to revise something I implied at the top of this post. Disciplined distrust is not a personality trait NASA happens to have. It is something the agency learned, and it is worth sitting with what it cost to learn it.

The pattern is not aerospace, and it is not American. On December 30, 2019, an ophthalmologist named Li Wenliang posted a warning in a private WeChat group of fellow doctors. Seven patients at his hospital in Wuhan had pneumonia and had tested positive for SARS. He told his colleagues to protect themselves. Four days later the local police summoned him and had him sign a letter of reprimand for making false comments on the internet. He was one of eight doctors warned over the same thing. He died of COVID-19 on February 7, 2020.

That March, an official investigation concluded the reprimand had been inappropriate. The police revoked it and apologized to his family. Read that carefully, because the detail is the useful part: the finding was that the reprimand was *inappropriate*, not that it was unlawful, and it arrived weeks after the thing it might have prevented. The organization did come around to its instrument in the end. It came around late and partially, after the bill had been paid in full. That is the ordinary shape of this. Discrediting a reading does not cancel the cost of what the reading was about. It decides how much of that cost you pay, and how late.

And here is the thing it took me nine posts to be able to say.

For nine posts the instrument was a number: a definition, a denominator, a perimeter, a formula. In these two it is a person. That matters more than it sounds, because a person is the highest-sensitivity, lowest-latency instrument any organization owns. A person can register an anomaly before there is data for it to appear in. Boisjoly did not have o-ring failure statistics for 29 degrees; nobody did. He had judgment about cold rubber, and judgment arrives earlier than evidence.

Which is precisely why this posture is the expensive one. A number you discredit can be recalculated later. A person you discredit stops reporting -- and so does everyone who watched it happen.

## Three postures, one variable

NASA, Johnson, and Thiokol look like three different stories. They are one story with the reader swapped out.

| Posture | Case | Was the instrument telling the truth? | What the organization did |
|---|---|---|---|
| **Verify** | Artemis II, 2026 | Unknown at the time | Triangulated: battery, or sensor? |
| **Pretend** | Johnson's thermostat | No, and nobody checked | Settled for the sensation of control |
| **Discredit** | Challenger 1986, Wuhan 2019 | **Yes** | Downgraded the reading and moved on |

All three are about the relationship between a reading and reality, and in all three the outcome was decided by the posture of the person holding the instrument, not by the instrument itself. The sensor did not save the Artemis crew; the engineers who interrogated it did. The knob did not fool Johnson; Johnson fooled himself by never asking what it was wired to. And the o-ring data did not fail Challenger; a room that needed the reading to be inconclusive found it inconclusive. The instrument is neutral. The posture is everything.

So here's what the mature posture actually looks like, gathered from every cure in this series:

Before you act on a number, ask what would have to be true for it to be wrong, and then go check that, the way NASA checked the battery instead of the reading. Ask what your instrument is connected to: does this metric move because the business moved, or because someone can turn it without moving anything? Keep the signal and its source apart -- "sales are up" is a reading, and whether sales are actually up is a separate question you are allowed to ask. And keep a human in the loop, because NASA's call was made by people interrogating data, not by data tripping an automatic switch. The instrument informs the judgment. It does not get to replace it.

Then one more, and it is the one that catches the expensive failure. Watch the vocabulary you reach for when a reading is unwelcome. When something you did not want to hear gets moved into *inconclusive*, or *preliminary*, or *anecdotal*, or *needs more data*, ask whether anybody actually went and checked -- or whether the label was allowed to stand in for the checking. Reclassifying a reading feels like rigor. It costs nothing and it sounds responsible. It is also the cheapest way there is to make a true signal go away.

## Closing

The same discipline that let NASA fly four people around the Moon on the strength of a distrusted sensor is the discipline a boardroom needs to avoid betting the company on a trusted one. The same comfort that let a president turn a dial connected to nothing is the comfort a leadership team feels in front of a dashboard connected to nothing. And the same instinct that turned a unanimous engineering recommendation into *inconclusive* is the instinct that turns your most uncomfortable analyst into someone who stops volunteering things.

A mature data culture reads like NASA. An immature one holds on to placebo knobs. And a culture that downgrades every reading it did not want does not have instruments at all. It has decoration.

The number was never the point. The instrument was never the point. The point is the person reading it -- whether they interrogate the reading like an engineer at T-minus-ten, or turn the knob and feel better. Every number in this series lied. The ones that did real damage were the ones read by someone who never thought to ask.

So read every number the way NASA read that sensor: as a claim to be verified, not a fact to be obeyed. And every once in a while, walk up to your favorite dashboard (the one that always makes you feel in control) and ask it the question nobody in the room wants to ask. Is this knob connected to anything?

Then ask the harder one, because it is not about the dashboard. When somebody walks into your office with a reading you did not request and do not want, what happens to them in the next ten seconds? That answer is your real instrumentation policy. It is not written down anywhere, everyone who works for you already knows it, and it determines which readings ever reach you at all.
