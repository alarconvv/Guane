#' Run a minimal phylogenetic signal summary
#'
#' This placeholder checks that the core layer runs independently from Shiny.
#'
#' @param x Numeric trait vector.
#'
#' @return A list with basic trait summary.
#' @export
core_signal_summary <- function(x) {
  if (!is.numeric(x)) {
    cli::cli_abort("Trait vector must be numeric.")
  }

  list(
    n = length(x),
    mean = mean(x, na.rm = TRUE),
    sd = stats::sd(x, na.rm = TRUE),
    missing = sum(is.na(x))
  )
}
