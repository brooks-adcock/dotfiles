Start a new in-flight change: create the branch, scaffold the change docs, then discuss the change before any implementation begins.

---

## Phase 1 — Orient and prepare base

Run these as separate Bash calls (never chain with &&):

1. `git branch --show-current` — note the current branch
2. `git status --short` — check for uncommitted changes
3. `ls changes/ 2>/dev/null` — see what changes already exist

**If the working tree is dirty:** run `git stash push -m "pre-change stash"` to stash changes, then tell the user what was stashed.

**Detect the base branch:**
Run `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'`. If that returns nothing, check which of `main`, `master`, `dev`, `develop` exists locally and use the first match.

**Update the base branch:**
1. `git checkout <base_branch>`
2. `git pull origin <base_branch>`

Tell the user: **"Branching from `<base_branch>` at `<short sha>`."**

---

## Phase 2 — Create the branch

Ask the user: **"What should the branch be called?"**

Then:

1. `git checkout -b <branch_name>` — create and switch to the branch from the updated base
2. `mkdir -p changes/<branch_name>` — create the change directory

Scaffold the four files:

**`changes/<branch_name>/change_contract.json`**
```json
{
  "goal": "",
  "non_goals": [],
  "constraints": [],
  "acceptance_checks": [],
  "touch_list": {
    "create": [],
    "modify": [],
    "delete": []
  }
}
```

**`changes/<branch_name>/decision_log.md`**
```markdown
# Decision Log — <branch_name>

Newest entries at the top. Record every non-trivial choice: what was tried, what failed, what worked.
```

**`changes/<branch_name>/testing_plan.md`**
```markdown
# Testing Plan — <branch_name>

| Test | Type | Status |
|------|------|--------|
```

**`changes/<branch_name>/notes.md`**
```markdown
# Notes — <branch_name>

## What's done
—

## What's next
—

## Gotchas
—

## Open questions
—
```

Tell the user: **"Branch `<branch_name>` created. Change docs scaffolded at `changes/<branch_name>/`. Let's define the contract before we touch any code."**

---

## Phase 3 — Define the contract

Ask one question at a time. After each answer, update `change_contract.json` immediately before asking the next.

**Q1 — Goal**
> "In one sentence: what does this change accomplish?"

Write the answer into `goal`.

**Q2 — Non-goals**
> "What is explicitly out of scope — things that are related but should NOT be touched in this change?"

Write answers into `non_goals` as an array of strings.

**Q3 — Constraints**
> "Any hard constraints? (e.g. must stay backwards compatible, must not touch the auth flow, must finish in a single PR)"

Write into `constraints`. If none, leave `[]`.

**Q4 — Touch list**
> "Which files do you expect to create, modify, or delete? Best guess is fine — we'll keep this in sync as work progresses."

Populate `touch_list.create`, `touch_list.modify`, `touch_list.delete` with full paths from project root.

**Q5 — Acceptance checks**
> "How will we know this change is done? List the specific conditions that must be true before we ship."

Write into `acceptance_checks` as an array of strings.

---

## Phase 4 — Confirm and hand off

Show the user the final `change_contract.json` and ask:

> "Does this look right? Once you confirm, run /rtfc at the start of any session to load this contract, and /change_docs to keep it up to date as work progresses."

Do not start implementing. Do not suggest what to build next. The contract is the output of this skill — implementation begins when the user is ready.
