# Repeat the mammal exercise in the graphical interface

Use the original alarconvv/Guane application, version 1.0, recorded HEAD a9a2675ca3644e8a3c43a9ef020758c7b39ab81f. In R from that repository, load it with pkgload::load_all() and run guane::run_app(). The supplied source hashes define the tested numerical files; full app installation follows its existing README.

1. In Phylo traits → Data, upload data/mammals-49-tree.nwk and data/mammals-49-traits.csv from this exercise folder.
2. Select taxon as the identifier. Confirm 49 tips and 49 records. Click Use matched taxa; confirm zero unmatched entries. Set Seed to 20261201.
3. Raw columns are body_mass_kg and home_range_km2. Natural-log columns have already been created once. Do not log the ln_ columns again.
4. In Phylogenetic signal select ln_home_range_km2 and 999 K test draws including observed. Run. Inspect both result rows and the randomized-K diagnostic.
5. Save Download results CSV, Download graph R code and, if available, Download graph PDF to a new local run folder. Preserve any export failure message. Capture the Results and Diagnostics views and Live Code Mirror.
6. In PGLS select response ln_home_range_km2, predictor ln_body_mass_kg, BM covariance and REML. Run. Inspect the coefficient table and both residual diagnostics.
7. Save coefficient CSV, graph R code and graph PDF. Capture the Results/Diagnostics views. Do not run the separate Compare covariance models button for this specified exercise.
8. Compare new numerical CSVs to terminal/signal.csv and terminal/pgls.csv at tolerance 10^-8 with the same package versions. Keep P values in scientific notation; a displayed 0.00000 is not exact zero.
9. Run the saved scripts in separate clean R sessions. The supplied run_all.R repeats this for the GUI files preserved in this package and checks their numerical results.

Save new GUI runs in a new directory so the historical evidence in gui/ is not overwritten. If inputs, settings or versions change, identify that as a new analysis rather than claiming an exact replay.
