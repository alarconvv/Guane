# Integration gate: every Run button goes through guane_task() and the module
# servers, in background-worker mode and in-process mode.

completed <- function(status, pattern) expect_match(status, pattern, info = status)

for (mode in c('async', 'sync')) {

 test_that(paste('ASR analyses complete through the task layer -', mode), {
  guane_test_mode(mode == 'async'); on.exit(guane_test_mode(FALSE))
  shiny::testServer(server_mod_family, args = list(id = 'asr'), {
   guane_test_prepare(session)
   s <- guane_click(session, output, 'mk_run', 'mk_status', list(mk_trait = 'habitat_binary', mk_framework = 'ML', mk_model = 'ER', mk_compare = FALSE))
   completed(s, '^Mk reconstruction completed')
   r <- session$returned$analyses$discrete$result()
   expect_equal(unname(rowSums(r$probabilities)), rep(1, nrow(r$probabilities)), tolerance = 1e-8)
   s <- guane_click(session, output, 'mk_run', 'mk_status', list(mk_framework = 'simmap', mk_nsim = 20, mk_seed = 5))
   completed(s, '^Stochastic mapping completed')
   expect_equal(session$returned$analyses$discrete$result()$mapping$nsim, 20)
   s <- guane_click(session, output, 'bm_run', 'bm_status', list(bm_trait = 'body_mass', bm_framework = 'ML'))
   completed(s, '^Continuous reconstruction completed')
   s <- guane_click(session, output, 'poly_run', 'poly_status', list(poly_trait = 'resource_use_polymorphic', poly_framework = 'ML', poly_model = 'ER'))
   completed(s, '^Polymorphic reconstruction completed')
  })
 })

 test_that(paste('Diversification analyses complete through the task layer -', mode), {
  guane_test_mode(mode == 'async'); on.exit(guane_test_mode(FALSE))
  shiny::testServer(server_mod_family, args = list(id = 'div'), {
   guane_test_prepare(session)
   completed(guane_click(session, output, 'rates_run', 'rates_status', list(rates_models = c('Yule', 'BD'))), '^Rate analysis completed')
   completed(guane_click(session, output, 'rates_diagnose', 'rates_status', list(rates_nsim = 20, rates_points = 21)), '^Diagnostics completed')
   completed(guane_click(session, output, 'time_run', 'time_status', list(time_models = 'ExpYule')), '^Time-model analysis completed')
   completed(guane_click(session, output, 'dd_run', 'dd_status', list(dd_models = '1')), '^(Analysis completed|Inspect convergence)')
   # Validation errors raised inside the worker come back with their exact text.
   expect_identical(guane_click(session, output, 'clade_run', 'clade_status'), 'Select one to ten internal nodes with at least four descendant tips each.')
   expect_identical(guane_click(session, output, 'joint_run', 'joint_status'), 'Choose one to four non-root shift nodes with at least four descendant tips.')
   d <- guane_test_data(); catalog <- guane_rates_clade_catalog(d$tree)$table
   node <- catalog$Node[catalog$Node != length(d$tree$tip.label) + 1 & catalog$Tips <= length(d$tree$tip.label) - 2][1]
   completed(guane_click(session, output, 'clade_run', 'clade_status', list(clade_nodes = node, clade_models = 'Yule', clade_profiles = FALSE)), '^Clade analysis completed')
   completed(guane_click(session, output, 'joint_run', 'joint_status', list(joint_nodes = node, joint_models = 'SharedYule')), '^Joint fitting completed')
   expect_true(any(session$returned$analyses$joint$result()$comparison$Converged))
  })
 })

 test_that(paste('Signal analyses complete through the task layer -', mode), {
  guane_test_mode(mode == 'async'); on.exit(guane_test_mode(FALSE))
  shiny::testServer(server_mod_family, args = list(id = 'signal'), {
   st <- guane_test_prepare(session)
   session$setInputs(signal_trait = 'body_mass', nsim = 99, run = 1)
   guane_poll(session, function() !is.null(session$returned$analyses$signal$result()))
   expect_equal(nrow(session$returned$analyses$signal$result()), 2)
   expect_match(st$activity, '^Signal analysis completed')
   completed(guane_click(session, output, 'pgls_run', 'pgls_status', list(pgls_response = 'body_mass', pgls_predictors = 'body_length', pgls_model = 'BM', pgls_method = 'REML', pgls_value = 0.5, pgls_fixed = FALSE)), '^PGLS completed')
   completed(guane_click(session, output, 'pgls_compare_run', 'pgls_status'), '^Comparison finished')
   completed(guane_click(session, output, 'pglm_run', 'pglm_status', list(pglm_response = 'offspring_count', pglm_predictors = 'body_mass', pglm_family = 'count')), '^PGLM completed')
   completed(guane_click(session, output, 'pagel_run', 'pagel_status', list(pagel_x = 'habitat_binary', pagel_y = 'parental_care_binary', pagel_starts = 1, pagel_max = 100)), '^Correlation test completed')
  })
 })

 test_that(paste('SSE analyses complete through the task layer -', mode), {
  guane_test_mode(mode == 'async'); on.exit(guane_test_mode(FALSE))
  shiny::testServer(server_mod_family, args = list(id = 'sse'), {
   guane_test_prepare(session)
   completed(guane_click(session, output, 'bisse_run', 'bisse_status', list(bisse_trait = 'habitat_binary', bisse_state0 = 'aquatic', bisse_models = 'Full')), '^BiSSE completed')
   completed(guane_click(session, output, 'musse_run', 'musse_status', list(musse_trait = 'locomotion_3state', musse_models = 'Equal diversification and transitions', musse_starts = 1, musse_slices = FALSE)), '^MuSSE completed')
   expect_true(any(session$returned$analyses$musse$result()$comparison$Converged))
   completed(guane_click(session, output, 'hidden_run', 'hidden_status', list(hidden_trait = 'habitat_binary', hidden_state0 = 'terrestrial', hidden_models = 'BiSSE (HiSSE backend)', hidden_starts = 1, hidden_verify = FALSE, hidden_maxeval = 20)), '^Hidden-state fitting finished')
   expect_true(any(session$returned$analyses$hidden$result()$comparison$Finite))
   st <- session$returned$data$state
   st$traits$log_mass <- log(st$traits$body_mass)
   completed(guane_click(session, output, 'quasse_run', 'quasse_status', list(quasse_trait = 'log_mass', quasse_error = .1, quasse_nx = 256, quasse_r = 2, quasse_starts = 1, quasse_maxit = 200, quasse_baseline = FALSE, quasse_verify = FALSE)), '^QuaSSE completed')
   expect_true(any(session$returned$analyses$quasse$result()$comparison$Converged))
  })
 })
}

