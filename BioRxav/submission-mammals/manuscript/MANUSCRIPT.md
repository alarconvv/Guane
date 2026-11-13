# GUANE connects interactive phylogenetic comparative analyses with reproducible R workflows

**Author review draft. Target date: 8 December 2026. No submission authorized.**

**Authors and affiliations:** To be completed by the author. Funding, contributions, competing interests and corresponding-author details will be added after review.

## Abstract

Phylogenetic comparative workflows require explicit decisions about matching species, transforming measurements and specifying evolutionary covariance. GUANE is an R/Shiny application that connects these decisions with established statistical methods and inspectable R code. We evaluate a continuous-trait workflow using the mammal.data and mammal.tree examples distributed with phytools. The dataset comprises 49 matching taxa with body mass in kilograms and home-range area in square kilometres. All 98 measurements agree with the original published table at its printed precision. We preserve the raw variables and create separate natural-log columns. The graphical interface runs phylogenetic signal analysis and Brownian phylogenetic generalized least squares, and its outputs are compared with terminal calculations and clean-session execution of interface-generated scripts. Numerical estimates agree within recorded tolerances. The fitted log-log slope is 1.2616, with a conditional 95% interval of 0.9060–1.6172. All 49 leave-one-taxon-out fits retain a positive slope, although an independence-covariance reference gives a substantially different magnitude. The example demonstrates reproducible execution and retained analytical decisions, rather than a new biological discovery or a new statistical estimator. The accompanying package contains prepared inputs, original GUI exports, captured interface evidence, scripts, diagnostic outputs and manuscript figures.

**Keywords:** phylogenetic comparative methods; phylogenetic signal; PGLS; reproducibility; Shiny; body mass; home range.

## Introduction

Comparative studies connect differences among species with hypotheses about evolutionary history. Shared ancestry makes observations statistically dependent, and analyses therefore require explicit assumptions about phylogenetic covariance (Felsenstein, 1985). Modern R packages provide extensive comparative functionality, but a reproducible study must preserve more than the name of a method. Species matching, the physical scale of a measurement, transformations, model settings and diagnostics all affect what a reported result means.

A graphical interface can help researchers navigate these choices if the computation remains inspectable outside the application. GUANE is a multilingual R/Shiny platform that organizes data preparation and comparative analyses into a common workflow. Its numerical functions accept ordinary R objects, while interface and server components manage controls and results. R-code exports provide a route from the interactive session to independent execution.

Here we evaluate a focused workflow with a small historical mammal example distributed in phytools. We ask whether the GUI preserves a transparent path from unit-checked measurements to phylogenetic signal and a specified regression, and whether its results can be reproduced from the terminal. Body mass and home-range area provide an established biological illustration. The purpose is software workflow evaluation; it is not to discover a new allometric law or reproduce every analysis in the original mammal study.

## Materials and methods

### Evaluated software

We used the original GUANE application, package version 1.0, from alarconvv/Guane. The recorded repository HEAD is a9a2675ca3644e8a3c43a9ef020758c7b39ab81f. Hashes of the actual source files and inputs accompany this package, because a commit identifier alone does not describe local changes. Later GUANE variants are outside the evaluated implementation.

The computation layer is separated from interface construction and reactive orchestration. We evaluated the data card, phylogenetic signal and PGLS workflows. The local Shiny app was launched from the original checkout; prepared empirical files were uploaded through the graphical controls. We did not replace the application's synthetic example or website tutorials. The analysis package retains the numerical source functions unchanged, allowing a terminal replay without loading the full application.

### Dataset and explicit scales

We used mammal.data and mammal.tree from phytools 2.5-2, which contain 49 species-level records and a matching historical phylogeny. The package help associates the example with Garland et al. (1992). For the complete 49-species measurements, we directly checked Garland et al. (1993), Table 1, printed page 273. That table explicitly states body mass in kilograms and home-range area in square kilometres. Its 49 mass/area pairs agree with the installed package at printed precision; tiny representation differences were retained rather than rounded away. The checked data include 19 Carnivora and 30 ungulates in the historical classification.

All identifiers match between the tree and table, and none was removed or imputed. We preserved the source abbreviations and taxonomy. Inputs passed checks for unique labels, finite positive trait values, a rooted bifurcating ultrametric tree and positive edge lengths. The historical tree is a composite hypothesis whose documentation describes estimated divergence times; we preserve its supplied branch lengths. A modern phylogeny, alternative topologies and independent verification of every historical branch are outside this evaluation.

