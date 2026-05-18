Update the project documentation in `./docs/`. This documentation exists specifically for AI agents to get up to context quickly, make forward progress, and not repeat mistakes.

## Documentation Files

Maintain these three files in `./docs/`:

### 1. `architecture.md` — What IS (current state of the system)
- How the system works right now
- Directory structure with purpose of each directory/key file
- Tech stack with versions and why each was chosen
- Data model with field descriptions
- Key behaviors and flows
- How to run, build, and develop
- Direct database access commands

### 2. `decisions.md` — What was tried and why (ADR-style log)
- Newest entries at the top (most recent context first)
- Each entry follows this format:

```
## YYYY-MM-DD — [Short title]

**Context:** What situation prompted this decision
**Options considered:**
- Option A — [tradeoffs]
- Option B — [tradeoffs]
**Decision:** What was chosen and why
**What didn't work:** Specific failures, error messages, dead ends encountered
**Consequences:** What follows from this decision (good and bad)
```

- This is the HIGHEST VALUE file — it prevents agents from repeating mistakes
- Include specific error messages when something failed (e.g., "Turbopack can't resolve imports outside project root")
- Include the exact thing that DID work after failures (e.g., "moving generated client to src/ fixed it")

### 3. `status.md` — What's done, in progress, and next
- **Done** — completed features with brief description
- **In Progress** — what's actively being worked on
- **Next** — prioritized list of what to build next
- **Known Issues** — bugs, tech debt, things that need fixing
- **Not Doing** — things explicitly decided against (and why) so agents don't suggest them

## Writing Guidelines

Follow these principles — the audience is an AI agent, not a human reader:

1. **Write for someone who just walked in** — no assumed context. File paths are explicit, names are specific, acronyms are defined on first use.
2. **Lead with what's true now** — architecture.md reflects current reality, not aspirations or history. History goes in decisions.md.
3. **Include what DOESN'T work** — "We tried X, it failed because Y" saves more time than any other documentation. Always capture dead ends.
4. **Keep it scannable** — use headers, tables, short bullets, code blocks. Agents skim just like people do.
5. **Date everything in decisions.md** — so an agent can judge if context is stale vs. load-bearing.
6. **Separate current state from aspirational state** — architecture.md = what IS, status.md = what WILL BE.
7. **Be specific** — say `ui/src/lib/prisma.ts` not "the prisma config". Say `PrismaBetterSqlite3` (lowercase qlite) not "the adapter". Exact names prevent wrong guesses.
8. **Include runnable commands** — if an agent needs to do something (migrate, build, query), give them the exact command.

## Process

1. **Read the current docs** — read all files in `./docs/` to understand what's already documented.
2. **Check recent git history** — run `git log --oneline -20` and `git diff HEAD~1 --stat` (or more if needed) to see what changed recently.
3. **Scan the codebase** — check directory structure, key config files, and any new or modified source files.
4. **Update each doc file:**
   - `architecture.md` — make it match current reality. Remove anything that's no longer true. Add anything new.
   - `decisions.md` — add new entries for any decisions made since last update. Don't modify old entries unless they're factually wrong.
   - `status.md` — move completed items to Done, update In Progress, reprioritize Next based on current state.
5. **Don't over-document** — if something is obvious from the code, don't explain it. Focus on the WHY, the gotchas, and the things that would waste an agent's time to rediscover.
6. **Remove stale content** — outdated docs are worse than no docs. If something changed, update or delete the old version.
