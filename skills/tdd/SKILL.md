---
name: tdd
description: Drive strict red-green-refactor test-driven development for any behavior change. Use when implementing a new behavior, fixing a bug, or refactoring code that needs coverage. Triggers: implement, write this feature, fix this bug, add behavior, tdd, write a test first, red green refactor.
---

# TDD

Drive strict red-green-refactor. The inner loop for any behavior change.

## When to Use

Writing any new behavior, fixing a bug, or refactoring code that needs coverage.
Works on one unit at a time — typically a unit from an approved `scope` plan.

## Steps

1. Write the smallest failing test that captures the next behavior.
2. Run it; confirm it fails *for the expected reason*.
3. Write the minimum production code to make it pass.
4. Run the full suite; confirm green.
5. Refactor with the tests green.

## Rules

- No production code without a failing test motivating it.
- One behavior per test; descriptive names.
- Fast and deterministic; isolate I/O behind seams.
- A hard-to-write test is a design signal — refactor before continuing.
- For bug fixes: the failing test reproduces the bug *first*, then fix it.

## Definition of done

Before declaring a unit done: full suite green, linter clean, formatter applied.
Never commit with any of these red.

## Hand-offs

- Defer "what kinds of tests, how much" to `testing`.
- A finished unit is ready for `review`.
- When `review` returns feedback, re-enter this loop — red-green per item.
- Implement only the unit currently approved in the `scope` plan; re-check
  intent before starting each unit in case it changed.
