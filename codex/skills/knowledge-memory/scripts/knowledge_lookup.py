#!/usr/bin/env python3
import argparse
import os
import re
from typing import Dict, List, Set

KEYWORDS: Dict[str, List[str]] = {
    "debugging": ["error", "bug", "fail", "failing", "trace", "exception", "落ち", "エラー", "不具合"],
    "testing": ["test", "pytest", "unit", "integration", "e2e", "テスト"],
    "tooling": ["cli", "shell", "zsh", "git", "docker", "tool", "ツール"],
    "coding": ["implement", "refactor", "function", "class", "api", "実装", "コード"],
    "workflow": ["process", "flow", "手順", "進め方", "運用", "workflow"],
    "ops": ["deploy", "infra", "incident", "monitor", "運用", "障害"],
    "design": ["design", "ui", "ux", "設計"],
    "security": ["security", "auth", "token", "secret", "脆弱", "認証", "権限"],
    "product": ["requirement", "scope", "spec", "要件", "仕様", "機能"],
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Lookup relevant cross-project knowledge by task text."
    )
    parser.add_argument("--task", required=True, help="Current task/request text")
    parser.add_argument(
        "--limit",
        type=int,
        default=2,
        help="Number of recent entries per category (default: 2)",
    )
    return parser.parse_args()


def infer_categories(task: str) -> List[str]:
    task_l = task.lower()
    matched: Set[str] = set()
    for category, patterns in KEYWORDS.items():
        for p in patterns:
            if p.lower() in task_l:
                matched.add(category)
                break
    if not matched:
        matched.add("other")
    return sorted(matched)


def read_recent_blocks(path: str, limit: int) -> List[str]:
    if not os.path.exists(path):
        return []
    with open(path, "r", encoding="utf-8") as f:
        content = f.read().strip()
    if not content:
        return []
    blocks = re.split(r"\n(?=###\s)", content)
    entries = [b.strip() for b in blocks if b.strip().startswith("### ")]
    if limit <= 0:
        return entries
    return entries[-limit:]


def main() -> int:
    args = parse_args()
    categories = infer_categories(args.task)
    base_dir = os.path.expanduser("~/ai-memory/knowledge")

    print(f"task: {args.task}")
    print(f"categories: {', '.join(categories)}")

    found_any = False
    for category in categories:
        path = os.path.join(base_dir, f"{category}.md")
        blocks = read_recent_blocks(path, args.limit)
        if not blocks:
            continue
        found_any = True
        print(f"\n## {category}")
        for block in blocks:
            print(block)

    if not found_any:
        print("\nNo relevant knowledge entries found.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
