# Unit tests: background task helpers (R/app_tasks.R), synchronous mode only.

with_task_env <- function(options = list(), env = character(), code) {
 old_opt <- options(c(list(guane.async = NULL, guane.workers = NULL, guane.task_timeout = NULL), options))
 on.exit(options(old_opt), add = TRUE)
 names_env <- c('GUANE_ASYNC', 'GUANE_WORKERS', 'GUANE_TASK_TIMEOUT')
 old_env <- Sys.getenv(names_env, unset = NA)
 on.exit({for (n in names_env) if (is.na(old_env[[n]])) Sys.unsetenv(n) else do.call(Sys.setenv, stats::setNames(list(old_env[[n]]), n))}, add = TRUE)
 Sys.unsetenv(names_env)
 if (length(env)) do.call(Sys.setenv, as.list(env))
 force(code)
}

resolve_promise <- function(p, timeout = 10) {
 state <- new.env(); state$done <- FALSE
 promises::then(p, onFulfilled = function(v) {state$value <- v; state$done <- TRUE}, onRejected = function(e) {state$error <- e; state$done <- TRUE})
 t0 <- Sys.time()
 while (!state$done && difftime(Sys.time(), t0, units = 'secs') < timeout) later::run_now(.05)
 state
}

test_that('guane_task_setting returns the default when neither option nor env var is set', {
 with_task_env(code = {
  expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE))
  expect_equal(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1), 1)
  expect_equal(guane_task_setting('guane.task_timeout', 'GUANE_TASK_TIMEOUT', 0), 0)
 })
})

test_that('guane_task_setting parses environment variables as logical or numeric', {
 with_task_env(env = c(GUANE_ASYNC = 'false', GUANE_WORKERS = '3', GUANE_TASK_TIMEOUT = '2.5'), code = {
  expect_false(guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE))
  expect_identical(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1), 3)
  expect_identical(guane_task_setting('guane.task_timeout', 'GUANE_TASK_TIMEOUT', 0), 2.5)
 })
 with_task_env(env = c(GUANE_ASYNC = 'TRUE'), code = expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', FALSE)))
 with_task_env(env = c(GUANE_ASYNC = 'T'), code = expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', FALSE)))
 for (v in c('true', 'True', 'yes', 'YES', '1', 'on', ' On ', 'y', 't'))
  with_task_env(env = c(GUANE_ASYNC = v), code = expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', FALSE), label = v))
 for (v in c('false', 'No', '0', 'OFF', 'n', 'F'))
  with_task_env(env = c(GUANE_ASYNC = v), code = expect_false(guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE), label = v))
 # Invalid logical values fall back to the default with a message, never an error.
 with_task_env(env = c(GUANE_ASYNC = 'maybe'), code = {
  expect_message(z <- guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE), 'ignoring invalid value for GUANE_ASYNC')
  expect_true(z)
  expect_message(z <- guane_task_setting('guane.async', 'GUANE_ASYNC', FALSE), 'invalid'); expect_false(z)
 })
 with_task_env(env = c(GUANE_ASYNC = ''), code = expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE)))
})

test_that('guane_task_setting falls back on invalid numbers and clamps to bounds', {
 with_task_env(env = c(GUANE_WORKERS = 'abc'), code = {
  expect_message(z <- guane_task_setting('guane.workers', 'GUANE_WORKERS', 1, 1, 8), 'ignoring invalid value for GUANE_WORKERS')
  expect_equal(z, 1)
 })
 with_task_env(env = c(GUANE_WORKERS = 'Inf'), code = expect_message(expect_equal(guane_task_setting('guane.workers', 'GUANE_WORKERS', 2, 1, 8), 2)))
 with_task_env(env = c(GUANE_WORKERS = '100'), code = expect_equal(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1, 1, 8), 8))
 with_task_env(env = c(GUANE_WORKERS = '-3'), code = expect_equal(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1, 1, 8), 1))
 with_task_env(options = list(guane.workers = 0.5), code = expect_equal(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1, 1, 8), 1))
})

test_that('guane_task_timeout defaults to one hour, accepts only an explicit 0 to disable, and is clamped', {
 with_task_env(code = expect_equal(guane_task_timeout(), 3600))
 with_task_env(options = list(guane.task_timeout = 0), code = expect_equal(guane_task_timeout(), 0))
 with_task_env(env = c(GUANE_TASK_TIMEOUT = '120'), code = expect_equal(guane_task_timeout(), 120))
 with_task_env(env = c(GUANE_TASK_TIMEOUT = '-5'), code = expect_message(expect_equal(guane_task_timeout(), 3600)))  # negative never disables the limit
 with_task_env(env = c(GUANE_TASK_TIMEOUT = '1e9'), code = expect_equal(guane_task_timeout(), 7 * 86400))
 with_task_env(env = c(GUANE_TASK_TIMEOUT = 'soon'), code = expect_message(expect_equal(guane_task_timeout(), 3600)))
})

