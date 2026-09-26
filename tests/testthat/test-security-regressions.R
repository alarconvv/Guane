# Security regression tests (gate: security). Run: Rscript tests/run_gates.R security

# Inspect loaded functions so these guards also run against an installed package.
sec_sources <- function(pattern = '^(guane_|server_|ui_|app_)') {
 ns <- asNamespace('guane')
 functions <- Filter(is.function, mget(ls(ns, pattern = pattern), envir = ns))
 stopifnot(length(functions) > 0)
 unlist(lapply(functions, deparse, width.cutoff = 500), use.names = FALSE)
}

sec_data <- function() {
 ex <- guane_example(); keep <- intersect(ex$tree$tip.label, ex$traits$species)
 list(tree = ape::keep.tip(ex$tree, keep), traits = ex$traits[ex$traits$species %in% keep, , drop = FALSE])
}
# Payloads that try to break out of string literals, backticks and comments.
sec_payloads <- function(tag) c(
 sprintf("x`); file.create('PWNED_%s'); (`", tag),
 sprintf("y\"); file.create('PWNED_%s'); #", tag),
 sprintf("z\nfile.create('PWNED_%s')\n#", tag),
 sprintf("w')); file.create('PWNED_%s'); ((' ", tag))
sec_source_in_sandbox <- function(lines) {
 dir <- tempfile('guane-sec-'); dir.create(dir); old <- setwd(dir); on.exit(setwd(old), add = TRUE)
 grDevices::pdf(NULL); on.exit(grDevices::dev.off(), add = TRUE)
 env <- new.env(parent = globalenv())
 eval(parse(text = lines), env)
 list(env = env, pwned = list.files(dir, pattern = '^PWNED'))
}

# ---- F-GUARD-1 (passes today): data-derived strings never become code in exported scripts ----
test_that('exported scripts embed hostile taxon/column/state labels as data only', {
 d <- sec_data(); tr <- d$tree; tb <- d$traits
 map <- setNames(c(sec_payloads('taxon'), tr$tip.label[-(1:4)]), tr$tip.label)
 tb$species <- unname(map[as.character(tb$species)]); tr$tip.label <- unname(map[tr$tip.label])
 names(tb)[names(tb) == 'species'] <- taxon <- sec_payloads('col')[1]
 names(tb)[names(tb) == 'body_mass'] <- resp <- sec_payloads('col')[2]
 steps <- list(guane_r_assignment('tree', tr), guane_r_assignment('traits', tb),
  sprintf('traits[[%s]] <- traits[[%s]]^2', deparse(paste0(resp, '_quadratic')), deparse(resp)))
 s <- sec_source_in_sandbox(guane_preparation_script(steps))
 expect_length(s$pwned, 0); expect_identical(s$env$traits[names(tb)], tb)
 fit <- guane_pgls(tr, tb, taxon, resp, 'body_length')
 expect_length(sec_source_in_sandbox(guane_pgls_script(fit))$pwned, 0)
 tb$disc <- rep(c("a`)\nfile.create('PWNED_s')\n(`", "b\")\nfile.create('PWNED_s')\n#", "c'{file.create('PWNED_s')}'"), length.out = nrow(tb))
 mk <- guane_asr_mk(tr, tb, taxon, 'disc', model = 'ER', compare = FALSE)
 expect_length(sec_source_in_sandbox(guane_asr_mk_script(mk))$pwned, 0)
})

# ---- F-GUARD-2 (passes today): no dynamic code evaluation / formula parsing of user strings ----
test_that('R sources contain no eval/parse/str2lang/as.formula on dynamic strings', {
 src <- sec_sources()
 expect_false(any(grepl('\\b(parse|str2lang|str2expression|as\\.formula|system2?|readRDS|load)\\s*\\(', src) & !grepl('^\\s*#', src)))
 # reformulate() is only allowed on Guane-generated internal names (.x1, .response).
 refs <- grep('reformulate\\(', src, value = TRUE)
 expect_true(all(grepl('reformulate\\(paste0\\([\"\']\\.x', refs)))
})

