
# keep the environment active
source("renv/activate.R")


local({
  options(
    repos = c(CRAN = "https://cloud.r-project.org"),
    shiny.autoreload = TRUE,
    usethis.protocol = "https"
  )

  if (interactive()) {
    message("Guane project loaded. Use devtools::load_all(); guane::run_app()")
  }
})
