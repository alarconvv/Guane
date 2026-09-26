#' Guane: Multilingual Phylogenetic Comparative Analyses
#'
#' A modular R Shiny platform for data preparation, phylogenetic analyses,
#' diagnostics, visualizations and reproducible exports in three languages.
#' @keywords internal
"_PACKAGE"

# Variables evaluated inside mirai workers (see app_tasks.R).
utils::globalVariables(c("lib", "dev", "eval_task"))
# Column names evaluated by transform() in presentation tables.
utils::globalVariables(c("Estimate", "P_value", "P"))
