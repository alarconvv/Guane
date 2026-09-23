# GUane scientific limitations

A reference for analysis, interpretation and reporting

Implementation snapshot through Milestone 6E • 22 September 2026

GUane provides supported phylogenetic analyses under explicit statistical models. A completed run, a converged optimizer or a passed software test does not establish that the model fits a particular biological question. This document records the current platform’s documented scientific assumptions, inference limits, backend restrictions and unimplemented capabilities.

### How to use this document

For each analysis, check the relevant method section and the shared data and uncertainty sections. Report the engine, model, conditioning, data preparation and diagnostic findings alongside the results. Source identifiers such as [S2] point to the implementation records listed at the end.

### Current scope

**Phylo traits** Blomberg’s K, Pagel’s lambda, PGLS, Pagel’s binary correlation test and supported binary/count/grouped-binomial PGLM workflows.

**Ancestral state reconstruction** Continuous marginal ML and legacy engines; discrete and polymorphic ML; conditional stochastic maps; supported continuous BM and discrete/polymorphic Bayesian workflows.

**Diversification** LTT, constant-rate, time-varying, separate-clade, joint clade-dependent and six diversity-dependent model families.

**SSE models** BiSSE, MuSSE, QuaSSE and binary hidden-state/null models are implemented in independent analysis cards. Their uncertainty, numerical and comparison restrictions are detailed below; implemented does not mean universally validated. [S12, S14–S16]

### Resolved historical restrictions

OU intervals and known measurement error are available in the newer continuous marginal-ML engine. Bayesian discrete and polymorphic reconstruction is also implemented. Older milestone documents described these as pending; those historical statements do not describe the current platform. BiSSE, MuSSE, QuaSSE and binary HiSSE/CID models are also now implemented. Historical pending statements are superseded only for these supported scopes. Engine-specific limits remain and are detailed below. [S3, S8, S9, S12, S14–S16]

This is a dated limitation register, not a certification of all data regimes or a guarantee that every future release has the same scope. It should be updated when engines, dependencies or validation evidence change.


## Shared data and interpretation limits

**Taxon matching** Traits must be matched explicitly to named tree tips. Duplicate taxa, missing values, incompatible coding and non-finite inputs require review. Matching or pruning changes the analysed sample and potentially its biological meaning; the software does not establish that the retained taxa are representative. [S1, S2]

**Tree requirements** Rooting, bifurcation, positive finite branch lengths and ultrametricity are enforced as required by each method. Requirements differ: do not infer that a tree accepted by one card is suitable for another. No implicit rooting, polytomy resolution, branch repair, recalibration or imputation is performed. [S1, S2, S5, S11]

**Branch units** Branch lengths are not automatically calendar time. Rate estimates are per supplied branch-length unit unless the tree has a justified time calibration. Changing scale changes parameter interpretation and can change numerical behaviour and prior meaning.

**Fixed inputs** Most analyses condition on one supplied topology, branch lengths and observed trait coding. Tree uncertainty and observation uncertainty are generally not integrated. Known-standard-error options in continuous marginal ML and QuaSSE are specific exceptions, not platform-wide measurement-error support. Multiple-tree LTT displays do not make other engines tree-integrated analyses. [S3, S10, S11]

**Transformations** Log, exponential, quadratic and reciprocal operations create derived columns. Domain and finite-value checks do not determine whether a transformation is biologically appropriate. Squaring can merge positive and negative values; transformed coefficients, rates and priors have a different interpretation. Known standard errors must already be expressed on the selected transformed scale. [S1, S3]

**Normality checks** The Data panel’s Shapiro–Wilk check requires 3–5000 finite, nonconstant observations. It assesses the selected column, not regression residuals or adequacy of a phylogenetic model. A transformation chosen to improve a normality test does not by itself validate subsequent inference. [S1]

**Independent contrasts** PICs are node-level contrasts, not additional species observations. They must not be entered into species-level K/lambda analysis or subjected to a second phylogenetic covariance adjustment. Their independence and interpretation depend on the assumed tree and evolutionary model. [S1, S2]

**Examples and screening** The bundled 20-tip tree and 19-row trait table deliberately mismatch. They test preparation workflows; successful example analyses are not biological findings. Minimum sample-size, rank and workload checks are computational/statistical screens, not proof of identifiability or sufficient information. [S1, S2]


## Phylogenetic signal and PGLS

### Blomberg K and Pagel lambda

