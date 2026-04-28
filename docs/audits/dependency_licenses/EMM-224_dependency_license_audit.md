# Dependency- und Transitiv-Lizenzen — EMM-224

| Feld | Wert |
| --- | --- |
| Issue | EMM-224 |
| Risiko | R3 Audit-only |
| Stand | 2026-04-28 |
| Bezug | Proprietäres Root-`LICENSE` (All rights reserved); Third-Party bleibt bei jeweiligen Lizenzen |

## Kurzfazit: **GO**

Für den **Pub-Workspace** (`dart pub deps --json` am Monorepo-Root) sind **122** eindeutige **hosted** Pakete erfasst. In den **pub.dev**-`license:`-Tags (Pana) **keine** Treffer auf **GPL-, AGPL-, LGPL-, MPL- oder EPL**-Familien. Dominanz **permissive** Lizenzen (BSD-2/3, MIT, Apache-2.0, Zlib). **Kein BLOCK**-Kandidat aus automatischer Klassifikation.

**Offen** (außerhalb Dart-Pub): native **Android/iOS-Buildtooling** (Gradle, Xcode, ggf. NDK), **Flutter-Engine**-Binaries — separat in Release-Prozess/Store-Compliance prüfen; nicht Gegenstand der reinen Pub-Dependency-Liste.

---

## BLOCK / REVIEW (zuerst)

### BLOCK

*Keine* — kein Paket mit Copyleft-/Strong-Block-Tags (GPL/AGPL/…) in der pub.dev-Score-Auswertung für diesen Snapshot.

### REVIEW (automatisiert)

| Paket | Version | Anmerkung |
| --- | --- | --- |
| `typed_data` | 1.4.0 | **pub.dev**-Score hatte **keine** `license:`-Tags. **Manuell:** `LICENSE` im lokalen Pub-Cache = **BSD-3-Clause** (Dart project authors). `classification_resolved`: **OK** in `EMM-224_findings.json`. |

### SDK (`source: sdk` in `dart pub deps`)

`flutter`, `sky_engine`, `flutter_web_plugins`, `flutter_localizations`, `flutter_test` — **nicht** als hosted-Paket lizenziert; Lizenstexte liegen in der **Flutter-SDK-Installation** (u. a. Engine: BSD-3-Clause). Kein Widerspruch zur obigen Bewertung erkennbar; technische **Store-/NDK-**Themen separat.

---

## Aggregat (pub.dev-Tags, 122 Pakete)

Häufigkeit der erkannten `license:*`-Tag-Kernbegriffe (mehrfach pro Paket möglich):

| Lizenz-Familie (Tag) | ca. Vorkommen |
| --- | ---: |
| `bsd-3-clause` | 99 |
| `mit` | 14 |
| `apache-2.0` | 8 |
| `bsd-2-clause` | 1 |
| `zlib` (zusätzlich zu BSD bei `vector_math`) | 1 |
| `fsf-libre` / `osi-approved` (Kategorien) | je 121 |
| leer (nur `typed_data`, siehe oben) | 1 |

---

## Vollständige Lizenzmatrix

Maschinenlesbar mit je Paket: Name, Version, `license_tags`, Klassifikation **OK** / **REVIEW** / **BLOCK**, sowie ggf. `license_file_note` / `classification_resolved` — Datei:

[`EMM-224_findings.json`](EMM-224_findings.json)

---

## Methodik (Kurz)

1. `dart pub get` im Repo-Root; `dart pub deps --json` (enthält **transitive** Abhängigkeiten des gesamten Workspaces).
2. Alle Einträge mit `"source": "hosted"` → eindeutige Paare `name@version` → **122** Pakete.
3. Pro Paket: `GET https://pub.dev/api/packages/{name}/score` — **license:**\* aus `tags` lesen.
4. Klassifikation: Substrings `gpl`/`agpl`/`copyleft` → **BLOCK**; `lgpl`/`mpl`/`epl` → **REVIEW**; leere Tags → **REVIEW** bis manuell geklärt.
5. **Keine** Abhängigkeiten geändert; **keine** fremden Lizenztexte editiert.

---

## Public-Go-Empfehlung (proprietärer Code + public sichtbar)

| Empfehlung | Begründung |
| --- | --- |
| **GO** | Kein ungeprüfter Copyleft-Blocker in der Pub-Dependency-Menge; `typed_data` durch LICENSE-Datei abgesichert. Apache-2.0/MIT-Bestandteile: üblich **Attribution** / **NOTICE**-Hinweise in ausgelieferten Builds beachten (org-interne Policy). |

*Rechtlich verbindlich nur nach Freigabe durch Bevollmächtigte; dieses Dokument ist technische Audit-Stütze, keine Rechtsberatung.*
