#' Summarize a numeric trait for phylogenetic signal analysis
#'
#' This minimal core function verifies that a trait is numeric and returns
#' basic information needed before running phylogenetic signal methods.
#'
#' @param trait Numeric vector.
#'
#' @return A list with trait summary values.
#' @export
core_signal_summary <- function(trait) {
  if (!is.numeric(trait)) {
    cli::cli_abort("`trait` must be numeric.")
  }

  list(
    n = length(trait),
    n_missing = sum(is.na(trait)),
    mean = mean(trait, na.rm = TRUE),
    sd = stats::sd(trait, na.rm = TRUE)
  )
}
