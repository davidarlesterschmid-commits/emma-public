# Agent Workflow Tests (Multi-Agent) — reproduzierbare Testfälle

Stand: 2026-04-26  
Ticket: Linear `EMM-165`  
Risiko: R1 (Doku/Testfall-Spezifikation, kein Produktverhalten)

## Ziel & Nicht-Ziele

Ziel: Reproduzierbare Tests für den Multi-Agent-Workflow **ohne PR-Flut**. Die Tests prüfen die Gate-Logik und die erwarteten Blocker-/Automation-Zustände.

Nicht-Ziele:

- Keine neuen CI-Checks, keine Branch-Protection, keine Repo-Rechte-/Secret-Änderungen.
- Keine Serien-PRs: **maximal 1 “Re-use PR”** (ein Test-PR, der für mehrere Tests wiederverwendet wird) oder reine Simulation ohne Push.

## Normative Quellen (verbindlich)

- `AGENTS.md`
- `docs/operations/automerge_policy.md`
- `docs/operations/review_merge_automation.md`
- `docs/operations/multi_agent_smoke_test.md`
- `docs/operations/CONTEXT_SNAPSHOT.md`

## Grundprinzip: “Dry-Run-first”, dann “Single reusable PR”

Diese Tests sind so geschrieben, dass sie bevorzugt als **Dry-Run** (ohne Push/ohne PR) durchführbar sind. Wenn ein Schritt zwingend GitHub-Workflow-Status erfordert (z. B. Auto-Ready), wird **ein einziger** wiederverwendbarer PR genutzt.

Empfohlener Ablauf:

- Erst alle Tests als **Simulation** durchgehen (Dokumentation/Checklisten-Abgleich).
- Danach optional **ein** PR öffnen und für die wenigen GitHub-spezifischen Nachweise wiederverwenden.

## Testfall-Format

Jeder Testfall nutzt:

- **Preconditions**
- **Steps**
- **Expected**
- **Cleanup / Anti-Flut-Regel**

Begriffe:

- **Gate**: Self oder LLM-Gate (zulaessiger Review-Provider, z. B. Claude / ChatGPT / Codex / Cursor / Gemini) — siehe `docs/operations/review_merge_automation.md`
- **Ready**: PR ist nicht Draft
- **Checks**: vorhandene GitHub-Checks (keine neuen erfinden)

---

## Test 1 — R0 grün → merge (Happy Path)

**Zweck:** Nachweisen, dass ein R0-PR bei grünem Zustand **agentisch squash-gemerged** werden darf (Self-Check ausreichend). Referenz: R0/R1-Matrix & Merge-Logik. (`docs/operations/review_merge_automation.md`, `docs/operations/automerge_policy.md`)

**Preconditions**

- Linear-Issue existiert (kann ein dediziertes Test-Issue sein) mit Risiko **R0**.
- Branchname enthält Linear-ID (z. B. `cursor/EMM-XXX-r0-doc-only`).
- Änderung ist **nur** Doku/Meta, keine Produktdateien.
- PR ist **Ready for review** (nicht Draft).
- Vorhandene Checks sind **grün** oder es gibt **nachvollziehbare Auslassung** (keine CI “hinzubauen”).
- Linear `GATE OUTCOME` liegt vor: **PASS** (Self).

**Steps (Simulation / Dry-Run)**

- Prüfe anhand `docs/operations/review_merge_automation.md`, dass für R0 Self-Review genügt und Merge erlaubt ist.
- Prüfe, dass “Draft blockiert immer” und “rote/pending Checks blockieren immer” im Testdesign berücksichtigt sind.

**Steps (optional: Single reusable PR)**

- Öffne einen Draft-PR (einmalig, wiederverwendbar) und stelle sicher, dass:
  - PR-Titel oder PR-Body die Linear-ID enthält
  - Risiko R0 im PR-Body begründet ist
- Warte bis Checks grün sind (oder dokumentiere “keine Checks vorhanden”).
- Setze PR auf **Ready** (z. B. per `gh pr ready`).
- Führe den Squash-Merge mit Head-SHA-Schutz aus (Policy-konform; Details in `docs/operations/review_merge_automation.md`).

**Expected**

- Merge ist für R0 zulässig, wenn: Ready + PASS (Self) + Checks grün/ausgelassen + Linear `GATE OUTCOME` PASS.
- Nach erfolgreichem Merge ist Linear `ABSCHLUSS` Pflicht (inkl. Merge-SHA).

