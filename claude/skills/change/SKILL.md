---
name: change
description: Initialize a new change with proper branch hierarchy, change directory, and contract. Use when the user says "start change", "start a change", "new change", "begin change", or "init change" followed by a topic name.
allowed-tools: Bash, Read, Write
argument-hint: <topic>
user-invocable: true
---

# Start Change Skill

This skill initiates a new change by creating the proper branch hierarchy, change directory, and drafting the change contract.

## Trigger

User says one of:
- "start change `<topic>`"
- "start a change `<topic>`"
- "new change `<topic>`"
- "begin change `<topic>`"
- "init change `<topic>`"

Where `<topic>` is a short identifier for the change (e.g., "auth_fix", "api_update", "crdt_refactor").

**Argument**: $ARGUMENTS (the topic name)

## Prerequisites

This skill should be invoked AFTER discussing the change. The discussion should have covered:
- What the change is trying to accomplish (goal)
- What we're NOT doing (non-goals)
- Technical constraints
- General approach

## Branch Hierarchy

```
develop
  └── <developer>_<YY_MM_DD>_daily       (daily aggregation branch)
        └── <developer>_<YY_MM_DD>_<topic>  (change branch)
```

Changes merge back to the daily branch. Daily branch merges to develop at end of day.

## Instructions

When triggered, follow these steps exactly:

### Step 1: Get Developer Name

```bash
git config user.name
```

Sanitize for branch name:
- Replace spaces with underscores
- Convert to lowercase
- Remove special characters

Example: "Brooks Adcock" → "brooks_adcock"

If git config returns empty, ask the user:
> "I couldn't determine your developer name from git config. What name should I use for branch naming? (e.g., 'brooks')"

### Step 2: Generate Date

Get today's date in `YY_MM_DD` format.

Example: January 23, 2026 → "26_01_23"

### Step 3: Build Names

```
developer = "brooks"           # from Step 1
date = "26_01_23"              # from Step 2  
topic = "auth_fix"             # from user input / $ARGUMENTS

daily_branch = "brooks_26_01_23_daily"
change_branch = "brooks_26_01_23_auth_fix"
change_dir = "./changes/brooks_26_01_23_auth_fix"
```

### Step 4: Check for Dirty State

```bash
git status --porcelain
```

If there is output (uncommitted changes), STOP and report:

> **Cannot start new change: You have uncommitted changes.**
>
> Current branch: `<current_branch>`
>
> Options:
> 1. Commit your current changes first, then run "start change" again
> 2. Open a new terminal/window for parallel work
> 3. Stash changes with `git stash` (you'll need to restore later)
>
> What would you like to do?

Do NOT proceed until the working directory is clean.

### Step 5: Ensure Daily Branch Exists

Check if daily branch exists:

```bash
git show-ref --verify --quiet refs/heads/<daily_branch>
echo $?  # 0 = exists, 1 = doesn't exist
```

**If daily branch does NOT exist:**

```bash
git checkout develop
git pull origin develop
git checkout -b <daily_branch>
```

Report: "Created daily branch: `<daily_branch>`"

**If daily branch already exists:**

```bash
git checkout <daily_branch>
git pull origin <daily_branch> 2>/dev/null || true
```

Report: "Switched to existing daily branch: `<daily_branch>`"

### Step 6: Check if Change Branch Already Exists

```bash
git show-ref --verify --quiet refs/heads/<change_branch>
echo $?
```

**If change branch already exists:**

> Branch `<change_branch>` already exists.
>
> Options:
> 1. Switch to it and resume work
> 2. Choose a different topic name
>
> What would you like to do?

**If change branch does NOT exist:**

```bash
git checkout -b <change_branch>
```

Report: "Created change branch: `<change_branch>`"

### Step 7: Check if Change Directory Already Exists

```bash
ls -d <change_dir> 2>/dev/null
```

**If directory exists:**

> Change directory already exists at `<change_dir>`.
>
> Options:
> 1. Resume with existing contract (review it first)
> 2. Start fresh (will overwrite existing files)
>
> What would you like to do?

**If directory does NOT exist:**

```bash
mkdir -p <change_dir>
```

### Step 8: Create Change Documents

Check if project templates exist at `./changes/system/templates/`. If they do, copy from there. Otherwise write the files directly using the content below.

**`change_contract.json`:**
```json
{
  "branch": "<change_branch>",
  "created": "<YYYY-MM-DD>",
  "goal": "<inferred from discussion>",
  "non_goals": [],
  "constraints": [],
  "acceptance_checks": [],
  "touch_list": {
    "modify": [],
    "create": [],
    "delete": []
  },
  "invariants": []
}
```

**`decision_log.md`:**
```markdown
# Decision Log

**Branch:** `<change_branch>`
**Created:** `<YYYY-MM-DD>`

## Context

<Summary of why this change is needed, from the discussion>

## Decisions Made

<Any decisions already made during discussion>

## Assumptions

- 

## Open Questions Resolved

| Question | Answer |
|----------|--------|
| | |

## References

- 
```

**`testing_plan.md`:**
```markdown
# Testing Plan

**Branch:** `<change_branch>`
**Created:** `<YYYY-MM-DD>`

## New Tests to Write

| Test File | Test Name | Description |
|-----------|-----------|-------------|
| | | |

## Existing Tests to Verify

| Test File | Relevance |
|-----------|-----------|
| | |

## Invariant Tests

| Invariant | How Tested |
|-----------|------------|
| | |

## Edge Cases

- [ ] 
- [ ] 

## Manual Testing Checklist

- [ ] 
- [ ] 

## Test Commands

```bash
# Run your project's test suite here
```
```

Also create an empty **`notes.md`**.

**Important:** Pre-populate `change_contract.json` with `goal`, `non_goals`, `constraints`, and `acceptance_checks` inferred from the prior discussion. Leave `touch_list` and `invariants` empty — those require deliberate thought.

Pre-populate `decision_log.md` Context and any Decisions Made from the discussion.

### Step 9: Report and Prompt for Review

Display a summary:

> **Change initialized successfully!**
>
> - Branch: `<change_branch>`
> - Directory: `<change_dir>`
> - Daily branch: `<daily_branch>`
>
> **Files created:**
> - `change_contract.json` - Review and complete the touch_list
> - `decision_log.md` - Pre-populated from our discussion
> - `testing_plan.md` - Template ready for completion
> - `notes.md` - Empty, for implementation notes
>
> **Next steps:**
> 1. Review and edit `change_contract.json` — especially the touch_list
> 2. Complete `testing_plan.md`
> 3. When ready, say "preflight check" to verify everything before coding

Read the `change_contract.json` file so it appears in context for review.

## Error Handling

| Error | Response |
|-------|----------|
| Not in a git repository | "Error: Not in a git repository. Navigate to the project root and try again." |
| Cannot determine developer name | Ask user to provide it |
| develop branch doesn't exist | "Error: 'develop' branch not found. What base branch should I use?" |
| Permission denied | "Error: Permission denied. Check file/directory permissions." |
| Network error on pull | Warn but continue (offline work is fine) |

## Notes

- The pre-populated contract is a draft — user MUST review before proceeding
- touch_list is intentionally left sparse — determining allowed files requires thought
- After this skill completes, the workflow continues with preflight check, then planning
- The change directory docs are **living documents** — keep them current throughout the change lifecycle, not just at creation
- The `/rtfc` command reads these four files at the start of any new session on this change
