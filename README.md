# emma — public transparency snapshot

This repository is a **curated, read-only snapshot** of selected governance and audit materials for the **emma** project. It does **not** contain application source code or internal product documentation from the private monorepo.

**Status (audits):**

- **EMM-222** — Public-readiness: **GO** (see `docs/audits/public_readiness/EMM-222_findings.json`).
- **EMM-223** — PII / proprietary `LICENSE` follow-up: reflected in the same findings and audit.
- **EMM-224** — Dependency and transitive license review (Pub): **GO** (see `docs/audits/dependency_licenses/`).

## License

This repository is publicly visible but not open source.

All rights are reserved by David Arlester Schmid. No permission is granted to copy, modify, distribute, sublicense, sell, or use the contents of this repository without prior written permission.

Third-party open-source components referenced in the EMM-224 materials remain subject to their respective licenses. See the root [`LICENSE`](LICENSE) file.

## Contents of this snapshot

| Path | Description |
| --- | --- |
| `LICENSE` | Proprietary license (all rights reserved). |
| `SECURITY.md` | How to report security concerns. |
| `docs/audits/public_readiness/` | EMM-222 public-readiness audit and machine-readable findings. |
| `docs/audits/dependency_licenses/` | EMM-224 dependency license audit and machine-readable matrix. |

No Git history from the private repository is included. This tree was created as a fresh snapshot (see EMM-225 in the private project process).

## Governance & automerge (EMM-227)

- **Policy:** [`docs/GITHUB_AUTOMERGE_POLICY.md`](docs/GITHUB_AUTOMERGE_POLICY.md) — restrictives Automerge nur für **R0/R1** mit Label **`public-safe`**, nie bei **`no-automerge`** oder **`risk/R2`** / **`risk/R3`**.
- **Labels:** [`docs/LABELS.md`](docs/LABELS.md) (im GitHub-UI anlegen).
- **PR-Vorlage:** [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md).
- **CODEOWNERS:** [`.github/CODEOWNERS`](.github/CODEOWNERS) — nach Eintrag gültiger @Handles optional mit Branch-Protection „Code owners“ nutzen.
- **Dependabot:** [`.github/dependabot.yml`](.github/dependabot.yml) — vorkonfigurierte Labels für Actions-Updates.

Das **private** `emma`-Repository hat **kein** dieses Automerge-Modell.
