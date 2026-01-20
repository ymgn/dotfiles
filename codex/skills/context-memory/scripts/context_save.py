#!/usr/bin/env python3
import os
import sys
from datetime import datetime

def ensure_file(path: str, header: str) -> None:
    if not os.path.exists(path):
        with open(path, "w", encoding="utf-8") as f:
            f.write(header.rstrip() + "\n")

def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: context_save.py <CASE-ID> [TEXT...]", file=sys.stderr)
        return 2

    case_id = sys.argv[1].strip()
    if not case_id:
        print("Error: CASE-ID is required", file=sys.stderr)
        return 2

    text = " ".join(sys.argv[2:]).strip()
    if not text:
        stdin_text = sys.stdin.read().strip()
        text = stdin_text

    if not text:
        print("Error: no text provided", file=sys.stderr)
        return 2

    base_dir = os.path.expanduser("~/ai-memory")
    case_dir = os.path.join(base_dir, case_id)
    os.makedirs(case_dir, exist_ok=True)

    ensure_file(os.path.join(case_dir, "spec.md"), "# Spec")
    ensure_file(os.path.join(case_dir, "decisions.md"), "# Decisions")
    ensure_file(os.path.join(case_dir, "next.md"), "# Next")
    log_path = os.path.join(case_dir, "log.md")
    ensure_file(log_path, "# Log")

    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    with open(log_path, "a", encoding="utf-8") as f:
        f.write(f"\n## {ts}\n{text}\n")

    print(f"Saved log entry to {log_path}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
