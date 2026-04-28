# Governance: Traceability-Policy

Stand: 2026-04-25

**Traceability-Pflicht:** Jede planbare Aenderung mit Produkt- oder Code-Relevanz muss fachlich nachvollziehbar **mindestens ein Modul (M01–M16)** und **mindestens eine Funktion / Funktionskatalog-Bezug** benennen. Technische und Governance-**Quellen der Wahrheit** bleiben: **Linear (Projekt)**, **GitHub (Code)** — siehe [agent_operating_model.md](agent_operating_model.md).

## 1) Modul-Bezug (Modultabelle / Taxonomie)

- **Kanonische Modul-Taxonomie M01–M16**, Begriffe und Zuordnungen: [../architecture/MAPPING.md](../architecture/MAPPING.md) — das ist die im Repo gefuehrte **Modultabelle** im Sinne der Architektur.
- **Backlog-/Implementierungsnachweise B01–B14** inkl. Mapping M01–M16 und Repo-Pfaden: [../architecture/module_traceability.md](../architecture/module_traceability.md) (keine Ersatz-Moduldefinition; ergaenzt MAPPING).

*Pflicht in Issues/PRs:* betroffene **M0x-Module** nennen oder begruenden, warum kein Modulberuehr (reine Meta-Aenderung).

## 2) Funktions-Bezug (Funktionskatalog v1.0)

- **Funktionskatalog v1.0** (Lastenheft-Integration): [../product/PRODUKT.md](../product/PRODUKT.md).
- Historische/Archiv-Referenz: [../_archive/2026-04-consolidation/FUNKTIONSKATALOG_v1.0.md](../_archive/2026-04-consolidation/FUNKTIONSKATALOG_v1.0.md).

*Pflicht in Issues/PRs:* relevante **Funktions- oder Mxx-Fach-Referenz** (Kapitel/ID wie im Katalog) oder begruendeter Verweis auf Spez-Abweichung in Linear.

## 3) Gleichwertigkeitsmatrix

- **Backend-Gleichwertigkeitsmatrix** (Aequivalenz Hintergrundsysteme / Pflichtadapter): [../planning/equivalence_matrix_backends.md](../planning/equivalence_matrix_backends.md).
- App-/Welten-Paritaet und weitere Matrizen: nach Linear und Ausfuehrungskarte — [../planning/LINEAR_EXECUTION_MAP.md](../planning/LINEAR_EXECUTION_MAP.md); Gleichwertigkeits-Tests/Specs (z. B. Routing, Wallet) verweisen auf die jeweils geltende Matrix, sobald pro Ticket vorgesehen.

*Pflicht:* Wo ein Ticket **Gleichwertigkeits- oder Paritaetsnachweis** behauptet, muss der Bezug zur **geltenden Matrix-Datei bzw. Linear-Nachweis-EMM** im Issue/PR stehen.

## 4) Aenderung von Traceability-Artefakten

Aendern Modul-Ports, B01–B14-Zeilen, Katalog-Abdeckung oder Aequivalenz-Claims **mit**: entsprechende Doku/Traceability-Tabellen in demselben oder einem Folge-Ticket **pflegen** (R3+ laut [../operations/automerge_policy.md](../operations/automerge_policy.md) wo tabellarischer oder Domain-Contract-Impact).

## Verweis

Review- und R-Klassen-Gates bei Modul-Contract-Aenderungen: [review_policy.md](review_policy.md), [../operations/automerge_policy.md](../operations/automerge_policy.md). Definition of Done: [../planning/DEFINITION_OF_DONE.md](../planning/DEFINITION_OF_DONE.md).
