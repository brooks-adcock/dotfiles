Wrap up an in-flight change: run tests, validate the touch list, commit with updated docs, and open a pull request.

---

## Phase 1 — Run tests

Run the `/test` skill.

**If any tests fail:** stop. Report the failures and do not proceed. Tell the user: "Fix the failures above before wrapping — re-run /change_wrap when ready."

**If all tests pass:** proceed to Phase 2.

---

## Phase 2 — Validate touch list

Run:
```
python3 changes/system/validate_touch_list.py
```

**If exit code 1 (undeclared files):** stop. Show the output. Tell the user: "These files were changed but are not in the touch_list. Either update the touch_list via /change_docs or revert the unintended changes."

**If exit code 2 (setup error):** stop. Show the output and ask the user to resolve it.

**WARN lines are informational** — declared files not yet touched are fine (they may be deferred or deleted). Do not block on warnings.

**If exit code 0:** proceed to Phase 3.

---

## Phase 3 — Commit

Run the `/commit` skill. It will detect the `changes/<branch_name>/` directory and call `/change_docs` automatically before staging and committing.

---

## Phase 4 — Open a pull request

1. Run `git branch --show-current` to confirm the branch
2. Run `git push -u origin <branch_name>` to push if not already pushed
3. Read `changes/<branch_name>/change_contract.json` to pull the PR title and summary from the contract

Construct the PR:
- **Title:** the `goal` field from `change_contract.json` (trim to under 70 chars if needed)
- **Body:** derive from the contract fields:

```
## What
<goal>

## Why
<one sentence on the motivation — infer from goal + acceptance_checks if not explicit>

## Changes
<touch_list: create/modify/delete as bullet points — omit empty categories>

## Acceptance checks
<acceptance_checks as a markdown checklist>

## Test plan
<summarize what /test ran and that it passed>

🤖 Generated with Claude Code
```

4. Run `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"` using a HEREDOC

Report the PR URL to the user when done.
