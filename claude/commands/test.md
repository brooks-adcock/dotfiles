You are running a Test session. Your job is to discover all test suites in the project, run them, report every failure with precise context, and propose concrete fixes. You do not apply fixes — you propose them and stop.

---

## Phase 1 — Discovery

Run these as separate Bash calls (never chain with &&):

1. `find . -name "pytest.ini" -o -name "pyproject.toml" -o -name "setup.cfg" -o -name "conftest.py" | grep -v __pycache__ | grep -v .claude | sort` — locate Python test config
2. `find . -name "vitest.config.*" -o -name "jest.config.*" | grep -v node_modules | grep -v .claude | sort` — locate JS test config
3. `find . -path "*/tests/*.py" -o -path "*/test_*.py" -o -path "*/*.test.ts" -o -path "*/*.test.tsx" -o -path "*/*.spec.ts" -o -path "*/*.spec.tsx" | grep -v node_modules | grep -v __pycache__ | grep -v .claude | sort` — find all test files
4. `cat docs/plan.md 2>/dev/null | grep -A3 "test suite\|Test suite\|pytest\|vitest" | head -40` — check plan for test context

If no test files exist anywhere, report: "No tests found. Check docs/plan.md for steps that define test suites and run /build to implement them." Then stop.

---

## Phase 2 — Run

Run each discovered suite. Capture full output.

### Python (pytest)

If `api/tests/` exists and contains `.py` files:

```
cd api && pip install -q -r code/requirements-dev.txt 2>&1 | tail -5
pytest api/tests/ -v --tb=short 2>&1
```

Run from the project root. If pytest is not installed, try `python -m pytest`.

If the suite requires a live DB/API (integration tests), attempt to run anyway. If connection errors appear, note them as an environment issue, not a test failure.

### JavaScript / TypeScript (Vitest or Jest)

If `web/code/vitest.config.*` or `web/code/package.json` contains a `"test"` script:

```
cd web/code && npm run test -- --reporter=verbose --run 2>&1
```

If the `"test"` script is missing from `package.json`, note it and skip.

---

## Phase 3 — Report

Output a structured report in this exact format:

---

### Test Run Summary

**API suite** (pytest)
- Files: list test files found, or "none"
- Result: PASSED / FAILED / SKIPPED (environment) / NOT FOUND
- X passed, Y failed, Z errors

**Web suite** (Vitest)
- Files: list test files found, or "none"
- Result: PASSED / FAILED / SKIPPED (environment) / NOT FOUND
- X passed, Y failed, Z errors

---

### Failures

For each failing test, output:

**[suite] test_name_or_describe_block > test_case**
```
[exact error output, trimmed to the relevant lines — assertion, traceback root cause, or error message]
```
Root cause: one sentence identifying WHY it fails (wrong value, missing dependency, schema mismatch, etc.)

---

### Environment issues

List any tests that could not run due to missing services (DB not running, API not up, missing env vars). State exactly what is needed to run them.

---

## Phase 4 — Propose fixes

For each failure, propose a fix in this format:

**Fix for: [test name]**
File: `path/to/file.py` (or `.ts`)
Change: describe the specific change in one or two sentences. If it is a code change, show a before/after diff block. If it is a configuration or environment issue, state the exact command or setting.

Do not implement the fix. Do not edit any file. Propose only.

---

## Finish

End with one of:
- "All tests passed." — if every suite ran clean
- "N failures across M suites — fixes proposed above." — if any test failed
- "No tests found — check docs/plan.md for test suite steps and run /build." — if no test files exist
