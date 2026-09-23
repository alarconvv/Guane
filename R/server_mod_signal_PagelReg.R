server_mod_signal_PagelReg <- function(input, output, session, data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Select two binary traits and run the test.')
 shiny::observeEvent(list(data$state$traits,data$taxon()),{
  cols<-setdiff(names(data$state$traits),data$taxon())
  cols<-cols[vapply(data$state$traits[cols],function(x) !anyNA(x) && length(unique(as.character(x)))==2,logical(1))]
  selected_x<-if(length(input$pagel_x)==1 && input$pagel_x %in% cols) input$pagel_x else head(cols,1)
  selected_y<-if(length(input$pagel_y)==1 && input$pagel_y %in% setdiff(cols,selected_x)) input$pagel_y else head(setdiff(cols,selected_x),1)
  shiny::updateSelectInput(session,'pagel_x',choices=cols,selected=selected_x)
  shiny::updateSelectInput(session,'pagel_y',choices=cols,selected=selected_y)
 },ignoreNULL=FALSE)
 shiny::observeEvent(list(data$state$tree,data$state$traits,data$taxon(),input$pagel_x,input$pagel_y,input$pagel_starts,input$pagel_max),{
  result(NULL);status('Inputs changed. Run the correlation test to update results.')
 },ignoreInit=TRUE)
 shiny::observeEvent(input$pagel_run,{
  result(NULL)
  tryCatch({
   fit<-shiny::withProgress(message="Fitting Pagel's correlation",value=.2,guane_pagel(data$state$tree,data$state$traits,data$taxon(),input$pagel_x,input$pagel_y,input$pagel_starts,input$pagel_max))
   result(fit);status('Correlation test completed. Review convergence and state counts.');data$record("Pagel's correlation completed.")
   for(w in fit$warnings) data$record(paste('Pagel:',w))
  },error=function(e) {status(conditionMessage(e));data$record(paste('Pagel:',conditionMessage(e)))})
 })
 output$pagel_readiness<-shiny::renderText({
  t<-data$state$traits
  if(is.null(t)) return('Load a tree and traits in Data. Select two distinct binary columns.')
  cols<-setdiff(names(t),data$taxon())
  n<-sum(vapply(t[cols],function(x) !anyNA(x) && length(unique(as.character(x)))==2,logical(1)))
  if(n<2) 'Two binary columns are required. Each must contain exactly two observed states and no missing values.' else 'Two binary traits are available. Resolve taxon mismatches in Data before running.'
 })
 output$pagel_rates<-shiny::renderTable({shiny::req(result());result()$rates},digits=5)
 output$pagel_status<-shiny::renderText(status())
 model<-shiny::reactive(if(is.null(input$pagel_graph)) 'dependent' else input$pagel_graph)
 palette<-shiny::reactive(if(is.null(input$pagel_palette)) 'Guane' else input$pagel_palette)
 draw<-function() guane_pagel_plot(result(),model(),palette(),isTRUE(input$pagel_width),data$lang())
 output$pagel_plot<-shiny::renderPlot({shiny::validate(shiny::need(!is.null(result()),'Run the correlation test on matched data to display results.'));draw()},res=110)
 output$pagel_mapping<-shiny::renderTable({shiny::req(result());tab<-result()$mapping;names(tab)<-vapply(names(tab),guane_text,character(1),lang=data$lang());tab})
 output$pagel_comparison<-shiny::renderTable({shiny::req(result());result()$comparison},digits=4)
 output$pagel_test<-shiny::renderTable({shiny::req(result());transform(result()$test,P=format.pval(P,digits=4,eps=1e-6))},digits=4)
 output$pagel_counts<-shiny::renderTable({shiny::req(result());result()$counts})
 output$pagel_attempts<-shiny::renderTable({shiny::req(result());result()$diagnostics},digits=4)
 output$pagel_warnings<-shiny::renderUI({shiny::req(result());messages<-if(length(result()$warnings)) result()$warnings else 'No fitting warnings reported. Inspect diagnostics before interpretation.';shiny::tagList(lapply(messages,shiny::p))})
 code<-shiny::reactive({shiny::req(result());guane_pagel_script(result(),model(),palette(),isTRUE(input$pagel_width),data$lang())})
 output$pagel_code<-shiny::renderText({if(is.null(result())) return('Run the correlation test on matched data to display results.');paste(code(),collapse='\n')})
 output$pagel_script<-shiny::downloadHandler('guane-pagel-correlation.R',function(file) writeLines(code(),file))
 output$pagel_pdf<-shiny::downloadHandler('guane-pagel.pdf',function(file){shiny::req(result());grDevices::pdf(file,width=8,height=7);on.exit(grDevices::dev.off());draw()})
 output$pagel_csv<-shiny::downloadHandler('guane-pagel-rates.csv',function(file){shiny::req(result());utils::write.csv(result()$rates,file,row.names=FALSE)})
 output$pagel_summary_csv<-shiny::downloadHandler('guane-pagel-models.csv',function(file){shiny::req(result());utils::write.csv(cbind(result()$comparison,result()$test[rep(1,2),,drop=FALSE]),file,row.names=FALSE)})
 list(result=result,code=code)
}
