#!/usr/bin/env bash
set -uo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TMP_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/testing-strategy-validation.XXXXXX") || exit 2
trap 'rm -rf "$TMP_ROOT"' EXIT
failed=0
PACKAGE="$ROOT/plugins/testing-strategy"

TOOLS="$ROOT/../harness-tools/tools"
[ -d "$TOOLS" ] || { echo "[error] 兄弟 checkout harness-tools が無い: $TOOLS" >&2; exit 2; }

python3 "$TOOLS/validate-plugin-repository.py" "$ROOT" || failed=1
python3 "$TOOLS/validate-plugin-repository.py" --self-test || failed=1
python3 "$TOOLS/test-hardening.py" --repository "$ROOT" || failed=1

version=$(jq -r '.plugins[0].version' "$ROOT/.agents/plugins/marketplace.json")
expected_skills='["./skills/design-test-strategy","./skills/design-api-test-scenarios","./skills/design-e2e-test-scenarios","./skills/plan-exploratory-testing"]'
for runtime in claude codex; do
  package="$PACKAGE/.${runtime}-plugin/plugin.json"
  if [ "$runtime" = codex ]; then
    marketplace="$ROOT/.agents/plugins/marketplace.json"
  else
    marketplace="$ROOT/.claude-plugin/marketplace.json"
  fi
  jq -e --arg version "$version" --argjson skills "$expected_skills" '
    .name=="testing-strategy" and
    .version==$version and
    .skills==$skills and
    .metadata.harness.marketplace=="testing-strategy" and
    (.metadata.harness.contractVersion|type)=="number" and
    .metadata.harness.internalPlugins=={"map-test-coverage":"./internal/map-test-coverage"}
  ' "$package" >/dev/null || failed=1
  jq -e --arg version "$version" '.name=="testing-strategy" and (.plugins|length)==1 and .plugins[0].name=="testing-strategy" and .plugins[0].version==$version' "$marketplace" >/dev/null || failed=1
done
diff <(jq -S 'del(.interface)' "$PACKAGE/.claude-plugin/plugin.json") <(jq -S 'del(.interface)' "$PACKAGE/.codex-plugin/plugin.json") >/dev/null || failed=1

for entry in design-test-strategy design-api-test-scenarios design-e2e-test-scenarios plan-exploratory-testing; do
  pb="$PACKAGE/skills/$entry/playbook.yml"
  if [ "$entry" = design-test-strategy ]; then
    expected_inputs='["target_repository","request","references","document_destination"]'
  else
    expected_inputs='["target_repository","request","test_strategy_path","scope","references","document_destination"]'
  fi
  yq -o=json -I=0 '.' "$pb" | jq -e --arg entry "$entry" --argjson inputs "$expected_inputs" '
    .version==2 and
    .name==$entry and
    .inputs==$inputs and
    (.requires|sort_by(.plugin))==([{"plugin":"grill","marketplace":"grill"},{"plugin":"write-doc","marketplace":"write-doc"}]|sort_by(.plugin)) and
    ([.steps[].id]|length)==([.steps[].id]|unique|length)
  ' >/dev/null || failed=1
done

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
