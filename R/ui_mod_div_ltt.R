ui_mod_div_ltt <- function(id) {
 ns<-shiny::NS(id)
 ui_mod_analysis_base(id,'ltt','Lineage through time',
 controls=shiny::tagList(
  shiny::p('Uses the tree from Data; a trait table is not required.'),
  shiny::selectInput(ns('ltt_source'),'Tree source',c('Data tree'='data','Uploaded tree set'='upload')),
  shiny::conditionalPanel(sprintf("input['%s'] == 'upload'",ns('ltt_source')),
   shiny::fileInput(ns('ltt_files'),'Newick files (one or more trees)',multiple=TRUE,accept=c('.nwk','.tre','.tree','.newick')),
   shiny::p('Up to 25 trees; every tree must pass validation. Uploaded trees remain local to this card.')),
  shiny::checkboxInput(ns('ltt_stem'),'Include stem (root.edge)',FALSE),
  shiny::numericInput(ns('ltt_tol'),'Ultrametric tolerance',1e-6,min=1e-12,max=.001,step=1e-6),
  shiny::p('Non-ultrametric trees are not accepted in this workflow. No rooting, pruning, resolution or recalibration is automatic.'),
  shiny::p('Stem lengths are omitted unless explicitly included. Without a supplied stem, the curve begins at the crown root.'),
  shiny::actionButton(ns('run_ltt'),'Run LTT'),shiny::textOutput(ns('ltt_status'))),
 results=shiny::tagList(shiny::fluidRow(
  shiny::column(9,shiny::div(class='guane-asr-figure',shiny::plotOutput(ns('ltt_plot'),height='auto'))),
  shiny::column(3,shiny::h4('Graph controls'),
   shiny::selectInput(ns('ltt_direction'),'Time direction',c('Since origin'='forward','Before present'='backward')),
   shiny::checkboxInput(ns('ltt_log'),'Logarithmic lineage axis',FALSE),
   shiny::selectInput(ns('ltt_palette'),'Palette',c('Guane','Legacy','Grayscale')),
   shiny::numericInput(ns('ltt_line_width'),'Line width',2,min=.5,max=6,step=.5),
   shiny::selectInput(ns('ltt_line_type'),'Line type',c('Solid'='1','Dashed'='2','Dotted'='3','Dotdash'='4','Longdash'='5','Twodash'='6')),
   shiny::checkboxInput(ns('ltt_legend'),'Show legend',TRUE),
   shiny::numericInput(ns('ltt_width'),'Width (inches)',10,min=4,max=30),
   shiny::numericInput(ns('ltt_height'),'Height (inches)',7,min=3,max=30),
   shiny::numericInput(ns('ltt_dpi'),'PNG resolution (dpi)',150,min=72,max=600),
   shiny::downloadButton(ns('ltt_pdf'),'Download graph PDF'),shiny::downloadButton(ns('ltt_png'),'Download graph PNG'),shiny::downloadButton(ns('ltt_script'),'Download graph R code'))),
  shiny::p('Overlays are individual curves, not confidence bands. Compare trees only when branch-length units and sampling are compatible.'),
  shiny::tableOutput(ns('ltt_summary')),shiny::downloadButton(ns('ltt_csv'),'Export LTT table'),shiny::downloadButton(ns('ltt_rds'),'Download graph settings and result RDS'),
  shiny::tags$details(shiny::tags$summary('LTT coordinates (first 100 rows)'),shiny::tableOutput(ns('ltt_table')))),
 diagnostics=shiny::tagList(shiny::verbatimTextOutput(ns('ltt_diagnostics')),shiny::p('Describes branching through time. Incomplete sampling can bias this pattern; this is not an estimate of speciation or extinction rates.')),
 mirror=shiny::verbatimTextOutput(ns('ltt_code')))
}
