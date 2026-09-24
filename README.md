# テスト戦略とシナリオ設計

対象リポジトリを調査し、品質リスクをテスト戦略、プログラム境界シナリオ、E2Eシナリオ、探索的テスト計画へ具体化するClaude Code／Codex両対応プラグインリポジトリです。

## 公開スキル

| スキル | 完了状態 |
|---|---|
| `design-test-strategy` | 品質リスク、テストレベル、Small・Medium・Large、テストダブルの境界、重複排除、境界シナリオ方針、設計資料の点検、CI順序を一つの戦略資料へ保存する |
| `design-api-test-scenarios` | APIを含むプログラム境界について、具体入力、事前状態、観測結果、担当レベル、意図した省略を持つシナリオ資料を保存する |
| `design-e2e-test-scenarios` | 重要価値経路について、実構成で確かめる接続、完了条件、最終観測、下位で繰り返さない項目を持つE2Eシナリオ資料を保存する |
| `plan-exploratory-testing` | 自動テスト後の残余リスクへ探索を配分し、発見を再現可能な手順、自動チェック、TDDによる修正へ渡す計画を保存する |

## 方針

- 古典派とドメイン中心を既定にする
- 制御可能なDB、キャッシュ、メッセージング、ローカルサービスは実物を優先する
- テストピラミッドを重複削減の判断規則として使う
- 探索や運用で見つかった欠陥を、再現できる最小の担当レベルへ下げてから自動チェックへする
- Small・Medium・Largeを依存範囲で分類する
- 業務知識やデータモデルをテストケース集にせず、意味を説明する最小例とテスト設計を分ける
- API、CLI、イベント、ジョブなどの境界がある場合だけ、具体的な入力区分、状態系列、観測結果、テスト配分を持つ境界シナリオを扱う

性能とセキュリティの詳細戦略、探索の実行、テストコード実装、バグ修正は別の仕事として扱います。

## 配布構造

- marketplace: `testing-strategy`
- package: `testing-strategy`
- version: `1.1.0`
- public skills: `design-test-strategy`、`design-api-test-scenarios`、`design-e2e-test-scenarios`、`plan-exploratory-testing`
- internal skill: `map-test-coverage`
- external playbooks: `grill/grill` v1、`write-doc/write-doc` v2

## 検証

```bash
bash scripts/validate.sh
```

構造検査の成功は、戦略内容の妥当性を証明しません。主要な利用場面、責務外の依頼、分類が切り替わる境界は、`evals/scenarios.json`を使って人が意味評価します。

## このpackageが持つ判断

`testing-strategy` は、品質リスクをどのテストレベルとサイズ（Small・Medium・Large）で確かめ、どこへ重複させないかという配分の判断を持つ。CIがローカルの完了判定と同じ検査の集合を走らせること、E2Eへ残す経路と下位へ移す欠陥、外部サービスの公式テスト経路と共有の外部環境の扱い、境界シナリオと探索的テストの計画もここで決める。どの境界をテストで差し替えてよいかの具体、BDD IDの文法とテストへの転記は持たず、それぞれの持ち主の規約に従う。