Signal is implemented for finite numeric species-level traits, including explicitly transformed columns. Blomberg’s K uses randomization; Pagel’s lambda uses the implemented likelihood test. Both depend on the supplied tree, branch lengths, trait scale and model assumptions. They quantify aspects of phylogenetic pattern, not its causal evolutionary mechanism. [S2]

**Uncertainty coverage** Signal measurement-error models and lambda likelihood profiles remain deferred. A p-value is not a full interval for the strength of signal, and a nonsignificant result is not proof that phylogenetic dependence is absent. Finite randomization precision depends on the chosen replicates and seed.

**Interpretation** Signal values computed on different transformations describe different trait scales. Observed-tip maps and null plots support interpretation but do not provide ancestral reconstructions or validate the assumed trait process.

### Phylogenetic generalized least squares

PGLS supports numeric multiple predictors and Brownian, Grafen, Pagel and Blomberg correlation structures through nlme. The current workflow requires an ultrametric tree. Categorical predictors, interactions and non-ultrametric covariance weighting are deferred for this card; categorical PGLM support does not extend PGLS automatically. [S2]

**Model fit** Coefficients and conditional intervals depend on the specified linear mean and covariance structures. Collinearity checks and normalized-residual/Q–Q plots do not establish correct specification or adequate prediction. Bootstrap uncertainty remains deferred.

**Comparisons** The accepted comparison holds the data and formula fixed and refits covariance candidates with ML. Do not use REML scores to compare different fixed-effect specifications. Failed candidates remain visible and do not receive weights. No general likelihood-ratio testing facility is implied by the comparison table.

**Inference scope** Association is not causation. Selecting predictors or transformations after inspecting results introduces an additional selection step that is not included in the reported intervals. Model weights express relative support among the submitted, compatible candidates, not the probability that a model is scientifically true.

### Before reporting

Record the trait and predictor scales, included taxa, covariance structure, ML versus REML choice and any boundary or residual warnings. Explain why that covariance and mean model answer the biological question; do not substitute an acceptable residual plot for that justification.


## Pagel correlation and PGLM

### Pagel correlation

This card is Pagel’s 1994 Discrete Correlation Test for two binary traits, not continuous regression. It compares the independent four-rate and dependent eight-rate ARD models with equal root probabilities and multiple starts. Multistate outcomes, directional hypotheses, alternative root priors and a parametric-bootstrap test remain outside the supported card. [S2]

**Asymptotic testing** The reported likelihood-ratio reference is asymptotic. Sparse state combinations, rates near boundaries and convergence failures weaken its interpretation. A dependent model does not identify a causal direction or demonstrate that one trait caused the other.

### Phylogenetic generalized linear models

Current engines are binary logistic MPLE/IG10, Poisson GEE with a log link and grouped-binomial GEE with a logit link. Multiple numeric and explicitly coded categorical predictors are supported. These are particular implementations, not interchangeable examples of every generalized or Bayesian phylogenetic model. [S2]

**Valid responses** Count responses must be finite nonnegative integers. Grouped binomial requires integer successes, positive total trials and successes no larger than trials. Binary coding requires an explicit event state. The app does not round counts or silently remove invalid rows.

**Interval meaning** Binary Wald intervals condition on the fitted phylogenetic alpha. Poisson GEE intervals use scale-adjusted model-based covariance. Grouped-binomial GEE uses fixed tree working correlation, binomial scale one and model-based covariance. They are not bootstrap intervals or a one-cluster sandwich inference. [S2, S13]

**Unavailable models** Count exposure offsets, negative-binomial and zero-inflated models, extra-binomial models and Bayesian PGLM remain deferred. Unequal observation effort cannot be corrected by assuming an offset was fitted when none was provided.

**Comparison and diagnostics** GEE families have no likelihood/AIC comparison in GUane. Pearson and category checks are descriptive; formal multivariable separation detection is not implemented. Sparse categories, near-boundary probabilities and alpha warnings require attention even when a fit is returned.

**Sensitivity** Temporary taxon-omission refits show sensitivity to particular observations. They are not calibrated Cook distances, cross-validation or predictive validation. Failed omission refits remain part of the evidence rather than being silently excluded. [S2]


## Continuous ancestral reconstruction

### Comparable marginal maximum likelihood

The default marginal-ML workflow compares BM, single-optimum OU and EB on a common Gaussian likelihood of observed tips. Known independent observation standard errors can be supplied; they are squared once in the observation covariance. They are not estimated automatically, transformed automatically or treated as arbitrary correlated error. [S3]

