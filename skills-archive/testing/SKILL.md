---
name: testing
description: Choose test strategy across the pyramid — unit, integration, browser/e2e — and triage flaky tests. Use when deciding what to verify, planning outer-loop coverage, or chasing a nondeterministic test. Triggers — test strategy, what should we test, e2e tests, integration tests, flaky test, test is failing intermittently, coverage gaps.
---

# Testing

Decide *what* to verify across the test pyramid and triage flaky tests. The
outer loop around `tdd`.

## When to Use

When choosing what to verify, planning coverage for a change, or chasing a
nondeterministic test.

## Responsibilities

- Pick the right level for each risk: unit vs integration vs browser/e2e.
- Apply the pyramid — many fast unit tests, fewer integration, few e2e.
- Cover the meaningful paths: happy path, boundaries, error paths, regressions.
- Reserve browser/e2e coverage for critical user journeys only.
- Triage flaky tests: quarantine, root-cause, fix or delete.

## Rules

- Test behavior and contracts, not implementation detail.
- e2e is expensive — use it only for journeys unit/integration cannot cover.
- A flaky test is a bug: fix the root cause or remove it; never just retry-loop.
- Coverage percent is a smell detector, not a goal.
- Every fixed bug leaves a regression test behind.

## Flaky-test triage

1. Reproduce — run repeatedly; identify the nondeterminism (time, ordering,
   async, network, shared state).
2. Quarantine if it is blocking others, with a tracking note.
3. Fix the root cause — control the clock, await properly, isolate state.
4. Re-run many times to confirm it is stable.

## Output

- Risks mapped to chosen test level — table
- Gaps in current coverage
- e2e journeys worth automating
- Flaky tests + disposition
