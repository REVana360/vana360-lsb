#!/usr/bin/env python3
"""Check contributed commit messages against the Vana360 fork contract."""

from __future__ import annotations

import argparse
import re
import subprocess


ALLOWED_TYPES = (
    "core",
    "lua",
    "sql",
    "content",
    "tools",
    "docs",
    "ci",
    "chore",
    "refactor",
    "test",
)
SUBJECT_RE = re.compile(r"^(" + "|".join(ALLOWED_TYPES) + r"): \S")


def lint(message: str) -> list[str]:
    errors: list[str] = []
    stripped = message.rstrip()
    lines = stripped.splitlines()
    if not lines or not lines[0].strip():
        return ["empty message"]
    subject = lines[0]
    if len(lines) != 1:
        errors.append("message must be one line")
    if not subject.isascii():
        errors.append("subject contains non-ASCII text")
    if len(subject) > 50:
        errors.append(f"subject exceeds 50 chars ({len(subject)})")
    if not SUBJECT_RE.match(subject):
        errors.append("subject has a missing or invalid type")
    if "(" in subject or ")" in subject:
        errors.append("subject contains parentheses")
    return errors


def commit_messages(target: str):
    result = subprocess.run(
        ["git", "rev-list", "--reverse", "--no-merges", f"{target}..HEAD"],
        capture_output=True,
        check=True,
        text=True,
    )
    for commit in result.stdout.splitlines():
        message = subprocess.run(
            ["git", "show", "-s", "--format=%B", commit],
            capture_output=True,
            check=True,
            text=True,
        ).stdout
        yield commit, message


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("target")
    args = parser.parse_args()

    failed = False
    for commit, message in commit_messages(args.target):
        errors = lint(message)
        if errors:
            failed = True
            subject = message.rstrip().splitlines()[0] if message.rstrip() else ""
            print(f"#### Error in commit {commit}")
            print(f"```\n{subject}\n```")
            for error in errors:
                print(f"- {error}")
            print()
    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())
