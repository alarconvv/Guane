#' Read a phylogenetic tree file
#'
#' Reads a phylogenetic tree from common tree formats supported by Guane.
#'
#' @param path Character. Path to a tree file.
#'
#' @return A `phylo` or `multiPhylo` object.
#' @export
core_read_tree <- function(path) {
  if (!is.character(path) || length(path) != 1 || !file.exists(path)) {
    cli::cli_abort("`path` must be a valid path to an existing tree file.")
  }

  ext <- tolower(tools::file_ext(path))

  tree <- switch(
    ext,
    "tre" = ape::read.tree(path),
    "tree" = ape::read.tree(path),
    "nwk" = ape::read.tree(path),
    "newick" = ape::read.tree(path),
    "nex" = ape::read.nexus(path),
    "nexus" = ape::read.nexus(path),
    "rds" = readRDS(path),
    cli::cli_abort("Unsupported tree file format: {.val {ext}}.")
  )

  if (!inherits(tree, c("phylo", "multiPhylo"))) {
    cli::cli_abort("The file did not produce a valid `phylo` or `multiPhylo` object.")
  }

  tree
}


#' Read a trait table
#'
#' Reads a trait table from common tabular file formats supported by Guane.
#'
#' @param path Character. Path to a trait table.
#'
#' @return A data frame.
#' @export
core_read_traits <- function(path) {
  if (!is.character(path) || length(path) != 1 || !file.exists(path)) {
    cli::cli_abort("`path` must be a valid path to an existing trait table.")
  }

  ext <- tolower(tools::file_ext(path))

  traits <- switch(
    ext,
    "csv" = readr::read_csv(path, show_col_types = FALSE),
    "tsv" = readr::read_tsv(path, show_col_types = FALSE),
    "txt" = readr::read_tsv(path, show_col_types = FALSE),
    "xls" = readxl::read_excel(path),
    "xlsx" = readxl::read_excel(path),
    "rds" = readRDS(path),
    cli::cli_abort("Unsupported trait table format: {.val {ext}}.")
  )

  as.data.frame(traits)
}
