#'#####################################
#'
#' Background execution of long analyses
#'
#'####################################
#'
#' Heavy fits (stochastic mapping, MCMC, SSE models, profiles, bootstraps)
#' run in a `mirai` background worker through `shiny::ExtendedTask`, so the
#' session stays responsive while an analysis runs. Under ShinyProxy each user
#' gets a container; the workers here keep that user's own interface usable.
#'
#' Configuration (options take precedence over environment variables):
#'  - `guane.async` / `GUANE_ASYNC`: `false` runs analyses in the Shiny process
#'    (accepts true/false, yes/no, 1/0, on/off).
#'  - `guane.workers` / `GUANE_WORKERS`: background R processes (default 1,
#'    clamped to the available cores).
#'  - `guane.task_timeout` / `GUANE_TASK_TIMEOUT`: seconds before a background
#'    analysis is cancelled (default 3600; 0 disables the limit).
#'
#' Core functions stay pure; only the call is moved. The worker receives the
#' function object and fully evaluated arguments, never reactives. Timed-out,
#' superseded and orphaned analyses are cancelled so they never block the next
#' run, and a crashed worker is replaced before the next dispatch.
#'
#'@author Viviana Romero Alarcon
guane_tasks_env <- new.env(parent = emptyenv())

guane_task_messages <- c(
 running = 'Analysis running in the background. You can keep exploring other results.',
 busy = 'An analysis is already running. Wait for it to finish.',
 timeout = 'The analysis exceeded the server time limit. Reduce its size or run the exported R script locally.',
 crashed = 'The analysis process stopped unexpectedly, possibly because it ran out of memory. Reduce the analysis size and run it again.',
 unavailable = 'The background analysis service is temporarily unavailable. Try again in a moment.'
)

# Read a setting from an option or environment variable. Invalid values fall back
# to `default`; numeric values are clamped to [lower, upper].
guane_task_setting <- function(option, env, default, lower = -Inf, upper = Inf) {
 value <- getOption(option)
 if (is.null(value)) {
  value <- Sys.getenv(env, '')
  if (!nzchar(value)) return(default)
 }
 if (is.logical(default)) {
  if (is.logical(value) && length(value) == 1 && !is.na(value)) return(value)
  key <- tolower(trimws(as.character(value)[1]))
  if (key %in% c('true', 't', 'yes', 'y', '1', 'on')) return(TRUE)
  if (key %in% c('false', 'f', 'no', 'n', '0', 'off')) return(FALSE)
  message('Guane: ignoring invalid value for ', env, '; using ', default, '.')
  return(default)
 }
 number <- suppressWarnings(as.numeric(value)[1])
 if (!is.finite(number)) {
  message('Guane: ignoring invalid value for ', env, '; using ', default, '.')
  return(default)
 }
 min(max(number, lower), upper)
}

guane_task_timeout <- function() {
 value <- guane_task_setting('guane.task_timeout', 'GUANE_TASK_TIMEOUT', 3600, -Inf, 7 * 86400)
 if (value < 0) {
  message('Guane: ignoring negative GUANE_TASK_TIMEOUT; using 3600. Use 0 to disable the limit.')
  return(3600)
 }
 value
}

# Source path when Guane is loaded with pkgload::load_all() rather than installed;
# workers then need the development package loaded the same way.
guane_dev_path <- function() {
 ns <- topenv(environment(guane_dev_path))
 if (!isNamespace(ns) || !identical(getNamespaceName(ns), c(name = 'guane'))) return(NULL)
 path <- getNamespaceInfo(ns, 'path')
 if (file.exists(file.path(path, 'Meta', 'package.rds'))) NULL else path
}

guane_workers_init <- function() {
 workers <- as.integer(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1, 1, max(1, parallel::detectCores(), na.rm = TRUE)))
 mirai::daemons(workers)
 # Wait until every worker has connected so each one is initialised below.
 t0 <- Sys.time()
 while (mirai::status()$connections < workers && difftime(Sys.time(), t0, units = 'secs') < 30) Sys.sleep(0.05)
 if (mirai::status()$connections < workers) stop('workers did not connect')
 # Workers must see the same libraries as this process (e.g. .guane-library),
 # and the development package when Guane runs from source via pkgload.
 dev <- guane_dev_path()
 setup <- mirai::everywhere({
  .libPaths(lib)
  if (!is.null(dev)) pkgload::load_all(dev, quiet = TRUE, export_all = TRUE, helpers = FALSE, attach_testthat = FALSE)
  TRUE
 }, lib = .libPaths(), dev = dev)
 t0 <- Sys.time()
 while (any(vapply(setup, mirai::unresolved, logical(1))) && difftime(Sys.time(), t0, units = 'secs') < 120) Sys.sleep(0.05)
 failed <- vapply(setup, function(m) mirai::unresolved(m) || !isTRUE(m$data), logical(1))
 if (any(failed)) stop('worker setup failed')
 guane_tasks_env$workers <- workers
 invisible(workers)
}

