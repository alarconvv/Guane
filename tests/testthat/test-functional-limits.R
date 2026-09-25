# Functional: server safeguards in the real app with background workers
# (GUANE_ASYNC=true, GUANE_TASK_TIMEOUT=8): task time limit and worker release,
# tree-size upload limit, and spreadsheet-formula neutralisation in CSV exports.
source(testthat::test_path('functional-driver.R'), local = TRUE)

app <- guane_ft_app(async = TRUE, name = 'limits-async', env = c(GUANE_TASK_TIMEOUT = '8'))
withr::defer(guane_ft_stop(app))

timeout_msg <- 'The analysis exceeded the server time limit. Reduce its size or run the exported R script locally.'
mk_done <- 'Mk reconstruction completed. Review optimizer diagnostics and model assumptions.'
mk_ignore <- c('Inputs changed. Run Mk reconstruction to update results.', 'Choose a discrete trait and run Mk reconstruction.')

test_that('a mapping over the time limit is cancelled and the worker is released for the next run', {
 guane_ft_prepare(app, 'asr')
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_trait` = 'habitat_binary', `asr-mk_framework` = 'simmap')
 guane_ft_set(app, `asr-mk_nsim` = 500, `asr-mk_seed` = 11)
 t0 <- Sys.time()
 app$click('asr-mk_run')
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 60, ignore = mk_ignore)
 expect_identical(status, timeout_msg)
 # Cancelled at ~8 s, far below the ~40 s the full mapping needs.
 expect_lt(as.numeric(difftime(Sys.time(), t0, units = 'secs')), 20)
 expect_identical(guane_ft_plot_src(app, 'asr-mk_plot'), '')

 # Immediately run a fast ML fit (single model; well under the 8 s limit even on a loaded machine) on the same worker.
 guane_ft_set(app, `asr-mk_framework` = 'ML', `asr-mk_compare` = FALSE)
 t1 <- Sys.time()
 app$click('asr-mk_run')
 status <- guane_ft_wait_status(app, 'asr-mk_status', timeout = 30, ignore = mk_ignore)
 elapsed <- as.numeric(difftime(Sys.time(), t1, units = 'secs'))
 expect_identical(status, mk_done)
 expect_lt(elapsed, 15)
 expect_match(guane_ft_plot_src(app, 'asr-mk_plot'), '^data:image/png;base64,')
})

test_that('uploading a tree above the tip limit shows the size message', {
 guane_ft_select(app, 'asr', 'data')
 path <- withr::local_tempfile(fileext = '.nwk')
 set.seed(1)
 ape::write.tree(ape::rtree(6000), path)
 app$upload_file(`asr-tree_file` = path, timeout_ = 60 * 1000)
 msg <- 'This tree exceeds the maximum number of tips supported on this server. Run the exported R script locally for larger trees.'
 expect_identical(guane_ft_wait_text(app, 'asr-activity', msg, timeout = 30), msg)
 app$wait_for_js("document.querySelectorAll('.shiny-notification').length > 0", timeout = 20000)
 expect_match(paste(unlist(app$get_js("Array.from(document.querySelectorAll('.shiny-notification')).map(function(n){return n.textContent;})")), collapse = ' '), msg, fixed = TRUE)
 # The previously loaded (matched) data are kept: still 19 tips.
 expect_match(guane_ft_text(app, 'asr-structure'), '19\\s*TREE TIPS')
})

test_that('CSV exports prefix formula-like taxon and state labels with an apostrophe', {
 d <- guane_example()
 keep <- intersect(d$tree$tip.label, d$traits$species)
 tree <- ape::keep.tip(d$tree, keep)
 traits <- d$traits[d$traits$species %in% keep, c('species', 'body_mass', 'habitat_binary')]
 tree$tip.label[tree$tip.label == 'Sp01'] <- '=cmd'
 traits$species[traits$species == 'Sp01'] <- '=cmd'
 traits$habitat_binary[traits$habitat_binary == 'aquatic'] <- '=aquatic'
 tree_path <- withr::local_tempfile(fileext = '.nwk')
 traits_path <- withr::local_tempfile(fileext = '.csv')
 ape::write.tree(tree, tree_path)
 utils::write.csv(traits, traits_path, row.names = FALSE)

 guane_ft_select(app, 'asr', 'data')
 app$upload_file(`asr-tree_file` = tree_path)
 expect_identical(guane_ft_wait_text(app, 'asr-activity', 'Tree loaded.'), 'Tree loaded.')
 app$upload_file(`asr-traits_file` = traits_path)
 expect_identical(guane_ft_wait_text(app, 'asr-activity', 'Trait table loaded.'), 'Trait table loaded.')
 guane_ft_set(app, `asr-taxon` = 'species')
 guane_ft_set(app, `asr-view` = 'checks')
 expect_match(guane_ft_text(app, 'asr-diagnostics'), 'All checks passed', fixed = TRUE)

 # Data table export: the '=cmd' taxon and '=aquatic' states are neutralised.
 guane_ft_set(app, `asr-view` = 'traits')
 raw <- readLines(app$get_download('asr-traits_download'), warn = FALSE)
 expect_true(any(grepl('^"\'=cmd",', raw)), info = paste(raw, collapse = '\n'))
 expect_true(any(grepl('"\'=aquatic"', raw, fixed = TRUE)))
 expect_false(any(grepl('^"=cmd"', raw)))
 exported <- utils::read.csv(app$get_download('asr-traits_download'), check.names = FALSE)
 expect_true("'=cmd" %in% exported$species)
 expect_equal(exported$body_mass, traits$body_mass)

 # Mk node probabilities export: the '=aquatic' state column header too.
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_trait` = 'habitat_binary', `asr-mk_framework` = 'ML', `asr-mk_compare` = FALSE)
 app$click('asr-mk_run')
 expect_identical(guane_ft_wait_status(app, 'asr-mk_status', timeout = 30, ignore = mk_ignore), mk_done)
 raw <- readLines(app$get_download('asr-mk_csv'), warn = FALSE)
 expect_match(raw[1], '"\'=aquatic"', fixed = TRUE)
 expect_false(grepl('"=aquatic"', raw[1], fixed = TRUE))
 probs <- utils::read.csv(app$get_download('asr-mk_csv'), check.names = FALSE, row.names = 1)
 expect_setequal(names(probs), c("'=aquatic", 'terrestrial'))
 expect_true(all(abs(rowSums(probs) - 1) < 1e-6))

 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
})
