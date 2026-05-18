#' Phylogenetic signal module UI
#'
#' @param id Module namespace ID.
#'
#' @return A Shiny UI.
#' @export
mod_signal_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::h2("Phylogenetic Signal Module"),

    shiny::tabsetPanel(
      shiny::tabPanel(
        "Data",
        shiny::numericInput(ns("x1"), "Trait value 1", value = 1),
        shiny::numericInput(ns("x2"), "Trait value 2", value = 2),
        shiny::numericInput(ns("x3"), "Trait value 3", value = 3)
      ),

      shiny::tabPanel(
        "Diagnosis",
        shiny::verbatimTextOutput(ns("diagnosis"))
      ),

      shiny::tabPanel(
        "Parameters",
        shiny::p("Later: choose Blomberg's K or Pagel's lambda.")
      ),

      shiny::tabPanel(
        "Results",
        shiny::verbatimTextOutput(ns("result"))
      ),

      shiny::tabPanel(
        "Live Code Mirror",
        shiny::verbatimTextOutput(ns("code"))
      )
    )
  )
}
