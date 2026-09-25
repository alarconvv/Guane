# Shared fixtures for all gates. Tests run with pkgload::load_all() or R CMD check.
guane_test_data <- function() {
 d <- guane_example()
 keep <- intersect(d$tree$tip.label, d$traits$species)
 list(tree = ape::keep.tip(d$tree, keep), traits = d$traits[d$traits$species %in% keep, , drop = FALSE], taxon = 'species')
}

# Load the synthetic example into a module's data layer and remove the
# intentional Sp20 mismatch so analyses can run.
guane_test_prepare <- function(session) {
 session$setInputs(example = 1, taxon = 'species', seed = 11)
 st <- session$returned$data$state; d <- guane_test_data()
 st$tree <- d$tree; st$traits <- d$traits
 session$flushReact()
 invisible(st)
}

guane_running_message <- 'Analysis running in the background. You can keep exploring other results.'

# Drive the event loop until `done()` is TRUE (background promises resolve here).
guane_poll <- function(session, done, timeout = 120) {
 t0 <- Sys.time()
 repeat {
  later::run_now(0.05); session$flushReact()
  if (isTRUE(done())) return(invisible(TRUE))
  if (difftime(Sys.time(), t0, units = 'secs') > timeout) return(invisible(FALSE))
 }
}

# Click a Run button and wait until the status output leaves the running message.
guane_click <- function(session, output, button, status_id, inputs = list(), timeout = 180) {
 if (length(inputs)) do.call(session$setInputs, inputs)
 do.call(session$setInputs, stats::setNames(list(stats::runif(1)), button))
 guane_poll(session, function() !identical(output[[status_id]], guane_running_message), timeout)
 output[[status_id]]
}

# Reset the per-process worker state so each test controls async mode explicitly.
guane_test_mode <- function(async, workers = 1, timeout = 0) {
 guane_workers_stop()
 options(guane.async = async, guane.workers = workers, guane.task_timeout = timeout)
 invisible(NULL)
}
