You are running a Code Review. Your job is to review the current branch against both the project's documented intent and standard code quality criteria. A good review checks not just whether the code is correct, but whether it builds the right thing.

---

## Before You Start

Run these as separate Bash calls (never chain with &&):

1. Detect the base branch: `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'` — falls back to `main` if empty
2. `git log --oneline <base>..HEAD` — see what commits are on this branch
3. `git diff <base>..HEAD --stat` — see which files changed
4. `git diff <base>..HEAD` — read the full diff
4. If `docs/prd.md` exists: read it — this is the source of truth for intent
5. If `docs/plan.md` exists: read it — find the step(s) this branch implements
6. If `docs/architecture.md` exists: read it — understand the intended design
7. If `docs/decisions.md` exists: read it — understand prior decisions that constrain this work

---

## Review in two passes

### Pass 1 — Intent

Review the diff against the documented intent. This is the most important pass.

**PRD alignment**
- Does the implementation actually solve the problem stated in `prd.md`?
- Are the goals met? Are non-goals respected — i.e. was anything built that was explicitly out of scope?

**Plan alignment**
- Which step(s) does this correspond to in `plan.md`?
- Are the test criteria for those steps satisfied by the code?
- Were any files touched outside the step's `Files:` touch list? If so, is the deviation justified or a sign of scope creep?

**Architecture alignment**
- Does the code follow the structure documented in `architecture.md`?
- Are new files placed in the correct locations per project conventions (`[component]/code/`)?
- Does the implementation match the documented API contracts, data model, and integration points?

### Pass 2 — Code quality

Standard review criteria:

- **Correctness** — does the code do what it claims? Are there edge cases the test criteria don't cover?
- **Security** — any injection, auth, or exposure issues? Check OWASP top 10 where relevant.
- **Clarity** — would a capable engineer understand this without a walkthrough?
- **Test coverage** — are the tests meaningful, or do they just mechanically satisfy the criteria without catching real failures?
- **Consistency** — does the code follow the patterns already established in the codebase?

---

## Report

Structure your output as:

**Intent review**
- PRD: [aligned / concern: ...]
- Plan step(s): [N, N — criteria met / concern: ...]
- Touch list: [clean / deviations: ...]
- Architecture: [aligned / concern: ...]

**Code quality**
- List specific issues found, each with: file + line, description, severity (blocking / suggestion)
- If nothing of note, say "no issues found"

**Verdict**
One of:
- **Approve** — ready to merge
- **Approve with suggestions** — mergeable, minor non-blocking notes
- **Request changes** — specific blocking issues listed above must be addressed

Do not pad. A clean review should be short. Issues should be specific enough to act on without follow-up questions.
