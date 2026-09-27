# 期待する判定

この較正の資料は、2026-09-27 の1回目の実行（claude plugin eval、`--runs 1 --ablation none`）で作られた `out/test-strategy.md` と `grill-log/test-strategy.md` である。下の判定は、eval を組んだ担当が資料、記録、要件、設計資料を読んで出したもので、採点役がこれを再現できるかで採点の形を確かめる。境目と書いた条件は、読み方で判定が分かれうるので、一致の数を別に数える。採点役には、このファイルを読ませない。

## 判定

- fact-observed-only: PASS
- fact-hypothesis-marked: PASS
- double-only-uncontrollable: PASS
- level-smallest-boundary: PASS
- size-by-resources: PASS
- risk-from-failures: PASS
- risk-concurrency-deterministic: PASS
- owner-documents-not-rewritten: PASS
- owner-ci-same-entry: PASS
- owner-separate-areas: PASS
- shape-prose: PASS
- grill-only-strategy-changing: PASS（境目）
- xs-internal-stores-real: PASS
- xs-async-reflection: PASS
- xs-concurrent-rules: PASS
- xs-docs-no-code-yet: PASS

## 理由

現状の節は、コード、テスト、CI、docker compose の定義が無いことを観測した事実として書き、要件にある「現在の実装」の記述も観測した現状ではなく設計の意図として扱っている。差し替えるのは Clerk、時計、ポストIDの発行だけで、PostgreSQL、2用途の Redis、Pub/Sub エミュレーターは実物を使う。同時実行は、実行順を明示的に作るかバリアで固定する。

grill-only-strategy-changing は、問い1（切り離す品質領域）のうち性能を切り離すことが要件から決まると記録自身が書いているので、資料から決まることを問うたと読めば FAIL になりうる。セキュリティ診断と探索の切り離しは資料から決まらず、問いの全体は戦略を変えるので、境目とした。
