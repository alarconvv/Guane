server_mod_sse_musse <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Select a discrete trait and run MuSSE.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 options<-shiny::reactive(list(trait=input$musse_trait,models=value('musse_models',character()),state_text=value('musse_states',''),survival=isTRUE(value('musse_survival',TRUE)),root=value('musse_root','OBS'),parameter_text=value('musse_parameters',''),optimizer=value('musse_optimizer','nlminb'),starts=value('musse_starts',3),maxit=value('musse_maxit',500),backend=value('musse_backend',guane_sse_backend()),tolerance=value('musse_tol',1e-8),eps=value('musse_eps',0),slices=isTRUE(value('musse_slices',TRUE)),verify=isTRUE(value('musse_verify',TRUE))))
 shiny::observeEvent(list(data$state$traits,data$taxon()),{
  cols<-setdiff(names(data$state$traits),data$taxon());counts<-vapply(data$state$traits[cols],function(x)if(anyNA(x))0L else length(unique(as.character(x))),integer(1));cols<-cols[counts>=2&counts<=8]
  preferred<-cols[vapply(data$state$traits[cols],function(x)length(unique(x))>2,logical(1))]
  selected<-if(length(input$musse_trait)==1&&input$musse_trait%in%cols)input$musse_trait else head(c(preferred,cols),1)
  shiny::updateSelectInput(session,'musse_trait',choices=cols,selected=selected)
 },ignoreNULL=FALSE)
 preview<-shiny::reactive(guane_musse_state_table(data$state$traits,input$musse_trait,value('musse_states','')))
 output$musse_mapping_preview<-shiny::renderTable({z<-tryCatch(preview(),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))));translate(data.frame(Code=seq_len(nrow(z)),z))},digits=6)
 shiny::observeEvent(input$musse_fill_states,{
  tryCatch({tab<-guane_musse_state_table(data$state$traits,input$musse_trait);text<-paste(capture.output(utils::write.csv(tab,row.names=FALSE)),collapse='\n');shiny::updateTextAreaInput(session,'musse_states',value=text)},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(input$musse_fill,{
  tryCatch({guane_ltt(data$state$tree);tab<-guane_musse_parameters(data$state$tree,nrow(preview()));text<-paste(capture.output(utils::write.csv(tab,row.names=FALSE,na='')),collapse='\n');shiny::updateTextAreaInput(session,'musse_parameters',value=text)},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),options()),{musse_task$discard();result(NULL);status('MuSSE inputs changed. Run again to update results.')},ignoreInit=TRUE)
 musse_fail<-function(msg){status(msg);data$record(paste('MuSSE:',msg))}
 musse_task<-guane_task(function(r){result(r);status(if(any(r$comparison$Converged))'MuSSE completed. Review convergence, bounds and model assumptions.' else 'No valid MuSSE fit. Inspect diagnostics.');data$record('MuSSE analysis completed.');for(w in r$warnings)data$record(paste('MuSSE:',w))},musse_fail,status)
 shiny::observeEvent(input$musse_run,{
  result(NULL)
  tryCatch(musse_task$run(guane_musse_fit,c(list(tree=data$state$tree,traits=data$state$traits,taxon=data$taxon()),options())),error=function(e)musse_fail(conditionMessage(e)))
 })
 shiny::observeEvent(result(),{r<-result();if(is.null(r))return();choices<-r$comparison$Model;valid<-choices[r$comparison$Converged];shiny::updateSelectInput(session,'musse_plot_model',choices=choices,selected=if(length(input$musse_plot_model)==1&&input$musse_plot_model%in%choices)input$musse_plot_model else if(length(valid))valid[1] else choices[1])})
 shiny::observeEvent(list(result(),input$musse_plot_model),{r<-result();if(is.null(r))return();f<-r$fits[[value('musse_plot_model','Equal transitions')]];choices<-if(isTRUE(f$valid))f$constraint$free else character();shiny::updateSelectInput(session,'musse_plot_parameter',choices=choices,selected=if(length(input$musse_plot_parameter)==1&&input$musse_plot_parameter%in%choices)input$musse_plot_parameter else head(choices,1))})
 musse_profile_model<-NULL
 musse_profile_task<-guane_task(function(p){r<-result();if(is.null(r))return();p$model<-musse_profile_model;r$profile<-p
   if(p$better){r$fits[[p$model]]$better_failed<-TRUE;r$comparison$Weight<-NA_real_;r$warnings<-unique(c(r$warnings,'A profile found a better likelihood. Refit before interpretation.'))}
   result(r);status(p$warning);data$record(paste('SSE profile:',p$model,p$settings$parameter));shiny::updateSelectInput(session,'musse_graph',selected='profile')
 },status,status)
 shiny::observeEvent(input$musse_profile_run,{
  tryCatch({shiny::req(result());r<-result();musse_profile_model<<-input$musse_plot_model
   musse_profile_task$run(guane_musse_profile,list(r,input$musse_plot_model,input$musse_plot_parameter,input$musse_profile_lower,input$musse_profile_upper,input$musse_profile_points,input$musse_profile_level,r$inputs$maxit))
  },error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(input$musse_profile_lower,input$musse_profile_upper,input$musse_profile_points,input$musse_profile_level),{musse_profile_task$discard();r<-result();if(!is.null(r)&&!is.null(r$profile)){r$profile<-NULL;result(r)}},ignoreInit=TRUE)
 output$musse_profile_interval<-shiny::renderTable({shiny::req(result()$profile);translate(result()$profile$interval)},digits=6)
 output$musse_profile_curve<-shiny::renderTable({shiny::req(result()$profile);translate(result()$profile$curve)},digits=6)
 output$musse_profile_csv<-shiny::downloadHandler('guane-musse-profile.csv',function(file){shiny::req(result()$profile);guane_write_csv(result()$profile$curve,file,row.names=FALSE)})
 output$musse_interval_csv<-shiny::downloadHandler('guane-musse-interval.csv',function(file){shiny::req(result()$profile);guane_write_csv(result()$profile$interval,file,row.names=FALSE)})
 translate<-function(x){if(is.null(x))return(NULL);for(n in intersect(c('LowerStatus','UpperStatus'),names(x)))x[[n]]<-vapply(x[[n]],guane_text,character(1),lang=data$lang());if('Model'%in%names(x))x$Model<-vapply(x$Model,guane_text,character(1),lang=data$lang());names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 output$musse_status<-shiny::renderText(guane_text(status(),data$lang()))
 for(n in c('mapping','estimates','comparison','diagnostics','attempts'))local({key<-n;output[[paste0('musse_',key)]]<-shiny::renderTable({shiny::req(result());translate(result()[[key]])},digits=6)})
 output$musse_constraints<-shiny::renderTable({shiny::req(result());translate(do.call(rbind,lapply(names(result()$fits),function(m){f<-result()$fits[[m]];if(!f$valid)return(NULL);cbind(Model=m,f$constraint$table)})))},digits=6)
 output$musse_warnings<-shiny::renderText({shiny::req(result());r<-result();paste(c(vapply(r$warnings,guane_text,character(1),lang=data$lang()),unlist(lapply(r$fits,`[[`,'numerical_messages'))),collapse='\n')})
 output$musse_interpretation<-shiny::renderText({shiny::req(result());d<-result()$comparison;if(anyNA(d$Weight))return(guane_text('MuSSE ranking weights are unavailable. Inspect individual fits and diagnostics.',data$lang()));paste(guane_text('Lowest AIC among selected models:',data$lang()),guane_text(d$Model[which.min(d$AIC)],data$lang()))})
 output$musse_metadata<-shiny::renderText({shiny::req(result());r<-result();paste('diversitree',r$version,'| n =',length(r$states),'| sampling.f =',paste(r$mapping$Sampling,collapse=', '),'| root =',r$inputs$root,'| condition.surv =',r$inputs$survival)})
 settings<-shiny::reactive(guane_musse_settings(type=value('musse_graph','rates'),model=value('musse_plot_model','Equal transitions'),parameter=value('musse_plot_parameter','lambda1'),palette=value('musse_palette','Guane'),labels=isTRUE(value('musse_labels',TRUE)),label_size=value('musse_font',.7),width=value('musse_width',10),height=value('musse_height',7),lang=data$lang()))
 draw<-function(){shiny::req(result());tryCatch(guane_musse_plot(result(),settings()),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$musse_plot<-shiny::renderPlot(draw(),width=function()settings()$width*96,height=function()settings()$height*96,res=96)
 code<-shiny::reactive({if(is.null(result()))return(c('# Proposed MuSSE settings. No fit has been performed.',guane_r_assignment('analysis_settings',options()),'# result <- do.call(guane_musse_fit, c(list(tree=tree, traits=traits, taxon=taxon), analysis_settings))'));guane_musse_script(result(),settings())})
 output$musse_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$musse_script<-shiny::downloadHandler('guane-musse.R',function(file){shiny::req(result());writeLines(code(),file)})
 output$musse_pdf<-shiny::downloadHandler('guane-musse.pdf',function(file){shiny::req(result());s<-settings();grDevices::pdf(file,width=s$width,height=s$height);on.exit(grDevices::dev.off());draw()})
 output$musse_png<-shiny::downloadHandler('guane-musse.png',function(file){shiny::req(result());s<-settings();grDevices::png(file,width=s$width*150,height=s$height*150,res=150);on.exit(grDevices::dev.off());draw()})
 for(n in c('estimates','comparison','attempts','slices'))local({key<-n;id<-if(key=='estimates')'musse_csv' else paste0('musse_',key,'_csv');output[[id]]<-shiny::downloadHandler(paste0('guane-musse-',key,'.csv'),function(file){shiny::req(result());guane_write_csv(result()[[key]],file,row.names=FALSE)})})
 output$musse_rds<-shiny::downloadHandler('guane-musse.rds',function(file){shiny::req(result());saveRDS(list(result=result(),settings=settings()),file)})
 list(result=result,code=code)
}
