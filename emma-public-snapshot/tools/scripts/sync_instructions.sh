#!/usr/bin/env bash
# Spiegelt AGENTS.md nach .github/copilot-instructions.md (kanonische Agent-Quelle).
# Aufruf aus Repo-Root:  bash tools/scripts/sync_instructions.sh
set -euo pipefail

SRC="AGENTS.md"
DST=".github/copilot-instructions.md"

if [[ ! -f "$SRC" ]]; then
  echo "Fehler: $SRC fehlt. Aus Repo-Root aufrufen." >&2
  exit 1
fi

mkdir -p "$(dirname "$DST")"
{
  printf '%s\n\n' '<!-- AUTOGENERIERT via tools/scripts/sync_instructions.sh - NICHT direkt editieren. Quelle: AGENTS.md -->'
  cat "$SRC"
} > "$DST"

echo "Mirror aktualisiert: $DST ($(wc -c < "$DST") Byte)"
