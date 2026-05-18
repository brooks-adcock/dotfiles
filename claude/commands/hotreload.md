The app's hot reload is stuck. Detect the stack and give it a bump.

## Step 1: Detect the environment

Check in order:
1. `docker-compose*.yml` or `compose*.yml` — is this a Docker-based dev setup?
2. `package.json` `scripts.dev` or `scripts.start` — what bundler/server is in use? (webpack, vite, esbuild, next, etc.)
3. Running processes if needed: `ps aux | grep -E 'node|webpack|vite'`

## Step 2: Apply the right nudge

**Docker + webpack:**
```bash
docker compose -f <compose-file> exec <app-service> ./node_modules/.bin/webpack --mode development
```

**Docker compose (any service — full restart):**
```bash
docker compose -f <compose-file> restart <service>
```

**Vite / Next.js / esbuild (native node):**
Touch the entry point to force a rebuild — find it from `package.json` `main` or the dev script:
```bash
touch <entry-file>
```

**nodemon:**
```bash
kill -HUP $(pgrep -f nodemon)
```

**Generic node dev server (last resort):**
Find the PID and restart it:
```bash
kill $(lsof -ti:<dev-port>) && npm run dev
```

## Step 3: Confirm

Tell the user what was bumped and ask them to reload the browser.
