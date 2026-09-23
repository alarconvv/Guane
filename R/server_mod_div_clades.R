server_mod_div_clades <- function(input,output,session,data) {
 clade_result<-shiny::reactiveVal(NULL);clade_status<-shiny::reactiveVal('Choose settings and run diversification models.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 options<-shiny::reactive({number<-function(n){z<-input[[n]];if(is.null(z)||!nzchar(trimws(z)))NULL else suppressWarnings(as.numeric(z))}
 list(models=if(is.null(input$clade_models))character() else input$clade_models,sampling=value('clade_sampling',1),survival=isTRUE(value('clade_survival',TRUE)),optimizer=value('clade_optimizer','nlminb'),maxit=value('clade_maxit',2000),upper=number('clade_upper'),start_lambda=number('clade_start_lambda'),start_mu=number('clade_start_mu'),intervals=isTRUE(value('clade_intervals',TRUE)),slices=isTRUE(value('clade_slices',TRUE)))})
 translate<-function(x){if(is.null(x))return(NULL);names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x}
 # Clade snapshots are independent of whole-tree fits and time-model diagnostics.
 shiny::observeEvent(data$state$tree,{
  choices<-tryCatch({z<-guane_rates_clade_catalog(data$state$tree)$table;stats::setNames(z$Node,paste0(z$Node,' | n=',z$Tips,' | ',z$First_tip,ifelse(nzchar(z$Label),paste0(' | ',z$Label),'')))},error=function(e)character())
  shiny::updateSelectizeInput(session,'clade_nodes',choices=choices,selected=character())
  shiny::updateTextAreaInput(session,'clade_sampling',value='')
 },ignoreNULL=FALSE)
 clade_options<-shiny::reactive({o<-options();o$sampling<-NULL;c(o,list(profiles=isTRUE(value('clade_profiles',TRUE)),level=value('clade_level',.95),points=value('clade_points',31)))})
 clade_selection<-shiny::reactive({nodes<-suppressWarnings(as.numeric(value('clade_nodes',character())));guane_rates_clade_select(data$state$tree,nodes,guane_rates_clade_sampling(value('clade_sampling',''),nodes))})
 clade_signature<-NULL
 shiny::observeEvent(list(data$state$tree,input$clade_nodes,input$clade_sampling,clade_options()),{
  current<-list(data$state$tree,input$clade_nodes,input$clade_sampling,clade_options())
  if(!identical(current,clade_signature)){clade_result(NULL);clade_status('Clade inputs changed. Run clade models to update results.');clade_signature<<-current}
 },ignoreNULL=FALSE)
 shiny::observeEvent(input$clade_fill,{
  nodes<-suppressWarnings(as.numeric(value('clade_nodes',character())))
  if(length(nodes))shiny::updateTextAreaInput(session,'clade_sampling',value=paste(c('Node,Sampling',paste(nodes,1,sep=',')),collapse='\n'))
 })
 shiny::observeEvent(input$clade_preview_run,{
  tryCatch({clade_selection();shiny::updateSelectInput(session,'clade_graph',selected='clade_tree');bslib::nav_select('clades_view','results',session=session);clade_status('Preview only. Run clade models to fit the selected crowns.')},error=function(e)clade_status(conditionMessage(e)))
 })
 shiny::observeEvent(input$clade_run,{
  clade_result(NULL)
  tryCatch({
   selection<-clade_selection()
   r<-shiny::withProgress(message=guane_text('Fitting selected crown clades',data$lang()),value=.1,do.call(guane_rates_clade_fit,c(list(tree=data$state$tree,nodes=selection$clades$Node,sampling=selection$clades[,c('Node','Sampling')]),clade_options())))
   clade_result(r);shiny::updateSelectInput(session,'clade_plot_node',choices=as.character(r$clades$Node),selected=as.character(r$clades$Node[1]))
   shiny::updateSelectInput(session,'clade_plot_model',choices=options()$models,selected=options()$models[1])
   shiny::updateSelectInput(session,'clade_graph',selected='clade_rates')
   clade_status(if(any(r$audit$Successful_models>0))'Clade analysis completed. Review each clade separately.' else 'No valid clade fits. Inspect the clade audit.')
   data$record(paste('Clade diversification:',paste(r$clades$Node,collapse=', ')))
  },error=function(e)clade_status(conditionMessage(e)))
 })
 clade_settings<-shiny::reactive(list(node=value('clade_plot_node',NULL),labels=isTRUE(value('clade_labels',TRUE)),node_labels=isTRUE(value('clade_node_labels',TRUE)),cex=value('clade_cex',.7)))
 clade_view<-shiny::reactive({if(!is.null(clade_result()))clade_result() else clade_selection()})
 output$clade_status<-shiny::renderText(guane_text(clade_status(),data$lang()))
 output$clade_summary<-shiny::renderTable({shiny::req(clade_result());translate(clade_result()$clades)},digits=6)
 output$clade_interpretation<-shiny::renderText({
  shiny::req(clade_result());r<-clade_result();txt<-function(x)guane_text(x,data$lang())
  paste(txt('Successful clade-model fits:'),sum(r$audit$Successful_models),'/',sum(r$audit$Requested_models),'|',txt('Tips outside selected crowns:'),length(r$excluded),txt('Rate differences are descriptive; no between-clade significance test is performed.'))
 })
 output$clade_estimates<-shiny::renderTable({shiny::req(clade_result());translate(guane_rates_clade_table(clade_result(),'estimates'))},digits=6)
 output$clade_comparison<-shiny::renderTable({shiny::req(clade_result());translate(guane_rates_clade_table(clade_result(),'comparison'))},digits=6)
 output$clade_attempts<-shiny::renderTable({shiny::req(clade_result());translate(guane_rates_clade_table(clade_result(),'attempts'))},digits=6)
 output$clade_audit<-shiny::renderTable({shiny::req(clade_result());d<-clade_result()$audit;d$Message<-vapply(strsplit(d$Message,' | ',fixed=TRUE),function(z)paste(vapply(z,guane_text,character(1),lang=data$lang()),collapse=' | '),character(1));translate(d)})
 output$clade_profile_table<-shiny::renderTable({shiny::req(clade_result());d<-guane_rates_clade_table(clade_result(),'profile');if(!is.null(d))for(n in c('Lower_status','Upper_status'))d[[n]]<-vapply(d[[n]],guane_text,character(1),lang=data$lang());translate(d)},digits=6)
 for(field in c('estimates','comparison','attempts','profiles','profile_curves','slices'))local({
  key<-field;output[[paste0('clade_',key,'_csv')]]<-shiny::downloadHandler(paste0('guane-clade-',key,'.csv'),function(file){shiny::req(clade_result());d<-guane_rates_clade_table(clade_result(),if(key=='profiles')'profile' else key);shiny::req(d);utils::write.csv(d,file,row.names=FALSE)})
 })
 output$clade_members_csv<-shiny::downloadHandler('guane-clade-membership.csv',function(file){shiny::req(clade_result());utils::write.csv(clade_result()$membership,file,row.names=FALSE)})
 output$clade_manifest_csv<-shiny::downloadHandler('guane-clade-settings.csv',function(file){shiny::req(clade_result());utils::write.csv(clade_result()$clades,file,row.names=FALSE)})
 output$clade_audit_csv<-shiny::downloadHandler('guane-clade-audit.csv',function(file){shiny::req(clade_result());utils::write.csv(clade_result()$audit,file,row.names=FALSE)})
 output$clade_trees<-shiny::downloadHandler('guane-crown-clades.zip',function(file){
  shiny::req(clade_result());r<-clade_result();folder<-tempfile('guane-clades-');dir.create(folder);on.exit(unlink(folder,recursive=TRUE))
  paths<-vapply(r$clades$Node,function(node){z<-r$trees[[as.character(node)]];path<-file.path(folder,paste0('Node_',node,'.nwk'));ape::write.tree(z,file=path,digits=17);path},character(1))
  utils::zip(zipfile=file,files=paths,flags='-j')
 })
 settings<-shiny::reactive(list(type=value('clade_graph','clade_rates'),model=value('clade_plot_model','Yule'),parameter=value('clade_parameter','lambda'),palette=value('clade_palette','Guane'),lang=data$lang()))
 plot_settings<-shiny::reactive(c(settings(),clade_settings()))
 draw<-function(){r<-clade_view();shiny::req(r);tryCatch(do.call(guane_rates_clade_plot,c(list(result=r),plot_settings())),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),data$lang()))))}
 output$clade_plot<-shiny::renderPlot(draw(),width=960,height=672,res=96)
 code<-shiny::reactive({pending<-c('# Proposed settings; run analysis to apply.',guane_r_assignment('analysis_settings',options()),guane_r_assignment('additional_settings',clade_options()));r<-tryCatch(clade_view(),error=function(e)NULL);if(is.null(r))return(pending);c(pending,do.call(guane_rates_clade_script,c(list(result=r),plot_settings())))})
 output$clade_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$clade_script<-shiny::downloadHandler('guane-clade.R',function(file){shiny::req(clade_view());writeLines(code(),file)})
 output$clade_pdf<-shiny::downloadHandler('guane-clade.pdf',function(file){shiny::req(clade_view());grDevices::pdf(file,width=10,height=7);on.exit(grDevices::dev.off());draw()})
 output$clade_png<-shiny::downloadHandler('guane-clade.png',function(file){shiny::req(clade_view());grDevices::png(file,width=1500,height=1050,res=150);on.exit(grDevices::dev.off());draw()})
 output$clade_rds<-shiny::downloadHandler('guane-clade.rds',function(file){shiny::req(clade_view());saveRDS(list(result=clade_view(),settings=plot_settings()),file)})
 list(result=clade_result,code=code)
}
