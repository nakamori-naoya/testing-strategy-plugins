#!/usr/bin/env bash
# ケースが共有する準備。空の作業場所へ、テスト戦略を適用する対象リポジトリと、skill が読む別 package のファイルを置く。
# 対象リポジトリ（target-repo/）は、お題の要件と設計資料だけを持つ、手元だけの git repository である。コードとテストは無い。
# 二つ目の引数に strategy を渡したケースだけ、固定の材料にしたテスト戦略（materials/test-strategy/）を作業場所の test-strategy/ へ置く。
# 業務の分け方（split.md）は採点役だけが読む。
# 別 package（write-doc、grill）は隔離環境に入らないので、兄弟 checkout の最新のファイルを写す。
# 兄弟 checkout が無ければ、写しで代用せずに止まる。
set -euo pipefail

[ $# -ge 1 ] || { echo "使い方: bash scaffold.sh <お題のディレクトリ> [strategy]" >&2; exit 2; }
TOPIC_DIR=$(cd "$1" && pwd)
EVALS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPOSITORY=$(cd "$EVALS_DIR/.." && pwd)
WORKSPACE=$(cd "$(dirname "$REPOSITORY")" && pwd)
WRITE_DOC="$WORKSPACE/write-doc-plugins/plugins/write-doc/skills/write-doc"
GRILL="$WORKSPACE/grill-plugins/plugins/grill/skills/grill"

for skill in "$WRITE_DOC" "$GRILL"; do
  [ -f "$skill/SKILL.md" ] || { echo "兄弟 checkout の skill が無い: $skill" >&2; exit 2; }
done

mkdir -p harness out grill-log target-repo/docs
cp -R "$TOPIC_DIR/materials/input" target-repo/docs/requirements
cp -R "$TOPIC_DIR/materials/design" target-repo/docs/design
git -C target-repo init -q
git -C target-repo add docs
git -C target-repo -c user.name=eval -c user.email=eval@example.invalid commit -q -m "docs: 要件と設計資料"
if [ "${2:-}" = strategy ]; then
  [ -d "$TOPIC_DIR/materials/test-strategy" ] || { echo "固定の材料のテスト戦略が無い: $TOPIC_DIR/materials/test-strategy" >&2; exit 2; }
  cp -R "$TOPIC_DIR/materials/test-strategy" test-strategy
fi
cp -R "$WRITE_DOC" harness/write-doc
cp -R "$GRILL" harness/grill
