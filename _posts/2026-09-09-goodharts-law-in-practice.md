---
layout: post
title: "Goodhart's Law in Practice"
date: 2026-09-09 06:00:00-0600
description: "He won awards for the number. The number was the problem."
thumbnail: assets/img/feat-goodharts-law-in-practice.webp
tags: [data-governance, data-management, business-intelligence, data-modeling, data-quality, data-ethics, goodharts-law]
categories: [trust-erosion]
---

![Goodhart's Law in Practice](/assets/img/feat-goodharts-law-in-practice.webp)

*He won awards for the number. The number was the problem.*

This was in San José, years ago, back when I was just getting started in data. My company still lived on systems support: networks, servers, maintenance. One of those clients was a hotel franchise, and its manager was the best hotel operator I have ever known. He had come up from the front desk to the general manager's office, and he understood the reservation and operations process better than anyone I have dealt with. Awards, recognition, years with the brand. On paper he was a star, and the paper was not lying about the numbers. Occupancy ran high. Revenue per available room ran high. By every figure the franchise tracked, his property shone.

I want to be careful here, because I am talking about a friend, and because what I can prove and what I suspect are not the same thing. He explained the lever to me himself. How much he used it, and whether what I call a trick was for him just good management, I cannot prove. But the pattern was hard to unsee once I knew where to look. It all lived in a single word: *available*.

Revenue per available room (RevPAR) divides room revenue -- just the rooms, not the restaurant -- by the rooms you have available to sell. The occupancy rate divides the rooms you filled by that same figure. Send a few rooms to "maintenance" and they drop out of *available*. You have not booked a single extra guest, not earned a single extra dollar. But the denominator just got smaller, so occupancy climbs, RevPAR climbs, and the dashboard upstairs lights up green in two places at once.

Read those as two numbers agreeing with each other and you have already made the mistake. RevPAR is average daily rate multiplied by occupancy. Occupancy is not a second opinion on the first number, it is a factor inside it. One move on the denominator, two green lights. The board upstairs believes it has been told twice.

Put a number on it. The property had 210 rooms. On a good night you sell 165: occupancy is 165 over 210, just under 79%. Now you send 21 rooms (ten percent) to "maintenance" and keep selling the same 165. Not one extra guest, not one extra dollar, but the denominator is now 189 and reported occupancy jumps to 87%. At an average rate of around US$95, RevPAR goes from US$75 to US$83: one move, both green lights.

The craft was in the restraint. You do not send half the hotel to maintenance. That gets noticed. You adjust it just enough. Enough to move the number into award territory, never enough to look strange. The best version of this is indistinguishable from a manager having a slightly better quarter than his peers. That is exactly why it is so hard to catch.

How I came to know any of this was not by auditing anything. We became friends through a disaster: the hotel's server went down and I ended up working three days straight, more than sixteen hours a day, sleeping there, to bring it back. A hotel generates a brutal volume of automatic transactions, and while the server was down they had to be re-keyed by hand, one by one. After something like that you stay close. The denominator came up much later, in a conversation between friends about how different it is to run a local hotel and to run under a chain's metrics. He did not tell me about it as a prank. He explained it the way you explain a rule of the game.

## The honest version of the same move

Before you call that fraud, sit with an awkward fact: shrinking the denominator is often exactly the right thing to do.

Years ago I was running a training at a hotel in Menorca, off-season, in the middle of winter. The property was two towers side by side, and one of them was shut completely: no guests, no staff, no lights, no heating. It stayed dark until about two weeks before the high season, when they brought it back to life. Closing it was good management. An empty tower in January costs almost nothing to keep dark, and counting its rooms as *available* would have made every ratio lie in the other direction: occupancy and RevPAR would have looked terrible for rooms the hotel had deliberately, sensibly, taken off the market. Dropping them out of *available* was the metric working exactly as designed.

That is the trap. The honest version and the gamed version make the identical move (fewer rooms in the denominator) and light up the identical green dashboard. The difference is not in the math. It is in whether the rooms are genuinely out of service or quietly parked to flatter a number; whether the decision is one you would defend out loud to the board or one timed to a bonus cycle that nobody mentions. Same lever, opposite intent -- and from the report upstairs, you cannot tell them apart.

## Now take the humans out of it

At the Marine Life Oceanarium in Gulfport, Mississippi, the dolphins were paid in fish for bringing trash out of their pool. Tim Hoffland ran training and rescue there for about fifteen years, and the way he tells it, a dolphin named Kelly worked out the flaw in the pay scheme faster than the people who wrote it.

The scheme had one property that mattered. The fish was flat. However small the scrap she handed over, she got the same fish for it.

So Kelly stopped handing things over. She started hoarding. She tucked trash under a rock at the bottom of the pool and paid it out in fragments, one small delivery every time a trainer walked past. Same reward per piece, more pieces, less swimming. The trainers could not work out the pattern, and they did not work it out from the pool deck either. They found out when they drained the tank to replace a pane of glass and found the pile sitting under the rocks.

Then she escalated. The oceanarium paid a premium for birds, because gulls landed in the pool and a hungry dolphin taking a bite out of a gull is an animal-welfare problem trainers would rather buy their way out of. A bird was worth considerably more fish than a piece of trash. So Kelly started holding back a fish from her own ration and stashing it under the same rock. Not to eat. As bait -- she would wait at the surface with it until a gull came down, and then she had a bird to turn in. Her calf picked it up. From the calf it spread through the pool.

A caveat, and it matters. This is a trainer's recollection, written up by a journalist years afterward. No protocol, no observation log, nothing peer-reviewed, and the further the story runs -- the bait, the calf, the spread -- the thinner the sourcing gets. Take Kelly as an illustration, not as evidence. The mechanism does not need her: flat pay per piece rewards fragmentation whether or not a dolphin ever noticed. What she adds is that something with no stake whatsoever in your compensation philosophy found the seam anyway.

Two things in that story do work the hotel case cannot.

The first is the bait. Kelly took a reward she had already earned and spent it to manufacture more reward, and that has a corporate translation you have probably watched happen: the budget you won by hitting the number goes into hitting the number, not into the thing the number was standing in for. The metric stops being something the organization reads and becomes something the organization funds.

The second is what happened to the pool. It got dirtier. The trash was still in there, under a rock, while the number said it was being removed -- and now there were dead gulls in a pool that had never had dead gulls in it before. The metric counted pieces delivered. Nobody was counting trash removed, which was the entire point of paying for trash in the first place. A count of pieces and a volume of garbage are not the same unit, and the gap between them is where the fish went.

And now the part that reaches back to the hotel. There was no bonus cycle here, no compensation committee, nothing you could call a culture. Nobody taught Kelly this, and nobody could have explained the metric to her if they had wanted to -- she had no way to understand it. She was paid per piece, and *per piece* is a shape you can feel without being able to name. If you want to keep believing the hotel manager's problem was his character, you have to explain the dolphin first.

## When a measure becomes a target

There is a law for this, and it has a name people recognize. Goodhart's Law, in the popular phrasing: *when a measure becomes a target, it ceases to be a good measure.*

The original was about monetary policy, but the version that matters for anyone building dashboards is operational. The moment a number stops describing the business and starts controlling someone's bonus, the number's job changes. It is no longer there to tell the truth. It is there to be hit. And people are resourceful about hitting targets, far more resourceful about that than about the messy goal the target was supposed to represent.

Occupancy was supposed to represent "is this hotel being run well and sold hard." It was a proxy. A reasonable one. But the manager was not paid on "run well." He was paid, in money and in recognition, on the proxy. So the proxy is what he optimized -- and the proxy had a seam, and he found it.

I saw none of this at the time. I saw a friend being clever, street-smart ingenuity aimed at a corporate dashboard, and I half admired it. I had no way to see it as anything else: I was just getting started in data. The strange part came later. For years, every time I helped build a dashboard, I dodged this seam without knowing it had a name. I knew that tying a bonus to a number bent it, but I knew it with my hands, not my head. Only with the CDMP and with CRISP-BI did I put the name on it that it had carried all along: it was not street-smarts, it was Goodhart's Law, and underneath it, the principal-agent problem.

## This is the agency problem wearing a KPI

Here is the part that matters most, and it is bigger than hotels.

This is the principal-agent problem, the oldest tension in management, dressed up as a metric. The chain (the principal) cannot stand in every hotel watching every decision its managers (the agents) make. So it does what every large organization does: it installs a number as a stand-in for oversight. The number is supposed to align the agent's behavior with the company's interest. Run the hotel well, the number goes up, everyone wins.

But the agent's actual interest (promotion, bonus, the award on the wall) attaches to the number, not to the goal the number was standing in for. And when the number is gameable, those two things come apart. The manager can serve himself while appearing, on every report the chain receives, to serve the chain. Goodhart's Law is what the agency problem looks like once a company reduces its oversight to a single figure. The figure becomes the surface the agent manages, and the real business goes on underneath it, unwatched.

This is also where the line falls between this post and the vanity metric in [the post before it](/blog/2026/the-metric-as-mirror-not-window/), and it is finer than it looks. A vanity metric was never a good proxy. Admission speed did not go bad under pressure; it was never aimed at care in the first place, and no incentive was needed to make it useless. Goodhart is the opposite story. Occupancy was a good proxy. Watch it passively, with nothing riding on it, and it tells you something true about how a hotel is being run. What broke it was the target. The moment a reward attached, the number stopped representing reality. Whether there was bad faith in it may be unanswerable, and the dolphin is there to tell you it is also beside the point. What is not beside the point is that you have stopped looking at a blind spot and started looking at an instrument under load.

## Same shape, all the way up the building

Once you have the pattern, you see it everywhere a number controls a reward. And it climbs well past the front desk, all the way to the stock market.

Return on equity (ROE) is one of the most watched numbers there is, even more than its cousin return on assets. It is profit divided by shareholders' equity, and it has the same shape as RevPAR, and the same seam: the denominator can be shrunk. The most famous way to shrink it is for a company to buy back its own shares. Spend cash repurchasing stock and equity falls, so ROE climbs even if the business earned nothing more. Do it with borrowed money (buy back shares with debt) and equity shrinks further while earnings power has not changed at all. Nobody ran the business better. Somebody reshaped the balance sheet so the ratio would read better.

Different industry, identical structure, and the agency problem in plain sight. Executive pay is often tied to ROE or earnings per share, so buy back enough stock and you hit the target without improving a single thing the number was meant to track. A respected proxy, a gameable denominator, a reward bolted to the proxy, and the real goal (the long-term health of the business) quietly going unserved while the number shows a triumph. The hotel manager shrank a room count. A CFO can shrink the equity base with a press release. The seam is the same.

## The cost was never the repairs

If you ask what the gaming cost the hotel chain, the honest answer is: directly, not much. A few rooms idled, some real maintenance done that did not need doing yet, a bit of foregone revenue on nights those rooms might have sold. Relatively low. If that were the whole bill, you could almost shrug it off.

The real cost is not on that ledger. The real cost is that the chain lost its thermometer.

You measure occupancy so you can make decisions. Does this property need a marketing push? Are we underpriced on weekends? Should we renovate, expand, or sell? Every one of those calls leans on the occupancy and RevPAR numbers being honest. When those numbers are quietly bent to one manager's bonus cycle, every decision downstream is made on a reading from an instrument that adjusts itself to the convenience of the person being measured. The chain thought it had a star property throwing off reliable signals. What it actually had was a thermometer held by someone with a reason to warm it with his hand before each reading.

That is the deep damage of Goodhart. It does not just inflate one figure. It destroys your ability to steer, because steering depends on instruments you can trust, and a gamed metric is an instrument that lies most exactly when the stakes are highest.

## The cure is governance, not a better metric

The instinct, when you discover a gamed metric, is to go find a better one. Resist it. There is no ungameable number. RevPAR was itself the industry's clever upgrade over raw occupancy, and it got gamed through the same denominator. Chasing a perfect metric is how you spend forever losing to people who are paid to find the seam. And the dolphin should have settled the question anyway: the agent does not have to understand your metric to exploit it. Sophistication in the measure buys you nothing against something that is only feeling for the shape of the payout.

What actually works is structural.

**Never let a single gameable number carry a paycheck.** The instant one figure controls a bonus, Goodhart starts working on it, consciously or not. The defense is structural: tie pay to a *basket* that is hard to move in one direction at once. Occupancy alone is gameable. Occupancy alongside total revenue, alongside guest complaints about availability, alongside actual rooms-sold: now you cannot shrink the denominator without one of the other numbers telling on you.

What makes that a basket is not the count. It is the independence. Total revenue and rooms sold are numerators, and they do not live inside occupancy the way occupancy lives inside RevPAR. Stack up three figures that share a denominator and you have diversified nothing. You have one metric wearing three hats, and it will tell you the same lie three times in a row while you congratulate yourself on the corroboration. Not a smarter single metric. A portfolio of metrics that can actually disagree with each other, plus human judgment reading them together.

**Watch the denominator: it leaves a trail.** A room going to maintenance is a real operational event. It gets logged. A closed tower in January is on the calendar, declared and seasonal. A flurry of "maintenance" that happens to track the end of every bonus period is a fingerprint. And you do not need anything fancier than that pattern to start asking questions. The gaming hides in the number; the evidence hides in the operational record underneath it. Nobody caught Kelly by watching the fish count either. They caught her by draining the pool.

And the deepest fix is the one the agency problem has always demanded: you cannot fully outsource oversight to a metric. The number is a tool for directing attention, not a replacement for judgment. The companies that get gamed worst are the ones that most wanted the number to do the watching for them.

## Closing

The manager won his awards, and in a sense he earned them. He optimized the number the chain paid him to optimize, with skill and restraint. The failure was not his character. It was a company that mistook a gameable proxy for the goal, attached money and recognition to it, and then stopped looking. Deming put it about as bluntly as it can be put, in a line H. Thomas Johnson recalls him saying: give people quantitative targets and make their jobs depend on hitting them, and *"they will likely meet the targets -- even if they have to destroy the enterprise to do it."*

He did not destroy anything. He just bent a thermometer a few degrees, quietly, for years, while everyone upstairs kept reading the temperature and trusting it. That is the quiet version of Goodhart, and it is the common one. Not a scandal. A slow, deniable, award-winning erosion of the one thing a measurement is for: telling you the truth when you are not in the room to check.

And if it consoles you to think this takes a scheming human being, it does not. It takes a payout with a shape. Somewhere in Gulfport there was a pile of garbage under a rock, growing, for as long as the fish kept coming.

You do not fix that with a better number. You fix it by refusing to let any single number carry a paycheck -- and by remembering that the moment you stop watching and let the metric watch for you, you have handed the people you measure the pen that writes your reality.
