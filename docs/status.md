# Status

## Done

- **`install.sh`** — symlinks `commands/`, `skills/`, `templates/`, `settings.json`, `preferences.md` into `~/.claude`; migration guard for old CLAUDE.md symlink pattern
- **Feature pipeline skills** — `/prd`, `/groom`, `/build`, `/review`, `/status`, `/test`
- **Change workflow** — `/change` (branch + contract), `/rtfc`, `/change_docs`, `/change_wrap`
- **Utility commands** — `/rtfm`, `/docs`, `/commit`, `/hotreload`
- **`/setup_project`** — scaffolds new projects with git, `ui/api/db` component dirs, Dockerfile stubs, `docker-compose.yml`, full `docs/` stubs, CI workflow, and dev scripts
- **`validate_touch_list.py`** — deterministic validator called from `change_wrap`; verifies branch-touched files are declared in `change_contract.json`; exits 0/1/2
- **`dev_*.sh` templates** — `dev_start.sh`, `dev_stop.sh`, `dev_build.sh`, `dev_tail.sh`, `dev_bork.sh`
- **CLAUDE.md split** — per-machine CLAUDE.md (not tracked) + shared `preferences.md` (tracked)
- **`machines/pop-os.md`** — reference CLAUDE.md for home server

## In Progress

Nothing active.

## Next

- Add more machine examples to `machines/` as new machines are set up
- Consider a `/setup_project` variant for non-Docker projects (plain Python, Node CLI)
- `/change_wrap` could auto-push the daily branch after the change branch PR is created

## Known Issues

- `validate_touch_list.py` requires `~/.claude/templates/` symlink — older installs (before `templates/` was added to `install.sh`) won't have it. Run `bash install.sh` again to fix.
- `machines/pop-os.md` is a stale reference example — it's not symlinked and may drift from the real machine's CLAUDE.md.

## Not Doing

- **Homebrew** — MacPorts is the system package manager; Homebrew is explicitly avoided
- **Tracking CLAUDE.md in dotfiles** — it's intentionally per-machine to avoid cross-machine pollution
- **Auto-push on commit** — `preferences.md` explicitly says don't push unless asked
