---
name: pr
description: Open a pull request once an independent reviewer has approved the diff. Compose the branch name, commit message, PR description, and ticket link so a human landing on the PR cold can understand it. Use only after the reviewer agent returns approve via `review` — never directly after `tdd`. Triggers — open a PR, create the PR, push this up for review, write the PR description, link the ticket.
---

# PR

After the reviewer agent has approved the diff via `review`, the work needs
to leave the builder's sandbox as a pull request a human can read. This
skill produces the artifacts a human reviewer landing on the PR cold needs:
a branch, a commit, a description, and a ticket link.

## When to Use

Two preconditions must both be true, in this order:

1. The gate is clean — lint, typecheck, and tests all pass.
2. The reviewer agent has read the diff via `review` and returned an
   **approve** verdict.

The builder does **not** run `pr` immediately after `tdd`. A clean gate
triggers `review`, not `pr`. Only after an independent reviewer has
approved does control return to the builder for `pr`.

## Steps

1. **Branch.** You should be on a feature branch, not the main branch.
   Name the branch after the ticket or task — short, lowercase, hyphenated,
   recognizable later.
2. **Commit.** Stage only the files this task changed. Commit with a
   one-line imperative summary ("add", "fix", "rename"). If extra context
   is useful, leave a blank line and add a short paragraph explaining why.
3. **Push.** Push the branch to the remote.
4. **Write the PR description.** Three to five lines:
   - What changed, in one or two sentences.
   - A link to the ticket or task.
   - The approach, in one sentence — why this shape, not another.
   The description is for the reviewer; it is not a design doc.
5. **Open the PR.** Target the correct base branch. The ticket is linked
   in the description; the tracker should reflect the work.

## Rules

- One logical change per PR. If the diff covers two unrelated changes,
  that is two PRs. Do not bundle.
- Never commit or push to the main branch directly. The PR is the only
  path changes land.
- Stage only the files the plan said you would touch, plus anything
  `review` explicitly approved. If staged files extend further than that,
  stop and reconcile — either the plan was wrong or you drifted.
- Commit messages are imperative, not past tense. They describe the
  change, not the journey of writing it.
- The PR description summarizes; it does not re-derive. The reasoning
  lived in `plan`, the implementation lived in `tdd`. The description
  points at them, it does not replay them.

## Traps to avoid

- **"I just finished `tdd` and the gate is clean — time to open the PR."**
  No. A clean gate hands the diff to the reviewer agent, not to `pr`. A
  separate reviewer reads the diff first and either approves or sends it
  back. `pr` runs only after an approve verdict comes back. If you find
  yourself here without one, stop — you are about to skip `review`.
- **"While I'm here, let me fix this small unrelated thing."** No. Open
  a separate PR. Bundling unrelated changes makes the review harder, the
  diff harder to reason about, and the history harder to bisect when
  something regresses later.
- **"More context in the description is better."** No. A short, focused
  description gets read. A long one gets skimmed. Three to five lines
  beats three to five paragraphs.
- **"The diff is small enough that the reviewer will figure it out."** No.
  The reviewer does not know what `tdd` produced or why. Five lines of
  context costs you nothing and saves time for every reviewer who reads
  the PR.

## Output

- Branch name
- Commit message(s)
- PR description — what changed, ticket link, approach
- Link to the opened PR