**OU interpretation** The implemented OU covariance is root-conditioned, with one constant mean: the root equals the single optimum. It is not a stationary/random-root OU model and does not estimate distinct root and optimum values or multiple selective regimes.

**EB interpretation** The default EB shape range permits decreasing rates. A custom positive upper bound can permit accelerating evolution, which should not be described as an early burst. Shape search bounds affect the candidate model space and are recorded.

**Prediction intervals** Node prediction intervals include mean-estimation uncertainty but condition on fitted diffusion and shape parameters and the supplied tree. They exclude estimation uncertainty in diffusion, alpha or r and do not provide simultaneous coverage across nodes. They are not Bayesian credible intervals.

**Numerical comparisons** Only converged finite candidates are eligible. Bounds and failed starts remain visible. AICc is available only when sample size exceeds the required parameter-count threshold. Candidates with different trait scales, error vectors, taxa or likelihood definitions are not comparable. Dense covariance calculations limit practical interactive scale.

### Legacy continuous engines

fastAnc and anc.ML remain available with their original meanings. The fastAnc adapter’s marginal tip likelihood and anc.ML’s joint tip-and-fitted-node density are different bases; legacy results are not inserted into the marginal comparison. [S4]

**Legacy OU** The installed anc.ML OU path carries a backend caution about limited testing and supplies no node variance/CI. Its results remain estimates-only. This limitation does not apply to OU intervals from the newer marginal engine.

**Legacy errors and EB** The legacy anc.BM measurement-error path is not exposed because its covariance scaling was inconsistent with the intended error model. Legacy EB intervals are approximate Hessian-based quantities; invalid uncertainty can require an explicit rerun without intervals. A backend indexing issue was corrected and independently tested. [S4]

**Displays** Maps and phenograms interpolate estimated nodes; they are not sampled OU/EB evolutionary trajectories. PIC Q–Q and decorrelated-tip residual displays are exploratory. The latter can depend on ordering and are not calibrated adequacy tests. [S3, S4, S6]


## Discrete and polymorphic ancestral reconstruction

### Maximum likelihood and fixed rate matrices

Discrete ML supports 2–10 observed unambiguous states with ER, SYM, ARD or indexed custom constraints. Equal positive indices share rates; zero forbids a transition. States, rate constraints and root weights are scientific assumptions, not formatting choices. Hidden-state and ambiguous-tip models are not part of this workflow. [S5, S8]

**Root assumptions** Equal or named fixed root weights are supported. Local reconstruction and estimated/stationary/FitzJohn root schemes remain outside the validated advanced-ML controls. The optimizer bounds editor requires positive bounds; supplied fixed Q matrices can contain explicit zeros.

**Fixed Q and comparisons** A supplied Q must respect the selected constraints. Fixed-Q evaluation does not optimize rates and does not produce a model-ranking AIC table. Custom-start comparisons are disabled where the vector could mean different parameters in different candidates. Boundary rates, sparse states and failed convergence qualify interpretation.

**Marginal and joint results** Node pies are global marginal probabilities conditional on the fitted rates, tree and root weights. They do not integrate rate, model or tree uncertainty. An optional joint-ML assignment is one joint configuration; ties may exist, and its entries are not node probabilities. It never replaces the marginal summaries. [S5]

### Polymorphic character models

Two or three constituent states are supported, including ER/SYM/ARD/transient constraints. A+B denotes coexistence, not uncertainty about whether A or B was present. Unordered models retain the complete allowed combined-state space, including unobserved combinations. [S9]

**Ordering** Ordered models require an explicit constituent order and maximum polymorphism; only contiguous combinations are allowed. The example’s pairwise combinations may be incompatible with a linear order. Do not delete or recode genuine observations merely to force a model to accept them.

**Missing extensions** Larger constituent spaces and arbitrary custom polymorphic constraint editing remain deferred. The number of allowed combinations and free rates can exceed the information supplied by observed tips; computational acceptance does not establish identifiability.

### Stochastic mapping with a fixed Q

These histories condition on one fitted or supplied Q, root weights and tree. They do not sample a posterior distribution over rates and require no rate-chain burn-in. History ranges represent conditional historical variation; Monte Carlo standard error measures simulation precision, not uncertainty in the evolutionary model. This differs from the Bayesian Q-sampling workflow. [S5, S6]

**Graphical interpretation** Selected-state density maps project a multistate history onto that state versus all others; they do not fit a binary model. Occupancy depends on grid resolution and is rounded by phytools to 0.001. Q-diagram thresholds and support symbols affect display, not fitted values. Colored histories and density maps currently use phylograms because of an installed-backend fan-rendering limitation. [S6]


