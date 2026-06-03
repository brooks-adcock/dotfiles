Read the project documentation before doing anything else.

> **Which context loader to use?**
> - `/rtfm` — project-level feature work using the `prd` → `groom` → `build` pipeline
> - `/rtfc` — branch-scoped changes tracked in `./changes/<branch>/` (hotfixes, isolated changes)

## Instructions

1. Read files in `./docs/` that exist (run as separate Bash calls, never chain with &&):
   - `docs/architecture.md` — how the system works, directory structure, tech stack, data model
   - `docs/decisions.md` — what was tried, what failed, what worked (newest first)
   - `docs/status.md` — what's done, what's next, known issues, things we're NOT doing
   - `docs/prd.md` — if it exists: the product requirements driving current work
   - `docs/plan.md` — if it exists: the ordered step breakdown and current progress

2. When done, reply with exactly `10-8` and nothing else.

3. You are now ready to work. Do not re-discover things that are already documented. Do not retry approaches listed as failed in `decisions.md`. Do not suggest things listed under "Not Doing" in `status.md`. Do not implement steps marked ✅ in `plan.md`.
