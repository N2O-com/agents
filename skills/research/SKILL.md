---
name: research
description: Evaluate external options — libraries, services, architectural approaches — and run throwaway spikes when the path is not obvious. Use when choosing a dependency or approach, comparing alternatives, or de-risking an unknown. Triggers: which library, evaluate options, compare approaches, should we use, spike, prototype, what is the best way to.
---

# Research

Evaluate external options and de-risk unknowns with timeboxed spikes, then
recommend one path with explicit reasoning.

## When to Use

When the implementation path is not obvious: choosing a library or service,
comparing architectural approaches, or when uncertainty needs a prototype to
resolve before committing.

## Steps

1. State the decision and the constraints it must satisfy.
2. Enumerate 2–4 real candidates — include "do nothing / build minimal".
3. Evaluate each against the constraints. Check license, maintenance health,
   open CVEs, and footprint (bundle/binary/runtime cost).
4. If uncertainty remains, spike the top candidate — timeboxed, throwaway code.
5. Recommend one option with the reasoning and the main risk of being wrong.

## Rules

- Write the decision criteria down *before* evaluating options.
- Spike code is timeboxed and disposable — never quietly promoted to production.
- Verify claims against primary sources (docs, source, changelog), not blog posts.
- Prefer the boring, already-in-use option unless a criterion forces otherwise.

## Output

- Decision + constraints / criteria
- Options compared — table against the criteria
- Spike findings, if any
- Recommendation + reasoning
- Risk if we are wrong / cost to reverse
