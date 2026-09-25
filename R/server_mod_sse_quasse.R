server_mod_sse_quasse <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Select a continuous trait and run QuaSSE.')
 value<-function(n,d)if(is.null(input[[paste0('quasse_',n)]]))d else input[[paste0('quasse_',n)]]
 options<-shiny::reactive(list(trait=input$quasse_trait,error=value('error',1),error_column=value('error_column',''),lambda=value('lambda','Constant'),mu=value('mu','Constant'),parameter_text=value('parameters',''),baseline=isTRUE(value('baseline',TRUE)),sampling=value('sampling',1),survival=isTRUE(value('survival',TRUE)),root=value('root','OBS'),root_mean=value('root_mean',0),root_sd=value('root_sd',1),nx=as.numeric(value('nx',1024)),r=as.numeric(value('r',4)),step=value('step',.001),tc=value('tc',.1),range_mult=value('range',5),xmid=if(is.null(input$quasse_xmid)||is.na(input$quasse_xmid))NULL else input$quasse_xmid,w=value('w',5),method=value('method','fftC'),tips=isTRUE(value('tips',FALSE)),optimizer=value('optimizer','nlminb'),starts=value('starts',2),maxit=value('maxit',200),slices=isTRUE(value('slices',FALSE)),verify=isTRUE(value('verify',TRUE))))
 shiny::observeEvent(list(data$state$traits,data$taxon()),{
  cols<-setdiff(names(data$state$traits)[vapply(data$state$traits,is.numeric,logical(1))],data$taxon())
  selected<-if(length(input$quasse_trait)==1&&input$quasse_trait%in%cols)input$quasse_trait else head(cols,1)
  shiny::updateSelectInput(session,'quasse_trait',choices=cols,selected=selected)
  shiny::updateSelectInput(session,'quasse_error_column',choices=c('Common standard error'='',stats::setNames(cols,cols)),selected=if(value('error_column','')%in%cols)value('error_column','') else '')
 },ignoreNULL=FALSE)
 shiny::observeEvent(input$quasse_fill,{
  tryCatch({o<-options();d<-guane_quasse_data(data$state$tree,data$state$traits,data$taxon(),o$trait,o$error,o$error_column);t<-guane_quasse_parameters(d,o$lambda,o$mu);shiny::updateTextAreaInput(session,'quasse_parameters',value=paste(capture.output(utils::write.csv(t,row.names=FALSE,na='')),collapse='\n'))},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),options()),{quasse_task$discard();result(NULL);status('QuaSSE inputs changed. Run again to update results.')},ignoreInit=TRUE)
 quasse_fail<-function(msg){status(msg);data$record(paste('QuaSSE:',msg))}
 quasse_task<-guane_task(function(r){result(r);status(if(any(r$comparison$Converged))'QuaSSE completed. Review convergence and grid sensitivity.' else 'No valid QuaSSE fit. Inspect diagnostics.');data$record('QuaSSE analysis completed.');for(w in r$warnings)data$record(paste('QuaSSE:',w))},quasse_fail,status)
 shiny::observeEvent(input$quasse_run,{
  result(NULL)
  tryCatch(quasse_task$run(guane_quasse_fit,c(list(tree=data$state$tree,traits=data$state$traits,taxon=data$taxon()),options())),error=function(e)quasse_fail(conditionMessage(e)))
 })
 shiny::observeEvent(result(),{r<-result();if(is.null(r))return();shiny::updateSelectInput(session,'quasse_plot_model',choices=names(r$fits),selected=if(value('plot_model','Selected')%in%names(r$fits))value('plot_model','Selected') else names(r$fits)[1])})
 shiny::observeEvent(list(result(),input$quasse_plot_model),{r<-result();if(is.null(r))return();f<-r$fits[[value('plot_model','Selected')]];choices<-if(isTRUE(f$valid))f$constraint$free else character();shiny::updateSelectInput(session,'quasse_plot_parameter',choices=choices,selected=if(value('plot_parameter','diffusion')%in%choices)value('plot_parameter','diffusion') else head(choices,1))})
 quasse_robust_task<-guane_task(function(a){r<-result();if(is.null(r))return();r$robustness<-a
   if(!a$passed){r$comparison$Weight<-NA_real_;r$warnings<-unique(c(r$warnings,a$warning));r$robustness_review<-TRUE}
   if(isTRUE(r$robustness_review))r$comparison$Weight<-NA_real_
   result(r);status(a$warning);data$record('QuaSSE grid and domain refits completed.');shiny::updateSelectInput(session,'quasse_graph',selected='robustness')
 },status,status)
 shiny::observeEvent(input$quasse_robust_run,{
  tryCatch({shiny::req(result());quasse_robust_task$run(guane_quasse_robustness,list(result(),value('domain_factor',1.5)))},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(input$quasse_domain_factor,{quasse_robust_task$discard();r<-result();if(!is.null(r)&&!is.null(r$robustness)){r$robustness<-NULL;result(r)}},ignoreInit=TRUE)
 output$quasse_robustness<-shiny::renderTable({shiny::req(result()$robustness);translate(result()$robustness$table)},digits=6)
 output$quasse_robust_csv<-shiny::downloadHandler('guane-quasse-robustness.csv',function(file){shiny::req(result()$robustness);guane_write_csv(result()$robustness$table,file,row.names=FALSE)})
 translate<-function(x){if(is.null(x))return(NULL);if('Model'%in%names(x))x$Model<-vapply(x$Model,guane_text,character(1),lang=data$lang());names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 output$quasse_status<-shiny::renderText(guane_text(status(),data$lang()))
 for(n in c('estimates','comparison','diagnostics','attempts'))local({key<-n;output[[paste0('quasse_',key)]]<-shiny::renderTable({shiny::req(result());translate(result()[[key]])},digits=6)})
 output$quasse_constraints<-shiny::renderTable({shiny::req(result());translate(do.call(rbind,lapply(names(result()$fits),function(m){f<-result()$fits[[m]];if(!f$valid)return(NULL);cbind(Model=m,f$constraint$table)})))},digits=6)
 output$quasse_warnings<-shiny::renderText({shiny::req(result());r<-result();paste(c(vapply(r$warnings,guane_text,character(1),lang=data$lang()),unlist(lapply(r$fits,`[[`,'numerical_messages'))),collapse='\n')})
 output$quasse_metadata<-shiny::renderText({shiny::req(result());r<-result();paste('diversitree',r$version,'| n =',length(r$states),'| lambda:',r$inputs$lambda,'| mu:',r$inputs$mu,'| root:',r$inputs$root,'| sampling.f:',r$inputs$sampling,'| nx:',r$control$nx,'| dt.max:',r$control$dt.max)})
 output$quasse_interpretation<-shiny::renderText({shiny::req(result());z<-result()$comparison;if(anyNA(z$Weight))guane_text('QuaSSE ranking weights are unavailable. Inspect individual fits and diagnostics.',data$lang()) else paste(guane_text('Lowest AIC among selected models:',data$lang()),guane_text(z$Model[which.min(z$AIC)],data$lang()))})
 settings<-shiny::reactive(guane_quasse_settings(value('graph','rates'),value('plot_model','Selected'),value('plot_parameter','diffusion'),value('palette','Guane'),isTRUE(value('labels',TRUE)),value('font',.7),value('width',10),value('height',7),data$lang()))
 draw<-function(){shiny::req(result());tryCatch(guane_quasse_plot(result(),settings()),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$quasse_plot<-shiny::renderPlot(draw(),width=function()settings()$width*96,height=function()settings()$height*96,res=96)
 code<-shiny::reactive({if(is.null(result()))return(c('# Proposed QuaSSE settings; no fit performed.',guane_r_assignment('analysis_settings',options())));guane_quasse_script(result(),settings())})
 output$quasse_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$quasse_script<-shiny::downloadHandler('guane-quasse.R',function(file){shiny::req(result());writeLines(code(),file)})
 output$quasse_pdf<-shiny::downloadHandler('guane-quasse.pdf',function(file){shiny::req(result());s<-settings();grDevices::pdf(file,width=s$width,height=s$height);on.exit(grDevices::dev.off());draw()})
 output$quasse_png<-shiny::downloadHandler('guane-quasse.png',function(file){shiny::req(result());s<-settings();grDevices::png(file,width=s$width*150,height=s$height*150,res=150);on.exit(grDevices::dev.off());draw()})
 for(n in c('estimates','comparison','attempts','slices'))local({key<-n;id<-if(key=='estimates')'quasse_csv' else paste0('quasse_',key,'_csv');output[[id]]<-shiny::downloadHandler(paste0('guane-quasse-',key,'.csv'),function(file){shiny::req(result());guane_write_csv(result()[[key]],file,row.names=FALSE)})})
 output$quasse_rds<-shiny::downloadHandler('guane-quasse.rds',function(file){shiny::req(result());saveRDS(list(result=result(),settings=settings()),file)})
 list(result=result,code=code)
}
