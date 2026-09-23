ui_mod_signal_PGLS <- function(id) {
 ns<-shiny::NS(id)
 ui_mod_analysis_base(id,'PGLS','PGLS',
 controls=shiny::tagList(
  shiny::selectInput(ns('pgls_response'),'Response',choices=NULL),
  shiny::selectInput(ns('pgls_predictors'),'Predictors',choices=NULL,multiple=TRUE),
  shiny::selectInput(ns('pgls_model'),'Correlation structure',c('BM','Grafen','Pagel','Blomberg')),
  shiny::tagList(
   shiny::numericInput(ns('pgls_value'),'Initial or fixed parameter (rho / lambda / g)',.5,min=0,step=.1),
   shiny::checkboxInput(ns('pgls_fixed'),'Keep correlation parameter fixed',FALSE)),
  shiny::selectInput(ns('pgls_method'),'Estimation method',c('REML','ML')),
  shiny::p('Uses prepared species data. Do not supply PIC values. This version requires an ultrametric tree.'),
  shiny::p('Grafen replaces branch lengths using topology; the uploaded tree remains unchanged.'),
  shiny::actionButton(ns('pgls_run'),'Run PGLS'),shiny::textOutput(ns('pgls_status')),
  shiny::actionButton(ns('pgls_compare_run'),'Compare covariance models (ML)'),
  shiny::p('Comparison uses the same data and predictors for all four structures, with ML and the current fixed or initial parameter setting.')),
 results=shiny::tagList(
  shiny::fluidRow(shiny::column(9,shiny::plotOutput(ns('pgls_plot'),height='460px')),
   shiny::column(3,shiny::h4('Graph controls'),
    shiny::selectInput(ns('pgls_plot_type'),'Graph',c('Observed versus fitted'='fit','Coefficient intervals'='coefficients','Residual diagnostics'='diagnostics')),
    shiny::selectInput(ns('pgls_color'),'Plot color',c('Guane green'='#34765b','Legacy cyan'='#02b2ce','Grayscale'='#333333')),
    shiny::checkboxInput(ns('pgls_labels'),'Show taxon labels',FALSE),
    shiny::downloadButton(ns('pgls_pdf'),'Download graph PDF'),shiny::downloadButton(ns('pgls_script'),'Download graph R code'))),
  shiny::textOutput(ns('pgls_metadata')),shiny::tableOutput(ns('pgls_coefficients')),
  shiny::p('Intervals are 95% t intervals conditional on the fitted covariance. The dashed diagonal represents perfect agreement, not a regression line.'),
  shiny::p('Each coefficient describes the response change per predictor unit, holding other predictors constant. Association does not establish causation.'),
  shiny::downloadButton(ns('pgls_csv'),'Download coefficients CSV'),
  shiny::h4('Covariance model comparison'),shiny::plotOutput(ns('pgls_comparison_plot'),height='320px'),shiny::tableOutput(ns('pgls_comparison')),
  shiny::p('AIC weights describe relative support within the successful candidate set, not probabilities that models are true. Failed models remain listed. No likelihood-ratio tests or model averaging are performed.'),
  shiny::downloadButton(ns('pgls_comparison_csv'),'Download comparison CSV'),shiny::downloadButton(ns('pgls_comparison_pdf'),'Download comparison PDF'),shiny::downloadButton(ns('pgls_comparison_script'),'Download comparison R code')),
 diagnostics=shiny::tagList(shiny::plotOutput(ns('pgls_diagnostics'),height='400px'),
  shiny::p('Inspect normalized residuals for patterns and Q-Q departures. Trait normality is not residual normality.'),
  shiny::textOutput(ns('pgls_warnings')),shiny::verbatimTextOutput(ns('pgls_details'))),
 mirror=shiny::tagList(shiny::p('The graph R script embeds prepared inputs, refits the model and draws the selected graph. Edit it in RStudio without Guane.'),shiny::verbatimTextOutput(ns('pgls_code')),shiny::verbatimTextOutput(ns('pgls_comparison_code'))))
}
