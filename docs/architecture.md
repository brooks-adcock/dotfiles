# Architecture

Claude Code skills, commands, templates, and settings — tracked in version control and symlinked into `~/.claude`.

## What this is

A dotfiles repo for Claude Code. `install.sh` creates symlinks so `~/dotfiles/claude/` drives `~/.claude/`. Skills and commands are updated via `git pull` — no re-install required.

## Directory structure

```
dotfiles/
├── install.sh                    # Symlinks claude/ into ~/.claude
├── README.md
└── claude/
    ├── settings.json             # Shared Claude Code settings (skipDangerousModePermissionPrompt: true)
    ├── preferences.md            # Shared user preferences (@-imported by per-machine CLAUDE.md)
    ├── commands/                 # Slash commands — each .md file = one /command
    │   ├── build.md              # Execute next plan step via clean subagent
    │   ├── change.md             # Start a new change (branch + contract)
    │   ├── change_docs.md        # Update change contract docs mid-work
    │   ├── change_wrap.md        # Test → validate → commit → push → PR
    │   ├── commit.md             # Update docs, audit .gitignore, commit
    │   ├── docs.md               # Update docs/architecture|decisions|status.md
    │   ├── groom.md              # Turn PRD into architecture doc + build plan
    │   ├── hotreload.md          # Bump a stuck dev server
    │   ├── prd.md                # Interview-driven product requirements doc
    │   ├── review.md             # Review branch against PRD, plan, and code quality
    │   ├── rtfc.md               # Load change contract at start of session
    │   ├── rtfm.md               # Read all project docs before starting work
    │   ├── setup_project.md      # Scaffold a new project in current directory
    │   ├── status.md             # Snapshot plan progress + uncommitted changes
    │   └── test.md               # Run test suites; propose fixes, never apply
    ├── skills/
    │   └── change/
    │       └── SKILL.md          # Full change skill logic (branch hierarchy, contract scaffolding)
    ├── templates/                # Copied into new projects by setup_project
    │   ├── setup_project.sh      # Full project scaffold (git, component dirs, Dockerfiles, docs, CI)
    │   ├── validate_touch_list.py # Validates branch-touched files match change_contract.json
    │   ├── dev_start.sh          # Start dev environment
    │   ├── dev_stop.sh           # Stop dev environment
    │   ├── dev_build.sh          # Build dev image/assets
    │   ├── dev_tail.sh           # Tail dev logs
    │   └── dev_bork.sh           # Detect and bump stuck hot reload
    └── machines/
        └── pop-os.md             # Example CLAUDE.md for pop-os home server (not symlinked)
```

## What `install.sh` symlinks

| Symlink | Source |
|---------|--------|
| `~/.claude/commands` | `~/dotfiles/claude/commands` |
| `~/.claude/skills` | `~/dotfiles/claude/skills` |
| `~/.claude/templates` | `~/dotfiles/claude/templates` |
| `~/.claude/settings.json` | `~/dotfiles/claude/settings.json` |
| `~/.claude/preferences.md` | `~/dotfiles/claude/preferences.md` |

`~/.claude/CLAUDE.md` is **not symlinked** — it's written per-machine and is not tracked. It should `@~/.claude/preferences.md` to pull in shared prefs.

## Machine context pattern

Each machine has its own `~/.claude/CLAUDE.md` describing its stack and conventions. The file ends with `@~/.claude/preferences.md` to import shared preferences. `machines/pop-os.md` is a reference example (not actively symlinked).

## Command types

### Feature pipeline (start → ship)
`/prd` → `/groom` → `/build` (repeat) → `/test` → `/review` → `/commit`

### Change workflow (branch-scoped)
`/change` → work → `/rtfc` (each new session) → `/change_docs` → `/change_wrap`

The change workflow uses a `changes/<branch>/` directory with four living documents:
- `change_contract.json` — goal, non_goals, constraints, acceptance_checks, touch_list
- `decision_log.md` — context and decisions
- `testing_plan.md` — test coverage plan
- `notes.md` — free-form implementation notes

`/change_wrap` runs `validate_touch_list.py` from `~/.claude/templates/` to confirm that all files touched on the branch are declared in `touch_list` before committing.

## How to install

```bash
git clone git@github.com:brooks-adcock/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

## How to update skills

```bash
git -C ~/dotfiles pull
```

No re-install needed — the symlinks keep `~/.claude` in sync.
