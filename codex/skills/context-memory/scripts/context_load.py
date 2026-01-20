#!/usr/bin/env python3
import os
import sys

def read_if_exists(path: str) -> str:
    if not os.path.exists(path):
        return ""
    with open(path, "r", encoding="utf-8") as f:
        return f.read().rstrip() + "\n"

def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: context_load.py <CASE-ID>", file=sys.stderr)
        return 2

    case_id = sys.argv[1].strip()
    if not case_id:
        print("Error: CASE-ID is required", file=sys.stderr)
        return 2

    base_dir = os.path.expanduser("~/ai-memory")
    case_dir = os.path.join(base_dir, case_id)
    if not os.path.isdir(case_dir):
        print(f"No memory found for {case_id} at {case_dir}")
        return 1

    parts = []
    for name in ["spec.md", "decisions.md", "next.md", "log.md"]:
        content = read_if_exists(os.path.join(case_dir, name))
        if content:
            parts.append(content)

    output = "\n".join(parts).strip()
    if output:
        print(output)
    else:
        print(f"Memory exists for {case_id} but files are empty")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
