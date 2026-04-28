# tools

Hilfsskripte, Codegenerierung und CI-nahe Werkzeuge fuer das Workspace-Monorepo.

- `scripts/sync_instructions.ps1` / `sync_instructions.sh` — spiegelt `AGENTS.md` nach `.github/copilot-instructions.md` (aus Repo-Root ausfuehren).
- `scripts/emma-git-bash.sh` — Git Bash / WSL: `analyze`, `format`, Tests (Dart/Flutter/Python), `test-tools`, `run-chrome`, `sync-agents`, `branch-hygiene` (aus Repo-Root: `bash tools/scripts/emma-git-bash.sh help`). Unter Git for Windows: `chmod +x` nur noetig fuer direktes `./`-Starten.
- `scripts/branch_hygiene.ps1` — Branch-Inventar lokal/`origin` und optional sichere Bereinigung merge-mergter lokaler Branches (Squash-Hinweis: [docs/operations/pr_hygiene.md](../docs/operations/pr_hygiene.md)). Beispiel: `pwsh -File tools/scripts/branch_hygiene.ps1 -Prune`
- `scripts/agent_workflow.ps1` — nicht-destruktiver VS-Code-/Agentenhelfer fuer `START`, `REVIEW REQUEST` und `GATE CHECK`. Er liest lokale Git-Refs und den Single Context Snapshot, erzeugt Markdown-Bloecke und postet/merged/pusht nichts. Beispiele:
  - `pwsh -File tools/scripts/agent_workflow.ps1 start EMM-188 -Risk R1 -Agent Codex`
  - `pwsh -File tools/scripts/agent_workflow.ps1 review-request EMM-188 -Risk R1 -PrLink <PR-Link>`
  - `pwsh -File tools/scripts/agent_workflow.ps1 gate EMM-188 -Risk R1 -PrLink <PR-Link>`

## Python-Tooling-Tests

`tools/llm_routing.py` (Governance-Tooling, EMM-235) wird ueber `tools/tests/` mit der Python-stdlib `unittest` abgesichert. Reine stdlib, keine externen Dependencies, keine Netzwerkaufrufe.

Lokale Ausfuehrung aus dem Repo-Root:

- Linux / macOS / WSL / Git Bash:

  ```bash
  python3 -m unittest discover -s tools/tests -p 'test_*.py' -v
  ```

  oder ueber den Helper:

  ```bash
  bash tools/scripts/emma-git-bash.sh test-tools
  ```

- Windows (PowerShell):

  ```powershell
  python -m unittest discover -s tools/tests -p "test_*.py" -v
  ```

  Eingebettet im Health-Check (laeuft als eigener Schritt):

  ```powershell
  pwsh -File tools/repo_health_check.ps1
  ```

CI verankert den gleichen Aufruf als Pflicht-Step in `.github/workflows/dart.yml` ("Python tooling tests").
