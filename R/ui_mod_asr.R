# Shared controls only; each card retains its own UI and namespaced input IDs.
ui_asr_mk_advanced <- function(ns,prefix) {
 id<-function(x)ns(paste0(prefix,'_',x))
 cond<-function(x,value)sprintf("input['%s'] == '%s'",id(x),value)
 shiny::tags$details(shiny::tags$summary('Advanced analysis controls'),
  shiny::selectInput(id('root'),'Root probabilities (pi)',c('Equal weights'='equal','Named custom weights'='custom')),
  shiny::conditionalPanel(cond('root','custom'),
   shiny::actionButton(id('root_fill'),'Fill equal root weights'),
   shiny::textAreaInput(id('root_weights'),'Root weights: state,weight',rows=5),
   shiny::p('One named row per allowed state; weights are normalized to sum to one.')),
  shiny::selectInput(id('rate_mode'),'Transition rates',c('Estimate rates'='estimate','Supply fixed Q'='fixed')),
  shiny::conditionalPanel(cond('rate_mode','fixed'),
   shiny::actionButton(id('q_fill'),'Fill Q template from constraints'),
   shiny::textAreaInput(id('fixed_Q'),'Fixed Q: named CSV matrix',rows=7),
   shiny::p('Rows are sources, columns are destinations. Include headers and negative row-sum diagonals. Turn off comparison.')),
  shiny::conditionalPanel(cond('rate_mode','estimate'),
   shiny::selectInput(id('start_mode'),'Optimization settings',c('Guane: three deterministic starts'='deterministic','Use backend defaults'='backend','Custom starting rates'='custom')),
   shiny::p('Backend defaults omit q.init, min.q, max.q, logscale and opt.method. Bounds and optimizer controls below apply only to Guane or custom starts.'),
   shiny::conditionalPanel(sprintf("input['%s'] != 'backend'",id('start_mode')),
    shiny::numericInput(id('min_rate'),'Lower rate bound (min.q)',1e-10,min=1e-15),
    shiny::numericInput(id('max_rate'),'Upper rate bound',100,min=1e-8),
    shiny::selectInput(id('optimizer'),'Optimizer (opt.method)',c('nlminb','optim')),
    shiny::checkboxInput(id('logscale'),'Optimize log rates (logscale)',TRUE)),
   shiny::conditionalPanel(cond('start_mode','custom'),
    shiny::textInput(id('q_init'),'Starting rates (q.init)','0.1'),
    shiny::p('Enter one rate or one per positive constraint index, in index order. Turn off comparison.'))),
  shiny::h5('Effective settings preview'),shiny::verbatimTextOutput(id('advanced_preview')))
}

