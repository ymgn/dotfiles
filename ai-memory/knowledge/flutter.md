# flutter

### 2026-02-15 18:26
- title: Flutter実装は将来Qiitaのベストプラクティス準拠へ移行する
- context: ユーザー指示: https://qiita.com/softbase/items/401d574a44a7b947b275 のベストプラクティスを将来的に採用する
- insight: 現段階はMVP優先だが、今後の実装はClean Architecture/MVVM、Riverpod、適切な責務分離を前提に進める必要がある
- action: 次回以降のFlutter実装で、まず構成分離（presentation/domain/data）と状態管理方針をベストプラクティスに合わせて設計する
- confidence: high

### 2026-02-15 18:26
- title: Flutter関連のコメント・README・コミットメッセージは日本語で統一する
- context: ユーザー指示: コミットメッセージ、README、コード内コメントを日本語で運用
- insight: ドキュメントと言語方針の統一により、運用時の認識齟齬を減らせる
- action: 今後の変更では日本語文言で記述し、英語文言が混在した場合は同バッチで修正する
- confidence: high
