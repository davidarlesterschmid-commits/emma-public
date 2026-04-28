# SPECS — Notifications Phase 1

**Status:** gueltig fuer EMM-111  
**Stand:** 2026-04-28  
**Linear:** [EMM-111](https://example.invalid/emma-app-mdma/issue/EMM-111/r2-notification-package-kommunikationskanale-phase-1-spezifizieren)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / lokale In-App-Notification-Vorbereitung; R3 bei produktivem Push-, E-Mail-, Messaging-, Kampagnen- oder personenbezogenem Event-Backend.

---

## 1. Zweck

Diese Spezifikation definiert das Notification-Package Phase 1 fuer emma v1.0. Ziel ist ein nachvollziehbares Kommunikationsmodell fuer Journey-, Routing-, Wallet-, Subscription-, BMM- und Stoerfallereignisse.

Phase 1 schafft ein fachliches Notification-Modell und minimale In-App-Faehigkeit. Produktive Push-, E-Mail- oder Kampagnenintegrationen sind nicht Teil von EMM-111.

---

## 2. Bestehender Repo-Stand

Eine Suche nach `notification`, `notifications`, `push`, `in-app`, `email`, `consent` und `trigger` ergab keinen belastbaren bestehenden Notification-Domain-Zuschnitt.

Damit gilt fuer EMM-111:

```text
Status: fachlich neu vorzubereiten
Keine produktive Push-/E-Mail-/Messaging-Integration
Kein Kampagnen- oder Massenversand im Scope
```

---

## 3. Leitentscheidungen

1. Phase 1 priorisiert In-App-Notifications/Banner als minimalen Kanal.
2. Push und E-Mail bleiben konzeptionell modelliert, aber nicht produktiv angebunden.
3. Kein Notification-Versand ohne passenden Consent Scope aus EMM-100.
4. Notifications muessen ausloesendes Ereignis, Kanal, Prioritaet, Status und DecisionTrace enthalten.
5. BMM-/Arbeitgeberbezug darf nur bei aktivem Arbeitgebermodus und Consent verwendet werden.
6. Keine externen Nachrichten an Partner, Arbeitgeber oder Nutzer ohne separates Gate.
7. Notifications duerfen keine Buchung, Zahlung oder Vertragsaenderung ausloesen.

---

## 4. Zielmodell

| Objekt | Zweck |
|---|---|
| `NotificationEvent` | Ausloesendes fachliches Ereignis, z. B. Route ready, Ticket missing, Stoerung. |
| `NotificationMessage` | Nutzergerichtete Nachricht mit Titel, Body, Prioritaet und Kanal. |
| `NotificationChannel` | `inApp`, `push`, `email`, `systemLog`. |
| `NotificationTrigger` | Regel, wann aus einem Ereignis eine Nachricht wird. |
| `NotificationConsent` | Kanal- und Zweckfreigabe aus EMM-100. |
| `NotificationStatus` | queued, displayed, dismissed, failed, suppressed. |
| `NotificationDecisionTrace` | Warum wurde gesendet, unterdrueckt oder nur In-App angezeigt. |

---

## 5. Kanaele

| Kanal | Phase-1-Status | Hinweise |
|---|---|---|
| `inApp` | erlaubt | Minimaler Standard fuer Banner/Card/Inbox. |
| `push` | modelliert, nicht produktiv | Nur mit explizitem Consent und separatem Adapter-Gate. |
| `email` | modelliert, nicht produktiv | Nur mit explizitem Consent und separatem Adapter-Gate. |
| `systemLog` | erlaubt | Interner Trace, nicht Nutzerkommunikation. |

---

## 6. Trigger-Typen

| Trigger | Quelle | Kanal Phase 1 | Beispiel |
|---|---|---|---|
| `journeyReady` | EMM-97/EMM-99 | inApp | Deine Route ist vorbereitet. |
| `routeFallback` | EMM-99 | inApp | Fuer nextbike liegen keine Daten vor. |
| `routeDisruption` | spaeter Realtime/M07 | inApp | Es gibt eine Stoerung auf deiner Route. |
| `subscriptionExpiring` | EMM-109 | inApp | Dein Abo laeuft bald ab. |
| `subscriptionUnknown` | EMM-109 | inApp | Dein Vertragsstatus kann nicht bestaetigt werden. |
| `credentialMissing` | EMM-105 | inApp | Dein Ticketnachweis ist nicht verfuegbar. |
| `walletSimulationReady` | EMM-105 | inApp | Simulierter Nachweis vorbereitet. |
| `bmmComplianceRequired` | EMM-110 | inApp | Arbeitgebermodus erfordert Bestaetigung. |
| `budgetLow` | EMM-110 | inApp | Dein simuliertes Mobilitaetsbudget ist niedrig. |
| `receiptRequired` | EMM-110/EMM-105 | inApp | Fuer diese Fahrt ist ein Beleg erforderlich. |

---

## 7. Consent-Regeln

Notification-Ausgabe braucht Consent gemaess Zweck und Kanal.

| Fall | Regel |
|---|---|
| In-App Systemhinweis fuer aktuelle Session | erlaubt, wenn notwendig fuer Funktion/Fehlervermeidung. |
| Push | nur mit `notificationConsent.push == true`. |
| E-Mail | nur mit `notificationConsent.email == true`. |
| Arbeitgeberbezug | nur mit `employerContext` + aktivem Arbeitgebermodus. |
| Standort-/Kalenderbezug | nur mit spezifischem Scope aus EMM-100. |
| Marketing/Kampagne | nicht Scope. |

Kein fehlender Consent darf als Zustimmung interpretiert werden.

---

## 8. Prioritaeten

| Prioritaet | Bedeutung | Beispiel |
|---|---|---|
| `info` | neutraler Hinweis | Simulation aktiv. |
| `actionRequired` | Nutzer muss etwas pruefen/bestaetigen | Credential fehlt, Abo unknown. |
| `warning` | Risiko oder Einschraenkung | Fallback, Budget niedrig. |
| `critical` | Stoerfall/Garantie/Service | Route nicht durchfuehrbar, Ersatzpfad noetig. |

---

## 9. Beziehung zu EMM-99 Routing

Routing kann Notifications erzeugen fuer:

- Journey ready,
- Fallback-Route,
- alle Daten fehlen,
- Garantieeignung unklar,
- robuste Route bevorzugt,
- Nutzerpraeferenz beeinflusst Auswahl.

NotificationTrace muss `journeyContextId` oder `planningSelectionId` referenzieren.

---

## 10. Beziehung zu EMM-105 Wallet

Wallet/Credential kann Notifications erzeugen fuer:

- Credential missing,
- Credential expired,
- fake/simulation active,
- WalletItem prepared,
- receipt required.

Bei Fake/Fallback:

```text
Notification muss Simulation/Fake klar benennen.
```

---

## 11. Beziehung zu EMM-109 Subscription

Subscription kann Notifications erzeugen fuer:

- unknown status,
- expired,
- suspended,
- expiring soon,
- provider reference missing.

`unknown` darf nie als aktive Berechtigung kommuniziert werden.

---

## 12. Beziehung zu EMM-110 BMM

BMM-Notifications duerfen nur entstehen, wenn:

```text
profileMode == employer
AND ComplianceAcknowledgement vorhanden oder bmmComplianceRequired als In-App-Hinweis
AND employerContext Consent aktiv, falls personenbezogene Arbeitgeberdaten betroffen sind
```

Keine Nachricht an Arbeitgeber in Phase 1.

---

## 13. Nicht-Scope

- Kein produktiver Push-Anbieter.
- Kein E-Mail-Versand.
- Kein Kampagnensystem.
- Kein Massenversand.
- Keine personenbezogene Segmentierung.
- Keine Arbeitgeberbenachrichtigung.
- Keine Partnerbenachrichtigung.
- Keine Live-Realtime-Integration.

---

## 14. Akzeptanzkriterien

1. NotificationEvent, NotificationMessage, Channel, Trigger, Status und Trace sind fachlich modellierbar.
2. In-App ist als Phase-1-Kanal definiert.
3. Push und E-Mail sind nur modelliert, nicht produktiv.
4. Consent-Regeln sind kanal- und zweckbezogen definiert.
5. Trigger aus Routing, Wallet, Subscription und BMM sind abbildbar.
6. Fake-/Simulation-/Fallback-Zustaende werden transparent kommuniziert.
7. Keine Notification loest Buchung, Zahlung oder Vertragsaenderung aus.
8. Arbeitgeberbezug ist ohne aktiven Arbeitgebermodus/Consent unterdrueckt.

---

## 15. Testfaelle

| Test | Erwartung |
|---|---|
| Journey ready | In-App Hinweis wird erzeugt. |
| nextbike Fallback | In-App Warnung mit Fallback-Hinweis. |
| Credential missing | actionRequired Hinweis. |
| Fake Wallet | Info mit Simulation-Hinweis. |
| Subscription unknown | actionRequired, nicht als aktiv dargestellt. |
| Push ohne Consent | suppressed mit Trace. |
| E-Mail ohne Consent | suppressed mit Trace. |
| Arbeitgeberkontext ohne Consent | suppressed oder nur neutraler Compliance-Hinweis. |
| Receipt required | In-App Hinweis im Arbeitgebermodus. |

---

## 16. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-98 | Auswahlbildschirm kann In-App-Hinweise anzeigen. |
| EMM-99 | Routing erzeugt Fallback-/Journey-Events. |
| EMM-100 | Consent- und Praeferenzlogik steuert Kanaele. |
| EMM-105 | Wallet-/Credential-Zustaende erzeugen Events. |
| EMM-110 | Arbeitgebermodus und BMM-Entitlements beeinflussen Trigger. |
| Spaeter M07 | Stoerfall-/Mobilitaetsgarantie-Events. |

---

## 17. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-111 in Code umgesetzt wird.

Review-Fragen:

1. Sind Push/E-Mail nicht produktiv vorweggenommen?
2. Wird fehlender Consent sicher unterdrueckt?
3. Sind Fake/Fallback/Simulation transparent?
4. Gibt es keine externe Nachricht an Arbeitgeber/Partner?
5. Ist das Modell kompatibel mit EMM-98, EMM-99, EMM-100, EMM-105 und EMM-110?

---

## 18. Agentenauftrag

**Codex**

- Notification-Modelle und lokale In-App-Fake-Queue vorbereiten.
- Unit Tests fuer Consent, Suppression, Trigger und Trace.
- Keine produktiven Push-/E-Mail-/Messaging-Adapter.
- Keine UI ausser minimaler ViewModel-Faehigkeit.

**Claude**

- Review auf Consent, Scope, Fake-vs-real-Trennung und Eventmodell.

**Cursor**

- Erst nach R2-Gate fuer In-App-Banner-/Screen-Integration verwenden.
