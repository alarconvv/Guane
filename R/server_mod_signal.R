server_mod_signal <- function(id, lang=function() 'en') {
 shiny::moduleServer(id,function(input,output,session) {
  data<-server_mod_signal_data(input,output,session,lang)
  analyses<-list(signal=server_mod_signal_signal(input,output,session,data),PGLS=server_mod_signal_PGLS(input,output,session,data),PagelReg=server_mod_signal_PagelReg(input,output,session,data),PGLM=server_mod_signal_PGLM(input,output,session,data))
  list(data=data,analyses=analyses)
 })
}
