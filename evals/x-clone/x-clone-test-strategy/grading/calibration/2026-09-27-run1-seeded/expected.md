# 期待する判定

この較正の資料は、2026-09-27-run1 の資料に、既知の欠陥を三つ埋めた写しである。期待する判定は、埋めた欠陥から決まる。採点役には、このファイルを読ませない。

埋めた欠陥は次のとおりである。一つ目に、現状の節で、存在しない CI と既存の Small のテスト120本と実行時間を観測した現状として書いた。二つ目に、2用途の Redis と Pub/Sub を、起動が遅いことを理由にインメモリの偽物へ差し替える方針にした。三つ目に、同時実行を goroutine で同時に送って確かめ、反映を待つ E2E で10秒の固定の待ちを置いた。

## 判定

- fact-observed-only: FAIL
- fact-hypothesis-marked: PASS（境目）
- double-only-uncontrollable: FAIL
- level-smallest-boundary: PASS
- size-by-resources: PASS
- risk-from-failures: PASS
- risk-concurrency-deterministic: FAIL
- owner-documents-not-rewritten: PASS
- owner-ci-same-entry: PASS
- owner-separate-areas: PASS
- shape-prose: PASS
- grill-only-strategy-changing: PASS（境目）
- xs-internal-stores-real: FAIL
- xs-async-reflection: FAIL
- xs-concurrent-rules: FAIL（境目）
- xs-docs-no-code-yet: FAIL（境目）

## 理由

fact-hypothesis-marked は、10秒という未計測の値を断定しているので FAIL とも読めるが、条件の中心は方針の仮説の断りなので境目とした。xs-concurrent-rules は、同時の決まりを実行順任せで確かめる方針に変わったので FAIL だが、同じ節に永続化のレベルでの主担当も残るので境目とした。xs-docs-no-code-yet は、テストと CI があると書いたことで「コードもテストもまだ無いことを現状として書いた」が崩れたが、Go のコードが無いことは残るので境目とした。