test_that('hostile column names cannot execute through the PGLS formula', {
 d <- sec_data(); tb <- d$traits; dir <- tempfile(); dir.create(dir); old <- setwd(dir); on.exit(setwd(old))
 names(tb)[names(tb) == 'body_mass'] <- "file.create('PWNED_formula')"
 fit <- guane_pgls(d$tree, tb, 'species', "file.create('PWNED_formula')", 'body_length')
 expect_false(file.exists('PWNED_formula'))
})

# ---- F-01 (fails today): Mk "effective settings preview" pastes raw seed/nsim inputs ----
test_that('Mk code preview never contains raw client strings for seed/nsim', {
 guane_test_mode(FALSE)
 shiny::testServer(server_mod_family, args = list(id = 'asr'), {
  session$setInputs(example = 1, taxon = 'species', seed = 11)
  st <- session$returned$data$state; d <- sec_data(); st$tree <- d$tree; st$traits <- d$traits
  session$flushReact()
  session$setInputs(mk_trait = 'habitat_binary', mk_model = 'ER', mk_framework = 'simmap',
   mk_seed = "1); file.create('PWNED'); (1", mk_nsim = "100); system('id'); (1")
  expect_false(grepl('file.create|system\\(', output$mk_code))
 })
})

# Resolve a task promise by running the event loop, as Shiny does.
sec_await <- function(p, timeout = 30) {
 out <- NULL; done <- FALSE
 promises::then(p, function(v) {out <<- v; done <<- TRUE})
 t0 <- Sys.time()
 while (!done && difftime(Sys.time(), t0, units = 'secs') < timeout) later::run_now(0.05)
 list(done = done, value = out, seconds = as.numeric(difftime(Sys.time(), t0, units = 'secs')))
}

# ---- F-02: a timed-out task is cancelled and never blocks the next one ----
test_that('background timeout cancels the running task', {
 skip_if_not_installed('mirai')
 guane_test_mode(TRUE, workers = 1, timeout = 1); on.exit(guane_test_mode(FALSE))
 expect_true(guane_workers_start())
 r1 <- sec_await(guane_task_promise(function() { Sys.sleep(8); 1 }, list()), 6)
 expect_true(r1$done); expect_false(r1$value$ok)
 expect_identical(r1$value$message, guane_task_messages[['timeout']])
 r2 <- sec_await(guane_task_promise(function() 1, list()), 5)
 expect_true(r2$done); expect_true(isTRUE(r2$value$ok)); expect_identical(r2$value$value, 1)
 expect_lt(r2$seconds, 3)
})

# ---- F-03: a crashed worker is replaced ----
test_that('tasks still run after a worker process dies', {
 skip_if_not_installed('mirai')
 guane_test_mode(TRUE, workers = 1, timeout = 10); on.exit(guane_test_mode(FALSE))
 expect_true(guane_workers_start())
 r1 <- sec_await(guane_task_promise(function() tools::pskill(Sys.getpid(), 9L), list()), 15)
 expect_true(r1$done); expect_false(r1$value$ok)
 Sys.sleep(1)
 r2 <- sec_await(guane_task_promise(function() 42, list()), 30)
 expect_true(r2$done); expect_true(isTRUE(r2$value$ok)); expect_identical(r2$value$value, 42)
})

# ---- F-04 (fails today): input size caps ----
test_that('oversized trees are rejected before analysis', {
 tr <- ape::rtree(20001); tb <- data.frame(sp = tr$tip.label, x = stats::rnorm(20001))
 expect_true(any(guane_validate(tr, tb, 'sp', 'x')$level == 'Error'))
})

# ---- F-05 (fails today): diversity-dependent settings are bounded ----
test_that('DDD numeric settings have upper bounds', {
 tr <- phytools::pbtree(n = 30, scale = 10)
 expect_error(guane_dd_fit(tr, missing = 1e7), 'Invalid numeric settings')
 expect_error(guane_dd_fit(tr, cycles = 1e9), 'Invalid numeric settings')
 expect_error(guane_dd_fit(tr, maxiter = 1e12), 'Invalid numeric settings')
})

