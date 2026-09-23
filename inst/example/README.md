# Guane synthetic example

`guane-example-tree.nwk` contains 20 tips (Sp01–Sp20). `guane-example-traits.csv` contains 19 species (Sp01–Sp19). **Sp20 is intentionally absent from the CSV** so users can inspect a mismatch before choosing “Use matched taxa”. This explicit action removes Sp20 from the working tree and records it; originals and undo retain the 20-tip tree.

The data are invented for software demonstrations, not biological inference. The rooted, bifurcating, ultrametric tree has Grafen branch lengths in arbitrary units, not calibrated ages.

| Column | Type | Meaning / states |
|---|---|---|
| species | Identifier | Exact tree tip label |
| body_mass | Continuous | Example mass in grams |
| body_length | Continuous | Example length in centimetres |
| temperature | Continuous | Example temperature in degrees Celsius |
| habitat_binary | Discrete, 2 states | terrestrial, aquatic |
| locomotion_3state | Discrete, 3 states | walking, swimming, flying |
| diet_5state | Discrete, 5 states | herbivore, carnivore, omnivore, insectivore, frugivore |
| parental_care_binary | Discrete, 2 states | absent, present |
| resource_use_polymorphic | Polymorphic | fruit, seed, insect and combinations joined by `+` |
| offspring_count | Count | Invented nonnegative integer offspring counts, including zeros; equal observation effort |

A value such as `fruit+seed` represents multiple observed states within a species, not missing data or uncertainty about one state. The `+` encoding follows the installed `phytools::fitpolyMk` parser; the app's Polymorphic traits card supports ML, stochastic mapping and Bayesian Mk analyses of this coding.

Use habitat_binary and parental_care_binary for Pagel's correlation after explicitly matching taxa. No multistate trait is automatically binarized.

For count PGLM, select Counts (Poisson GEE / log), offspring_count, and numeric predictors such as body_mass and temperature. Explicitly match taxa first. These invented values demonstrate the workflow and are not evidence about real reproductive biology.

Grouped-binomial example: success_count is the invented number of successful trials and trial_count is the total attempts for that species. Denominators vary; both zero-success and all-success species are included. Select these two columns in Grouped binomial (GEE / logit), after explicit taxon matching. Trials are counts, not a predictor or an exposure offset.
