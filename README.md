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

Click **Load example data**, then **Run signal analysis**. Upload one Newick/Nexus 
tree and a CSV table for your own analysis. Select a taxon column and numeric trait. 
The trait preview shows 25 rows by default (change **Preview rows** to see more); computations use the complete table.

## Documentation

The documentation and tutorials are published at <https://alarconvv.github.io/guane-site/>. The site source lives in its own repository, [alarconvv/guane-site](https://github.com/alarconvv/guane-site).

It covers installation, an interface tour, one tutorial per module using the bundled example, custom input formats, exports and scientific limitations.
