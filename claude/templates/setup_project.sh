#!/bin/bash
set -euo pipefail

PROJECT_NAME="$(basename "$PWD")"
TEMPLATES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREATED=()
SKIPPED=()

stamp() { echo "  ✓ $1"; CREATED+=("$1"); }
skip()  { echo "  - $1 (exists, skipped)"; SKIPPED+=("$1"); }

echo "Setting up project: $PROJECT_NAME"
echo ""

# ── Git ──────────────────────────────────────────────────────────────────────
if [ ! -d .git ]; then
    git init -q
    stamp ".git"
fi

# ── Component directories ─────────────────────────────────────────────────────
for component in ui api db; do
    mkdir -p "$component/code"
    touch "$component/code/.gitkeep"

    if [ ! -f "$component/Dockerfile" ]; then
        case "$component" in
            ui)
                cat > "$component/Dockerfile" << 'EOF'
# TODO: replace with your chosen base image (e.g. node:20-alpine)
# FROM node:20-alpine
# WORKDIR /app
# COPY code/package*.json ./
# RUN npm ci --production
# COPY code/ .
# RUN npm run build
# EXPOSE 3000
# CMD ["npm", "start"]
EOF
                ;;
            api)
                cat > "$component/Dockerfile" << 'EOF'
# TODO: replace with your chosen base image (e.g. python:3.12-slim, node:20-alpine)
# FROM python:3.12-slim
# WORKDIR /app
# COPY code/requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# COPY code/ .
# EXPOSE 8000
# CMD ["python", "main.py"]
EOF
                ;;
            db)
                cat > "$component/Dockerfile" << 'EOF'
# TODO: replace with your chosen base image (e.g. postgres:16-alpine, mysql:8)
# FROM postgres:16-alpine
# COPY init/ /docker-entrypoint-initdb.d/
# EXPOSE 5432
EOF
                ;;
        esac
        stamp "$component/Dockerfile"
    else
        skip "$component/Dockerfile"
    fi
done

for component in ui api; do
    if [ ! -f "$component/Dockerfile.dev" ]; then
        case "$component" in
            ui)
                cat > "$component/Dockerfile.dev" << 'EOF'
# TODO: replace with your chosen base image (e.g. node:20-alpine)
# FROM node:20-alpine
# WORKDIR /app
# COPY code/package*.json ./
# RUN npm install
# CMD ["npm", "run", "dev"]
EOF
                ;;
            api)
                cat > "$component/Dockerfile.dev" << 'EOF'
# TODO: replace with your chosen base image (e.g. python:3.12-slim, node:20-alpine)
# FROM python:3.12-slim
# WORKDIR /app
# COPY code/requirements.txt .
# RUN pip install -r requirements.txt
# CMD ["python", "-m", "uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
EOF
                ;;
        esac
        stamp "$component/Dockerfile.dev"
    else
        skip "$component/Dockerfile.dev"
    fi
done

# ── Docker Compose ────────────────────────────────────────────────────────────
if [ ! -f docker-compose.yml ]; then
    cat > docker-compose.yml << 'EOF'
services:
  ui:
    build:
      context: ./ui
      dockerfile: Dockerfile
    # TODO: ports, environment

  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    # TODO: ports, environment

  db:
    build:
      context: ./db
      dockerfile: Dockerfile
    # TODO: volumes, environment
EOF
    stamp "docker-compose.yml"
else
    skip "docker-compose.yml"
fi

if [ ! -f docker-compose.dev.yml ]; then
    cat > docker-compose.dev.yml << 'EOF'
services:
  ui:
    build:
      context: ./ui
      dockerfile: Dockerfile.dev
    volumes:
      - ./ui/code:/app
    # TODO: ports, environment

  api:
    build:
      context: ./api
      dockerfile: Dockerfile.dev
    volumes:
      - ./api/code:/app
    # TODO: ports, environment

  db:
    build:
      context: ./db
      dockerfile: Dockerfile
    volumes:
      - db_data:/var/lib/postgresql/data
    # TODO: environment

volumes:
  db_data:
EOF
    stamp "docker-compose.dev.yml"
else
    skip "docker-compose.dev.yml"
fi

# ── Dev scripts ───────────────────────────────────────────────────────────────
for script in dev_build dev_start dev_stop dev_tail dev_bork; do
    if [ ! -f "${script}.sh" ]; then
        cp "$TEMPLATES_DIR/${script}.sh" .
        chmod +x "${script}.sh"
        stamp "${script}.sh"
    else
        skip "${script}.sh"
    fi
done

# ── Docs ──────────────────────────────────────────────────────────────────────
mkdir -p docs

if [ ! -f docs/architecture.md ]; then
    cat > docs/architecture.md << EOF
# Architecture — $PROJECT_NAME

## Overview

## Directory Structure

