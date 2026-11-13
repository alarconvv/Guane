# Full-data Moen model fits — completed 11 November 2026

All six correctly specified Moen models were fitted to all 1,579 frog taxa through Guane's `guane_hidden_fit()` and its native HiSSE adapter. Two starts were completed for every model, giving 12 saved native fit objects plus six complete Guane result objects. This is execution through Guane's R analysis layer, not manual operation of the graphical interface.

**The fitting batch is complete, but none of the six models passed all numerical validation checks. No model weights or biological ranking are supported by this batch.**

## Results

The table reports Guane's selected native fit, not the subsequently improved verification-optimizer fit. AIC values are diagnostic and provisional; do not interpret the smallest value as evidence for a winning biological model.

| Model | Parameters | Selected native log-likelihood | Provisional AIC | Spread between starts |
|---|---:|---:|---:|---:|
| full2 | 16 | -6591.520845 | 13215.041691 | 3.132631 |
| full3 | 14 | -6589.123161 | 13206.246321 | 8.560971 |
| suicide4 | 14 | -6581.690862 | 13191.381723 | 13.081728 |
| suicide6 | 13 | -6591.232302 | 13208.464605 | 18.686357 |
| CID2 | 12 | -6603.952844 | 13231.905689 | 0.154273 |
| CID4 | 16 | -6584.448522 | 13200.897044 | 13.014987 |

## What passed

- All 12 starts returned finite likelihoods and native status 3 (relative function tolerance reached), below the 100,000-evaluation cap.
- All six native parameter counts match the audited specifications: 16, 14, 14, 13, 12 and 16.
- Saved inputs confirm identical data, sampling fractions and likelihood settings across models, and all 1,579 tips remain in every result.
- Each saved Guane specification and native transition matrix matches the separately audited Moen S4 definition.
- Each model and start has its own saved result, settings, seed and optimizer diagnostics.

## What failed

- All six models have likelihood differences between starts exceeding the 0.0001 tolerance. The spreads range from about 0.154 to 18.686 log-likelihood units.
- No start passes independent-optimizer verification. Nine nlminb checks report successful termination but disagree with the native result by more than 0.0001. Both CID2 checks and CID4 start 1 report false convergence instead.
- Every selected native fit has a boundary parameter. Full2 and CID2 hit the transition-rate upper bound of 100; the other selected fits include near-zero extinction fractions or transition rates at exp(-20). Detailed parameter names and values are in `free_parameter_bounds.csv`.
- Full2's selected fit has lower likelihood than full3, suicide4 and suicide6, although it contains each as a constrained model. In particular, its likelihood is 9.829984 units below suicide4. This establishes that the current full2 search missed a better feasible solution; its current AIC is unsuitable for model selection.

A native convergence flag therefore does not establish a reliable optimum. The 100,000 cap was not reached: simply raising that cap would not address these early tolerance terminations and local optima.

## Reproducible settings

The script `fit_six_models.R` runs the unchanged Guane functions with audited Custom definitions. It uses the local Moen S1 traits and S2 tree, state 0 = nonphytotelm and state 1 = phytotelm breeding, counts 1,467/112, sampling fractions 0.4994893/0.6666667, survival conditioning, madfitz root treatment and likelihood root weighting. Each native search and independent nlminb check has a 100,000 evaluation budget. The two scalar starting triples (turnover, extinction fraction, transition) are (0.05, 0.5, 0.01) and approximately (0.17636874, 0.17511748, 0.0067885201), with seeds 20261111 and 20261112. Upper bounds are (10, 10, 100), tolerance sqrt(.Machine$double.eps), and annealing is disabled. Three models ran concurrently; no app source was modified.

The batch began at 08:14 and finished at 18:30 America/New_York on 11 November 2026. Wall-clock durations include intervals with little or no CPU accumulation; they are not reliable benchmark timings. Versions are recorded in `sessionInfo.txt`, and input/code hashes in `checksums.json`.

Run from Guane/:

```r
# Rscript validation/2026-11-11-moen-fits/fit_six_models.R
# Rscript validation/2026-11-11-moen-fits/summarize_fits.R
```

The fitting script reuses completed checkpoints in this directory. It does not silently rerun or overwrite completed fits. Preserve the current directory as the original batch if changing the search protocol.

## Files

- `<model>_result.rds`: complete Guane result, including input data/settings and selected native fit.
- `<model>_start1.rds`, `<model>_start2.rds`: each native fit and independent optimizer diagnostics/parameter vector.
- `six_model_comparison.csv`: provisional comparison; weights are NA.
- `all_attempts.csv`: all 12 optimizer outcomes, including verification likelihoods.
- `nested_likelihood_checks.csv`: parent/submodel likelihood-order checks.
- `free_parameter_bounds.csv`: fitted free parameters and bound flags.
- Per-model estimates/transitions CSVs: numerical outputs only, not validated biological estimates.

## Required next refinement

Restart full2 from the better suicide4 solution mapped into its less-constrained parameterization, and use the saved improved verification parameters as starting points for the other models. Add targeted perturbations and tighter stopping tolerances, then examine upper-bound sensitivity for full2/CID2 and identifiability at near-zero rates. Repeat the same agreement, repeated-start and nesting checks before model selection. Any boundary solution needs explicit scientific justification and sensitivity analysis rather than removing the validation flag.

The archived S10 fits remain unavailable, so this is not a verified numerical reproduction of Moen's published fitted values. The manuscript was left unchanged. This report documents completed fitting and failed numerical validation; it does not certify convergence to global maxima or establish phytotelm-dependent diversification.
