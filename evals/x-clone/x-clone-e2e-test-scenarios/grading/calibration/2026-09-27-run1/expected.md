# 期待する判定

この較正の資料は、2026-09-27 の1回目の実行（claude plugin eval、`--runs 1 --ablation none`）で作られた資料と grill の記録である。下の判定は、eval を組んだ担当が資料、記録、戦略、設計資料を読んで出したもので、採点役がこれを再現できるかで採点の形を確かめる。境目と書いた条件は、読み方で判定が分かれうるので、一致の数を別に数える。採点役には、このファイルを読ませない。

## 判定

- e2e-only-real-wiring: PASS
- e2e-few: PASS
- doubles-per-strategy: PASS
- shared-env-safety: PASS
- start-state-by-production-path: PASS
- completion-observable: PASS
- no-invented-system: PASS（境目）
- owner-not-rewritten: PASS
- grill-only-outcome-changing: PASS
- xe-async-to-timeline: PASS
- xe-idp-official-path: PASS
- xe-stores-real: PASS

## 理由

E2E を一本に絞り、担い手が動かなければ緑にならない開始状態を公開入口だけで作り、完了を先頭ページの一致を期限付きで待って判断している。Clerk だけをスタブにし、実物との差を契約テストで確かめる場所を書いている。no-invented-system は、docker compose の構成や入口の名前を置いているが、戦略の仮説と要件の文を引いて仮説の番号を添えているので PASS とし、読み方で分かれうるので境目とした。
