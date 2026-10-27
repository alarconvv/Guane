# Guane probes documentation and results register

Status date: 27 October 2026. A probe is a bounded exploratory or diagnostic check. It can expose a problem or establish numerical behavior without validating a biological claim. Statuses below distinguish completed work, insufficient evidence and genuinely unfinished outcomes.

## Primary documentation

| Read in this order | Purpose |
|---|---|
| [Project status and schedule](PROJECT_STATUS.md) | Current position, implementation decision and December milestones |
| [Pending work](PENDING_WORK.md) | Priorities, dependencies and completion conditions |
| [Existing manuscript](../../Guane-manuscript/Guane_MEE_manuscript.md) | Current scientific narrative and numerical tables |
| [Original app evaluation](../../Guane-manuscript/EVALUATION.md) | Architecture, capabilities, executed September checks and limitations |
| [Author notes](../../Guane-manuscript/AUTHOR_NOTES.md) | Scientific qualifications and author/publication work |
| [Dataset provenance](../../Guane-manuscript/data/PROVENANCE.md) | Butterfly sources, frog file hashes and distinction from published benchmarks |
| [Guaneverse current checklist](../../Guane.verse/docs/IMPLEMENTATION_CHECKLIST.md) | Latest implemented scope and closure records; later terminal sections supersede historical statuses |
| [Guaneverse method reference](../../Guane.verse/docs/METHOD_REFERENCE.md) | Current executable contracts, assumptions and routes |
| [Scientific reporting limits](../../Guane.verse/docs/SCIENTIFIC_LIMITATIONS.md) | Permitted wording, identification and uncertainty qualifications |
| [Biological decision register](../../Guane.verse/docs/BIOLOGICAL_SIGNOFF.md) | Claim-specific decisions; read final CID2 assessment with historical proposals |

## Original app and manuscript evidence

All paths in this table refer to `../Guane-manuscript/` from this repository.

| Evidence or probe | Location | Result and interpretation | Remaining action |
|---|---|---|---|
| Butterfly six-model fit | `run_butterflies.R`; `results/butterfly_model_comparison.csv` | Six candidates completed; ordered ARD smallest AIC found, 619.4751; log L −297.7376. Boundary and start disagreement retained. | Review optimizer sensitivity; avoid definitive weights or global-optimum wording. |
| Butterfly sensitivity | `sensitivity_butterflies.R`; `results/butterfly_sensitivity.log` | Extra search did not resolve the better published unordered-ARD likelihood. | Retain limitation or prospectively specify additional search if essential to the claim. |
| Fixed-Q numerical agreement | `verify_butterflies.R`; `results/backend-parity.log` | Direct backend likelihood parity passed; log L approximately −297.7376. | Keep separate from optimization adequacy. |
| Butterfly mapping | `map_butterflies.R`; `results/butterfly_mapping_summary.txt` and `butterfly_map_*.csv` | 100 saved histories conditional on fitted rates. | Report conditional variation, not rate/tree uncertainty. |
| Butterfly export replay | `results/butterfly_export.R`; `results/export-replay.log` | Saved reconstruction replay completed. | Verify actual refit separately if manuscript claims recomputation. |
| Frog runtime probe | `results/frog_runtime_probe.log` and `.rds` | One 10-evaluation CID-2 start; about 7.5 seconds; finite log L but not converged or verified. | Treat as exploratory timing only, not resource forecast or scientific fit. |
| Frog bounded candidates | `frog_diagnostic.R`; `results/frog_{HiSSE,CID2,CID4}_bounded_*` | Three full-data candidates, two starts each, 50 evaluations per native start. All native searches hit evaluation limits; independent checks improved likelihoods. | Diagnostic example only; no final model ranking. |
| Frog CID-2 budget sensitivity | `results/frog_CID2_diagnostic.rds`; diagnostic log | 200-evaluation run improved native log L to about −6628.672, still inadequate. | Preserve separately from common-budget comparison. |
| Extended frog search | `run_frogs.R`; `results/frog_run.log` | Initial extended exploration interrupted; completed candidate-set result not established. | No assumption that a background analysis is still running. Decide whether needed after paper scope freeze. |
| Frog replay | `results/frog_CID2_export.R`; `results/frog_export_replay.log` | Saved diagnostic plot and record replayed. | Not a converged refit. |
| Published frog arithmetic | `check_published_frogs.R`; `results/frog_published_benchmark.csv` | Arithmetic check of published rounded values. | Keep provenance attached; never present these as new Guane estimates. |
| September app tests | `results/test-gates-local.log` | 100/101 unit, 14/14 integration and 19/20 security blocks passed; two skips. Historical runner labeled gates GREEN. | Current runner requires zero warnings/skips, so old labels are not equivalent to current acceptance. Revalidate chosen source. |
| September functional attempt | `results/test-functional-local.log` | Driver failed initialization because chromote rejected NULL width; no functional tests executed. | Repair and rerun if original app is the manuscript target. |
| Narrow browser smoke | `results/app-smoke.log`; evaluation narrative | Example matching and signal results recorded. | Does not replace full browser gate. |

