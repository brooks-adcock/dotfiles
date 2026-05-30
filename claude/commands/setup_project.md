Scaffold a new project in the current directory using the standard structure.

## Instructions

1. Ask the user: **"What's the project name?"** Suggest the current directory name as the default.

2. Run the setup script as a single Bash call:
   ```
   bash ~/.claude/templates/setup_project.sh "<project_name>"
   ```

3. Relay the script output to the user exactly as printed.

4. Remind the user of the three things to fill in before starting work:
   - `CLAUDE.md` — replace the TODOs with actual project context
   - `docker-compose.yml` / `docker-compose.dev.yml` — ports, env vars, service config
   - `ui/Dockerfile`, `ui/Dockerfile.dev`, `api/Dockerfile`, `api/Dockerfile.dev`, `db/Dockerfile` — add your actual build steps
