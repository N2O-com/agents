---
name: plan
description: >
  Produce a thorough implementation plan after recon and before writing any
  code. The plan is the cheapest place to catch a wrong approach — every
  minute spent here saves ten in the tdd loop. Use after recon and before
  tdd. Triggers — plan this, what is the approach, how will you implement,
  before you code, plan before implementation, think before coding.
---

# Plan

After recon, before any code: a thorough, concrete commitment to an approach.
This is where you do the hard thinking. Every decision made here is one you
do not have to make mid-implementation, when context is fragmented and
backtracking is expensive. A vague plan is no plan — if you cannot explain
exactly how the implementation will work, you are not ready to write a test.

## When to Use

After `recon` is complete and before `tdd` starts. The recon output is your
primary input.

## Steps

1. **Restate the task.** One or two sentences proving you understood the
   request. Include the success criteria — how will you know this is done?
   If the task description is ambiguous, call out the ambiguity and state
   which interpretation you are choosing and why.

2. **Describe the approach.** Not "I will modify the handler." Say which
   handler, what the change is, how data flows through the modification,
   and why this approach fits the patterns recon found. If there are two
   viable approaches, name both, say which you are picking, and say why —
   then forget the other one. Do not hedge.

3. **Identify every file you will touch.** For each one, say what changes
   and why. If a file needs to be created, say what it contains and which
   existing file it is modeled on. If you are unsure whether a file needs
   changing, that is an open question — write it down, do not hide it.

4. **Design the tests before the code.** List every test you will write.
   For each test, state:
   - The behavior it verifies, in plain language.
   - The inputs and the expected outputs or side effects.
   - The test level — unit, integration, or e2e — and why that level.
   If recon found no existing tests in the area, name the test patterns
   from elsewhere in the codebase you will follow and where you found them.

5. **Walk through edge cases and error paths.** What inputs are weird?
   What happens on failure — network down, missing data, malformed input,
   concurrent access? Which of these do you need to handle, and which are
   out of scope? Say both.

6. **Name the risks.** What could go wrong? Where are you least confident?
   What assumption, if wrong, would force a restart? If the answer is
   "nothing," you are not thinking hard enough.

7. **State your implementation order.** Which test do you write first?
   Which file do you touch first? The order matters because each step
   should build on the last — a later test should not require rethinking
   an earlier one. If you cannot sequence the work, you do not understand
   the dependencies yet.

## When the plan involves choosing

Most plans do not — the path is already constrained by the task and the
codebase. When it is not — when you need to pick a library, service, or
architectural pattern — slow down and do this before locking in Step 2:

1. Write the decision criteria *first*, before evaluating any option. Once
   you have looked at the options, you will retroactively justify the one
   you already wanted. Criteria first.
2. Enumerate 2–4 real candidates. Always include "do nothing / use what is
   already in the codebase" — that is the default until something beats it.
3. For any new dependency, check license, maintenance activity, open CVEs,
   and footprint (binary size, runtime cost, peer-dep weight).
4. If uncertainty still blocks the decision, plan a timeboxed throwaway
   spike. State the timebox and the disposal up front — the spike code is
   never quietly promoted to production.
5. Verify claims against primary sources (docs, source, changelog). Not
   blog posts, not summaries, not memory.

Default toward the boring, already-in-use option. Novelty has to earn its
place by satisfying a criterion the boring option fails — not by being
interesting.

## Rules

- Concrete, not abstract. "Modify the `createVisitor` handler in
  `handlers/visitors.ts` to validate email format before insert" is a plan.
  "Update the relevant endpoint" is not.
- Every claim about the codebase must trace back to a `file:line` from
  recon. If you are guessing, say so.
- Refactors and behavior changes do not share a plan. If both are needed,
  do one then the other — never bundled. The behavior change writes a
  failing test; the refactor keeps every existing test green.
- No "just plumbing." Every change in the plan must have an observable
  effect a test will verify. If a change has no test, either it does not
  belong in the plan or the test is the thing that is missing.
- If something is out of scope, say so explicitly. Implicit scope boundaries
  become scope creep during implementation.
- Do not plan work you do not intend to do. If a refactor would be nice but
  is not required, leave it out — mention it as a follow-up, not a step.
- The plan is wrong. It will change during implementation as you learn things
  you could not have known upfront. That is fine. The value is in the
  thinking, not in the document being prophetic. But start with the best
  plan you can make — "I will figure it out as I go" is not a plan.

## Output

- Task restatement + success criteria
- Approach — what, how, why this shape
- Files to touch — each with what changes and why
- Tests to write — behavior, inputs/outputs, level
- Edge cases and error handling
- Risks and low-confidence areas
- Implementation order