# Start (once per R process) the background workers used by all sessions.
guane_workers_start <- function() {
 if (isTRUE(guane_tasks_env$started)) return(invisible(guane_async_enabled()))
 guane_tasks_env$started <- TRUE
 guane_tasks_env$async <- FALSE
 if (!guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE)) return(invisible(FALSE))
 if (!requireNamespace('mirai', quietly = TRUE)) {
  message('Guane: package "mirai" is not installed; analyses run in the Shiny process.')
  return(invisible(FALSE))
 }
 ok <- tryCatch({guane_workers_init(); TRUE}, error = function(e) {
  message('Guane: background workers could not start (', conditionMessage(e), '); analyses run in the Shiny process.')
  FALSE
 })
 guane_tasks_env$async <- ok
 # Once workers have run, later failures never fall back to the Shiny process.
 guane_tasks_env$wanted <- ok
 invisible(ok)
}

guane_workers_restart <- function(reason) {
 message('Guane: restarting background workers (', reason, ').')
 try(mirai::daemons(0), silent = TRUE)
 guane_tasks_env$active <- 0L
 ok <- tryCatch({guane_workers_init(); TRUE}, error = function(e) FALSE)
 guane_tasks_env$async <- ok
 invisible(ok)
}

# Replace workers that died (e.g. killed for exceeding memory) before dispatching.
# With several workers, surviving ones keep serving; restart only when none is left.
guane_workers_ensure <- function() {
 if (!isTRUE(guane_tasks_env$wanted)) return(invisible(FALSE))
 alive <- tryCatch(mirai::status()$connections, error = function(e) 0L)
 if (isTRUE(guane_tasks_env$async) && length(alive) == 1 && is.numeric(alive) && alive > 0) return(invisible(TRUE))
 guane_workers_restart(paste(alive, 'workers connected'))
}

# Cancellation cannot interrupt compiled code. After a grace period, restart the
# workers if they are still executing more tasks than this process has in flight.
guane_workers_reap <- function(grace = 5) {
 later::later(function() {
  if (!isTRUE(guane_tasks_env$async)) return()
  executing <- tryCatch(mirai::status()$mirai[['executing']], error = function(e) 0L)
  active <- guane_tasks_env$active; if (is.null(active)) active <- 0L
  if (length(executing) == 1 && is.numeric(executing) && executing > active) guane_workers_restart('a cancelled analysis did not stop')
 }, grace)
}

guane_workers_stop <- function() {
 if (isTRUE(guane_tasks_env$async)) try(mirai::daemons(0), silent = TRUE)
 rm(list = ls(guane_tasks_env), envir = guane_tasks_env)
 invisible(NULL)
}

guane_async_enabled <- function() isTRUE(guane_tasks_env$async)

# Evaluated inside the worker (or in-process). Errors are returned as data so the
# exact condition message reaches the interface and its translation dictionary.
guane_task_eval <- function(fn, args) {
 warnings <- character()
 tryCatch({
  value <- withCallingHandlers(do.call(fn, args), warning = function(w) {
   warnings <<- c(warnings, conditionMessage(w))
   invokeRestart('muffleWarning')
  })
  list(ok = TRUE, value = value, warnings = warnings)
 }, error = function(e) list(ok = FALSE, message = conditionMessage(e), warnings = warnings))
}

# Cancel a background computation (no-op for in-process runs or finished tasks).
guane_task_cancel <- function(handle) {
 if (inherits(handle, 'mirai') && requireNamespace('mirai', quietly = TRUE) && mirai::unresolved(handle)) {
  mirai::stop_mirai(handle)
  guane_workers_reap()
  return(invisible(TRUE))
 }
 invisible(FALSE)
}

