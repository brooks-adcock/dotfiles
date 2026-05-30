#!/bin/bash
set -euo pipefail

PROJECT_NAME="${1:-$(basename "$PWD")}"
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
        touch "$component/Dockerfile"
        stamp "$component/Dockerfile"
    else
        skip "$component/Dockerfile"
    fi
done

for component in ui api; do
    if [ ! -f "$component/Dockerfile.dev" ]; then
        touch "$component/Dockerfile.dev"
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
if [ ! -d docs ]; then
    mkdir docs
    cat > docs/architecture.md << EOF
# Architecture — $PROJECT_NAME

## Overview

## Directory Structure

## Tech Stack

## Data Model

## Key Flows

## How to Run
EOF
    cat > docs/decisions.md << EOF
# Decisions — $PROJECT_NAME

Newest entries at the top.
EOF
    cat > docs/status.md << EOF
# Status — $PROJECT_NAME

## Done

## In Progress

## Next

## Known Issues

## Not Doing
EOF
    stamp "docs/"
else
    skip "docs/"
fi

# ── Changes dir ───────────────────────────────────────────────────────────────
if [ ! -d changes ]; then
    mkdir changes
    touch changes/.gitkeep
    stamp "changes/"
else
    skip "changes/"
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
