#!/usr/bin/env python3
"""Prompt safety scanner for .prompt.md files.

Fails CI when high-risk command patterns are detected.
"""

from __future__ import annotations

import pathlib
import re
import sys
from dataclasses import dataclass


@dataclass(frozen=True)
class Rule:
    name: str
    pattern: re.Pattern[str]
    reason: str


RULES = [
    Rule(
        name="destructive_root_delete",
        pattern=re.compile(r"(^|\s)(sudo\s+)?rm\s+-rf\s+/(\s|$)", re.IGNORECASE),
        reason="Destructive command can wipe the system.",
    ),
    Rule(
        name="pipe_remote_to_shell",
        pattern=re.compile(
            r"\b(curl|wget)\b[^\n\r|>]*\|\s*(sh|bash|zsh|pwsh|powershell)\b",
            re.IGNORECASE,
        ),
        reason="Piping remote content directly into a shell is unsafe.",
    ),
    Rule(
        name="dangerous_eval",
        pattern=re.compile(r"\b(Invoke-Expression|IEX)\b", re.IGNORECASE),
        reason="Dynamic command evaluation can hide malicious behavior.",
    ),
    Rule(
        name="base64_execute",
        pattern=re.compile(
            r"base64\s+(-d|--decode)[^\n\r|>]*\|\s*(sh|bash|zsh|pwsh|powershell)\b",
            re.IGNORECASE,
        ),
        reason="Decoded payload execution is high-risk obfuscation.",
    ),
    Rule(
        name="reverse_shell_netcat",
        pattern=re.compile(r"\bnc\b[^\n\r]*\s-e\s", re.IGNORECASE),
        reason="Netcat with -e is commonly used for reverse shells.",
    ),
    Rule(
        name="raw_disk_write",
        pattern=re.compile(r"\bdd\s+if=.*\s+of=/dev/", re.IGNORECASE),
        reason="Raw device writes can destroy data.",
    ),
    Rule(
        name="filesystem_format",
        pattern=re.compile(r"\bmkfs(\.[A-Za-z0-9_]+)?\b", re.IGNORECASE),
        reason="Filesystem formatting is destructive.",
    ),
]


def scan_file(file_path: pathlib.Path) -> list[str]:
    issues: list[str] = []
    lines = file_path.read_text(encoding="utf-8", errors="replace").splitlines()
    for i, line in enumerate(lines, start=1):
        for rule in RULES:
            if rule.pattern.search(line):
                issues.append(
                    f"{file_path.as_posix()}:{i}: [{rule.name}] {rule.reason} | line: {line.strip()}"
                )
    return issues


def main() -> int:
    root = pathlib.Path(__file__).resolve().parents[1]
    prompt_files = sorted(root.glob("*.prompt.md"))

    if not prompt_files:
        print("No .prompt.md files found. Nothing to scan.")
        return 0

    all_issues: list[str] = []
    for prompt_file in prompt_files:
        all_issues.extend(scan_file(prompt_file))

    if all_issues:
        print("Prompt safety scan failed. High-risk patterns detected:\n")
        for issue in all_issues:
            print(f"- {issue}")
        print("\nResolve or remove these patterns before merging.")
        return 1

    print(f"Prompt safety scan passed for {len(prompt_files)} prompt files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
