# GUANE connects interactive phylogenetic comparative analysis with inspectable R workflows

**Revised short bioRxiv draft — 11 November 2026. Target posting: 8 December 2026. Review copy: provenance and author approval remain open.**

**Authors and affiliations:** TODO: confirm author list, order, affiliations and corresponding author. This draft describes the original GUANE application and a separate empirical finch example; it does not replace the existing longer Applications manuscript.

## Abstract

Phylogenetic comparative analyses require explicit decisions about taxon matching, trait representation and evolutionary covariance. Graphical interfaces can support these decisions when their analytical settings and numerical results remain inspectable. GUANE is an R/Shiny application that connects data preparation with established comparative methods and R code export. We demonstrate a compact continuous-trait workflow using the historical Darwin's finch dataset distributed with geiger. The distributed phylogeny contains 14 tips, and the morphological matrix contains 13 taxa; explicit matching retains 13 taxa without imputation. Using the original GUANE core functions, we estimate phylogenetic signal in beak depth and fit a Brownian phylogenetic generalized least-squares regression against wing length. Core estimates agree with direct phytools and nlme calculations. The fitted slope is 3.038 on the distributed measurement scale, with a conditional 95% interval of 2.256–3.821. These results illustrate inspectable calculation and diagnostic reporting in a small empirical workflow. They do not establish biological causation or broad model adequacy. The accompanying preparation package preserves inputs, exclusions, settings, source functions, numerical outputs and two figures. The graphical analyses and interface-generated scripts reproduced the terminal estimates. Leave-one-taxon-out regression slopes remained positive (2.811–3.142), whereas the K randomization test was sensitive to taxon omission. Historical measurement metadata and a cross-distribution taxon-label discrepancy constrain biological interpretation.

**Keywords:** comparative methods; phylogenetic signal; phylogenetic regression; reproducibility; Shiny; Darwin's finches.

## Introduction

Comparisons among species must account for their shared evolutionary history. Researchers can apply established phylogenetic methods through R packages such as ape, phytools and nlme, but an analysis also requires decisions about identifiers, missing observations, trait scales and covariance assumptions. A successful calculation does not reveal whether these decisions were appropriate or recoverable from the final figure alone.

Graphical workflows can make comparative analyses easier to navigate while preserving a record of those choices. Their scientific value depends on connecting interface controls to a specified computation and on making inputs, diagnostics and settings available for inspection. GUANE was developed as an R/Shiny platform for this purpose. Its analytical functions are separated from the interface and reactive orchestration, allowing computations to be called with ordinary R objects.

Here we present a narrowly scoped empirical demonstration using a small Darwin's finch dataset. We focus on phylogenetic signal and a single regression rather than attempting to evaluate every supported method. Our demonstration asks whether beak depth covaries with wing length under a specified Brownian covariance model and whether GUANE's core estimates match direct calls to its statistical engines. The contribution is an inspectable software workflow around existing comparative methods, not a new estimator or a new claim about finch adaptation.

## Materials and methods

### Software and scope

The evaluated implementation is the original GUANE application, version 1.0, from the alarconvv/Guane repository. The local repository HEAD was a9a2675ca3644e8a3c43a9ef020758c7b39ab81f. Because a commit identifier alone cannot describe local changes, the preparation package records hashes of the actual source files used. Later GUANE variants are outside this evaluation.

GUANE separates interface definitions, server behavior and computations into distinct source files. We evaluated its data validation, phylogenetic signal and PGLS computation functions. The website tutorial illustrates these methods with synthetic values; the present project supplies empirical inputs in a separate directory. We copied the required core files unchanged into the preparation package and called them directly from R. On 11 November 2026 we additionally uploaded the original empirical files through the local Shiny interface, explicitly matched taxa, and ran both analysis cards using the same settings. The downloaded signal R script and the PGLS Live Code Mirror script were executed in separate clean R sessions without loading GUANE. The PGLS download button itself was not verified.

### Empirical data and matching

We extracted the geospiza object from geiger 2.0.12, which distributes morphological measurements of Darwin's finches with an empirical phylogeny. The package credits Dolph Schluter. We preserved the distributed R object, original 14-tip tree and 13-row trait table. One tree tip, olivacea, has no corresponding trait row and was excluded using an explicit matching step. No trait observations were imputed or removed on the basis of their values. The resulting tree and table contain the same 13 identifiers in the same order.

