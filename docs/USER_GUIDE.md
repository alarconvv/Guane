# Guane user guide — current platform

Guane is a local R/Shiny workspace for phylogenetic comparative analyses. This guide describes the app as implemented through **Milestone 6F (22 September 2026)**. It uses an invented dataset so you can learn the workflow without treating its fitted results as biological findings. The [scientific limitations](SCIENTIFIC_LIMITATIONS.md) give the assumptions and unavailable methods in more detail.

## Open Guane

From the project folder, run this in R or RStudio:

```r
shiny::runApp(".")
```

If Guane has been installed as an R package, use `guane::run_app()` instead. The development app uses the project's local `.guane-library` when it exists; analyses need their respective R backends installed. If a package is missing, follow the error message and ask the project maintainer for the project's dependency setup. The Shiny URL printed by R is local to your computer. The language menu at the top switches **English, Español, Português**.

The four main pills are **Phylo traits**, **Ancestral state reconstruction**, **Diversification**, and **SSE models**. Each has its **own Data card** and analysis cards. Loading the example in one main pill does not load it into the other three. Analysis cards have controls on the left and **Results**, **Diagnostics**, and **Live Code Mirror** tabs. Results and selections stay in place when you switch language or adjust graph appearance. Changing data or model settings can clear an affected result; click its **Run** button again.

## Start with the bundled example

The source files are [guane-example-tree.nwk](../inst/example/guane-example-tree.nwk) and [guane-example-traits.csv](../inst/example/guane-example-traits.csv). In any main pill, open **Data** and click **Load example data**. Guane reads these files; it does not generate a new dataset each time.

The Newick tree has **20 tips (Sp01–Sp20)**, while the CSV has **19 rows (Sp01–Sp19)**. Sp20 is intentionally absent from the table. In **Checking data**, read the mismatch report. Then click **Use matched taxa** in the left settings panel. This explicitly removes Sp20 from the *working* tree and records the action in **Diagnosis log**. The original loaded tree remains available through **Undo data change** or **Restore original inputs**. Do this in each main pill where you want to use the example. Without it, analyses that need aligned tree and trait data will reject the mismatch. For **Diversification → Lineage through time** and other tree-only cards, the tree can be used without matching a trait table.

After matching, inspect **Tree preview** and **Trait preview**. The latter shows a limited number of rows for display; the model uses the whole working table. **Checking data** offers Shapiro–Wilk on the selected numeric trait; log, exponential, quadratic and reciprocal transformations; and phylogenetic independent contrasts (PICs). A transformation creates a **new column** and preserves its source. Choose **Column to display** in the right panel to see the transformed column's histogram, density or Q–Q plot. The distribution graph responds to that selection. PICs are node-level contrasts shown separately; they are not added as species traits. Trait normality does not establish normal residuals for a fitted model. **Diagnosis log** records preparation actions and can export a CSV log and an R preparation script.

The example is synthetic. Its tree is rooted, bifurcating and ultrametric, with **arbitrary branch-length units**, not dated ages. Its columns are:

| CSV column | Data | Example use |
| --- | --- | --- |
| `species` | Tree tip identifier | Select as **Taxon column**. |
| `body_mass`, `body_length`, `temperature` | Continuous measurements | Signal, PGLS, continuous reconstruction, QuaSSE. |
| `habitat_binary`, `parental_care_binary` | Two-state characters | Pagel's correlation, binary reconstruction, BiSSE/HiSSE. |
| `locomotion_3state` | Three-state character | Discrete reconstruction, MuSSE. |
| `diet_5state` | Five-state character | Discrete reconstruction, MuSSE. |
| `resource_use_polymorphic` | Coexisting states such as `fruit+seed` | Polymorphic reconstruction. `+` means coexistence, not uncertainty. |
| `offspring_count` | Nonnegative integer count | Count PGLM. |
| `success_count`, `trial_count` | Successes and total trials | Grouped-binomial PGLM. |

The [example data dictionary](../inst/example/README.md) describes units and coding. These values are invented to exercise the interface; do not interpret model coefficients or p-values as biological evidence.

## Follow a first analysis: phylogenetic signal

