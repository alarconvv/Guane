# Finch interface and terminal verification

Test date: 11 November 2026. **PASS for the tested signal and BM PGLS workflows.** This is a focused empirical workflow check, not a test of every GUANE module or biological model adequacy.

## What was exercised

The original GUANE application was started locally with its ordinary Shiny interface. The browser uploaded the original distributed 14-tip Newick tree and 13-row CSV, rather than loading the synthetic example. In the Data card, taxon matching retained 13 tips and recorded `olivacea` as the excluded tree tip. The browser log explicitly states one unmatched entry was removed. No trait rows were excluded.

The graphical signal card used `beakD`, Data seed **20261201**, and **999 total test draws**, including the observed configuration. PGLS used response `beakD`, predictor `wingL`, **BM** covariance and **REML**, with 13 species and 11 residual degrees of freedom. The regression diagnostic view displayed normalized residual plots and reported no fitting warnings.

## Results compared

| Quantity | GUI display | Terminal value |
|---|---:|---:|
| Blomberg K | 0.64307 | 0.643070858934493 |
| K randomization P | 0.03904 | 0.039039039039039 |
| Pagel lambda | 0.74572 | 0.745722788649143 |
| Lambda test P | 0.16762 | 0.167620945920515 |
| PGLS intercept | −10.95301 | −10.9530123675806 |
| PGLS wingL slope | 3.03848 | 3.03848118293088 |
| Slope lower 95% interval | 2.25613 | 2.25613058726124 |
| Slope upper 95% interval | 3.82083 | 3.82083177860052 |

GUI tables agree at their displayed five-decimal precision (absolute tolerance 5.1 × 10^-6). These full terminal values are generated outputs, not extra digits inferred from the GUI.

The actual downloaded **signal R script** was retained unchanged as `signal-export.R`. The **PGLS Live Code Mirror** was read from the visible interface and retained unchanged as `pgls-live-code.R`; the PGLS download button itself was not verified. Both scripts embed the GUI's prepared inputs and refit the analysis. Their numerical results and regression residuals agree with fresh calls to the current original GUANE package at tolerance 10^-8. The same scripts additionally executed successfully in separate `Rscript --vanilla` processes with assertions that GUANE was not loaded before or after execution.

## Repeat from the terminal

From the BioRxav directory:

```sh
Rscript --vanilla scripts/04_verify_interface_terminal.R
```

The script records tables, fit objects and checks under `results/interface-test-2026-11-11/`. Its `repo` variable points to the original local GUANE checkout; edit that path if moving the project. The script preserves the retained browser evidence and interface-generated scripts. It overwrites the terminal rerun outputs in this dated test directory.

For independent runs without loading GUANE, change into that results directory and execute:

```sh
Rscript --vanilla signal-export.R
Rscript --vanilla pgls-live-code.R
```

These standalone scripts require their documented backend R packages. The delivered standalone logs/PDFs/CSVs were generated in clean processes; the full package/session record is also retained. Original core scripts 01–03 remain available for the earlier preparation and figure workflow.

## Evidence

- `verification-checks.csv`: eight checked comparisons, all PASS.
- `terminal.log`, `terminal-sessionInfo.txt`, `verified-fits.rds`: current-package rerun and numerical comparisons.
- `signal-standalone.log`, `pgls-standalone.log`: separate clean-process executions.
- `terminal-signal.csv`, `terminal-pgls.csv`, `terminal-residuals.csv`: numerical outputs.
- `signal-dom.txt`, `pgls-dom.txt`, `pgls-diagnostics-dom.txt`, `preparation-log-dom.txt`: captured visible interface content.
- `signal-ui.png`, `pgls-ui.png`, `pgls-diagnostics-ui.png`, `preparation-ui.png`: browser screenshots.
- `signal-export.R`, `pgls-live-code.R`: unchanged scripts obtained from the running interface.

## Observed limitations

The first CSV upload from the project path showed a generic upload error. Retrying the identical CSV bytes from a short `/tmp` path succeeded. The cause was not established; this is not evidence of a CSV parsing bug. Automated download-event capture timed out. A separate browser download operation successfully retrieved the signal script. Consequently, this record validates that script's refit and the PGLS displayed script's refit, but does not claim that every CSV/PDF/script download control works.

Trait unit/transform metadata, historical phylogeny provenance, measurement error and biological model adequacy remain separate scientific review tasks. No source, existing example or existing website documentation was changed. The manuscript's earlier pending statements have not been rewritten automatically; use this dated report when revising them.
