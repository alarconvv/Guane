#' Template module server
#'
#' @param id Module namespace ID.
#'
#' @return A Shiny module server.
#' @keywords internal
mod_template_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    # Server logic goes here.
  })
}
