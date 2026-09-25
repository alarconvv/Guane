# Analysis cards per primary module; each card has ui_mod_<module>_<card> and server_mod_<module>_<card>.
guane_cards <- list(signal=c('signal','PGLS','PagelReg','PGLM'), asr=c('continuous','discrete','poly'),
 div=c('ltt','rates','time','clades','joint','diversity'), sse=c('bisse','musse','quasse','hidden'))

# One primary module: the shared Data card plus its analysis cards.
server_mod_family <- function(id, lang=function() 'en') {
 shiny::moduleServer(id,function(input,output,session) {
  data<-server_mod_data_base(input,output,session,lang)
  analyses<-sapply(guane_cards[[id]],function(card) get(paste0('server_mod_',id,'_',card),mode='function')(input,output,session,data),simplify=FALSE)
  list(data=data,analyses=analyses)
 })
}

#' Connect the primary module servers.
#' @export
app_server <- function(modules=c('signal','asr','div','sse')) {
 function(input,output,session) {
  setNames(lapply(modules,function(m) server_mod_family(m, lang=shiny::reactive(if(is.null(input$lang)) 'en' else input$lang))),modules)
 }
}
