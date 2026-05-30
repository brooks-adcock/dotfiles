You are running a Status check. Your job is to read the current project state and report it clearly. You do not write to any file. You do not take any action. Read only.

---

## Read

Run these as separate Bash calls (never chain with &&):

1. `git log --oneline -5` — recent commits
2. `git status` — uncommitted changes
3. If `docs/prd.md` exists: read it
4. If `docs/plan.md` exists: read it
5. If `docs/status.md` exists: read it

---

## Report

Output a single, terse status block in this format:

---

**What we're building**
One sentence from the PRD goal. If no PRD exists, say so.

**Plan progress**
X of N steps complete.
✅ Last completed: Step N — [Name]
▶ Next: Step N — [Name] — [one sentence from the What field]
🔲 Remaining: N steps

If no plan exists, say so.

**Uncommitted changes**
List modified files, or "clean" if none.

**Open questions / blockers**
Any unresolved items from `prd.md` or `plan.md` worth flagging, or "none."

---

Nothing else. No suggestions, no next steps, no commentary. The user asked where things stand — answer that and stop.
