# Linear Execution Map — emma App v1.0

**Status:** gueltig  
**Stand:** 2026-04-28  
**Linear-Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Projektstatus:** Backlog  
**Repo:** `davidarlesterschmid-commits/emma`  
**Fuehrende Projektwahrheit:** Linear  
**Fuehrende Code-/Doku-Wahrheit:** GitHub  
**Letzter Linear-Sync:** Projektzuordnung, Blocker und Milestones in Linear gesetzt; siehe Abschnitt 13.

---

## 1. Zweck

Diese Datei spiegelt die aktuelle Linear-Ausfuehrungsstruktur fuer Gleichwertigkeit, Regelwerk, Routing, Subscription, BMM, Notifications, Wallet und Governance im Repo.

Sie dient nicht als Ersatz fuer Linear, sondern als nachvollziehbare Repo-Referenz fuer:

- Issue-Reihenfolge,
- Risikoklassen,
- Blocker,
- relevante Repo-Dokumente,
- Agenten-/Review-Gates,
- Traceability zwischen Produktwahrheit, Doku und Umsetzung.

---

## 2. Verbindliche Arbeitsregeln

1. Keine Arbeit ohne Linear-Issue.
2. Jeder Branch, Commit und PR enthaelt die Linear-ID.
3. Jede Arbeit hat eine Risikoklasse R0-R5.
4. Bei unklarer Risikoklasse gilt die hoehere plausible Klasse.
5. R0/R1 sind nach Self-Check oder Review mergefaehig.
6. R2 braucht Claude PASS oder passende Tests/Checks bzw. begruendete Auslassung.
7. R3/R4/R5 brauchen separates Gate und duerfen nicht automatisch gemerged werden.
8. Merge grundsaetzlich per Squash.
9. Nach Merge wird Linear mit PR-Link, Merge-SHA, Risiko, Review-Outcome, Scope und naechstem Schritt aktualisiert.
10. Keine Secrets, CI-/GitHub-Rechte, Massenformatierung, parallele Architektur- oder Produktlogik ausserhalb Scope ohne explizites Gate.
11. **Neue Linear-Issues** (insb. per MCP/API): Vorlage und Agent-Stopp-Regeln — [LINEAR_ISSUE_TEMPLATE.md](LINEAR_ISSUE_TEMPLATE.md).

---

## 3. Projektlink

| Artefakt | Link |
|---|---|
| Linear-Projekt | [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview) |

---

## 4. Issue-Map

Alle Issues in dieser Tabelle sind dem Linear-Projekt `emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM` zugeordnet.

