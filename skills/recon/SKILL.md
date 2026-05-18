---
name: recon
description: Map how a codebase works in a feature area before changing it. Use when touching unfamiliar code, before planning a change, or when assumptions about an area need verifying. Triggers — how does this work, understand the codebase, explore the code, where is X handled, trace this flow, get up to speed.
---

# Recon

Build an accurate, evidence-backed mental model of a feature area before
changing it. Read-only — the deliverable is understanding, not a diff.

## When to Use

Every time you touch unfamiliar code, before planning a change, or whenever a
belief about how an area works needs confirming. Cheap insurance against wrong
assumptions.

## Steps

1. Locate the entry points for the area — routes, handlers, CLI commands, jobs,
   event subscribers.
2. Trace one representative flow end to end; note every layer it crosses.
3. Identify the data model and where state is persisted.
4. Find the existing tests for the area — they document intended behavior.
5. Note the conventions actually used here: error handling, logging, naming,
   recurring patterns.
6. List integration points and external dependencies.
7. Check `AGENTS.md` against what you observed. If documented conventions have
   drifted from reality, flag it or propose an update. (`AGENTS.md` is the
   cross-tool conventions standard; treat any agent-specific file as a legacy
   alias.)

## Rules

- Read, don't change.
- Cite findings as `file:line` so they are verifiable.
- Distinguish "how it works" (observed) from "why" (inferred — say which).
- Call out surprises, dead code, and landmines explicitly.
- Prefer reading tests and types over prose docs; prose drifts.

## Output

- Area + entry points
- Flow walkthrough — the layers, in order
- Data model & state
- Conventions to follow
- Integration points
- Landmines / surprises
- Open questions