1. Open **Phylo traits → Data**, load the example, inspect the mismatch and click **Use matched taxa**.
2. Open **Phylogenetic signal**. Select `body_mass` under **Trait for signal**. Leave **K test draws** at 999 for a first pass, then click **Run signal analysis**.
3. In **Results**, read Blomberg's K and Pagel's λ and view the observed tip values. In **Diagnostics**, inspect the randomized K distribution. The tip colors are observed values, not ancestral estimates. A p-value concerns the specified test and tree; it is not proof of a causal process.
4. Return to **Data → Checking data**. Select `body_mass`, choose **Natural log**, and click **Create transformed column**. The new `body_mass_log` column can be selected in **Column to display** and in **Trait for signal**. Run the signal analysis again to analyze the transformed values. The original `body_mass` remains unchanged.
5. Under **Graph controls**, choose the graph and appearance, then use **Download graph R code** to edit the graph in RStudio. **Download graph PDF** and **Download results CSV** are also available.

Other Phylo traits cards: **PGLS** fits a continuous response against one or more numeric predictors with BM, Grafen, Pagel or Blomberg covariance; **Compare covariance models (ML)** uses the same data and ML across those four candidates. **Pagel's correlation** is Pagel's 1994 test of correlated evolution of **two binary traits**; on the example choose `habitat_binary` and `parental_care_binary`. It compares independent and dependent discrete-evolution models. **PGLM** supports binary, Poisson count, and grouped-binomial responses. For a count demonstration choose **Counts (Poisson GEE / log)**, `offspring_count`, then `body_mass` and `temperature` as predictors. For grouped binomial choose `success_count` as successes and `trial_count` as total trials. Mark any discrete predictor under **Categorical predictors** and set its reference category. Run a model before running taxon influence diagnostics. GEE results do not have likelihood-based AIC comparisons.

## Reconstruct ancestral states

Load and explicitly match the example in **Ancestral state reconstruction → Data** first. Then choose one of these analysis cards:

- **Continuous traits:** select `body_mass`, **Maximum likelihood**, and **Brownian motion (BM)**, then **Run continuous reconstruction**. Explore trait maps, phenograms, node estimates and diagnostics. Marginal ML can also fit OU and early-burst (EB) models; **Compare BM, OU and EB using marginal ML** requires the same data and likelihood basis. Bayesian BM is available with MCMC controls and posterior diagnostics. Parsimony is marked planned.
- **Discrete traits:** select `locomotion_3state`, **Maximum likelihood**, and **ER**, then **Run Mk reconstruction**. The Results graph can show node probability pies and transition-rate diagrams. SYM, ARD and customizable rate constraints are available. **Stochastic mapping (fixed fitted rates)** saves sampled histories conditional on the fitted rates/tree; **Bayesian Mk (sample rates)** has chain settings and diagnostics. Parsimony is planned.
- **Polymorphic traits:** select `resource_use_polymorphic`, leave **Ordered polymorphism** off, choose **Maximum likelihood → ER**, inspect the transition preview and run. This example contains three constituent states and combinations such as `fruit+seed`. Ordered analyses require you to supply an order; the full example includes combinations incompatible with some orders and will be rejected when they violate the chosen constraints. Stochastic mapping and Bayesian Mk are available for ordered or unordered coding. Parsimony is planned.

Read **Diagnostics** for convergence, boundary, Monte Carlo and model warnings. Marginal node probabilities, sampled histories and joint ML estimates answer different questions; use the method label shown with the result. Branch colors and phenogram lines interpolate fitted node values; they are not observed evolutionary trajectories. Select a result graph and download its editable R code, PDF and relevant CSV/RDS data from that card.

## Explore diversification

Open **Diversification → Data** and click **Load example data**. Tree-only cards do not require the CSV match. The example tree's branch lengths are arbitrary, so axes describe **branch-length units**, not years or millions of years.

Start with **Lineage through time**: keep **Data tree**, click **Run LTT**, then switch **Time direction** or **Logarithmic lineage axis** under Graph controls. The curve counts observed surviving lineages; it does not estimate speciation or extinction rates. You can instead upload up to 25 Newick trees into the LTT card for an overlay when their units and sampling are comparable.

The remaining cards answer different rate questions:

