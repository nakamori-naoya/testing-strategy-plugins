# 期待する判定

この較正の資料は、2026-09-27 の1回目の実行（claude plugin eval、`--runs 1 --ablation none`）で作られた資料と grill の記録である。下の判定は、eval を組んだ担当が資料、記録、戦略、設計資料を読んで出したもので、採点役がこれを再現できるかで採点の形を確かめる。境目と書いた条件は、読み方で判定が分かれうるので、一致の数を別に数える。採点役には、このファイルを読ませない。

## 判定

- explore-unknowns: PASS
- evidence-not-assumed: PASS
- charter-direction: PASS
- oracle-grounded: PASS
- record-evidence: PASS
- handoff-smallest-level: PASS
- hypothesis-marked: PASS
- owner-not-rewritten: PASS
- grill-only-outcome-changing: PASS
- xx-order-and-interleave: PASS
- xx-intended-behavior-not-defect: PASS
- xx-diagnosability: PASS

## 理由

charter は方向と観察する品質を一文で書き、出来事の順序の入れ替えを未知として選び、補充の禁止や論理定義との一致を異常を疑う根拠にしている。反映の途中で相手のポストが残ることを仕様どおりと書いている。再現できる欠陥は依存を外して最小の置き場へ下げ、未修正のコードで意図した理由により失敗することを修正の条件にしている。
