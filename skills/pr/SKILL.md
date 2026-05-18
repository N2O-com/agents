---
name: pr
description: Drive an already-open pull request through to merge — addressing review feedback, rebasing, resolving conflicts, and keeping CI green. Use when a PR is open and stuck at the merge bottleneck. Triggers — get this PR merged, address review comments, resolve conflicts, rebase the branch, CI is failing on my PR, drive this to merge.
---

# PR Shepherd

Drive an open PR through the merge bottleneck: feedback, rebase, conflicts, CI.

## When to Use

A PR is open and needs to land — review threads to resolve, a stale branch,
conflicts, or red CI.

## Steps

1. Check PR status: review comments, CI state, mergeability, branch staleness.
2. Triage review feedback — for each item: address it, push back with reasoning,
   or explicitly defer it. Say which.
3. Make changes as focused follow-up commits; reply to each thread.
4. Rebase or merge the base branch when behind; resolve conflicts deliberately.
5. Re-run CI; if it fails, fix the root cause.
6. Re-request review. Repeat until merged.

## Rules

- Every review thread gets a resolution — fixed, answered, or explicitly deferred.
- Resolve conflicts by understanding both sides; never blindly take one.
- Keep PR scope fixed — new ideas become new issues, not new commits here.
- Do not merge with red or skipped CI, or unresolved blocking comments.
- Keep the PR description current as the diff evolves.

## Output

- Current status — CI / reviews / conflicts
- Feedback items + disposition
- Actions taken this pass
- Blockers / what is needed to merge
