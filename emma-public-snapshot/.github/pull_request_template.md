<!--
emma — Standard-PR-Beschreibung. Liegt im Default-Branch unter `.github/pull_request_template.md`
und wird von GitHub beim **neuen** Pull-Request **automatisch** in den PR-Body vorgefuellt; Autor:innen
muessen **alle als verpflichtend gekennzeichneten** Traceability-Felder inhaltlich ausfuellen
(Platzhalter/„TODO“ sind keine Abnahme).

Hinweis: Nicht-Draft-PRs werden zusaetzlich von `pr-governance` (Maschinenlesbarkeit) geprueft; siehe
`.github/workflows/pr-governance.yml` — ausschliesslich Dokumentation, keine neue CI durch dieses Template.
-->

## PR-Titel (verpflichtend)

- **Kanon (Branch + Review):** `type(EMM-###): kurze, eindeutige Beschreibung` — die **EMM-###** im Titel
  muss mit der **Linear-ID** im PR-Body uebereinstimmen (verhindert Titel-↔-Issue-Drift).
- **Gewuenschter Titel:** `chore(EMM-141): describe change`

## Linear Issue (verpflichtend)

- **Linear-ID:** EMM-XXX (Platzhalter ersetzen)
- **Link:** (vollstaendiger URL zum Linear-Issue; nicht optional)

**Beispiel (copy/paste, Werte ersetzen):**
- EMM-166
- https://example.invalid/…/issue/EMM-166/…

## Modul (verpflichtend)

- **Mindestens ein** Modul aus **M01–M16** muss im PR-Body vorkommen (Kanon: [docs/architecture/MAPPING.md](../docs/architecture/MAPPING.md)). Mehrere zulaessig, wenn sachlich begruendet.
- **Eintrag (verpflichtend):** M02
- **Zusatz-Trace (optional, empfohlen):** B01–B14 aus [docs/architecture/module_traceability.md](../docs/architecture/module_traceability.md) nur, wenn die Aenderung backlog-/Umsetzungsrelevant in diesem Schicht-Modell ist.

## Funktions-ID (verpflichtend)

**Eine** der folgenden Varianten ist vollstaendig auszufuellen; leere oder triviale Platzhalter sind unzulaessig:

1. Katalog-**Funktions-ID** im Format `M##-F##` (z. B. **M07-F12**), vgl. [docs/product/PRODUKT.md](../docs/product/PRODUKT.md)
2. Oder, wenn keine Produktfunktion betroffen ist: `Nicht zutreffend: <Begruendung mit mindestens 8 sinnvollen Zeichen>`

- **Eintrag (verpflichtend):** Nicht zutreffend: reine Doku-/Meta-/Operations-Aenderung

**Beispiele (nur Muster, im PR ersetzen):** `M07-F12` · `Nicht zutreffend: kein fachliches M01–M16-Modul betroffen`

## Risikoklasse

*(Verpflichtend: genau eine aktive Risikoklasse; die Ueberschrift `## Risikoklasse` nicht umbenennen — maschinenlesbarer Abgleich.)*

- Exakt **eine** der folgenden R-Zeilen; alle nicht zutreffenden R0–R5-Zeilen entfernen:
- **R1**
- **Kurzbegruendung (verpflichtend, 1–2 Saetze):**

## Scope (verpflichtend)

- **Was wird geaendert?** (1–3 praezise Bullets, verpflichtend)
- **Welche Pfade/Dateien/Bereiche?** (konkret; verpflichtend)

**Beispiel:** PR-Template: Pflicht-Traceability; Datei: `.github/pull_request_template.md`

## Nicht im Scope (verpflichtend)

- **Explizit ausgeschlossen:** (z. B. CI/Workflows, Produkthaltigkeit — verpflichtend beantworten)

**Beispiel:** Keine Aenderung an Workflows, keine Produkt-Runtime-Logik

## Tests