ui_asr_graphics <- function(ns,prefix,continuous=FALSE) {
 id<-function(x)ns(paste0(prefix,'_',x))
 in_graph<-function(types)sprintf("[%s].includes(input['%s'])",paste(sprintf("'%s'",types),collapse=','),id('graph'))
 shiny::tagList(
  shiny::tags$details(shiny::tags$summary('Figure size and appearance'),
   shiny::numericInput(id('width'),'Figure width (inches)',10,min=4,max=20,step=.5),
   shiny::numericInput(id('height'),'Figure height (inches)',8,min=4,max=20,step=.5),
   shiny::numericInput(id('dpi'),'PNG resolution (dpi)',150,min=72,max=300,step=1),
   shiny::p('Figure proportions apply to the preview, PDF and R exports. DPI applies to PNG only.'),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies')),
    shiny::selectInput(id('layout'),'Tree layout',c('Phylogram'='phylogram','Fan'='fan')),
    shiny::p('Fan layouts are available for node trees. Colored histories and continuous maps use phylograms.')),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','map','history','density')),shiny::selectInput(id('direction'),'Direction',c('Left to right'='rightwards','Right to left'='leftwards'))),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','map','history','density','phenogram')),
    shiny::selectInput(id('font'),'Label font',c('Plain'=1,'Bold'=2,'Italic'=3,'Bold italic'=4)),
    shiny::numericInput(id('label_offset'),'Label offset (tree-height fraction)',.02,min=0,max=.5,step=.01),
    shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','map','history','density')),shiny::checkboxInput(id('underscore'),'Preserve underscores',TRUE))),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','map','history','density','phenogram','rates')),
    shiny::numericInput(id('edge_width'),'Line width',2,min=.1,max=10,step=.1)),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','phenogram')),shiny::selectInput(id('edge_type'),'Line type',c('Solid'=1,'Dashed'=2,'Dotted'=3,'Dot dash'=4,'Long dash'=5,'Two dash'=6))),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','map','history','density','rates','probabilities')),
    shiny::checkboxInput(id('legend'),'Show legend',TRUE),
    shiny::numericInput(id('legend_size'),'Legend text size',.7,min=.2,max=2,step=.1)),
   shiny::conditionalPanel(in_graph(c('tree','joint','frequencies','history','rates','probabilities')),shiny::numericInput(id('legend_columns'),'Legend columns (0 = automatic)',0,min=0,max=10,step=1)),
   shiny::conditionalPanel(in_graph(c('map','density')),shiny::numericInput(id('legend_fraction'),'Color-bar length (tree-height fraction)',.4,min=.05,max=1,step=.05)),
   shiny::conditionalPanel(in_graph(c('map','density')),shiny::numericInput(id('resolution'),'Color-map grid resolution',100,min=20,max=500,step=10)),
   shiny::conditionalPanel(in_graph(c('map','density','history')),shiny::checkboxInput(id('outline'),'Outline colored branches',FALSE))),
  shiny::tags$details(shiny::tags$summary('Custom colors'),
   if(continuous)shiny::textInput(id('gradient'),'Gradient colors (hex, separated by commas)','') else shiny::tagList(
    shiny::actionButton(id('colors_fill'),'Fill colors from palette'),
    shiny::textAreaInput(id('colors'),'State colors: state,#RRGGBB',rows=5)),
   shiny::p('Leave blank to use the selected palette. Custom colors are display settings only.')),
  if(!continuous)shiny::conditionalPanel(in_graph(c('tree','frequencies')),
   shiny::selectInput(id('node_style'),'Node display',c('Probability pies'='pies','Most-supported state'='best')),
   shiny::conditionalPanel(sprintf("input['%s'] == 'best'",id('node_style')),
    shiny::sliderInput(id('support'),'Minimum state support',min=0,max=1,value=.9,step=.05),
    shiny::p('A cross marks a tie or support below the threshold. Probabilities remain unchanged.'))),
  if(!continuous)shiny::conditionalPanel(in_graph('rates'),shiny::tags$details(shiny::tags$summary('Q diagram settings'),
   shiny::numericInput(id('q_digits'),'Rate significant digits',3,min=1,max=8,step=1),
   shiny::numericInput(id('q_threshold'),'Hide rates below',1e-12,min=0,max=1e8),
   shiny::checkboxInput(id('q_zeros'),'Show zero-rate arrows',FALSE),
   shiny::checkboxInput(id('q_text'),'Show rate text',TRUE),
   shiny::checkboxInput(id('q_width'),'Scale arrow widths by rates',FALSE),
   shiny::numericInput(id('q_max_width'),'Maximum arrow width',5,min=1,max=10,step=.5),
   shiny::numericInput(id('q_rotate'),'Diagram rotation (degrees)',0,min=-360,max=360,step=15),
   shiny::numericInput(id('q_spacer'),'Arrow spacing',.1,min=0,max=.4,step=.01),
   shiny::p('These controls change the diagram only; Q and model constraints are unchanged.'))),
  shiny::selectInput(id('focus_node'),'Inspect saved node',choices=c('No highlighted node'='')),
  if(!continuous)shiny::conditionalPanel(in_graph(c('density','transition')),
   shiny::selectInput(id('focus_state'),'Selected state',choices=NULL),
   shiny::conditionalPanel(in_graph('transition'),shiny::selectInput(id('transition_to'),'Destination state',choices=NULL)),
   shiny::p('Density colors show mean occupancy within each grid segment across saved histories, conditional on Q and the tree. This is a display projection, not a new binary analysis.')),
  shiny::actionButton(id('graphics_reset'),'Reset graph controls'),
  shiny::downloadButton(id('png'),'Download graph PNG'),
  shiny::downloadButton(id('view_rds'),'Download graph settings and result RDS'))
}

ui_asr_reconstruction <- function(ns,prefix) {
 id<-function(x)ns(paste0(prefix,"_",x))
 cond<-function(x,value)sprintf("input['%s'] == '%s'",id(x),value)
 shiny::tagList(
  shiny::selectInput(id('reconstruction'),'Reconstruction output',c('Global marginal probabilities'='marginal','Joint assignments and global marginals'='joint')),
  shiny::conditionalPanel(cond('reconstruction','joint'),shiny::numericInput(id('joint_tol'),'Joint tolerance (tol)',1e-12,min=1e-15),
   shiny::p('Joint assignments maximize the simultaneous ancestral configuration. Ties may occur; assignments are not probabilities.'))
 )
}

