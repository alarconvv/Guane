server_mod_signal_PGLS <- function(input, output, session, data) {
 comparison<-shiny::reactiveVal(NULL)
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Choose variables and run PGLS.')
 shiny::observeEvent(data$state$traits,{
  cols<-names(data$state$traits)[vapply(data$state$traits,is.numeric,logical(1))]
  shiny::updateSelectInput(session,'pgls_response',choices=cols,selected=if(length(input$pgls_response)==1 && input$pgls_response %in% cols) input$pgls_response else cols[1])
  shiny::updateSelectInput(session,'pgls_predictors',choices=cols,selected=intersect(input$pgls_predictors,cols))
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),input$pgls_response,input$pgls_predictors,input$pgls_model,input$pgls_value,input$pgls_fixed,input$pgls_method),{
  comparison(NULL);result(NULL);status('Inputs changed. Run PGLS to update results.')
 },ignoreInit=TRUE)
 shiny::observeEvent(input$pgls_run,{
  result(NULL)
  tryCatch({
   fit<-guane_pgls(data$state$tree,data$state$traits,data$taxon(),input$pgls_response,input$pgls_predictors,input$pgls_model,input$pgls_value,isTRUE(input$pgls_fixed),input$pgls_method)
   result(fit);status('PGLS completed. Review residual diagnostics and fit warnings.');data$record('PGLS completed.')
   for(w in fit$warnings) data$record(paste('PGLS warning:',w))
  },error=function(e) {status(conditionMessage(e));data$record(paste('PGLS:',conditionMessage(e)))})
 })
 shiny::observeEvent(input$pgls_compare_run,{
  comparison(NULL)
  tryCatch({
   r<-guane_pgls_compare(data$state$tree,data$state$traits,data$taxon(),input$pgls_response,input$pgls_predictors,input$pgls_value,isTRUE(input$pgls_fixed))
   comparison(r);status('Comparison finished. Review failed models and warnings.');data$record('PGLS ML covariance comparison completed.')
  },error=function(e) status(conditionMessage(e)))
 })
 output$pgls_comparison<-shiny::renderTable({shiny::req(comparison());tab<-comparison()$table;names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab},digits=4)
 output$pgls_comparison_plot<-shiny::renderPlot({shiny::req(comparison());guane_pgls_compare_plot(comparison(),color(),data$lang())},res=110)
 output$pgls_comparison_csv<-shiny::downloadHandler('guane-pgls-comparison.csv',function(file){shiny::req(comparison());utils::write.csv(comparison()$table,file,row.names=FALSE)})
 output$pgls_comparison_script<-shiny::downloadHandler('guane-pgls-comparison.R',function(file){shiny::req(comparison());writeLines(guane_pgls_compare_script(comparison(),color(),data$lang()),file)})
 output$pgls_comparison_pdf<-shiny::downloadHandler('guane-pgls-comparison.pdf',function(file){shiny::req(comparison());grDevices::pdf(file,width=9,height=6);on.exit(grDevices::dev.off());guane_pgls_compare_plot(comparison(),color(),data$lang())})
 output$pgls_comparison_code<-shiny::renderText({shiny::req(comparison());paste(guane_pgls_compare_script(comparison(),color(),data$lang()),collapse='\n')})
 output$pgls_status<-shiny::renderText(status())
 plot_type<-shiny::reactive(if(is.null(input$pgls_plot_type)) 'fit' else input$pgls_plot_type)
 color<-shiny::reactive(if(is.null(input$pgls_color)) '#34765b' else input$pgls_color)
 draw<-function(type=plot_type()) guane_pgls_plot(result(),type,color(),isTRUE(input$pgls_labels),guane_pgls_plot_text(data$lang()))
 output$pgls_plot<-shiny::renderPlot({shiny::req(result());draw()},res=110)
 output$pgls_diagnostics<-shiny::renderPlot({shiny::req(result());draw('diagnostics')},res=110)
 output$pgls_coefficients<-shiny::renderTable({shiny::req(result());tab<-result()$coefficients;names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab},digits=5)
 output$pgls_metadata<-shiny::renderText({shiny::req(result());r<-result();paste(paste(r$response,'~',paste(r$predictors,collapse=' + ')),r$model,r$method,paste('n =',nrow(r$points)),paste('logLik =',round(as.numeric(stats::logLik(r$fit)),3)),paste(names(r$parameter),round(r$parameter,4),collapse='; '),sep=' | ')})
 output$pgls_warnings<-shiny::renderText({shiny::req(result());if(length(result()$warnings)) paste(result()$warnings,collapse='\n') else 'No fitting warnings reported. Inspect diagnostics before interpretation.'})
 output$pgls_details<-shiny::renderPrint({shiny::req(result());summary(result()$fit)})
 code<-shiny::reactive({shiny::req(result());guane_pgls_script(result(),plot_type(),color(),isTRUE(input$pgls_labels),data$lang())})
 output$pgls_code<-shiny::renderText(paste(code(),collapse='\n'))
 output$pgls_script<-shiny::downloadHandler('guane-pgls-graph.R',function(file) writeLines(code(),file))
 output$pgls_pdf<-shiny::downloadHandler('guane-pgls.pdf',function(file){shiny::req(result());grDevices::pdf(file,width=9,height=6);on.exit(grDevices::dev.off());draw()})
 output$pgls_csv<-shiny::downloadHandler('guane-pgls-coefficients.csv',function(file){shiny::req(result());utils::write.csv(result()$coefficients,file,row.names=FALSE)})
 list(result=result,code=code,comparison=comparison)
}