test_that('guane_dev_path points at the source tree under pkgload::load_all', {
 path <- guane_dev_path()
 skip_if(is.null(path), 'Guane is installed, not loaded from source')
 expect_true(file.exists(file.path(path, 'DESCRIPTION')))
 expect_equal(unname(read.dcf(file.path(path, 'DESCRIPTION'), 'Package')[1, 1]), 'guane')
 expect_false(file.exists(file.path(path, 'Meta', 'package.rds')))
})

test_that('guane_task_setting gives options precedence over environment variables', {
 with_task_env(options = list(guane.async = TRUE, guane.workers = 2), env = c(GUANE_ASYNC = 'false', GUANE_WORKERS = '5'), code = {
  expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', FALSE))
  expect_equal(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1), 2)
 })
 with_task_env(options = list(guane.async = FALSE), env = c(GUANE_ASYNC = 'true'), code = expect_false(guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE)))
 with_task_env(options = list(guane.workers = '4'), code = expect_identical(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1), 4))
})

test_that('guane_task_eval returns ok/value and captures warnings', {
 r <- guane_task_eval(function(a, b) a + b, list(1, 2))
 expect_true(r$ok); expect_equal(r$value, 3); expect_equal(r$warnings, character())
 w <- guane_task_eval(function() {warning('first'); warning('second'); 'done'}, list())
 expect_true(w$ok); expect_equal(w$value, 'done'); expect_equal(w$warnings, c('first', 'second'))
 n <- guane_task_eval(function() NULL, list())
 expect_true(n$ok); expect_true('value' %in% names(n)); expect_null(n$value)
})

test_that('guane_task_eval returns the exact error message and warnings raised before it', {
 msg <- 'Select a discrete trait with 2 to 10 observed states.'
 e <- guane_task_eval(function() {warning('careful'); stop(msg)}, list())
 expect_false(e$ok); expect_identical(e$message, msg); expect_equal(e$warnings, 'careful')
 expect_null(e$value)
 # A real core error arrives unchanged so the interface can translate it.
 real <- guane_task_eval(guane_mk_matrix, list(states = 'a', model = 'ER'))
 expect_identical(real$message, msg)
 expect_false(identical(guane_text(real$message, 'es'), real$message))
})

test_that('guane_async_enabled is FALSE in synchronous test mode', {
 guane_test_mode(async = FALSE)
 expect_false(guane_async_enabled())
 guane_tasks_env$async <- TRUE; expect_true(guane_async_enabled())
 guane_test_mode(async = FALSE)
 expect_false(guane_async_enabled())
})

test_that('guane_workers_start with async disabled keeps analyses in-process', {
 guane_test_mode(async = FALSE)
 on.exit(guane_test_mode(async = FALSE), add = TRUE)
 expect_false(guane_workers_start())
 expect_true(guane_tasks_env$started); expect_false(guane_async_enabled())
 # Idempotent: a second start reports the current (synchronous) mode.
 expect_false(guane_workers_start()); expect_false(guane_async_enabled())
 expect_false(guane_task_cancel(NULL))
})

test_that('guane_task_promise always resolves (never rejects) in synchronous mode', {
 guane_test_mode(async = FALSE)
 p <- guane_task_promise(function(x) x * 2, list(21))
 expect_true(promises::is.promise(p))
 s <- resolve_promise(p)
 expect_true(s$done); expect_null(s$error)
 expect_true(s$value$ok); expect_equal(s$value$value, 42)
 f <- resolve_promise(guane_task_promise(function() {warning('w1'); stop('exact failure')}, list(), on_start = function(m) NULL))
 expect_null(f$error)
 expect_false(f$value$ok); expect_identical(f$value$message, 'exact failure'); expect_equal(f$value$warnings, 'w1')
 expect_setequal(names(f$value), c('ok', 'message', 'warnings'))
})

test_that('guane_task_fit_map chains an Mk fit and stochastic mapping through the task wrapper', {
 guane_test_mode(async = FALSE)
 d <- guane_test_data()
 args <- list(tree = d$tree, traits = d$traits, taxon = 'species', trait = 'habitat_binary', compare = FALSE)
 s <- resolve_promise(guane_task_promise(guane_task_fit_map, list(fit = guane_asr_mk, fit_args = args, nsim = 6, seed = 9)), timeout = 60)
 expect_true(s$value$ok)
 direct <- guane_asr_map(do.call(guane_asr_mk, args), 6, 9)
 expect_identical(s$value$value$mapping$node_states, direct$mapping$node_states)
 expect_equal(s$value$value$mapping$nsim, 6)
 bad <- guane_task_eval(guane_task_fit_map, list(fit = guane_asr_mk, fit_args = args, nsim = 1, seed = 9))
 expect_false(bad$ok); expect_identical(bad$message, 'Choose an integer number of histories between 2 and 500.')
})
