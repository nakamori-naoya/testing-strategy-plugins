> 作業を始める前に、workspace正本入口 `/Users/naoya-nakamoriq/Documents/Github/harness-pluginsv2/AGENTS.md` を読み、そこから指定される共通規約とこのrepository固有の規則を適用する。

# AGENTS.md

このrepositoryは、対象リポジトリのコード、設計資料、既存テスト、CIを調べ、品質リスクからリポジトリ全体のテスト戦略、プログラム境界シナリオ、E2Eシナリオ、探索的テスト計画を作るmarketplaceである。

- marketplaceへ公開するインストール対象は`testing-strategy` package 1件とする。
- package manifestは`design-test-strategy`、`design-api-test-scenarios`、`design-e2e-test-scenarios`、`plan-exploratory-testing`の自己完結skill 4件を直接公開する。
- 4入口のうち後者3入口が共有する、品質リスク、既存の検証証拠、残余リスク、欠陥を再現できる最小の担当レベルを対応付ける判断は、内部skill `map-test-coverage`が所有する。
- 各公開入口は資料を1本作る。テストコード、CI設定、探索の実行、バグ修正、性能・セキュリティの詳細戦略は作らない。探索的テスト計画は、発見を再現可能な手順、自動チェック、TDDによる修正へ渡す条件までを所有する。
- 古典派を既定とし、対象リポジトリが制御できる協働先は実物を使う。テストダブルは外部APIなど決定的に制御できない境界、または利用者が合意した例外へ限定する。
- テストピラミッドは件数比率ではなく、同じ欠陥をより小さな境界へ移す判断規則として使う。Small・Medium・Largeは時間だけでなく依存範囲で分類する。
- 探索または運用で見つかった欠陥は、発見時の高水準な操作をそのまま固定せず、同じ失敗を再現できる最小の担当レベルへ下げて自動チェックへ渡す。
- 利用者へ問う場面は公開playbook `grill`へ委ねる。成果物の保存は公開playbook `write-doc`へ委ねる。両者の内部実装へ依存しない。
- 対象リポジトリ固有の値、層名、保存先、テストフレームワーク、時間上限を既定値として埋め込まない。
- 変更後は`bash scripts/validate.sh`と、workspace rootの`bash scripts/validate.sh <このrepositoryの絶対path>`を実行する。
