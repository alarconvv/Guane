# Preparing the GUANE short preprint

## Scope and paper question

Aim for a 1,800–2,500 word software research preprint with two figures and one small empirical workflow. The question is: can users inspect and reproduce the sequence from explicit taxon matching to phylogenetic signal and a simple continuous-trait regression in the original GUANE application? The biological demonstration asks whether finch beak depth covaries with wing length under a specified Brownian covariance model. It is not a claim of a new finch discovery or a new statistical method.

The broader sibling Guane-manuscript draft already exists. Reuse its reviewed software description where appropriate, but keep this short alternative project separate. The current request establishes a December 8, 2026 review-package target; the older repository status targeted a December 31 coauthor draft. Submission earlier than that requires the following work to finish sooner.

## Practical analysis workflow

1. Read DATA_PROVENANCE.md. Keep the immediate package source and historical metadata gaps distinct. Confirm trait scales, units, aggregation and the tree source with the dataset/package maintainers or original documentation before final scientific interpretation.
2. Run the three scripts in README.md. Inspect input-validation.txt, exclusions.csv, signal.csv, pgls-coefficients.csv, pgls-warnings.txt and the residual panel. The delivered files already contain a completed core run. Record a new run in a dated copy if changing settings.
3. Launch the original application from its repository using `devtools::load_all()` and `guane::run_app()`. In **Phylo traits → Data**, upload `data/finches-13-tree.nwk` and `data/finches-13-traits.csv`. Select `taxon`, inspect all 13 rows and the matching report, and use matched taxa. Set the Data-card seed to **20261201**. No extra log transform or PIC preprocessing is needed.
4. In **Phylogenetic signal**, select `beakD`, use **999 test draws including observed**, and run. Inspect K and lambda and the randomized-K diagnostic. Save results CSV, graph PDF and graph R code into a new `results/ui-replay/` directory. Compare against delivered signal.csv with the same package versions and seed.
5. In **PGLS**, choose response `beakD`, predictor `wingL`, correlation **BM**, estimation **REML**. Run and save coefficients, diagnostics and exported R script. Inspect coefficient intervals, observed versus fitted, residual versus fitted and Q–Q plots. Compare with delivered coefficient table. Do not apply both independent contrasts and PGLS to these same species-level inputs.
6. Run the exported scripts in a clean R session. Compare estimates within 1e-8 and retain versions, warnings and any failures. Record actual UI labels/settings if they differ from this guide. The dated interface test completed these comparisons; rerun them if changing inputs or settings. PGLS code was copied from Live Code Mirror; that download button remains unverified.
7. Evaluate model adequacy before interpreting the fitted slope. Inspect residual patterns and influential taxa; rerun a documented leave-one-out sensitivity if needed, reporting every exclusion rather than keeping a favorable fit. With 13 taxa, avoid a broad search across evolutionary/diversification models. Lack of an optimizer warning is not proof of adequate assumptions.

## How to finish the manuscript

Write Methods first from scripts and actual settings. Keep the 13-taxon matching decision, original scale and BM/REML specification explicit. Insert the actual core results already saved, then revise their interpretation after scientific review. Figure 1 explains the inspectable workflow. Figure 2 shows the supplied phylogeny, trait relationship and residuals; the line is a fitted relationship, not an ancestral trajectory. Do not add invented interface screenshots or unrun benchmark claims.

Finish the introduction around a narrow reproducibility gap: graphical workflows must preserve taxon matching, model assumptions, settings and numerical outputs. Identify GUANE as an interface to established packages. The discussion should explain the benefit and its limits, including the small historical dataset, single tree, unresolved measurement metadata and untested interface replay. Replace every TODO in the draft. Have a comparative-methods reviewer check both results and assumptions.

## Schedule to 8 December 2026

The current target is **8 December 2026**. See submission/DECEMBER_8_SCHEDULE.md for dated milestones. The interface and terminal comparisons are completed (INTERFACE_TERMINAL_TEST.md); all 13 omission fits are completed (ROBUSTNESS_REPORT.md). Remaining release conditions are the original metadata and taxon mapping, author review and final file checks. This is a review package only; no submission or reminder is authorized.

## Submission preparation

Check the current [bioRxiv submission guidance](https://www.biorxiv.org/submit-a-manuscript) and [FAQ](https://www.biorxiv.org/about/FAQ) directly before posting. Their pages were not retrievable in this run, so category, license choices, accepted file formats and screening requirements have not been verified. Frame the work as computational biological research with an empirical evaluation; do not assume that a tutorial or software announcement alone will pass screening.

Supply author order, affiliations, corresponding contact, contributions, funding and competing interests. Confirm that all authors consent to posting and that any related journal policy permits the preprint. Prepare the final manuscript PDF with legible figures and complete references; archive code, versioned inputs, license notices and environment record with a persistent identifier. Replace the availability placeholder with that identifier. Recheck citations and results against the archived version. Submit only after unresolved data metadata and central reproducibility claims have been resolved or narrowed explicitly.
