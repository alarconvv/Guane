#' Read a phylogenetic tree file
#'
#' Reads a phylogenetic tree from common tree formats supported by Guane.
#' Newick and Nexus files may contain either one tree (`phylo`) or multiple
#' trees (`multiPhylo`), for example posterior tree distributions from Bayesian
#' phylogenetic inference.
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
    "trees" = ape::read.tree(path),
    "nwk" = ape::read.tree(path),
    "newick" = ape::read.tree(path),
    "nex" = ape::read.nexus(path),
    "nexus" = ape::read.nexus(path),
    "rds" = readRDS(path),
    cli::cli_abort("Unsupported tree file format: {.val {ext}}.")
  )

  tree <- normalize_guane_tree_object(tree)

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
    "xml" = read_guane_xml_table(path),
    "rds" = readRDS(path),
    cli::cli_abort("Unsupported trait table format: {.val {ext}}.")
  )

  if (!is.data.frame(traits)) {
    cli::cli_abort("The uploaded trait file must produce a data frame or table-like object.")
  }

  as.data.frame(traits, stringsAsFactors = FALSE)
}


#' Summarize a phylogenetic tree object
#'
#' @param tree A `phylo` or `multiPhylo` object.
#'
#' @return A named list with tree-object metadata.
#' @export
core_tree_summary <- function(tree) {
  tree <- normalize_guane_tree_object(tree)

  if (inherits(tree, "multiPhylo")) {
    first_tree <- tree[[1]]

    return(list(
      object_class = "multiPhylo",
      n_trees = length(tree),
      preview_tree = 1,
      n_tips_preview_tree = length(first_tree$tip.label),
      n_internal_nodes_preview_tree = first_tree$Nnode,
      has_branch_lengths_preview_tree = !is.null(first_tree$edge.length)
    ))
  }

  if (inherits(tree, "phylo")) {
    return(list(
      object_class = "phylo",
      n_trees = 1,
      n_tips = length(tree$tip.label),
      n_internal_nodes = tree$Nnode,
      has_branch_lengths = !is.null(tree$edge.length)
    ))
  }

  cli::cli_abort("`tree` must be a `phylo` or `multiPhylo` object.")
}


normalize_guane_tree_object <- function(tree) {
  if (inherits(tree, "phylo")) {
    return(tree)
  }

  if (inherits(tree, "multiPhylo")) {
    if (length(tree) == 0) {
      cli::cli_abort("The uploaded `multiPhylo` object does not contain any trees.")
    }

    valid_trees <- vapply(tree, inherits, logical(1), "phylo")

    if (!all(valid_trees)) {
      cli::cli_abort("All elements of a `multiPhylo` object must inherit from `phylo`.")
    }

    return(tree)
  }

  if (is.list(tree) && length(tree) > 0 &&
      all(vapply(tree, inherits, logical(1), "phylo"))) {
    class(tree) <- "multiPhylo"
    return(tree)
  }

  tree
}


read_guane_xml_table <- function(path) {
  doc <- xml2::read_xml(path)
  root <- xml2::xml_root(doc)
  rows <- xml2::xml_children(root)

  if (length(rows) == 0) {
    cli::cli_abort("The XML file does not contain table rows.")
  }

  row_values <- lapply(rows, function(row) {
    fields <- xml2::xml_children(row)

    if (length(fields) == 0) {
      value <- xml2::xml_text(row)
      names(value) <- xml2::xml_name(row)
      return(as.list(value))
    }

    values <- xml2::xml_text(fields)
    names(values) <- xml2::xml_name(fields)

    as.list(values)
  })

  columns <- unique(unlist(lapply(row_values, names), use.names = FALSE))

  if (length(columns) == 0) {
    cli::cli_abort("The XML file could not be interpreted as a table.")
  }

  out <- lapply(columns, function(column) {
    vapply(
      row_values,
      function(row) {
        if (column %in% names(row)) {
          return(as.character(row[[column]]))
        }

        NA_character_
      },
      character(1)
    )
  })

  names(out) <- columns

  as.data.frame(out, stringsAsFactors = FALSE)
}
