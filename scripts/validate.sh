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

while IFS= read -r script; do
  bash -n "$script" || failed=1
done < <(find "$ROOT" -type f -name '*.sh' | sort)

if [ "$failed" -eq 0 ]; then
  echo 'Validation: passed'
else
  echo 'Validation: failed'
fi
exit "$failed"
