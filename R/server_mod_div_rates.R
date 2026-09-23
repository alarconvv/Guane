server_mod_div_rates <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Choose settings and run diversification models.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 options<-shiny::reactive({number<-function(n){z<-input[[n]];if(is.null(z)||!nzchar(trimws(z)))NULL else suppressWarnings(as.numeric(z))}
 list(models=if(is.null(input$rates_models))character() else input$rates_models,sampling=value('rates_sampling',1),survival=isTRUE(value('rates_survival',TRUE)),optimizer=value('rates_optimizer','nlminb'),maxit=value('rates_maxit',2000),upper=number('rates_upper'),start_lambda=number('rates_start_lambda'),start_mu=number('rates_start_mu'),intervals=isTRUE(value('rates_intervals',TRUE)),slices=isTRUE(value('rates_slices',TRUE)))})
 translate<-function(x){if(is.null(x))return(NULL);names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 diagnostic_options<-shiny::reactive(list(profiles=isTRUE(value('rates_profiles',TRUE)),level=value('rates_level',.95),points=value('rates_points',61),simulate=isTRUE(value('rates_simulate',TRUE)),nsim=value('rates_nsim',200),seed=value('rates_simseed',999)))
 shiny::observeEvent(diagnostic_options(),{
  r<-result();if(!is.null(r)){r$profile<-r$adequacy<-r$diagnostic_inputs<-NULL;result(r);status('Diagnostic settings changed. Run uncertainty and diagnostics again.')}
 },ignoreInit=TRUE)
 shiny::observeEvent(input$rates_diagnose,{
  shiny::req(result())
  tryCatch({r<-shiny::withProgress(message=guane_text('Running uncertainty and simulation diagnostics',data$lang()),value=.1,do.call(guane_rates_diagnose,c(list(result=result()),diagnostic_options())));result(r);status('Diagnostics completed. Review profile limits and simulation assumptions.')},
   error=function(e){status(conditionMessage(e))})
 })
 shiny::observeEvent(list(data$state$tree,options()),{result(NULL);status('Inputs changed. Run diversification models to update results.')},ignoreNULL=FALSE)
 shiny::observeEvent(input$rates_run,{
  result(NULL)
  tryCatch({r<-shiny::withProgress(message=guane_text('Fitting diversification models',data$lang()),value=.1,do.call(guane_rates_fit,c(list(tree=data$state$tree),options())));result(r);status(if(any(r$comparison$Converged))'Rate analysis completed. Inspect convergence, bounds and uncertainty.' else 'No valid model fit. Change settings and run again.');data$record('Constant-rate diversification analysis completed.')},error=function(e){status(conditionMessage(e));data$record(paste('Diversification:',conditionMessage(e)))})
 })
 shiny::observeEvent(result(),{r<-result();if(is.null(r))return();shiny::updateSelectInput(session,'rates_plot_model',choices=r$comparison$Model,selected=if(isTRUE(input$rates_plot_model%in%r$comparison$Model))input$rates_plot_model else r$comparison$Model[1])})
 output$rates_status<-shiny::renderText(guane_text(status(),data$lang()))
 output$rates_estimates<-shiny::renderTable({shiny::req(result());translate(result()$estimates)},digits=6)
 output$rates_comparison<-shiny::renderTable({shiny::req(result());translate(result()$comparison)},digits=6)
 output$rates_attempts<-shiny::renderTable({shiny::req(result());translate(result()$attempts)},digits=6)
 output$rates_warnings<-shiny::renderText({shiny::req(result());w<-result()$warnings;if(!length(w))w<-'No fitting warnings reported. Inspect diagnostics before interpretation.';paste(vapply(w,guane_text,character(1),lang=data$lang()),collapse='\n')})
 output$rates_interpretation<-shiny::renderText({
  shiny::req(result());d<-result()$comparison;txt<-function(x)guane_text(x,data$lang())
  if(!all(is.finite(d$Weight)))return(txt('Model ranking requires two converged candidates. Inspect individual estimates and diagnostics.'))
  best<-which.min(d$AIC);gap<-max(d$DeltaAIC)
  paste(txt('Lowest AIC among selected models:'),d$Model[best],
   paste0('(Delta AIC = ',signif(gap,3),'; ',txt('Weight'),' = ',signif(d$Weight[best],3),').'),
   txt(if(gap<2)'The AIC difference is small; these data do not clearly distinguish the selected models.' else 'Relative AIC support does not establish that the selected model adequately describes the data.'))
 })
 output$rates_profile_table<-shiny::renderTable({
  shiny::req(result()$profile);d<-result()$profile$intervals
  for(n in c('Lower_status','Upper_status'))d[[n]]<-vapply(d[[n]],guane_text,character(1),lang=data$lang())
  translate(d)
 },digits=6)
 output$rates_adequacy_table<-shiny::renderTable({shiny::req(result()$adequacy);translate(result()$adequacy$summary)},digits=6)
 output$rates_profile_csv<-shiny::downloadHandler('guane-profile-intervals.csv',function(file){shiny::req(result()$profile);utils::write.csv(result()$profile$intervals,file,row.names=FALSE)})
 output$rates_profile_curves_csv<-shiny::downloadHandler('guane-profile-curves.csv',function(file){shiny::req(result()$profile);utils::write.csv(result()$profile$curves,file,row.names=FALSE)})
 output$rates_envelope_csv<-shiny::downloadHandler('guane-ltt-envelope.csv',function(file){shiny::req(result()$adequacy);utils::write.csv(result()$adequacy$envelope,file,row.names=FALSE)})
 output$rates_draws_csv<-shiny::downloadHandler('guane-simulated-branching-times.csv',function(file){shiny::req(result()$adequacy);utils::write.csv(result()$adequacy$draws,file,row.names=FALSE)})
 output$rates_metadata<-shiny::renderText({shiny::req(result());r<-result();paste('diversitree',r$version,'| n =',r$tips,'| sampling.f =',r$inputs$sampling,'| condition.surv =',r$inputs$survival,'| upper =',signif(r$inputs$upper,6))})
 output$rates_csv<-shiny::downloadHandler('guane-rate-estimates.csv',function(file){shiny::req(result());utils::write.csv(result()$estimates,file,row.names=FALSE)})
 output$rates_comparison_csv<-shiny::downloadHandler('guane-rate-comparison.csv',function(file){shiny::req(result());utils::write.csv(result()$comparison,file,row.names=FALSE)})
 output$rates_attempts_csv<-shiny::downloadHandler('guane-rate-optimizer.csv',function(file){shiny::req(result());utils::write.csv(result()$attempts,file,row.names=FALSE)})
 output$rates_slices_csv<-shiny::downloadHandler('guane-rate-slices.csv',function(file){shiny::req(result()$slices);utils::write.csv(result()$slices,file,row.names=FALSE)})
 settings<-shiny::reactive(list(type=value('rates_graph','rates'),model=value('rates_plot_model','Yule'),parameter=value('rates_parameter','lambda'),palette=value('rates_palette','Guane'),lang=data$lang()))
 plot_settings<-settings
 draw<-function(){r<-result();shiny::req(r);tryCatch(do.call(guane_rates_plot,c(list(result=r),plot_settings())),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$rates_plot<-shiny::renderPlot(draw(),width=960,height=672,res=96)
 code<-shiny::reactive({pending<-c('# Proposed settings; run analysis to apply.',guane_r_assignment('analysis_settings',options()),guane_r_assignment('additional_settings',diagnostic_options()));r<-tryCatch(result(),error=function(e)NULL);if(is.null(r))return(pending);c(pending,do.call(guane_rates_script,c(list(result=r),plot_settings())))})
 output$rates_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$rates_script<-shiny::downloadHandler('guane-rates.R',function(file){shiny::req(result());writeLines(code(),file)})
 output$rates_pdf<-shiny::downloadHandler('guane-rates.pdf',function(file){shiny::req(result());grDevices::pdf(file,width=10,height=7);on.exit(grDevices::dev.off());draw()})
 output$rates_png<-shiny::downloadHandler('guane-rates.png',function(file){shiny::req(result());grDevices::png(file,width=1500,height=1050,res=150);on.exit(grDevices::dev.off());draw()})
 output$rates_rds<-shiny::downloadHandler('guane-rates.rds',function(file){shiny::req(result());saveRDS(list(result=result(),settings=plot_settings()),file)})
 list(result=result,code=code)
}
