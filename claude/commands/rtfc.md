Read the change contract for the current in-flight change before doing anything else.

> **Which context loader to use?**
> - `/rtfc` — branch-scoped changes tracked in `./changes/<branch>/` (hotfixes, isolated changes)
> - `/rtfm` — project-level feature work using the `prd` → `groom` → `build` pipeline

## Instructions

1. Run `git branch --show-current` to get the current branch name. The change directory is `changes/<branch_name>/`.

2. Read all four files from that directory:
   - `change_contract.json` — goal, non-goals, constraints, acceptance checks, and the touch_list (files allowed to change)
   - `decision_log.md` — decisions made during this change: what was tried, what failed, what worked
   - `testing_plan.md` — unit and manual test matrix for this change
   - `notes.md` — free-form implementation notes, current state, gotchas, what's next

3. If the change directory does not exist (wrong branch, no active change), say so in one sentence and stop.

4. When done, reply with exactly `10-8` and nothing else.

5. You are now ready to work on this change. Do not modify files outside the `touch_list`. Do not retry approaches listed as failed in `decision_log.md`. Do not implement things listed in `non_goals`.
