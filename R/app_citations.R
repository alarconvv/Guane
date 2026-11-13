# Main analytical and plotting packages; infrastructure dependencies are not engines.
guane_citation_packages <- function(key, result) {
 packages <- switch(key,
  signal=c('ape','phytools'), PGLS=c('ape','nlme'), PagelReg=c('ape','phytools'),
  PGLM=c('ape',if(identical(result$method,'binomial_GEE')) 'gee' else 'phylolm'),
  continuous=c('ape','phytools'), discrete=c('ape','phytools'), poly=c('ape','phytools'),
  ltt='ape', rates=c('ape','diversitree'), time=c('ape','diversitree'),
  clades=c('ape','diversitree'), joint=c('ape','diversitree'), diversity=c('ape','DDD'),
  bisse=c('ape','diversitree'), musse=c('ape','diversitree'),
  quasse=c('ape','diversitree'), hidden=c('ape','hisse','nloptr'))
 if(key=='time' && !is.null(result$uncertainty$bootstrap)) packages<-c(packages,'deSolve')
 if(is.null(packages)) stop('Unknown analysis citation key: ',key)
 if(key %in% c('continuous','discrete','poly') && !is.null(result$bayes)) packages<-c(packages,'coda')
 packages
}

guane_analysis_citation <- function(key, result, lang='en') {
 titles <- c(signal='phylogenetic signal analysis',PGLS='PGLS',PagelReg="Pagel's correlation",PGLM='PGLM',
  continuous='ancestral reconstruction of continuous traits',discrete='ancestral reconstruction of discrete traits',poly='ancestral reconstruction of polymorphic traits',
  ltt='lineage-through-time analysis',rates='constant-rate diversification analysis',time='time-varying diversification analysis',
  clades='clade-specific diversification analysis',joint='joint clade-dependent diversification analysis',diversity='diversity-dependent diversification analysis',
  bisse='BiSSE',musse='MuSSE',quasse='QuaSSE',hidden='hidden-state and null-model diversification analysis')
 packages <- guane_citation_packages(key,result)
 txt <- function(x) guane_text(x,lang)
 sentence <- sprintf(txt('We performed %s in Guane, using the following R packages for analysis and visualization: %s.'),
  txt(titles[[key]]),paste(packages,collapse=', '))
 note <- if(key=='continuous' && identical(result$engine,'Gaussian ML'))
  txt('Model fitting used the Guane Gaussian ML implementation; phytools supported visualization.') else character()
 versions <- paste(vapply(c('guane',packages),function(p) paste(p,utils::packageVersion(p)),character(1)),collapse='; ')
 references <- c(paste0('Guane ',utils::packageVersion('guane'),' (R package). https://github.com/alarconvv/Guane'),
  unlist(lapply(packages,function(p) paste(format(utils::citation(p),style='text'),collapse='\n')),use.names=FALSE))
 list(sentence=sentence,note=note,versions=versions,references=references,
  commands=paste0('citation("',packages,'")'))
}

# Only comments are added: replaying an export never needs the citation helpers.
guane_citation_comments <- function(key, result, lang='en') {
 x <- guane_analysis_citation(key,result,lang)
 lines <- c(guane_text('How to cite this analysis',lang),x$sentence,x$note,
  guane_text('Cite Guane and the packages below; adapt this wording to describe your model and settings.',lang),
  x$versions,x$references,x$commands,'')
 paste0('# ',unlist(strsplit(lines,'\n',fixed=TRUE),use.names=FALSE))
}

guane_citation_ui <- function(key, result, lang='en') {
 x <- guane_analysis_citation(key,result,lang)
 txt <- function(s) guane_text(s,lang)
 shiny::tags$details(class='guane-citation',
  shiny::tags$summary(txt('How to cite this analysis')),
  shiny::p(txt('Cite Guane and the packages below; adapt this wording to describe your model and settings.')),
  shiny::p(class='guane-citation-sentence',x$sentence),
  if(length(x$note)) shiny::p(x$note),
  shiny::p(class='muted',x$versions),
  shiny::tags$ul(lapply(x$references,shiny::tags$li)),
  shiny::tags$pre(shiny::tags$code(paste(x$commands,collapse='\n'))))
}
