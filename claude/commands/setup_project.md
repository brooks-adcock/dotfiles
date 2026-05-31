Scaffold a new project in the current directory using the standard structure.

## Instructions

1. Run the setup script as a single Bash call:
   ```
   bash ~/.claude/templates/setup_project.sh
   ```

2. Relay the script output to the user exactly as printed.

3. Remind the user of the three things to fill in before starting work:
   - `CLAUDE.md` — replace the TODOs with actual project context
   - `docker-compose.yml` / `docker-compose.dev.yml` — ports, env vars, service config
   - `ui/Dockerfile`, `ui/Dockerfile.dev`, `api/Dockerfile`, `api/Dockerfile.dev`, `db/Dockerfile` — uncomment and adapt the starter scaffold to your actual stack

---

## What gets created

### Component directories
| Path | Purpose |
|------|---------|
| `ui/code/` | Frontend source code |
| `api/code/` | Backend source code |
| `db/code/` | Database migrations and init scripts |
| `ui/Dockerfile` | Production UI image (commented scaffold) |
| `ui/Dockerfile.dev` | Dev UI image with hot reload (commented scaffold) |
| `api/Dockerfile` | Production API image (commented scaffold) |
| `api/Dockerfile.dev` | Dev API image with hot reload (commented scaffold) |
| `db/Dockerfile` | Database image (commented scaffold) |

### Compose files
| File | Purpose |
|------|---------|
| `docker-compose.yml` | Production compose config |
| `docker-compose.dev.yml` | Dev compose config with volume mounts |

### Dev scripts
| Script | What it does |
|--------|-------------|
| `dev_build.sh` | Build all images |
| `dev_start.sh` | Start containers (detached) |
| `dev_stop.sh` | Stop containers |
| `dev_tail.sh` | Follow logs |
| `dev_bork.sh` | Nuclear reset — stop, remove containers/volumes, rebuild |

### Docs
All docs files live in `docs/`. They are checked individually — re-running the script on an existing project only creates missing files.

| File | Created by | Purpose |
|------|-----------|---------|
| `docs/architecture.md` | `setup_project` | Current state of the system: stack, directory layout, data model, key flows, how to run |
| `docs/decisions.md` | `setup_project` | ADR-style log of every non-trivial choice: what was tried, what failed, what was chosen |
| `docs/status.md` | `setup_project` | Done / In Progress / Next / Known Issues / Not Doing |
| `docs/prd.md` | `setup_project` stub → filled by `/prd` | Product requirements: problem, goals, non-goals, users, constraints, risks |
| `docs/plan.md` | `setup_project` stub → filled by `/groom` | Ordered build steps with file lists and test criteria |

### Other
| Path | Purpose |
|------|---------|
| `CLAUDE.md` | Project context loaded by Claude at the start of every session |
| `changes/system/validate_touch_list.py` | Deterministic touchlist validator — run by `/change_wrap` before commit |
| `changes/` | In-flight change contracts (one subdirectory per branch, created by `/change`) |
| `.gitignore` | Standard ignores: `.env`, `node_modules/`, `__pycache__/`, etc. |

---

## Workflow after setup

```
/prd      → fill in docs/prd.md (what and why)
/groom    → fill in docs/architecture.md + docs/plan.md (how and in what order)
/build    → execute one step from the plan at a time
/docs     → keep docs/architecture.md, decisions.md, status.md in sync with the code
/change   → for isolated hotfixes that don't follow the prd→groom→build pipeline
```
