> 作業を始める前に、workspace正本入口 `/Users/naoya-nakamoriq/Documents/Github/harness-pluginsv2/AGENTS.md` を読み、そこから指定される共通規約とこのrepository固有の規則を適用する。

# AGENTS.md

このrepositoryは、対象リポジトリのコード、設計資料、既存テスト、CIを調べ、品質リスクからリポジトリ全体のテスト戦略を作るmarketplaceである。

- marketplaceへ公開するインストール対象は`testing-strategy` package 1件、公開入口は`plugins/testing-strategy/skills/design-test-strategy/` 1件とする。内部skillは持たない。
- 公開入口は戦略資料を1本作る。テストコード、CI設定、境界シナリオ全件、性能・セキュリティ・探索的テストの詳細戦略は作らない。
- 古典派を既定とし、対象リポジトリが制御できる協働先は実物を使う。テストダブルは外部APIなど決定的に制御できない境界、または利用者が合意した例外へ限定する。
- テストピラミッドは件数比率ではなく、同じ欠陥をより小さな境界へ移す判断規則として使う。Small・Medium・Largeは時間だけでなく依存範囲で分類する。
- 利用者へ問う場面は公開playbook `grill`へ委ねる。成果物の保存は公開playbook `write-doc`へ委ねる。両者の内部実装へ依存しない。
- 対象リポジトリ固有の値、層名、保存先、テストフレームワーク、時間上限を既定値として埋め込まない。
- 変更後は`bash scripts/validate.sh`と、workspace rootの`bash scripts/validate.sh <このrepositoryの絶対path>`を実行する。
