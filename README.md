# GUANE



**Guane** is a modular, multilingual Shiny platform for phylogenetic comparative
analyses. The project aims to make phylogenetic comparative methods more accessible, 
reproducible, and transparent for researchers who may have limited programming experience, limited access to advanced computational training, or who prefer to work through a graphical interface.

Guane is designed as an R package that contains both a full Shiny application and 
independent analytical sub-apps. Each analytical module can run inside the complete 
Guane platform or separately as a standalone mini-application. For example, users 
will be able to run the phylogenetic signal module, ancestral state reconstruction 
module, regression module, or diversification module independently.

## Project goals

Guane has three main goals:

1. Provide a user-friendly graphical interface for common phylogenetic comparative methods.
2. Generate reproducible R code for every analysis through a Live Code Mirror.
3. Support multilingual access, beginning with English, Spanish, and Portuguese.

## Architecture

Guane follows a modular, layered architecture inspired by recommendations for 
large Shiny applications. Each module is separated into three conceptual layers:

- **Graphical interface layer**: Shiny UI components, widgets, navigation, 
language options, and display panels.
- **Analytical computation layer**: Pure R functions that perform data reading,
validation, model fitting, diagnostics, and result processing.
- **Shiny server layer**: Reactive server logic that connects user inputs to 
analytical functions and outputs.

This design allows us to test the analytical functions, documente them, and use 
them independently from the Shiny interface.

## Core module structure

Each Guane analytical module follows the same general structure:

1. **Data upload**
2. **Data diagnosis**
3. **Analysis parameters**
4. **Results**
5. **Live Code Mirror**

This means that every module is designed to be self-contained while sharing common 
infrastructure for data loading, validation, and reproducible code generation.

## Planned modules

The first development version focuses on the foundation of the platform and the 
phylogenetic signal module. Planned modules include:

- Phylogenetic signal
- Phylogenetic regression and comparative linear models
- Ancestral state reconstruction
- Diversification rate analysis
- Character-dependent diversification
- Data validation and standardization
- Live Code Mirror
- Multilingual interface
- Future integration with phyloSophos preregistered workflows

## Current development stage

Guane is currently in early development. The first milestone is to build a minimal 
working prototype that can:

- Load a phylogenetic tree.
- Load a trait table.
- Diagnose compatibility between tree tip labels and trait data.
- Run a simple phylogenetic signal workflow.
- Display the exact R code used in the analysis.
- Run both as a full app and as an independent module app.

## Development philosophy

Guane is built around the principle:

> Clean data → valid analysis → transparent code → reproducible science.

The platform is intended not only as an analytical tool, but also as a teaching 
and reproducibility environment for phylogenetic comparative biology.

## License

Guane is released under the GPL-3.0 license.

## Reproducing the Guane R Environment

Guane uses `renv` to make the R package environment reproducible. All required R 
package versions are recorded in `renv.lock`.

These instructions are for users who want to clone the project, restore the same 
R environment, and run Guane.

---

## 1. Requirements

Before starting, install:

- R
- Git
- RStudio, optional but recommended

This project was developed using R 4.6.0. If possible, use the same or a recent R version.

---

## 2. Clone the repository

Open a terminal and run:


```bash
git clone https://github.com/alarconvv/Guane.git
cd guane
```

---

## 3. Restore the R environment

Open R from the project root folder.

Then run:

```r
source("renv/activate.R")
renv::restore()
```

This will install the package versions recorded in `renv.lock`.

To check that the environment was restored correctly, run:

```r
renv::status()
```

A successful setup should report that the project is synchronized.

---

## 4. Load and run Guane

After restoring the environment, run:

```r
devtools::load_all()
guane::run_app()
```

This should launch the Guane Shiny application.

---

## 5. Optional: check the package

Users who want to verify that the package builds correctly can run:

```r
devtools::check()
```

The package should run without undeclared dependency errors.

---

## 6. Troubleshooting

### Error: `cannot open file 'renv/activate.R'`

This usually means you are not in the project root folder.

Check your current folder with:

```r
getwd()
list.files()
```

You should see files such as:

```text
DESCRIPTION
renv.lock
renv/
README.md
```

If not, move to the correct project folder and try again.

---

### Error: package is not installed

Run:

```r
renv::restore()
```

Then check again:

```r
renv::status()
```

---

### Error during package check

First update the documentation:

```r
devtools::document()
```

Then rerun:

```r
devtools::check()
```

---

## 7. Important notes

Users should not manually edit `renv.lock`.

Users should not commit or copy the local `renv/library/` folder. The environment should always be restored from `renv.lock` using:

```r
renv::restore()
```

The following files are needed for reproducibility:

```text
renv.lock
renv/activate.R
.Rprofile
DESCRIPTION
```


## Docker usage

Guane can be run with Docker for reproducible local installation and future deployment on a Linux server. The Docker image restores the R package environment from `renv.lock`, so package versions are controlled by the lockfile.

### Requirements

Install:

- Docker Desktop
- Git

On Apple Silicon Macs, such as M1, M2, M3, or M4, the Docker image is built using the `linux/amd64` platform because this is closer to the expected Linux server environment.

### Build the Docker image

From the root of the repository:

```bash
docker buildx build --platform linux/amd64 --no-cache -t guane:local --load .

```
Disclaimer: This documentation was done using GPT 5.0. However, developer tested every steps before releasing it for the developer.