\`\`\`
ui/        — frontend
api/       — backend
db/        — database
docs/      — project documentation for AI agents
changes/   — in-flight change contracts
\`\`\`

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| UI    | TODO      |     |
| API   | TODO      |     |
| DB    | TODO      |     |

## Data Model

## Key Flows

## How to Run (dev)

\`\`\`bash
./dev_build.sh   # build images
./dev_start.sh   # start containers (detached)
./dev_tail.sh    # follow logs
./dev_stop.sh    # stop containers
./dev_bork.sh    # nuclear reset
\`\`\`

## How to Build (production)

\`\`\`bash
docker compose -f docker-compose.yml build
\`\`\`

## Direct Database Access

\`\`\`bash
# TODO: add psql / sqlite3 / mysql command once DB is configured
\`\`\`
EOF
    stamp "docs/architecture.md"
else
    skip "docs/architecture.md"
fi

if [ ! -f docs/decisions.md ]; then
    cat > docs/decisions.md << EOF
# Decisions — $PROJECT_NAME

Newest entries at the top.

<!-- Entry format:
## YYYY-MM-DD — [Short title]

**Context:** What situation prompted this decision
**Options considered:**
- Option A — tradeoffs
- Option B — tradeoffs
**Decision:** What was chosen and why
**What didn't work:** Specific failures, error messages, dead ends
**Consequences:** What follows from this decision
-->
EOF
    stamp "docs/decisions.md"
else
    skip "docs/decisions.md"
fi

if [ ! -f docs/status.md ]; then
    cat > docs/status.md << EOF
# Status — $PROJECT_NAME

## Done

## In Progress

## Next

## Known Issues

## Not Doing
EOF
    stamp "docs/status.md"
else
    skip "docs/status.md"
fi

if [ ! -f docs/prd.md ]; then
    cat > docs/prd.md << EOF
# PRD — $PROJECT_NAME

> Run \`/prd\` to fill this in through a guided conversation.

## Problem Statement

## Goals

## Non-Goals

## Users

## Constraints

## Edge Cases

## Open Questions

## Dependencies

## Risks
EOF
    stamp "docs/prd.md"
else
    skip "docs/prd.md"
fi

if [ ! -f docs/plan.md ]; then
    cat > docs/plan.md << EOF
# Plan — $PROJECT_NAME

> Run \`/groom\` (after completing the PRD) to generate this through a guided conversation.
> Each step will follow this format:
>
> ## Step N — [Name]
> **What:** One sentence describing the change.
> **Why:** How this step serves the PRD goals.
> **Files:** Exhaustive list of every file created or modified — full paths from project root.
> **Test criteria:** Specific, checkable conditions that confirm this step is complete.
> **Depends on:** Step numbers this must follow, or — if none.
> **Status:** 🔲
EOF
    stamp "docs/plan.md"
else
    skip "docs/plan.md"
fi

# ── Changes dir ───────────────────────────────────────────────────────────────
mkdir -p changes changes/system

if [ ! -f changes/.gitkeep ]; then
    touch changes/.gitkeep
fi

if [ ! -f changes/system/validate_touch_list.py ]; then
    cp "$TEMPLATES_DIR/validate_touch_list.py" changes/system/validate_touch_list.py
    chmod +x changes/system/validate_touch_list.py
    stamp "changes/system/validate_touch_list.py"
else
    skip "changes/system/validate_touch_list.py"
fi

# ── CLAUDE.md ─────────────────────────────────────────────────────────────────
if [ ! -f CLAUDE.md ]; then
    cat > CLAUDE.md << EOF
# $PROJECT_NAME

## What this is
TODO: one paragraph describing the project.

## Stack
TODO: languages, frameworks, key dependencies.

## How to run (dev)
\`\`\`bash
./dev_build.sh   # build images
./dev_start.sh   # start containers (detached)
./dev_tail.sh    # follow logs in a separate terminal
./dev_stop.sh    # stop containers
./dev_bork.sh    # nuclear reset
\`\`\`

@~/.claude/preferences.md
EOF
    stamp "CLAUDE.md"
else
    skip "CLAUDE.md"
fi

# ── .gitignore ────────────────────────────────────────────────────────────────
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOF'
.env
.env.*
!.env.example
node_modules/
.next/
__pycache__/
*.pyc
.DS_Store
*.db
*.db-journal
*.db-wal
EOF
    stamp ".gitignore"
else
    skip ".gitignore"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "Done. ${#CREATED[@]} created, ${#SKIPPED[@]} skipped."
echo ""
echo "Next steps:"
echo "  1. Fill in the TODOs in CLAUDE.md, docker-compose.yml, docker-compose.dev.yml"
echo "  2. Populate Dockerfile and Dockerfile.dev in each component"
echo "  3. Run /prd to start defining requirements"
