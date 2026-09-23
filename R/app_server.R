#' Connect the primary module servers.
#' @export
app_server <- function(modules=c('signal','asr','div','sse')) {
 function(input,output,session) {
  setNames(lapply(modules,function(m) get(paste0('server_mod_',m),mode='function')(m, lang=shiny::reactive(if(is.null(input$lang)) 'en' else input$lang))),modules)
 }
}