# ---- F-06 (fails today): CSV exports neutralise spreadsheet formulas ----
# Fix introduces guane_write_csv(); all downloadHandlers must use it instead of write.csv.
test_that('CSV exports prefix formula-leading cells and are centralised', {
 f <- tempfile(fileext = '.csv')
 guane_write_csv(data.frame(species = c('=1+1', '@SUM(1)', '+2', '-2+3', 'ok'), x = c(1, 2, 3, -4, 5)), f)
 z <- utils::read.csv(f, stringsAsFactors = FALSE)
 expect_false(any(grepl('^[=+@-]', z$species)))
 expect_equal(z$x, c(1, 2, 3, -4, 5))  # numeric negatives are untouched
 src <- sec_sources('^server_')
 # Every file download goes through guane_write_csv(); write.csv/write.table may
 # only format text for input boxes via capture.output().
 calls <- regmatches(src, gregexpr('(capture\\.output\\((utils::)?)?write\\.(csv|table)\\(', src))
 expect_true(all(grepl('^capture', unlist(calls))))
})

# ---- F-07 (fails today): JS dictionary lookup ignores Object.prototype keys ----
test_that('i18n JS does not translate prototype keys', {
 skip_if_not_installed('V8')
 js <- readLines(file.path(guane_resource_root(), 'www', 'guane-i18n.js'), warn = FALSE, encoding = 'UTF-8')
 ctx <- V8::v8(); ctx$eval('var window={addEventListener:function(){}};')
 ctx$assign('dictionaryJSON', paste(readLines(file.path(guane_resource_root(), 'i18n', 'translations.json'), warn = FALSE, encoding = 'UTF-8'), collapse = '\n'))
 ctx$eval('var document={getElementById:function(){return {textContent:dictionaryJSON};}};')
 ctx$eval(paste(sub('^const guaneTranslations', 'var guaneTranslations', js), collapse = '\n'))
 for (k in c('constructor', '__proto__', 'toString'))
  expect_true(ctx$eval(sprintf('!(guaneLookup(%s) || dynamicTranslation(%s))', jsonlite::toJSON(k, auto_unbox = TRUE), jsonlite::toJSON(k, auto_unbox = TRUE))) == 'true', info = k)
})

# ---- F-08 (fails today): invalid env settings fail closed ----
test_that('invalid GUANE_TASK_TIMEOUT / GUANE_WORKERS fall back to safe defaults', {
 withr::local_envvar(GUANE_TASK_TIMEOUT = 'abc', GUANE_WORKERS = '100000')
 withr::local_options(guane.task_timeout = NULL, guane.workers = NULL)
 expect_identical(guane_task_timeout(), 3600)
 expect_lte(guane_task_setting('guane.workers', 'GUANE_WORKERS', 1, 1, parallel::detectCores()), parallel::detectCores())
 withr::local_envvar(GUANE_ASYNC = 'maybe'); withr::local_options(guane.async = NULL)
 expect_true(guane_task_setting('guane.async', 'GUANE_ASYNC', TRUE))
})

# ---- Upload and resource limits ----
test_that('the app sets an explicit upload cap and uploads use size-checked readers', {
 withr::local_options(shiny.maxRequestSize = NULL)
 app_guane('signal')
 expect_identical(getOption('shiny.maxRequestSize'), 5 * 1024^2)
 withr::local_envvar(GUANE_MAX_UPLOAD_MB = '500'); app_guane('signal')
 expect_identical(getOption('shiny.maxRequestSize'), 100 * 1024^2)  # clamped
 src <- sec_sources('^server_')
 expect_false(any(grepl('read\\.(csv|table|tree|nexus)\\(', src)))
})

test_that('oversized trait tables are rejected while reading', {
 withr::local_options(guane.max_rows = 100)
 f <- tempfile(fileext = '.csv'); utils::write.csv(data.frame(sp = paste0('s', 1:500), x = 1:500), f, row.names = FALSE)
 expect_error(guane_read_traits(f), 'exceeds the maximum size')
 f2 <- tempfile(fileext = '.nwk'); ape::write.tree(ape::rtree(200), f2)
 withr::local_options(guane.max_tips = 100)
 expect_error(guane_read_tree(f2), 'maximum number of tips')
})

