---
name: review
description: Critically read a diff for correctness, edge cases, security, and test coverage — then approve or send it back with concrete feedback. Use when reviewing a PR or self-reviewing before requesting review. Triggers — review this, code review, review my changes, check this diff, is this ready for review, look over this PR.
---

# Code Review

A structured, critical read of a diff. Either approve, or send it back with
feedback specific enough to act on.

## When to Use

Reviewing someone's PR, or self-reviewing a diff before requesting review.

## Steps

1. Read the intent — PR description, ticket. Know what the diff should do.
2. Read the diff top to bottom for correctness against that intent.
3. Second pass: edge cases, error handling, concurrency, security.
4. Third pass: tests — do they actually cover the change and its boundaries?
5. Note conventions, naming, readability — lower priority, still note.

## Checklist

Correctness · error handling · security · tests · performance · readability ·
scope creep · migration / rollback safety.

## Rules

- Label every comment: blocking issue vs non-blocking nit.
- Critique the code, not the author; explain *why* and suggest a direction.
- Verify claims against the actual diff; cite `file:line`.
- Check what is *missing* — untested path, unhandled error — not just what is present.
- Approve when the diff is correct and safe; do not gate on taste.

## Review loop

The verdict is binary: approve, or send back to `tdd` with feedback. On a
send-back, each blocking item must be concrete enough to act on directly.
Re-review after the fix pass; iterate until approved. Do not approve to be nice.

## Output

- Summary verdict — approve / changes requested
- Blocking issues, with `file:line`
- Non-blocking suggestions / nits
- Questions for the author
