#' Run the Guane Shiny application
#'
#' @param module Module to open. Use "data_upload", "signal", or "template".
#' @param ... Additional arguments passed to `shiny::runApp()`.
#'
#' @return Runs the Shiny app.
#' @export
run_app <- function(module = "data_upload", ...) {
  shiny::runApp(
    appDir = guane_app(module = module),
    ...
  )
}
