# R/app_factory.R

build_single_module_app <- function(module = "data_upload",
                                    registry = module_registry) {
  if (!module %in% names(registry)) {
    stop(
      "Unknown module: ", module,
      ". Available modules are: ",
      paste(names(registry), collapse = ", "),
      call. = FALSE
    )
  }

  module_spec <- registry[[module]]

  if (module == "data_upload") {
    ui <- bslib::page_navbar(
      title = paste("Guane:", module_spec$label),
      bslib::nav_panel(
        title = module_spec$label,
        module_spec$ui(module)
      )
    )

    server <- function(input, output, session) {
      app_state <- shiny::reactiveValues(
        tree = NULL,
        traits = NULL,
        validation = list(valid = FALSE)
      )

      module_spec$server(module, app_state = app_state)
    }

    return(shiny::shinyApp(ui, server))
  }

  if (!"data_upload" %in% names(registry)) {
    stop(
      "The selected module requires `data_upload`, but `data_upload` is not registered.",
      call. = FALSE
    )
  }

  data_upload_spec <- registry[["data_upload"]]

  ui <- bslib::page_navbar(
    title = paste("Guane:", module_spec$label),

    bslib::nav_panel(
      title = "Data upload",
      data_upload_spec$ui("data_upload")
    ),

    bslib::nav_panel(
      title = module_spec$label,
      module_spec$ui(module)
    )
  )

  server <- function(input, output, session) {
    app_state <- shiny::reactiveValues(
      tree = NULL,
      traits = NULL,
      validation = list(valid = FALSE)
    )

    data_upload_spec$server("data_upload", app_state = app_state)

    module_spec$server(module, app_state = app_state)
  }

  shiny::shinyApp(ui, server)
}

guane_app <- function(module = "data_upload",
                      registry = module_registry) {
  build_single_module_app(module = module, registry = registry)
}