The five retained variables are wing length, tarsus length, culmen length, beak depth and gonys width, using the original column names wingL, tarsusL, culmenL, beakD and gonysW. We selected beakD for signal analysis and as the regression response, with wingL as the sole predictor. Values were retained on their distributed scale without an additional log transformation. The current and historical package documentation attribute the data to Dolph Schluter but do not identify the original collection protocol, physical units, variable-specific transformation or historical tree calibration. The BEAST example contains identical numerical measurements, but its Certhidea olivacea row matches the geiger row labelled fusca. We preserved the geiger distribution unchanged; the identity and tree placement of that record require confirmation before biological interpretation. Branch lengths were not converted into calendar time. The retained tree passed checks for rooting, bifurcation, ultrametricity and finite positive branch lengths; all analyzed traits were finite and nonconstant.

### Signal and regression

We called guane_signal with seed 20261201 and 999 K test draws including the observed configuration. The function uses phytools::phylosig to compute Blomberg's K and its randomization test, together with Pagel's lambda and a likelihood-ratio test against lambda equal to zero. The two tests have different reference hypotheses and should not be interpreted as interchangeable measures of significance.

We fitted beakD as a function of wingL through guane_pgls with Brownian covariance and restricted maximum likelihood. This function uses ape::corBrownian and nlme::gls. Species-level observations entered the regression directly; independent contrasts were not applied as an additional preprocessing step. GUANE returned coefficient estimates, standard errors, conditional t-based intervals and normalized residuals. No covariance-model search or model averaging was performed.

### Computational verification and figures

We compared GUANE's K and lambda estimates with direct phytools calls and compared its regression coefficients with a direct nlme::gls fit using the same inputs, covariance and estimation method. Assertions required numerical agreement within 10^-10. We compared the rendered GUI values at their five-decimal display precision (absolute tolerance 5.1 × 10^-6) and compared script refits, prepared inputs and regression residuals with terminal package calls at tolerance 10^-8. This comparison checks implementation consistency rather than independently validating the statistical methods. The analysis record includes warnings, input exclusions, session information and saved fit objects.

We performed all 13 leave-one-taxon-out refits using the same BM/REML model, retaining every outcome. For each 12-taxon dataset we also repeated signal estimation with the same seed and draw count. We fitted a fixed-lambda-zero independence reference to assess sensitivity to the covariance assumption, without selecting a preferred model. Conditional normalized residuals were inspected graphically and with a descriptive Shapiro–Wilk check; with 13 taxa this is not a model-adequacy certificate.

Figure 1 summarizes the workflow. Figure 2 displays the matched tree, trait association with the fitted regression line, normalized residuals against fitted values, and leave-one-taxon-out slope intervals. Both figures are generated by the supplied script. No ancestral values are estimated or represented in these figures.

## Results

The preparation retained all 13 available morphological records and excluded the single unmatched tree tip. All input assertions passed. GUANE's numerical estimates agreed with the direct backend calls within the specified tolerance. The PGLS function returned no warnings for this run.

Beak depth had an estimated Blomberg's K of 0.6431, with randomization P = 0.03904 under the specified draw count and seed. The estimated lambda was 0.7457, with likelihood-ratio P = 0.1676 against lambda = 0. These outcomes reflect distinct tests in a small dataset. The lambda estimate alone does not establish strong evidence against zero phylogenetic covariance, and neither statistic establishes a particular evolutionary process.

The Brownian PGLS slope for wingL was 3.0385 (SE 0.3555; conditional 95% interval 2.2561–3.8208). The intercept was −10.9530 (SE 1.5010). These estimates describe a positive association on the distributed scale conditional on the tree and specified model. Figure 2C exposes the residual pattern for evaluation; a completed computation and absence of warnings do not establish the adequacy of Brownian residual covariance.

The complete numerical tables and diagnostics accompany the draft. The results reported here were generated by the frozen core functions. The graphical signal and PGLS tables agreed with terminal results at displayed precision. Refits using the downloaded signal script and the PGLS Live Code Mirror agreed within 10^-8, including the PGLS normalized residuals. Separate standalone processes succeeded without loading GUANE. The interface log recorded exclusion of olivacea. One CSV upload showed a generic error; uploading identical bytes from a short temporary path succeeded. Automated download capture timed out; a separate download operation recovered the signal script. These observations do not validate every export control.

Across all 13 leave-one-taxon-out refits, slopes ranged from 2.8110 to 3.1420 and all conditional 95% intervals remained above zero. Omitting psittacula produced the largest absolute slope change (0.2275). The independence-reference slope was 3.0824. In contrast, K-test P values ranged from 0.0120 to 0.2122 and lambda-test P values from 0.0509 to 1.0000 after omission. Thus the direction of the supplied-table regression was stable to single-taxon deletion, while a threshold-based signal conclusion was not. The descriptive residual Shapiro–Wilk result was W = 0.9017, P = 0.1411, which does not demonstrate residual normality or covariance adequacy.

## Discussion

The finch example illustrates the decisions that an inspectable comparative workflow should retain. A mismatch between a tree and trait table becomes an explicit exclusion, and the user can identify the variables and covariance model used in the final calculation. Keeping these decisions alongside source functions and numerical outputs makes the analysis easier to evaluate and repeat.

