#!/usr/bin/env python3
import argparse
import json
import os
import re
import sys
from datetime import datetime
from typing import Any, Dict, List

ALLOWED_CATEGORIES = {
    "coding",
    "tooling",
    "workflow",
    "debugging",
    "ops",
    "design",
    "security",
    "testing",
    "product",
    "other",
}
MAX_ITEMS = 5
CONFIDENCE = {"high", "medium", "low"}


def normalize_category(raw: str) -> str:
    category = raw.strip().lower()
    if category in ALLOWED_CATEGORIES:
        return category
    if category.startswith("proposed:"):
        suffix = category[len("proposed:") :].strip()
        suffix = re.sub(r"[^a-z0-9_-]+", "-", suffix).strip("-")
        if suffix:
            return f"proposed:{suffix}"
    return "other"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Save cross-project knowledge entries into ~/dotfiles/ai-memory/knowledge"
    )
    parser.add_argument(
        "--max-items",
        type=int,
        default=MAX_ITEMS,
        help=f"Maximum entries to save from input (default: {MAX_ITEMS})",
    )
    return parser.parse_args()


def read_entries_from_stdin() -> List[Dict[str, Any]]:
    payload = sys.stdin.read().strip()
    if not payload:
        raise ValueError("No input. Pass a JSON array via stdin.")
    try:
        data = json.loads(payload)
    except json.JSONDecodeError as exc:
        raise ValueError(f"Invalid JSON: {exc}") from exc
    if not isinstance(data, list):
        raise ValueError("Input JSON must be an array of entry objects.")
    entries: List[Dict[str, Any]] = []
    for item in data:
        if isinstance(item, dict):
            entries.append(item)
    if not entries:
        raise ValueError("No valid entry objects found in JSON array.")
    return entries


def normalize_entry(entry: Dict[str, Any]) -> Dict[str, str]:
    category = normalize_category(str(entry.get("category", "other")))
    title = str(entry.get("title", "")).strip() or "Untitled insight"
    context = str(entry.get("context", "")).strip() or "General conversation"
    insight = str(entry.get("insight", "")).strip()
    action = str(entry.get("action", "")).strip() or "Re-check and apply when relevant."
    confidence = str(entry.get("confidence", "medium")).strip().lower()
    if confidence not in CONFIDENCE:
        confidence = "medium"
    if not insight:
        insight = "No explicit insight provided."
    return {
        "category": category,
        "title": title,
        "context": context,
        "insight": insight,
        "action": action,
        "confidence": confidence,
    }


def append_entry(path: str, entry: Dict[str, str]) -> None:
    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    block = (
        f"\n### {ts}\n"
        f"- title: {entry['title']}\n"
        f"- context: {entry['context']}\n"
        f"- insight: {entry['insight']}\n"
        f"- action: {entry['action']}\n"
        f"- confidence: {entry['confidence']}\n"
    )
    with open(path, "a", encoding="utf-8") as f:
        f.write(block)


def ensure_category_file(path: str, category: str) -> None:
    if os.path.exists(path):
        return
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"# {category}\n")


def append_proposal(base_dir: str, category: str, title: str) -> None:
    if not category.startswith("proposed:"):
        return
    proposals_path = os.path.join(base_dir, "_proposals.md")
    ts = datetime.now().strftime("%Y-%m-%d %H:%M")
    if not os.path.exists(proposals_path):
        with open(proposals_path, "w", encoding="utf-8") as f:
            f.write("# category proposals\n")
    with open(proposals_path, "a", encoding="utf-8") as f:
        f.write(f"\n- {ts} {category} ({title})\n")


def main() -> int:
    args = parse_args()
    try:
        entries = read_entries_from_stdin()
    except ValueError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 2

    base_dir = os.path.expanduser("~/dotfiles/ai-memory/knowledge")
    os.makedirs(base_dir, exist_ok=True)

    saved = 0
    max_items = max(1, args.max_items)
    for raw in entries[:max_items]:
        entry = normalize_entry(raw)
        category = entry["category"]
        file_category = category.replace("proposed:", "")
        path = os.path.join(base_dir, f"{file_category}.md")
        ensure_category_file(path, file_category)
        append_entry(path, entry)
        append_proposal(base_dir, category, entry["title"])
        saved += 1

    print(f"Saved {saved} knowledge entries into {base_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
