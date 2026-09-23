server_mod_sse <- function(id, lang=function() 'en') {
 shiny::moduleServer(id,function(input,output,session) {
  data<-server_mod_sse_data(input,output,session,lang)
  analyses<-list(bisse=server_mod_sse_bisse(input,output,session,data),
   musse=server_mod_sse_musse(input,output,session,data),
   quasse=server_mod_sse_quasse(input,output,session,data),
   hidden=server_mod_sse_hidden(input,output,session,data))
  list(data=data,analyses=analyses)
 })
}
