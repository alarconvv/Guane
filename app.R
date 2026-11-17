# Development entry point; installed users call guane::run_app().
# To launch one primary module: guane::run_app("signal"), "asr", "div" or "sse".

if (dir.exists(".guane-library")) {
  .libPaths(c(normalizePath(".guane-library"), .libPaths()))
}

# Optional deployment settings.
# Development machines can leave these unset.
guane_host <- Sys.getenv("GUANE_HOST", "")
guane_port <- Sys.getenv("GUANE_PORT", "")

if (nzchar(guane_host)) {
  options(shiny.host = guane_host)
}

if (nzchar(guane_port)) {
  options(shiny.port = as.integer(guane_port))
}

pkgload::load_all(".", quiet = TRUE)

app_guane()
