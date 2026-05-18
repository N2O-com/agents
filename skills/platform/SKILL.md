---
name: platform
description: Conventions for the N2O platform monorepo — stack, commands, quality gates, testing. Load this before doing any work in the platform repo so every other skill inherits the repo's conventions. Triggers — working in platform, platform repo conventions, what commands does this repo use, how do I test here, AGENTS.md.
---

# Platform

Conventions for the `platform` repo. The workflow skills (`scope`, `recon`,
`research`, `tdd`, `testing`, `review`, `pr`) all assume this file. `recon`
reconciles documented conventions against observed ones and flags drift.

## When to Use

Load this at the start of any task in the `platform` repo, before `recon` or
`scope`. It is the repo's `AGENTS.md` — concrete commands and gates the other,
framework-agnostic skills defer to.

## What this is

`platform` — a production Turborepo monorepo. End-to-end TypeScript, ESM
(`"type": "module"`), pnpm 10, Node 18+.

```
apps/
  app/   Next.js 16 authenticated application (port 3000)
  web/   Next.js marketing site (port 3001)
packages/
  ai analytics auth database design email internationalization
  next-config observability realtime seo storage typescript-config
  vitest webhooks
```

Workspace packages are imported as `@repo/<name>`.

## Stack

- **Framework:** Next.js 16, React 19.
- **Auth:** Better Auth (`@repo/auth`).
- **Data:** Kysely query builder over Postgres (Neon / Planetscale), `@repo/database`.
- **Client state / data fetching:** TanStack Query; `ra-core` + `react-router-dom` in `app`.
- **Forms:** react-hook-form + Zod (`@hookform/resolvers`).
- **UI:** shadcn/ui in `@repo/design`; Tailwind v4.
- **Other:** Resend (email), Ably (realtime), PostHog/GA (analytics), S3/R2 (storage).

## Commands

Run from the repo root unless noted. Turbo scopes work to affected packages.

- `pnpm dev` — all apps; `pnpm dev:mock` — `app` with MSW request mocking.
- `pnpm build` — build everything. **`build` depends on `test`** (see `turbo.json`),
  so a build is also a test run.
- `pnpm test` — Vitest across all packages. Single package: `pnpm --filter <pkg> test`.
- `pnpm typecheck` — type-check the workspace.
- `pnpm check` / `pnpm fix` — lint via Ultracite (Biome). `fix` auto-applies.
- `pnpm knip` — dead-code / unused-dependency report.
- `pnpm syncpack` / `pnpm syncpack:fix` — keep dependency versions consistent across packages.
- DB: `pnpm --filter app migrate:dev` (`:up` / `:down` / `:status`), `seed:dev`.
  Migrations and seeds live in `apps/app/lib/db/`.

## Quality gates

Enforced by lefthook (`lefthook.yml`); bypass only with `--no-verify` and a reason.

- **pre-commit (blocking):** no merge-conflict markers; `turbo typecheck` on
  packages affected since HEAD.
- **pre-commit (non-blocking):** `ultracite fix` auto-fixes and re-stages;
  Biome warnings surface but do not block.
- **pre-push (blocking):** `turbo build --affected` and `turbo test --affected`.

**Definition of done** for any unit of work: typecheck clean, `pnpm test`
green, `pnpm check` clean. Don't commit with these red.

## Testing

- Vitest 3 is the runner. Shared config and MSW setup live in `@repo/vitest`
  (`packages/vitest/`) — extend it, don't hand-roll per package.
- Component tests use Testing Library + jsdom.
- **Network is mocked with MSW**, never hit live. App-level handlers live in
  `apps/app/mocks/`; `dev:mock` runs the app against them.
- Co-locate tests with the code; mirror existing `__tests__` / `*.test.ts` usage
  in the target package.
- Every fixed bug leaves a regression test behind.

## Conventions

- TypeScript everywhere; no new plain `.js`. ESM imports.
- Ultracite/Biome owns formatting and lint — never hand-format; run `pnpm fix`.
- Env vars are **per-app** `.env.local` files (not committed); root `.env.local`
  holds only DB migration admin credentials. Any new runtime var must also be
  declared in the relevant `turbo.json` task `env` list (strict mode — an
  undeclared var is unavailable and breaks the build). See `env.md`.
- Shared logic belongs in a `@repo/*` package, not copied between apps.
- `recon` cites findings as `file:line`.

## Workflow

Work flows: `recon`/`research` → `scope` → [plan approval] → `tdd` ⇄ `testing`
→ `review` → `pr`. The approval gate after `scope` is a real stop — present the
unit breakdown and wait before writing code. See `SKILLS-PLAN.md` for the full design.
