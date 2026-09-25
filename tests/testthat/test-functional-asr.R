# Functional: Data workflow + ancestral state reconstruction end to end, with
# background workers (GUANE_ASYNC=true): example data, Sp20 mismatch, error path,
# matching, Mk ML, stochastic mapping with UI responsiveness, and downloads.
source(testthat::test_path('functional-driver.R'), local = TRUE)

app <- guane_ft_app(async = TRUE, name = 'asr-async')
withr::defer(guane_ft_stop(app))

test_that('ASR data workflow: example data reports the Sp20 mismatch', {
 guane_ft_select(app, 'asr', 'data')
 app$click('asr-example')
 app$wait_for_idle(duration = 300)
 expect_identical(guane_ft_text(app, 'asr-activity'),
  'Synthetic example loaded: 20 tree tips, 19 trait rows. Review the intentional Sp20 mismatch in Checking data.')
 expect_identical(app$get_value(input = 'asr-taxon'), 'species')
 guane_ft_set(app, `asr-view` = 'checks')
 app$wait_for_idle(duration = 300)
 expect_match(guane_ft_text(app, 'asr-diagnostics'),
  'Taxon mismatch: 1 tree tips without traits; 0 table taxa outside tree.', fixed = TRUE)
 # Structure card: 20 tips vs 19 rows.
 structure <- guane_ft_text(app, 'asr-structure')
 expect_match(structure, '20\\s*TREE TIPS')
 expect_match(structure, '19\\s*TRAIT ROWS')
})

test_that('error path: Mk before matching gives the validation message, not a crash', {
 guane_ft_select(app, 'asr', 'discrete')
 expect_identical(app$get_value(input = 'asr-mk_trait'), 'habitat_binary')
 app$click('asr-mk_run')
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 60,
  ignore = 'Choose a discrete trait and run Mk reconstruction.')
 expect_identical(status, 'Match unique taxon labels explicitly in Data before reconstruction; at least three taxa are required.')
 expect_identical(guane_ft_plot_src(app, 'asr-mk_plot'), '')
 # The session is still alive and interactive.
 guane_ft_set(app, `asr-mk_model` = 'ER')
 expect_identical(app$get_value(input = 'asr-mk_model'), 'ER')
})

test_that('matching resolves the mismatch and is logged', {
 guane_ft_select(app, 'asr', 'data')
 app$click('asr-match')
 app$wait_for_idle(duration = 300)
 expect_identical(guane_ft_text(app, 'asr-activity'),
  'User requested matching; 1 unmatched entries removed. Export the standardized inputs with your script.')
 guane_ft_set(app, `asr-view` = 'checks')
 app$wait_for_idle(duration = 300)
 expect_match(guane_ft_text(app, 'asr-diagnostics'), 'All checks passed', fixed = TRUE)
 expect_match(guane_ft_text(app, 'asr-structure'), '19\\s*TREE TIPS')
 guane_ft_set(app, `asr-view` = 'log')
 app$wait_for_idle(duration = 300)
 expect_match(guane_ft_text(app, 'asr-history'), 'Match taxa; tree exclusions: Sp20', fixed = TRUE)
})

test_that('ASR Mk ML reconstruction on habitat_binary completes with plot and tables', {
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_trait` = 'habitat_binary', `asr-mk_framework` = 'ML', `asr-mk_model` = 'ER')
 app$click('asr-mk_run')
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 180,
  ignore = c('Inputs changed. Run Mk reconstruction to update results.', 'Choose a discrete trait and run Mk reconstruction.'))
 expect_identical(status, 'Mk reconstruction completed. Review optimizer diagnostics and model assumptions.')
 src <- guane_ft_plot_src(app, 'asr-mk_plot')
 expect_match(src, '^data:image/png;base64,')
 expect_gt(nchar(src), 5000)
 probs <- guane_ft_text(app, 'asr-mk_probabilities')
 expect_match(probs, 'aquatic')
 expect_match(probs, 'terrestrial')
 # 19 tips -> 18 internal nodes in the probability table (+ header row).
 rows <- app$get_js("document.querySelectorAll('#asr-mk_probabilities tbody tr').length")
 expect_equal(rows, 18)
 expect_match(guane_ft_text(app, 'asr-mk_metadata'), 'habitat_binary | Mk | ER | ML | n = 19', fixed = TRUE)
 expect_match(guane_ft_text(app, 'asr-mk_q'), 'aquatic')
})

test_that('downloads: Live Code Mirror R script and node-probability CSV', {
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-discrete_view` = 'code')
 app$wait_for_idle(duration = 300)
 mirror <- app$get_value(output = 'asr-mk_code')
 expect_match(mirror, 'phytools', fixed = TRUE)
 script <- app$get_download('asr-mk_script')
 expect_true(file.exists(script))
 expect_identical(basename(script), 'guane-discrete-mk.R')
 lines <- readLines(script, warn = FALSE, encoding = 'UTF-8')
 expect_gt(length(lines), 20)
 expect_match(lines[1], '^# Guane discrete Mk')
 expect_true(any(grepl('fitMk', lines, fixed = TRUE)))
 # The exported script is syntactically valid R.
 expect_error(parse(text = lines, encoding = 'UTF-8'), NA)
 # The downloaded script is the same code shown in the Live Code Mirror.
 expect_identical(trimws(paste(lines, collapse = '\n')), trimws(mirror))
 guane_ft_set(app, `asr-discrete_view` = 'results')
 csv <- app$get_download('asr-mk_csv')
 expect_identical(basename(csv), 'guane-mk-probabilities.csv')
 probs <- utils::read.csv(csv, check.names = FALSE, row.names = 1)
 expect_equal(nrow(probs), 18)
 expect_setequal(names(probs), c('aquatic', 'terrestrial'))
 expect_true(all(abs(rowSums(probs) - 1) < 1e-6))
 expect_true(all(probs >= 0 & probs <= 1))
})

