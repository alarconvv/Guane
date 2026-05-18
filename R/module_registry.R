guane_module_registry <- function() {
  list(
    signal = list(
      label = "Phylogenetic signal",
      ui = mod_signal_ui,
      server = mod_signal_server
    )
  )
}
