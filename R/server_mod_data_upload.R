#' Data upload, preview, and validation module server
#'
#' Server logic for reading uploaded files, rendering previews, running
#' validation checks, and updating the app-level analysis gate.
#'
#' @param id Module namespace ID.
#' @param app_state Optional Shiny reactiveValues object shared by the full app.
#'
#' @return A Shiny module server.
#' @export
server_mod_data_upload <- function(id, app_state = NULL) {
  shiny::moduleServer(id, function(input, output, session) {

    if (is.null(app_state)) {
      app_state <- shiny::reactiveValues(
        tree = NULL,
        traits = NULL,
        validation = list(valid = FALSE)
      )
    }

    dismissed_warning_ids <- shiny::reactiveVal(character())
    diagnosis_log <- shiny::reactiveVal(guane_empty_diagnosis_log())

    tree_result <- shiny::reactive({
      uploaded <- input$posterior_tree_file
      source <- "Posterior tree distribution"

      if (is.null(uploaded)) {
        uploaded <- input$tree_file
        source <- "Single tree file"
      }

      if (is.null(uploaded)) {
        return(list(value = NULL, error = NULL, source = NULL))
      }

      tryCatch(
        {
          path <- guane_preserve_upload_extension(uploaded)
          tree <- core_read_tree(path)

          list(value = tree, error = NULL, source = source)
        },
        error = function(e) {
          list(value = NULL, error = conditionMessage(e), source = source)
        }
      )
    })

    trait_result <- shiny::reactive({
      uploaded <- input$trait_file

      if (is.null(uploaded)) {
        return(list(value = NULL, error = NULL))
      }

      tryCatch(
        {
          path <- guane_preserve_upload_extension(uploaded)
          traits <- core_read_traits(path)

          list(value = traits, error = NULL)
        },
        error = function(e) {
          list(value = NULL, error = conditionMessage(e))
        }
      )
    })

    output$taxon_column_ui <- shiny::renderUI({
      traits <- trait_result()$value

      if (is.null(traits)) {
        return(shiny::helpText("Upload a trait table to select the taxon column."))
      }

      candidate <- guane_guess_taxon_column(names(traits))

      shiny::selectInput(
        inputId = session$ns("taxon_col"),
        label = "Taxon label column",
        choices = names(traits),
        selected = candidate
      )
    })

    output$trait_columns_ui <- shiny::renderUI({
      traits <- trait_result()$value

      if (is.null(traits)) {
        return(shiny::helpText("Upload a trait table to select trait columns."))
      }

      taxon_col <- input$taxon_col
      choices <- setdiff(names(traits), taxon_col)

      shiny::selectInput(
        inputId = session$ns("trait_cols"),
        label = "Trait columns to validate",
        choices = choices,
        selected = choices,
        multiple = TRUE
      )
    })

    validation_result <- shiny::reactive({
      tree <- tree_result()
      traits <- trait_result()

      if (!is.null(tree$error)) {
        issues <- guane_empty_issue_table()
        issues[nrow(issues) + 1, ] <- list(
          issue_id = "tree_format_error",
          severity = "error",
          category = "tree format",
          issue = "Incompatible tree format",
          details = tree$error,
          n = NA_integer_,
          correction = "Upload a valid Newick, Nexus, or RDS file containing a `phylo` or `multiPhylo` object.",
          can_dismiss = FALSE,
          status = "active"
        )

        return(guane_validation_from_issues(issues))
      }

      if (!is.null(traits$error)) {
        issues <- guane_empty_issue_table()
        issues[nrow(issues) + 1, ] <- list(
          issue_id = "trait_format_error",
          severity = "error",
          category = "trait format",
          issue = "Incompatible trait table format",
          details = traits$error,
          n = NA_integer_,
          correction = "Upload a valid CSV, TSV, Excel, XML, TXT, or RDS table.",
          can_dismiss = FALSE,
          status = "active"
        )

        return(guane_validation_from_issues(issues))
      }

      if (is.null(tree$value) || is.null(traits$value) || is.null(input$taxon_col)) {
        return(NULL)
      }

      core_validate_tree_traits(
        tree = tree$value,
        traits = traits$value,
        taxon_col = input$taxon_col,
        trait_cols = input$trait_cols,
        require_ultrametric = isTRUE(input$require_ultrametric),
        allow_polytomies = isTRUE(input$allow_polytomies),
        dismissed_issue_ids = dismissed_warning_ids()
      )
    })

    shiny::observeEvent(validation_result(), {
      validation <- validation_result()

      if (is.null(validation)) {
        if (!is.null(app_state)) {
          app_state$validation_ready <- FALSE
        }

        return()
      }

      if (!is.null(app_state)) {
        app_state$validation_ready <- isTRUE(validation$analysis_ready)
        app_state$validation <- validation
      }

      diagnosis_log(
        guane_append_diagnosis_log(
          diagnosis_log(),
          validation$issues,
          validation$analysis_ready
        )
      )
    }, ignoreNULL = FALSE)

    shiny::observeEvent(input$dismiss_selected_warnings, {
      selected <- input$warnings_to_dismiss

      if (is.null(selected) || length(selected) == 0) {
        return()
      }

      dismissed_warning_ids(unique(c(dismissed_warning_ids(), selected)))
    })

    shiny::observeEvent(input$reset_dismissed_warnings, {
      dismissed_warning_ids(character())
    })

    diagnostic_report <- shiny::reactive({
      shiny::req(validation_result())

      BuildDiagnosticReport(
        validation.result = validation_result(),
        dataset.name = "Uploaded dataset"
      )
    })

    output$diagnostic_report <- shiny::renderText({
      diagnostic_report()
    })

    output$download_diagnostic_report <- shiny::downloadHandler(
      filename = function() {
        paste0("guane_diagnostic_report_", Sys.Date(), ".txt")
      },
      content = function(file) {
        WriteDiagnosticReport(
          report.text = diagnostic_report(),
          file = file
        )
      }
    )



    output$tree_status <- shiny::renderUI({
      result <- tree_result()

      if (is.null(result$value) && is.null(result$error)) {
        return(shiny::helpText("No tree file uploaded yet."))
      }

      if (!is.null(result$error)) {
        return(shiny::div(
          class = "alert alert-danger",
          shiny::strong("Tree upload error: "),
          result$error
        ))
      }

      tree_class <- if (inherits(result$value, "multiPhylo")) {
        "multiPhylo"
      } else {
        "phylo"
      }

      shiny::div(
        class = "alert alert-success",
        shiny::strong("Tree loaded successfully. "),
        paste0("Detected object class: ", tree_class, ". Source: ", result$source, ".")
      )
    })

    output$tree_summary <- shiny::renderPrint({
      result <- tree_result()

      shiny::validate(
        shiny::need(!is.null(result$value), "Upload a tree file to see the summary."),
        shiny::need(is.null(result$error), result$error)
      )

      core_tree_summary(result$value)
    })

    output$tree_plot <- shiny::renderPlot({
      result <- tree_result()

      shiny::validate(
        shiny::need(!is.null(result$value), "Upload a tree file to preview the tree."),
        shiny::need(is.null(result$error), result$error)
      )

      tree <- result$value

      if (inherits(tree, "multiPhylo")) {
        tree <- tree[[1]]
        main <- "Preview of first tree in posterior distribution"
      } else {
        main <- "Tree preview"
      }

      plot(tree, cex = 0.7, no.margin = TRUE, main = main)
    })

    output$trait_status <- shiny::renderUI({
      result <- trait_result()

      if (is.null(result$value) && is.null(result$error)) {
        return(shiny::helpText("No trait dataset uploaded yet."))
      }

      if (!is.null(result$error)) {
        return(shiny::div(
          class = "alert alert-danger",
          shiny::strong("Trait upload error: "),
          result$error
        ))
      }

      shiny::div(
        class = "alert alert-success",
        shiny::strong("Trait dataset loaded successfully. "),
        paste0(
          nrow(result$value), " rows and ",
          ncol(result$value), " columns detected."
        )
      )
    })

    output$trait_summary <- shiny::renderPrint({
      result <- trait_result()

      shiny::validate(
        shiny::need(!is.null(result$value), "Upload a trait dataset to see the summary."),
        shiny::need(is.null(result$error), result$error)
      )

      traits <- result$value

      list(
        n_rows = nrow(traits),
        n_columns = ncol(traits),
        column_names = names(traits),
        column_classes = vapply(traits, function(x) class(x)[1], character(1))
      )
    })

    output$trait_table_preview <- shiny::renderTable({
      result <- trait_result()

      shiny::validate(
        shiny::need(!is.null(result$value), "Upload a trait dataset to preview the table."),
        shiny::need(is.null(result$error), result$error)
      )

      preview_rows <- guane_null_default(input$trait_preview_rows, 10)

      utils::head(result$value, preview_rows)
    }, striped = TRUE, bordered = TRUE, spacing = "s")

    output$analysis_gate <- shiny::renderUI({
      validation <- validation_result()

      if (is.null(validation)) {
        return(shiny::div(
          class = "alert alert-warning",
          shiny::strong("Analysis locked. "),
          "Upload both a tree and a trait table, then select a taxon column."
        ))
      }

      if (isTRUE(validation$analysis_ready)) {
        return(shiny::div(
          class = "alert alert-success",
          shiny::strong("Analysis unlocked. "),
          "No active errors or warnings remain."
        ))
      }

      if (isTRUE(validation$has_errors)) {
        return(shiny::div(
          class = "alert alert-danger",
          shiny::strong("Analysis locked. "),
          "Critical validation errors must be corrected before analysis."
        ))
      }

      shiny::div(
        class = "alert alert-warning",
        shiny::strong("Analysis locked by warnings. "),
        "Review the warnings and dismiss only those that are acceptable for your analysis."
      )
    })

    output$warnings_to_dismiss_ui <- shiny::renderUI({
      validation <- validation_result()

      if (is.null(validation) || nrow(validation$issues) == 0) {
        return(NULL)
      }

      warnings <- validation$issues[
        validation$issues$severity == "warning" &
          validation$issues$status == "active" &
          validation$issues$can_dismiss,
        ,
        drop = FALSE
      ]

      if (nrow(warnings) == 0) {
        return(NULL)
      }

      labels <- stats::setNames(
        warnings$issue_id,
        paste0(warnings$issue, " — ", warnings$details)
      )

      shiny::checkboxGroupInput(
        inputId = session$ns("warnings_to_dismiss"),
        label = "Warnings to dismiss voluntarily",
        choices = labels
      )
    })

    output$validation_table <- shiny::renderTable({
      validation <- validation_result()

      shiny::validate(
        shiny::need(!is.null(validation), "Upload tree and trait data to run validation.")
      )

      validation$issues
    }, striped = TRUE, bordered = TRUE, spacing = "s")

    output$correction_options <- shiny::renderUI({
      validation <- validation_result()

      if (is.null(validation) || nrow(validation$issues) == 0) {
        return(shiny::p("No correction options to display."))
      }

      shiny::tags$ul(
        lapply(seq_len(nrow(validation$issues)), function(i) {
          issue <- validation$issues[i, ]

          shiny::tags$li(
            shiny::strong(paste0("[", issue$severity, "] ", issue$issue, ": ")),
            issue$correction
          )
        })
      )
    })

    output$diagnosis_log <- shiny::renderTable({
      diagnosis_log()
    }, striped = TRUE, bordered = TRUE, spacing = "s")
  })
}