## Bayesian ancestral reconstruction

### Continuous Brownian motion

The anc.Bayes workflow samples diffusion and ancestral states under BM, with exact tip observations and a fixed tree. Bayesian OU/EB, tip measurement error and tree uncertainty are not included. Diffusion has an exponential prior parameterized by its mean; node priors are independent normals. Priors and proposals operate on the selected trait scale and must be assessed for that scale. [S7]

Node summaries are posterior means and equal-tailed credible intervals under those assumptions. They are not HPD intervals or simultaneous bands. Full continuous chains retain burn-in for inspection, but the backend supplies no acceptance counts. Changes between saved/thinned draws are not acceptance rates.

### Discrete and polymorphic rate sampling

make.simmap with Q set to mcmc supplies retained rate draws and paired histories. Posterior node probabilities average conditional marginal probabilities over retained Q draws; they are not probabilities calculated at the posterior mean Q. The displayed mean Q is a summary, not the rate matrix used for every history. [S8, S9]

**Priors and roots** Gamma shape/rate parameters and proposal variances require scale-aware choices. The optional empirical prior uses rates fitted from the same data and is empirical Bayes, not an independent external prior. Fixed equal or named root weights are supported; stationary/estimated roots and FitzJohn weighting are excluded to avoid inconsistent sampling and mapping assumptions.

**Backend access** The discrete/polymorphic backend does not return burn-in traces or acceptance counts and does not expose editable initial rate vectors. It samples starts from priors. Positive burn-in and finite workload limits are enforced; these safeguards do not establish convergence.

### Diagnostics and comparison

Diagnostics use spectral ESS, classic split-Rhat and MCSE, not rank-normalized Rhat or tail ESS. Warnings flag small ESS, Rhat above the implemented threshold, single/stuck chains and unavailable precision. Passing thresholds is not proof of convergence, identifiability or insensitivity to priors. Short/default browser runs are exploratory. [S10]

Node-indicator diagnostics concern sampled state frequencies; the averaged conditional marginal probability is a distinct summary. Constant sampled indicators can have unavailable precision rather than zero uncertainty. Assess multiple chains, traces, effective sample sizes and scientifically plausible alternative priors.

No Bayesian model-comparison engine or ML/AIC ranking is attached to these posterior samples. No joint-ML assignment is claimed for the Bayesian result. Polymorphic Bayesian models retain the same two/three-constituent, ordering and coexistence restrictions as their ML counterparts. Parsimony remains unimplemented. [S7–S10]


## LTT and whole tree diversification

### Lineages through time

LTT displays reconstructed sampled lineages, including multi-tree displays when supplied. It is not total historical species richness, does not observe extinct lineages, and does not by itself estimate speciation/extinction rates or a test of rate change. Comparisons depend on branch units, crown/stem handling and sampling. [S11]

### Constant rate models

Yule and birth–death models use their implemented crown likelihood and sampling/conditioning settings. Random extant sampling is assumed; nonrandom or deliberately diversified sampling is not modeled. Supplied stems are excluded in the crown fitting path. Extinction can be weakly identified, especially in small clades or near boundaries.

**Intervals** Curvature intervals are approximate normal intervals and are withheld where curvature, boundaries or rate limits make them unreliable. Profile intervals reoptimize nuisance rates within a finite search domain. A reached search bound is not an infinite confidence interval. Boundary coverage is not calibrated.

**Simulation diagnostics** Conditional LTT simulations fix fitted rates, random sampling fraction, crown age and sampled tip count. They check branching-time shape, not tree size or age. Envelopes are pointwise, not simultaneous, and exclude parameter/tree uncertainty. The discrepancy tail fraction is descriptive rather than a calibrated p-value; rates are not refitted for each such diagnostic replicate.

### Time varying models

The current temporal extension includes exponential-speciation Yule and birth–death candidates, with constant extinction in ExpBD, and compatible constant-rate baselines using the same ODE likelihood. It is not an arbitrary time-function or joint time-varying speciation-and-extinction model. Time is measured backward from the present; beta’s sign must be interpreted using that convention.

**Numerical scope** Present-day rate bounds do not necessarily bound ancestral rates. Starts, beta bounds, integration tolerance and solver choice matter. Tighter-tolerance likelihood checks and refits detect some instability but do not prove a global optimum.

