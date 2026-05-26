#' Validate uploaded tree and trait data
#'
#' Runs Guane's pre-analysis validation decision tree.
#'
#' @param tree A `phylo` or `multiPhylo` object.
#' @param traits A data frame containing trait data.
#' @param taxon_col Character. Column name containing taxon names.
#' @param trait_cols Character vector. Trait columns to check for missing values.
#' @param require_ultrametric Logical. If `TRUE`, non-ultrametric trees are errors.
#' @param allow_polytomies Logical. If `FALSE`, polytomies are warnings.
#' @param malformed_pattern Regular expression for valid taxon labels.
#' @param dismissed_issue_ids Character vector of dismissed warning issue IDs.
#'
#' @return A list with issues, status, and readiness flags.
#' @export
core_validate_tree_traits <- function(
    tree,
    traits,
    taxon_col,
    trait_cols = NULL,
    require_ultrametric = FALSE,
    allow_polytomies = FALSE,
    malformed_pattern = "^[A-Za-z0-9_.:-]+$",
    dismissed_issue_ids = character()
) {
  tree <- normalize_guane_tree_object(tree)

  if (!inherits(tree, c("phylo", "multiPhylo"))) {
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

  if (is.null(trait_cols) || length(trait_cols) == 0) {
    trait_cols <- setdiff(names(traits), taxon_col)
  }

  trait_cols <- intersect(trait_cols, names(traits))

  issues <- guane_empty_issue_table()

  add_issue <- function(
    issue_id,
    severity,
    category,
    issue,
    details,
    n = NA_integer_,
    correction = "",
    can_dismiss = severity != "error"
  ) {
    issues[nrow(issues) + 1, ] <<- list(
      issue_id = issue_id,
      severity = severity,
      category = category,
      issue = issue,
      details = details,
      n = as.integer(ifelse(is.na(n), NA_integer_, n)),
      correction = correction,
      can_dismiss = can_dismiss,
      status = if (issue_id %in% dismissed_issue_ids && can_dismiss) {
        "dismissed"
      } else {
        "active"
      },
      stringsAsFactors = FALSE
    )
  }

  tree_list <- guane_tree_list(tree)
  reference_tree <- tree_list[[1]]

  tree_taxa <- trimws(as.character(reference_tree$tip.label))
  raw_tree_taxa <- as.character(reference_tree$tip.label)

  data_taxa <- trimws(as.character(traits[[taxon_col]]))
  raw_data_taxa <- as.character(traits[[taxon_col]])

  # --------------------------------------------------------------------------
  # 1. Tree object and posterior-distribution consistency
  # --------------------------------------------------------------------------

  if (inherits(tree, "multiPhylo")) {
    tip_sets_match <- vapply(
      tree_list,
      function(x) identical(sort(x$tip.label), sort(reference_tree$tip.label)),
      logical(1)
    )

    if (!all(tip_sets_match)) {
      add_issue(
        issue_id = "tree_posterior_inconsistent_tip_sets",
        severity = "error",
        category = "tree",
        issue = "Posterior tree distribution has inconsistent tip labels",
        details = paste0(
          sum(!tip_sets_match),
          " trees do not contain the same tip set as the first tree."
        ),
        n = sum(!tip_sets_match),
        correction = paste(
          "Use a posterior tree distribution in which all trees contain the same taxa,",
          "or prune/standardize the posterior trees before uploading."
        ),
        can_dismiss = FALSE
      )
    }
  }

  # --------------------------------------------------------------------------
  # 2. Duplicate labels
  # --------------------------------------------------------------------------

  duplicated_tree_taxa <- unique(tree_taxa[duplicated(tree_taxa)])
  duplicated_data_taxa <- unique(data_taxa[duplicated(data_taxa)])

  if (length(duplicated_tree_taxa) > 0) {
    add_issue(
      issue_id = "tree_duplicate_taxa",
      severity = "error",
      category = "taxon labels",
      issue = "Duplicated tree tip labels",
      details = paste(duplicated_tree_taxa, collapse = ", "),
      n = length(duplicated_tree_taxa),
      correction = "Rename duplicated tree tips so every terminal taxon has a unique label.",
      can_dismiss = FALSE
    )
  }

  if (length(duplicated_data_taxa) > 0) {
    add_issue(
      issue_id = "trait_duplicate_taxa",
      severity = "error",
      category = "taxon labels",
      issue = "Duplicated taxon labels in trait table",
      details = paste(duplicated_data_taxa, collapse = ", "),
      n = length(duplicated_data_taxa),
      correction = "Remove duplicate rows or make taxon names unique in the trait table.",
      can_dismiss = FALSE
    )
  }

  # --------------------------------------------------------------------------
  # 3. Malformed labels
  # --------------------------------------------------------------------------

  empty_tree_taxa <- is.na(tree_taxa) | tree_taxa == ""
  empty_data_taxa <- is.na(data_taxa) | data_taxa == ""

  if (any(empty_tree_taxa)) {
    add_issue(
      issue_id = "tree_empty_taxa",
      severity = "error",
      category = "taxon labels",
      issue = "Empty tree tip labels",
      details = paste(which(empty_tree_taxa), collapse = ", "),
      n = sum(empty_tree_taxa),
      correction = "Fill or correct empty tree tip labels before upload.",
      can_dismiss = FALSE
    )
  }

  if (any(empty_data_taxa)) {
    add_issue(
      issue_id = "trait_empty_taxa",
      severity = "error",
      category = "taxon labels",
      issue = "Empty taxon labels in trait table",
      details = paste(which(empty_data_taxa), collapse = ", "),
      n = sum(empty_data_taxa),
      correction = "Fill or remove rows with empty taxon labels.",
      can_dismiss = FALSE
    )
  }

  tree_whitespace <- raw_tree_taxa != tree_taxa
  data_whitespace <- raw_data_taxa != data_taxa

  if (any(tree_whitespace, na.rm = TRUE)) {
    add_issue(
      issue_id = "tree_taxa_whitespace",
      severity = "warning",
      category = "taxon labels",
      issue = "Tree labels contain leading or trailing whitespace",
      details = paste(raw_tree_taxa[tree_whitespace], collapse = ", "),
      n = sum(tree_whitespace, na.rm = TRUE),
      correction = "Trim whitespace from tree labels before analysis."
    )
  }

  if (any(data_whitespace, na.rm = TRUE)) {
    add_issue(
      issue_id = "trait_taxa_whitespace",
      severity = "warning",
      category = "taxon labels",
      issue = "Trait-table labels contain leading or trailing whitespace",
      details = paste(raw_data_taxa[data_whitespace], collapse = ", "),
      n = sum(data_whitespace, na.rm = TRUE),
      correction = "Trim whitespace from taxon labels in the trait table."
    )
  }

  malformed_tree_taxa <- tree_taxa[
    !is.na(tree_taxa) &
      tree_taxa != "" &
      !grepl(malformed_pattern, tree_taxa)
  ]

  malformed_data_taxa <- data_taxa[
    !is.na(data_taxa) &
      data_taxa != "" &
      !grepl(malformed_pattern, data_taxa)
  ]

  if (length(malformed_tree_taxa) > 0) {
    add_issue(
      issue_id = "tree_malformed_taxa",
      severity = "warning",
      category = "taxon labels",
      issue = "Potentially malformed tree labels",
      details = paste(unique(malformed_tree_taxa), collapse = ", "),
      n = length(unique(malformed_tree_taxa)),
      correction = paste(
        "Use simple labels with letters, numbers, underscores, dots, colons, or hyphens.",
        "Avoid spaces and special characters unless the downstream method supports them."
      )
    )
  }

  if (length(malformed_data_taxa) > 0) {
    add_issue(
      issue_id = "trait_malformed_taxa",
      severity = "warning",
      category = "taxon labels",
      issue = "Potentially malformed trait-table labels",
      details = paste(unique(malformed_data_taxa), collapse = ", "),
      n = length(unique(malformed_data_taxa)),
      correction = paste(
        "Use simple labels with letters, numbers, underscores, dots, colons, or hyphens.",
        "Make sure names match the tree exactly."
      )
    )
  }

  # --------------------------------------------------------------------------
  # 4. Mismatched taxa
  # --------------------------------------------------------------------------

  matched_taxa <- intersect(tree_taxa, data_taxa)
  tree_not_in_data <- setdiff(tree_taxa, data_taxa)
  data_not_in_tree <- setdiff(data_taxa, tree_taxa)

  if (length(tree_not_in_data) > 0) {
    add_issue(
      issue_id = "tree_taxa_missing_from_traits",
      severity = "error",
      category = "taxon matching",
      issue = "Tree taxa missing from trait table",
      details = paste(tree_not_in_data, collapse = ", "),
      n = length(tree_not_in_data),
      correction = "Add missing taxa to the trait table or prune the tree before analysis.",
      can_dismiss = FALSE
    )
  }

  if (length(data_not_in_tree) > 0) {
    add_issue(
      issue_id = "trait_taxa_missing_from_tree",
      severity = "warning",
      category = "taxon matching",
      issue = "Trait-table taxa missing from tree",
      details = paste(data_not_in_tree, collapse = ", "),
      n = length(data_not_in_tree),
      correction = "Remove extra rows from the trait table or use a tree containing those taxa."
    )
  }

  if (length(matched_taxa) < 3) {
    add_issue(
      issue_id = "too_few_matched_taxa",
      severity = "error",
      category = "taxon matching",
      issue = "Too few matched taxa",
      details = paste0(length(matched_taxa), " matched taxa detected."),
      n = length(matched_taxa),
      correction = "At least three matching taxa are required for a meaningful phylogenetic analysis.",
      can_dismiss = FALSE
    )
  }

  # --------------------------------------------------------------------------
  # 5. Tree structure checks
  # --------------------------------------------------------------------------

  binary_status <- vapply(tree_list, guane_is_binary_tree, logical(1))
  ultrametric_status <- vapply(tree_list, guane_is_ultrametric_tree, logical(1))

  if (!allow_polytomies && any(!binary_status)) {
    add_issue(
      issue_id = "tree_polytomies",
      severity = "warning",
      category = "tree structure",
      issue = "Polytomies detected",
      details = paste0(sum(!binary_status), " tree(s) are not fully bifurcating."),
      n = sum(!binary_status),
      correction = paste(
        "Resolve polytomies before using methods that require a fully bifurcating tree.",
        "For exploratory work, you may dismiss this warning if the selected method can handle polytomies."
      )
    )
  }

  if (any(!ultrametric_status)) {
    add_issue(
      issue_id = "tree_non_ultrametric",
      severity = if (require_ultrametric) "error" else "warning",
      category = "tree structure",
      issue = "Non-ultrametric tree detected",
      details = paste0(sum(!ultrametric_status), " tree(s) are not ultrametric."),
      n = sum(!ultrametric_status),
      correction = paste(
        "Use an ultrametric tree for methods requiring time-scaled phylogenies.",
        "Otherwise, dismiss this warning only if the chosen method allows non-ultrametric trees."
      ),
      can_dismiss = !require_ultrametric
    )
  }

  # --------------------------------------------------------------------------
  # 6. Missing trait values
  # --------------------------------------------------------------------------

  missing_trait_counts <- vapply(
    trait_cols,
    function(column) sum(is.na(traits[[column]]) | traits[[column]] == ""),
    integer(1)
  )

  missing_trait_counts <- missing_trait_counts[missing_trait_counts > 0]

  if (length(missing_trait_counts) > 0) {
    add_issue(
      issue_id = "trait_missing_values",
      severity = "error",
      category = "trait values",
      issue = "Missing trait values detected",
      details = paste(
        paste0(names(missing_trait_counts), " = ", missing_trait_counts),
        collapse = "; "
      ),
      n = sum(missing_trait_counts),
      correction = paste(
        "Impute missing values, remove incomplete taxa,",
        "or select only trait columns without missing values."
      ),
      can_dismiss = FALSE
    )
  }

  active_issues <- issues[issues$status == "active", , drop = FALSE]
  active_errors <- active_issues[active_issues$severity == "error", , drop = FALSE]
  active_warnings <- active_issues[active_issues$severity == "warning", , drop = FALSE]

  list(
    issues = issues,
    active_issues = active_issues,
    active_errors = active_errors,
    active_warnings = active_warnings,
    n_tree_tips = length(tree_taxa),
    n_trait_rows = nrow(traits),
    n_matched_taxa = length(matched_taxa),
    matched_taxa = matched_taxa,
    tree_not_in_data = tree_not_in_data,
    data_not_in_tree = data_not_in_tree,
    has_errors = nrow(active_errors) > 0,
    has_warnings = nrow(active_warnings) > 0,
    analysis_ready = nrow(active_errors) == 0 && nrow(active_warnings) == 0
  )
}


guane_empty_issue_table <- function() {
  data.frame(
    issue_id = character(),
    severity = character(),
    category = character(),
    issue = character(),
    details = character(),
    n = integer(),
    correction = character(),
    can_dismiss = logical(),
    status = character(),
    stringsAsFactors = FALSE
  )
}


guane_tree_list <- function(tree) {
  if (inherits(tree, "multiPhylo")) {
    return(unclass(tree))
  }

  list(tree)
}


guane_is_binary_tree <- function(tree) {
  if (exists("is.binary.phylo", envir = asNamespace("ape"), inherits = FALSE)) {
    return(ape::is.binary.phylo(tree))
  }

  ape::is.binary.tree(tree)
}


guane_is_ultrametric_tree <- function(tree) {
  isTRUE(ape::is.ultrametric(tree))
}
