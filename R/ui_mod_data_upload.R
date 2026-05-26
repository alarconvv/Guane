#' Data upload, preview, and validation module UI
#'
#' Provides file upload widgets for phylogenetic trees, posterior tree
#' distributions, and trait datasets, with immediate previews and validation.
#'
#' @param id Module namespace ID.
#'
#' @return A Shiny UI.
#' @export
ui_mod_data_upload <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::h2("Data Upload, Preview, and Validation"),

    shiny::p(
      "Upload a phylogenetic tree and a trait dataset. Guane will preview the ",
      "data, detect common problems, and block analytical modules until critical ",
      "validation issues are resolved."
    ),

    shiny::fluidRow(
      shiny::column(
        width = 4,

        shiny::h3("Upload files"),

        shiny::fileInput(
          inputId = ns("tree_file"),
          label = "Single tree file: Newick or Nexus",
          accept = c(
            ".tre", ".tree", ".nwk", ".newick",
            ".nex", ".nexus", ".rds"
          )
        ),

        shiny::fileInput(
          inputId = ns("posterior_tree_file"),
          label = "Posterior tree distribution: multiPhylo",
          accept = c(
            ".tre", ".tree", ".trees", ".nwk", ".newick",
            ".nex", ".nexus", ".rds"
          )
        ),

        shiny::fileInput(
          inputId = ns("trait_file"),
          label = "Trait dataset: CSV, Excel, XML, TSV, TXT, or RDS",
          accept = c(
            ".csv", ".tsv", ".txt",
            ".xls", ".xlsx",
            ".xml", ".rds"
          )
        ),

        shiny::numericInput(
          inputId = ns("trait_preview_rows"),
          label = "Rows to preview",
          value = 10,
          min = 1,
          max = 50,
          step = 1
        ),

        shiny::hr(),

        shiny::h3("Validation settings"),

        shiny::uiOutput(ns("taxon_column_ui")),
        shiny::uiOutput(ns("trait_columns_ui")),

        shiny::checkboxInput(
          inputId = ns("require_ultrametric"),
          label = "Require ultrametric tree",
          value = FALSE
        ),

        shiny::h4("Diagnostic report"),
        shiny::verbatimTextOutput(ns("diagnostic_report")),
        shiny::downloadButton(
          outputId = ns("download_diagnostic_report"),
          label = "Download diagnostic report"
        ),

        shiny::checkboxInput(
          inputId = ns("allow_polytomies"),
          label = "Allow polytomies",
          value = FALSE
        ),

        shiny::actionButton(
          inputId = ns("dismiss_selected_warnings"),
          label = "Dismiss selected warnings"
        ),

        shiny::actionButton(
          inputId = ns("reset_dismissed_warnings"),
          label = "Reset dismissed warnings"
        )
      ),

      shiny::column(
        width = 8,

        shiny::tabsetPanel(
          shiny::tabPanel(
            "Tree preview",
            shiny::br(),
            shiny::uiOutput(ns("tree_status")),
            shiny::verbatimTextOutput(ns("tree_summary")),
            shiny::plotOutput(ns("tree_plot"), height = "500px")
          ),

          shiny::tabPanel(
            "Trait preview",
            shiny::br(),
            shiny::uiOutput(ns("trait_status")),
            shiny::verbatimTextOutput(ns("trait_summary")),
            shiny::tableOutput(ns("trait_table_preview"))
          ),

          shiny::tabPanel(
            "Validation",
            shiny::br(),
            shiny::uiOutput(ns("analysis_gate")),
            shiny::uiOutput(ns("warnings_to_dismiss_ui")),
            shiny::h4("Detected issues"),
            shiny::tableOutput(ns("validation_table")),
            shiny::h4("Correction options"),
            shiny::uiOutput(ns("correction_options"))
          ),

          shiny::tabPanel(
            "Diagnosis log",
            shiny::br(),
            shiny::tableOutput(ns("diagnosis_log"))
          )
        )
      )
    )
  )
}
