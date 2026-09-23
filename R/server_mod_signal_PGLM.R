server_mod_signal_PGLM <- function(input,output,session,data) {
 influence<-shiny::reactiveVal(NULL)
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Choose a response family, response and predictors.')
 grouped<-shiny::reactive(identical(input$pglm_family,'grouped'))
 trials<-shiny::reactive(if(grouped()) input$pglm_trials else NULL)
 count<-shiny::reactive(identical(input$pglm_family,'count'))
 method<-shiny::reactive(if(grouped()) 'binomial_GEE' else if(count()) 'poisson_GEE' else if(is.null(input$pglm_method)) 'logistic_MPLE' else input$pglm_method)
 event<-shiny::reactive(if(count() || grouped()) NULL else input$pglm_event)
 shiny::observeEvent(list(data$state$traits,data$taxon(),count(),grouped()),{
  t<-data$state$traits;cols<-setdiff(names(t),data$taxon())
  eligible<-cols[vapply(t[cols],function(x) if(count() || grouped()) is.numeric(x) && all(is.finite(x)) && all(x>=0 & x==floor(x)) && (grouped() || length(unique(x))>1) else !anyNA(x) && length(unique(as.character(x)))==2,logical(1))]
  shiny::updateSelectInput(session,'pglm_response',choices=eligible,selected=if(length(input$pglm_response)==1 && input$pglm_response %in% eligible) input$pglm_response else head(eligible,1))
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(data$state$traits,data$taxon(),input$pglm_response,grouped()),{
  t<-data$state$traits;cols<-setdiff(names(t),c(data$taxon(),input$pglm_response))
  cols<-cols[vapply(t[cols],function(x) is.numeric(x) && all(is.finite(x)) && all(x>0 & x==floor(x)),logical(1))]
  shiny::updateSelectInput(session,'pglm_trials',choices=cols,selected=if(length(input$pglm_trials)==1 && input$pglm_trials %in% cols) input$pglm_trials else head(cols,1))
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(data$state$traits,data$taxon(),input$pglm_response,trials()),{
  t<-data$state$traits;cols<-setdiff(names(t),c(data$taxon(),input$pglm_response,trials()))
  numeric<-cols[vapply(t[cols],function(x) is.atomic(x) || is.factor(x),logical(1))]
  shiny::updateSelectInput(session,'pglm_predictors',choices=numeric,selected=intersect(input$pglm_predictors,numeric))
 },ignoreNULL=FALSE)
 categorical<-shiny::reactive(intersect(input$pglm_categorical,input$pglm_predictors))
 shiny::observeEvent(input$pglm_predictors,{
  shiny::updateSelectInput(session,'pglm_categorical',choices=input$pglm_predictors,selected=intersect(input$pglm_categorical,input$pglm_predictors))
 },ignoreNULL=FALSE)
 references<-shiny::reactive({
  cats<-categorical()
  stats::setNames(lapply(cats,function(name) input[[paste0('pglm_ref_',match(name,names(data$state$traits)))]]),cats)
 })
 output$pglm_references<-shiny::renderUI({
  cats<-categorical();t<-data$state$traits
  shiny::tagList(lapply(cats,function(name) {
   id<-paste0('pglm_ref_',match(name,names(t)));states<-sort(unique(as.character(t[[name]])),method='radix')
   old<-shiny::isolate(input[[id]])
   shiny::selectInput(session$ns(id),shiny::tagList(shiny::span('Reference category'),': ',shiny::tags$strong(name)),states,selected=if(length(old)==1 && old %in% states) old else head(states,1))
  }))
 })
 output$pglm_coding<-shiny::renderTable({shiny::req(result(),nrow(result()$coding)>0);tab<-result()$coding;names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab})
 shiny::observeEvent(list(data$state$traits,input$pglm_response),{
  states<-if(length(input$pglm_response)==1 && input$pglm_response %in% names(data$state$traits)) sort(unique(as.character(data$state$traits[[input$pglm_response]])),method='radix') else character()
  shiny::updateSelectInput(session,'pglm_event',choices=states,selected=if(length(input$pglm_event)==1 && input$pglm_event %in% states) input$pglm_event else tail(states,1))
 },ignoreNULL=TRUE)
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),input$pglm_response,event(),input$pglm_predictors,method(),count(),grouped(),trials(),categorical(),references()),{
  result(NULL);status('Inputs changed. Run PGLM to update results.')
 },ignoreInit=TRUE)
 shiny::observeEvent(input$pglm_run,{
  result(NULL)
  tryCatch({
   fit<-guane_pglm(data$state$tree,data$state$traits,data$taxon(),input$pglm_response,input$pglm_predictors,event(),method(),trials(),categorical(),references())
   result(fit);status('PGLM completed. Review diagnostics and fitting warnings.');data$record('PGLM completed.')
   for(w in fit$warnings) data$record(paste('PGLM:',w))
  },error=function(e){status(conditionMessage(e));data$record(paste('PGLM:',conditionMessage(e)))})
 })
 shiny::observeEvent(result(),{influence(NULL)},ignoreNULL=FALSE)
 shiny::observeEvent(input$pglm_influence_run,{
  shiny::req(result());influence(NULL)
  shiny::withProgress(message='Diagnostic refits',value=0,{
   influence(guane_pglm_influence(result()))
  })
  data$record('PGLM leave-one-taxon-out diagnostics completed; prepared data unchanged.')
 })
 output$pglm_taxa_screen<-shiny::renderTable({shiny::req(result());tab<-guane_pglm_screen(result())$taxa;names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab},digits=4)
 output$pglm_category_screen<-shiny::renderTable({shiny::req(result());tab<-guane_pglm_screen(result())$categories;shiny::req(nrow(tab)>0);names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab})
 output$pglm_influence_table<-shiny::renderTable({shiny::req(influence());tab<-influence()$table;names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab},digits=4)
 output$pglm_influence_plot<-shiny::renderPlot({shiny::req(influence());guane_pglm_influence_plot(influence(),color(),data$lang())},res=110)
 output$pglm_influence_csv<-shiny::downloadHandler('guane-pglm-influence.csv',function(file){shiny::req(influence());utils::write.csv(influence()$table,file,row.names=FALSE)})
 output$pglm_influence_script<-shiny::downloadHandler('guane-pglm-influence.R',function(file){shiny::req(influence());writeLines(guane_pglm_influence_script(influence(),color(),data$lang()),file)})
 output$pglm_influence_pdf<-shiny::downloadHandler('guane-pglm-influence.pdf',function(file){shiny::req(influence());grDevices::pdf(file,width=9,height=6);on.exit(grDevices::dev.off());guane_pglm_influence_plot(influence(),color(),data$lang())})
 output$pglm_influence_code<-shiny::renderText({shiny::req(influence());paste(guane_pglm_influence_script(influence(),color(),data$lang()),collapse='\n')})
 output$pglm_status<-shiny::renderText(status())
 type<-shiny::reactive(if(is.null(input$pglm_graph)) 'fit' else input$pglm_graph)
 color<-shiny::reactive(if(is.null(input$pglm_color)) '#34765b' else input$pglm_color)
 draw<-function(kind=type()) guane_pglm_plot(result(),kind,color(),isTRUE(input$pglm_labels),data$lang())
 output$pglm_plot<-shiny::renderPlot({shiny::validate(shiny::need(!is.null(result()),'Run PGLM on matched data to display results.'));draw()},res=110)
 output$pglm_diagnostics<-shiny::renderPlot({shiny::req(result());draw('diagnostics')},res=110)
 output$pglm_coefficients<-shiny::renderTable({shiny::req(result());tab<-result()$coefficients;tab$P<-format.pval(tab$P,digits=4,eps=1e-6);names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab},digits=5)
 output$pglm_guidance<-shiny::renderUI({
  if(grouped()) shiny::tagList(shiny::p('Select successes and total trials per species. Trials must be positive integers; successes may range from zero to trials.'),shiny::p('Grouped-binomial GEE uses a logit link and a fixed tree-derived working correlation. No trial expansion or proportion rounding is performed.')) else if(count()) shiny::tagList(shiny::p('Poisson GEE with log link and multiple numeric or categorical predictors. Select a nonnegative integer count column.'),shiny::p('Counts require comparable observation effort. Exposure offsets, zero-inflation and negative-binomial models are not supported.')) else shiny::p('Bernoulli response with logit link; multiple numeric or categorical predictors.')
 })
 output$pglm_interpretation<-shiny::renderUI({
  if(grouped()) shiny::tagList(shiny::p('Coefficients describe log-odds changes holding other predictors constant. Intervals use model-based covariance with binomial scale fixed at one.'),shiny::p('One phylogeny is one correlated cluster. Robust sandwich intervals, likelihood and AIC are not reported. Extra-binomial variation is not fitted.')) else if(count()) shiny::tagList(shiny::p('Coefficients describe log mean-count changes holding other predictors constant; exp(coefficient) is the expected count ratio per predictor unit.'),shiny::p('GEE intervals use scale-adjusted model-based standard errors, not robust sandwich or bootstrap errors. Phylogenetic correlation is fixed by the tree. Likelihood and AIC are not available.')) else shiny::p('Coefficients describe log-odds changes holding other predictors constant. Intervals and standard errors are conditional on estimated alpha.')
 })
 output$pglm_diagnostic_help<-shiny::renderUI({
  if(grouped()) shiny::tagList(shiny::p('Pearson residuals compare observed successes with trials times fitted probability, using binomial variance. Dispersion is descriptive and does not rescale the fitted intervals.')) else if(count()) shiny::tagList(shiny::p('Pearson residuals use (observed - fitted) / sqrt(fitted), without dispersion scaling. Patterns may reveal misspecification; residual normality is not assumed.'),shiny::p('Dispersion is the sum of squared Pearson residuals divided by residual degrees of freedom. Values above one indicate extra variation relative to the Poisson working variance; this is descriptive, not a calibrated test.')) else shiny::p('Binary residuals are not normally distributed. This plot checks patterns; it is not a normality test or a calibrated goodness-of-fit test.')
 })
 output$pglm_count_diagnostics<-shiny::renderTable({
  shiny::req(result(),result()$method %in% c('poisson_GEE','binomial_GEE'));r<-result()
  if(r$method=='binomial_GEE') {
   tab<-data.frame(Metric=vapply(c('Taxa','Total trials','Total successes','Residual degrees of freedom','Pearson dispersion (descriptive)','Convergence code'),guane_text,character(1),lang=data$lang()),Value=c(nrow(r$points),sum(r$points$Trials),sum(r$points$Successes),r$fit$n-r$fit$d,sum(r$points$Pearson^2)/(r$fit$n-r$fit$d),r$fit$convergence))
   names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());return(tab)
  }
  tab<-data.frame(Metric=vapply(c('Taxa','Observed zeros','Residual degrees of freedom','Dispersion','Convergence code'),guane_text,character(1),lang=data$lang()),Value=c(nrow(r$points),sum(r$points$Observed==0),r$fit$n-r$fit$d,r$fit$scale,r$fit$convergence))
  names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab
 },digits=4)
 output$pglm_metadata<-shiny::renderText({shiny::req(result());r<-result();paste(paste(r$response,'~',paste(r$predictors,collapse=' + ')),
  if(r$method=='binomial_GEE') paste('Binomial / logit | binomial_GEE | n =',nrow(r$points),'|',r$trials,'| scale = 1') else if(r$method=='poisson_GEE') paste('Poisson / log | poisson_GEE | n =',nrow(r$points),'|',guane_text('Dispersion',data$lang()),'=',signif(r$fit$scale,5)) else paste(paste('1 =',r$event,'; 0 =',r$reference),paste('Bernoulli / logit |',r$method,'| n =',nrow(r$points),'| alpha =',signif(r$fit$alpha,5)),sep='\n'),sep='\n')})
 output$pglm_warnings<-shiny::renderText({shiny::req(result());if(length(result()$warnings)) paste(result()$warnings,collapse='\n') else 'No fitting warnings reported. Inspect diagnostics before interpretation.'})
 output$pglm_details<-shiny::renderPrint({shiny::req(result());if(result()$method %in% c('binomial_GEE','poisson_GEE')) list(method=result()$method,coefficients=result()$coefficients,scale=result()$fit$scale,convergence=result()$fit$convergence,iterations=result()$fit$iterations) else summary(result()$fit)})
 code<-shiny::reactive({shiny::req(result());guane_pglm_script(result(),type(),color(),isTRUE(input$pglm_labels),data$lang())})
 output$pglm_code<-shiny::renderText({if(is.null(result())) return('Run PGLM on matched data to display results.');paste(code(),collapse='\n')})
 output$pglm_script<-shiny::downloadHandler('guane-pglm.R',function(file) writeLines(code(),file))
 output$pglm_pdf<-shiny::downloadHandler('guane-pglm.pdf',function(file){shiny::req(result());grDevices::pdf(file,width=9,height=6);on.exit(grDevices::dev.off());draw()})
 output$pglm_csv<-shiny::downloadHandler('guane-pglm-coefficients.csv',function(file){shiny::req(result());utils::write.csv(result()$coefficients,file,row.names=FALSE)})
 output$pglm_predictions<-shiny::downloadHandler('guane-pglm-fitted-values.csv',function(file){shiny::req(result());utils::write.csv(result()$points,file,row.names=FALSE)})
 list(result=result,code=code,influence=influence)
}