**Cleanup / Anti-Flut-Regel**

- Kein zweiter PR. Wenn ein PR existiert: nach Nachweis merge (oder schließen) und **für weitere Tests denselben PR nicht duplizieren**, sondern Test 2–5 als Simulation oder als Status-Variation (Draft/Label/Review) auf demselben PR durchführen.

---

## Test 2 — R2 ohne Claude → block (Gate Enforcement)

**Zweck:** Nachweisen, dass ein R2-PR **nicht** gemerged werden darf, wenn **Claude `PASS` fehlt**. Referenz: R2-Matrix & PASS/FAIL-Regeln. (`docs/operations/review_merge_automation.md`, `docs/operations/automerge_policy.md`)

**Preconditions**

- Linear-Issue existiert mit Risiko **R2** (oder PR ist als R2 deklariert).
- PR ist Ready, Checks sind grün (oder dokumentiert), lokale Tests wären (theoretisch) vorhanden.
- **Kein** Claude-Review-Outcome `PASS` liegt vor.

**Steps (Simulation / Dry-Run)**

- Prüfe in `docs/operations/review_merge_automation.md`:
  - “R2: Claude-Review Pflicht”
  - “Ohne Claude `PASS`: kein Merge”
  - “Merge-Entscheidungslogik Schritt 3/6”

**Steps (optional: Single reusable PR)**

- Verwende denselben PR aus Test 1 (nur wenn zulässig/gewünscht) und simuliere R2, indem du:
  - im PR-Body Risiko als R2 deklarierst (ohne weiteren Code-Change; Test ist Governance-/Workflow-orientiert)
  - **kein** Claude `PASS` einholst
- Beobachte, dass ein Merge-Versuch nach Policy nicht zulässig wäre.

**Expected**

- Ergebnis ist **BLOCKED** (prozessual): R2 ohne Claude `PASS` darf nicht gemerged werden.
- Dokumentationspflicht: Linear `GATE OUTCOME` kann nicht `PASS` sein; Endzustand ist “REQUEST_CHANGES/BLOCKED” bzw. “kein Merge”.

**Cleanup / Anti-Flut-Regel**

- Kein neuer PR; keine zusätzlichen Branches.

---

## Test 3 — BLOCKED_BY_AGENT (technischer/prozessualer Blocker)

**Zweck:** Reproduzierbar dokumentieren, wann und wie `BLOCKED_BY_AGENT` zu setzen ist. Referenz: `BLOCKED_BY_AGENT` Abschnitt. (`docs/operations/review_merge_automation.md`)

**Preconditions**

- Ein PR existiert oder wird simuliert, bei dem:
  - Merge nicht agentisch möglich ist, **ohne** dass `BLOCKED_BY_INPUT` oder `BLOCKED_BY_CONTEXT_DRIFT` die Ursache sind.
- Typische Trigger laut Policy:
  - Checks bleiben rot/pending trotz zumutbarem Re-Run
  - Auto-Merge (`--auto`) technisch nicht nutzbar und direkter Squash-Merge ist nicht zulässig
  - Branch Protection / Rechte verhindern Merge

**Steps (Simulation / Dry-Run)**

- Lies den `BLOCKED_BY_AGENT` Abschnitt in `docs/operations/review_merge_automation.md` und baue daraus eine Checkliste:
  - Ist die Ursache wirklich nicht “Input fehlt” und nicht “Snapshot drift”?
  - Gab es einen zumutbaren Reparatur-/Re-Run-Versuch?
  - Ist die Fix-Idee außerhalb des Ticket-Scopes oder würde Repo-Rechte/CI ändern?
- Definiere den erwarteten Linear-Abschluss:
  - `ABSCHLUSS` mit `Agent-Blocker: BLOCKED_BY_AGENT`
  - `Merge-SHA: n/a`

**Steps (optional: Single reusable PR)**

- Versuche (ohne Regelbruch) einen Status herzustellen, der Merge verhindert (z. B. Draft bleibt Draft oder Checks pending/rot).
- Dokumentiere dann im Linear-Issue `BLOCKED_BY_AGENT` gemäß Template.

**Expected**

- Der PR bleibt ungemerged.
- In Linear ist `BLOCKED_BY_AGENT` nachvollziehbar begründet, inkl. “letzter Reparaturversuch” und klarer Next Step (z. B. Maintainer/Repo-Admin Aktion).

**Cleanup / Anti-Flut-Regel**

