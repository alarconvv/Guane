server_mod_div <- function(id, lang=function() 'en') {
 shiny::moduleServer(id,function(input,output,session) {
  data<-server_mod_div_data(input,output,session,lang)
  analyses<-list(ltt=server_mod_div_ltt(input,output,session,data),rates=server_mod_div_rates(input,output,session,data),time=server_mod_div_time(input,output,session,data),clades=server_mod_div_clades(input,output,session,data),joint=server_mod_div_joint(input,output,session,data),diversity=server_mod_div_diversity(input,output,session,data))
  list(data=data,analyses=analyses)
 })
}
