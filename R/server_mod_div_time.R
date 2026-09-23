server_mod_div_time <- function(input,output,session,data) {
 time_result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Choose settings and run diversification models.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 options<-shiny::reactive({number<-function(n){z<-input[[n]];if(is.null(z)||!nzchar(trimws(z)))NULL else suppressWarnings(as.numeric(z))}
 list(models=if(is.null(input$time_models))character() else input$time_models,sampling=value('time_sampling',1),survival=isTRUE(value('time_survival',TRUE)),optimizer=value('time_optimizer','nlminb'),maxit=value('time_maxit',2000),upper=number('time_upper'),start_lambda=number('time_start_lambda'),start_mu=number('time_start_mu'),intervals=isTRUE(value('time_intervals',TRUE)),slices=isTRUE(value('time_slices',TRUE)))})
 translate<-function(x){if(is.null(x))return(NULL);names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 time_options<-shiny::reactive(list(models=if(is.null(input$time_models))character() else input$time_models,beta_start=value('time_beta',0),beta_bound=value('time_bound',3),tol=value('time_tol',1e-8),backend=value('time_backend','gslode')))
 shiny::observeEvent(list(data$state$tree,options(),time_options()),{if(!is.null(time_result()))status('Time-model settings changed. Run time-varying comparison again.');time_result(NULL)},ignoreNULL=FALSE)
 shiny::observeEvent(input$time_run,{
  time_result(NULL)
  tryCatch({
   shared<-options();shared<-shared[c('sampling','survival','optimizer','maxit','upper','start_lambda','start_mu')]
   r<-shiny::withProgress(message=guane_text('Fitting time-varying models',data$lang()),value=.1,do.call(guane_rates_tv_fit,c(list(tree=data$state$tree),shared,time_options())))
   time_result(r);shiny::updateSelectInput(session,'time_graph',selected='time_rates');status('Time-model analysis completed. Inspect diagnostics and bounds.')
  },error=function(e)status(conditionMessage(e)))
 })
 time_unc_options<-shiny::reactive(list(model=value('time_unc_model','ExpYule'),profiles=isTRUE(value('time_profiles',TRUE)),level=value('time_level',.95),points=value('time_points',31),bootstrap=isTRUE(value('time_bootstrap',TRUE)),nsim=value('time_nsim',50),seed=value('time_seed',999),robustness=isTRUE(value('time_robustness',TRUE)),factor=value('time_factor',2)))
 shiny::observeEvent(time_unc_options(),{
  r<-time_result();if(!is.null(r)){r$uncertainty<-r$uncertainty_inputs<-NULL;time_result(r);status('Time uncertainty settings changed. Run time uncertainty again.')}
 },ignoreInit=TRUE)
 shiny::observeEvent(input$time_unc_run,{
  shiny::req(time_result())
  tryCatch({
   r<-shiny::withProgress(message=guane_text('Computing time-model uncertainty',data$lang()),value=.1,do.call(guane_rates_tv_uncertainty,c(list(result=time_result()),time_unc_options())))
   time_result(r);status('Time uncertainty completed. Review limits, failures and robustness.')
  },error=function(e)status(conditionMessage(e)))
 })
 output$time_interpretation<-shiny::renderText({
  shiny::req(time_result());d<-time_result()$comparison;txt<-function(x)guane_text(x,data$lang())
  if(!all(is.finite(d$Weight)))return(txt('Compatible converged and numerically stable fits are required.'))
  i<-which.min(d$AIC);gap<-sort(d$DeltaAIC)[2]
  paste(txt('Lowest AIC among time candidates:'),d$Model[i],paste0('(',txt('Weight'),' = ',signif(d$Weight[i],3),').'),
   txt(if(gap<2)'The AIC difference is small; these data do not clearly distinguish the selected models.' else 'Relative AIC support does not establish that the selected model adequately describes the data.'))
 })
 output$time_unc_warnings<-shiny::renderText({
  shiny::req(time_result()$uncertainty);w<-time_result()$uncertainty$warnings
  paste(vapply(w,guane_text,character(1),lang=data$lang()),collapse='\n')
 })
 output$time_profile_table<-shiny::renderTable({
  shiny::req(time_result()$uncertainty$profile);d<-time_result()$uncertainty$profile$intervals
  for(n in c('Lower_status','Upper_status'))d[[n]]<-vapply(d[[n]],guane_text,character(1),lang=data$lang())
  translate(d)
 },digits=6)
 output$time_boot_summary<-shiny::renderText({
  shiny::req(time_result()$uncertainty$bootstrap);b<-time_result()$uncertainty$bootstrap
  paste(b$model,'|',guane_text('Successful refits',data$lang()),b$success,'/',b$nsim,'|',guane_text('Boundary',data$lang()),b$boundary,'| CDF error =',signif(b$cdf_error,3))
 })
 output$time_boot_table<-shiny::renderTable({shiny::req(time_result()$uncertainty$bootstrap);translate(time_result()$uncertainty$bootstrap$replicates)},digits=6)
 output$time_robust_table<-shiny::renderTable({
  shiny::req(time_result()$uncertainty$robustness);d<-time_result()$uncertainty$robustness
  d$Scenario<-vapply(d$Scenario,guane_text,character(1),lang=data$lang());translate(d)
 },digits=6)
 output$time_unc_csv<-shiny::downloadHandler('guane-time-profile.csv',function(file){shiny::req(time_result()$uncertainty$profile);utils::write.csv(cbind(Model=time_result()$uncertainty$model,time_result()$uncertainty$profile$intervals),file,row.names=FALSE)})
 output$time_profile_curves_csv<-shiny::downloadHandler('guane-time-profile-curves.csv',function(file){shiny::req(time_result()$uncertainty$profile);utils::write.csv(cbind(Model=time_result()$uncertainty$model,time_result()$uncertainty$profile$curves),file,row.names=FALSE)})
 output$time_boot_csv<-shiny::downloadHandler('guane-time-bootstrap-refits.csv',function(file){shiny::req(time_result()$uncertainty$bootstrap);utils::write.csv(cbind(Model=time_result()$uncertainty$model,time_result()$uncertainty$bootstrap$replicates),file,row.names=FALSE)})
 output$time_bands_csv<-shiny::downloadHandler('guane-time-bootstrap-bands.csv',function(file){shiny::req(time_result()$uncertainty$bootstrap$bands);utils::write.csv(cbind(Model=time_result()$uncertainty$model,time_result()$uncertainty$bootstrap$bands),file,row.names=FALSE)})
 output$time_robust_csv<-shiny::downloadHandler('guane-time-robustness.csv',function(file){shiny::req(time_result()$uncertainty$robustness);utils::write.csv(cbind(Model=time_result()$uncertainty$model,time_result()$uncertainty$robustness),file,row.names=FALSE)})
 output$time_comparison<-shiny::renderTable({shiny::req(time_result());translate(time_result()$comparison)},digits=6)
 output$time_attempts<-shiny::renderTable({shiny::req(time_result());translate(time_result()$attempts)},digits=6)
 output$time_warnings<-shiny::renderText({shiny::req(time_result());w<-time_result()$warnings;if(!length(w))w<-'No fitting warnings reported. Inspect diagnostics before interpretation.';paste(vapply(w,guane_text,character(1),lang=data$lang()),collapse='\n')})
 output$time_csv<-shiny::downloadHandler('guane-time-comparison.csv',function(file){shiny::req(time_result());utils::write.csv(time_result()$comparison,file,row.names=FALSE)})
 output$time_curves_csv<-shiny::downloadHandler('guane-time-curves.csv',function(file){shiny::req(time_result());utils::write.csv(time_result()$curves,file,row.names=FALSE)})
 output$time_attempts_csv<-shiny::downloadHandler('guane-time-optimizer.csv',function(file){shiny::req(time_result());utils::write.csv(time_result()$attempts,file,row.names=FALSE)})
 settings<-shiny::reactive(list(type=value('time_graph','time_rates'),model=value('time_plot_model','Yule'),parameter=value('time_parameter','lambda'),palette=value('time_palette','Guane'),lang=data$lang()))
 plot_settings<-settings
 draw<-function(){r<-time_result();shiny::req(r);tryCatch(do.call(guane_rates_tv_plot,c(list(result=r),plot_settings())),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$time_plot<-shiny::renderPlot(draw(),width=960,height=672,res=96)
 output$time_status<-shiny::renderText(guane_text(status(),data$lang()))
 code<-shiny::reactive({pending<-c('# Proposed settings; run analysis to apply.',guane_r_assignment('analysis_settings',options()),guane_r_assignment('time_settings',time_options()),guane_r_assignment('additional_settings',time_unc_options()));r<-tryCatch(time_result(),error=function(e)NULL);if(is.null(r))return(pending);c(pending,do.call(guane_rates_tv_script,c(list(result=r),plot_settings())))})
 output$time_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$time_script<-shiny::downloadHandler('guane-time.R',function(file){shiny::req(time_result());writeLines(code(),file)})
 output$time_pdf<-shiny::downloadHandler('guane-time.pdf',function(file){shiny::req(time_result());grDevices::pdf(file,width=10,height=7);on.exit(grDevices::dev.off());draw()})
 output$time_png<-shiny::downloadHandler('guane-time.png',function(file){shiny::req(time_result());grDevices::png(file,width=1500,height=1050,res=150);on.exit(grDevices::dev.off());draw()})
 output$time_rds<-shiny::downloadHandler('guane-time.rds',function(file){shiny::req(time_result());saveRDS(list(result=time_result(),settings=plot_settings()),file)})
 list(result=time_result,code=code)
}
