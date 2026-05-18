guane_app <- function(module = "full") {
  registry <- guane_module_registry()

  if (module == "full") {
    return(build_full_app(registry))
  }

  if (!module %in% names(registry)) {
    cli::cli_abort("Unknown Guane module: {.val {module}}.")
  }

  build_single_module_app(module, registry)
}

build_full_app <- function(registry) {
  ui <- bslib::page_navbar(
    title = "Guane",
    bslib::nav_panel(
      title = registry$signal$label,
      registry$signal$ui("signal")
    )
  )

  server <- function(input, output, session) {
    registry$signal$server("signal")
  }

  shiny::shinyApp(ui, server)
}

build_single_module_app <- function(module, registry) {
  module_spec <- registry[[module]]

  ui <- bslib::page_navbar(
    title = paste("Guane:", module_spec$label),
    bslib::nav_panel(
      title = module_spec$label,
      module_spec$ui(module)
    )
  )

  server <- function(input, output, session) {
    module_spec$server(module)
  }

  shiny::shinyApp(ui, server)
}
