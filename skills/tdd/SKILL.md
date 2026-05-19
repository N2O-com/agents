---
name: tdd
description: Drive strict red-green-refactor test-driven development, with test-quality discipline, a failure-diagnosis sub-loop, and explicit anti-rationalization guardrails. Use when implementing a new behavior, fixing a bug, refactoring code that needs coverage, or chasing a test failure. Triggers — implement, write this feature, fix this bug, add behavior, tdd, write a test first, red green refactor, test failure, diagnose this failure, root cause.
---

# TDD

Strict red-green-refactor. The discipline that keeps you from writing code
that "looks right" but is not actually tested.

## When to Use

Writing any new behavior, fixing any bug, or refactoring code that needs
coverage. Run after `plan`, on one task at a time.

## The loop

1. Write the smallest failing test that captures the next behavior.
2. Run it. Confirm it fails *for the expected reason* — the right assertion
   failing on the right line, not a missing import, typo, or setup error.
3. Write the minimum production code to make it pass.
4. Run the full suite; confirm green.
5. Refactor with tests green. If a test goes red during the refactor, you
   broke something — stop and fix before continuing.

## Test quality

- Test behavior and contracts, not implementation detail. A test that breaks
  under a behavior-preserving refactor is a bad test. Assert on inputs →
  outputs, side effects, and observable state — not on how the code is
  structured internally.
- Cover the meaningful paths, not just the golden path: happy path,
  boundaries, error paths, regression cases.
- One behavior per test. Names should explain what fails when the test fails.
- Fast and deterministic. Isolate I/O, time, randomness, and shared state
  behind seams.
- A hard-to-write test is a design signal. If the setup is painful, refactor
  the production code before continuing the test.
- Every fixed bug leaves a regression test behind. The failing test reproduces
  the bug *first*, then the fix lands.
- Coverage percent is a smell detector, not a goal. 100% of bad tests is
  worse than 60% of good ones.

## When a test fails

If the fix is not obvious, follow the diagnosis discipline before changing
any code:

1. Read the failure message and stack trace. Understand what *actually*
   failed, not what you expected to fail. Reproduce it consistently before
   guessing at causes.
2. Check what you changed most recently — the bug is almost always in the
   new code, not the old code. Diff before you debug.
3. Form one hypothesis. Make one minimal change to test it. Not two changes,
   not a "while I'm here" cleanup. One.
4. If three consecutive fix attempts fail, stop. The approach is wrong, not
   the implementation. Re-read the `recon` output. Reconsider the plan. You
   may need to back up further than feels comfortable.

Rules under this loop:

- No fix without a root cause. A symptom patch is not a fix — it is a second
  bug, layered on top of the first.
- One hypothesis, one change at a time. Bundle fixes and you will not know
  which one worked, or whether you introduced a new problem along the way.
- A flaky test is a bug in the test or the code under it. Never just retry-
  loop — find the nondeterminism (time, ordering, async, shared state) and
  remove it.

## Traps to avoid

These are the rationalizations that will tempt you to skip the discipline.
Each is wrong, and each is wrong for a specific reason:

- **"I already know what the code looks like, I'll write the test after."**
  This is rationalized test-after, not TDD. The test must fail *first*. If
  you wrote production code before the test, delete the production code,
  write the test, watch it fail, then rewrite the production code. "I already
  know" is the exact reason you need the test first — to verify the
  assumption you are about to encode.

- **"The test passed immediately, so I must have gotten it right."**
  No. A test that passes before the production code exists is not testing
  what you think it is testing. It is a false safety net. Stop and figure out
  why it passed — wrong assertion, missing setup, already-satisfied condition
  — before writing another line.

- **"This test is tightly coupled to the implementation, but it works."**
  A test that breaks under a behavior-preserving refactor locks in the shape
  of the code, not its behavior. Rewrite it to assert on what the code
  *does*, not how it does it.

- **"I'll skip the 'confirm it fails for the expected reason' step just this
  once."** Do not. A test that fails for the wrong reason (typo, unresolved
  import, missing fixture) will silently start passing for the wrong reason
  later — and you will believe the feature works when it does not.

- **"Let me bundle these two fixes since they are related."** They are not
  related until you have evidence they are. Bundle them and a regression in
  one will be misattributed to the other for hours.

## Definition of done

Before declaring the task done: full suite green, linter clean, formatter
applied. Never commit with any of these red.

## Hand-offs

When the loop is complete and the definition of done is met, the diff is
ready for `review`. If `review` returns feedback, re-enter this loop —
red-green per item.
