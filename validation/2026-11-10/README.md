# Validation follow-up, 10 November 2026

Run scripts from the Guane repository root. Earlier data and results are read from
`../Guane-manuscript/`; that directory was moved after the September analysis.
New results are saved here without overwriting the earlier analyses or manuscript.

## Scope and criteria

This validates the Guane examples. It is not an exact replication of Moen's model
set: Guane's built-in HiSSE, CID-2 and CID-4 models have 13, 7 and 11 parameters.
Moen's corresponding full2, CID2 and CID4 specifications have 16, 12 and 16.
The archived S4 code establishes those differences in transition constraints.

The likelihoods, parameter constraints and root treatments must agree before
optimization results are compared. Numerical convergence alone does not establish
global optimality, biological causation or model adequacy. For frogs, retain
Guane's existing rules for weights: all starts converged, independently verified,
interior, repeatable within 1e-4 log likelihood and consistent with nesting.
Do not relax these rules to manufacture a model ranking.

## Executed checks

`check_inputs.R` verifies all six saved butterfly likelihoods against direct
`phytools::fitpolyMk` calls with fixed Q and the alternative likelihood evaluator.
It also checks node probability normalization, Q row sums, all three frog
specifications against the archived specifications, and frog taxon/state counts.
Results are in `input_checks.log` and `butterfly_fixedQ_parity.csv`.

`targeted_tests.log` records the existing ancestral-state and SSE unit tests.
`source_commit.txt`, `source_sha256.txt`, `data_sha256.txt` and session records
identify the current implementation and input data. The relevant model-fitting
functions are unchanged from the earlier analysis; export helpers changed.

## Longer searches

```sh
Rscript validation/2026-11-10/refine_butterflies.R
Rscript validation/2026-11-10/refine_frogs.R CID-2
Rscript validation/2026-11-10/refine_frogs.R HiSSE
Rscript validation/2026-11-10/refine_frogs.R CID-4
```

The butterfly script evaluates additional starting vectors and direct-rate versus
log-rate optimization. Backend mode uses phytools' own defaults; other runs use
Guane's requested upper bound of 100. Direct-rate phytools optimization permits
zero rates, whereas log-rate optimization uses the positive lower bound. These
are sensitivity analyses, not identical optimizer settings. Preserve each fit's
effective calls when interpreting differences.

Frog refinement uses the native `restart.obj` facility through Guane's unchanged
`guane_hidden_native` adapter, in a private function environment. It starts from
the earlier independent optimizer's parameter vector, then from a reproducibly
perturbed vector. Each native search and independent check receives a budget of
3,000 evaluations, with no annealing. The full initial restart objects and each
completed native fit are checkpointed. The graphical card does not expose these
full-vector restarts. This is an explicit script-level extension, not a claim
that the same restart workflow was performed through the UI.

The wrapper records original scalar settings in Guane's ordinary attempt table;
the actual restarted vectors are the separate `_initial1.rds` and `_initial2.rds`
files. Use those objects and this script to reproduce the refinement. A standard
export's optional refit does not reproduce these injected restarts.
Initial restart objects reuse an earlier native fit as a structural template.
Their updated `solution`, `index.par` and bounds define the start; legacy
likelihood/optimizer fields in those initial objects are not new fit results.
The wrapper also reseeds the second restart with 20261112 before drawing its
perturbation; the ordinary per-model Seed field precedes that override. The
combined table labels that original field and records the actual RNG sequence.

Search completion and final conclusions are recorded separately after inspecting
the resulting fits. A saved file by itself is not evidence that a fit passed.

## Independent butterfly checks and archived models

`crosscheck_butterflies.R` optimizes the same allowed transition matrix using
`diversitree::make.mkn`, with fixed equal root probabilities. Each resulting Q is
evaluated and reconstructed by Guane, with an assertion that the independent and
Guane likelihoods agree within 1e-5. Ten starts per ordering were completed.
`butterfly_bound_sensitivity.R`, `butterfly_path_starts.R` and
`butterfly_published_optimizer.R` explore wider bounds, alternate starting routes
through the unobserved state, and log-rate L-BFGS-B, respectively. Only completed
rows in their CSV files count as executed searches. The initial Guane exploration
and later bound/L-BFGS-B explorations were interrupted after preserving completed
fits when a more direct validation became available; interrupted attempts are not
silently counted as converged.

The original fitted butterfly models were located in the author's archived
[manuscript repository](https://github.com/liamrevell/Revell.phytools-v2), at commit
`ec5143f86bb31e4898849b588e961369caaf5aba`. The downloaded `.rda` matches the Git blob
hash in that repository. `revell_archive_provenance.txt` records the path, hashes
and CC-BY-4.0 license. These are published fitted objects, not newly estimated
results. In particular, the published unordered ARD vector has rates exceeding
100 (maximum 376.75), so it lies outside the original Guane search bounds.

`refit_archived_butterfly.R` verifies the archived data and trees against the
example inputs, reevaluates all six archived Q matrices in Guane, and performs
reference-informed Guane refits at upper bounds 100, 1000 and 10000. The 10000
starts extend the fast rates from the completed 1000-bound fit. The direct archived
likelihood checks are in `published_models_guane_parity.csv`; new refits have
separate filenames and retain their settings. This distinguishes exact likelihood
reproduction from finding an optimum without access to published fitted values.

`refit_ordered_guane.R` returns the independently optimized ordered vector to
Guane's own optimizer. The reconstructed node probabilities change by less than
0.000055 relative to the September result. Its new export was replayed in a fresh
R process; `butterfly_ordered_export_replayed.pdf` is the resulting figure.

`combine_frogs.R` reapplies Guane's own comparison policy to completed native
checkpoints after verifying tree, sampling, root treatment and transition
constraints. It does not refit or substitute independent-check likelihoods for
native results. Its combined attempt table replaces the misleading scalar
initialization field with the actual full restart vectors, retaining the unused
scalar values in a separately labeled column. `summarize_validation.R` produces
a numerical summary and a diagnostic figure from completed results, and
`write_report.R` writes `VALIDATION_REPORT.md`.

## Final status

All six longer frog attempts and their independent checks completed. The combined
candidate set fails the existing weighting criteria, and all weights remain NA.
All six archived butterfly likelihoods were reproduced, and six new Guane
unordered refits plus the ordered refit completed. Boundary sensitivity remains.
Read `VALIDATION_REPORT.md` for the supported conclusions and limitations.
`manifest_sha256.txt` fingerprints the final files in this validation directory.
