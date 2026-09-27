# 期待する判定

この較正の資料は、2026-09-27 の1回目の実行（claude plugin eval、`--runs 1 --ablation none`）で作られた資料と grill の記録である。下の判定は、eval を組んだ担当が資料、記録、戦略、設計資料を読んで出したもので、採点役がこれを再現できるかで採点の形を確かめる。境目と書いた条件は、読み方で判定が分かれうるので、一致の数を別に数える。採点役には、このファイルを読ませない。

## 判定

- public-contract-decided: FAIL
- follow-strategy-definitions: PASS
- boundary-only-at-boundary: PASS
- concrete-inputs: PASS
- sequence-only-when-needed: PASS
- no-invented-interface: FAIL（境目）
- hypothesis-marked: PASS
- owner-not-rewritten: PASS
- shape-headings: PASS
- grill-only-outcome-changing: PASS
- xa-principal-from-auth: PASS
- xa-limit-and-duplicate-placed-below: PASS
- xa-reflection-request-observed: PASS

## 理由

no-invented-interface は、冒頭で定義もコードも無いと断ったうえで、`followee_user_id` のような wire の項目名、`UNAUTHENTICATED` や `USER_NOT_REGISTERED` のような失敗の表現を、仮説の番号を付けずにシナリオの期待結果として使っているので FAIL とした。項目名はコマンドデータモデルの列名から取れること、冒頭の断りが全体に掛かると読めることから、境目とした。

xa-reflection-request-observed は、成功で反映の要求が積まれることを FR-01（永続化）で確かめ、拒否で積まれないことを、重複のフォローと、フォローしていない相手の解除の後に反映の要求が1件のままであることで確かめているので PASS とした。条件は、要求が積まれたかを境界で見ることも、永続化のレベルへ送ることも認める。

public-contract-decided は、この資料が今の条件より前の入口で作られ、操作ごとに返す Code と再試行の可否を決めた節が無い（「再試行」の語が一度も現れない）ので FAIL とした。
