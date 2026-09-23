#' Assemble the Guane application.
#' @export
app_guane <- function(module='full', submodule='full', default_lang='en') {
 module<-match.arg(module,c('full','signal','asr','div','sse'))
 default_lang<-match.arg(default_lang,c('en','es','pt'))
 if(!identical(submodule,'full')) stop('Select analysis cards within the primary module; submodule must be "full".')
 modules<-if(module=='full') c('signal','asr','div','sse') else module
 shiny::shinyApp(ui=app_ui(modules,default_lang),server=app_server(modules))
}
