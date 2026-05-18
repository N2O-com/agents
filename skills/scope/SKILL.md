---
name: scope
description: Decompose a feature request or work-in-progress diff into the smallest sequence of independently shippable units, then stop for plan approval before any code is written. Use at the start of a task or before opening a large PR. Triggers: break this down, decompose, plan this work, how should we split, scope this, too big for one PR.
---

# Scope

Break an intent or an existing diff into the smallest sequence of independently
shippable units. Prevents the giant unreviewable PR.

## When to Use

At the start of a task, or when a change is growing too large for one
reviewable PR. Input is a feature request, a ticket, or a work-in-progress diff.

## Steps

1. Restate the goal as one sentence and one success signal.
2. Identify the seam: what can ship first and stay safe even if nothing follows.
3. Split into units of roughly one reviewable PR each.
4. Sequence units by dependency; mark which are independent (parallelizable).
5. Separate refactors (no behavior change) from behavior changes — never mix
   them in one unit.
6. Flag units that need `recon` or `research` before they can start.
7. Present the plan and **stop**. Do not start implementation until the plan is
   approved or revised.

## Rules

- Every unit must be independently mergeable and leave the main branch releasable.
- Prefer feature-flagged increments over a long-lived branch.
- If a unit cannot be tested in isolation, it is too big or wrongly cut.
- No "just plumbing" unit with no test and no observable effect — fold it into
  its consumer.
- The breakdown is a *plan*: editable. Whoever reviews it may re-order, merge,
  split, or drop units.

## Output

- Goal + success signal
- Units, ordered — each with: what ships · why safe alone · est. size ·
  depends-on · independent? · needs recon/research?
- Suggested PR sequence
- Risks / open questions
- **Awaiting approval** — nothing proceeds past this line
