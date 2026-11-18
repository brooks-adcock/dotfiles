---
name: change
description: Initialize a new change with a change branch, change directory, and contract. Use when the user says "start change", "start a change", "new change", "begin change", or "init change" followed by a topic name.
allowed-tools: Bash, Read, Write
argument-hint: <topic>
user-invocable: true
---

# Start Change Skill

This skill initiates a new change by creating the change branch, change directory, and drafting the change contract.

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
<base>
  └── <YY_MM_DD>_<topic>
```

`<base>` is `develop` when that branch exists. The change branch merges to `<base>`. Do not create a daily branch. Do not put a person's name on the branch.

## Instructions

When triggered, follow these steps exactly:

### Step 1: Generate Date

Get today's date in `YY_MM_DD` format.

Example: January 23, 2026 → "26_01_23"

### Step 2: Build Names

```
date = "26_01_23"              # from Step 1
topic = "auth_fix"             # from user input / $ARGUMENTS

change_branch = "26_01_23_auth_fix"
change_dir = "./changes/26_01_23_auth_fix"
```

### Step 3: Check for Dirty State

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

### Step 4: Update the Base Branch

```bash
git checkout develop
git pull origin develop
```

If `develop` does not exist, ask which base branch to use, then checkout and pull that branch.

Report: "Branching from `<base>` at `<short sha>`."

### Step 5: Check if Change Branch Already Exists

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

### Step 6: Check if Change Directory Already Exists

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

### Step 7: Create Change Documents

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

### Step 8: Report and Prompt for Review

Display a summary:

> **Change initialized successfully!**
>
> - Branch: `<change_branch>`
> - Directory: `<change_dir>`
> - Base: `<base>`
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
| develop branch doesn't exist | "Error: 'develop' branch not found. What base branch should I use?" |
| Permission denied | "Error: Permission denied. Check file/directory permissions." |
| Network error on pull | Warn but continue (offline work is fine) |

## Notes

- The pre-populated contract is a draft — user MUST review before proceeding
- touch_list is intentionally left sparse — determining allowed files requires thought
- After this skill completes, the workflow continues with preflight check, then planning
- The change directory docs are **living documents** — keep them current throughout the change lifecycle, not just at creation
- The `/rtfc` command reads these four files at the start of any new session on this change
