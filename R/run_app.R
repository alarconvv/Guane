#' Launch the Guane platform.
#' @export
run_app <- function(module='full', default_lang='en', ...) {
 shiny::runApp(app_guane(module,default_lang),...)
}
