server_mod_div_ltt <- function(input,output,session,data) {
 result<-shiny::reactiveVal(NULL);status<-shiny::reactiveVal('Choose trees and run LTT.')
 value<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
 source<-shiny::reactive(value('ltt_source','data'))
 active<-shiny::reactive(if(source()=='data')data$state$tree else input$ltt_files)
 shiny::observeEvent(list(active(),source(),input$ltt_stem,input$ltt_tol),{result(NULL);status('Inputs changed. Run LTT to update results.')},ignoreNULL=FALSE)
 shiny::observeEvent(input$run_ltt,{
  result(NULL)
  tryCatch({trees<-if(source()=='data')data$state$tree else {f<-input$ltt_files;if(is.null(f))stop('Upload Newick trees first.');guane_ltt_read(f$datapath,f$name)}
   r<-guane_ltt_run(trees,isTRUE(input$ltt_stem),value('ltt_tol',1e-6));result(r);status('LTT completed. Review tree ages and sampling assumptions.');data$record('Computed lineage-through-time curve.')
  },error=function(e){status(conditionMessage(e));data$record(paste('LTT:',conditionMessage(e)))})
 })
 settings<-shiny::reactive(guane_ltt_settings(isTRUE(input$ltt_log),identical(input$ltt_direction,'backward'),value('ltt_palette','Guane'),value('ltt_width',10),value('ltt_height',7),value('ltt_dpi',150),value('ltt_line_width',2),as.numeric(value('ltt_line_type','1')),isTRUE(value('ltt_legend',TRUE)),data$lang()))
 draw<-function(){shiny::req(result());guane_ltt_plot(result(),settings())}
 output$ltt_plot<-shiny::renderPlot({draw()},width=function()settings()$width*96,height=function()settings()$height*96,res=96)
 output$ltt_status<-shiny::renderText(paste(vapply(strsplit(status(),': ',fixed=TRUE)[[1]],guane_text,character(1),lang=data$lang()),collapse=': '))
 output$ltt_summary<-shiny::renderTable({shiny::req(result());x<-attr(result(),'summary');names(x)<-vapply(names(x),guane_text,character(1),lang=data$lang());x},digits=6)
 output$ltt_table<-shiny::renderTable({shiny::req(result());head(as.data.frame(result()),100)},digits=6)
 output$ltt_diagnostics<-shiny::renderText({shiny::req(result());i<-attr(result(),'inputs');paste(guane_text('Validated rooted ultrametric trees; no taxa or branches were changed.',data$lang()),paste('ape',utils::packageVersion('ape'),'| tol =',i$tol,'| include_stem =',i$include_stem),guane_text('Overlays are individual curves, not confidence bands. Compare trees only when branch-length units and sampling are compatible.',data$lang()),sep='\n')})
 code<-shiny::reactive({shiny::req(result());guane_ltt_script(result(),settings=settings())})
 output$ltt_code<-shiny::renderText({if(is.null(result()))return(paste('# guane_ltt_run(trees, include_stem, tol)',paste('include_stem =',isTRUE(input$ltt_stem),'| tol =',value('ltt_tol',1e-6)),sep='\n'));paste(code(),collapse='\n')})
 output$ltt_csv<-shiny::downloadHandler('guane-ltt.csv',function(file){shiny::req(result());utils::write.csv(result(),file,row.names=FALSE)})
 output$ltt_script<-shiny::downloadHandler('guane-ltt.R',function(file)writeLines(code(),file))
 output$ltt_pdf<-shiny::downloadHandler('guane-ltt.pdf',function(file){shiny::req(result());s<-settings();grDevices::pdf(file,width=s$width,height=s$height);on.exit(grDevices::dev.off());draw()})
 output$ltt_png<-shiny::downloadHandler('guane-ltt.png',function(file){shiny::req(result());s<-settings();grDevices::png(file,width=s$width,height=s$height,units='in',res=s$dpi);on.exit(grDevices::dev.off());draw()})
 output$ltt_rds<-shiny::downloadHandler('guane-ltt.rds',function(file){shiny::req(result());saveRDS(list(result=result(),settings=settings()),file)})
 list(result=result,code=code)
}
