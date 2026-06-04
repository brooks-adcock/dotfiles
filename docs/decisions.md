# Decisions

Newest first.

---

## 2026-06-04 — validate_touch_list.py called from dotfiles templates directly

**Context:** `change_wrap` needed to validate that branch-touched files matched the change contract before committing. The validator needed to be available in any project that uses the change workflow.

**Options considered:**
- Inline the validation logic in `change_wrap.md` — brittle, hard to maintain
- Vendor the script into each project at `/change_wrap` time — copies diverge
- Call it from `~/.claude/templates/validate_touch_list.py` directly — single source of truth

**Decision:** Call `~/.claude/templates/validate_touch_list.py` directly. Since `~/.claude/templates` is symlinked from `~/dotfiles/claude/templates`, the script is always current and no per-project copy is needed.

**Consequences:** Projects must be installed with a version of `install.sh` that symlinks `templates/`. Pre-symlink installs won't have the script at `~/.claude/templates/`.

---

## 2026-06-04 — setup_project generates Dockerfile scaffolds, drops project name prompt

**Context:** `/setup_project` needed to scaffold enough structure that a new project could immediately start with `docker compose`. Asking the user for a project name added friction with no benefit (it's always `basename $PWD`).

**Decision:** Dockerfile stubs are generated for `ui/`, `api/`, and `db/` components. All content is commented-out with `# TODO` instructions. Project name derived from `basename "$PWD"` — no prompt.

**Consequences:** Projects always get three component dirs. Teams using a different component structure will need to delete extras manually.

---

## 2026-06-04 — templates/ added as a symlink target

**Context:** `dev_*.sh` scripts and `validate_touch_list.py` are useful in any project but shouldn't be copy-pasted. Making `~/.claude/templates` a symlink from dotfiles means `setup_project.sh` can copy from it without per-project vendoring.

**Decision:** Added `link "$DOTFILES_DIR/claude/templates" "$HOME/.claude/templates"` to `install.sh`. New installs get `~/.claude/templates/` automatically.

**What didn't work:** Earlier approach vendored `validate_touch_list.py` into each project at scaffold time — meant the validator would go stale whenever the dotfiles version was updated.

---

## 2026-05-01 — CLAUDE.md split: per-machine vs. shared preferences

**Context:** `CLAUDE.md` was a dotfiles symlink, which meant every machine shared one context file. Machine-specific stack info (ports, LAN IPs, OS, tool paths) polluted all machines.

**Options considered:**
- Single shared CLAUDE.md with machine-specific sections — noisy, hard to maintain
- Per-machine CLAUDE.md (not tracked) + shared preferences.md (tracked) — clean separation

**Decision:** `CLAUDE.md` is written per-machine, not tracked. `preferences.md` is tracked and imported via `@~/.claude/preferences.md` at the bottom of each machine's CLAUDE.md.

**What didn't work:** The old symlink approach caused `install.sh` to fail on machines that had already set up per-machine CLAUDE.md — the migration guard in `install.sh` detects and rejects this state.

**Consequences:** New machines must hand-write their own CLAUDE.md. `machines/pop-os.md` serves as a reference example.

---

## 2026-04-15 — change workflow uses branch-scoped `changes/` directory

**Context:** Needed a way to pass context between sessions on a long-lived change branch without relying on conversation history (which is lost between sessions).

**Decision:** Each change gets a `changes/<branch>/` directory with four files: `change_contract.json`, `decision_log.md`, `testing_plan.md`, `notes.md`. `/rtfc` loads these at the start of each session. Files are committed alongside code changes.

**Consequences:** The `changes/` directory accumulates per-project. Projects should either gitignore it or commit it (both are valid — committing means the contract is in history alongside the code).

---

## 2026-04-01 — skills/ directory separate from commands/

**Context:** Slash commands (`.md` files in `commands/`) are simple prompt instructions. More complex workflows (like `change`) need structured logic, argument handling, and conditional branching that doesn't fit in a flat `.md` file.

**Decision:** Complex skills go in `skills/<name>/SKILL.md` with frontmatter (`name`, `description`, `allowed-tools`, `argument-hint`, `user-invocable`). Simple prompts stay in `commands/`.

**Consequences:** Two lookup locations. Claude Code resolves both via symlink. The distinction is informal — any command could be moved to skills/ if it grows complex.
