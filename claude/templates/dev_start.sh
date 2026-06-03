#!/bin/bash
set -euo pipefail
docker compose -f docker-compose.dev.yml up -d
echo "Started. Run ./dev_tail.sh in a separate terminal to follow logs."
