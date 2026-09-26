#' Launch the Guane platform.
#' @param module Primary module to launch, or full for all modules.
#' @param default_lang Initial interface language: en, es, or pt.
#' @param ... Additional arguments passed to shiny::runApp().
#' @export
run_app <- function(module='full', default_lang='en', ...) {
 shiny::runApp(app_guane(module,default_lang),...)
}
