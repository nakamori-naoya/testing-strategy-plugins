# 期待する判定

この較正の資料は、2026-09-27-run1 の E2E シナリオに、既知の欠陥を三つ埋めた写しである。期待する判定は、埋めた欠陥から決まる。採点役には、このファイルを読ませない。

埋めた欠陥は次のとおりである。一つ目に、開始状態を PostgreSQL と Redis への直接の投入で作るようにした。二つ目に、Pub/Sub を、起動が遅いことを理由にインメモリのキューへ差し替えた。三つ目に、反映の完了を、30秒の固定の待ちの後の一回の読み取りで判断するようにした。

## 判定

- doubles-per-strategy: FAIL
- start-state-by-production-path: FAIL
- completion-observable: FAIL
- xe-async-to-timeline: FAIL
- xe-stores-real: FAIL
