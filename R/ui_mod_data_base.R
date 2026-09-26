ui_mod_data_base <- function(id) {
 ns <- shiny::NS(id)
 settings <- bslib::card(bslib::card_header('Setting up'),
   fileInput(ns('tree_file'),'Load single tree',accept=c('.tre','.nwk','.nex','.nexus')),
   fileInput(ns('traits_file'),'Load traits \u00b7 CSV',accept='.csv'),
   actionButton(ns('example'),'Load example data'),
   helpText('Synthetic example: 20 tree tips and 19 trait rows. Sp20 is intentionally absent from the table.'),
   selectInput(ns('taxon'),'Taxon column',character()),selectInput(ns('trait'),'Numeric trait',character()),
   numericInput(ns('seed'),'Seed',999,min=0,max=2147483647),
   actionButton(ns('match'),'Use matched taxa'),
   helpText('Review mismatches before pruning. Changes are recorded in Diagnosis log.'),
   actionButton(ns('reset'),'Reset controls'),actionButton(ns('undo_data'),'Undo data change'),actionButton(ns('restore_data'),'Restore original inputs'))
 graphics <- bslib::card(bslib::card_header('Graphic controls'),
   selectInput(ns('layout'),'Tree layout',c('Phylogram'='phylogram','Cladogram'='cladogram','Fan'='fan')),
   selectInput(ns('direction'),'Direction',c('Left to right'='rightwards','Right to left'='leftwards','Top to bottom'='downwards')),
   checkboxInput(ns('lengths'),'Use branch lengths',TRUE),checkboxInput(ns('labels'),'Show tip labels',TRUE),checkboxInput(ns('nodes'),'Show node numbers',FALSE),
   sliderInput(ns('font'),'Label size',.5,1.8,1,step=.1),sliderInput(ns('edge'),'Edge width',1,5,2),downloadButton(ns('plot_download'),'Export tree \u00b7 PDF'),downloadButton(ns('tree_script'),'Download graph R code'))
 preview <- bslib::navset_tab(id=ns('view'),
   bslib::nav_panel('Tree preview',value='tree',plotOutput(ns('tree_plot'),height='420px')),
   bslib::nav_panel('Trait preview',value='traits',tableOutput(ns('traits_table'))),
   bslib::nav_panel('Checking data',value='checks',div(class='guane-check-panels',div(uiOutput(ns('diagnostics')),
      p('Normality of a trait does not establish normality of regression residuals. Inspect model diagnostics after fitting.'),
      helpText('Contrasts are node-level data, separate from the species table. Contrast regression must be fitted through the origin.'),verbatimTextOutput(ns('checks'))),div(h4('Data distribution'),plotOutput(ns('distribution'),height='360px'),textOutput(ns('distribution_note'))))),
   bslib::nav_panel('Diagnosis log',value='log',tableOutput(ns('history'))))
 data <- bslib::nav_panel('Data',value='data',
   div(class='guane-data-grid',
     div(settings,
       conditionalPanel(sprintf("input['%s'] == 'log'",ns('view')),
         bslib::card(bslib::card_header('Diagnosis log'),downloadButton(ns('log_download'),'Export diagnosis log'),downloadButton(ns('preparation_script'),'Export preparation script')))),
     div(bslib::card(preview),div(class='guane-data-bottom',
       bslib::card(bslib::card_header('Description / Messages'),textOutput(ns('activity'))),
       bslib::card(bslib::card_header('Structure'),uiOutput(ns('structure'))))),
     div(       conditionalPanel(sprintf("input['%s'] == 'checks'",ns('view')),
         bslib::card(bslib::card_header('Checking data'),
      actionButton(ns('normality'),'Shapiro\u2013Wilk normality test'),
      selectInput(ns('transformation'),'Transformation',c('Natural log'='log','Exponential'='exp','Quadratic'='quadratic','Reciprocal'='reciprocal')),
      actionButton(ns('transform'),'Create transformed column'),actionButton(ns('pic'),'Compute independent contrasts \u00b7 ape'),tags$hr(),selectInput(ns('dist_column'),'Column to display',character()),selectInput(ns('dist_type'),'Distribution plot',c('Histogram'='hist','Density'='density','Normal Q\u2013Q'='qq')),sliderInput(ns('dist_bins'),'Histogram bins',5,50,15),checkboxInput(ns('dist_rug'),'Show individual observations',TRUE),downloadButton(ns('dist_export'),'Export distribution \u00b7 PDF'),downloadButton(ns('distribution_script'),'Download graph R code'))),
conditionalPanel(sprintf("input['%s'] == 'tree'",ns('view')),graphics),
       conditionalPanel(sprintf("input['%s'] == 'traits'",ns('view')),
         bslib::card(bslib::card_header('Table controls'),numericInput(ns('rows'),'Preview rows',25,min=1,max=1000),downloadButton(ns('traits_download'),'Export traits'))))))
  data
}