Agreement with direct phytools and nlme calculations supports the consistency of GUANE's adapters for this small example. It does not demonstrate greater accuracy than those packages, validate every GUANE method or establish advantages in speed or usability. Those claims would require separate evaluations. The practical benefit examined here is the connection among preparation, established methods and retained analysis records.

Several limitations constrain biological interpretation. Thirteen taxa provide a compact demonstration but limited information for complex evolutionary-model comparisons. The analysis conditions on one historical phylogeny and does not propagate tree uncertainty or measurement error. Wing length and beak depth share aspects of organismal size, and their association cannot be interpreted as a causal relationship. The tree is also an approximation to the evolutionary relationships of these finches. Historical measurement metadata must be resolved before interpreting the coefficient in original units or as an allometric exponent.

The interface and terminal agreement supports reproducibility for the two tested workflows and retained settings. Single-taxon deletion supports the numerical stability of the regression direction on the distributed table, but cannot repair uncertainty about taxon identity, measurement provenance or evolutionary covariance. Resolving the fusca/olivacea naming discrepancy and the historical measurement metadata is required before treating these calculations as new biological evidence. Other modules, alternate trees and every export control remain outside this evaluation.

## Data and code availability

The empirical source is geiger 2.0.12, available from CRAN. Its package license is GPL >=2; no separate CC0 license is asserted for the finch dataset. The preparation package retains source attribution, the original distributed object, matched input files, exclusions, scripts, GUANE source copies and outputs. GUANE source is GPL >=3. TODO: replace this local availability statement with a persistent public archive identifier and the exact evaluated GUANE release before posting.

## Author contributions and declarations

TODO: author-approved contributions, funding, acknowledgments, competing interests and corresponding author details. Verify applicable institutional declarations for reuse of published comparative data. No new animal measurements were collected for this demonstration.

## Figure captions

**Figure 1. Inspectable empirical workflow in GUANE.** The historical finch distribution contains a 14-tip tree and 13 morphological records. Explicit matching excludes olivacea and retains the 13 available records. Signal analysis and Brownian PGLS produce numerical results and diagnostics. The tested graphical analyses reproduced the terminal estimates; the downloaded signal script and displayed PGLS script also refitted successfully in clean R sessions. File: figures/figure01.pdf.

**Figure 2. A small continuous-trait demonstration using Darwin's finches.** (A) The distributed phylogeny after removal of the tip without traits; labels preserve source identifiers, and branch lengths retain distributed units. (B) Beak depth against wing length on the distributed scale, with the fitted Brownian PGLS line. (C) Normalized residuals against fitted values from the same model. (D) Slopes and conditional 95% intervals from all 13 leave-one-taxon-out fits; row labels identify the omitted taxon, and the vertical reference is the full-data slope. Points represent the 13 matched taxa. The line is a regression fit, not an ancestral reconstruction; original trait units and historical transformations remain to be verified. File: figures/figure02.pdf.

## References

Blomberg SP, Garland T Jr, Ives AR. 2003. Testing for phylogenetic signal in comparative data: behavioral traits are more labile. Evolution 57:717–745. https://doi.org/10.1111/j.0014-3820.2003.tb00285.x

Felsenstein J. 1985. Phylogenies and the comparative method. American Naturalist 125:1–15. https://doi.org/10.1086/284325

Pagel M. 1999. Inferring the historical patterns of biological evolution. Nature 401:877–884. https://doi.org/10.1038/44766

Paradis E, Schliep K. 2019. ape 5.0: an environment for modern phylogenetics and evolutionary analyses in R. Bioinformatics 35:526–528. https://doi.org/10.1093/bioinformatics/bty633

Pennell MW et al. 2014. geiger v2.0: an expanded suite of methods for fitting macroevolutionary models to phylogenetic trees. Bioinformatics 30:2216–2218. https://doi.org/10.1093/bioinformatics/btu181

Revell LJ. 2024. phytools 2.0: an updated R ecosystem for phylogenetic comparative methods (and other things). PeerJ 12:e16505. https://doi.org/10.7717/peerj.16505

Software citations to finalize from the archived environment: geiger 2.0.12 (https://doi.org/10.32614/CRAN.package.geiger), ape, phytools, nlme, R and the frozen GUANE release. Confirm reference metadata and recover the original finch measurement/tree source before submission.

Additional source documentation: BEAST project, Analysing Continuous Traits (https://beast.community/continuous_traits); geiger historical dataset documentation (https://github.com/cran/geiger/blob/1.0-91/man/geospiza.Rd); ouch dataset documentation (https://kingaa.github.io/manuals/ouch/html/geospiza.html). These establish distribution history and a naming discrepancy, not the original measurement protocol.