- Kein neuer PR; kein “Retry-Spam”. Ein Re-Run maximal einmal, dann Blocker dokumentieren.

---

## Test 4 — Auto-Ready funktioniert (Draft → Ready bei grünen Checks)

**Zweck:** Nachweisen, dass der Workflow “Draft wird automatisch Ready, wenn Checks grün sind” funktioniert (ohne Merge). Referenz: Auto-Ready Beschreibung. (`docs/operations/review_merge_automation.md`)

**Preconditions**

- Repository hat den Workflow `.github/workflows/auto-ready.yml` (laut Doku optional). Falls nicht vorhanden/disabled: Ergebnis wird als **nicht verfügbar** dokumentiert.
- Ein PR ist **Draft** und hat relevante Checks, die grün werden können.
- Wichtig: Auto-Ready ist **kein Auto-Merge**.

**Steps (Simulation / Dry-Run)**

- Prüfe in `docs/operations/review_merge_automation.md`:
  - Auto-Ready existiert (optional)
  - Bedingungen: “relevante Checks grün”
  - Abgrenzung: Auto-Ready != Auto-Merge

**Steps (optional: Single reusable PR)**

- Öffne/verwende einen Draft-PR und warte bis Checks grün sind.
- Beobachte, ob der PR automatisch auf Ready gesetzt wird.

**Expected**

- PR wechselt **automatisch** von Draft zu Ready, sobald die definierten Checks grün sind (falls Workflow vorhanden/aktiv).
- Es findet **kein** Merge statt, nur Statuswechsel.
- Falls `.github/workflows/auto-ready.yml` nicht vorhanden oder deaktiviert ist: kein Auto-Ready; Ergebnis ist **nicht verfügbar/disabled** (ohne Folge-PRs).

**Cleanup / Anti-Flut-Regel**

- Nur ein PR. Falls Auto-Ready nicht aktiv ist, **kein** weiterer PR zur “Bestätigung” eröffnen; stattdessen Ergebnis als “nicht verfügbar/disabled” dokumentieren.

---

## Test 5 — R3-Gate Verhalten (Eskalation / kein Automerge)

**Zweck:** Nachweisen, dass R3+ **nie agentisch gemerged** wird und korrekt als `GATE_REQUIRED`/Maintainer-Gate behandelt wird. Referenz: R3+ Out-of-scope in Review/Merge Automation, Automerge Policy. (`docs/operations/review_merge_automation.md`, `docs/operations/automerge_policy.md`)

**Preconditions**

- Ein PR ist plausibel **R3** (Architektur-/Modulgrenzen-Impact) oder wird als R3 deklariert.
- Hinweis: Dieser Test ist Governance-orientiert; er soll **nicht** durch echte riskante Codeänderungen erzwungen werden.

**Steps (Simulation / Dry-Run)**

- Prüfe in `docs/operations/review_merge_automation.md`:
  - R3+ ist “Out of Scope” und “nie Auto-Merge”
  - `GATE_REQUIRED` Definition: wenn höhere plausible Klasse gilt
- Prüfe in `docs/operations/automerge_policy.md`:
  - Mindest-Gates für R3 (manueller Maintainer-Merge)

**Steps (optional: Single reusable PR)**

- Verwende einen vorhandenen PR und simuliere R3-Entscheidung rein prozessual:
  - Dokumentiere, dass die höhere plausible Klasse R3 ist → `GATE_REQUIRED`.
  - Kein agentischer Merge-Versuch.

**Expected**

- Outcome ist `GATE_REQUIRED` bzw. Hochstufung auf R3+.
- Merge ist **blockiert** für Agenten (Maintainer-Entscheidung).

**Cleanup / Anti-Flut-Regel**

- Keine weiteren PRs, keine riskanten Codeänderungen. Der Test endet mit dokumentierter Eskalation.

---

## Ergebnis-Checkliste (Minimal)

Ein Testlauf gilt als “durchgeführt”, wenn für jeden Testfall mindestens eines vorliegt:

- Simulation: Dokumentierter Abgleich gegen die normativen Quellen (inkl. “warum merge/block”) oder
- Single reusable PR: beobachteter Status (Draft/Ready/Checks) + dokumentiertes Gate/Blocker-Ergebnis

Wichtig: Wenn ein Test zwingend GitHub-UI/CI braucht und das Repo es nicht bereitstellt (z. B. Auto-Ready deaktiviert), wird das Ergebnis als “nicht verfügbar” dokumentiert, **ohne** zusätzliche PRs zu erzeugen.

