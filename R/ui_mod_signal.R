# R/ui_mod_signal.R

ui_mod_signal <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    bslib::card(
      bslib::card_header("Module 1: Phylogenetic signal and comparative regression"),

      shiny::fluidRow(
        shiny::column(
          width = 4,
          shiny::selectInput(ns("taxon_col"), "Taxon column", choices = NULL),
          shiny::selectInput(ns("response_col"), "Response trait", choices = NULL),
          shiny::selectInput(ns("predictor_col"), "Predictor trait", choices = NULL)
        ),
        shiny::column(
          width = 4,
          shiny::selectInput(
            ns("response_transform"),
            "Response transformation",
            choices = c(
              "None" = "none",
              "Natural log" = "log",
              "Log10" = "log10",
              "Log1p" = "log1p",
              "Square root" = "sqrt",
              "Exponential" = "exp",
              "Inverse" = "inverse",
              "Standardize" = "standardize"
            ),
            selected = "none"
          ),
          shiny::selectInput(
            ns("predictor_transform"),
            "Predictor transformation",
            choices = c(
              "None" = "none",
              "Natural log" = "log",
              "Log10" = "log10",
              "Log1p" = "log1p",
              "Square root" = "sqrt",
              "Exponential" = "exp",
              "Inverse" = "inverse",
              "Standardize" = "standardize"
            ),
            selected = "none"
          )
        ),
        shiny::column(
          width = 4,
          shiny::checkboxGroupInput(
            ns("methods"),
            "Analyses to run",
            choices = c(
              "Blomberg's K" = "blomberg_k",
              "Pagel's lambda" = "pagel_lambda",
              "PIC regression" = "pic",
              "PGLS: Brownian Motion" = "pgls_bm",
              "PGLS: Ornstein-Uhlenbeck" = "pgls_ou"
            ),
            selected = c(
              "blomberg_k",
              "pagel_lambda",
              "pic",
              "pgls_bm",
              "pgls_ou"
            )
          ),
          shiny::numericInput(
            ns("k_nsim"),
            "Blomberg's K randomization simulations",
            value = 999,
            min = 99,
            step = 100
          ),
          shiny::selectInput(
            ns("pgls_method"),
            "PGLS fitting method",
            choices = c("ML", "REML"),
            selected = "ML"
          ),
          shiny::numericInput(
            ns("ou_alpha"),
            "Initial OU alpha",
            value = 1,
            min = 0.0001,
            step = 0.1
          )
        )
      ),

      shiny::actionButton(
        ns("run_signal"),
        "Run module",
        class = "btn-primary"
      )
    ),

    shiny::br(),

    shiny::tabsetPanel(
      shiny::tabPanel(
        "Verbose results",
        shiny::verbatimTextOutput(ns("signal_report")),
        shiny::downloadButton(ns("download_report"), "Download report")
      ),
      shiny::tabPanel(
        "Plots",
        shiny::plotOutput(ns("signal_plot"), height = "650px"),
        shiny::plotOutput(ns("pic_plot"), height = "450px")
      ),
      shiny::tabPanel(
        "Live Code Mirror",
        shiny::verbatimTextOutput(ns("live_code"))
      )
    )
  )
}
