# Support code for the functional (end-to-end) gate. Sourced by
# test-functional-*.R; not a test file itself and not a testthat helper, so it
# is never loaded by the unit, integration or security gates.
#
# The app is launched from the repository's development entry point (app.R),
# which sources R/ into one environment. Background workers (mirai) receive
# those closures intact, so GUANE_ASYNC=true exercises real worker execution.

guane_ft_running <- 'Analysis running in the background. You can keep exploring other results.'

guane_ft_root <- function() normalizePath(testthat::test_path('..', '..'), mustWork = TRUE)

guane_ft_skip <- function() {
 testthat::skip_if_not_installed('shinytest2')
 testthat::skip_if_not_installed('chromote')
 if (!nzchar(Sys.getenv('CHROMOTE_CHROME'))) {
  bundled <- '/opt/pw-browsers/chromium-1194/chrome-linux/chrome'
  if (file.exists(bundled)) Sys.setenv(CHROMOTE_CHROME = bundled)
 }
 chrome <- tryCatch(chromote::find_chrome(), error = function(e) NULL)
 if (is.null(chrome) || !nzchar(chrome)) testthat::skip('No Chrome/Chromium available for functional tests.')
 # Chromium refuses to start its sandbox as root (containers, CI).
 if (identical(unname(Sys.info()[['effective_user']]), 'root') || identical(unname(Sys.info()[['user']]), 'root')) {
  args <- chromote::default_chrome_args()
  if (!'--no-sandbox' %in% args) chromote::set_chrome_args(c(args, '--no-sandbox'))
 }
 invisible(TRUE)
}

# A fresh Chrome per app. Under testthat, AppDriver first opens (and never
# closes) a probe session; with chromote 0.4 + Chromium >= 141 a second
# Target.createTarget carrying width/height fails with "Target position can only
# be set for new windows". Sessions are therefore created without a position
# and AppDriver sets the viewport itself afterwards.
guane_ft_chromote <- function() {
 obj <- chromote::Chromote$new()
 original <- obj$new_session
 unlockBinding('new_session', obj)
 obj$new_session <- function(width = NULL, height = NULL, targetId = NULL, wait_ = TRUE)
  original(width = width, height = height, targetId = targetId, wait_ = wait_)
 lockBinding('new_session', obj)
 chromote::set_default_chromote_object(obj)
 obj
}

# Launch the full app in headless Chromium from `app_dir` (default: the
# repository root, i.e. the development entry point app.R). Returns the driver;
# call guane_ft_stop() when done.
guane_ft_app <- function(async = TRUE, workers = 1, name = 'guane', app_dir = guane_ft_root(), env = character()) {
 guane_ft_skip()
 browser <- guane_ft_chromote()
 base <- c(GUANE_ASYNC = if (async) 'true' else 'false', GUANE_WORKERS = as.character(workers), GUANE_TASK_TIMEOUT = '0')
 env <- c(env, base[setdiff(names(base), names(env))])
 # In a non-UTF-8 (C) locale non-ASCII UI
 # labels would be mangled, so give the app process a UTF-8 locale when possible.
 if (!isTRUE(l10n_info()[['UTF-8']])) env <- c(env, LC_ALL = 'C.UTF-8', LANG = 'C.UTF-8')
 app <- withr::with_envvar(env, shinytest2::AppDriver$new(app_dir, name = name, load_timeout = 180 * 1000, timeout = 60 * 1000,
  width = 1400, height = 1000, seed = 11, view = FALSE, clean_logs = FALSE))
 attr(app, 'guane_browser') <- browser
 app
}

guane_ft_stop <- function(app) {
 try(app$stop(), silent = TRUE)
 browser <- attr(app, 'guane_browser')
 if (!is.null(browser)) try(browser$close(), silent = TRUE)
 invisible(NULL)
}

guane_ft_text_js <- function(app, selector) {
 x <- app$get_js(sprintf("(function(){var e=document.querySelector(%s);return e?e.textContent:'';})()", jsonlite::toJSON(selector, auto_unbox = TRUE)))
 trimws(x)
}

# Browser-side problems: console errors and uncaught exceptions.
guane_ft_browser_errors <- function(app) {
 logs <- as.data.frame(app$get_logs())
 logs[logs$location == 'chromote' & logs$level %in% c('error', 'throw', 'exception'), c('level', 'message'), drop = FALSE]
}

guane_ft_text <- function(app, id) {
 x <- app$get_js(sprintf("(function(){var e=document.getElementById('%s');return e ? e.textContent : null;})()", id))
 if (is.null(x)) NA_character_ else trimws(x)
}

# Wait until a status text output is non-empty and no longer the running message
# (in any language). Returns the final text.
guane_ft_wait_status <- function(app, id, timeout = 240, ignore = character()) {
 ignore_js <- jsonlite::toJSON(c(ignore, ''), auto_unbox = FALSE)
 app$wait_for_js(sprintf(
  "(function(){var e=document.getElementById('%s'); if(!e) return false; var t=e.textContent.trim();
    if(e.classList.contains('recalculating')) return false;
    if(%s.indexOf(t) >= 0) return false;
    return !/running in the background|en ejecuci\\u00f3n en segundo plano|em execu\\u00e7\\u00e3o em segundo plano/i.test(t);})()",
  id, ignore_js), timeout = timeout * 1000, interval = 250)
 app$wait_for_idle(duration = 300, timeout = 60 * 1000)
 guane_ft_text(app, id)
}

guane_ft_select <- function(app, module, card = NULL) {
 guane_ft_set(app, module = module)
 if (!is.null(card)) do.call(guane_ft_set, c(list(app), stats::setNames(list(card), paste0(module, "-analysis"))))
 app$wait_for_idle(duration = 200)
 invisible(app)
}

# Data tab: load the example, check the Sp20 mismatch report, then match.
guane_ft_prepare <- function(app, module, check_mismatch = FALSE) {
 guane_ft_select(app, module, 'data')
 app$click(paste0(module, '-example'))
 app$wait_for_idle(duration = 300)
 if (check_mismatch) {
  do.call(guane_ft_set, c(list(app), stats::setNames(list("checks"), paste0(module, "-view"))))
  app$wait_for_idle(duration = 300)
  mismatch <- guane_ft_text(app, paste0(module, '-diagnostics'))
 } else mismatch <- NULL
 app$click(paste0(module, '-match'))
 app$wait_for_idle(duration = 300)
 list(mismatch = mismatch, activity = guane_ft_text(app, paste0(module, '-activity')))
}

guane_ft_plot_src <- function(app, output) {
 v <- app$get_value(output = output)
 if (is.list(v) && !is.null(v$src)) v$src else ''
}

# Poll a text output until it equals `expected` (or the timeout elapses).
guane_ft_wait_text <- function(app, id, expected, timeout = 20) {
 t0 <- Sys.time()
 repeat {
  x <- guane_ft_text(app, id)
  if (identical(enc2utf8(x), enc2utf8(expected)) || difftime(Sys.time(), t0, units = 'secs') > timeout) return(x)
  Sys.sleep(.25)
 }
}

# set_inputs() without waiting for an output change (many inputs here only
# affect client-side translation or re-select the current tab), then idle.
guane_ft_set <- function(app, ...) {
 app$set_inputs(..., wait_ = FALSE)
 app$wait_for_idle(duration = 300, timeout = 60 * 1000)
 invisible(app)
}
