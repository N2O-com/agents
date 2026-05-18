# Skills Plan

Overall plan for the contents of `/skills`. This **replaces** the current
`pm` / `ci` / `tdd` folders. Each skill lives at `skills/<name>/SKILL.md`.

## The seven skills

| Skill         | Mode                                                          | When in the day                          |
|---------------|---------------------------------------------------------------|-------------------------------------------|
| `scope`       | Decompose work into small, sequenced, shippable units         | Start of a task; before opening a big PR  |
| `recon`       | Map how this codebase works in a feature area                 | Every time you touch unfamiliar code      |
| `research`    | Evaluate external options, libraries, approaches; spikes      | When the path isn't obvious               |
| `tdd`         | Inner loop: red-green-refactor                                | Writing any behavior                      |
| `testing`     | Test strategy across the pyramid incl. browser/e2e + flaky triage | Choosing what to verify; outer-loop checks |
| `review` | Critical read of a diff                                       | Giving or prepping for review             |
| `pr` | Drive an open PR to merge: feedback, rebase, conflicts        | The merge bottleneck                      |

### How they chain

```
recon ─┐                          ┌──── review loop ────┐
       ├─► scope ──[approval]──► tdd ◄─► testing ─► review ─► pr
research ┘         gate            ▲                  │
                                   └──────────────────┘
```

`recon` and `research` are inputs to `scope`. `scope` produces the units of work
that `tdd` implements. `testing` informs what `tdd` writes and adds outer-loop
coverage. `review` reads the resulting diff; `pr` lands it.

Two gates, both adopted from the open-swe reference (below):

- **Approval gate** between `scope` and `tdd` — the plan is reviewed and approved
  *before any code is written*. No silent "code first, fix later".
- **Review loop** — `review` either approves or sends the diff back to `tdd`
  with feedback; iterate until correct. Review is not one-shot.

### Reference: langchain-ai/open-swe

