server_mod_div_joint <- function(input,output,session,data) {
 joint_result<-shiny::reactiveVal(NULL);joint_status<-shiny::reactiveVal('Choose settings and run diversification models.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 options<-shiny::reactive({number<-function(n){z<-input[[n]];if(is.null(z)||!nzchar(trimws(z)))NULL else suppressWarnings(as.numeric(z))}
 list(models=if(is.null(input$joint_models))character() else input$joint_models,sampling=value('joint_sampling',1),survival=isTRUE(value('joint_survival',TRUE)),optimizer=value('joint_optimizer','nlminb'),maxit=value('joint_maxit',2000),upper=number('joint_upper'),start_lambda=number('joint_start_lambda'),start_mu=number('joint_start_mu'),intervals=isTRUE(value('joint_intervals',TRUE)),slices=isTRUE(value('joint_slices',TRUE)))})
 translate<-function(x){if(is.null(x))return(NULL);names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 shiny::observeEvent(data$state$tree,{
  choices<-tryCatch({z<-guane_rates_clade_catalog(data$state$tree)$table;z<-z[z$Node!=length(data$state$tree$tip.label)+1,,drop=FALSE];stats::setNames(z$Node,paste0(z$Node,' | n=',z$Tips,' | ',z$First_tip))},error=function(e)character())
  shiny::updateSelectizeInput(session,'joint_nodes',choices=choices,selected=character());shiny::updateTextAreaInput(session,'joint_sampling',value='');shiny::updateTextAreaInput(session,'joint_custom',value='')
 },ignoreNULL=FALSE)
 joint_options<-shiny::reactive({o<-options();c(list(tree=data$state$tree,nodes=suppressWarnings(as.numeric(value('joint_nodes',character()))),sampling=guane_rates_joint_csv(value('joint_sampling','')),models=value('joint_models',character()),custom=if('Custom'%in%value('joint_models',character()))guane_rates_joint_csv(value('joint_custom','')) else NULL,controls=guane_rates_joint_csv(value('joint_controls',''))),o[c('survival','optimizer','maxit','upper','intervals')])})
 joint_signature<-NULL
 shiny::observe({current<-list(data$state$tree,input$joint_nodes,input$joint_sampling,input$joint_models,if('Custom'%in%value('joint_models',character()))input$joint_custom else NULL,input$joint_controls,options()[c('survival','optimizer','maxit','upper','intervals')]);if(!identical(current,joint_signature)){joint_signature<<-current;joint_task$discard();joint_result(NULL);joint_status('Joint inputs changed. Run joint models to update results.')}})
 shiny::observeEvent(input$joint_fill,{
  tryCatch({r<-guane_rates_joint_data(data$state$tree,suppressWarnings(as.numeric(value('joint_nodes',character()))));ids<-r$regions$Region
   shiny::updateTextAreaInput(session,'joint_sampling',value=paste(c('Region,Sampling',paste(ids,1,sep=',')),collapse='\n'))
   shiny::updateTextAreaInput(session,'joint_custom',value=paste(c('Region,Lambda,Mu',paste(ids,paste0('lambda',ids),paste0('mu',ids),sep=',')),collapse='\n'))
  },error=function(e)joint_status(conditionMessage(e)))
 })
 joint_view<-shiny::reactive({if(!is.null(joint_result()))return(joint_result());o<-joint_options();guane_rates_joint_data(o$tree,o$nodes,o$sampling)})
 shiny::observeEvent(input$joint_preview,{tryCatch({joint_view();shiny::updateSelectInput(session,'joint_graph',selected='joint_tree');bslib::nav_select('joint_view','results',session=session);joint_status('Joint preview only. Run models to fit rates.')},error=function(e)joint_status(conditionMessage(e)))})
 joint_task<-guane_task(function(r){joint_result(r);shiny::updateSelectInput(session,'joint_plot_model',choices=r$comparison$Model,selected=r$comparison$Model[if(any(r$comparison$Converged))which(r$comparison$Converged)[1] else 1]);shiny::updateSelectInput(session,'joint_graph',selected=if(nrow(r$comparison)>1&&all(is.finite(r$comparison$DeltaAIC)))'joint_comparison' else 'joint_rates');joint_status('Joint fitting completed. Inspect convergence, boundaries and comparisons.');data$record(paste('Joint diversification shifts:',paste(r$nodes,collapse=', ')))},joint_status,joint_status)
 shiny::observeEvent(input$joint_run,{
  joint_result(NULL);tryCatch(joint_task$run(guane_rates_joint_fit,joint_options()),error=function(e)joint_status(conditionMessage(e)))
 })
 output$joint_status<-shiny::renderText(guane_text(joint_status(),data$lang()))
 output$joint_warnings<-shiny::renderText({shiny::req(joint_result());w<-joint_result()$warnings;if(!length(w))w<-'No fitting warnings reported. Inspect diagnostics before interpretation.';paste(vapply(w,guane_text,character(1),lang=data$lang()),collapse='\n')})
 output$joint_interpretation<-shiny::renderText({shiny::req(joint_result());d<-joint_result()$comparison;txt<-function(x)guane_text(x,data$lang());if(!all(is.finite(d$Weight)))return(txt('Joint ranking is unavailable; inspect candidate diagnostics.'));i<-which.min(d$AIC);paste(txt('Lowest joint AIC:'),d$Model[i],paste0('(',txt('Weight'),' = ',signif(d$Weight[i],3),').'),txt('Support is conditional on the selected shifts and candidate set.'))})
 for(field in c('comparison','estimates','attempts','constraints','controls','regions','membership','edges'))local({
  key<-field;out<-if(key=='controls')'joint_controls_table' else paste0('joint_',key)
  output[[out]]<-shiny::renderTable({shiny::req(joint_result());translate(joint_result()[[key]])},digits=6)
  output[[paste0('joint_',key,'_csv')]]<-shiny::downloadHandler(paste0('guane-joint-',key,'.csv'),function(file){shiny::req(joint_result(),joint_result()[[key]]);guane_write_csv(joint_result()[[key]],file,row.names=FALSE)})
 })
 settings<-shiny::reactive(list(type=value('joint_graph','joint_rates'),model=value('joint_plot_model','SharedBD'),parameter=value('joint_parameter','lambda'),palette=value('joint_palette','Guane'),lang=data$lang()))
 plot_settings<-shiny::reactive(c(settings(),list(labels=isTRUE(value('joint_labels',TRUE)),node_labels=isTRUE(value('joint_node_labels',TRUE)),cex=value('joint_cex',.7))))
 draw<-function(){r<-joint_view();shiny::req(r);tryCatch(do.call(guane_rates_joint_plot,c(list(result=r),plot_settings())),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$joint_plot<-shiny::renderPlot(draw(),width=960,height=672,res=96)
 code<-shiny::reactive({pending<-c('# Proposed settings; run analysis to apply.',guane_r_assignment('analysis_settings',options()),guane_r_assignment('additional_settings',joint_options()));r<-tryCatch(joint_view(),error=function(e)NULL);if(is.null(r))return(pending);c(pending,do.call(guane_rates_joint_script,c(list(result=r),plot_settings())))})
 output$joint_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$joint_script<-shiny::downloadHandler('guane-joint.R',function(file){shiny::req(joint_view());writeLines(code(),file)})
 output$joint_pdf<-shiny::downloadHandler('guane-joint.pdf',function(file){shiny::req(joint_view());grDevices::pdf(file,width=10,height=7);on.exit(grDevices::dev.off());draw()})
 output$joint_png<-shiny::downloadHandler('guane-joint.png',function(file){shiny::req(joint_view());grDevices::png(file,width=1500,height=1050,res=150);on.exit(grDevices::dev.off());draw()})
 output$joint_rds<-shiny::downloadHandler('guane-joint.rds',function(file){shiny::req(joint_view());saveRDS(list(result=joint_view(),settings=plot_settings()),file)})
 list(result=joint_result,code=code)
}
