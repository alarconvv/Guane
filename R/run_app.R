#' Run the Guane Shiny application
#'
#' @param module Character. Which Guane module to run. Use `"full"` for the
#'   complete app or a module name such as `"signal"`.
#' @param ... Additional arguments passed to [shiny::runApp()].
#'
#' @return Opens the Guane Shiny application.
#' @export
run_app <- function(module = "full", ...) {
  app <- guane_app(module = module)
  shiny::runApp(app, ...)
}
