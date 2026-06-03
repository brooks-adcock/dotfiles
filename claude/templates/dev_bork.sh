#!/bin/bash
set -euo pipefail
echo "Borking dev environment..."
docker compose -f docker-compose.dev.yml down -v --remove-orphans 2>/dev/null || true
docker system prune -af --volumes
echo "Clean slate."