test_that('stochastic mapping runs in the background and the UI stays responsive', {
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_framework` = 'simmap')
 guane_ft_set(app, `asr-mk_nsim` = 400, `asr-mk_seed` = 11)
 expect_identical(guane_ft_text(app, 'asr-mk_run'), 'Run stochastic mapping')
 t0 <- Sys.time()
 app$click('asr-mk_run', wait_ = FALSE)
 expect_identical(guane_ft_wait_text(app, 'asr-mk_status', guane_ft_running, timeout = 20), guane_ft_running)

 # While the worker is busy: change language, switch primary modules and a
 # results view; each round trip must complete well before the analysis ends.
 t1 <- Sys.time()
 guane_ft_set(app, lang = 'es')
 expect_identical(guane_ft_wait_text(app, 'asr-mk_run', 'Ejecutar mapeo estocástico'), 'Ejecutar mapeo estocástico')
 guane_ft_set(app, module = 'div')
 expect_identical(app$get_value(input = 'module'), 'div')
 guane_ft_set(app, module = 'asr')
 guane_ft_set(app, `asr-discrete_view` = 'diagnostics')
 expect_identical(app$get_value(input = 'asr-discrete_view'), 'diagnostics')
 guane_ft_set(app, `asr-discrete_view` = 'results', lang = 'en')
 responsive_secs <- as.numeric(difftime(Sys.time(), t1, units = 'secs'))
 # Still running after all of that: the interactions were served concurrently.
 expect_identical(guane_ft_text(app, 'asr-mk_status'), guane_ft_running)
 expect_lt(responsive_secs, 15)

 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 300)
 total_secs <- as.numeric(difftime(Sys.time(), t0, units = 'secs'))
 expect_identical(status, 'Stochastic mapping completed. Review simulation precision and fitted-rate warnings.')
 expect_gt(total_secs, responsive_secs)
 expect_match(guane_ft_plot_src(app, 'asr-mk_plot'), '^data:image/png;base64,')
 expect_match(guane_ft_text(app, 'asr-mk_mapping_info'), 'Saved histories 400 | Mapping seed 11', fixed = TRUE)
 transitions <- guane_ft_text(app, 'asr-mk_transitions')
 expect_match(transitions, 'terrestrial')
 expect_match(transitions, 'MCSE')
 csv <- utils::read.csv(app$get_download('asr-mk_transitions_csv'))
 expect_setequal(csv$From, c('aquatic', 'terrestrial'))
 expect_true(all(c('Mean', 'SD', 'MCSE', 'Lower', 'Upper') %in% names(csv)))
 expect_true(all(csv$Lower <= csv$Mean & csv$Mean <= csv$Upper))

 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
})

test_that('changing an input during a long mapping cancels it and a new ML run completes promptly', {
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_framework` = 'simmap')
 guane_ft_set(app, `asr-mk_nsim` = 500, `asr-mk_seed` = 12)
 app$click('asr-mk_run', wait_ = FALSE)
 expect_identical(guane_ft_wait_text(app, 'asr-mk_status', guane_ft_running, timeout = 20), guane_ft_running)
 Sys.sleep(1)
 # Change an analytical input while the worker is busy.
 guane_ft_set(app, `asr-mk_framework` = 'ML')
 changed <- 'Inputs changed. Run Mk reconstruction to update results.'
 expect_identical(guane_ft_wait_text(app, 'asr-mk_status', changed, timeout = 10), changed)
 expect_identical(guane_ft_plot_src(app, 'asr-mk_plot'), '')
 # The superseded mapping (~40 s) was cancelled: the ML run is not queued behind it.
 t0 <- Sys.time()
 app$click('asr-mk_run')
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 60, ignore = changed)
 expect_identical(status, 'Mk reconstruction completed. Review optimizer diagnostics and model assumptions.')
 expect_lt(as.numeric(difftime(Sys.time(), t0, units = 'secs')), 15)
 expect_match(guane_ft_text(app, 'asr-mk_metadata'), '| ML |', fixed = TRUE)
 # The stale mapping result never overwrites the ML result afterwards.
 Sys.sleep(3)
 expect_identical(guane_ft_text(app, 'asr-mk_status'), status)
})
