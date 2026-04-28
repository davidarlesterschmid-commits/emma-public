# emma

Flutter/Dart-Monorepo für die **emma-App** — gemeinsames Frontend für öffentliche Mobilität in Mitteldeutschland (Android-first, iOS vorbereitet).

## Schnellstart

```bash
dart pub global activate melos
dart pub get
```

```bash
melos run analyze
melos run test:flutter
```

App lokal (Chrome, Fakes default):

```bash
cd apps/emma_app
flutter run -d chrome --dart-define=USE_FAKES=true
```

## Technologie-Stack (Kurz)

| Bereich | Technologie |
|---------|-------------|
| Framework | Flutter |
| Sprache | Dart (SDK siehe Root-`pubspec.yaml`, Workspace) |
| State | Riverpod (in der App-Shell) |
| Navigation | GoRouter |
| Monorepo | Melos, Dart Pub Workspace |

## Dokumentation

| Dokument | Inhalt |
|----------|--------|
| [docs/README.md](docs/README.md) | **Einstieg** — alle kannoischen Docs verlinkt |
| [AGENTS.md](AGENTS.md) | Regeln für KI-Agents, Setup, Architektur |
| [docs/planning/STATUS.md](docs/planning/STATUS.md) | Implementierungsstand, Planung, Audits |
| [docs/product/PRODUKT.md](docs/product/PRODUKT.md) | Lastenheft + Funktionskatalog (v1.0) |
| [docs/planning/MVP_SCOPE.md](docs/planning/MVP_SCOPE.md) | MVP-Scope 6+3+9 (ADR-04) |

Volltext alter Einzeldateien (Backup): `docs/_archive/2026-04-consolidation/`.

## Sicherheit

Echt-API-Keys (nur mit `USE_FAKES=false`) per `--dart-define=...` — nicht ins Repo committen.