# Common Bayesian controls and displays for discrete and polymorphic Mk cards.
ui_asr_bayes_controls <- function(ns,prefix,show_index=TRUE) {
 shiny::conditionalPanel(sprintf("input['%s'] == 'Bayes'",ns(paste0(prefix,'_framework'))),
   shiny::numericInput(ns(paste0(prefix,'_bayes_nsim')),'Saved rate draws per chain',200,min=20,max=2000,step=1),
   shiny::numericInput(ns(paste0(prefix,'_bayes_burnin')),'Burn-in generations',1000,min=1,max=1000000,step=1),
   shiny::numericInput(ns(paste0(prefix,'_bayes_spacing')),'Save every N generations',50,min=1,max=10000,step=1),
   shiny::numericInput(ns(paste0(prefix,'_bayes_chains')),'Chains',2,min=1,max=4,step=1),
   shiny::numericInput(ns(paste0(prefix,'_bayes_seed')),'MCMC seed',999,min=0,max=2147483642,step=1),
   shiny::selectInput(ns(paste0(prefix,'_bayes_root')),'Root probabilities',c('Equal'='equal','Custom named weights'='custom')),
   shiny::conditionalPanel(sprintf("input['%s'] == 'custom'",ns(paste0(prefix,'_bayes_root'))),
    shiny::textAreaInput(ns(paste0(prefix,'_bayes_weights')),'Root weights: state,weight',value='',rows=4)),
   shiny::actionButton(ns(paste0(prefix,'_bayes_fill')),'Fill rate-prior table'),
   shiny::textAreaInput(ns(paste0(prefix,'_bayes_parameters')),'Gamma priors and proposals (CSV)',value='',rows=5,width='100%'),
   shiny::p('Columns: Parameter, Shape, Rate, ProposalVariance. Use q1, q2, etc. for the displayed constraint indices. Blank uses gamma shape 1, rate 1 and proposal variance 0.1 for every rate.'),
   shiny::checkboxInput(ns(paste0(prefix,'_bayes_empirical')),'Empirical prior means from these data',FALSE),
   shiny::p('Empirical mode replaces Shape with fitted rate times Rate. Otherwise priors are prespecified gamma distributions; Rate is the inverse-scale parameter. Chain starts are sampled from these priors.'),
   shiny::tags$details(shiny::tags$summary('Effective Bayesian controls'),shiny::verbatimTextOutput(ns(paste0(prefix,'_bayes_controls')))),
   if(show_index)shiny::div(style='overflow-x:auto',shiny::tableOutput(ns(paste0(prefix,'_bayes_index')))),
   shiny::p('One history is sampled per retained Q draw. Generations per chain equal burn-in plus saved draws times spacing. The backend does not return burn-in traces, acceptance counts or editable starting rates. Short runs are exploratory.'),
   shiny::p('Equal or named root weights are held fixed. The tree and observed tip states are fixed; rate uncertainty is integrated. No AIC or Bayesian model comparison is performed.'))
}
ui_asr_bayes_results <- function(ns,prefix) {
 shiny::conditionalPanel(sprintf("input['%s'] == 'Bayes'",ns(paste0(prefix,'_framework'))),
   shiny::p('Node pies average conditional marginal probabilities over posterior rate draws. The displayed Q is the posterior mean. History intervals integrate rate and history uncertainty on the fixed tree; MCSE accounts for serial dependence. Inspect rate and node diagnostics.'),
   shiny::downloadButton(ns(paste0(prefix,'_bayes_draws_csv')),'Download retained posterior CSV'),
   shiny::downloadButton(ns(paste0(prefix,'_bayes_settings_csv')),'Download effective rate priors CSV'))
}
ui_asr_bayes_diagnostics <- function(ns,prefix) {
 shiny::conditionalPanel(sprintf("input['%s'] == 'Bayes'",ns(paste0(prefix,'_framework'))),
   shiny::p('Diagnostics use retained rate draws: spectral ESS, classic split Rhat and MCSE, not rank-normalized Rhat or tail ESS. Passing thresholds is not proof of convergence. Constant sampled indicators do not establish zero uncertainty.'),
   shiny::div(class='guane-asr-figure',shiny::plotOutput(ns(paste0(prefix,'_bayes_trace')),height='auto')),
   shiny::downloadButton(ns(paste0(prefix,'_bayes_trace_pdf')),'Download graph PDF'),shiny::downloadButton(ns(paste0(prefix,'_bayes_trace_script')),'Download graph R code'),
   shiny::div(style='overflow-x:auto',shiny::tableOutput(ns(paste0(prefix,'_bayes_diagnostics')))),
   shiny::downloadButton(ns(paste0(prefix,'_bayes_diagnostics_csv')),'Download chain diagnostics CSV'),
   shiny::p('Node MCSE and ESS describe SampledFrequency; Probability averages conditional marginals over Q draws.'),
   shiny::div(style='overflow-x:auto',shiny::tableOutput(ns(paste0(prefix,'_bayes_node_diagnostics')))),
   shiny::downloadButton(ns(paste0(prefix,'_bayes_node_csv')),'Download posterior node diagnostics CSV'))
}
