Commit the current work with updated documentation and clean gitignore files.

## Step 1: Update documentation

Detect which workflow is active:

1. Run `git branch --show-current` to get the branch name
2. Check if `changes/<branch_name>/` exists

**If `changes/<branch_name>/` exists** — run the `/change_docs` skill to update the change contract, decision log, testing plan, and notes before committing.

**Otherwise** — run the `/docs` skill to update `./docs/architecture.md`, `./docs/decisions.md`, and `./docs/status.md`. If `docs/plan.md` exists, `/docs` will derive "In Progress" and "Next" from it — no separate plan update needed.

## Step 2: Audit .gitignore files

Check that nothing sensitive or generated will be committed:

1. Run `find . -name ".gitignore" | grep -v node_modules | grep -v .git` and read each file found
2. Run `git status` to see what's untracked/modified
3. Look for anything that should NOT be committed:
   - `.env` files, credentials, secrets, API keys
   - `node_modules/`, `.next/`, generated directories
   - Database files (`*.db`, `*.db-journal`, `*.db-wal`)
   - OS junk (`.DS_Store`, `Thumbs.db`)
   - PID files, lock files
   - Large binaries or build artifacts
4. If any `.gitignore` file is missing coverage, fix it BEFORE staging

## Step 3: Stage files

1. Run `git status` to see all changes
2. Run `git diff` to review what changed (both staged and unstaged)
3. Stage files by name — do NOT use `git add -A` or `git add .`
4. Verify with `git status` that only intended files are staged

## Step 4: Write and execute the commit

1. Run `git log --oneline -5` to see recent commit message style
2. Analyze ALL staged changes to understand what was done
3. Write the commit message following this structure:

```
<concise summary in imperative mood, under 72 chars>

<what was done and WHY, organized by concern>

<specific decisions made, if any>

<things that were tried and didn't work, if significant>

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

4. Commit immediately — do not ask for confirmation
5. Run `git status` after to verify clean tree

## Rules

- **Auto-commit** — do not ask the user for confirmation, just commit
- **Do not push** — never push to remote unless explicitly asked
- **No compound cd commands** — NEVER use `cd /path && git ...` as a single command. Either use absolute paths, `git -C /path`, or run cd as a completely separate Bash call. Compound cd commands trigger permission prompts.
- **Stage by name** — always `git add file1 file2 file3`, never `git add -A` or `git add .`
- **Use HEREDOC for commit messages** — pass the message via `cat <<'EOF'` to preserve formatting
- **No empty commits** — if there are no changes, say so and stop
