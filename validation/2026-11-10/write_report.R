# Build the final assessment from completed numerical records.
out<-'validation/2026-11-10'
frog<-readRDS(file.path(out,'frog_combined.rds'))
ref<-read.csv(file.path(out,'butterfly_archive_start_refits.csv'))
parity<-read.csv(file.path(out,'published_models_guane_parity.csv'))
cross<-read.csv(file.path(out,'butterfly_archive_refit_parity.csv'))
ordered<-readRDS(file.path(out,'butterfly_ordered_guane_refit.rds'))
original<-readRDS('../Guane-manuscript/results/butterfly_ordered_ARD.rds')
search_count<-sum(vapply(c('butterfly_independent_search.csv','butterfly_bound_sensitivity.csv',
  'butterfly_path_starts.csv','butterfly_LBFGSB.csv'),function(f)nrow(read.csv(file.path(out,f))),integer(1)))
table<-vapply(split(ref,ref$Upper),function(d)sprintf('| %s | %.6f | %.6f | %.8f |',
  format(d$Upper[1],scientific=FALSE),d$LogLik[1],d$LogLik[2],diff(range(d$LogLik))),character(1))
frogtab<-vapply(seq_len(nrow(frog$comparison)),function(i){
  d<-frog$comparison[i,];a<-frog$attempts[frog$attempts$Model==d$Model,]
  sprintf('| %s | %d | %.6f | %.6f | %s | %s | %.6f |',d$Model,d$Parameters,d$LogLik,
    max(a$VerificationLogLik),d$Converged,d$Verified,d$StartSpread)
},character(1))
stopifnot(all(is.na(frog$comparison$Weight)))
lines<-c('# Validation assessment — 10 November 2026','',
'The butterfly likelihood implementation and conditional ordered reconstruction are supported by the completed checks. Reference-informed Guane refits resolve the earlier likelihood gap, but the unordered model retains bound-dependent fast rates. The frog candidate set does **not** pass Guane\'s model-comparison criteria. Do not present both examples as fully validated biological reanalyses. The manuscript was left unchanged.','',
'## Butterfly evidence','',
sprintf('All six original fitted models archived by Revell were evaluated in Guane after checking the input data and trees. The largest absolute difference from the archived log likelihood was %.3g. In particular, Guane reproduces the published unordered ARD value of −295.080700168921. These are checks of published parameter vectors, not new optimization results.',max(abs(parity$Difference))),'',
'The archived unordered vector contains rates above 100 (maximum 376.7502), outside the original search bound. However, two new Guane refits at the original bound found a better likelihood than the published value. Thus bounds alone did not explain the earlier gap: the original search also occupied an inferior local optimum. The new starts used the archived fitted vector; they are reference-informed, not blind recovery.','',
'| Upper rate bound | Start 1 log L | Start 2 log L | Absolute difference |',
'|:--|--:|--:|--:|',table,'',
sprintf('All six new refits reported convergence, and their likelihoods agreed with an independent diversitree evaluation within %.3g. At each bound at least one rate reached the upper limit. The improving likelihood with wider bounds demonstrates unresolved estimation of fast rates; it does not justify treating the estimated rate values as precise biological measurements.',max(abs(cross$Difference))),'',
sprintf('The ordered ARD model refitted in Guane gives log L = %.9f and AIC = %.6f. Its root probability for forest+fringe+open is %.7f. Across all internal nodes and states, the largest change from the earlier reconstruction is %.7f. This supports the conditional reconstruction; it does not account for tree or rate uncertainty.',ordered$logLik,2*12-2*ordered$logLik,ordered$probabilities[1,'forest+fringe+open'],max(abs(ordered$probabilities-original$probabilities))),'',
'The ordered candidate retains the smaller AIC among these fitted candidates across the tested unordered bounds. This is a comparison of the solutions found, not a proof of global optimality or a calibration of biological model support. Both new butterfly export scripts replayed in fresh R processes.','',
sprintf('%d completed optimization runs using diversitree\'s likelihood are retained, spanning random starts, parameterizations, path starts and bounds, including failures and inferior local optima. Some exploratory runs were interrupted after preserving completed candidates when the original fitted objects provided a direct validation route. Counts and plots use completed fits only.',search_count),'',
'## Frog evidence','',
'The complete 1,579-species dataset, original sampling fractions and Guane model constraints were retained. Each candidate used two full-vector restarts. Each native start had a maximum budget of 3,000 evaluations; the independent nlminb check used iter.max = eval.max = 3,000. These are configured limits, not actual evaluation counts. The second restart perturbed the earlier verification vector. This native restart facility is a script-level extension; the GUI does not expose it.','',
'| Candidate | k | Selected native log L | Best check log L | Selected native converged | Selected native verified | Native start spread |',
'|:--|--:|--:|--:|:--|:--|--:|',frogtab,'',
'The independent-check column is diagnostic only. Its values were not substituted into native fit objects or silently used for AIC. Guane preferentially selects a converged native fit when one exists, while retaining any better nonconverged start as a diagnostic. “Selected native verified” describes the selected fit, not every start. Read the per-start records for the full evidence.','',
'The candidate set fails the existing requirements for repeatability, independent verification and interior estimates. CID-2 checks approach the same likelihood, but its second native solution was worse despite a convergence status. CID-4 starts occupy substantially different local solutions and include lower-bound extinction fractions. The lower bound exp(−20) approximates zero; it does not establish a precise nonzero extinction estimate. Guane\'s own combined comparison correctly withholds all weights.','',
'HiSSE\'s second native start reached −6617.062233 but stopped at its 3,000-evaluation limit; its independent check reached −6617.007310. Guane therefore selected the lower-likelihood converged first start, while preserving the better failed start. A boundary estimate alone is not proof that a model is incorrect; here the conservative weighting policy also encounters nonrepeatability and optimizer disagreement.','',
'Guane\'s 13-, 7- and 11-parameter models differ from Moen\'s corresponding 16-, 12- and 16-parameter models. These new results are not a numerical replication of Moen\'s table and must not be used to infer an effect of phytotelm breeding. Do not change the candidate constraints or weaken the diagnostic rules merely to obtain a ranking.','',
'## Implementation and reproducibility','',
'The targeted ancestral-state and SSE unit tests passed. Input, taxon-count, constraint and nesting checks passed. The original frog files still match the archived SHA-256 digests. The relevant fitting functions were unchanged from the earlier analysis; this follow-up used commit a9a2675ca3644e8a3c43a9ef020758c7b39ab81f. No application source files were edited.','',
'See README.md for the scripts and execution distinctions. Native frog checkpoints, full restart vectors, per-start diagnostics, data/source hashes and session records are retained. The combined attempt table records actual restart vectors and separately labels scalar settings that the restart facility ignored. Published fitted butterfly objects retain their provenance and CC-BY-4.0 attribution.','',
'## Decision before manuscript polishing','',
'The butterfly example can be updated to report the verified likelihood reproduction, new reference-informed fits and stable ordered reconstruction, with explicit optimization and boundary qualifications. The frog example is presently defensible as a worked demonstration of diagnostic failure, not as a validated model-support result. A manuscript requiring two successful inferential reanalyses still needs further frog methodology work or an explicitly revised example design. No full browser suite, simulation calibration, formal identifiability analysis or global-optimum proof was performed in this follow-up.','',
'References: [Revell (2024)](https://doi.org/10.7717/peerj.16505); [original fitted-model archive](https://github.com/liamrevell/Revell.phytools-v2/tree/ec5143f86bb31e4898849b588e961369caaf5aba/peerj/revision/revision.2); [Moen (2022)](https://doi.org/10.1111/evo.14406).')
writeLines(lines,file.path(out,'VALIDATION_REPORT.md'))
