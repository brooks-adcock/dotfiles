You are running a Build session. Your job is to gather context, spawn a clean subagent to execute one step, and report the result. You do not execute the step yourself — the agent does, starting with zero conversation history.

---

## Phase 1 — Gather context (you do this, not the agent)

Run as separate Bash calls (never chain with &&):

1. `cat docs/plan.md` — find the first step with Status 🔲
2. `cat docs/architecture.md`
3. `cat docs/status.md`
4. Read every file listed in the step's `Files:` field

Stop conditions:
- No `docs/plan.md` → tell user to run `/groom` first
- All steps ✅ → tell user the plan is complete
- A step's `Depends on` lists a step that is not ✅ → report the unmet dependency and stop

---

## Phase 2 — Spawn the agent

Tell the user: **"Spawning agent for Step N — [Name]"**

Use the Agent tool (general-purpose) with a fully self-contained prompt. The agent has no access to this conversation — everything it needs must be in the prompt. Build the prompt by substituting the `{{...}}` placeholders with the actual content you read above.

### Agent prompt template

```
You are executing one build step. All context is below. Do not read any files not listed here unless the step's test criteria require running a command that discovers output files.

---

## Project architecture

{{full content of docs/architecture.md}}

---

## Build plan

{{full content of docs/plan.md}}

---

## Project status

{{full content of docs/status.md}}

---

## Current file contents

{{for each file in the step's Files field, output:
### path/to/file.ext
<current file content>
}}

---

## Your step: Step N — [Name]

Read the step fields above carefully:
- **What** — the single change you are making
- **Why** — the goal this serves
- **Files** — the only files you may create or modify
- **Test criteria** — what must pass before you mark it done
- **Depends on** — already confirmed ✅ by the caller

## Execution rules

**Touch list is a hard contract.** If you discover mid-implementation that you need a file not in `Files:`, stop. Do not touch it. Report what you found and what is needed (see Blocked below).

**Stay in scope.** No related improvements, no refactoring adjacent code, no implementing the next step. If you notice something worth fixing nearby, record it in your build log entry in `docs/status.md` and move on — do not fix it now.

**Project structure.** All source code lives in `[component]/code/`. Full paths from project root only.

**Read before write.** The file contents are provided above, but if a file will be modified read it again via the Read tool immediately before editing to catch any drift.

## Verify

Before marking done, verify every test criterion in the step:
- Run relevant tests if a test suite exists
- Check each condition explicitly — do not substitute "looks right" for a listed criterion
- If a criterion cannot be verified automatically, state exactly what you checked and why you are confident it passes

Do not mark ✅ if any criterion is unmet.

## Update docs

Once all criteria pass:

**1. Mark the step complete in `docs/plan.md`:**
Change `**Status:** 🔲` to `**Status:** ✅`

**2. Append to `docs/status.md`:**
## Step N — [Name] — [date]
- [What was built, in one or two specific sentences]
- [Any non-obvious decision made during implementation]
- [Test results — what was run, what passed]

Do not pad. One line is fine if the implementation was straightforward.

**3. If anything non-obvious happened**, append to `docs/decisions.md`:
- A bug found and fixed (root cause, not just symptom)
- A choice made between two viable approaches
- An unexpected constraint discovered in the existing code

## Blocked

If you cannot complete the step cleanly, stop and report:

> "Blocked on Step N — [Name]"
>
> **What I found:** [specific description]
> **What is needed:** [what must be resolved first]
> **Suggested action:** [re-groom this step / fix dependency N first / ask user about X]

Leave status as 🔲. Do not partially implement and mark done.

## Finish

Return a summary containing:
- Step completed or blocked
- What was built (one sentence)
- Test results
- Next step name and number only
```

---

## Phase 3 — Report to the user

Relay the agent's summary:
- Step completed or blocked
- What was built
- Test results
- Next step name and number only — do not start it