**Bootstrap and profiles** Profiles have finite search ranges and approximate reference coverage. Bootstrap refits condition on crown age, sampled tip count and sampling fraction. Successful-refit pointwise bands are not calibrated simultaneous coverage or model-selection uncertainty. Bands require the documented success threshold; failures and boundary frequency remain relevant evidence. [S11]


## Clade dependent diversification

### Separate clade fits

The Clade-specific pill fits selected non-overlapping crown clades independently. Each crown must contain at least four sampled tips. Descendants are retained explicitly and ancestral stems excluded. Per-clade random sampling fractions are assumptions supplied by the user. [S11]

**Comparison domain** Delta AIC and weights compare candidates within each clade only. Likelihood or AIC magnitudes from different clades must not be ranked against each other. Estimated rate differences across clades are descriptive and are not a joint rate-shift significance test.

**Selection and uncertainty** Choosing clades after viewing rates adds selection bias that is not included in intervals. Small clades can provide little information about extinction. Intervals condition on the selected crowns, tree, branch lengths and sampling fractions; they do not include uncertainty in defining the groups.

### Joint clade dependent models

The joint pill fits prespecified whole-tree regions through the native split birth–death likelihood. Shared or region-dependent rates and supported equality/fixed-rate constraints are available. Nested regions are permitted within the implemented selection restrictions. These are joint fits rather than a collection of separately ranked crown fits. [S11]

**Shift timing** The installed backend supports branch-base placement only, represented by split.t = Inf. Other timing choices are not implemented. Shift locations and sampling are fixed inputs, not quantities estimated or averaged over by this workflow.

**Inference** AIC is conditional on the chosen regions and compatible candidate set. It does not account for searching many possible shift arrangements. The platform provides no calibrated likelihood-ratio p-value or uncertainty analysis over shift placement.

**Rate estimation** Curvature intervals remain approximate and can be withheld at boundaries or with unstable curvature. Regions with few informative events can have weakly identified rates. Multiple starts and their agreement support numerical review but cannot establish a unique or globally optimal solution.

**Backend failure** Critical cases with equal speciation and extinction can produce non-finite native likelihoods. Such cases fail visibly rather than being repaired by an unvalidated limiting formula. Time-varying regional rates, unrestricted shift searches and Bayesian regional models remain outside this engine.

### Reporting

State whether the analysis used independent crown fits or a joint whole-tree model. Record every node/region, excluded taxa, sampling assumption, shift convention, fixed/shared parameter and failed fit. A biologically justified partition is part of the analysis design, not merely a graph-control choice.


## Diversity dependent diversification

The DDD card supports model codes 1, 1.3, 2, 3, 4 and 5: selected speciation-, extinction- and jointly diversity-dependent families. Other DDD variants are not offered pending validation. Analyses use crown age, with soc fixed to 2. Missing extant species are a count, not a sampling fraction. [S11]

**Parameter meaning** K is model-specific. In model 1.3 it denotes diversity at zero speciation; in models 1 and 2 it refers to equal speciation and extinction. It must not be interpreted as a universal ecological carrying capacity across every family. r applies only to model 5.

**Control limits** The native dd_ML function does not expose arbitrary parameter bounds. GUI starts and fixed values are explicit, and optimization cycles are finite. Numerical resolution, integration tolerances and starting values can affect estimates and likelihoods. A converged return is not evidence of parameter identifiability.

**Comparison** AIC comparisons are confined to candidates fitted to the same data, conditioning, missing-species count and likelihood basis in this card. They are not compared with other Diversification cards. Failed candidates, numerical instability and known better fits can suppress ranking weights.

**Profiles and robustness** Profiles fix one estimated parameter and refit nuisance parameters. Approximate chi-square crossings are interpolated within successful grid segments connected to the MLE. Failed points and finite search limits cannot be interpreted as resolved interval endpoints. Multiple-start and resolution/tolerance refits are diagnostic; better estimates are not substituted silently.

**Restricted bootstrap** Bootstrap currently requires complete sampling, crown analysis and crown-survival conditioning, cond = 1. Crown age is fixed, both crown lineages must survive, and simulated tip counts vary. This is neither a tip-count-conditioned nor an incomplete-sampling bootstrap. Other settings can use supported profile/robustness checks, not this bootstrap.

**Bootstrap uncertainty** Percentile intervals require at least 20 successful refits and 90% success. Failed simulations/refits remain auditable; non-finite parameter estimates do not count as successes. Intervals exclude tree/model-selection uncertainty and are not calibrated boundary intervals. Replicate elapsed-time limits are best-effort R limits, not hard separate-process timeouts.

