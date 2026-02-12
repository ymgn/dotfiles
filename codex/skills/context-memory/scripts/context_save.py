#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
from datetime import datetime

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


def memory_path(base_dir: str, keyword: str) -> str:
    return os.path.join(base_dir, f"{keyword}.md")


def detect_keyword_from_branch() -> str:
    try:
        proc = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            check=False,
            capture_output=True,
            text=True,
        )
    except OSError:
        return ""

    if proc.returncode != 0:
        return ""

    branch = proc.stdout.strip()
    prefix = "feature/"
    if not branch.startswith(prefix):
        return ""

    candidate = branch[len(prefix) :].strip()
    if not candidate:
        return ""
    return candidate


def detect_latest_keyword(base_dir: str) -> str:
    latest_path = ""
    latest_mtime = -1.0
    try:
        names = os.listdir(base_dir)
    except OSError:
        return ""
    for name in names:
        if not name.endswith(".md"):
            continue
        if name.startswith("."):
            continue
        path = os.path.join(base_dir, name)
        if not os.path.isfile(path):
            continue
        try:
            mtime = os.path.getmtime(path)
        except OSError:
            continue
        if mtime > latest_mtime:
            latest_mtime = mtime
            latest_path = path
    if not latest_path:
        return ""
    return os.path.basename(latest_path)[:-3]


def create_memory_file(path: str, keyword: str, overview: str) -> None:
    content = (
        f"# {keyword}\n\n"
        "## 概要\n"
        f"{overview.strip()}\n\n"
        "## ログ\n"
    )
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


def format_text_block(label: str, text: str) -> str:
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if not lines:
        return f"- {label}: なし\n"
    body = "\n".join(f"  - {line}" for line in lines)
    return f"- {label}:\n{body}\n"


def append_log(path: str, text: str) -> None:
    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    section = f"\n### {ts}\n{format_text_block('実施内容', text)}"
    with open(path, "a", encoding="utf-8") as f:
        f.write(section)


def load_existing_memory(path: str) -> str:
    if not os.path.isfile(path):
        return ""
    with open(path, "r", encoding="utf-8") as f:
        return f.read().rstrip()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Save context memory entry to ~/ai-memory/<KEYWORD>.md"
    )
    parser.add_argument(
        "keyword",
        nargs="?",
        default="",
        help="Memory keyword. If omitted, feature/<KEYWORD> branch is used.",
    )
    parser.add_argument(
        "text",
        nargs="*",
        help="Log text. If omitted, stdin is used.",
    )
    parser.add_argument(
        "--overview",
        default="",
        help="Overview text used when creating memory file for the first time.",
    )
    return parser.parse_args()


def build_overview(text: str, explicit_overview: str) -> str:
    if explicit_overview.strip():
        return explicit_overview.strip()
    for line in text.splitlines():
        line = line.strip()
        if line:
            return line[:120]
    return "概要未設定"


def main() -> int:
    args = parse_args()
    base_dir = os.path.expanduser("~/ai-memory")
    os.makedirs(base_dir, exist_ok=True)

    raw_keyword = args.keyword.strip()
    if not raw_keyword:
        raw_keyword = detect_keyword_from_branch()
        if not raw_keyword:
            raw_keyword = detect_latest_keyword(base_dir)
        if not raw_keyword:
            print("Error: KEYWORD could not be inferred. Pass KEYWORD once.", file=sys.stderr)
            return 2

    try:
        keyword = normalize_keyword(raw_keyword)
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 2

    text = " ".join(args.text).strip()
    if not text:
        text = sys.stdin.read().strip()
    if not text:
        print("Error: no text provided", file=sys.stderr)
        return 2

    path = memory_path(base_dir, keyword)
    existing = load_existing_memory(path)

    if existing:
        print(f"Loaded existing memory from {path}")
        print(existing)

    if not os.path.exists(path):
        overview = build_overview(text, args.overview)
        create_memory_file(path, keyword, overview)

    append_log(path, text)
    print(f"Saved log entry to {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
