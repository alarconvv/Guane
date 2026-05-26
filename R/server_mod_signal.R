server_mod_signal <- function(id,
                              app_state = NULL,
                              tree_r = NULL,
                              trait_data_r = NULL,
                              validation_status_r = NULL) {
  shiny::moduleServer(id, function(input, output, session) {

    if (!is.null(app_state)) {
      tree_r <- shiny::reactive(app_state$tree)
      trait_data_r <- shiny::reactive(app_state$traits)
      validation_status_r <- shiny::reactive(app_state$validation)
    }

    shiny::observe({
      data <- trait_data_r()
      shiny::req(data)

      data <- as.data.frame(data)
      choices <- names(data)

      shiny::updateSelectInput(
        session,
        "taxon_col",
        choices = choices,
        selected = choices[1]
      )

      shiny::updateSelectInput(
        session,
        "response_col",
        choices = choices,
        selected = choices[min(2, length(choices))]
      )

      shiny::updateSelectInput(
        session,
        "predictor_col",
        choices = c("None" = "", choices),
        selected = if (length(choices) >= 3) choices[3] else ""
      )
    })

    validation_is_ok <- shiny::reactive({
      if (is.null(validation_status_r)) {
        return(TRUE)
      }

      status <- validation_status_r()

      if (isTRUE(status)) {
        return(TRUE)
      }

      if (is.list(status) && isTRUE(status$valid)) {
        return(TRUE)
      }

      FALSE
    })

    signal_result <- shiny::eventReactive(input$run_signal, {
      shiny::validate(
        shiny::need(validation_is_ok(), "Resolve critical validation issues before running Module 1."),
        shiny::need(!is.null(tree_r()), "Upload or select a phylogenetic tree first."),
        shiny::need(!is.null(trait_data_r()), "Upload or select a trait dataset first."),
        shiny::need(nzchar(input$taxon_col), "Select a taxon column."),
        shiny::need(nzchar(input$response_col), "Select a response trait."),
        shiny::need(length(input$methods) > 0, "Select at least one analysis.")
      )

      predictor_col <- input$predictor_col
      if (!nzchar(predictor_col)) {
        predictor_col <- NULL
      }

      guane_run_signal_module(
        tree = tree_r(),
        data = trait_data_r(),
        taxon_col = input$taxon_col,
        response_col = input$response_col,
        predictor_col = predictor_col,
        response_transform = input$response_transform,
        predictor_transform = input$predictor_transform,
        methods = input$methods,
        k_nsim = input$k_nsim,
        pgls_method = input$pgls_method,
        ou_alpha = input$ou_alpha
      )
    })

    output$signal_report <- shiny::renderText({
      result <- signal_result()
      shiny::req(result)
      result$report
    })

    output$signal_plot <- shiny::renderPlot({
      result <- signal_result()
      shiny::req(result)
      guane_plot_signal_overview(result)
    })

    output$pic_plot <- shiny::renderPlot({
      result <- signal_result()
      shiny::req(result)
      guane_plot_pic(result)
    })

    output$live_code <- shiny::renderText({
      result <- signal_result()
      shiny::req(result)
      result$code
    })

    output$download_report <- shiny::downloadHandler(
      filename = function() {
        paste0("guane_module_1_signal_report_", Sys.Date(), ".txt")
      },
      content = function(file) {
        result <- signal_result()
        writeLines(result$report, con = file)
      }
    )

    signal_result
  })
}
