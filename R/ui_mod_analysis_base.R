# One primary module: the shared Data card plus its analysis cards (see guane_cards).
ui_mod_family <- function(id) {
 cards<-lapply(guane_cards[[id]],function(card) get(paste0('ui_mod_',id,'_',card),mode='function')(id))
 do.call(bslib::navset_card_pill,c(list(id=shiny::NS(id)('analysis'),ui_mod_data_base(id)),cards))
}

# Shared presentation shell; card implementations remain in separate files.
ui_mod_analysis_base <- function(id, key, title, controls, results, diagnostics, mirror) {
 ns<-shiny::NS(id)
 bslib::nav_panel(title,value=key,
  shiny::div(class='guane-analysis-grid',
   bslib::card(bslib::card_header('Analysis controls'),controls),
   bslib::card(bslib::navset_tab(id=ns(paste0(key,'_view')),
    bslib::nav_panel('Results',value='results',results),
    bslib::nav_panel('Diagnostics',value='diagnostics',diagnostics),
    bslib::nav_panel('Live Code Mirror',value='code',mirror)))))
}