# Dispatch one analysis. Returns a promise that always resolves to
# list(ok, value | message, warnings). `on_start` receives the mirai handle so
# callers can cancel it.
guane_task_promise <- function(fn, args, on_start = NULL) {
 if (!isTRUE(guane_tasks_env$wanted)) return(promises::promise_resolve(guane_task_eval(fn, args)))
 guane_workers_ensure()
 # Fail closed: heavy work never falls back to the shared Shiny process.
 if (!guane_async_enabled()) return(promises::promise_resolve(list(ok = FALSE, message = guane_task_messages[['unavailable']], warnings = character())))
 state <- new.env(parent = emptyenv()); state$timed_out <- FALSE
 m <- mirai::mirai(eval_task(fn, args), eval_task = guane_task_eval, fn = fn, args = args)
 guane_tasks_env$active <- (if (is.null(guane_tasks_env$active)) 0L else guane_tasks_env$active) + 1L
 if (is.function(on_start)) on_start(m)
 timeout <- guane_task_timeout()
 cancel_timer <- if (timeout > 0) later::later(function() if (!is.null(m) && mirai::unresolved(m)) {
  state$timed_out <- TRUE; mirai::stop_mirai(m); guane_workers_reap()
 }, timeout) else function() invisible(FALSE)
 # Poll for completion on the Shiny event loop. Polling (every 0.1 s) avoids a
 # race in completion callbacks that could leave a fast task unresolved.
 promises::promise(function(resolve, reject) {
  check <- function() {
   if (mirai::unresolved(m)) return(later::later(check, 0.1))
   value <- m$data
   # Release the task and its timer so finished results are not retained.
   cancel_timer(); m <<- NULL
   guane_tasks_env$active <- max(0L, guane_tasks_env$active - 1L)
   if (!mirai::is_error_value(value) && is.list(value) && !is.null(value$ok)) return(resolve(value))
   code <- suppressWarnings(as.integer(value))
   message <- if (state$timed_out) guane_task_messages[['timeout']]
    else if (identical(code, 19L)) guane_task_messages[['crashed']]
    else if (identical(code, 20L)) 'Analysis cancelled.'
    else paste('Background task failed:', paste(format(value), collapse = ' '))
   resolve(list(ok = FALSE, message = message, warnings = character()))
  }
  check()
 })
}

#' Create a background task bound to one Run button.
#'
#' @param on_success function(value) or function(value, warnings) applied in the
#'   session when the analysis finishes; it may update reactive values and inputs.
#'   Uncaught warnings raised in the worker are passed as a character vector.
#' @param on_error function(message) applied when the analysis fails.
#' @param status optional reactiveVal receiving the running message.
#' @return list with `run(fn, args)`, `running()` and `discard()`. `run()` must be
#'   called with a plain function and a list of evaluated arguments (no reactives).
#'   `discard()` cancels a running analysis whose inputs changed and drops its result.
#' @noRd
guane_task <- function(on_success, on_error, status = NULL) {
 guane_workers_start()
 generation <- 0L
 started <- 0L
 handle <- NULL
 # Cancellation settles after session teardown; keep task internals alive until then.
 task <- shiny::withReactiveDomain(NULL, shiny::ExtendedTask$new(function(fn, args) guane_task_promise(fn, args, on_start = function(m) handle <<- m)))
 session <- shiny::getDefaultReactiveDomain()
 if (!is.null(session)) session$onSessionEnded(function() guane_task_cancel(handle))
 shiny::observeEvent(task$status(), {
  state <- task$status()
  if (!state %in% c('success', 'error')) return()
  handle <<- NULL
  if (started != generation) return()
  value <- tryCatch(task$result(), error = function(e) list(ok = FALSE, message = conditionMessage(e)))
  if (!isTRUE(value$ok)) return(on_error(value$message))
  if (length(formals(on_success)) >= 2) on_success(value$value, value$warnings) else on_success(value$value)
 }, ignoreInit = TRUE)
 list(
  run = function(fn, args = list()) {
   if (identical(shiny::isolate(task$status()), 'running')) {
    if (!is.null(status)) status(guane_task_messages[['busy']])
    return(invisible(FALSE))
   }
   generation <<- generation + 1L
   started <<- generation
   if (!is.null(status)) status(guane_task_messages[['running']])
   task$invoke(fn, args)
   invisible(TRUE)
  },
  running = function() identical(task$status(), 'running'),
  discard = function() {
   generation <<- generation + 1L
   guane_task_cancel(handle)
  }
 )
}

# Worker-side chains for analyses with two consecutive heavy steps.
guane_task_fit_map <- function(fit, fit_args, nsim, seed) {
 guane_asr_map(do.call(fit, fit_args), nsim, seed)
}
