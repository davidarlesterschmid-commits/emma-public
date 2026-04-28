# SPECS — Nutzerpraeferenzen und Lernlogik

**Status:** gueltig fuer EMM-100  
**Stand:** 2026-04-28  
**Linear:** [EMM-100](https://example.invalid/emma-app-mdma/issue/EMM-100/r2-nutzerpraferenzen-lernlogik-spezifizieren)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / lokale Domain-Vorbereitung; R3 bei personenbezogenen Live-Daten, externer Profil-/Kalender-/Standortintegration oder automatisierten kosten-/vertragsrelevanten Entscheidungen.

---

## 1. Zweck

Diese Spezifikation definiert das Praeferenz-, Consent- und Lernmodell fuer die emma App v1.0. Ziel ist eine nachvollziehbare, datenschutzbewusste und deterministische Personalisierung der Routing-/Journey-Entscheidung aus EMM-99.

Die Lernlogik darf Vorschlaege und Gewichtungen verbessern, aber keine intransparenten kosten- oder vertragsrelevanten Aktionen ausloesen.

---

## 2. Bestehender Repo-Stand

Eine Suche nach `preferences`, `user preference`, `learning`, `automation`, `consent`, `profile` und `SharedPreferences` ergab keinen belastbaren bestehenden Domain-Zuschnitt fuer eine zentrale Praeferenz-/Lernlogik.

Damit gilt fuer EMM-100:

```text
Status: fachlich neu vorzubereiten
Keine externe Profil-/Consent-/Kalender-/Standortintegration im Scope
Keine automatische Vertrags-/Kostenentscheidung
```

---

## 3. Leitentscheidungen

1. Praeferenzen werden in harte Constraints, weiche Gewichtungen und implizite Lernsignale getrennt.
2. Harte Constraints duerfen nicht durch Lernen uebersteuert werden.
3. Lernen ist regelbasiert, lokal und deterministisch; kein ML/Blackbox im MVP.
4. Nutzer kann Praeferenzen und Lernzustand einsehen, zuruecksetzen oder deaktivieren.
5. Automatisierungsgrade werden explizit gespeichert: `recommendOnly`, `prepareAfterConfirmation`, `executeAfterExplicitApproval`.
6. Kosten- oder vertragsrelevante Schritte bleiben ohne explizite Freigabe verboten.
7. Consent ist Voraussetzung fuer jede Nutzung sensibler Kontextdaten.

---

## 4. Zielmodell

### 4.1 Kernobjekte

| Objekt | Zweck |
|---|---|
| `UserMobilityProfile` | Container fuer Praeferenzen, Consent, Automatisierungsgrad und Lernzustand. |
| `ExplicitPreference` | Vom Nutzer gesetzte Praeferenz, z. B. Verkehrsmittel bevorzugen/vermeiden. |
| `HardConstraint` | Nicht uebersteuerbare Vorgabe, z. B. barrierefrei, keine Scooter, max. 1 Umstieg. |
| `SoftWeightPreference` | Gewichtung fuer Scoring, z. B. schneller, guenstiger, komfortabler. |
| `ImplicitLearningSignal` | Aus Nutzung abgeleitetes Signal, z. B. haeufige Taxi-Auswahl. |
| `AutomationConsent` | Erlaubte Automatisierungsgrade je Aktionsklasse. |
| `ConsentScope` | Datenfreigabe fuer Standort, Kalender, Historie, Notifications, BMM-Kontext. |
| `PreferenceDecisionTrace` | Nachvollziehbarkeit, welche Praeferenz eine Entscheidung beeinflusst hat. |

---

## 5. Praeferenztypen

| Typ | Beispiel | Wirkung |
|---|---|---|
| Hard Constraint | barrierefrei erforderlich | Filtert unzulaessige Kandidaten. |
| Hard Constraint | max. 1 Umstieg | Kandidaten mit mehr Umstiegen unzulaessig. |
| Soft Preference | moeglichst guenstig | Veraendert Scoring-Gewichte. |
| Soft Preference | moeglichst schnell | Veraendert Scoring-Gewichte. |
| Soft Preference | komfortabel | Komfort/Umstiegsrisiko hoeher gewichten. |
| Modal Preference | OePNV bevorzugt | Bonus fuer OePNV-Kandidaten. |
| Modal Avoidance | Taxi vermeiden | Malus fuer Taxi, aber nicht zwingend Ausschluss. |
| Context Preference | Arbeitsweg robust | Zuverlaessigkeit/Garantie hoeher gewichten. |

---

## 6. Automatisierungsgrade

| Grad | Bedeutung | Erlaubt |
|---|---|---|
| `recommendOnly` | emma empfiehlt nur. | Routing, Hinweise, Erklaerung. |
| `prepareAfterConfirmation` | emma bereitet nach bestaetigtem Anlass vor. | Auswahl, Stub-/Fallback-Vorbereitung, Wallet-Simulation. |
| `executeAfterExplicitApproval` | emma darf nach expliziter Einzelfreigabe ausfuehren. | Simulierte Buchung/Wallet im MVP. |

Nicht erlaubt ohne separates Gate:

- echte Zahlung,
- echte Buchung,
- echte Vertragsaenderung,
- automatische Kuendigung/Pausierung,
- externe Nachricht an Partner oder Arbeitgeber.

---

## 7. Consent Scopes

| Scope | Wirkung | Default |
|---|---|---|
| `locationContext` | Standort fuer Anlass/Routing nutzen. | aus |
| `calendarContext` | Kalender fuer implizite Anlaesse nutzen. | aus |
| `journeyHistory` | abgeschlossene Reisen fuer Lernen nutzen. | aus |
| `notificationConsent` | Push/In-App/E-Mail je Kanal. | aus / kanalabhaengig |
| `employerContext` | BMM-/Arbeitgeberbezug nutzen. | aus bis Profilwechsel/Freigabe |
| `accessibilityNeeds` | Barrierefreiheitsbedarf speichern. | explizit |

Grundsatz:

```text
Kein sensibler Kontext ohne Consent.
Kein fehlender Consent darf als Zustimmung interpretiert werden.
```

---

## 8. Lernlogik

### 8.1 MVP-Lernprinzip

Lernen ist lokal, regelbasiert und begrenzt:

```text
letzte 3-5 relevante Entscheidungen
maximal +10 Prozentpunkte Einfluss auf Modal-/Scoring-Gewicht
Reset jederzeit moeglich
```

### 8.2 Erlaubte Lernsignale

| Signal | Wirkung |
|---|---|
| Nutzer waehlt wiederholt gleiche Mobilitaetsoption | leichter Bonus fuer diese Option. |
| Nutzer verwirft wiederholt bestimmte Option | leichter Malus fuer diese Option. |
| Nutzer waehlt haeufig `fast` | Zeit/Zuverlaessigkeit leicht hoeher. |
| Nutzer waehlt haeufig `cheap` | Preis leicht hoeher. |
| Nutzer akzeptiert Fallback nie | FallbackPenalty erhoehen. |
| Nutzer nutzt Arbeitgebermodus | BMM-konforme Optionen bevorzugen, falls Consent aktiv. |

### 8.3 Nicht erlaubte Lernfolgen

Lernen darf nicht:

- harte Constraints lockern,
- unknown Subscription als active behandeln,
- teurere Optionen automatisch buchen,
- echte Zahlungen ausloesen,
- Arbeitgeberdaten ohne Consent verwenden,
- personenbezogene Daten extern synchronisieren,
- Nutzerentscheidungen unerklaerbar machen.

---

## 9. Einfluss auf EMM-99 Scoring

Praeferenzen liefern ein `PreferenceAdjustment` an die Planungs-Engine.

### 9.1 Beispielstruktur

| Feld | Bedeutung |
|---|---|
| `modeOverride` | balanced, fast, cheap, comfortable, robust. |
| `modalBonuses` | Bonus je Mobilitaetsoption. |
| `modalPenalties` | Malus je Mobilitaetsoption. |
| `maxTransfers` | harter Filter, wenn gesetzt. |
| `requiresAccessibility` | harter Filter/hohe Gewichtung. |
| `fallbackPenaltyAdjustment` | erhoeht/senkt Stub-Malus. |
| `trace` | Herkunft der Anpassung. |

### 9.2 Grenzen

```text
Gesamteinfluss impliziter Lernsignale <= 10 Prozentpunkte
Explizite Soft Preferences duerfen staerker wirken
Hard Constraints haben Vorrang vor Score
```

---

## 10. Persistenz

### 10.1 MVP

Im MVP ist lokale Persistenz erlaubt, z. B. `SharedPreferences` oder aequivalenter lokaler Storage.

Pflicht:

- versioniertes Schema,
- Reset-Funktion,
- kein Klartext sensibler Details, wenn vermeidbar,
- keine Cloud-Synchronisierung ohne Gate.

### 10.2 Modellversionierung

| Feld | Zweck |
|---|---|
| `profileVersion` | Version des lokalen Praeferenzschemas. |
| `updatedAt` | letzte Aenderung. |
| `learningEnabled` | Lernen aktiv/inaktiv. |
| `learningResetAt` | letzter Reset. |

---

## 11. Transparenz / UX-Anforderungen

Auch wenn EMM-100 keine UI umsetzt, muss das Modell folgende UX-Anforderungen unterstuetzen:

- Anzeige, welche Praeferenzen aktiv sind.
- Hinweis, wenn eine Empfehlung durch Praeferenzen beeinflusst wurde.
- Reset von Lernlogik.
- Deaktivierung von Lernen.
- getrennte Anzeige expliziter Praeferenzen vs. gelernte Anpassungen.

---

## 12. Nicht-Scope

- Kein ML-Modell.
- Keine externe Profilplattform.
- Keine Kalender-/Standort-Liveintegration.
- Keine automatische Zahlung/Buchung/Vertragsaenderung.
- Keine Arbeitgeberdatenverarbeitung ohne EMM-110-Kontext.
- Keine UI-Umsetzung.

---

## 13. Akzeptanzkriterien

1. Praeferenzen sind in harte Constraints, weiche Gewichtungen und Lernsignale getrennt.
2. Automatisierungsgrade sind modellierbar.
3. Consent Scopes sind modellierbar und Default nicht zustimmend.
4. Lernen ist regelbasiert, begrenzt und resetbar.
5. Implizites Lernen kann Scoring maximal begrenzt beeinflussen.
6. Hard Constraints haben Vorrang vor Scoring.
7. Keine kosten- oder vertragsrelevante Aktion ohne explizite Freigabe.
8. EMM-99 kann ein PreferenceAdjustment konsumieren.
9. DecisionTrace dokumentiert Praeferenz- und Lernwirkung.

---

## 14. Testfaelle

| Test | Erwartung |
|---|---|
| Kein Consent | sensible Kontexte werden nicht genutzt. |
| Hard Constraint maxTransfers=1 | Route mit 2 Umstiegen wird ausgeschlossen. |
| Soft Preference cheap | Preisgewichtung steigt. |
| Wiederholte Taxi-Auswahl | Taxi-Bonus steigt bis maximaler Grenze. |
| Lern-Reset | alle impliziten Anpassungen geloescht. |
| Unknown Subscription | Lernen darf Status nicht als active behandeln. |
| EmployerContext ohne Consent | keine BMM-Praeferenzwirkung. |
| DecisionTrace | enthaelt Quelle: explicit, learned, consent, default. |

---

## 15. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-99 | Konsumiert PreferenceAdjustment in Scoring. |
| EMM-111 | Notification-Kanaele und Trigger brauchen Consent-/Praeferenzkontext. |
| EMM-110 | Arbeitgeberprofil und BMM-Kontext erweitern Praeferenzmodell. |
| EMM-101 | Tests muessen Praeferenzwirkung und Grenzen pruefen. |

---

## 16. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-100 in Code umgesetzt wird.

Review-Fragen:

1. Sind Consent Defaults sicher und nicht zustimmend?
2. Sind Hard Constraints nicht durch Lernen uebersteuerbar?
3. Ist Lernen deterministisch und begrenzt?
4. Gibt es keine kosten-/vertragsrelevante Automatisierung ohne Freigabe?
5. Ist die Scoring-Anbindung an EMM-99 nachvollziehbar?

---

## 17. Agentenauftrag

**Codex**

- Praeferenz- und Lernmodelle vorbereiten.
- Lokale Persistenz nur nicht-sensitiv und versioniert.
- Unit Tests fuer Constraints, Consent, Lernen, Reset und PreferenceAdjustment.
- Keine externe Integration.
- Keine UI.

**Claude**

- Datenschutz-/Compliance-/Architekturreview.
- Pruefung gegen EMM-99, EMM-101 und EMM-110.

**Cursor**

- Nur nach R2-Gate fuer fokussierte Integration in App-/Journey-Flow verwenden.
