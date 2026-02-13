---
description: 直近会話を振り返って横断ナレッジに保存
argument-hint: テキスト=<任意>
---
knowledge-memory の手順で知見を保存する。

ルール:
1. `テキスト` があれば優先し、なければ直近会話を使う。
2. 実務で再利用できる知見を最大5件抽出する。
3. カテゴリは `coding/tooling/workflow/debugging/ops/design/security/testing/product/other` を優先する。
4. 既存カテゴリで合わない場合は `proposed:<name>` を使う。
5. 各項目は `category/title/context/insight/action/confidence` を持つ JSON 配列にする。
6. 次のコマンドで保存する:
   `printf '%s\n' '<JSON_ARRAY>' | python3 ~/dotfiles/codex/skills/knowledge-memory/scripts/reflect_save.py`
