ui_mod_sse <- function(id) {
 bslib::navset_card_pill(id=shiny::NS(id)('analysis'),
  ui_mod_sse_data(id),ui_mod_sse_bisse(id),ui_mod_sse_musse(id),
  ui_mod_sse_quasse(id),ui_mod_sse_hidden(id))
}
