# 期待する判定

この較正の資料は、2026-09-27-run1 の境界シナリオに、既知の欠陥を三つ埋めた写しである。期待する判定は、埋めた欠陥から決まる。採点役には、このファイルを読ませない。

埋めた欠陥は次のとおりである。一つ目に、存在しない `.proto` のパス、digest、HTTP の写しを、現状の事実として書いた。二つ目に、他人の利用者IDを名乗る要求で、要求の中の `x-user-id` をフォロワーとして使う期待にした。三つ目に、フォロー上限の境界値と拒否理由の網羅を、この境界のシナリオに置き、「不正な値」で済ませた例を足した。

## 判定

- public-contract-decided: FAIL
- boundary-only-at-boundary: FAIL
- concrete-inputs: FAIL
- no-invented-interface: FAIL
- xa-principal-from-auth: FAIL
- xa-limit-and-duplicate-placed-below: FAIL

public-contract-decided は、この資料が今の条件より前の入口で作られ、操作ごとに返す Code と再試行の可否を決めた節が無い（「再試行」の語が一度も現れない）ので FAIL とした。
