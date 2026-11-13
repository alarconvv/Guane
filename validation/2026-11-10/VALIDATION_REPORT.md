# Validation assessment — 10 November 2026

The butterfly likelihood implementation and conditional ordered reconstruction are supported by the completed checks. Reference-informed Guane refits resolve the earlier likelihood gap, but the unordered model retains bound-dependent fast rates. The frog candidate set does **not** pass Guane's model-comparison criteria. Do not present both examples as fully validated biological reanalyses. The manuscript was left unchanged.

## Butterfly evidence

All six original fitted models archived by Revell were evaluated in Guane after checking the input data and trees. The largest absolute difference from the archived log likelihood was 3.98e-13. In particular, Guane reproduces the published unordered ARD value of −295.080700168921. These are checks of published parameter vectors, not new optimization results.

The archived unordered vector contains rates above 100 (maximum 376.7502), outside the original search bound. However, two new Guane refits at the original bound found a better likelihood than the published value. Thus bounds alone did not explain the earlier gap: the original search also occupied an inferior local optimum. The new starts used the archived fitted vector; they are reference-informed, not blind recovery.

| Upper rate bound | Start 1 log L | Start 2 log L | Absolute difference |
|:--|--:|--:|--:|
| 100 | -294.844545 | -294.844543 | 0.00000199 |
| 1000 | -294.770587 | -294.770587 | 0.00000024 |
| 10000 | -294.749598 | -294.749612 | 0.00001366 |

All six new refits reported convergence, and their likelihoods agreed with an independent diversitree evaluation within 8.53e-10. At each bound at least one rate reached the upper limit. The improving likelihood with wider bounds demonstrates unresolved estimation of fast rates; it does not justify treating the estimated rate values as precise biological measurements.

The ordered ARD model refitted in Guane gives log L = -297.737484759 and AIC = 619.474970. Its root probability for forest+fringe+open is 0.8876087. Across all internal nodes and states, the largest change from the earlier reconstruction is 0.0000546. This supports the conditional reconstruction; it does not account for tree or rate uncertainty.

The ordered candidate retains the smaller AIC among these fitted candidates across the tested unordered bounds. This is a comparison of the solutions found, not a proof of global optimality or a calibration of biological model support. Both new butterfly export scripts replayed in fresh R processes.

68 completed optimization runs using diversitree's likelihood are retained, spanning random starts, parameterizations, path starts and bounds, including failures and inferior local optima. Some exploratory runs were interrupted after preserving completed candidates when the original fitted objects provided a direct validation route. Counts and plots use completed fits only.

## Frog evidence

The complete 1,579-species dataset, original sampling fractions and Guane model constraints were retained. Each candidate used two full-vector restarts. Each native start had a maximum budget of 3,000 evaluations; the independent nlminb check used iter.max = eval.max = 3,000. These are configured limits, not actual evaluation counts. The second restart perturbed the earlier verification vector. This native restart facility is a script-level extension; the GUI does not expose it.

| Candidate | k | Selected native log L | Best check log L | Selected native converged | Selected native verified | Native start spread |
|:--|--:|--:|--:|:--|:--|--:|
| HiSSE | 13 | -6619.671175 | -6617.007310 | TRUE | FALSE | 2.608942 |
| CID-2 | 7 | -6625.297731 | -6625.297683 | TRUE | TRUE | 0.165525 |
| CID-4 | 11 | -6594.605334 | -6594.605334 | TRUE | TRUE | 10.708818 |

The independent-check column is diagnostic only. Its values were not substituted into native fit objects or silently used for AIC. Guane preferentially selects a converged native fit when one exists, while retaining any better nonconverged start as a diagnostic. “Selected native verified” describes the selected fit, not every start. Read the per-start records for the full evidence.

The candidate set fails the existing requirements for repeatability, independent verification and interior estimates. CID-2 checks approach the same likelihood, but its second native solution was worse despite a convergence status. CID-4 starts occupy substantially different local solutions and include lower-bound extinction fractions. The lower bound exp(−20) approximates zero; it does not establish a precise nonzero extinction estimate. Guane's own combined comparison correctly withholds all weights.

HiSSE's second native start reached −6617.062233 but stopped at its 3,000-evaluation limit; its independent check reached −6617.007310. Guane therefore selected the lower-likelihood converged first start, while preserving the better failed start. A boundary estimate alone is not proof that a model is incorrect; here the conservative weighting policy also encounters nonrepeatability and optimizer disagreement.

Guane's 13-, 7- and 11-parameter models differ from Moen's corresponding 16-, 12- and 16-parameter models. These new results are not a numerical replication of Moen's table and must not be used to infer an effect of phytotelm breeding. Do not change the candidate constraints or weaken the diagnostic rules merely to obtain a ranking.

## Implementation and reproducibility

The targeted ancestral-state and SSE unit tests passed. Input, taxon-count, constraint and nesting checks passed. The original frog files still match the archived SHA-256 digests. The relevant fitting functions were unchanged from the earlier analysis; this follow-up used commit a9a2675ca3644e8a3c43a9ef020758c7b39ab81f. No application source files were edited.

See README.md for the scripts and execution distinctions. Native frog checkpoints, full restart vectors, per-start diagnostics, data/source hashes and session records are retained. The combined attempt table records actual restart vectors and separately labels scalar settings that the restart facility ignored. Published fitted butterfly objects retain their provenance and CC-BY-4.0 attribution.

## Decision before manuscript polishing

The butterfly example can be updated to report the verified likelihood reproduction, new reference-informed fits and stable ordered reconstruction, with explicit optimization and boundary qualifications. The frog example is presently defensible as a worked demonstration of diagnostic failure, not as a validated model-support result. A manuscript requiring two successful inferential reanalyses still needs further frog methodology work or an explicitly revised example design. No full browser suite, simulation calibration, formal identifiability analysis or global-optimum proof was performed in this follow-up.

References: [Revell (2024)](https://doi.org/10.7717/peerj.16505); [original fitted-model archive](https://github.com/liamrevell/Revell.phytools-v2/tree/ec5143f86bb31e4898849b588e961369caaf5aba/peerj/revision/revision.2); [Moen (2022)](https://doi.org/10.1111/evo.14406).