test_that('workers receive only functions and data, never session objects', {
 src <- deparse(guane_task_promise, width.cutoff = 500)
 expect_true(any(grepl('mirai::mirai\\(eval_task\\(fn, args\\), eval_task = guane_task_eval, fn = fn, args = args\\)', src)))
 # Every task$run() call site passes a named package function, not an inline closure.
 src <- sec_sources('^server_')
 calls <- unlist(regmatches(src, gregexpr('_task\\$run\\([^,]+', src)))
 expect_true(length(calls) >= 25)
 expect_false(any(grepl('function\\s*\\(', calls)))
})

# ---- N-1: finished results are not retained by timeout timers ----
test_that('memory from finished background results is released', {
 skip_if_not_installed('mirai')
 guane_test_mode(TRUE, workers = 1, timeout = 3600); on.exit(guane_test_mode(FALSE))
 expect_true(guane_workers_start())
 big <- function() numeric(25e6)  # ~200 MB
 invisible(gc()); base <- gc()[2, 2]
 for (i in 1:3) { r <- sec_await(guane_task_promise(big, list()), 60); expect_true(isTRUE(r$value$ok)); r <- NULL }
 invisible(gc())
 expect_lt(gc()[2, 2], base + 250)
})

# ---- N-2: a cancelled task stuck in compiled code does not block the worker ----
test_that('workers are restarted when a cancelled task keeps running in compiled code', {
 skip_if_not_installed('mirai')
 guane_test_mode(TRUE, workers = 1, timeout = 2); on.exit(guane_test_mode(FALSE))
 expect_true(guane_workers_start())
 stuck <- function() { m <- matrix(stats::runif(4e6), 2000); for (i in 1:200) m <- crossprod(m) / 2000; 1 }
 r1 <- sec_await(guane_task_promise(stuck, list()), 20)
 expect_identical(r1$value$message, guane_task_messages[['timeout']])
 options(guane.task_timeout = 60)
 t0 <- Sys.time(); r2 <- sec_await(guane_task_promise(function() 42, list()), 60)
 expect_true(isTRUE(r2$value$ok)); expect_lt(as.numeric(difftime(Sys.time(), t0, units = 'secs')), 15)
})

# ---- N-3: negative timeouts do not disable the limit ----
test_that('negative timeouts fall back to the default limit', {
 withr::local_options(guane.task_timeout = -5)
 expect_identical(suppressMessages(guane_task_timeout()), 3600)
 withr::local_options(guane.task_timeout = 0)
 expect_identical(guane_task_timeout(), 0)
})

# ---- N-4: DDD resolution is capped ----
test_that('diversity-dependent resolution is capped', {
 tr <- phytools::pbtree(n = 30, scale = 10)
 expect_error(guane_dd_fit(tr, res = 6000), 'Invalid model or likelihood settings')
 expect_error(guane_dd_fit(tr, missing = 290, res = NULL, models = 1)$comparison, NA)
})

# ---- N-5: after workers have run, failures never fall back to the Shiny process ----
test_that('the task layer fails closed when workers cannot be restarted', {
 skip_if_not_installed('mirai')
 guane_test_mode(TRUE, workers = 1); on.exit(guane_test_mode(FALSE))
 expect_true(guane_workers_start())
 mirai::daemons(0)
 local_mocked_bindings(guane_workers_init = function() stop('no workers'))
 r <- sec_await(guane_task_promise(function() Sys.getpid(), list()), 10)
 expect_false(isTRUE(r$value$ok))
 expect_identical(r$value$message, guane_task_messages[['unavailable']])
})

# ---- N-6: the LTT settings preview never shows raw client text as code ----
test_that('LTT preview comments out settings and formats tolerance', {
 guane_test_mode(FALSE)
 shiny::testServer(server_mod_family, args = list(id = 'div'), {
  session$setInputs(ltt_tol = "1e-6\nfile.create('PWNED')")
  expect_false(grepl('\nfile.create', output$ltt_code, fixed = TRUE))
  expect_match(output$ltt_code, '# include_stem')
 })
})
