#' Diagnose compatibility between a tree and trait table
#'
#' Checks whether tree tip labels and trait-table taxon names are compatible
#' before running phylogenetic comparative analyses.
#'
#' @param tree A `phylo` or `multiPhylo` object.
#' @param traits A data frame containing trait data.
#' @param taxon_col Character. Name of the column containing taxon names.
#'
#' @return A list containing summary counts, detected issues, and an
#'   `analysis_ready` flag.
#' @export
core_diagnose_tree_traits <- function(tree, traits, taxon_col) {
  if (inherits(tree, "multiPhylo")) {
    tree <- tree[[1]]
  }

  if (!inherits(tree, "phylo")) {
    cli::cli_abort("`tree` must be a `phylo` or `multiPhylo` object.")
  }

  if (!is.data.frame(traits)) {
    cli::cli_abort("`traits` must be a data frame.")
  }

  if (!is.character(taxon_col) || length(taxon_col) != 1) {
    cli::cli_abort("`taxon_col` must be a single character value.")
  }

  if (!taxon_col %in% names(traits)) {
    cli::cli_abort("`taxon_col` was not found in `traits`.")
  }

  tree_taxa <- trimws(as.character(tree$tip.label))
  data_taxa <- trimws(as.character(traits[[taxon_col]]))

  duplicated_tree_taxa <- unique(tree_taxa[duplicated(tree_taxa)])
  duplicated_data_taxa <- unique(data_taxa[duplicated(data_taxa)])

  matched_taxa <- intersect(tree_taxa, data_taxa)
  tree_not_in_data <- setdiff(tree_taxa, data_taxa)
  data_not_in_tree <- setdiff(data_taxa, tree_taxa)

  issues <- data.frame(
    severity = character(),
    issue = character(),
    n = integer(),
    stringsAsFactors = FALSE
  )

  add_issue <- function(severity, issue, n) {
    issues[nrow(issues) + 1, ] <<- list(severity, issue, n)
  }

  if (length(duplicated_tree_taxa) > 0) {
    add_issue("error", "Duplicated tree tip labels", length(duplicated_tree_taxa))
  }

  if (length(duplicated_data_taxa) > 0) {
    add_issue("error", "Duplicated taxon names in trait table", length(duplicated_data_taxa))
  }

  if (length(tree_not_in_data) > 0) {
    add_issue("warning", "Tree taxa missing from trait table", length(tree_not_in_data))
  }

  if (length(data_not_in_tree) > 0) {
    add_issue("warning", "Trait-table taxa missing from tree", length(data_not_in_tree))
  }

  if (length(matched_taxa) < 3) {
    add_issue("error", "Too few matched taxa", length(matched_taxa))
  }

  list(
    n_tree_tips = length(tree_taxa),
    n_trait_rows = nrow(traits),
    n_matched_taxa = length(matched_taxa),
    matched_taxa = matched_taxa,
    tree_not_in_data = tree_not_in_data,
    data_not_in_tree = data_not_in_tree,
    issues = issues,
    analysis_ready = !any(issues$severity == "error")
  )
}
