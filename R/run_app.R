#' Launch the Guane platform.
#' @export
run_app <- function(module='full', submodule='full', default_lang='en', ...) {
 shiny::runApp(app_guane(module,submodule,default_lang),...)
}