We modeled the chain on [open-swe](https://github.com/langchain-ai/open-swe)'s
phase pipeline. Its four graphs map onto our skills:

| open-swe phase | What it does                                              | Our skill(s)             |
|----------------|-----------------------------------------------------------|--------------------------|
| Manager        | Entry point; initializes state, routes the task           | (the human / task setup) |
| Planner        | Researches the codebase, generates a step-by-step plan, **requires manual plan approval** | `recon` + `research` → `scope` |
| Programmer     | Executes each plan step; writes code, runs tests          | `tdd` + `testing`        |
| Reviewer       | Checks quality/correctness; loops back to Programmer with feedback until correct | `review` (loops to `tdd`) |

Practices worth carrying over verbatim:

- **`AGENTS.md` convention file** — open-swe injects repo conventions into every
  prompt. `AGENTS.md` is itself a cross-tool standard, so it fits the
  framework-agnostic goal. `recon` reads/maintains it; all skills assume it.
- **Definition of done** — open-swe runs linters, formatters, and tests *before
  committing*. Make this an explicit gate (see `tdd` / `pr`).
- **Independent units** — open-swe fans work out to child agents. We stay
  framework-agnostic: `scope` just marks which units are independent, so
  *whatever* agent runs them can parallelize — no specific subagent mechanism.
- **Mid-flight feedback** — open-swe ingests new messages before its next step.
  Skills should re-check intent at step boundaries, not barrel ahead.

### Format: skills.sh official spec

These skills follow the [skills.sh](https://skills.sh) official format
([vercel-labs/skills](https://github.com/vercel-labs/skills)) and are
**framework-agnostic** — the same skill must work across Claude Code, Cursor,
Cline, OpenCode, and other agents. That constrains how we write them:

- **Directory:** one self-contained folder per skill, `skills/<name>/SKILL.md`,
  plus any bundled resource `.md` files / scripts in that folder.
- **Frontmatter (required):** `name` (lowercase + hyphens, unique) and
  `description` (purpose + when to use; pack in concrete trigger phrases).
- **Frontmatter (optional):** `metadata.internal: true` to hide from discovery.
  Avoid agent-specific keys like `allowed-tools` or `context: fork` — they only
  work on some agents. If used, the skill must still function without them.
- **No framework coupling:** don't name a specific agent's tools, subagent
  mechanism, slash commands, or file conventions. Describe *what* to do, not
  *which tool* does it. "Search the codebase" — not "use the Grep tool".
- **Section convention:** after the frontmatter, lead with `## When to Use`,
  then `## Steps` (or `## Process`). Skill-specific sections (`Rules`,
  `Output`) follow. Keep the body short and imperative.

### Shared conventions (apply to every SKILL.md)

- Lead with a one-line statement of the mode, then `## When to Use`.
- Use numbered **Steps** when the skill is a procedure; use **Responsibilities**
  + **Rules** when it's a posture.
- End with an **Output** template when the skill produces an artifact.
- Push long reference material into sibling `.md` files in the skill folder and
  link them with relative paths, rather than bloating SKILL.md.
- Refer to conventions, files, and capabilities generically so the skill ports
  across agents.

---

## scope

**Purpose:** Take an intent ("add X") or an existing diff and break it into the
smallest sequence of independently shippable units. Prevents the giant unreviewable PR.

**Input:** a feature request, a ticket, or a work-in-progress diff.

SKILL.md should contain:

- **Responsibilities**
  - Restate the goal as one sentence and one success signal.
  - Identify the seam: what can ship first and be safe even if nothing follows.
  - Split into units of ≤ ~400 LOC / one reviewable PR each.
  - Sequence units by dependency; mark which are parallelizable.
  - Separate refactors (no behavior change) from behavior changes — never mix in one unit.
  - Flag the units that need `recon` or `research` before they can start.
- **Rules**
  - Every unit must be independently mergeable and leave `main` releasable.
  - Prefer feature-flagged increments over a long-lived branch.
  - If a unit can't be tested in isolation, it's too big or wrongly cut.
  - No unit "just plumbing" with no test and no observable effect — fold it into its consumer.
- **Approval gate** (from open-swe's Planner)
  - The unit breakdown is a *plan* — present it and stop. Do not start `tdd`
    until the plan is explicitly approved or revised.
  - Make the plan editable: the reviewer can re-order, merge, split, or drop units.
- **Output template**
  - Goal + success signal
  - Units (ordered): name · what ships · why safe alone · est. size · depends-on · parallelizable? · needs recon/research?
  - Suggested PR sequence
  - Risks / open questions
  - **Awaiting approval** — explicit line; nothing proceeds past it

---

## recon

**Purpose:** Build an accurate mental model of how a feature area of *this*
codebase works before changing it. Read-only.

**When:** every time you touch unfamiliar code. Cheap insurance against wrong assumptions.

SKILL.md should contain:

- **Loop**
  1. Locate the entry points (routes, handlers, CLI, jobs) for the area.
  2. Trace one representative request/flow end to end; note each layer it crosses.
  3. Identify the data model and where state is persisted.
  4. Find the existing tests for the area — they document intended behavior.
  5. Note the conventions actually used here (error handling, logging, naming, patterns).
  6. List the integration points and external dependencies.
  7. Check `AGENTS.md` — reconcile documented conventions with observed ones; if
     they've drifted, flag it or propose an update. (`AGENTS.md` is the cross-tool
     standard; treat any agent-specific file as a legacy alias.)
- **Rules**
  - Read, don't change. The deliverable is understanding, not a diff.
  - Cite findings as `file:line` so they're verifiable.
  - Distinguish "how it works" (observed) from "why" (inferred — say so).
  - Call out surprises, dead code, and landmines explicitly.
  - Prefer reading tests and types over reading prose docs (docs drift).
  - Conventions belong in `AGENTS.md` so every other skill inherits them.
- **Output template**
  - Area + entry points
  - Flow walkthrough (the layers, in order)
  - Data model & state
  - Conventions to follow
  - Integration points
  - Landmines / surprises
  - Open questions

Possible supporting file: `recon/tracing.md` — tactics for following a flow
across async boundaries, queues, events.

---

## research

**Purpose:** Evaluate external options — libraries, services, architectural
approaches — and run throwaway spikes when the path isn't obvious.

SKILL.md should contain:

- **Loop**
  1. State the decision and the constraints it must satisfy.
  2. Enumerate 2–4 real candidate options (include "do nothing / build minimal").
  3. Evaluate each against the constraints; note license, maintenance health, footprint.
  4. Spike the top candidate if uncertainty remains — timeboxed, throwaway code.
  5. Recommend one option with the reasoning and the main risk of being wrong.
- **Rules**
  - Decision criteria are written down *before* evaluating options.
  - Spike code is timeboxed and explicitly disposable — never quietly promoted to prod.
  - Check: maintenance activity, open CVEs, license compatibility, bundle/binary cost.
  - Prefer the boring, already-in-use option unless a criterion forces otherwise.
  - Verify claims against primary sources (docs, source, changelog) — not blog posts.
- **Output template**
  - Decision + constraints / criteria
  - Options compared (table against criteria)
  - Spike findings (if any)
  - Recommendation + reasoning
  - Risk if we're wrong / reversal cost

---

## tdd

**Purpose:** The inner loop — strict red-green-refactor for any behavior change.
(Closest to the current `skills/tdd/SKILL.md`; keep its core, tighten.)

SKILL.md should contain:

- **Loop**
  1. Write the smallest failing test that captures the next behavior.
  2. Run it; confirm it fails *for the expected reason*.
  3. Write the minimum production code to make it pass.
  4. Run the full suite; confirm green.
  5. Refactor with tests green.
- **Rules**
  - No production code without a failing test motivating it.
  - One behavior per test; descriptive names.
  - Fast and deterministic; isolate I/O behind seams.
  - A hard-to-write test is a design signal — refactor before continuing.
  - For bug fixes: the failing test reproduces the bug *first*, then fix.
- **Definition of done** (from open-swe — gate before hand-off)
  - Full suite green, linter clean, formatter applied — before declaring a unit done.
  - Never commit with these red.
- **Hand-offs**
  - Defer "what kinds of tests / how much" to `testing`.
  - When done, the diff is ready for `review`.
  - When `review` returns feedback, re-enter the loop here (red-green per item).
  - Only act on the unit currently approved in the `scope` plan — re-check before
    starting each unit in case intent changed.

Possible supporting file: `tdd/defense-in-depth.md` (carry over from
`skills-old/tdd-agent/`).

---

## testing

**Purpose:** Outer-loop test *strategy* — choosing what to verify across the
pyramid (unit / integration / browser-e2e) and triaging flaky tests.

SKILL.md should contain:

- **Responsibilities**
  - Decide the right level for each risk: unit vs integration vs e2e.
  - Apply the pyramid — many fast unit tests, fewer integration, few e2e.
  - Cover the meaningful paths: happy path, boundaries, error paths, regressions.
  - Set up browser/e2e coverage for critical user journeys only.
  - Triage flaky tests: quarantine, root-cause, fix or delete.
- **Rules**
  - Test behavior and contracts, not implementation detail.
  - e2e is expensive — reserve for journeys that unit/integration can't cover.
  - A flaky test is a bug: fix the root cause or remove it; never just retry-loop.
  - Coverage % is a smell detector, not a goal.
  - Every fixed bug leaves a regression test behind.
- **Flaky-triage sub-loop**
  1. Reproduce — run repeatedly, identify nondeterminism (time, order, async, network).
  2. Quarantine if blocking others, with a tracking note.
  3. Fix the root cause (control the clock, await properly, isolate state).
  4. Re-run many times to confirm stable.
- **Output template**
  - Risks → chosen test level (table)
  - Gaps in current coverage
  - e2e journeys worth automating
  - Flaky tests + disposition

Possible supporting files: `testing/browser-e2e.md`, `testing/flaky-triage.md`.

---

## review

**Purpose:** A critical, structured read of a diff — for giving review or for
self-review before requesting one.

SKILL.md should contain:

- **Loop**
  1. Read the PR description / intent; know what the diff is *supposed* to do.
  2. Read the diff top to bottom for correctness against that intent.
  3. Second pass: edge cases, error handling, concurrency, security.
  4. Third pass: tests — do they actually cover the change and its boundaries?
  5. Note conventions, naming, readability — lower priority, still note.
- **Rules**
  - Distinguish blocking issues from nits — label every comment.
  - Critique the code, not the author; explain *why*, suggest a direction.
  - Verify claims against the actual diff; cite `file:line`.
  - Check what's *missing* (untested path, unhandled error) — not just what's present.
  - Approve when correct and safe; don't gate on taste.
- **Review checklist** (correctness, error handling, security, tests, performance,
  readability, scope-creep, migration/rollback safety).
- **Review loop** (from open-swe's Reviewer)
  - Verdict is binary: approve, or send back to `tdd` with specific feedback.
  - On a send-back, each blocking item must be concrete enough to act on directly.
  - Re-review after the fix pass; iterate until approved. Don't approve to be nice.
- **Output template**
  - Summary verdict (approve / changes requested)
  - Blocking issues (with `file:line`)
  - Non-blocking suggestions / nits
  - Questions for the author

---

## pr

**Purpose:** Drive an already-open PR through the merge bottleneck — addressing
feedback, rebasing, resolving conflicts, keeping CI green.

SKILL.md should contain:

- **Loop**
  1. Check PR status: review comments, CI state, mergeability, branch staleness.
  2. Triage review feedback — address, push back with reasoning, or defer (say which).
  3. Make the changes as focused follow-up commits; reply to each thread.
  4. Rebase / merge `main` when behind; resolve conflicts deliberately.
  5. Re-run CI; if it fails, fix (consider invoking the CI side of `testing`).
  6. Re-request review; repeat until merged.
- **Rules**
  - Every review thread gets a resolution — fixed, answered, or explicitly deferred.
  - Resolve conflicts by understanding both sides; never blindly take one.
  - Keep the PR scope fixed — new ideas become new issues, not new commits here.
  - Don't merge with red or skipped CI, or unresolved blocking comments.
  - Keep the PR description current as the diff evolves.
- **Output template**
  - Current status (CI / reviews / conflicts)
  - Feedback items + disposition
  - Actions taken this pass
  - Blockers / what's needed to merge

---

## Open questions for you

- Keep `ci` as its own skill, or fold CI-failure triage into `testing` /
  `pr` as planned above?
- Do we want a SQLite/task-state mechanism like `skills-old/pm-agent` had, or is
  `scope` purely a thinking tool that emits markdown?
- Should `scope` write its units somewhere durable (issues, a file), or just output?
- Standardize on `file:line` citations across all read-heavy skills — agreed?
- How hard is the approval gate — a true stop-and-wait, or just "surface the plan
  prominently and continue unless told otherwise"? (A hard stop is itself an
  agent-specific capability; the framework-agnostic version is "surface and wait".)
- Confirm `AGENTS.md` as the single conventions file (it's the cross-tool
  standard — assumed throughout, flag if you disagree).
- Should any of these be marked `metadata.internal` (e.g. `recon` if it's
  scaffolding rather than a public capability)?