The manuscript README still uses `manuscript/...` commands, whereas the current directory is the sibling `Guane-manuscript/`. Reconcile package-loading assumptions and working-directory requirements before publishing reproduction commands.

## Separate Guaneverse scientific studies and probes

The author selected original Guane for the Methods in Ecology and Evolution paper on 27 October 2026. The following Guaneverse studies are broader project history, outside that paper's required results and validation. Paths refer to `../Guane.verse/`. Follow the linked report for primary artifacts and scripts.

| Study or probe | Documentation | Terminal status and remaining implication |
|---|---|---|
| Research-data exercises | [Real-data validation](../../Guane.verse/docs/REAL_DATA_VALIDATION.md), [expanded scientific checks](../../Guane.verse/docs/SCIENTIFIC_VALIDATION.md) | Saved native/analytical agreement and replay evidence. Scope is numerical implementation; not universal biological validation. |
| Initial calibration pilot | [Calibration results](../../Guane.verse/docs/HIDDEN_CALIBRATION_PILOT_RESULTS.md) | COMPLETE, insufficient: 12 draws, six eligible analyses, all six timed out. Recovery not evaluated. |
| Native-start timing | [Start timing](../../Guane.verse/docs/HIDDEN_START_TIMING.md) | Completed smaller examples with optimizer checkpoints. Timing and numerical readiness do not establish identification. |
| Larger-tree timing | [Large timing](../../Guane.verse/docs/HIDDEN_LARGE_TIMING.md) | Both analyses timed out; delayed deadline enforcement. Censored exposure, not completed runtime. |
| Timing with sleep prevention | [Awake timing](../../Guane.verse/docs/HIDDEN_AWAKE_TIMING.md) | MiSSE 19m13s; HiSSE/CID2 16m32s in that run. Not a controlled performance benchmark. |
| MiSSE independent starts | [Start agreement](../../Guane.verse/docs/MISSE_START_AGREEMENT.md) | Best likelihood reproduced across four stable distinct starts; weak identification remains. |
| MiSSE turnover support | [Original profile](../../Guane.verse/docs/MISSE_TURNOVER_PROFILE.md), [refinement](../../Guane.verse/docs/MISSE_PROFILE_REFINEMENT.md) | Refinement COMPLETE. Broad similar-likelihood support survives uncapped local searches. Turnover 0.4 remains unresolved: likelihood spread about 0.002234 exceeds 1e-4. No calibrated interval. |
| Biological recovery assessment | [Biological validation](../../Guane.verse/docs/HIDDEN_BIOLOGICAL_VALIDATION.md) | Sign-off withheld; stable numerical fits can miss known rates or collapse regimes. |
| Bounded pilot v2 | [Pilot v2 assessment](../../Guane.verse/docs/HIDDEN_BIOLOGICAL_PILOT_V2_RESULTS.md) | COMPLETE, INSUFFICIENT. 24 simulation attempts, ten eligible; only two sentinel cases eligible. Three models completed; no expansion. MiSSE turnover failed on one null tree; CID2 passed on one tree. |
| Eligibility study | [Eligibility results](../../Guane.verse/docs/BIOLOGICAL_ELIGIBILITY_RESULTS.md) | COMPLETE: 480 attempts, 213 eligible. Establishes eligibility yield, not model recovery. |
| CID2 confirmation | [Confirmation assessment](../../Guane.verse/docs/CID2_CONFIRMATION_RESULTS.md), [execution record](../../Guane.verse/docs/CID2_CONFIRMATION_EXECUTION.md) | TERMINAL, INCOMPLETE. 166 attempts, 83 eligible; first 50 selected. One completed recovery success, two stopped and 47 unstarted: 49 unknown. Poll gap 8.117669s exceeded fixed 5s maximum. No support completed; not a completed negative recovery experiment. |
| RRphylo penalty reliability | [Reliability assessment](../../Guane.verse/docs/RRPHYLO_RELIABILITY.md) | Four of five fixed fixtures demonstrate bounded agreement; balanced zero-mean case unresolved despite native code 0. Numerical stability and biological accuracy remain separate. |
| Threshold short-budget probe | [Threshold implementation](../../Guane.verse/docs/THRESHOLD_IMPLEMENTATION.md); `artifacts/threshold-short-budget-probe.log`, `threshold-probe.log` | 20,000-proposal development fixture under-mixed; 100,000-proposal fixture passed diagnostics for that case. Not universal mixing assurance. |
| Engineering audit probes | `artifacts/contracts-audit-probes.log`, `uncertainty-boundary-probe.log`, `expansion-ui-probe.log`, `rrphylo-reliability-probe.log` | Supporting developer evidence. Use associated closure/implementation reports for conclusions; probe filenames do not establish scientific readiness. |

## Status rules for future updates

**Complete** means the specified bounded work reached terminal accounting, even if its outcome is insufficient. **Incomplete** means intended scientific outcomes remain missing. **Unresolved** means numerical or inferential evidence does not meet the declared criterion. **On hold** records a sequencing decision, not a failed analysis.

Use terminal assessments rather than older proposal/running paragraphs. In particular, CID2 confirmation is no longer merely planned or running. Do not turn 49 unknown outcomes into 49 biological failures. No new study is launched by this inventory.
