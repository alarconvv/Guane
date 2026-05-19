# Guane



**Guane** is a modular, multilingual Shiny platform for phylogenetic comparative analyses. The project aims to make phylogenetic comparative methods more accessible, reproducible, and transparent for researchers who may have limited programming experience, limited access to advanced computational training, or who prefer to work through a graphical interface.

Guane is designed as an R package that contains both a full Shiny application and independent analytical sub-apps. Each analytical module can run inside the complete Guane platform or separately as a standalone mini-application. For example, users will be able to run the phylogenetic signal module, ancestral state reconstruction module, regression module, or diversification module independently.

## Project goals

Guane has three main goals:

1. Provide a user-friendly graphical interface for common phylogenetic comparative methods.
2. Generate reproducible R code for every analysis through a Live Code Mirror.
3. Support multilingual access, beginning with English, Spanish, and Portuguese.

## Architecture

Guane follows a modular, layered architecture inspired by recommendations for large Shiny applications. Each module is separated into three conceptual layers:

- **Graphical interface layer**: Shiny UI components, widgets, navigation, language options, and display panels.
- **Analytical computation layer**: Pure R functions that perform data reading, validation, model fitting, diagnostics, and result processing.
- **Shiny server layer**: Reactive server logic that connects user inputs to analytical functions and outputs.

This design allows us to test the analytical functions, documente them, and use them independently from the Shiny interface.

## Core module structure

Each Guane analytical module follows the same general structure:

1. **Data upload**
2. **Data diagnosis**
3. **Analysis parameters**
4. **Results**
5. **Live Code Mirror**

This means that every module is designed to be self-contained while sharing common infrastructure for data loading, validation, and reproducible code generation.

## Planned modules

The first development version focuses on the foundation of the platform and the phylogenetic signal module. Planned modules include:

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

Guane is currently in early development. The first milestone is to build a minimal working prototype that can:

- Load a phylogenetic tree.
- Load a trait table.
- Diagnose compatibility between tree tip labels and trait data.
- Run a simple phylogenetic signal workflow.
- Display the exact R code used in the analysis.
- Run both as a full app and as an independent module app.

## Development philosophy

Guane is built around the principle:

> Clean data → valid analysis → transparent code → reproducible science.

The platform is intended not only as an analytical tool, but also as a teaching and reproducibility environment for phylogenetic comparative biology.

## License

Guane is released under the GPL-3.0 license.