| Card | First use with example | How to read it |
| --- | --- | --- |
| **Constant-rate models** | Select Yule and Birth–death; click **Run diversification models**. | Compare candidate fits on the same tree; then use **Run uncertainty and diagnostics** for profiles and conditional LTT checks. |
| **Time-varying models** | Run the default Yule, BD, ExpYule and ExpBD candidates. | View rates through time; optional profile, conditional bootstrap and robustness checks are separate actions. |
| **Clade-specific models** | Select eligible non-overlapping crown nodes, **Preview selected clades**, then run. | Fits each selected clade separately. Compare models **within** a clade, not AIC across different clades. |
| **Joint clade-dependent models** | Select shift nodes, **Preview joint regions**, then run selected shared/shift candidates. | Uses a whole-tree partitioned likelihood; shifts are placed at branch bases. |
| **Diversity-dependent models** | Run a selected DDD model, then **Run numerical diagnostics**. | Curves relate rates to modeled diversity; optional profile/robustness/bootstrap actions have additional assumptions. |

For all rate cards, inspect failed starts, boundaries and numerical stability before interpreting estimates or model weights. Sampling fractions are treated as supplied values. Graph and table downloads, including editable R plotting code, are in the corresponding card.

## Explore SSE models

Open **SSE models → Data**, load the example, inspect and explicitly match Sp20. These methods fit state-dependent diversification models; the small invented example is mainly useful for learning controls and diagnostics.

| Card | Example controls | Important check |
| --- | --- | --- |
| **BiSSE** | Choose `habitat_binary`, set its state 0, select models and click **Run BiSSE**. | Check state coding, sampling fractions, boundaries, optimizer starts and independent verification. |
| **MuSSE** | Choose `locomotion_3state` (or `diet_5state`) and **Run MuSSE**. | Check the displayed state table. The card supports 2–8 observed categorical states. |
| **QuaSSE** | Choose `body_mass`; for interface practice enter `10` under **Common measurement standard error**, then **Run QuaSSE**. This invented error value is not a biological measurement. | Check grid resolution, integration stability and optimizer verification. **Run grid and domain refits** for an additional numerical check. |
| **Hidden-state and null models** | Choose `habitat_binary` and a binary state 0, then select HiSSE, CID-2, CID-4 or the same-backend BiSSE candidate. | Inspect native termination and independent verification before using any comparison. Hidden classes are latent rate categories. |

BiSSE and MuSSE also offer **Profile uncertainty**: fit first, select a model and estimated parameter group in Graph controls, enter finite search bounds that enclose its estimate, then click **Run profile uncertainty**. Inspect the interval and profile grid in Diagnostics. Unresolved endpoints are shown as unavailable. SSE model weights may be withheld even when a finite likelihood is displayed; the warnings explain why. Compare AIC **within one compatible card run**, not between BiSSE, MuSSE, QuaSSE and HiSSE cards. Multistate hidden-state null models, calibrated SSE tests and QuaSSE/hidden-state intervals are unavailable.

## Use your own data and save your work

In the relevant **Data** card, upload exactly one rooted tree in Newick (`.nwk`, `.tre`) or Nexus (`.nex`, `.nexus`) format and a CSV with a taxon column. Tip labels and table identifiers must match exactly and be unique. Choose the taxon and numeric trait columns in Data; individual analysis cards choose their own response or trait. Review **Checking data** before using **Use matched taxa**. Guane does not silently prune, impute, root, resolve polytomies or recalibrate a tree. Each method may impose stricter tree, branch-length, state or sampling requirements. For a tree-only diversification card, the CSV is optional.

After a run, **Results** contains graphs, estimates and relevant CSV/PDF/PNG/RDS downloads; **Diagnostics** contains warnings and method-specific checks. **Live Code Mirror** shows the current saved analysis or prepared settings. **Download graph R code** produces editable R for the selected graph, with the data and settings needed to rerun it in RStudio. Some scripts require the named scientific R packages; inspect their header and run them in an R environment with those packages installed. Save the Data card's prepared tree/CSV and **Export preparation script** when you want an audit trail. A graph file alone is not the complete analytical record.

Changing the display palette, labels or language should keep the fitted result. Changing data, model inputs or parameter settings may invalidate it; rerun the analysis. **Reset controls** clears the Data workspace, while **Undo data change** and **Restore original inputs** are Data preparation actions. The [scientific limitations](SCIENTIFIC_LIMITATIONS.md) explain why some estimates, intervals or comparison weights are deliberately unavailable.

## Customized input formats

The [custom input format reference](CUSTOM_INPUT_FORMATS.md) gives exact headers, headerless matrix rules, constraints, and pasteable examples for ASR, diversification, and SSE controls. The [Quarto manual](GUANE_MANUAL.qmd) combines this reference with the worked platform walkthrough.
