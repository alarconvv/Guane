#' Template core function
#'
#' This is an example of a core analytical function that can run without Shiny.
#'
#' @param x Numeric vector.
#'
#' @return A list with summary statistics.
#' @keywords internal
core_template_summary <- function(x) {
  if (!is.numeric(x)) {
    cli::cli_abort("`x` must be numeric.")
  }

  list(
    n = length(x),
    mean = mean(x, na.rm = TRUE),
    sd = stats::sd(x, na.rm = TRUE)
  )
}
