server_mod_asr_continuous <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Choose a numeric trait and run continuous reconstruction.')
 shiny::observeEvent(list(data$state$traits,data$taxon()),{
  t<-data$state$traits;cols<-setdiff(names(t)[vapply(t,is.numeric,logical(1))],data$taxon())
  shiny::updateSelectInput(session,'bm_trait',choices=cols,selected=if(length(input$bm_trait)==1 && input$bm_trait %in% cols) input$bm_trait else head(cols,1))
 },ignoreNULL=FALSE)
 number<-function(z)if(is.null(z) || !nzchar(trimws(z)))NULL else suppressWarnings(as.numeric(z))
 options<-shiny::reactive({
  if(identical(input$bm_framework,'Bayes')) {
   value<-function(name,default)if(is.null(input[[name]]))default else input[[name]]
   return(list(ngen=value('bm_ngen',50000),sample=value('bm_sample',100),burnin=value('bm_burnin',10000),chains=value('bm_chains',2),seed=value('bm_seed',999),spread=value('bm_spread',2),parameters=if(is.null(input$bm_parameters) || !nzchar(trimws(input$bm_parameters)))NULL else input$bm_parameters))
  }
  model<-if(is.null(input$bm_model))'BM' else input$bm_model
  engine<-if(model!='BM')'anc.ML' else if(is.null(input$bm_engine))'fastAnc' else input$bm_engine
  if(isTRUE(input$bm_marginal)) {
   lower<-number(input$bm_shape_lower);upper<-number(input$bm_shape_upper)
   bounds<-if(is.null(lower) && is.null(upper))NULL else c(if(is.null(lower))NA_real_ else lower,if(is.null(upper))NA_real_ else upper)
   return(list(model=model,engine='Gaussian ML',maxit=if(is.null(input$bm_maxit))2000 else input$bm_maxit,trace=isTRUE(input$bm_trace),intervals=if(is.null(input$bm_intervals))TRUE else isTRUE(input$bm_intervals),start=if(model=='BM')NULL else number(input$bm_start),se_column=if(is.null(input$bm_se) || !nzchar(input$bm_se))NULL else input$bm_se,shape_bounds=if(model=='BM')NULL else bounds,compare=isTRUE(input$bm_compare)))
  }
  if(engine=='fastAnc')return(list(model=model,engine=engine))
  list(model=model,engine=engine,maxit=if(is.null(input$bm_maxit))2000 else input$bm_maxit,tol=number(input$bm_tol),trace=isTRUE(input$bm_trace),intervals=if(model=='OU')FALSE else if(is.null(input$bm_intervals))TRUE else isTRUE(input$bm_intervals),start=if(model=='BM')NULL else number(input$bm_start))
 })
 shiny::observeEvent(list(data$state$traits,data$taxon(),input$bm_trait),{
  t<-data$state$traits;cols<-setdiff(names(t)[vapply(t,is.numeric,logical(1))],c(data$taxon(),input$bm_trait))
  shiny::updateSelectInput(session,'bm_se',choices=c('None (zero error)'='',stats::setNames(cols,cols)),selected=if(!is.null(input$bm_se) && input$bm_se%in%cols)input$bm_se else '')
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),input$bm_trait,input$bm_framework,options()),{
  bm_task$discard();result(NULL);status('Inputs changed. Run continuous reconstruction to update results.')
 },ignoreInit=TRUE)
 bm_fail<-function(msg){status(msg);data$record(paste('Continuous:',msg))}
 bm_task<-guane_task(function(r){result(r);status('Continuous reconstruction completed. Review uncertainty and diagnostics.');data$record(paste('Continuous reconstruction:',r$model,r$engine))},bm_fail,status)
 shiny::observeEvent(input$bm_run,{
  result(NULL)
  tryCatch({
   if(!input$bm_framework%in%c('ML','Bayes')) stop('This framework is planned. Choose maximum likelihood.')
   bm_task$run(if(identical(input$bm_framework,'Bayes'))guane_asr_bayes else guane_asr_continuous,c(list(tree=data$state$tree,traits=data$state$traits,taxon=data$taxon(),trait=input$bm_trait),options()))
  },error=function(e)bm_fail(conditionMessage(e)))
 })
 shiny::observeEvent(input$bm_fill_parameters,{
  tryCatch({t<-guane_bayes_parameters(data$state$tree,data$state$traits,data$taxon(),input$bm_trait);shiny::updateTextAreaInput(session,'bm_parameters',value=paste(capture.output(utils::write.csv(t,row.names=FALSE)),collapse='\n'))},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(input$bm_framework,result()),{
  is_bayes<-identical(input$bm_framework,'Bayes')
  choices<-c('Trait map'='map','Phenogram'='phenogram','Node intervals'='intervals','Selected node'='node','Model diagnostics'='diagnostics')
  choices<-c(choices,if(is_bayes)c('MCMC trace'='trace','Posterior density'='posterior_density') else c('Marginal model comparison'='comparison'))
  shiny::updateSelectInput(session,'bm_graph',choices=choices,selected=if(!is.null(input$bm_graph) && input$bm_graph%in%choices)input$bm_graph else 'map')
  if(!is.null(result()$bayes))shiny::updateSelectInput(session,'bm_parameter',choices=c('sig2',as.character(result()$nodes$Node),'logLik'),selected=if(!is.null(input$bm_parameter) && input$bm_parameter%in%c('sig2',as.character(result()$nodes$Node),'logLik'))input$bm_parameter else 'sig2')
 },ignoreNULL=FALSE)
 output$bm_bayes_preview<-shiny::renderText({shiny::req(identical(input$bm_framework,'Bayes'));if(!is.null(result()$bayes))return(paste(capture.output(str(result()$bayes[c('controls','seeds','ngen','sample','burnin','chains')])),collapse='\n'));tryCatch(paste(capture.output(str(guane_bayes_controls(data$state$tree,data$state$traits,data$taxon(),input$bm_trait,options()$parameters,options()$sample))),collapse='\n'),error=function(e)guane_text(conditionMessage(e),data$lang()))})
 output$bm_chain_diagnostics<-shiny::renderTable({shiny::req(result()$bayes);d<-result()$bayes$diagnostics;names(d)<-vapply(names(d),guane_text,character(1),lang=data$lang());d},digits=5)
 output$bm_draws_csv<-shiny::downloadHandler('guane-bm-posterior.csv',function(file){shiny::req(result()$bayes);guane_write_csv(result()$bayes$draws,file,row.names=FALSE)})
 output$bm_chains_rds<-shiny::downloadHandler('guane-bm-chains.rds',function(file){shiny::req(result()$bayes);saveRDS(result(),file)})
 output$bm_chain_csv<-shiny::downloadHandler('guane-bm-chain-diagnostics.csv',function(file){shiny::req(result()$bayes);guane_write_csv(result()$bayes$diagnostics,file,row.names=FALSE)})
 output$bm_status<-shiny::renderText(guane_text(status(),data$lang()))
 appearance<-server_asr_graphics(input,output,session,'bm',result,data$lang)
 settings<-shiny::reactive(list(type=if(is.null(input$bm_graph)) 'map' else input$bm_graph,palette=if(is.null(input$bm_palette)) 'Guane' else input$bm_palette,labels=isTRUE(input$bm_labels),node_labels=isTRUE(input$bm_nodes),lang=data$lang(),label_size=if(is.null(input$bm_label_size)).7 else input$bm_label_size,appearance=appearance(),parameter=if(is.null(input$bm_parameter))'sig2' else input$bm_parameter))
 draw<-function(diagnostic=FALSE){s<-settings();if(diagnostic)s$type<-'diagnostics';do.call(guane_asr_bm_plot,c(list(result=result()),s))}
 output$bm_plot<-shiny::renderPlot({server_asr_plot(function(){shiny::req(result());draw()},data$lang())},width=function()appearance()$width*96,height=function()appearance()$height*96,res=96)
 output$bm_diagnostics<-shiny::renderPlot({server_asr_plot(function(){shiny::req(result());draw(TRUE)},data$lang())},width=function()appearance()$width*96,height=function()appearance()$height*96,res=96)
 output$bm_estimates<-shiny::renderTable({shiny::req(result());t<-result()$nodes;names(t)<-vapply(names(t),guane_text,character(1),lang=data$lang());t},digits=5)
 output$bm_summary<-shiny::renderTable({shiny::req(result());r<-result();if(!is.null(r$bayes)){t<-data.frame(Metric=vapply(c('Taxa','Chains','Retained draws per chain','Burn-in generations'),guane_text,character(1),lang=data$lang()),Value=c(length(r$x),r$bayes$chains,nrow(r$bayes$retained[[1]]),r$bayes$burnin));names(t)<-vapply(names(t),guane_text,character(1),lang=data$lang());return(t)};t<-data.frame(Metric=vapply(c('Taxa','Internal nodes','Root estimate','Diffusion parameter (sig2)','Log likelihood (engine basis)','alpha (OU)','r (EB)','Optimizer convergence'),guane_text,character(1),lang=data$lang()),Value=c(length(r$x),nrow(r$nodes),r$root,r$rate,r$logLik,if(is.null(r$alpha))NA else r$alpha,if(is.null(r$r))NA else r$r,if(is.null(r$fit))NA else r$fit$convergence));names(t)<-vapply(names(t),guane_text,character(1),lang=data$lang());t},digits=5)
 output$bm_metadata<-shiny::renderText({shiny::req(result());paste(result()$trait,'|',result()$model,if(is.null(result()$bayes))'| ML | n =' else '| Bayesian | n =',length(result()$x),'|',if(result()$engine=='Gaussian ML')'Guane' else 'phytools::',result()$engine,'|',result()$backend_version)})
 output$bm_comparison<-shiny::renderTable({shiny::req(result()$comparison);d<-result()$comparison;d$Status<-vapply(d$Status,guane_text,character(1),lang=data$lang());names(d)<-vapply(names(d),guane_text,character(1),lang=data$lang());d},digits=5)
 output$bm_comparison_csv<-shiny::downloadHandler('guane-continuous-comparison.csv',function(file){shiny::req(result()$comparison);guane_write_csv(result()$comparison,file,row.names=FALSE)})
 output$bm_uncertainty<-shiny::renderText({shiny::req(result());guane_text(result()$uncertainty,data$lang())})
 output$bm_likelihood<-shiny::renderText({shiny::req(result());guane_text(result()$likelihood_basis,data$lang())})
 output$bm_warnings<-shiny::renderText({shiny::req(result());if(length(result()$warnings)) paste(vapply(result()$warnings,guane_text,character(1),lang=data$lang()),collapse='\n') else guane_text('No fitting warnings reported. Inspect diagnostics before interpretation.',data$lang())})
 code<-shiny::reactive({
  if(is.null(result()))return(c('# Prospective call; tree and x must be explicitly matched in Data.',
   paste0('settings <- ',paste(deparse(options()),collapse='\n')),
   '# BM/fastAnc uses vars=TRUE, CI=TRUE. anc.ML arguments are validated on Run.',
   paste0('result <- do.call(',if(identical(input$bm_framework,'Bayes'))'guane_asr_bayes' else 'guane_asr_continuous',', c(list(tree=tree, traits=traits, taxon=taxon, trait=trait), settings))')))
  do.call(guane_asr_bm_script,c(list(result=result()),settings()))
 })
 output$bm_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$bm_script<-shiny::downloadHandler('guane-continuous.R',function(file){shiny::req(result());writeLines(code(),file)})
 output$bm_png<-shiny::downloadHandler('guane-continuous.png',function(file){shiny::req(result());g<-appearance();grDevices::png(file,width=g$width,height=g$height,units='in',res=g$dpi);on.exit(grDevices::dev.off());draw()})
 output$bm_view_rds<-shiny::downloadHandler('guane-continuous-view.rds',function(file){shiny::req(result());saveRDS(list(result=result(),plot_settings=settings()),file)})
 output$bm_pdf<-shiny::downloadHandler('guane-continuous.pdf',function(file){shiny::req(result());grDevices::pdf(file,width=appearance()$width,height=appearance()$height);on.exit(grDevices::dev.off());draw()})
 output$bm_diagnostic_pdf<-shiny::downloadHandler('guane-continuous-diagnostics.pdf',function(file){shiny::req(result());grDevices::pdf(file,width=appearance()$width,height=appearance()$height);on.exit(grDevices::dev.off());draw(TRUE)})
 output$bm_diagnostic_script<-shiny::downloadHandler('guane-continuous-diagnostics.R',function(file){shiny::req(result());s<-settings();s$type<-'diagnostics';writeLines(do.call(guane_asr_bm_script,c(list(result=result()),s)),file)})
 output$bm_csv<-shiny::downloadHandler('guane-continuous-nodes.csv',function(file){shiny::req(result());guane_write_csv(result()$nodes,file,row.names=FALSE)})
 list(result=result,code=code)
}
