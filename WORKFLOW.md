# Workflow

How agent skills are structured in this repo.

## Why

Stripe (Minions), Coinbase (Forge), and Ramp (Inspect) all build coding
agents around the same pattern: narrow well-scoped tasks, deterministic
enforcement outside the LLM (the agent doesn't decide whether to run the
linter — the pipeline does), and isolated sandboxes. The agent is one node
in a larger system, not the whole system.

To model this for an agent that runs long, on tightly scoped tickets, with
no human in the loop until the PR opens, the skills are optimized for:

- **Judgment, not facts.** Skills hold what the agent needs to *think*
  well — conventions, architectural intent, and anti-rationalization
  (naming the excuses the agent will use to skip discipline; pattern from
  [obra/superpowers](https://github.com/obra/superpowers)). Repo-specific
  facts — commands, file paths, package managers — stay in `AGENTS.md`.
- **Hard handoffs to infrastructure.** Anything the agent could lie about
  or skip — running tests, running the linter — lives outside the LLM, in
  the gate. The agent experiences enforcement, it does not perform it.

## Pipeline

The pipeline uses two agents and five skills total.

- Agent 1 — Builder
- Agent 2 — Reviewer

**Builder:**

1. **`recon`** — explores the repo. Maps entry points, flows, existing
   tests, and conventions; cross-checks `AGENTS.md` against the actual code.
2. **`plan`** — commits to an implementation approach. Restates the task,
   lists files to touch, designs the tests, walks edge cases, flags risks.
3. **`tdd`** — strict red-green-refactor. Writes a failing test, makes it
   pass, refactors. Diagnoses failures by root cause, not symptom.

**Gate** (not an agent) — runs lint, typecheck, and tests. On failure,
errors return to the builder's `tdd`; max 3 retries before stopping.

**Reviewer:**

- **`review`** — independent read of the diff. Approves (control returns
  to the builder for `pr`) or sends back to `tdd` with concrete feedback.

**Builder (resumes):**

- **`pr`** — opens a pull request for human review. Creates the branch,
  commits, writes the description, and links the ticket.

## Architecture

**The gate is infrastructure, not a skill.** The agent can't skip it, lie
about it, or decide what checks to run. The orchestration layer runs the
commands and reads exit codes. The agent just experiences "I got sent
back with errors."

**Review is independent by design.** The builder owns the work end-to-end
except for one cut: the diff goes to a separate reviewer agent that did
not participate in building. A reviewer that participated would
rationalize, not review. The PR description, by contrast, is written by
the *builder* — the builder has the context the description needs to
convey, which an independent reviewer would have to reverse-engineer from
the diff.

**Skills are global; repo conventions are local.** The same skills run
across every repo. Repo-specific commands and conventions live in each
repo's `AGENTS.md`.
