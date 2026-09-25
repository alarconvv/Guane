# Development entry point; installed users call guane::run_app().
# To launch one primary module: guane::run_app('signal'), 'asr', 'div' or 'sse'.
if (dir.exists(".guane-library")) .libPaths(c(normalizePath(".guane-library"), .libPaths()))
pkgload::load_all(".", quiet = TRUE)
app_guane()