test_that('stale results are discarded and the superseded run is cancelled', {
 guane_test_mode(TRUE); on.exit(guane_test_mode(FALSE))
 shiny::testServer(server_mod_family, args = list(id = 'asr'), {
  guane_test_prepare(session)
  a <- session$returned$analyses$discrete
  session$setInputs(mk_trait = 'habitat_binary', mk_model = 'ER', mk_framework = 'simmap', mk_nsim = 500, mk_seed = 1, mk_run = 1)
  expect_identical(output$mk_status, guane_running_message)
  session$setInputs(mk_seed = 2)  # inputs change while the mapping runs
  expect_identical(output$mk_status, 'Inputs changed. Run Mk reconstruction to update results.')
  guane_poll(session, function() FALSE, 3)
  expect_null(a$result())
  # The cancelled run no longer occupies the worker: a new run finishes promptly.
  session$setInputs(mk_framework = 'ML')
  t0 <- Sys.time(); s <- guane_click(session, output, 'mk_run', 'mk_status', timeout = 30)
  expect_match(s, '^Mk reconstruction completed'); expect_lt(as.numeric(difftime(Sys.time(), t0, units = 'secs')), 15)
 })
})

test_that('a second click while running reports busy instead of queuing', {
 guane_test_mode(TRUE); on.exit(guane_test_mode(FALSE))
 shiny::testServer(server_mod_family, args = list(id = 'asr'), {
  guane_test_prepare(session)
  session$setInputs(mk_trait = 'habitat_binary', mk_model = 'ER', mk_framework = 'simmap', mk_nsim = 300, mk_seed = 1, mk_run = 1)
  session$setInputs(mk_run = 2)
  expect_identical(output$mk_status, 'An analysis is already running. Wait for it to finish.')
  guane_poll(session, function() !is.null(session$returned$analyses$discrete$result()), 120)
  expect_equal(session$returned$analyses$discrete$result()$mapping$nsim, 300)
 })
})