guane_preserve_upload_extension <- function(upload) {
  ext <- tools::file_ext(upload$name)

  path <- if (nzchar(ext)) {
    tempfile(fileext = paste0(".", ext))
  } else {
    tempfile()
  }

  copied <- file.copy(upload$datapath, path, overwrite = TRUE)

  if (!isTRUE(copied)) {
    cli::cli_abort("Could not prepare the uploaded file for reading.")
  }

  path
}


guane_null_default <- function(x, default) {
  if (is.null(x)) {
    return(default)
  }

  x
}


guane_guess_taxon_column <- function(columns) {
  candidates <- c(
    "species", "Species",
    "taxon", "Taxon",
    "taxa", "Taxa",
    "tip.label", "tip_label",
    "name", "Name"
  )

  match <- intersect(candidates, columns)

  if (length(match) > 0) {
    return(match[[1]])
  }

  columns[[1]]
}


guane_validation_from_issues <- function(issues) {
  active_issues <- issues[issues$status == "active", , drop = FALSE]
  active_errors <- active_issues[active_issues$severity == "error", , drop = FALSE]
  active_warnings <- active_issues[active_issues$severity == "warning", , drop = FALSE]

  list(
    issues = issues,
    active_issues = active_issues,
    active_errors = active_errors,
    active_warnings = active_warnings,
    has_errors = nrow(active_errors) > 0,
    has_warnings = nrow(active_warnings) > 0,
    analysis_ready = nrow(active_errors) == 0 && nrow(active_warnings) == 0
  )
}


guane_empty_diagnosis_log <- function() {
  data.frame(
    timestamp = character(),
    issue_id = character(),
    severity = character(),
    issue = character(),
    status = character(),
    analysis_ready = logical(),
    stringsAsFactors = FALSE
  )
}


guane_append_diagnosis_log <- function(log, issues, analysis_ready) {
  if (is.null(issues) || nrow(issues) == 0) {
    entry <- data.frame(
      timestamp = as.character(Sys.time()),
      issue_id = "none",
      severity = "none",
      issue = "No validation issues detected",
      status = "passed",
      analysis_ready = analysis_ready,
      stringsAsFactors = FALSE
    )

    return(rbind(log, entry))
  }

  entries <- data.frame(
    timestamp = as.character(Sys.time()),
    issue_id = issues$issue_id,
    severity = issues$severity,
    issue = issues$issue,
    status = issues$status,
    analysis_ready = analysis_ready,
    stringsAsFactors = FALSE
  )

  rbind(log, entries)
}
