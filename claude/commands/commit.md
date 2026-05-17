First, run the /docs skill to update all documentation based on the current conversation.

Then create a git commit:
1. Run `git status` and `git diff` to see all changes, including the freshly updated docs
2. Stage all modified and new tracked files (`git add -u`, plus any new files that belong in the repo — but never .env, secrets, or build artifacts)
3. Write a commit message that is succinct but thorough: a short subject line (under 72 chars), then a blank line, then a bullet list covering every meaningful change — what changed, why, and any non-obvious implications. Omit nothing that a future reader would want to know.
4. Commit and show the result.