test_that('background and in-process runs give identical results', {
 run <- function(async) {
  guane_test_mode(async); on.exit(guane_test_mode(FALSE))
  out <- NULL
  shiny::testServer(server_mod_family, args = list(id = 'asr'), {
   guane_test_prepare(session)
   guane_click(session, output, 'mk_run', 'mk_status', list(mk_trait = 'habitat_binary', mk_model = 'ER', mk_framework = 'simmap', mk_nsim = 30, mk_seed = 9))
   out <<- session$returned$analyses$discrete$result()$mapping$node_summary
  })
  out
 }
 expect_identical(run(TRUE), run(FALSE))
})

test_that('the time limit cancels long analyses and the next run proceeds', {
 guane_test_mode(TRUE, timeout = 1); on.exit(guane_test_mode(FALSE))
 shiny::testServer(server_mod_family, args = list(id = 'asr'), {
  guane_test_prepare(session)
  s <- guane_click(session, output, 'mk_run', 'mk_status', list(mk_trait = 'habitat_binary', mk_model = 'ER', mk_framework = 'simmap', mk_nsim = 500, mk_seed = 1), timeout = 30)
  expect_identical(s, 'The analysis exceeded the server time limit. Reduce its size or run the exported R script locally.')
  # No timer for the follow-up run: under testServer's mock session a pending
  # later() timer delays promise delivery until it fires (harness artifact; the
  # real app is covered by the functional gate).
  options(guane.task_timeout = 0)
  expect_match(guane_click(session, output, 'mk_run', 'mk_status', list(mk_framework = 'ML'), timeout = 30), '^Mk reconstruction completed')
 })
})

test_that('ending a session cancels its running analysis', {
 guane_test_mode(TRUE); on.exit(guane_test_mode(FALSE))
 shiny::testServer(server_mod_family, args = list(id = 'asr'), {
  guane_test_prepare(session)
  session$setInputs(mk_trait = 'habitat_binary', mk_model = 'ER', mk_framework = 'simmap', mk_nsim = 500, mk_seed = 1, mk_run = 1)
  guane_poll(session, function() FALSE, 1)
 })
 # testServer closes the session on exit; the worker must be free again quickly.
 t0 <- Sys.time(); done <- FALSE
 promises::then(guane_task_promise(function() 1, list()), function(v) done <<- isTRUE(v$ok))
 while (!done && difftime(Sys.time(), t0, units = 'secs') < 10) later::run_now(0.05)
 expect_true(done); expect_lt(as.numeric(difftime(Sys.time(), t0, units = 'secs')), 5)
})

test_that('fast background tasks always resolve (no completion race)', {
 guane_test_mode(TRUE); on.exit(guane_test_mode(FALSE))
 expect_true(guane_workers_start())
 n <- 0L
 for (i in 1:50) promises::then(guane_task_promise(function(x) x, list(i)), function(v) if (isTRUE(v$ok)) n <<- n + 1L)
 t0 <- Sys.time()
 while (n < 50L && difftime(Sys.time(), t0, units = 'secs') < 30) later::run_now(0.05)
 expect_identical(n, 50L)
})