**Persistent review** A fit marked for review cannot regain intervals merely by turning robustness off and rerunning uncertainty. Review findings must be resolved through a new fit. This guard prevents a misleading display; it does not diagnose the biological cause of instability.

**Graphs** Rate curves show dependence on diversity. The LTT shows surviving reconstructed lineages, not fitted total historical richness. No historical-diversity confidence bands or universally calibrated goodness-of-fit test are claimed.


## State dependent speciation and extinction

### Shared SSE assumptions

All implemented SSE cards condition on one rooted, bifurcating ultrametric tree with positive branch lengths, explicitly matched traits and supplied sampling assumptions. Rates use branch-length units. Fossils, unresolved clades, tree uncertainty, estimated sampling fractions and ambiguous observations are outside these workflows. Positive supplied stems are excluded in crown-based paths with a warning. [S12, S14–S16]

**Interpretation** Trait association is not causality. Small or imbalanced states, weak extinction identification, local optima and parameter boundaries can make apparently precise point estimates misleading. Multiple starts and numerical checks diagnose some failures but cannot prove identifiability, model adequacy or a global optimum. The bundled example tests the interface; it is not evidence for a biological trait effect.

**Comparison domain** Compare candidates only when fitted to identical data and compatible root, survival, sampling and likelihood settings within the relevant card. Do not combine AIC from BiSSE, MuSSE, QuaSSE and HiSSE cards. The hidden-state card refits a BiSSE-equivalent model using its own backend to support a consistent candidate set. Relative support depends on the supplied candidates and does not establish that any model is true.

**Uncertainty and graphs** BiSSE/MuSSE offer optional approximate profile intervals for verified stable interior fits. QuaSSE and hidden-state intervals, SSE credible intervals, calibrated likelihood-ratio tests, Bayesian SSE and simulation-based adequacy remain unavailable. Likelihood slices hold nuisance parameters fixed; they are not refitted profiles or confidence limits. Rate plots show point estimates and tree plots show observed traits, not hidden ancestral assignments. [S12, S14–S16]

### BiSSE

BiSSE requires two explicitly coded observed states and known state-specific random sampling fractions. Preset and custom fixed/shared rate constraints are supported; arbitrary formula constraints are not. Missing, ambiguous and polymorphic states are rejected. [S12]

The standalone trait-independent candidate does not represent hidden rate heterogeneity. Binary HiSSE and CID nulls are now available in their separate card; candidates must be refitted there before comparison. Unmodeled heterogeneity can mimic trait dependence even when a standalone BiSSE comparison appears favorable. Failed or unstable optimization and known better feasible candidates can suppress model weights.

### MuSSE

MuSSE supports 2–8 observed categorical states with k(k+1) unrestricted rates. Extra unobserved states and missing, ambiguous or polymorphic observations are not supported. ROOT.EQUI is unavailable in the installed multistate backend; OBS, FLAT and GIVEN are exposed. [S14]

No multistate hidden-state null engine or ancestral histories are provided. Binary CID models do not supply a null for a multistate MuSSE analysis. State imbalance and the rapidly growing rate count can overwhelm available information. Multiple starts, tighter ODE tolerances and feasible-candidate checks do not establish global optimality. Weights concern compatible candidates in one run; duplicate equivalent candidates should be avoided.

### Profile intervals and optimizer verification

BiSSE/MuSSE profiles refit nuisance groups at each finite-grid point using two deterministic starts and check tighter ODE evaluation. Interval endpoints interpolate approximate chi-square crossings only across successful connected segments. Search bounds are not confidence endpoints; failed segments and better likelihoods suppress affected endpoints. Boundary, unstable or independently unverified original fits cannot receive profiles. Intervals condition on the tree, model, coding, sampling and root treatment; no simultaneous, model-selection or boundary-calibrated coverage is claimed. Only one selected free-group profile is saved per card. [S17]

Independent optimization in BiSSE, MuSSE and QuaSSE swaps nlminb and L-BFGS-B. The original estimates remain unchanged even if the check finds a better point. Weights require repeatable interior fits, successful starts and agreement, and remain unavailable when verification is disabled. A fit flagged by a better profile or unresolved robustness check requires a new fit; hiding the diagnostic does not restore support.

### QuaSSE

QuaSSE assumes finite continuous observations with known positive Gaussian measurement standard errors, constant Brownian drift/diffusion, a known global random sampling fraction and selected constant, exponential or sigmoid speciation/extinction functions. The GUI error default of 1 is an editable starting value, not an estimate from the data. Diffusion is a variance rate, not a standard deviation. Standard errors must match the selected trait scale. [S15]

