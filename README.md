# Guane


## How to run Guane

```
git clone https://github.com/alarconvv/Guane.git
```

From this project directory in R/RStudio:

```r
library(devtools)

devtools::load_all()

guane::run_app()
```

Click **Load example data**, then **Run signal analysis**. Upload one Newick/Nexus tree and a CSV table for your own analysis. Select a taxon column and numeric trait. The trait preview displays the first 100 rows; computations use the complete table.