We retained body_mass_kg and home_range_km2 as raw physical measurements. Two derived columns were created once using R log(): ln_body_mass_kg and ln_home_range_km2. These represent ln(mass/1 kg) and ln(area/1 km²). The package's phyl.RMA example likewise applies log() to the stored measurements, supporting that those stored values are not already logs. The original paper used base-10 logarithms in its displayed analyses; our natural-log transformation is explicit and is not presented as a verbatim reproduction of its analysis. The original table combines records from multiple underlying studies, so the observations should not be described as measurements from a single standardized collection protocol.

### Graphical execution

In the Phylo traits Data card we uploaded the 49-tip Newick file and CSV table, selected taxon as the identifier and set seed 20261201. Explicit matching recorded zero unmatched entries. In the signal card we selected ln_home_range_km2 and 999 test draws, including the observed configuration. The card computes Blomberg's K with its randomization test and Pagel's lambda with a likelihood-ratio test against lambda equal to zero (Blomberg et al., 2003; Pagel, 1999).

In PGLS we selected ln_home_range_km2 as response, ln_body_mass_kg as the single predictor, Brownian covariance and restricted maximum likelihood. These settings call ape::corBrownian and nlme::gls. Species-level measurements entered the regression directly, without independent contrasts as an additional preprocessing step. The coefficient intervals are t-based intervals conditional on the fitted covariance. We inspected observed versus fitted values, normalized residuals and a Q–Q display, and retained fit warnings.

### Terminal replication and sensitivity

We downloaded the GUI's numerical tables and captured its Live Code Mirror scripts. Downloaded graph scripts and graph PDFs are retained with the GUI evidence where collection succeeded; the export manifest distinguishes files from screenshots and terminal replays. Each retained analytical script was refitted in a fresh Rscript --vanilla process, with assertions that the GUANE namespace was not loaded. We also called the frozen GUANE core functions on the same CSV/Newick inputs and compared estimates with direct phytools and nlme calls.

Full-precision CSVs and script results were compared at tolerance 10^-8, while direct backend checks used 10^-10. Captured GUI tables were checked at their displayed precision. Saved logs distinguish failed browser export attempts from completed numerical analyses. Figures produced by replay are labelled as terminal-generated, not passed off as original GUI exports.

We refitted the same BM/REML regression after omitting each taxon in turn, reporting all 49 outcomes, conditional intervals and signal results. We also fitted a fixed-lambda-zero independence reference using the same variables and REML. This is a sensitivity reference, not model selection or evidence that either covariance is adequate. Normalized residual plots provide descriptive checks rather than a certificate of model adequacy.

## Results

All 49 taxa matched and the GUI preparation log recorded zero exclusions. Both graphical analyses completed, and PGLS reported no fitting warnings. Numerical tables and clean-session script refits agreed with the corresponding terminal analyses within the recorded tolerances. Direct phytools and nlme calls agreed with the GUANE adapter estimates.

For ln home-range area, K was 0.2568045, with randomization P = 0.002002 under the specified seed and draw count. Lambda was 0.4159822, with likelihood-ratio P = 0.3760167 against lambda = 0. The tests have different reference hypotheses. The randomization result does not imply that the lambda test must reject zero, nor do either of these tests identify a biological evolutionary process.

The BM PGLS slope was 1.261576 (SE 0.176772; conditional 95% interval 0.905957–1.617195; P = 5.0716 × 10^-9), and the intercept was −3.278525. These describe the specified natural-log relationship conditional on the supplied tree and covariance model. GUI values displayed as 0.00000 for a small P value were not interpreted as exact zero.

All 49 single-taxon omission fits retained positive slopes, ranging from 1.133611 to 1.320231, with every lower 95% interval bound above zero. Omitting M._kirki produced the largest slope change. K randomization P values ranged from 0.001001 to 0.003003; lambda-test P values ranged from 0.095020 to 1.000000. The fixed-independence reference slope was 0.607104, substantially smaller than the BM estimate. Thus the regression direction survived single-taxon deletion, but its magnitude was sensitive to covariance assumptions.

Figure 1 presents the evaluated workflow. Figure 2 combines the fitted relationship, residual plots and every omission interval. The complete tree and per-taxon omission table accompany the supplementary materials. The GUI-output collection records export-tool retries separately from successful calculation and replay.

## Discussion

