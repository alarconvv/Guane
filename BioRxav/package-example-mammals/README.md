# Unit-checked R-package example for GUANE

Use **phytools 2.5-2** (`packageVersion()` prints 2.5.2), objects `mammal.data` and `mammal.tree`, as the replacement example. There are **49 taxa, two continuous traits and one matching tree**. This is larger than the finch example but remains a small dataset. All taxa match; no pruning, imputation or taxon relabelling was needed.

## Units and transformations verified

| GUANE input column | Meaning | Units or transformation |
|---|---|---|
| body_mass_kg | Original body mass | kilograms (kg) |
| home_range_km2 | Original home-range **area** | square kilometres (km²), not kilometres |
| ln_body_mass_kg | Analysis predictor | natural log of mass divided by 1 kg |
| ln_home_range_km2 | Analysis response/signal trait | natural log of area divided by 1 km² |

The package supplies the first two traits on their raw physical scale. This script preserves them and calls R `log()` exactly once to create the two separate natural-log columns. Do not log those derived columns again. The package's own `phyl.RMA` help likewise applies `log()` to `mammal.data`; it does not imply that the stored values are already logarithms. The 1993 paper used base-10 logarithms for its displayed analyses; the present explicit natural-log choice is separate. A log-log slope is unchanged when both variables are converted between the same log bases, but intercepts and signal on differently transformed traits require care.

## Direct source check

Garland T Jr, Dickerman AW, Janis CM, Jones JA. 1993. Phylogenetic analysis of covariance by computer simulation. Systematic Biology 42:265–292. [Author-hosted original article](https://biology.ucr.edu/people/faculty/Garland/GarlEA93.pdf).

**Table 1, printed page 273 (PDF page 9)** explicitly labels mass in kg and home-range area in km², and lists the underlying references. I visually checked that page and independently transcribed its 98 measurements for comparison. All 49 pairs in the installed package agree at the published precision: body mass to two decimal places, area to three. Package values have tiny numerical differences (largest absolute differences approximately 0.000002 kg and 0.0000002 km²); they were retained unchanged. See evidence/table1-value-audit.csv.

The package help associates these objects with Garland et al. 1992. That paper illustrates a smaller 43-species set; the **1993 Table 1 is the explicit source checked for the complete 49-species measurements**. Do not cite the 43-species table as though it contained all 49 observations. The 1993 Figure 1 and Appendix describe the historical composite time tree; the package tree has root-to-tip height 70, consistent with its million-year scale. Every branch has not been independently transcribed/audited. Retain source taxonomy and branch lengths rather than presenting this as a modern mammal phylogeny.

## Reproduce and use in GUANE

From this directory:

```sh
Rscript --vanilla prepare_and_check.R
```

Upload `data/mammals-49-tree.nwk` and `data/mammals-49-traits.csv` into GUANE, with `taxon` as the identifier. For the same focused workflow, use **ln_home_range_km2** for signal; response **ln_home_range_km2**, predictor **ln_body_mass_kg**, BM covariance and REML for PGLS. Seed 20261201 and 999 total K draws are explicit in the script.

Completed: input validation, all 98 printed-value comparisons, and actual terminal execution of the original GUANE core functions. Results and session versions are in results/. **Graphical-interface replay and robustness for these new mammal inputs have not yet been run.** Existing finch GUI screenshots and omission results do not validate the mammal example. The previous finch manuscript/PDF/ZIP are preserved as historical review artifacts; they have not been relabelled as mammal results.

The script uses the frozen original GUANE source in `../source/`. phytools is distributed under GPL >=2 and GUANE under GPL >=3; this is not a claim of a separate CC0 license for the original observations. Keep source attribution and the package license notices. This remains a local review project; nothing has been submitted or shared.
