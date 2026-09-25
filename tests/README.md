# Guane test gates

Four gates, each a set of `testthat` files selected by prefix:

| Gate | Files | What it covers |
|---|---|---|
| unit | `test-unit-*.R` | Pure functions: data validation and limits, ASR, diversification, signal, SSE, i18n, background-task helpers, exported R scripts (parse and re-run in a fresh R session) |
| integration | `test-integration-*.R` | Module servers through `shiny::testServer`, in background-worker and in-process modes: every Run button, stale-result discard, busy guard, timeout, cancellation on session end |
| functional | `test-functional-*.R` | Full app in headless Chromium via `shinytest2`: boot, language switching, data workflow, analyses, downloads, responsiveness during long runs, limits |
| security | `test-security-*.R` | Code-injection guards for exported scripts and formulas, CSV formula neutralisation, i18n JS lookups, upload and resource limits, worker cancellation and crash recovery, configuration parsing |

Run from the repository root:

```sh
Rscript tests/run_gates.R                      # all gates
Rscript tests/run_gates.R unit security        # selected gates
```

A gate is GREEN when it has no failures and no test skipped with a `BUG:` reason.

Functional tests need Chromium: set `CHROMOTE_CHROME` to the browser binary. `functional-driver.R` adds `--no-sandbox` when running as root.