*(Verpflichtend fuer jeden PR: Strategie und Nachweis; Ueberschrift `## Tests` nicht umbenennen — R2-Checks.)*

Fuer **jede** Risikoklasse: dokumentieren, **welche** Pruefstrategie gilt und **warum** (voll vs. reduziert,
siehe [docs/operations/test_scope_policy.md](../docs/operations/test_scope_policy.md)). Bei R2: substanziell
(hilft `pr-governance` und Reviewern); bloesse Boilerplate reicht nicht.

- **Check-Strategie (verpflichtend):** reduziert / voll (eine waehlen und zutreffend ausformulieren)

**Wenn reduziert (Begruendung und Ersatz sind verpflichtend):**
- Begruendung:
- Ersatzchecks (z. B. manueller Diff, Link-Check):

**Ausgefuehrt (zutreffende Kästchen setzen, Rest begruenden):**
- [ ] `melos run analyze`
- [ ] `melos run format`
- [ ] `melos run test:unit`
- [ ] `melos run test:flutter`
- [ ] sonstige:

**Nicht ausgefuehrt / Begruendung (verpflichtend, falls Kästchen unvollstaendig):**

**Beispiel (R0/R1, reine Doku- oder Template-Aenderung):** Strategie `reduziert` — Begruendung: kein
Dart-/Build-Pfad betroffen; Ersatz: gezielter Self-Check des Diffs

## Claude Review (verpflichtend zu befuellen, wo zutreffend)

- Angefordert: ja / nein / n/a (R0/R1 Self-Check reicht) — laut [docs/operations/review_merge_automation.md](../docs/operations/review_merge_automation.md)
- Outcome, sobald vorhanden: PASS / FAIL / GATE_REQUIRED / offen
- Linear REVIEW REQUEST / GATE OUTCOME: Link oder n/a
- Maschinenlesbare Marker: siehe *Maschinenlesbare Claude-Marker* in derselben Doku

## Merge-Entscheidung (verpflichtend zu beachten, nicht optional)

- Merge-Pfad: Self-Merge R0/R1 / R2 nur nach Claude PASS / R3+ Maintainer
- Linear `GATE OUTCOME` = PASS: ja / nein / n/a
- `ABSCHLUSS` inkl. Merge-SHA: geplant: ja / nein

## Risiken / offene Punkte (verpflichtend, „keine“ ist gueltig)

- (trifft/nicht; falls ja, kurz)

## Checkliste (Vor **Ready for review** abarbeiten)

- [ ] [PR-Hygiene](../docs/operations/pr_hygiene.md): Branch sinnvoll mit `main` geprueft, kein zweiter offener PR zum gleichen Issue ohne Linear-Begruendung
- [ ] Linear-ID **eindeutig** (kein EMM-XXX-Platzhalter)
- [ ] Risikoklasse im Abschnitt *Risikoklasse* als Zeile `- **R0**`…`- **R5**` gesetzt
- [ ] **Modul** M01–M16 genannt
- [ ] **Funktions-ID** (M##-F## oder begruendetes `Nicht zutreffend: ...`)
- [ ] **Tests**-Dokumentation (Strategie + Ausfuehrung bzw. Begruendung) vollstaendig
- [ ] Claude-Review laut R-Klasse und Policy
- [ ] `GATE OUTCOME` in Linear nach Merge-Policy
- [ ] Keine Produktlogik ausserhalb des Scope, keine unerlaubten `export`-Barrels, keine `package:emma_app/...` in `packages/**`, keine Business-Logik in Widgets, keine bezahlten APIs im MVP-Default (siehe [AGENTS.md](../AGENTS.md))

---

*Governance: [docs/operations/automerge_policy.md](../docs/operations/automerge_policy.md) ·
[docs/operations/review_merge_automation.md](../docs/operations/review_merge_automation.md) ·
[docs/operations/test_scope_policy.md](../docs/operations/test_scope_policy.md) ·
[PR-Hygiene](../docs/operations/pr_hygiene.md)*