Zero or missing errors, estimated error variance, arbitrary rate functions, split models and continuous hidden-state/null models are not supported. Functional misspecification, extreme observations, short sister branches, narrow error densities and grid boundaries can destabilize inference. Sigmoid symmetries or nearly constant curves can weaken identification. Fixed parameters are treated as known; uncertainty from estimating them elsewhere is not propagated.

**Numerical resolution** Results depend on finite trait domain, FFT resolution, time step and bounds. The original refinement diagnostic doubles the grid and halves the step at the fitted parameters. An additional explicit robustness action now refits on refined and widened grids while retaining the original estimates. It adjusts for the installed backend’s survival-conditioned dx² likelihood constant and retains both raw and adjusted values. A passing check is not proof of numerical convergence. The widening refit cannot compare likelihoods under FLAT roots because widening also changes that prior. Unresolved checks suppress weights persistently until a new fit. Refits currently require nx at most 2048 and widened domain multiplier at most 30. [S17] Raw AIC/log-likelihood values must not be compared across grids or other likelihood bases.

**Displays and inference** Error bars are ±1 supplied measurement SE, not confidence intervals. Rate curves cover the observed trait range and are point estimates. The optional constant-rate comparator is not a continuous hidden-state null; binary CID models cannot fill that role. No equilibrium root distribution or inferred ancestral history is claimed.

### Binary hidden state and character independent models

The hidden-state card supports HiSSE, CID-2, CID-4, same-backend BiSSE and custom models with two or four hidden classes for a binary observed trait. CID models tie diversification parameters across observed states within each hidden class; hidden classes still allow rate heterogeneity. These nulls address a particular model structure, not every possible source of confounding. Multistate and continuous hidden models remain unavailable. [S16]

**Optimizer status** The native hisse 2.1.11 result omits termination status, but GUane now retains the underlying nloptr record in a private call environment and verifies the objective at the returned solution. The installed namespace and likelihood are unchanged. Evaluation/time limits are not convergence. Optional independent nlminb refits use the same native likelihood; agreement is not an independent integration-accuracy check. This adapter is version-gated to hisse 2.1.11. [S17]

**Comparison safeguards** Weights require compatible, converged, repeatable interior fits with independent optimizer agreement, no duplicate model specifications and no known better feasible point. Failed verification or too few starts withholds weights; finite fits remain inspectable. These checks do not prove global optimality, identifiability, adequate fit or causal trait effects.

**Parameters and roots** Turnover equals lambda + mu; extinction fraction equals mu/lambda. Hidden labels are exchangeable between fits and should not be treated as observed biological categories. Sampling fractions are supplied per observed state. Given observed-state root probabilities are divided equally among hidden classes; hidden root proportions are not independently editable or estimated by that option.

**Constraint limits** Custom models support equality groups and zero extinction/transition rates, not arbitrary fixed positive rates or simultaneous changes in observed and hidden states. Native bounded search retains the lower log-rate bound of −20. The evaluation budget is now editable (default 100000), with termination status reported. More starts and optional annealing cannot guarantee the best possible fit.

**Unavailable inference** Hidden ancestral assignments, fossil conditioning, confidence intervals, calibrated tests and Bayesian inference are not implemented. Graphs of observed tips must not be read as reconstructions of hidden regimes. Uncertainty in topology, coding, sampling or model selection is not propagated.


## Uncertainty and reporting across the platform

### Quantities that must not be conflated

**Conditional prediction intervals** Describe node-prediction uncertainty under a fitted covariance model and tree. They need not include covariance-parameter uncertainty and are not posterior credible intervals.

**Curvature and profile intervals** Use likelihood approximations or reference thresholds. Finite searches, parameter boundaries and weak identifiability can invalidate simple nominal-coverage interpretations.

**Bayesian credible intervals** Summarize a posterior under specified priors, model and fixed inputs, with accuracy limited by sampling and convergence. They do not eliminate model or prior sensitivity.

**History ranges and bootstrap bands** Have the particular conditioning of their simulation/refitting procedure. A pointwise envelope is not a simultaneous band; successful-refit summaries must be read alongside failure counts.

**Monte Carlo error** Measures numerical precision of simulation summaries. A small MCSE does not mean the biological estimate has little uncertainty.

### Minimum information to report

Identify the GUane version or dated snapshot, package versions, method/engine, likelihood or posterior framework, tree source and units, included taxa, coding and transformations. Record model/root/sampling assumptions, fixed and estimated parameters, starts, bounds, priors, seeds and convergence or numerical warnings as relevant.

