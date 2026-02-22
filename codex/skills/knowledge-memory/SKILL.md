---
name: knowledge-memory
description: /reflect で直近会話から横断知識を抽出し、~/dotfiles/ai-memory/knowledge にカテゴリ保存する。
---

# Knowledge Memory

## 概要
`~/dotfiles/ai-memory/knowledge` にプロジェクト横断の知識を蓄積する。
`/reflect` で再利用可能な知見を抽出し、カテゴリ別ファイルへ保存する。

## コマンド
- `/reflect <テキスト...>`
- `/reflect`（テキスト省略可）

## カテゴリ方針
優先カテゴリ:
- `coding`
- `tooling`
- `workflow`
- `debugging`
- `ops`
- `design`
- `security`
- `testing`
- `product`
- `other`

該当なしの場合は `proposed:<name>` を提案カテゴリとして扱う。

## 保存フロー
`/reflect` 実行時:
1) `<テキスト...>` があれば使用し、なければ直近会話を要約して使う。
2) 知見を最大5件抽出する（削りすぎない）。
3) 各知見を JSON オブジェクト化する。
   - `category`
   - `title`
   - `context`
   - `insight`
   - `action`
   - `confidence`（`high`/`medium`/`low`）
4) JSON 配列を stdin で `reflect_save.py` に渡して保存する。

実行例:

```bash
printf '%s\n' '<JSON_ARRAY>' | python3 ~/dotfiles/codex/skills/knowledge-memory/scripts/reflect_save.py
```

## 自動参照フロー
実装・レビュー・デバッグなどの前に:
1) 現在依頼を1行で要約する。
2) `knowledge_lookup.py --task "<要約>"` を実行する。
3) 返却された知見を実行方針に反映する。

実行例:

```bash
python3 ~/dotfiles/codex/skills/knowledge-memory/scripts/knowledge_lookup.py --task "<request>"
```
