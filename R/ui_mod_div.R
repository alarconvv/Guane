ui_mod_div <- function(id) {
 bslib::navset_card_pill(id=shiny::NS(id)('analysis'),
 ui_mod_div_data(id),ui_mod_div_ltt(id),ui_mod_div_rates(id),
 ui_mod_div_time(id),ui_mod_div_clades(id),ui_mod_div_joint(id),ui_mod_div_diversity(id))
}
