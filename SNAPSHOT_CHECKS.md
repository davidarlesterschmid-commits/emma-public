# EMM-225 — automated checks for this snapshot (2026-04-28)

## Blocklist (must be 0 matches for patterns below)

Patterns applied to all tracked text under this repository:

| Check | Pattern / rule | Result |
| --- | --- | --- |
| PII path | Windows user-home path with real account segment | 0 |
| PII email | common webmail pattern for real individuals | 0 |
| Token | source-control PAT-style prefix (letters g-h-p-underscore) | 0 |
| Key material | PEM private-key block header | 0 |

Run locally: use your repo’s secret scan or a search for the above **without** pasting live patterns into this file.

## Referenced upstream audits (private repo, not in this tree)

- Secret/PII posture: EMM-222 / EMM-223.
- Pub dependency licenses: EMM-224 (GO).

**Verdict for snapshot contents:** `GO` from automated sweeps; **manual** gate (owner) still required before creating a public GitHub repository or setting visibility.
