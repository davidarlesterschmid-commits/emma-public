#!/usr/bin/env bash
# emma-git-bash.sh — Git Bash / WSL / Unix: Melos- und Flutter-Befehle aus dem emma-Repo-Root.
#
# Immer aus dem Repository-Root aufrufen:
#   bash tools/scripts/emma-git-bash.sh help
#   bash tools/scripts/emma-git-bash.sh analyze
#
# Kurz-Alias (optional in ~/.bashrc):
#   alias emma-bash='bash tools/scripts/emma-git-bash.sh'
#   (im emma-Clone: emma-bash analyze)
set -euo pipefail

_emma_root() {
  local here
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  (cd "$here/../.." && pwd)
}

ROOT="$(_emma_root)"
cd "$ROOT"

usage() {
  cat <<'EOF'
Befehl:

  help             Hilfe
  bootstrap        dart pub get
  analyze          melos run analyze
  format           melos run format
  test-unit        melos run test:unit
  test-flutter     melos run test:flutter
  test-tools       python -m unittest discover -s tools/tests -p 'test_*.py' -v
  run-chrome       flutter run -d chrome (apps/emma_app, USE_FAKES=true)
  sync-agents      sync_instructions.sh (AGENTS -> copilot-instructions)
  branch-hygiene   Branch-Inventar (main vs lokal/origin), s. docs/operations/pr_hygiene.md
EOF
}

_python() {
  for c in python3 python py; do
    if command -v "$c" >/dev/null 2>&1; then
      echo "$c"
      return 0
    fi
  done
  echo "python3"
}

_melos() {
  dart pub global run melos "$@"
}

case "${1:-help}" in
  help|-h|--help) usage ;;
  bootstrap) dart pub get ;;
  analyze) _melos run analyze ;;
  format) _melos run format ;;
  test-unit) _melos run test:unit ;;
  test-flutter) _melos run test:flutter ;;
  test-tools)
    PY="$(_python)"
    "$PY" -m unittest discover -s tools/tests -p 'test_*.py' -v
    ;;
  run-chrome)
    (cd "$ROOT/apps/emma_app" && exec flutter run -d chrome --dart-define=USE_FAKES=true)
    ;;
  sync-agents)
    bash "$ROOT/tools/scripts/sync_instructions.sh"
    ;;
  branch-hygiene)
    git -C "$ROOT" fetch --prune origin 2>/dev/null || true
    echo ""
    echo "=== Base: $(git -C "$ROOT" rev-parse --short main) (main) ==="
    echo ""
    echo "--- Local merged into main (merge commits only) ---"
    git -C "$ROOT" branch --merged main --format='%(refname:short)' 2>/dev/null || true
    echo ""
    echo "--- Local NOT merged into main ---"
    git -C "$ROOT" branch --no-merged main --format='%(refname:short)' 2>/dev/null || true
    echo ""
    echo "--- Remote merged into origin/main (merge commits only) ---"
    git -C "$ROOT" branch -r --merged origin/main 2>/dev/null | sed '/HEAD/d' || true
    echo ""
    echo "Hinweis: Bei Squash-Merge bleiben Feature-Branches oft 'not merged'. Siehe pr_hygiene.md."
    ;;
  *)
    echo "Unbekannt: $1" >&2
    usage >&2
    exit 1
    ;;
esac
