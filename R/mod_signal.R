mod_signal_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::h2("Phylogenetic Signal Module"),

    shiny::tabsetPanel(
      shiny::tabPanel(
        "Data",
        shiny::p("Data upload panel will go here.")
      ),

      shiny::tabPanel(
        "Diagnosis",
        shiny::p("Tree and trait diagnosis will go here.")
      ),

      shiny::tabPanel(
        "Parameters",
        shiny::p("Blomberg's K and Pagel's lambda settings will go here.")
      ),

      shiny::tabPanel(
        "Results",
        shiny::p("Phylogenetic signal results will go here.")
      ),

      shiny::tabPanel(
        "Live Code Mirror",
        shiny::p("Reproducible R code will go here.")
      )
    )
  )
}

mod_signal_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    # Signal module server logic will go here.
  })
}
