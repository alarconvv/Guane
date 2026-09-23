# Shared presentation shell; card implementations remain in separate files.
ui_mod_analysis_base <- function(id, key, title, controls, results, diagnostics, mirror) {
 ns<-shiny::NS(id)
 bslib::nav_panel(title,value=key,
  shiny::div(class='guane-analysis-grid',
   bslib::card(bslib::card_header('Analysis controls'),controls),
   bslib::card(bslib::navset_tab(id=ns(paste0(key,'_view')),
    bslib::nav_panel('Results',value='results',results),
    bslib::nav_panel('Diagnostics',value='diagnostics',diagnostics),
    bslib::nav_panel('Live Code Mirror',value='code',mirror),
    bslib::nav_panel('Chatbot',value='chatbot',shiny::p('Chatbot is planned. No messages are sent and no AI service is connected.'))))))
}
