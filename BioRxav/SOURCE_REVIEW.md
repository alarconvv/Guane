# GUANE source and website review

Reviewed 10 November 2026. Canonical original application: `/Users/vivianaromeroalarcon/My Drive/PROJECTS/G4_PlatformsAndReproducibility/G4P3_Guane/Guane`. Repository: https://github.com/alarconvv/Guane. HEAD: `a9a2675ca3644e8a3c43a9ef020758c7b39ab81f`; DESCRIPTION version 1.0. A commit identifier alone does not describe uncommitted changes: hashes of the actual copied computation files are recorded separately in evidence/sha256.txt.

Inspected the original application's README, DESCRIPTION, project status, data validation, signal and PGLS core code, together with the existing sibling manuscript's opening/software methods. Guane-codex-full and Guane.verse are separate implementations and do not supply validation claims here.

## Website and tutorials

The original README points to https://alarconvv.github.io/guane-site/. Retrieved that live page and these relevant pages; extracted text is preserved under evidence/website-*.txt:

- https://alarconvv.github.io/guane-site/tutorials/phylo-traits.html
- https://alarconvv.github.io/guane-site/reference/input-formats.html
- https://alarconvv.github.io/guane-site/reference/exports.html
- https://alarconvv.github.io/guane-site/reference/limitations.html

The tutorial explicitly calls its bundled example synthetic with arbitrary branch lengths. Its signal workflow reports K and lambda, uses the Data-card seed, and offers randomized-K diagnostics. Its PGLS workflow requires an ultrametric tree and offers BM, Grafen, Pagel and Blomberg structures. The new paper uses the same signal and PGLS workflow with separate empirical inputs; the tutorial and examples are untouched.

## Source to claim mapping

| Claim | Source | Evidence in this project |
|---|---|---|
| Exact matching and finite numeric traits are checked | core_mod_data_base.R, guane_validate | input assertions and validation output |
| K randomization and lambda likelihood test | core_mod_signal_signal.R, guane_signal | results/signal.csv, seed and draw count |
| Species-level PGLS with BM covariance and REML | core_mod_signal_PGLS.R, guane_pgls | coefficients, normalized residuals, warnings |
| Same estimates as direct backend calls | scripts/02_analyse.R | backend-agreement.txt |
| GUI reproduces this run and exported scripts refit it | requires an interactive run | PENDING, not claimed as validated |

The frozen files in source/ are unchanged copies of the original core source, carrying GPL >=3. `02_analyse.R` sources these files and invokes their ordinary R functions. It does not load the entire package or test asynchronous execution, translation coverage, uploads, UI controls or downloads. Agreement with direct phytools/nlme calls confirms adapter consistency for this dataset, not an independent statistical validation or scientific model adequacy. No full application test suite was run.

## Update on 11 November 2026

The GUI signal/PGLS run and clean terminal refits are now completed; see INTERFACE_TERMINAL_TEST.md. The previously pending GUI claim is superseded for these two tested workflows only. The signal script was downloaded, whereas PGLS code was captured from Live Code Mirror; every export control has not been tested. All 13 omission fits and the provenance audit are recorded separately. Original source, existing examples and website documentation remain unchanged.
