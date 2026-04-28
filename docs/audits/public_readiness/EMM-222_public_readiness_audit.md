# Public-Readiness Audit — EMM-222

| Feld | Wert |
| --- | --- |
| Issue | EMM-222 |
| Risikoklasse (Ticket) | R3 Audit-only |
| Audit-Datum | 2026-04-28 |
| Git-Status | `main`, working tree clean (lokal 3 Commits hinter `origin/main` gemeldet) |
| Getrackte Pfade (ungefähr) | 748 |
| Eingesetzte Checks | `git status`, `git branch --show-current`, `git ls-files`, Mustersuche (kein `gitleaks` lokal) |

**Kurzfazit (Stand Nachzieher EMM-223): GO** — proprietäre Root-`LICENSE`, PII redigiert; vor **Public-Visibility** noch **Dependency-Lizenz-Check** (siehe unten / `EMM-222_findings.json`). *(Ursprüngliches Audit: GO_AFTER_FIXES; F002/F003 nachbearbeitet.)*

---

## Blocker (historisch — EMM-222 Erststand)

1. **P1 — Personenbezug (F002):** Ehem. E-Mail / `C:\Users\…` in Doku — **in EMM-223 redigiert** (`mitigiert`).
2. **P1 — Lizenz (F003):** Ehem. fehlende Root-`LICENSE` — **in EMM-223** durch proprietary **All rights reserved** + README **mitigiert**; **kein** Open Source.

Kein P0 (lebende Secrets / Schlüsselmaterial) in der Stichproben- und Mustersuche in den **getrackten** Inhalten.

---

## Befundtabelle (alle Stufen)

| ID | P | Kategorie | Kurzbeschreibung | Empfehlung |
| --- | --- | --- | --- | --- |
| F001 | P0 | secrets | Keine Muster-Treffer für gängige lebende Geheimnisse; keine `.env` in Git | `KEEP` prüfprozess; History separat |
| F002 | P1 | pii | Ehem. E-Mail + lokale Pfade in Doku/Archiv (EMM-223: redigiert) | `REDACT` → **mitigiert** |
| F003 | P1 | legal | Root-`LICENSE` proprietary; README: public, not OSS (EMM-223) | **mitigiert**; Dep-Lizenz-Check vor Public |
| F004 | P2 | meta | Kein `SECURITY.md` / `CONTRIBUTING.md` | Folge-PR, `NEEDS_LEGAL_REVIEW` für Security-Kontakt |
| F005 | P2 | disclosure | `linear.app`- und GitHub-Repo-Referenzen in Governance-Doku | `KEEP` oder `REDACT` nach Kommunikationsvorgabe |
| F006 | P2 | ci | Secrets nur in Actions; PR erzwingt Linear-Key-Text; Fork-Flow beachten | `KEEP` + Doku/Policy |
| F007 | P2 | ops | `runner-test.yml` (self-hosted, manuell) sichtbar | `KEEP` oder anpassen |
| F008 | P3 | demo | Demo-E-Mails / Platzhalter im Code | `KEEP` |
| F009 | P3 | binaries | Normale App-Assets + `gradle-wrapper.jar` | `KEEP` |

Detailliert: `EMM-222_findings.json`.

---

## Go / No-Go

| Entscheidung | Begründung (kurz) |
| --- | --- |
| **NO-GO** (sofort) | Wenn rechtlich Lizenz+PII-Redaction vor Release Pflicht sind und nicht adressiert. |
| **GO** | Nicht empfohlen ohne vorherige License-Entscheidung + PII-Bereinigung. |
| **GO_AFTER_FIXES** | Zutreffend: Secret-Stichprobe ohne Treffer, aber P1-PII + Lizenz + empfohlene Public-Doku-Minimalien. |

---

## Empfohlener nächster PR-Scope (nach Ticket, ohne dieses Audit)

1. PII-Redaction in betroffenen `docs/`-Dateien (und ggf. Archiv, falls öffentlich mitveröffentlicht).
2. `LICENSE` + rechtliche Abstimmung; optional SPDX in Manifesten nach Policy.
3. `SECURITY.md` (VDP-light) und `CONTRIBUTING.md` (Fork-PR vs. org-intern, Linear-Pflicht erklären).
4. Option: Historien-/Secret-Tooling auf vollständige History (separat von EMM-222, falls verlangt).

---

*Audit-only: keine Löschungen, Umschreibungen, Secret-Rotation, Branch-/PR-/Visibility-Änderungen.*

---

## Nachbereitung — EMM-223 (Public-Blocker, 2026-04-28)

| Maßnahme | Ergebnis |
| --- | --- |
| P1-PII (F002) | Getrackte Vorkommen echter E-Mail in Pfadangaben und lokaler `C:\Users\…`-Pfade in betroffener Doku/Audit-Dateien entfernt bzw. durch `<LOCAL_REPO_PATH>` (und wo nötig kurze neutrale Kurzverweise) ersetzt — keine fachliche Umschreibung der Produktinhalte. |
| P1-Lizenz (F003) | Root-[`LICENSE`](../../../LICENSE): **proprietary / All rights reserved** (David Arlester Schmid). Repo: **öffentlich sichtbar erlaubt, kein Open Source**. README-Abschnitt *License* auf Englisch; Verweis auf `LICENSE`. |
| Offener Prüfpunkt | Vor GitHub-**Public**-Schaltung: **Dependency-License-Check** (transitiv), insb. Copyleft- oder Weitergabepflichten vs. proprietäres Modell. |
| `EMM-222_findings.json` | Meta (`verdict: GO`), F002/F003, `open_prerequisites_before_public_visibility` aktualisiert. |

**Lizenzentscheidung (EMM-223, zur Agenten-Weitergabe / Codex):**

- Root-`LICENSE` als proprietary / All rights reserved ergänzt  
- Keine Open-Source-Lizenz (kein MIT, Apache-2.0, GPL, …) für den **eigenen** Code  
- README: *publicly visible, not open source*  
- Third-Party-Abhängigkeiten, APIs, SDKs: unverändert deren Lizenzen; **keine** Umschreibung von Drittlizenzen im Repo  
- `EMM-222`‑Befund F003: **mitigiert**; GO für transparente Sichtbarkeit **mit** vorherigem/parallel laufendem Dep-Lizenz-Check als Governance-Pflicht  

**Fazit EMM-223:** **GO** für „Repo public, Code proprietär“; **offen:** Abhängigkeitslizenzen vor dem Schalter verifizieren. PII (F002) **mitigiert**.
