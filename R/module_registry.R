module_registry <- list(
  data_upload = list(
    label = "Data upload",
    ui = function(id, ...) {
      ui_mod_data_upload(id, ...)
    },
    server = function(id, ...) {
      server_mod_data_upload(id, ...)
    }
  ),

  signal = list(
    label = "Phylogenetic signal and comparative regression",
    ui = function(id, ...) {
      ui_mod_signal(id, ...)
    },
    server = function(id, ...) {
      server_mod_signal(id, ...)
    }
  )
)
