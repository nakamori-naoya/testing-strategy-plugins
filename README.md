# テスト戦略設計

対象リポジトリを調査し、利用者と品質リスクを合意したうえで、リポジトリ全体のテスト戦略をMarkdown正本として保存するClaude Code／Codex両対応プラグインリポジトリです。

## 公開スキル

| スキル | 完了状態 |
|---|---|
| `design-test-strategy` | 品質リスク、テストレベル、Small・Medium・Large、テストダブルの境界、重複排除、境界シナリオ方針、設計資料の点検、CI順序を一つの戦略資料へ保存する |

## 方針

- 古典派とドメイン中心を既定にする
- 制御可能なDB、キャッシュ、メッセージング、ローカルサービスは実物を優先する
- テストピラミッドを重複削減の判断規則として使う
- Small・Medium・Largeを依存範囲で分類する
- 業務知識やデータモデルをテストケース集にせず、意味を説明する最小例とテスト設計を分ける
- API、CLI、イベント、ジョブなどの境界がある場合だけ、具体的な入力区分、状態系列、観測結果、テスト配分を持つ境界シナリオを扱う

性能、セキュリティ、探索的テストの詳細戦略と、一変更ごとの境界・E2Eシナリオ設計は別の仕事として扱います。

## 配布構造

- marketplace: `testing-strategy`
- package: `testing-strategy`
- version: `1.0.0`
- public skill: `design-test-strategy`
- external playbooks: `grill/grill` v1、`write-doc/write-doc` v2

## 検証

```bash
bash scripts/validate.sh
```

構造検査の成功は、戦略内容の妥当性を証明しません。主要な利用場面、責務外の依頼、分類が切り替わる境界は、`evals/scenarios.json`を使って人が意味評価します。
