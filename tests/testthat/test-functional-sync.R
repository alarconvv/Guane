# Functional: the same end-to-end paths with background workers disabled
# (GUANE_ASYNC=false): analyses run in the Shiny process and must still reach
# their completed status. Also covers background workers when the app runs from
# source through pkgload::load_all().
source(testthat::test_path('functional-driver.R'), local = TRUE)

app <- guane_ft_app(async = FALSE, name = 'sync')
withr::defer(guane_ft_stop(app))

test_that('sync mode: app boots cleanly and the language switch works', {
 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
 guane_ft_set(app, lang = 'pt')
 expect_identical(guane_ft_text(app, 'signal-example'), 'Carregar dados de exemplo')
 guane_ft_set(app, lang = 'en')
 expect_identical(guane_ft_text(app, 'signal-example'), 'Load example data')
})

test_that('sync mode: ASR data workflow and Mk ML reconstruction complete', {
 prep <- guane_ft_prepare(app, 'asr', check_mismatch = TRUE)
 expect_match(prep$mismatch, 'Taxon mismatch: 1 tree tips without traits', fixed = TRUE)
 expect_match(prep$activity, '^User requested matching; 1 unmatched entries removed')
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_trait` = 'habitat_binary', `asr-mk_framework` = 'ML')
 app$click('asr-mk_run')
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 180,
  ignore = c('Inputs changed. Run Mk reconstruction to update results.', 'Choose a discrete trait and run Mk reconstruction.'))
 expect_identical(status, 'Mk reconstruction completed. Review optimizer diagnostics and model assumptions.')
 expect_match(guane_ft_plot_src(app, 'asr-mk_plot'), '^data:image/png;base64,')
 expect_equal(app$get_js("document.querySelectorAll('#asr-mk_probabilities tbody tr').length"), 18)
 probs <- utils::read.csv(app$get_download('asr-mk_csv'), row.names = 1)
 expect_true(all(abs(rowSums(probs) - 1) < 1e-6))
})

test_that('sync mode: stochastic mapping completes', {
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_framework` = 'simmap')
 guane_ft_set(app, `asr-mk_nsim` = 50, `asr-mk_seed` = 11)
 app$click('asr-mk_run', timeout_ = 180 * 1000)
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 180,
  ignore = 'Inputs changed. Run Mk reconstruction to update results.')
 expect_identical(status, 'Stochastic mapping completed. Review simulation precision and fitted-rate warnings.')
 expect_match(guane_ft_text(app, 'asr-mk_mapping_info'), 'Saved histories 50', fixed = TRUE)
})

test_that('sync mode: diversification, signal and BiSSE complete', {
 guane_ft_prepare(app, 'div')
 guane_ft_select(app, 'div', 'rates')
 app$click('div-rates_run')
 expect_identical(guane_ft_wait_status(app, 'div-rates_status', timeout = 180,
  ignore = c('Inputs changed. Run diversification models to update results.', 'Choose settings and run diversification models.')),
  'Rate analysis completed. Inspect convergence, bounds and uncertainty.')

 guane_ft_prepare(app, 'signal')
 guane_ft_select(app, 'signal', 'signal')
 app$click('signal-run')
 app$wait_for_js("/Blomberg/.test((document.getElementById('signal-results')||{}).textContent||'')", timeout = 180000)
 guane_ft_select(app, 'signal', 'data')
 expect_identical(guane_ft_wait_text(app, 'signal-activity', 'Signal analysis completed. Results correspond to the current inputs.'),
  'Signal analysis completed. Results correspond to the current inputs.')

 guane_ft_prepare(app, 'sse')
 guane_ft_select(app, 'sse', 'bisse')
 guane_ft_set(app, `sse-bisse_models` = 'Full')
 app$click('sse-bisse_run')
 expect_identical(guane_ft_wait_status(app, 'sse-bisse_status', timeout = 300, ignore = 'BiSSE inputs changed. Run again to update results.'),
  'BiSSE completed. Review convergence, bounds and model assumptions.')

 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
})

test_that('package entry point + GUANE_ASYNC=true: workers load the package and analyses complete', {
 dir <- withr::local_tempdir()
 entry <- if (dir.exists(file.path(guane_ft_root(), 'R'))) c(
  sprintf("pkgload::load_all(%s, quiet = TRUE, export_all = TRUE, helpers = FALSE, attach_testthat = FALSE)", deparse(guane_ft_root())),
  "app_guane(module = 'full', default_lang = 'en')") else 'guane::app_guane()'
 writeLines(entry, file.path(dir, 'app.R'))
 dev <- guane_ft_app(async = TRUE, name = 'pkgload-async', app_dir = dir)
 withr::defer(guane_ft_stop(dev))
 errors <- guane_ft_browser_errors(dev)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
 guane_ft_prepare(dev, 'asr')
 guane_ft_select(dev, 'asr', 'discrete')
 guane_ft_set(dev, `asr-mk_trait` = 'habitat_binary', `asr-mk_framework` = 'ML')
 dev$click('asr-mk_run')
 expect_identical(guane_ft_wait_text(dev, 'asr-mk_status', guane_ft_running, timeout = 10), guane_ft_running)
 expect_identical(guane_ft_wait_status(dev, 'asr-mk_status', timeout = 120,
  ignore = c('Inputs changed. Run Mk reconstruction to update results.', 'Choose a discrete trait and run Mk reconstruction.')),
  'Mk reconstruction completed. Review optimizer diagnostics and model assumptions.')
 expect_match(guane_ft_plot_src(dev, 'asr-mk_plot'), '^data:image/png;base64,')
 # A second analysis family through the same dev-loaded workers.
 guane_ft_prepare(dev, 'div')
 guane_ft_select(dev, 'div', 'rates')
 dev$click('div-rates_run')
 expect_identical(guane_ft_wait_status(dev, 'div-rates_status', timeout = 120,
  ignore = c('Inputs changed. Run diversification models to update results.', 'Choose settings and run diversification models.')),
  'Rate analysis completed. Inspect convergence, bounds and uncertainty.')
})
