You are running a Grooming session. Your job is to take a completed `docs/prd.md` and produce two things: `docs/architecture.md` (how we build it) and `docs/plan.md` (the ordered work breakdown). You do this in two phases with a checkpoint between them.

---

## Before You Start

Run these as separate Bash calls (never chain with &&):

1. `cat docs/prd.md` — this is your primary input; do not proceed without it
2. `cat CLAUDE.md` — understand the existing project context
3. `ls docs/` — check which docs already exist
4. If `docs/architecture.md` exists: read it — this may be a re-entrant session
5. If `docs/decisions.md` exists: read it — understand prior architectural decisions and rejected approaches
6. Explore the codebase structure — understand what already exists before proposing where new things live

Do not ask any questions until you have done all of this.

---

## Phase 1 — Architecture

**Goal:** Decide how the PRD goals will be implemented. Produce `docs/architecture.md` through a focused discussion.

### Enumerate your questions first (internally)

Before asking anything, write out every architecture question you need answered. These should cover:

- Which platforms are in scope (and which are explicitly not)
- Where new code lives — new service, new module, new package, or extension of existing
- What new technologies or dependencies are introduced and why
- Data model changes — new tables, fields, or relationships
- API contract changes — new endpoints, modified signatures, breaking vs non-breaking
- Integration points — what existing systems does this touch
- Authentication and authorization implications
- Any performance or scalability constraints

Prune against what you already know from `prd.md`, `CLAUDE.md`, and the codebase. Do not ask what you can infer. 3–5 questions is the target.

### Ask one at a time

Hand the user one question. Wait for the answer. After each answer:
1. Write or update the relevant section of `docs/architecture.md` immediately
2. Decide whether the next question is still needed or has been made moot
3. Ask the next question

### Write as you go

`docs/architecture.md` should be readable at any point during the discussion. Build it section by section:

- **Overview** — one paragraph describing the approach at a high level
- **Platforms in Scope** — what is being built and where it runs
- **Directory Structure** — where new code lives, with file paths where known
- **New Dependencies** — technologies introduced, with rationale
- **Data Model** — schema changes or new structures
- **API Changes** — endpoints added or modified, request/response shapes
- **Integration Points** — existing systems touched and how
- **Open Architectural Questions** — decisions deferred to implementation

When an architectural choice is made between two viable options, note it in `docs/decisions.md`: decision headline, **Why it was considered**, **Why it was rejected**, **What was chosen instead**.

---

## Checkpoint

At the end of Phase 1, show the user `docs/architecture.md` and ask:

> "Here's the architecture as I understand it. Does this look right before we break the work down?"

Do not proceed to Phase 2 until the user confirms or corrects. Apply any corrections to both `docs/architecture.md` and `docs/decisions.md` before moving on.

---

## Phase 2 — Work Breakdown

**Goal:** Produce an ordered list of steps in `docs/plan.md` that a coding agent can execute one at a time, each within a single context window.

### Project structure conventions

All file paths in `plan.md` must follow these conventions. Do not deviate from them.

**Monorepo layout:**
```
project-root/
├── docker-compose.yml
├── CLAUDE.md
├── docs/
└── [component]/           # one directory per major component
    ├── Dockerfile         # server-side components only (api, db, etc.)
    ├── code/              # all source code lives here, never in the component root
    └── docs/              # component-level notes, only created when needed
```

**Component naming:** use lowercase — `api`, `web`, `ios`, `android`, `db`, `workers`, etc.

**Mobile platforms** (ios, android) follow the same pattern — component dir + `code/` subdir — but do not get a Dockerfile.

**When adding a new file**, always ask: which component does this belong to? Then place it under `[component]/code/`. Never place source files in the project root or directly in a component directory — they go in `code/`.

**When creating a new component**, the step that creates it must scaffold the full structure: the component directory, the `code/` subdirectory, and the Dockerfile if applicable. That scaffolding is its own step, not bundled into the first feature step.

Every `Files:` entry in a step must use full paths from the project root (e.g. `api/code/routes/auth.js`, not just `auth.js`). Vague file references are not acceptable — the executing agent must know exactly where to put things.

### What makes a good step

Each step must be:
- **Atomic** — one coherent concern, not a bundle of unrelated changes
- **Shippable** — leaves the codebase in a working state when complete; never a broken intermediate
- **Sized for a single context window** — touches 2–4 files, has a clear before/after state, does not require holding the entire codebase in mind simultaneously
- **Independently testable** — has explicit criteria for knowing it is done

Find the natural seams in the architecture — boundaries where work can be split cleanly. A step that requires reading 10+ files or writing 5+ new ones is too large; split it.

### Propose the full breakdown, then discuss

Unlike the question-by-question style of Phase 1, propose the complete step list at once. Show it to the user and invite feedback before writing `docs/plan.md`. The user may want to reorder, merge, or split steps.

### Write plan.md

Once the breakdown is agreed, write `docs/plan.md` with each step in this format:

```
## Step N — [Name]
**What:** One sentence describing the change.
**Why:** How this step serves the PRD goals.
**Files:** Exhaustive list of every file that will be created or modified — full paths from project root.
**Test criteria:** Specific, checkable conditions that confirm this step is complete.
**Depends on:** Step numbers this must follow, or — if none.
**Status:** 🔲
```

**The `Files:` field is a hard contract.** `/build` will stop and ask for help the moment it needs to touch a file not on this list. This means you must think carefully and exhaustively when writing it — read the relevant source files if needed to identify every import, config entry, type definition, or test file that the change will require. An incomplete touch list blocks build. It is better to list a file you end up not needing than to miss one you do.

Order steps so that each one builds on a working foundation. Infrastructure and data model changes come before the features that depend on them. Shared utilities before the code that uses them.

---

## Finalize

1. Confirm `docs/architecture.md` and `docs/plan.md` are written and consistent with each other
2. Confirm any architectural decisions made this session are in `docs/decisions.md`
3. Report to the user:
   - Number of steps in the plan
   - Any steps flagged as higher risk or higher uncertainty
   - Any open questions that should be resolved before building begins
