---
name: context-memory
description: /context-save と /context-load で共有コンテキスト記憶を扱う。~/ai-memory 配下で複数エージェントが参照できるようにする。
---

# Context Memory

## 概要
`~/ai-memory` にキーワード単位の共有記憶を保持する。
slash 形式コマンドでプロジェクト文脈や作業ログを保存・読込する。

## コマンド解釈
以下は通常質問ではなく明示コマンドとして扱う:

- `/context-save <キーワード>` (任意)
- `/context-save` (現在ブランチが `feature/<キーワード>` の場合)
- `/context-load <キーワード>`

解釈ルール:
- `<キーワード>` は指定された場合の先頭トークン。
- 保存本文は直近会話を十分な情報量で要約して生成する。
- `<キーワード>` は日本語可。`/` と空値は拒否する。
- `<キーワード>` 省略時は以下順で解決する。
  1) 現在ブランチ `feature/<キーワード>`
  2) `~/ai-memory/*.md` の最終更新ファイル

## 記憶構造
キーワードごとに単一 Markdown ファイルで保存する。

```text
~/ai-memory/<キーワード>.md
```

ファイル形式:

```markdown
# <キーワード>

## 概要
<初回要約>

## ログ
### YYYY-MM-DD HH:MM
- 実施内容:
  - ...
```

## 保存フロー
`/context-save` 実行時:
1) 任意の `<キーワード>` を解釈する。
2) `<キーワード>` がない場合はブランチまたは最新記憶から推定する。
3) 対象ファイルがある場合は先に読み出して表示する。
4) 本文は直近会話を十分な情報量で要約して作る。
5) 対象ファイルがない場合は作成し、`## 概要` は本文先頭の有意な1行で自動生成する。
6) タイムスタンプ付きでログ追記する。

実行例:

```bash
printf '%s\n' "<SUMMARY>" | python3 ~/dotfiles/codex/skills/context-memory/scripts/context_save.py <キーワード>
```

補足:
- `--overview` は任意。未指定時は本文から自動生成される。
- 既存ファイルは `## 概要` を維持してログのみ追記する。
- `<キーワード>` は省略可能。

## 読込フロー
`/context-load` 実行時:
1) `<キーワード>` を解釈する。
2) `~/ai-memory/<キーワード>.md` を読み込む。
3) 作業再開しやすい形で簡潔に提示する。

実行例:

```bash
python3 ~/dotfiles/codex/skills/context-memory/scripts/context_load.py <キーワード>
```

互換性:
- 旧形式 `~/ai-memory/<キーワード>/{spec,decisions,next,log}.md` も読込可能。

## リソース

### scripts/
- `context_save.py`: `~/ai-memory/<キーワード>.md` の作成とタイムスタンプ付き追記を行う。
- `context_load.py`: 新形式を優先読込し、必要なら旧形式をフォールバックで読む。
