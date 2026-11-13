# Moen frog model specification audit — 11 November 2026

The six selected models in Moen's S4 can all be represented by Guane's existing Custom model interface. No application changes are needed. The built-in HiSSE, CID-2 and CID-4 presets are not the same candidate models.

## Exact constraints

Indices denote shared free parameters, not fitted rates. The state order is 0A, 1A, 0B, 1B, followed by 0C, 1C, 0D, 1D for CID4. Observed state 0 is nonphytotelm breeding; 1 is phytotelm breeding.

| S4 model | Hidden classes | Turnover indices | Extinction-fraction indices | Free transition rates | Total parameters |
|---|---:|---|---|---:|---:|
| full2 | 2 | 1,2,3,4 | 1,2,3,4 | 8 | 16 |
| full3 | 2 | 1,2,3,3 | 1,2,3,3 | 8 | 14 |
| suicide4 | 2 | 1,1,2,2 | 1,2,3,4 | 8 | 14 |
| suicide6 | 2 | 1,1,2,2 | 1,2,3,3 | 8 | 13 |
| CID2 | 2 | 1,1,2,2 | 1,1,2,2 | 8 | 12 |
| CID4 | 4 | 1,1,2,2,3,3,4,4 | 1,1,2,2,3,3,4,4 | 8 | 16 |

Turnover is lambda + mu; extinction fraction is mu/lambda. In particular, suicide4 and suicide6 need explicit extinction-fraction vectors: sharing turnover does not imply sharing extinction fraction.

Each `<model>_transitions.csv` contains the exact transition-index matrix for pasting into Guane. Rows are origin states and columns are destinations. Zero means a forbidden transition (Guane internally uses NA); diagonal entries are zero in the input. For the five four-state models, all eight directed single-change transitions are independent. CID4 has two observed-state transition rates shared across hidden classes and six symmetric hidden-class pair rates, shared across observed states. Simultaneous changes of observed and hidden state are forbidden.

Guane's current built-ins have 13 parameters (HiSSE), 7 (CID-2) and 11 (CID-4). Their transition constraints differ from S4. Previously obtained fits using those presets cannot be relabelled as Moen's six models.

## Running in Guane

Choose Custom, set the number of hidden classes, enter both vectors from the table, and paste the corresponding transition matrix. Supply the aligned frog tree and species/states data. Use sampling fractions 0.4994893 for state 0 and 0.6666667 for state 1, survival conditioning, madfitz root treatment and likelihood root weighting.

The interface supports one Custom definition per run, so run each model separately. A one-model run's weight is not a six-model comparison. Combine likelihoods and parameter counts only after checking that all fits use identical data and likelihood settings and satisfy the convergence checks.

From R, run from the Guane repository root:

```r
source('validation/2026-11-11-specification/moen_models.R')
# Sourcing constructs and validates specifications; it does not fit the frog data.
# tree: phylo object; traits: data.frame with species and states columns.
# Explicitly choose an evaluation budget before fitting:
# result <- fit_moen_model('full2', tree, traits, maxeval = 100000, starts = 2)
```

`fit_moen_model()` calls Guane's own `guane_hidden_fit()` and records the Moen model name. It uses upper bounds 10 for turnover, 10 for extinction fraction and 100 for transitions, one of S4's search protocols. These settings do not reproduce the author's entire optimization history. S4 also used default bounds, annealing and multiple supplied starting values. The helper's two starts are not a substitute for that search.

## Validation completed

`moen_models.R` evaluates only the reviewed model-construction block of the author's S4 with historical hisse 1.9.8 matrix constructors in an isolated environment. It does not execute S4's fitting, source calls or file-writing sections. The resulting matrices and parameter groups match Guane's parsed specifications exactly. Explicit matrix expectations, transition direction checks and Q-matrix equality at three distinct rate vectors all pass.

`check_native_indices.R` additionally executes all six models through Guane on a 12-tip synthetic tree and checks finite likelihoods, native parameter counts, transition matrices and fitted equality groups. All six pass. The deliberately short ten-evaluation checks return status 5 (evaluation limit); they establish execution and constraints, not convergence or biological results. Model weights remain NA. Results are in `synthetic_native_checks.csv` and software versions in `sessionInfo.txt`.

The author used hisse 1.9.8; the installed Guane backend is hisse 2.1.11. Historical source was read without installing or replacing a package. Matching specifications does not establish likelihood parity between versions. No new empirical frog fits were run for this specification audit, and the manuscript was not revised.

## Sources and provenance

- Moen (2022), Evolution 76:373–384: https://doi.org/10.1111/evo.14406
- Author code S4, GPL-3.0-or-later: https://doi.org/10.5281/zenodo.4708174
- Local S4: `../Guane-manuscript/data/Moen_S4_original.R`; MD5 `88bb92d4feb0af2ed8b8c4cc77610e6d` (see checksum manifest for authoritative computed value).
- Historical CRAN archive: https://cran.r-project.org/src/contrib/Archive/hisse/hisse_1.9.8.tar.gz
- CRAN GitHub mirror tag 1.9.8, commit `b87f19474d950f3e935bc279b6e16b54d098be7f`. Retained constructor and likelihood files were checked against the tarball.
- Archived fitted models: https://datadryad.org/dataset/doi:10.5061/dryad.w9ghx3fpp ; expected file `S10_globally_optimal_6models.Rdata`, 369643 bytes, SHA256 `14d55b6e01cdfce80f39e08f69f25fe958d080157dca58038c012fb87b1937a3`.

The next empirical validation is to compare the archived fitted parameters and likelihood conventions with these specifications, then fit the matched six-model set with sufficient optimization effort before reporting model weights or biological conclusions.

## Local archive search

At the user's request, searched `/Volumes/dataMac2026` by filename, including hidden and ignored files while excluding dependency/cache directories. The backup contains Moen_S1_traits.csv, Moen_S2_tree.tre and Moen_S4_original.R in the Guane-manuscript project. No file named S10_globally_optimal_6models.Rdata or matching globally-optimal/6models patterns was found. None of the 559 discovered RData files has the expected S10 byte size. A text-reference search in `/Volumes/dataMac2026/Guaneverse` also found no S10/global_opt_models/Dryad DOI reference. Candidate paths are retained in volume_candidates.txt and volume_rdata_candidates.txt. Some volume locations were inaccessible; this is not proof that a renamed, repackaged or inaccessible copy is absent. Archived fitted-parameter verification remains outstanding.
