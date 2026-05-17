Update the documents in the ./docs directory based on everything in the current conversation. Each file has a specific purpose — update only what has changed:

**architecture.md** — How the full stack fits together: components, data flow, routing, external access, monitoring. Update when new services are added, topology changes, or integration details are clarified.

**decisions.md** — Non-obvious choices and their rationale. Each entry covers: what was decided, why, and what was given up. Update when a meaningful technical decision is made or reversed. Include things that didn't work and why — this is institutional memory, not just a success log.

**plan.md** — Ordered implementation phases written so any phase can be independently handed to a subagent. Each step should be concrete and executable. Update to reflect completed steps, revised approaches, or newly discovered prerequisites. Mark completed phases clearly.

**status.md** — Current position in the plan. For each phase: whether it's complete, in progress, or not started. For completed phases, include the key version numbers or verification results. For in-progress phases, note what's done and what's next. Keep it tight — this is a quick-read dashboard, not a log.

Read all four files first, then update each one that needs changes. Do not rewrite sections that are still accurate. Respond with a one-line summary of what changed in each file.
