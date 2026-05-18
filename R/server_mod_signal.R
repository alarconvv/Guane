#' Phylogenetic signal module server
#'
#' @param id Module namespace ID.
#'
#' @return A Shiny module server.
#' @export
mod_signal_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {

    trait_vector <- shiny::reactive({
      c(input$x1, input$x2, input$x3)
    })

    result <- shiny::reactive({
      core_signal_summary(trait_vector())
    })

    output$diagnosis <- shiny::renderPrint({
      x <- trait_vector()

      list(
        is_numeric = is.numeric(x),
        n_values = length(x),
        missing_values = sum(is.na(x))
      )
    })

    output$result <- shiny::renderPrint({
      result()
    })

    output$code <- shiny::renderText({
      paste(
        "x <- c(",
        paste(trait_vector(), collapse = ", "),
        ")",
        "\n",
        "core_signal_summary(x)",
        sep = ""
      )
    })
  })
}
