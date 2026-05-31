Update the change contract docs for the current in-flight change. These files are the source of truth for AI agents working on this change — the same way `./docs/` is the source of truth for the overall project.

## Change Document Files

Located at `./changes/<branch_name>/`:

### 1. `change_contract.json` — The contract (rarely changes after init)
- `goal` — one-sentence purpose of this change
- `non_goals` — explicit out-of-scope items; add any newly-identified out-of-scope work here
- `constraints` — must-hold invariants; add any constraints discovered during implementation
- `acceptance_checks` — the checklist for "done"; add checks for anything added mid-change
- `touch_list.create / modify / delete` — **keep this in sync with the actual diff**

### 2. `decision_log.md` — What was tried and why (newest entry first)
Each entry:
```
## YYYY-MM-DD — [Short title]

**Context:** What prompted the decision
**Options considered:**
- Option A — tradeoffs
- Option B — tradeoffs
**Decision:** What was chosen and why
**What didn't work:** Specific failures, error messages, dead ends
**Consequences:** What follows from this (good and bad)
```
- This is the highest-value file — it prevents the next agent from repeating your dead ends
- Every non-trivial implementation choice belongs here
- Include exact error messages when something failed

### 3. `testing_plan.md` — Test coverage matrix
- Add rows for every new test written or planned
- Mark tests as written (✓) vs planned once they exist
- Note manual test steps for anything not covered by unit tests

### 4. `notes.md` — Current implementation state (living document)
- **What's done** — completed pieces with brief description
- **What's next** — immediate next steps (ordered)
- **Gotchas** — surprises discovered during implementation; traps for the next agent
- **Open questions** — unresolved design or behavior questions

## Process

1. **Identify the current change** — run `git rev-parse --abbrev-ref HEAD` to get the branch name. The change dir is `./changes/<branch_name>/`. If no change dir exists, stop and tell the user.

2. **Read all current change files** — understand what's already captured before writing anything.

3. **Check recent work** — run `git log --oneline -10` and `git diff HEAD~1 --stat` to see what's changed since the last doc update.

4. **Update each file:**
   - `change_contract.json` — sync `touch_list` to match the actual diff; add acceptance checks for anything new; add new non-goals for scope that was explicitly rejected
   - `decision_log.md` — prepend entries for every decision made since last update; don't modify existing entries unless factually wrong
   - `testing_plan.md` — add rows for new tests written or identified; mark written tests ✓
   - `notes.md` — rewrite "What's done" and "What's next" to reflect current state; append to "Gotchas" if anything new surfaced

5. **Validate touch_list** — run `python3 ~/.claude/templates/validate_touch_list.py` and fix any mismatches before finishing.

## Writing Guidelines

- Write for an AI agent who just ran `/rtfc` and is about to pick up the work
- Be specific: `src/components/calendar.tsx:142` not "the calendar file"
- Capture dead ends even if embarrassing — they save the next agent hours
- Keep `notes.md` lean: it should be a status snapshot, not a transcript
- Don't document what the code already makes obvious — focus on the WHY and the gotchas
