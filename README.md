# テスト戦略とシナリオ設計

対象リポジトリを調べ、品質リスクをテスト戦略、プログラム境界のシナリオ、E2E シナリオ、探索的テストの計画へ具体化する、Claude Code と Codex の両方で使える plugin です。

`design-test-strategy` がリポジトリ全体の戦略を作り、最小の担当レベル、Small・Medium・Large、差し替えてよい境界をその戦略資料に定めます。`design-api-test-scenarios`、`design-e2e-test-scenarios`、`plan-exploratory-testing` は、その戦略資料を読んで、変更ごとの設計資料を作ります。三つが共有する進め方は、内部の `map-test-coverage` にあります。

性能とセキュリティの詳細な戦略、探索の実行、テストコードの実装、バグの修正は扱いません。

## 検証

```bash
bash scripts/validate.sh
```

## 検証の eval

四つの入口が、要件と設計資料だけを持つリポジトリから、利用者の原則に沿った資料を作れるかは、`evals/` の下のケースで確かめる。一つのケースは、一つの入口の一つの資料である。今は X のクローンのお題について、テスト戦略、フォローの境界シナリオ、フォローからホームタイムラインまでの E2E シナリオ、ホームタイムラインへの反映の探索計画の四つを置いている。

対象リポジトリは、`evals/scaffold.sh` が作業場所の中に作る手元だけの git repository で、お題の要件（`materials/input/`）と設計資料（`materials/design/`）だけを持つ。後の三つのケースには、テスト戦略のケースで作った資料を固定の材料（`materials/test-strategy/`）として渡す。戦略の出来に後の三つの点数が引きずられないようにするためである。write-doc と grill は隔離環境に入らないので、兄弟 checkout から写し、無ければ止まる。

実行は `claude plugin eval` が受け持ち、出来の採点は、作業したエージェントとは別の Claude（採点役）が、条件ごとに判定と根拠を書いて受け持つ。`graders/` には、読まずに判定できること（資料と記録ができたか、skill と共通の判断を読んだか）だけを置く。共通の条件は `evals/criteria/<資料の種類>.md`、ケースに固有の条件は `evals/<お題>/<ケース>/grading/criteria.md` にあり、重みは利用者の原則の芯を3、骨組みを2、細部を1とする。採点役を確かめる資料と期待する判定は `grading/calibration/` に置き、実際に作らせた資料と、既知の欠陥を埋めた写しの二本を持つ。

```bash
claude plugin eval . --case x-clone-test-strategy \
  --runs 1 --ablation none --keep-temp \
  --scaffold --trust-plugin --allow-tools Write Edit Bash \
  --max-cost-usd 20 --no-publish
bash <harness-tools の grade-eval.sh> <ケースの絶対パス> <kept temp の絶対パス> [expected.md の絶対パス]
```

点数は3回の採点の多数決に重みを掛けた100点満点で、85点以上が「実用に足る」、70点以上が「手直しで使える」、70点未満が「作り直しが要る」である。結果は `evals/results/` に書かれ、git の管理から外してある。