The mammal example demonstrates the value of retaining explicit scales and preparation decisions in an interactive comparative workflow. Matching does not silently change the taxon set, raw values remain available alongside named transformations, and a selected covariance model can be traced to a specified R calculation. The interface and terminal comparisons provide evidence of numerical reproducibility for the two tested workflows.

This agreement is not an independent validation of the underlying statistical methods. GUANE uses established packages; direct backend agreement tests adapter consistency rather than demonstrating greater accuracy, speed or statistical power. We did not evaluate user comprehension, accessibility across all modules, concurrency, every interface control or every supported method. Browser export retries are reported without assigning their cause to the application.

The sensitivity results show why reproducibility and scientific interpretation require separate consideration. A positive slope across all omission fits does not establish robustness to evolutionary covariance. The independence-reference slope differs substantially from the BM slope, and the historical dataset includes major clades with different ecological characteristics. Our simple regression does not model dietary/clade effects or attempt to replicate the original paper's ANCOVA. It should therefore remain a transparent example of a specified calculation rather than a definitive biological scaling estimate.

The analysis conditions on one historical tree and ignores uncertainty in its topology, dates and heterogeneous source measurements. Species-level records may combine differing collection methods and contexts. Resolving original physical units does not remove these limitations. The demonstration is valuable because its settings and outputs can be inspected, including assumptions that may warrant more extensive analysis in a biological study.

## Data and code availability

The raw example is distributed with phytools 2.5-2, and the original measurement table is attributed to Garland et al. (1993). The local package includes raw-scale and derived inputs, source functions, GUI exports and captures, terminal scripts, full numerical results and checksums. GUANE is GPL >=3 and phytools is GPL >=2; no separate CC0 license is asserted for the original measurements. Preserve software notices and data-source attribution. Author action before posting: select the manuscript license, review dataset reuse terms and replace this local availability statement with an authorized persistent archive identifier. No public deposit has been made.

## Author declarations

Author list, affiliations, corresponding author, contributions, funding, competing interests and final posting consent will be supplied by the author after review. No new animal measurements were collected for this software demonstration.

## Figure captions

**Figure 1. Evaluated GUANE workflow.** The 49-taxon phytools example is checked against its published raw units and retained without exclusions. Natural-log columns are created explicitly, graphical analyses are run, and interface-generated scripts and numerical tables are compared with clean terminal calculations. This diagram summarizes the tested workflow, not every GUANE feature.

**Figure 2. Mammal comparative analysis and sensitivity.** (A) ln home-range area (km² reference unit) against ln body mass (kg reference unit), with the specified BM/REML regression line. (B) Normalized residuals versus fitted values. (C) Conditional residual Q–Q plot. (D) All 49 leave-one-taxon-out slope estimates with conditional 95% intervals; the horizontal line is the full-data slope. The index follows source-tree tip order; the omitted-taxon key is supplied in supplement/leave-one-out.csv. Neither the regression line nor these diagnostics represents an ancestral reconstruction. The independence-reference result is reported in the text rather than selected as a preferred model.

## References

Blomberg SP, Garland T Jr, Ives AR. 2003. Testing for phylogenetic signal in comparative data: behavioral traits are more labile. Evolution 57:717–745. https://doi.org/10.1111/j.0014-3820.2003.tb00285.x

Felsenstein J. 1985. Phylogenies and the comparative method. American Naturalist 125:1–15. https://doi.org/10.1086/284325

Garland T Jr, Dickerman AW, Janis CM, Jones JA. 1993. Phylogenetic analysis of covariance by computer simulation. Systematic Biology 42:265–292. https://doi.org/10.1093/sysbio/42.3.265

Garland T Jr, Harvey PH, Ives AR. 1992. Procedures for the analysis of comparative data using phylogenetically independent contrasts. Systematic Biology 41:18–32. https://doi.org/10.1093/sysbio/41.1.18

Pagel M. 1999. Inferring the historical patterns of biological evolution. Nature 401:877–884. https://doi.org/10.1038/44766

Paradis E, Schliep K. 2019. ape 5.0: an environment for modern phylogenetics and evolutionary analyses in R. Bioinformatics 35:526–528. https://doi.org/10.1093/bioinformatics/bty633

Revell LJ. 2024. phytools 2.0: an updated R ecosystem for phylogenetic comparative methods (and other things). PeerJ 12:e16505. https://doi.org/10.7717/peerj.16505

Software versions and citation records for R, Shiny, nlme, ape, phytools and the evaluated GUANE source are retained with the reproduction package. Complete the final release citation and public archive identifier before posting.
