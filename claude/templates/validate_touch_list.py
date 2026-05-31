#!/usr/bin/env python3
"""
Validate that files touched on the current branch match the touch_list in
changes/<branch>/change_contract.json.

Exit 0  — no undeclared changes (warnings may still print for unlisted files)
Exit 1  — one or more changed files are absent from the touch_list
Exit 2  — setup error (missing contract, not in a git repo, etc.)
"""

import json
import subprocess
import sys
from pathlib import Path


def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        return ""
    return r.stdout


def current_branch():
    out = run(["git", "rev-parse", "--abbrev-ref", "HEAD"]).strip()
    if not out or out == "HEAD":
        print("ERROR: could not determine current branch", file=sys.stderr)
        sys.exit(2)
    return out


def base_ref():
    """Return the best available ref to diff against."""
    for candidate in [
        ["git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD"],
        ["git", "rev-parse", "--verify", "origin/main"],
        ["git", "rev-parse", "--verify", "origin/master"],
        ["git", "rev-parse", "--verify", "main"],
        ["git", "rev-parse", "--verify", "master"],
    ]:
        out = run(candidate).strip()
        if out:
            return out
    print("ERROR: could not determine base branch", file=sys.stderr)
    sys.exit(2)


def changed_files(base):
    files = set()

    merge_base = run(["git", "merge-base", "HEAD", base]).strip()
    if not merge_base:
        print(f"ERROR: could not find merge-base with {base}", file=sys.stderr)
        sys.exit(2)

    # Committed changes since branching
    for line in run(["git", "diff", "--name-only", merge_base]).splitlines():
        if line.strip():
            files.add(line.strip())

    # Staged changes not yet committed
    for line in run(["git", "diff", "--name-only", "--cached"]).splitlines():
        if line.strip():
            files.add(line.strip())

    # Unstaged modifications
    for line in run(["git", "diff", "--name-only"]).splitlines():
        if line.strip():
            files.add(line.strip())

    # Untracked new files
    for line in run(["git", "ls-files", "--others", "--exclude-standard"]).splitlines():
        if line.strip():
            files.add(line.strip())

    return files


def main():
    branch = current_branch()
    contract_path = Path(f"changes/{branch}/change_contract.json")

    if not contract_path.exists():
        print(f"ERROR: {contract_path} not found", file=sys.stderr)
        sys.exit(2)

    try:
        contract = json.loads(contract_path.read_text())
    except json.JSONDecodeError as e:
        print(f"ERROR: could not parse {contract_path}: {e}", file=sys.stderr)
        sys.exit(2)

    touch_list = contract.get("touch_list", {})
    declared = set()
    for category in ("create", "modify", "delete"):
        for f in touch_list.get(category, []):
            if f.strip():
                declared.add(f.strip())

    base = base_ref()
    actual = changed_files(base)

    # Always exclude the change meta-directory for this branch
    change_dir = f"changes/{branch}/"
    actual = {f for f in actual if not f.startswith(change_dir)}

    unexpected = sorted(actual - declared)
    unlisted = sorted(declared - actual)

    if unexpected:
        print("FAIL — changed but not declared in touch_list:")
        for f in unexpected:
            print(f"  + {f}")

    if unlisted:
        print("WARN — declared in touch_list but not changed:")
        for f in unlisted:
            print(f"  ? {f}")

    if not unexpected and not unlisted:
        print(f"OK — {len(actual)} file(s) changed, all declared")
    elif not unexpected:
        print(f"OK — no undeclared changes ({len(unlisted)} declared file(s) not yet touched)")

    sys.exit(1 if unexpected else 0)


if __name__ == "__main__":
    main()
