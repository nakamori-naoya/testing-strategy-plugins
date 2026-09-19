#!/usr/bin/env bash
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/testing-strategy-validation.XXXXXX") || exit 2
trap 'rm -rf "$TMP_ROOT"' EXIT
failed=0

TOOLS="$ROOT/../harness-tools/tools"
[ -d "$TOOLS" ] || { echo "[error] 兄弟 checkout harness-tools が無い: $TOOLS" >&2; exit 2; }

python3 "$TOOLS/validate-plugin-repository.py" "$ROOT" || failed=1
python3 "$TOOLS/validate-plugin-repository.py" --self-test || failed=1
python3 "$TOOLS/test-hardening.py" --repository "$ROOT" || failed=1

for runtime in claude codex; do
  package="$ROOT/plugins/testing-strategy/.${runtime}-plugin/plugin.json"
  if [ "$runtime" = codex ]; then
    marketplace="$ROOT/.agents/plugins/marketplace.json"
  else
    marketplace="$ROOT/.claude-plugin/marketplace.json"
  fi
  jq -e '.name=="testing-strategy" and .version=="1.0.0" and .skills==["./skills/design-test-strategy"] and .metadata.harness.marketplace=="testing-strategy" and (.metadata.harness.contractVersion|type)=="number"' "$package" >/dev/null || failed=1
  jq -e '.name=="testing-strategy" and (.plugins|length)==1 and .plugins[0].name=="testing-strategy" and .plugins[0].version=="1.0.0"' "$marketplace" >/dev/null || failed=1
done

pb="$ROOT/plugins/testing-strategy/skills/design-test-strategy/playbook.yml"
yq -o=json -I=0 '.' "$pb" | jq -e '
  .version==2 and
  .name=="design-test-strategy" and
  .inputs==["target_repository","request","references","document_destination"] and
  (.requires|sort_by(.plugin))==([{"plugin":"grill","marketplace":"grill"},{"plugin":"write-doc","marketplace":"write-doc"}]|sort_by(.plugin)) and
  ([.steps[].id]|length)==([.steps[].id]|unique|length)
' >/dev/null || failed=1

map="$TMP_ROOT/lint-dev-map.json"
grill="$ROOT/../grill-plugins/plugins/grill"
write_doc="$ROOT/../write-doc-plugins/plugins/write-doc"
for provider in "$grill" "$write_doc"; do
  [ -d "$provider" ] || { echo "[error] 依存先の配布物checkoutが無い: $provider" >&2; exit 2; }
done
jq -n --arg g "$(cd "$grill" && pwd -P)" --arg w "$(cd "$write_doc" && pwd -P)" \
  '{schema:1,dependencies:{"grill/grill":$g,"write-doc/write-doc":$w}}' > "$map" || exit 2
for runtime in claude codex; do
  HARNESS_PLUGIN_DEV_ROOTS="$map" python3 "$TOOLS/lint-consumer-contract.py" --repo "$ROOT" --runtime "$runtime" || failed=1
done

jq -e '.schema==1 and (.cases|length)>=3 and ([.cases[].id]|length)==([.cases[].id]|unique|length)' "$ROOT/evals/scenarios.json" >/dev/null || failed=1

while IFS= read -r script; do
  bash -n "$script" || failed=1
done < <(find "$ROOT" -type f -name '*.sh' | sort)

if [ "$failed" -eq 0 ]; then
  echo 'Validation: passed'
else
  echo 'Validation: failed'
fi
exit "$failed"
