#' Assemble the Guane application.
#' @export
app_guane <- function(module='full', default_lang='en') {
  
 module<-match.arg(module,c('full','signal','asr','div','sse'))
 
 default_lang<-match.arg(default_lang,c('en','es','pt'))
 
 modules<-if(module=='full') c('signal','asr','div','sse') else module
 
 # Uploads are small text files; keep Shiny's request cap explicit (MB via GUANE_MAX_UPLOAD_MB).
 
 options(shiny.maxRequestSize=guane_task_setting('guane.max_upload_mb','GUANE_MAX_UPLOAD_MB',5,1,100)*1024^2)
 
 shiny::shinyApp(ui=app_ui(modules,default_lang),server=app_server(modules))
 
}
