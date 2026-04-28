# Automerge- und Branch-Policy — emma-public (EMM-227)

Dieses Repo ist **proprietär sichtbar**, kein vollständiger Quellcode des Produkts. **Automerge** ist absichtlich **streng** und existiert **nur** hier, nicht im privaten `emma`-Monorepo.

## Labels (anlegen in GitHub: *Issues → Labels*)

| Name | Bedeutung |
| --- | --- |
| `risk/R0` | Trivial / rein organisatorisch (z. B. Typo, Meta). Automerge **nur** mit weiteren Voraussetzungen. |
| `risk/R1` | Kleine, klar abgegrenzte Doku- oder Lint-Änderungen. |
| `risk/R2` / `risk/R3` | Höheres Risiko — **kein** Automerge; mindestens ein menschliches Review vor Merge. |
| `public-safe` | Inhalt ist für die **öffentliche** Sicht des Repos unkritisch; Voraussetzung für Automerge. |
| `no-automerge` | Erzwingt **manuellen** Merge (z. B. Sync, Legal, Sicherheitsreview). |
| `dependencies` | (optional) z. B. von Dependabot gesetzt. |

**Regel:** PRs ohne `public-safe` bekommen **keinen** Automerge (u. a. *Public-Sync-*PRs bleiben manuell, wenn `public-safe` bewusst weggelassen wird).

## Workflows

| Workflow | Rolle |
| --- | --- |
| `CI` | Pflicht-Check; in Branch Protection **erforderlich** (siehe unten). |
| `automerge (R0 or R1 only)` | Wenn Labels + Dateipfade passen: `enablePullRequestAutoMerge` (Squash), sobald **alle** Checks grün. |

Voraussetzungen: **Settings → General →** *Allow auto-merge* **ein**.

## Gesperrte Pfade (kein Automerge, Workflow kommentiert nur)

- Root-/Pfad-`LICENSE`
- `.github/workflows/`
- `docs/private/`
- beliebiger Pfad mit Segment `tariff`, `partner`, `guarantee`, `migration`

## Branch Protection (manuell in GitHub, Empfehlung)

Auf `main`:

- *Require a pull request before merging*
- *Require status checks to pass* → z. B. `validate` (Job aus `ci.yml`, Name je nach Sicht: „CI / validate“) **oder** den exakten Check-Namen, den GitHub anzeigt
- *Require linear history* (optional)
- *Do not* erlauben, dass *Administrators* Regeln dauerhaft umgehen, außer für Notfälle (Org-Policy)
- *Require code owner reviews*: nur aktiv, wenn in `.github/CODEOWNERS` **gültige** @Handles gesetzt sind

`CODEOWNERS` in diesem Repo ist vorerst **nur Kommentar** — reale @Handles eintragen, damit kritischer Schutz greift.

## Restrisiko

- Automerge baut auf **Label-Disziplin**; falsch gesetzte `public-safe` + `risk/R0` umgeht die Absicht.
- **Fork-PRs:** der Workflow führt keinen Automerge auf Forks aus (`head.repo == base.repo`).
- `enablePullRequestAutoMerge` scheitert, wenn *Allow auto-merge* fehlt oder org-weite Einschränkungen greifen.
- Vollständige rechtliche Freigabe ersetzt diese Policy nicht.
