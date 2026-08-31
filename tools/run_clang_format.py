#!/usr/bin/env python3
"""
Run clang-format on C++ source files.

Usage: python3 tools/run_clang_format.py [--check]
  --check : Only check formatting without modifying files
  --resolve : Print the selected major-22 executable and exit
"""

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

EXPECTED_MAJOR_VERSION = 22


def find_clang_format():
    """Find clang-format executable."""
    paths = [
        "clang-format-22",
        "/usr/bin/clang-format-22",
        "/usr/local/bin/clang-format-22",
        "/opt/homebrew/bin/clang-format-22",
        "clang-format",
        "/usr/bin/clang-format",
        "/usr/local/bin/clang-format",
        "/opt/homebrew/bin/clang-format",
        "C:\\Program Files\\LLVM\\bin\\clang-format.exe",
    ]
    rejected = []
    checked = set()

    for path in paths:
        executable = path if os.path.isabs(path) else shutil.which(path)
        if executable and executable not in checked and os.path.isfile(executable):
            checked.add(executable)
            try:
                result = subprocess.run(
                    [executable, "--version"], capture_output=True, text=True, timeout=5
                )
            except (OSError, subprocess.SubprocessError) as exc:
                rejected.append(f"{executable}: {exc}")
                continue

            output = f"{result.stdout}\n{result.stderr}"
            version_match = re.search(
                r"\bversion\s+(\d+(?:\.\d+){1,2})\b", output
            )
            if result.returncode != 0:
                rejected.append(f"{executable}: version check failed")
            elif not version_match:
                rejected.append(f"{executable}: unrecognized version output")
            else:
                version = version_match.group(1)
                major_version = int(version.split(".", 1)[0])
                if major_version == EXPECTED_MAJOR_VERSION:
                    return executable
                rejected.append(f"{executable}: reports version {version}")

    if rejected:
        details = "; ".join(rejected)
        print(
            "Error: clang-format major version "
            f"{EXPECTED_MAJOR_VERSION} is required; rejected candidates: {details}",
            file=sys.stderr,
        )
    else:
        print(
            "Error: clang-format major version "
            f"{EXPECTED_MAJOR_VERSION} is required, but no executable was found.",
            file=sys.stderr,
        )
    sys.exit(1)


def find_source_files():
    """Find all C++ source files in src/ and modules/ directories."""
    files = []
    for directory in ["src", "modules"]:
        if os.path.exists(directory):
            for ext in ["*.cpp", "*.h"]:
                files.extend(Path(directory).rglob(ext))
    return sorted(files)


def main():
    if "--resolve" in sys.argv:
        print(find_clang_format())
        return

    check_only = "--check" in sys.argv

    clang_format = find_clang_format()
    print(f"Using: {clang_format}")

    if not os.path.isfile(".clang-format"):
        print("Error: Run from repository root (where .clang-format exists)")
        sys.exit(1)

    files = find_source_files()
    print(f"Processing {len(files)} files...")

    failed = 0
    for file_path in files:
        if check_only:
            cmd = [
                clang_format,
                "--style=file",
                "--dry-run",
                "--Werror",
                str(file_path),
            ]
        else:
            cmd = [clang_format, "--style=file", "-i", str(file_path)]

        result = subprocess.run(cmd, capture_output=True)
        if result.returncode != 0:
            failed += 1
            print(f"Failed: {file_path}")

    if failed == 0:
        print("All files are properly formatted.")
    else:
        print(f"{failed} files failed formatting check.")
        sys.exit(1)


if __name__ == "__main__":
    main()
