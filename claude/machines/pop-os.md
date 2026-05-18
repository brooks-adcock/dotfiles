# Machine: pop-os — Home Server

This machine (`pop-os`) is a home server running prototype apps and shared infrastructure. LAN IP: `192.168.1.100`. Public domain: `znerd.fun` (Cloudflare).

## Stack

| Component | Details |
|-----------|---------|
| Reverse proxy | Caddy — config at `/etc/caddy/Caddyfile`, reload with `sudo systemctl reload caddy` |
| LAN DNS | dnsmasq — `*.adcock` resolves to `192.168.1.100` |
| Database / Auth / Storage | Self-hosted Supabase at `~/Projects/supabase/docker/` → `http://supabase.adcock` |
| Monitoring | Uptime Kuma at `~/Projects/uptime-kuma/` → `http://kuma.adcock` |
| Ops bot | Telegram bot (`ops-bot`) at `~/Projects/ops-bot/` — systemd service |
| Containers | Docker Engine (systemd) — apps managed via `docker compose` |
| CI/CD | Self-hosted GitHub Actions runner at `~/actions-runner` |
| Public access | Cloudflare Tunnel (`cloudflared`) — `znerd.fun` subdomains |
| Heartbeat | Healthchecks.io ping every 5 min via cron |

## Deployed Apps

| App | Port | LAN URL | Directory | Repo |
|-----|------|---------|-----------|------|
| KidsBank | 3010 | `http://kidsbank.adcock` | `~/Projects/KidsBank` | `brooks-adcock/KidsBank` |
| Uptime Kuma | 3001 | `http://kuma.adcock` | `~/Projects/uptime-kuma` | — |
| ops-bot | — | — | `~/Projects/ops-bot` | `brooks-adcock/ops-bot` |

## Supabase

- Docker Compose at `~/Projects/supabase/docker/` — 13 containers
- Credentials in `~/Projects/supabase/docker/.env`
- Studio: `http://supabase.adcock` (login: `supabase`)
- Postgres: `localhost:5432`, user `postgres`
- `postgres` MCP server is configured — use it to query the DB directly
- Each app gets its own schema and service role key; `auth.users` is shared

## Caddy conventions

- LAN `*.adcock` entries **must** use `http://` prefix — Caddy auto-promotes bare hostnames to HTTPS, ACME fails for `.adcock`, breaking the site
- Public `*.znerd.fun` entries use **no prefix** — Cloudflare terminates TLS at the edge, Caddy just proxies HTTP on port 80

## Adding a new app

1. Register a self-hosted runner for the repo (repo → Settings → Actions → Runners)
2. Write `Dockerfile` + `docker-compose.yml` — build-time vars (`NEXT_PUBLIC_*`) must be `ARG`/`ENV` in Dockerfile
3. Add `.github/workflows/deploy.yml` — branch name must match repo default branch in both `branches:` and `git pull origin <branch>`
4. Clone repo on pop-os: `git clone git@github.com:brooks-adcock/<repo>.git ~/Projects/<name>`
5. Add Caddy entry + `sudo systemctl reload caddy`
6. `docker compose build && docker compose up -d`
7. Add monitor in Uptime Kuma

## Common operations

```bash
# Reload Caddy after config change
sudo systemctl reload caddy

# Restart an app
cd ~/Projects/<app> && docker compose restart

# Rebuild and redeploy
cd ~/Projects/<app> && docker compose build && docker compose up -d

# All running containers
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Supabase container health
docker compose -f ~/Projects/supabase/docker/docker-compose.yml ps

# Apply a migration
docker exec -i supabase-db psql -U postgres < migrations/<file>.sql
```

## Key warnings

- **Never restart `systemd-logind`** — kills active SSH/graphical sessions. Edit `/etc/systemd/logind.conf` and reboot instead.
- **Never commit `.env` files** — secrets live on the server only.
- **`NEXT_PUBLIC_*` vars are build-time** — runtime `env_file` in docker-compose has no effect on them.

@~/.claude/preferences.md
