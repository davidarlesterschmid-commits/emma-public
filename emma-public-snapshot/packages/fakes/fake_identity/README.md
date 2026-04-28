# fake_identity

Drei feste **Demo-Accounts** (E-Mail, Passwort) fuer `USE_FAKES=true` — Quelle: `lib/src/fake_account_catalog.dart`.

- `demo@emma.de` / `demo2026` → `user-demo-001`
- `pilot@emma.de` / `demo2026` → `user-pilot-002`
- `firmenkunde@emma.de` / `admin2026` → `user-firm-003`

Echten IdP-Call ersetzen: `USE_FAKES=false` nutzt die Stub-Remote in `AuthRemoteDataSourceImpl`.
