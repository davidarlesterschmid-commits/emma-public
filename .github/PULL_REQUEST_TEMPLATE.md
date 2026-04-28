## Summary

<!-- Short description of the change. -->

## Risk & automerge (EMM-227)

- [ ] I have set **exactly one** risk label: `risk/R0` **or** `risk/R1` (low-risk / docs-typo, metadata).  
      Use `risk/R2` / `risk/R3` only if you expect **human review** — automerge will **not** run.
- [ ] I have added `public-safe` for changes that are safe to land under the public transparency policy.  
- [ ] I have **not** added `no-automerge` (add it to force manual merge, e.g. public sync or legal review).
- [ ] This PR is **not** a bulk sync from the private monorepo (those stay **manual** without `public-safe` by convention).

**Blocked from automerge (workflow will not enable auto-merge):** `LICENSE`, `.github/workflows/`, `docs/private/`, and any path segment `tariff`, `partner`, `guarantee`, or `migration`.

## Checklist

- [ ] `CI` workflow is green.
- [ ] I am not changing secrets, runners, or repository visibility.
