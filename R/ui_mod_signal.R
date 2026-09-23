ui_mod_signal <- function(id) {
 bslib::navset_card_pill(id=shiny::NS(id)("analysis"),
  ui_mod_signal_data(id),
  ui_mod_signal_signal(id),
  ui_mod_signal_PGLS(id),
  ui_mod_signal_PagelReg(id),
  ui_mod_signal_PGLM(id))
}