| Issue | Titel | Risiko | Status / Zweck | Linear-Link |
|---|---|---:|---|---|
| EMM-99 | Routing-Selektion / Planungs-Engine nachschaerfen | R2 | Bewertungslogik, Hauptoption, Fallback, Stoerfall-/Garantieeignung | [EMM-99](https://example.invalid/emma-app-mdma/issue/EMM-99/r2-routing-selektion-planungs-engine-nachscharfen) |
| EMM-100 | Nutzerpraeferenzen / Lernlogik spezifizieren | R2 | Praeferenzen, Routinen, Consent, Automatisierungsgrade | [EMM-100](https://example.invalid/emma-app-mdma/issue/EMM-100/r2-nutzerpraferenzen-lernlogik-spezifizieren) |
| EMM-101 | Routing-Tests / Gleichwertigkeitsnachweis erweitern | R1/R2 | Test- und Nachweislogik fuer App-Gleichwertigkeit | [EMM-101](https://example.invalid/emma-app-mdma/issue/EMM-101/r1-routing-tests-gleichwertigkeitsnachweis-erweitern) |
| EMM-105 | QR-/Barcode-Anzeige-Flow fuer Ticket-Wallet spezifizieren | R2 | Ticket-Wallet-Anzeige, Credential, Fehlerzustaende | [EMM-105](https://example.invalid/emma-app-mdma/issue/EMM-105/r2-qr-barcode-anzeige-flow-fur-ticket-wallet-spezifizieren) |
| EMM-107 | Backend-Gleichwertigkeitsmatrix erstellen | R1/R2 | Backend-Aequivalenz, Pflichtadapter, Systemluecken | [EMM-107](https://example.invalid/emma-app-mdma/issue/EMM-107/r1-backend-gleichwertigkeitsmatrix-erstellen) |
| EMM-108 | Regelwerksversionierung und Produktkatalog in domain_rules | R2 | Produktkatalog, Regelversionen, Gueltigkeiten, Mock-vs-Real-Tarif | [EMM-108](https://example.invalid/emma-app-mdma/issue/EMM-108/r2-regelwerksversionierung-und-produktkatalog-in-domain-rules) |
| EMM-109 | domain_subscription fuer Abo, Deutschlandticket und Vertragsstatus | R2 | Subscription-/Entitlement-Modell, D-Ticket, Vertragsstatus | [EMM-109](https://example.invalid/emma-app-mdma/issue/EMM-109/r2-domain-subscription-fur-abo-deutschlandticket-und-vertragsstatus) |
| EMM-110 | Multi-Profil Privat/Arbeitgeber-Rollenmodell fuer BMM | R2 | Profil-Switch, Compliance-Hinweis, lokale Persistenz, BMM-Trennung | [EMM-110](https://example.invalid/emma-app-mdma/issue/EMM-110/r2-multi-profil-privat-arbeitgeber-rollenmodell-fur-bmm) |
| EMM-111 | Notification-Package / Kommunikationskanaele Phase 1 spezifizieren | R2 | Notification-Port, Trigger, Consent, In-App/Push/E-Mail-Entscheidung | [EMM-111](https://example.invalid/emma-app-mdma/issue/EMM-111/r2-notification-package-kommunikationskanale-phase-1-spezifizieren) |
| EMM-112 | Strukturpapier App-, Entwicklungs- und IP-Governance erstellen | R2/R3 | eG / Operations GmbH / TAF, IP, Related Party, Freigaben | [EMM-112](https://example.invalid/emma-app-mdma/issue/EMM-112/r2-strukturpapier-app-entwicklungs-und-ip-governance-erstellen) |
| EMM-113 | Startportfolio Phase 1 auf maximal fuenf Produkte begrenzen | R1/R2 | Gruendungskern, Produkt-Scope-Freeze, Pflichtfelder | [EMM-113](https://example.invalid/emma-app-mdma/issue/EMM-113/r2-startportfolio-phase-1-auf-maximal-funf-produkte-begrenzen) |

---

## 5. Empfohlene Ausfuehrungsreihenfolge

Die Reihenfolge ist in Linear ueber Projektinhalt und Milestones gesichert; eine harte manuelle UI-Sortierung ist nicht technisch erzwungen.

1. **EMM-107** — Backend-Gleichwertigkeitsmatrix erstellen.
2. **EMM-108** — Regelwerksversionierung und Produktkatalog in `domain_rules` spezifizieren.
3. **EMM-109** — `domain_subscription` fuer Abo, Deutschlandticket und Vertragsstatus vorbereiten.
4. **EMM-99** — Routing-Selektion / Planungs-Engine nachschaerfen.
5. **EMM-101** — Routing-Tests / Gleichwertigkeitsnachweis erweitern.
6. **EMM-100** — Nutzerpraeferenzen / Lernlogik spezifizieren.
7. **EMM-110** — Multi-Profil Privat/Arbeitgeber-Rollenmodell fuer BMM.
8. **EMM-111** — Notification-Package / Kommunikationskanaele Phase 1 spezifizieren.
9. **EMM-105** — QR-/Barcode-Anzeige-Flow fuer Ticket-Wallet spezifizieren.
10. **EMM-112** — Strukturpapier App-, Entwicklungs- und IP-Governance erstellen.
11. **EMM-113** — Startportfolio Phase 1 auf maximal fuenf Produkte begrenzen.

---

## 6. Blocker- und Abhaengigkeitslogik

### 6.1 In Linear gesetzte harte Blocker

| Abhaengiges Issue | Blocked by | Zweck |
|---|---|---|
| EMM-101 | EMM-107 | Routing-/Gleichwertigkeitstests duerfen Backend-Aequivalenz nicht ohne Matrix behaupten. |
| EMM-101 | EMM-99 | Routing-Tests brauchen spezifizierte Routing-Selektion / Planungs-Engine. |
| EMM-109 | EMM-108 | Subscription benoetigt Produkt-/Regelwerksmodell. |
| EMM-99 | EMM-108 | Routing-Selektion braucht Produkt-/Regelwerks- und Preisgrundlage. |
| EMM-105 | EMM-108 | Ticket-Wallet-Anzeige braucht Produkt-/Regelwerkskontext. |
| EMM-105 | EMM-109 | QR-/Barcode-/Wallet-Anzeige braucht Subscription-/Ticketkontext. |
| EMM-100 | EMM-99 | Praeferenz-/Lernlogik wirkt auf spezifizierte Routing-Selektion. |
| EMM-111 | EMM-100 | Notification-/Kommunikationskanaele brauchen Consent-/Praeferenzkontext. |

### 6.2 Als Kommentar dokumentierte abstrakte Blocker

| Issue | Kommentar / Wirkung |
|---|---|
| EMM-107 | Voraussetzung fuer belastbare Backend-/Adapter-Gleichwertigkeitsclaims. Keine Backend-Gleichwertigkeit ohne dokumentierten Adapter-, Test- oder Doku-Nachweis. |
| EMM-110 | Voraussetzung fuer tiefere BMM-Budget-/Benefit-Umsetzung, weil Privat-/Arbeitgeber-Kontext und Compliance-Hinweis vorher sauber modelliert sein muessen. |
| EMM-112 | Voraussetzung fuer verbindliche eG/GmbH/TAF-Beauftragungen, IP-Entscheidungen und Related-Party-Leistungsbeziehungen. |
| EMM-113 | Voraussetzung fuer Businessplan-/Gruendungspruefungs-Scope-Freeze. Produkte ohne belastbare Pflichtfelder sind nicht gruendungsreif. |

### 6.3 Fachlich relevante, aber nicht entfernte Alt-Relations

Bestehende aeltere Relations, insbesondere `related`-Beziehungen und der externe Blocker `EMM-97`, wurden bewusst nicht geloescht. Diese Datei dokumentiert den Zielzustand fuer das Projekt `emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM`, ersetzt aber keine historischen Traceability-Beziehungen.

---

## 7. Meilensteinstruktur in Linear

Die folgenden Milestones sind in Linear angelegt und mit den Issues verknuepft.

| Meilenstein | Zugeordnete Issues | Ziel |
|---|---|---|
| M1 Gleichwertigkeit & Backend-Matrix | EMM-107, EMM-101 | Nachweislogik fuer App- und Backend-Aequivalenz. |
| M2 Regelwerk / Produktkatalog / Subscription | EMM-108, EMM-109 | Fachliche Grundlage fuer Tarif, Produkte, Abo und D-Ticket. |
| M3 Routing / Tests / Praeferenzen | EMM-99, EMM-100, EMM-101 | Planungs-Engine, Bewertung, Fallback und Lernlogik. |
| M4 BMM / Wallet / Notifications | EMM-110, EMM-111, EMM-105 | Arbeitgeberprofil, Kommunikation und Ticket-Wallet-Faehigkeit. |
| M5 Governance / Startportfolio | EMM-112, EMM-113 | Gruendungs- und Governance-Faehigkeit fuer eG/GmbH/TAF und Phase-1-Scope. |

---

## 8. Relevante Repo-Dokumente

| Dokument | Zweck |
|---|---|
| `docs/product/PRODUCT_TRUTH.md` | Fuehrende Produktlogik fuer Assistant, Routing, Selection, Simulation und Open-Data-first. |
| `docs/architecture/TARGET_ARCHITECTURE.md` | Zielarchitektur aus aktuellem Repo-Stand. |
| `docs/architecture/MAPPING.md` | Mapping zwischen Modulen, Domains, Ports, Paketen und Product Truth. |
| `docs/planning/STATUS.md` | Historisch gewachsener Gesamtstatus. |
| `docs/planning/STATUS_PRODUCT_TRUTH_SYNC.md` | Aktueller Sync fuer Assistant, Journey und Routing. |
| `docs/planning/MVP_SCOPE.md` | MVP-Scope und Domain-Priorisierung. |
| `docs/technical/SPECS_MVP.md` | Uebergeordnete MVP-Spezifikation. |
| `docs/technical/SPECS_ROUTING_SELECTION.md` | Spezifikation fuer Routing-Selection, Scoring, Fallback, Multimodalitaet und Simulation. |
| `equivalence_matrix_apps.md` | Gleichwertigkeitsmatrix bestehender App-Welten, soweit im Repo vorhanden. |
| `docs/planning/LINEAR_EXECUTION_MAP.md` | Diese Datei; Repo-Spiegel der Linear-Ausfuehrungsstruktur. |

---

## 9. Agenten- und Gate-Zuordnung

| Risikoklasse | Agentenmodus | Gate |
|---|---|---|
| R0/R1 | Codex/Cursor nach Self-Check | Self-Check oder Review ausreichend. |
| R2 | Codex/Cursor mit Tests oder Doku-Nachweis | Claude PASS oder begruendete Test-/Check-Auslassung. |
| R3 | Codex/Claude Analyse, Cursor nur nach Gate | Separates Gate, kein Auto-Merge. |
| R4/R5 | Planung, Analyse, Gate-Vorbereitung | Kein Merge ohne explizite Freigabe. |

---

## 10. Offene fachliche Entscheidungen

| Thema | Zugehoerige Issues | Status |
|---|---|---|
| Pass-through vs. eigener emma-Vertrag fuer D-Ticket/Abo | EMM-109 | offen, im Issue dokumentiert |
| Push vs. In-App vs. E-Mail fuer Phase 1 | EMM-111 | offen, im Issue dokumentiert |
| Produktiver Tarifserver vs. Mock/Fake-Tarif im MVP | EMM-108, EMM-99 | Mock/Fake bis separates Gate |
| Produktive Partner-/Routing-Adapter | EMM-99, EMM-107 | nicht Default; separate Gate-Entscheidung |
| eG/GmbH/TAF-IP- und Beauftragungslogik | EMM-112 | offen bis Strukturpapier / Rechtspruefung |
| Phase-1-Startportfolio | EMM-113 | auf maximal fuenf Produkte zu begrenzen |

---

## 11. Definition of Done fuer diese Execution Map

Diese Execution Map ist aktuell, wenn:

- alle hier gelisteten Issues in Linear existieren,
- die Linear-Links erreichbar und eindeutig sind,
- alle hier gelisteten Issues dem Projekt zugeordnet sind,
- harte Blocker in Linear gesetzt oder nicht modellierbare Blocker als Kommentare dokumentiert sind,
- Milestones M1-M5 in Linear angelegt und zugeordnet sind,
- Risikoklassen und Reihenfolge dokumentiert sind,
- relevante Repo-Dokumente verlinkt sind,
- neue Arbeiten weiterhin ueber Linear-ID laufen,
- Abweichungen zwischen Repo und Linear als Delta dokumentiert werden.

---

## 12. Aenderungsregel

Aenderungen an dieser Datei duerfen nur erfolgen, wenn sich mindestens einer der folgenden Punkte aendert:

- Linear-Projektstruktur,
- Issue-Scope oder Issue-Reihenfolge,
- Risikoklasse,
- Blocker-/Dependency-Logik,
- fuehrende Produkt-/Architektur-Dokumente,
- Gate- oder Merge-Regeln.

---

## 13. Linear-Sync-Ergebnis

### 13.1 Projekt geprueft

| Feld | Wert |
|---|---|
| Projektname | emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM |
| Projekt-URL | https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727 |
| Projektstatus | Backlog |
| Milestones vorhanden | ja |

### 13.2 Projektzuordnung geprueft

Alle relevanten Issues sind dem Projekt zugeordnet:

- EMM-99
- EMM-100
- EMM-101
- EMM-105
- EMM-107
- EMM-108
- EMM-109
- EMM-110
- EMM-111
- EMM-112
- EMM-113

### 13.3 Projektzuordnung geaendert

Im Sync wurden folgende Issues dem Projekt zugeordnet:

- EMM-99
- EMM-100
- EMM-101
- EMM-105
- EMM-108
- EMM-109

Bereits korrekt zugeordnet waren:

- EMM-107
- EMM-110
- EMM-111
- EMM-112
- EMM-113

### 13.4 Rest-Delta

Linear ist weitgehend synchron mit dieser Execution Map. Es verbleiben folgende nicht blockierende Deltas:

1. Die Reihenfolge ist ueber Projektinhalt und Milestones dokumentiert, aber nicht als harte manuelle UI-Sortierung erzwungen.
2. Risikoangaben bleiben teilweise textuell gemischt formuliert (`R1/R2`, `R2/R3`) und sind nicht als separates strukturiertes Linear-Feld vereinheitlicht.
3. Bestehende aeltere Relations, insbesondere `related`-Beziehungen und der externe Blocker `EMM-97`, bleiben erhalten, weil der Sync keine historischen Relationen loeschen sollte.

### 13.5 Abschlussbewertung

Linear ist weitgehend synchron, aber es verbleiben folgende Deltas: Die Reihenfolge ist ueber Projektinhalt und Milestones dokumentiert, nicht als harte UI-Sortierung erzwungen; Risiko ist weiterhin nur textuell und nicht als separates strukturiertes Feld vereinheitlicht; bestehende Alt-Relations wurden bewusst nicht geloescht.
