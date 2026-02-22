#!/usr/bin/env python3
import os
import sys

INVALID_KEYWORDS = {".", ".."}


def normalize_keyword(raw: str) -> str:
    keyword = raw.strip()
    if not keyword:
        raise ValueError("KEYWORD is required")
    if "/" in keyword or "\x00" in keyword:
        raise ValueError("KEYWORD must not contain '/' or NUL")
    if keyword in INVALID_KEYWORDS:
        raise ValueError("KEYWORD must not be '.' or '..'")
    return keyword


def read_if_exists(path: str) -> str:
    if not os.path.exists(path):
        return ""
    with open(path, "r", encoding="utf-8") as f:
        return f.read().rstrip() + "\n"


def load_legacy(case_dir: str) -> str:
    parts = []
    for name in ["spec.md", "decisions.md", "next.md", "log.md"]:
        content = read_if_exists(os.path.join(case_dir, name))
        if content:
            parts.append(content)
    return "\n".join(parts).strip()


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: context_load.py <KEYWORD>", file=sys.stderr)
        return 2

    try:
        keyword = normalize_keyword(sys.argv[1])
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 2

    base_dir = os.path.expanduser("~/dotfiles/ai-memory")
    new_path = os.path.join(base_dir, f"{keyword}.md")
    if os.path.isfile(new_path):
        print(read_if_exists(new_path).strip())
        return 0

    legacy_dir = os.path.join(base_dir, keyword)
    if os.path.isdir(legacy_dir):
        output = load_legacy(legacy_dir)
        if output:
            print(output)
            return 0
        print(f"Legacy memory exists for {keyword} but files are empty")
        return 1

    print(
        f"No memory found for '{keyword}'. Use /context-save {keyword} to create it."
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
