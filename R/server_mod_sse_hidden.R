server_mod_sse_hidden <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Select a binary trait and run hidden-state models.')
 value<-function(n,d)if(is.null(input[[paste0('hidden_',n)]]))d else input[[paste0('hidden_',n)]]
 options<-shiny::reactive(list(trait=input$hidden_trait,state0=input$hidden_state0,models=value('models',character()),eps_mode=value('eps_mode','Shared'),sampling=c(value('sampling0',1),value('sampling1',1)),survival=isTRUE(value('survival',TRUE)),root_type=value('root_type','madfitz'),root_mode=value('root_mode','Likelihood'),root0=value('root0',.5),starts=value('starts',2),seed=value('seed',999),sann=isTRUE(value('sann',FALSE)),sann_its=value('sann_its',1000),tolerance=value('tolerance',1e-8),turnover_start=value('turnover_start',.5),eps_start=value('eps_start',.2),transition_start=value('transition_start',.1),turnover_upper=value('turnover_upper',100),eps_upper=value('eps_upper',3),transition_upper=value('transition_upper',100),ode_eps=value('ode_eps',0),custom_classes=as.numeric(value('custom_classes',2)),turnover_text=value('turnover_text',''),eps_text=value('eps_text',''),transition_text=value('transition_text',''),verify=isTRUE(value('verify',TRUE)),maxeval=value('maxeval',100000)))
 shiny::observeEvent(list(data$state$traits,data$taxon()),{
  cols<-setdiff(names(data$state$traits),data$taxon());cols<-cols[vapply(data$state$traits[cols],function(x)!anyNA(x)&&length(unique(x))==2,logical(1))]
  selected<-if(length(input$hidden_trait)==1&&input$hidden_trait%in%cols)input$hidden_trait else head(cols,1)
  shiny::updateSelectInput(session,'hidden_trait',choices=cols,selected=selected)
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(data$state$traits,input$hidden_trait),{
  shiny::req(input$hidden_trait);x<-sort(unique(as.character(data$state$traits[[input$hidden_trait]])));selected<-if(length(input$hidden_state0)==1&&input$hidden_state0%in%x)input$hidden_state0 else head(x,1);shiny::updateSelectInput(session,'hidden_state0',choices=x,selected=selected)
 },ignoreNULL=TRUE)
 shiny::observeEvent(input$hidden_fill,{
  tryCatch({o<-options();s<-guane_hidden_spec('Custom',o$eps_mode,o$custom_classes);m<-s$trans;m[is.na(m)]<-0;shiny::updateTextInput(session,'hidden_turnover_text',value=paste(s$turnover,collapse=','));shiny::updateTextInput(session,'hidden_eps_text',value=paste(s$eps,collapse=','));shiny::updateTextAreaInput(session,'hidden_transition_text',value=paste(apply(m,1,paste,collapse=','),collapse='\n'))},error=function(e)status(conditionMessage(e)))
 })
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),options()),{result(NULL);status('Hidden-state inputs changed. Run again to update results.')},ignoreInit=TRUE)
 shiny::observeEvent(input$hidden_run,{
  result(NULL)
  tryCatch({r<-shiny::withProgress(message=guane_text('Fitting Hidden-state models',data$lang()),value=.1,do.call(guane_hidden_fit,c(list(tree=data$state$tree,traits=data$state$traits,taxon=data$taxon()),options())));result(r);status(if(any(r$comparison$Finite))'Hidden-state fitting finished. Review finite fits, starts and backend limitations.' else 'No finite hidden-state fit. Inspect diagnostics.');data$record('Hidden-state analysis completed.');for(w in r$warnings)data$record(paste('Hidden-state:',w))},error=function(e){status(conditionMessage(e));data$record(paste('Hidden-state:',conditionMessage(e)))})
 })
 shiny::observeEvent(result(),{r<-result();if(is.null(r))return();shiny::updateSelectInput(session,'hidden_plot_model',choices=names(r$fits),selected=if(value('plot_model','HiSSE')%in%names(r$fits))value('plot_model','HiSSE') else names(r$fits)[1])})
 translate<-function(x){if(is.null(x))return(NULL);if('Model'%in%names(x))x$Model<-vapply(x$Model,guane_text,character(1),lang=data$lang());names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 output$hidden_status<-shiny::renderText(guane_text(status(),data$lang()))
 for(n in c('estimates','comparison','attempts'))local({key<-n;output[[paste0('hidden_',key)]]<-shiny::renderTable({shiny::req(result());translate(result()[[key]])},digits=6)})
 output$hidden_constraints<-shiny::renderPrint({shiny::req(result());result()$specs})
 output$hidden_warnings<-shiny::renderText({shiny::req(result());r<-result();paste(c(vapply(r$warnings,guane_text,character(1),lang=data$lang()),unlist(lapply(r$fits,`[[`,'numerical_messages'))),collapse='\n')})
 output$hidden_metadata<-shiny::renderText({shiny::req(result());r<-result();paste('hisse',r$version,'| n =',length(r$states),'| root:',r$inputs$root_type,'| sampling:',paste(r$inputs$sampling,collapse=', '))})
 output$hidden_interpretation<-shiny::renderText({shiny::req(result());guane_text(if(anyNA(result()$comparison$Weight))'Model weights withheld: inspect termination, verification, starts, boundaries and duplicate constraints.' else 'Model weights describe only the compatible verified candidate set; they do not establish causality.',data$lang())})
 settings<-shiny::reactive(guane_hidden_settings(value('graph','rates'),value('plot_model','HiSSE'),value('palette','Guane'),isTRUE(value('labels',TRUE)),value('font',.7),value('width',10),value('height',7),data$lang()))
 draw<-function(){shiny::req(result());tryCatch(guane_hidden_plot(result(),settings()),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$hidden_plot<-shiny::renderPlot(draw(),width=function()settings()$width*96,height=function()settings()$height*96,res=96)
 code<-shiny::reactive({if(is.null(result()))return(c('# Proposed Hidden-state settings; no fit performed.',guane_r_assignment('analysis_settings',options())));guane_hidden_script(result(),settings())})
 output$hidden_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$hidden_script<-shiny::downloadHandler('guane-hidden.R',function(file){shiny::req(result());writeLines(code(),file)})
 output$hidden_pdf<-shiny::downloadHandler('guane-hidden.pdf',function(file){shiny::req(result());s<-settings();grDevices::pdf(file,width=s$width,height=s$height);on.exit(grDevices::dev.off());draw()})
 output$hidden_png<-shiny::downloadHandler('guane-hidden.png',function(file){shiny::req(result());s<-settings();grDevices::png(file,width=s$width*150,height=s$height*150,res=150);on.exit(grDevices::dev.off());draw()})
 for(n in c('estimates','comparison','attempts','transitions'))local({key<-n;id<-if(key=='estimates')'hidden_csv' else paste0('hidden_',key,'_csv');output[[id]]<-shiny::downloadHandler(paste0('guane-hidden-',key,'.csv'),function(file){shiny::req(result());utils::write.csv(result()[[key]],file,row.names=FALSE)})})
 output$hidden_rds<-shiny::downloadHandler('guane-hidden.rds',function(file){shiny::req(result());saveRDS(list(result=result(),settings=settings()),file)})
 list(result=result,code=code)
}
