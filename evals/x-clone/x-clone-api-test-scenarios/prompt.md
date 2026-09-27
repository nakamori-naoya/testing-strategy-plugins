---
description: X のクローンの対象リポジトリと、固定の材料にした確定済みのテスト戦略を渡し、フォローの業務の API テストシナリオ（design-api-test-scenarios）を作らせる。grill の問いには実行者が資料の事実で答える。
tags: [x-clone, api-test-scenarios]
plugins: ["../../../plugins/testing-strategy"]
max_turns: 200
timeout_seconds: 3600
allowed_tools: [Read, Glob, Grep, Skill, TodoWrite, Write, Edit, Bash]
---

X のクローン（X に似た SNS）のバックエンドについて、フォローの業務の API テストシナリオ（design-api-test-scenarios）の資料を作ってください。

## 入力

- target_repository：作業場所の `target-repo/`（絶対パスは `pwd` で確かめて渡してください）。要件（`docs/requirements/`）と、業務知識・コマンドデータモデル・クエリデータモデル・ユーザージャーニー（`docs/design/`）だけがある git repository で、コード、テスト、インターフェース定義はまだありません。
- test_strategy_path：作業場所の `test-strategy/test-strategy.md`（確定済みのテスト戦略）。
- request と scope：フォローの業務が公開する操作の契約を決め、どの具体例をどのレベルとサイズで確かめ、何を別のレベルへ重ねないかを決めたい。scope は、フォローする、フォローを外すの二つの操作と、その変更に伴う非同期の反映の要求まで。
- references：ありません。
- document_destination：`{output_directory: <作業場所の絶対パス>/out, name: api-test-scenarios.md}`。資料は `out/api-test-scenarios.md` に保存されます。

## ほかの package のファイル

この環境には write-doc と grill の skill が入っていません。代わりに、その最新のファイルを作業場所へ写してあります。skill が write-doc（公開 playbook `write-doc` を含む）に保存を任せるよう求めたら `harness/write-doc/SKILL.md` の指示どおりに保存し、template、見本、規範は `harness/write-doc/` の下を読んでください。grill（公開 playbook `grill` を含む）の規律に従うよう求めたら `harness/grill/SKILL.md` を読んでください。

## grill の問いへの答え方

この実行には、問いに答える利用者がいません。あなたが利用者の代わりも務めます。skill が grill で問いを出したら、次の決まりで自分で答えてください。

- 対象リポジトリの要件と設計資料（と、渡したテスト戦略）にある事実で答えが決まるなら、その事実で答える。
- それらに無いことは、問いに添えた推奨を仮置きする。仮置きした答えは決定として本文で断定せず、資料の未決に、仮置きであること、根拠、採らなかった案、何が分かれば確定するかと一緒に書く。
- 推奨も無いときは、未決として残す。

問い、推奨、あなたの答え、その根拠（どのファイルのどの節か、推奨を仮置きしたか）は、出た順にすべて `grill-log/api-test-scenarios.md` に書いてください。grill の終わりの一覧への合意も、同じファイルに書いてください。問いが一つも無かったときも、そのファイルを作り、問わなかった理由を書いてください。

## 守ること

対象リポジトリの資料は書き換えないでください。クラウドや外部のサービスへは接続しないでください。テストコード、CI の設定は作らず、何も実行しないでください。

## 止まるとき

skill の停止条件に当たったら、skill の指示どおりに止まってください。止まったときは、何が分からず、それで結論のどこが変わるかを報告に書いてください。

## 報告

最後に、日本語で、保存した資料のパス、status（ready か unresolved）、grill の問いの数、合意した決定と仮説と未決の数、途中で止まったならその理由を短く書いてください。
