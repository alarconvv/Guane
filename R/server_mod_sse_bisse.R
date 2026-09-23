server_mod_sse_bisse <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Select a binary trait and run BiSSE.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 options<-shiny::reactive(list(trait=input$bisse_trait,state0=input$bisse_state0,models=value('bisse_models',character()),sampling=c(value('bisse_rho0',1),value('bisse_rho1',1)),survival=isTRUE(value('bisse_survival',TRUE)),root=value('bisse_root','OBS'),root_p=if(identical(value('bisse_root','OBS'),'GIVEN'))c(value('bisse_root0',.5),1-value('bisse_root0',.5)) else c(.5,.5),parameter_text=value('bisse_parameters',''),optimizer=value('bisse_optimizer','nlminb'),starts=value('bisse_starts',3),maxit=value('bisse_maxit',500),backend=value('bisse_backend',guane_bisse_backend()),tolerance=value('bisse_tol',1e-8),eps=value('bisse_eps',0),slices=isTRUE(value('bisse_slices',TRUE)),verify=isTRUE(value('bisse_verify',TRUE))))
 shiny::observeEvent(list(data$state$traits,data$taxon()),{
  cols<-setdiff(names(data$state$traits),data$taxon());cols<-cols[vapply(data$state$traits[cols],function(x)!anyNA(x)&&length(unique(as.character(x)))==2,logical(1))]
  selected<-if(length(input$bisse_trait)==1&&input$bisse_trait%in%cols)input$bisse_trait else head(cols,1)
  shiny::updateSelectInput(session,'bisse_trait',choices=cols,selected=selected)
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(input$bisse_trait,data$state$traits),{
  x<-if(length(input$bisse_trait)==1)data$state$traits[[input$bisse_trait]] else NULL;states<-sort(unique(as.character(x)))
  selected<-if(length(input$bisse_state0)==1&&input$bisse_state0%in%states)input$bisse_state0 else head(states,1)
  shiny::updateSelectInput(session,'bisse_state0',choices=states,selected=selected)
 },ignoreNULL=FALSE)
 shiny::observeEvent(input$bisse_fill,{
  tryCatch({guane_ltt(data$state$tree);tab<-guane_bisse_parameters(data$state$tree);text<-paste(capture.output(utils::write.csv(tab,row.names=FALSE,na='')),collapse='\n');shiny::updateTextAreaInput(session,'bisse_parameters',value=text)},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),options()),{result(NULL);status('BiSSE inputs changed. Run again to update results.')},ignoreInit=TRUE)
 shiny::observeEvent(input$bisse_run,{
  result(NULL)
  tryCatch({r<-shiny::withProgress(message=guane_text('Fitting BiSSE models',data$lang()),value=.1,do.call(guane_bisse_fit,c(list(tree=data$state$tree,traits=data$state$traits,taxon=data$taxon()),options())));result(r);status(if(any(r$comparison$Converged))'BiSSE completed. Review convergence, bounds and model assumptions.' else 'No valid BiSSE fit. Inspect diagnostics.');data$record('BiSSE analysis completed.');for(w in r$warnings)data$record(paste('BiSSE:',w))},error=function(e){status(conditionMessage(e));data$record(paste('BiSSE:',conditionMessage(e)))})
 })
 shiny::observeEvent(result(),{r<-result();if(is.null(r))return();choices<-r$comparison$Model;valid<-choices[r$comparison$Converged];shiny::updateSelectInput(session,'bisse_plot_model',choices=choices,selected=if(length(input$bisse_plot_model)==1&&input$bisse_plot_model%in%choices)input$bisse_plot_model else if(length(valid))valid[1] else choices[1])})
 shiny::observeEvent(list(result(),input$bisse_plot_model),{r<-result();if(is.null(r))return();f<-r$fits[[value('bisse_plot_model','Full')]];choices<-if(isTRUE(f$valid))f$constraint$free else guane_bisse_names();shiny::updateSelectInput(session,'bisse_plot_parameter',choices=choices,selected=if(length(input$bisse_plot_parameter)==1&&input$bisse_plot_parameter%in%choices)input$bisse_plot_parameter else head(choices,1))})
 shiny::observeEvent(input$bisse_profile_run,{
  tryCatch({shiny::req(result());r<-result();p<-shiny::withProgress(message=guane_text('Profile likelihood',data$lang()),value=.1,guane_bisse_profile(r,input$bisse_plot_model,input$bisse_plot_parameter,input$bisse_profile_lower,input$bisse_profile_upper,input$bisse_profile_points,input$bisse_profile_level,r$inputs$maxit));p$model<-input$bisse_plot_model;r$profile<-p
   if(p$better){r$fits[[p$model]]$better_failed<-TRUE;r$comparison$Weight<-NA_real_;r$warnings<-unique(c(r$warnings,'A profile found a better likelihood. Refit before interpretation.'))}
   result(r);status(p$warning);data$record(paste('SSE profile:',p$model,p$settings$parameter));shiny::updateSelectInput(session,'bisse_graph',selected='profile')
  },error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(input$bisse_profile_lower,input$bisse_profile_upper,input$bisse_profile_points,input$bisse_profile_level),{r<-result();if(!is.null(r)&&!is.null(r$profile)){r$profile<-NULL;result(r)}},ignoreInit=TRUE)
 output$bisse_profile_interval<-shiny::renderTable({shiny::req(result()$profile);translate(result()$profile$interval)},digits=6)
 output$bisse_profile_curve<-shiny::renderTable({shiny::req(result()$profile);translate(result()$profile$curve)},digits=6)
 output$bisse_profile_csv<-shiny::downloadHandler('guane-bisse-profile.csv',function(file){shiny::req(result()$profile);utils::write.csv(result()$profile$curve,file,row.names=FALSE)})
 output$bisse_interval_csv<-shiny::downloadHandler('guane-bisse-interval.csv',function(file){shiny::req(result()$profile);utils::write.csv(result()$profile$interval,file,row.names=FALSE)})
 translate<-function(x){if(is.null(x))return(NULL);for(n in intersect(c('LowerStatus','UpperStatus'),names(x)))x[[n]]<-vapply(x[[n]],guane_text,character(1),lang=data$lang());if('Model'%in%names(x))x$Model<-vapply(x$Model,guane_text,character(1),lang=data$lang());names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 output$bisse_status<-shiny::renderText(guane_text(status(),data$lang()))
 for(n in c('mapping','estimates','comparison','diagnostics','attempts'))local({key<-n;output[[paste0('bisse_',key)]]<-shiny::renderTable({shiny::req(result());translate(result()[[key]])},digits=6)})
 output$bisse_constraints<-shiny::renderTable({shiny::req(result());translate(do.call(rbind,lapply(names(result()$fits),function(m){f<-result()$fits[[m]];if(!f$valid)return(NULL);cbind(Model=m,f$constraint$table)})))},digits=6)
 output$bisse_warnings<-shiny::renderText({shiny::req(result());r<-result();paste(c(vapply(r$warnings,guane_text,character(1),lang=data$lang()),unlist(lapply(r$fits,`[[`,'numerical_messages'))),collapse='\n')})
 output$bisse_interpretation<-shiny::renderText({shiny::req(result());d<-result()$comparison;if(anyNA(d$Weight))return(guane_text('BiSSE ranking weights are unavailable. Inspect individual fits and diagnostics.',data$lang()));paste(guane_text('Lowest AIC among selected models:',data$lang()),guane_text(d$Model[which.min(d$AIC)],data$lang()))})
 output$bisse_metadata<-shiny::renderText({shiny::req(result());r<-result();paste('diversitree',r$version,'| n =',length(r$states),'| sampling.f =',paste(r$inputs$sampling,collapse=', '),'| root =',r$inputs$root,'| condition.surv =',r$inputs$survival)})
 settings<-shiny::reactive(guane_bisse_settings(type=value('bisse_graph','rates'),model=value('bisse_plot_model','Full'),parameter=value('bisse_plot_parameter','lambda0'),palette=value('bisse_palette','Guane'),labels=isTRUE(value('bisse_labels',TRUE)),label_size=value('bisse_font',.7),width=value('bisse_width',10),height=value('bisse_height',7),lang=data$lang()))
 draw<-function(){shiny::req(result());tryCatch(guane_bisse_plot(result(),settings()),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$bisse_plot<-shiny::renderPlot(draw(),width=function()settings()$width*96,height=function()settings()$height*96,res=96)
 code<-shiny::reactive({if(is.null(result()))return(c('# Proposed BiSSE settings. No fit has been performed.',guane_r_assignment('analysis_settings',options()),'# result <- do.call(guane_bisse_fit, c(list(tree=tree, traits=traits, taxon=taxon), analysis_settings))'));guane_bisse_script(result(),settings())})
 output$bisse_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$bisse_script<-shiny::downloadHandler('guane-bisse.R',function(file){shiny::req(result());writeLines(code(),file)})
 output$bisse_pdf<-shiny::downloadHandler('guane-bisse.pdf',function(file){shiny::req(result());s<-settings();grDevices::pdf(file,width=s$width,height=s$height);on.exit(grDevices::dev.off());draw()})
 output$bisse_png<-shiny::downloadHandler('guane-bisse.png',function(file){shiny::req(result());s<-settings();grDevices::png(file,width=s$width*150,height=s$height*150,res=150);on.exit(grDevices::dev.off());draw()})
 for(n in c('estimates','comparison','attempts','slices'))local({key<-n;id<-if(key=='estimates')'bisse_csv' else paste0('bisse_',key,'_csv');output[[id]]<-shiny::downloadHandler(paste0('guane-bisse-',key,'.csv'),function(file){shiny::req(result());utils::write.csv(result()[[key]],file,row.names=FALSE)})})
 output$bisse_rds<-shiny::downloadHandler('guane-bisse.rds',function(file){shiny::req(result());saveRDS(list(result=result(),settings=settings()),file)})
 list(result=result,code=code)
}
