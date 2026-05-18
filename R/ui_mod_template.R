#' Template module UI
#'
#' @param id Module namespace ID.
#'
#' @return A Shiny UI.
#' @keywords internal
mod_template_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::h2("Module title"),

    shiny::tabsetPanel(
      shiny::tabPanel(
        "Data",
        shiny::p("Data upload panel goes here.")
      ),

      shiny::tabPanel(
        "Diagnosis",
        shiny::p("Data diagnosis panel goes here.")
      ),

      shiny::tabPanel(
        "Parameters",
        shiny::p("Analysis parameters go here.")
      ),

      shiny::tabPanel(
        "Results",
        shiny::p("Results go here.")
      ),

      shiny::tabPanel(
        "Live Code Mirror",
        shiny::p("Reproducible code goes here.")
      )
    )
  )
}
