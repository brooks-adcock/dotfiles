# dotfiles

Claude Code skills and settings, tracked in version control and symlinked into `~/.claude`.

## What this is

A set of slash commands (skills) for [Claude Code](https://claude.ai/code) that cover the full software development lifecycle — from writing requirements through building, testing, reviewing, and shipping.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and working (`claude` in your terminal)
- Git

## Install

```bash
git clone git@github.com:brooks-adcock/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

This symlinks four things into `~/.claude`:

| Symlink | Source |
|---------|--------|
| `~/.claude/commands` | `~/dotfiles/claude/commands` |
| `~/.claude/skills` | `~/dotfiles/claude/skills` |
| `~/.claude/settings.json` | `~/dotfiles/claude/settings.json` |
| `~/.claude/preferences.md` | `~/dotfiles/claude/preferences.md` |

Any existing files are backed up to `*.bak` before being replaced.

## Set up your machine context

Claude Code reads `~/.claude/CLAUDE.md` as background context — this is where you describe your machine, your stack, and any conventions Claude should always know.

This file is **not** tracked in the repo (it's machine-specific). Create it yourself:

```bash
nano ~/.claude/CLAUDE.md
```

A minimal example:

```markdown
# My Machine

MacBook Pro, macOS. Main languages: Python, TypeScript.
Projects live in ~/Projects.

@~/.claude/preferences.md
```

The last line (`@~/.claude/preferences.md`) imports the shared preferences from this repo. Keep it.

Add whatever context is useful: your stack, your coding conventions, services you run locally, things Claude should never do.

## Skills

### Feature development pipeline

| Skill | What it does |
|-------|-------------|
| `/prd` | Interview-driven product requirements doc |
| `/groom` | Turns the PRD into an architecture doc + ordered build plan |
| `/build` | Executes the next step in the plan via a clean subagent |
| `/review` | Reviews the branch against the PRD, plan, and code quality |
| `/status` | One-glance snapshot of plan progress and uncommitted changes |
| `/test` | Runs all test suites; proposes fixes, never applies them |

Typical flow: `/prd` → `/groom` → `/build` (repeat) → `/test` → `/review` → `/commit`

### Change workflow (branch-scoped)

| Skill | What it does |
|-------|-------------|
| `/change` | Creates a branch, scaffolds a change contract, interviews you before any code |
| `/rtfc` | Loads the change contract at the start of a session |
| `/change_docs` | Updates the contract, decision log, and notes after progress |
| `/change_wrap` | Tests → commit → push → open PR |

Typical flow: `/change` → work → `/rtfc` (each session) → `/change_docs` → `/change_wrap`

### Utilities

| Skill | What it does |
|-------|-------------|
| `/rtfm` | Reads all project docs before starting work |
| `/docs` | Updates `docs/architecture.md`, `docs/decisions.md`, `docs/status.md` |
| `/commit` | Updates docs, audits .gitignore, stages, and commits |
| `/hotreload` | Bumps a stuck dev server |

## Keeping skills up to date

Since `~/.claude/commands` is a symlink, any `git pull` in `~/dotfiles` instantly updates your skills — no re-install needed.

```bash
cd ~/dotfiles && git pull
```