Name the interval type and reference level; explain what is held fixed and excluded. Report failed candidates and bootstrap refits, unresolved limits and sensitivity checks. State the candidate set and comparison basis. Preserve the exported data/settings and R script so another analyst can reproduce the saved graph and, where supported, rerun the fit.

### Platform and validation boundaries

Most long fits execute synchronously. Dense matrices, growing state spaces and stored histories can limit interactive scale. Workload guards are computational safeguards, not sample-size or power guarantees. Broad accessibility, performance and predictive-validation reviews remain separate tasks. [S2, S3, S10]

EN/ES/PT switching preserves analysed data and results, but some raw backend messages, audit strings and code comments remain English. Research identifiers and observed values are intentionally unchanged. Read the numerical output and method settings rather than relying on translated labels alone. [S2, S10]

Acceptance tests establish agreement and behaviour for tested cases; they do not establish universal interval coverage or scientific validity for arbitrary data. Temporary installation/app checks are not a complete package-release or R CMD check certification. QuaSSE/hidden-state uncertainty intervals and Bayesian SSE, parsimony and chatbot/phyloSophos communication remain unimplemented. [S10–S12, S14–S16]


## Source register and maintenance

Sources are repository-relative records in the Guane-demo project. Later engine-specific updates supersede older “pending” statements. Current implementation files were also checked for the data, PGLM, uncertainty and SSE status described here.

**S1** R/core_mod_data_base.R and shared Data modules; validation, transformations, normality and PIC handling.

**S2** docs/MILESTONE_3_ACCEPTANCE.md; supported Phylo traits methods, diagnostics and explicit limits.

**S3** docs/CONTINUOUS_MARGINAL_ACCEPTANCE.md; current marginal BM/OU/EB likelihood, known errors, intervals and comparison contract.

**S4** docs/MILESTONE_4J_ACCEPTANCE.md; legacy continuous-engine likelihood distinctions and backend limitations.

**S5** docs/MILESTONE_4H_ACCEPTANCE.md and docs/MILESTONE_4_ACCEPTANCE.md; advanced Mk controls, ML/mapping semantics and earlier ASR scope.

**S6** docs/MILESTONE_4I_ACCEPTANCE.md; saved-result graphics, density projection, interpolation and display limits.

**S7** docs/MILESTONE_4KA_ACCEPTANCE.md; continuous Bayesian BM priors, retained draws and diagnostics.

**S8** docs/MILESTONE_4KB_ACCEPTANCE.md; Bayesian discrete Mk rate sampling, roots and backend access.

**S9** docs/MILESTONE_4KC_ACCEPTANCE.md; Bayesian polymorphic coding, state spaces and constraints.

**S10** docs/MILESTONE_4KD_ACCEPTANCE.md; cross-engine Bayesian acceptance and convergence qualifications.

**S11** docs/MILESTONE_5J_ACCEPTANCE.md and milestone 5A through 5I acceptance records; Diversification scope, numerical checks, conditioning and uncertainty. Current diversity core: R/core_mod_div_diversity.R.

**S12** docs/MILESTONE_6A_ACCEPTANCE.md and R/core_mod_sse_bisse.R; implemented BiSSE scope, constraints, diagnostics and comparison limits.

**S13** R/core_mod_signal_PGLM.R; actual families, response validation, model-based covariance and export interpretation.

**S14** docs/MILESTONE_6B_ACCEPTANCE.md and R/core_mod_sse_musse.R; MuSSE state space, root restrictions and numerical checks.

**S15** docs/MILESTONE_6C_ACCEPTANCE.md and R/core_mod_sse_quasse.R; QuaSSE measurement errors, FFT/grid normalization, controls and limitations.

**S16** docs/MILESTONE_6D_ACCEPTANCE.md and R/core_mod_sse_hidden.R; hisse 2.1.11 integration, CID constraints, unavailable optimizer status and provisional comparisons.

**S17** docs/MILESTONE_6E_ACCEPTANCE.md and R/core_mod_sse.R with card-specific SSE cores; optimizer capture/verification, profile endpoints and grid/domain refits.

### Update rule

Revise this register after adding an engine, changing a likelihood or sampler, altering uncertainty calculations, changing backend versions or expanding acceptance evidence. Distinguish resolved historical restrictions from current limitations. Keep the scientific contract and the user-facing explanation aligned.

Record version 3 • Scope through Milestone 6E • Document language English
