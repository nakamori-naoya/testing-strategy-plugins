# テスト戦略とシナリオ設計

対象リポジトリを調べ、品質リスクをテスト戦略、プログラム境界のシナリオ、E2E シナリオ、探索的テストの計画へ具体化する、Claude Code と Codex の両方で使える plugin です。

`design-test-strategy` がリポジトリ全体の戦略を作り、最小の担当レベル、Small・Medium・Large、差し替えてよい境界をその戦略資料に定めます。`design-api-test-scenarios`、`design-e2e-test-scenarios`、`plan-exploratory-testing` は、その戦略資料を読んで、変更ごとの設計資料を作ります。三つが共有する進め方は、内部の `map-test-coverage` にあります。

性能とセキュリティの詳細な戦略、探索の実行、テストコードの実装、バグの修正は扱いません。

## 検証

```bash
bash scripts/validate.sh
```
