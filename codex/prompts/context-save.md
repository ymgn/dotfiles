---
description: 共有コンテキスト記憶を保存
argument-hint: キーワード=<任意>
---
context-memory の手順で記憶を保存する。

ルール:
1. 基本は引数なしで実行し、キーワードは自動推定する。
   - 優先: 現在ブランチ `feature/<キーワード>`
   - 代替: `~/ai-memory/*.md` の最終更新ファイル
2. キーワードが指定されていればそれを使う。
3. 保存本文は直近会話を十分な情報量で要約して作る。
4. 既存ファイルがあれば内容を先に読み出してから追記する。
5. ファイルがなければ作成し、概要は本文先頭の有意な1行から自動生成する。

実行例:
- 会話を要約して保存:
  `printf '%s\n' "<SUMMARY>" | python3 ~/dotfiles/codex/skills/context-memory/scripts/context_save.py <キーワード>`
