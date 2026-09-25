# Unit tests: Live Code Mirror / exported R scripts (*_script, *_preview, guane_r_assignment).
# Exported scripts are self-contained: data are embedded with guane_r_assignment and the
# Guane functions are deparsed into the script, so no input files are needed.

script_cache <- new.env()
cached <- function(key, expr) {
 if (!exists(key, envir = script_cache, inherits = FALSE)) assign(key, force(expr), envir = script_cache)
 get(key, envir = script_cache)
}
script_data <- function() cached('data', guane_test_data())

expect_parses <- function(code) {
 expect_type(code, 'character')
 expect_true(length(code) > 0)
 expr <- tryCatch(parse(text = code, keep.source = FALSE), error = identity)
 expect_false(inherits(expr, 'error'), info = if (inherits(expr, 'error')) conditionMessage(expr) else '')
 invisible(expr)
}

# Run an exported script plus `extra` (which saves results to `%s`) in a fresh R session.
run_exported <- function(code, extra, timeout = 120) {
 skip_if_not_installed('callr')
 dir <- tempfile('guane-script-'); dir.create(dir)
 on.exit(unlink(dir, recursive = TRUE), add = TRUE)
 file <- file.path(dir, 'guane-export.R'); out <- file.path(dir, 'out.rds')
 writeLines(c(code, sprintf(extra, out)), file, useBytes = TRUE)
 res <- callr::rscript(file, wd = dir, show = FALSE, fail_on_status = FALSE, stderr = '2>&1', timeout = timeout, libpath = .libPaths())
 expect_equal(res$status, 0L, info = paste(utils::tail(strsplit(res$stdout, '\n')[[1]], 15), collapse = '\n'))
 if (file.exists(out)) readRDS(out) else NULL
}

# ---- Parsing: every analysis type produces syntactically valid R ------------------------

test_that('data preparation, data plots and the Mk call preview parse', {
 d <- script_data()
 expect_parses(guane_preparation_script(list(guane_r_assignment('tree', d$tree))))
 expect_parses(guane_data_plot_script('tree', list(tree = d$tree, layout = 'phylogram', direction = 'rightwards', lengths = TRUE, labels = TRUE, font = 1, edge = 1, nodes = FALSE)))
 expect_parses(guane_data_plot_script('distribution', list(x = d$traits$body_mass)))
 z <- guane_mk_data(d$tree, d$traits, 'species', 'locomotion_3state')
 for (m in c('ER', 'SYM', 'ARD')) expect_parses(guane_mk_call_preview(z, guane_mk_matrix(z$states, m), advanced = list(reconstruction = 'joint')))
 expect_parses(guane_mk_call_preview(z, guane_mk_matrix(z$states, 'ER'), advanced = list(start_mode = 'backend')))
})

test_that('ASR scripts parse (Mk, mapped Mk, polymorphic, continuous, Gaussian, Bayesian)', {
 d <- script_data()
 mk <- cached('mk', guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary'))
 for (type in c('tree', 'rates', 'probabilities', 'comparison')) expect_parses(guane_asr_mk_script(mk, type = type))
 mapped <- guane_asr_map(mk, nsim = 5, seed = 1)
 expect_parses(guane_asr_mk_script(mapped, type = 'history', history = 2))
 expect_error(guane_asr_mk_script(mapped, type = 'history', history = 9), 'within the simulated range')
 poly <- guane_asr_poly(d$tree, d$traits, 'species', 'resource_use_polymorphic', compare = FALSE)
 expect_parses(guane_asr_poly_script(poly))
 ct <- cached('bm', guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass'))
 expect_parses(guane_asr_bm_script(ct))
 expect_parses(guane_asr_bm_script(guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', engine = 'Gaussian ML', compare = TRUE), type = 'comparison'))
 utils::capture.output(cb <- suppressWarnings(guane_asr_bayes(d$tree, d$traits, 'species', 'body_mass', ngen = 2000, sample = 50, burnin = 500, chains = 1, seed = 2)))
 expect_parses(guane_asr_bm_script(cb, type = 'trace', parameter = 'sig2'))
 utils::capture.output(mb <- guane_asr_mk_bayes(d$tree, d$traits, 'species', 'habitat_binary', nsim = 20, burnin = 10, samplefreq = 5, chains = 1, seed = 1))
 code <- guane_asr_mk_script(mb)
 expect_parses(code)
 expect_true(any(grepl('unserialize(memDecompress', code, fixed = TRUE)))
})

test_that('diversification scripts parse (LTT, rates, time, clades, joint, diversity)', {
 d <- script_data()
 expect_parses(guane_ltt_script(d$tree))
 expect_parses(guane_ltt_script(guane_ltt_run(list(A = d$tree, B = d$tree)), settings = guane_ltt_settings(backward = TRUE)))
 r <- cached('rates', guane_rates_fit(d$tree))
 expect_parses(guane_rates_script(r))
 expect_parses(guane_rates_script(guane_rates_diagnose(r, points = 21, nsim = 20), type = 'profile'))
 expect_parses(guane_rates_tv_script(guane_rates_tv_fit(d$tree, models = c('Yule', 'ExpYule'))))
 cat <- guane_rates_clade_catalog(d$tree)$table
 expect_parses(guane_rates_clade_script(guane_rates_clade_fit(d$tree, cat$Node[2], models = 'Yule', profiles = FALSE)))
 node <- cat$Node[cat$Node != length(d$tree$tip.label) + 1 & cat$Tips <= length(d$tree$tip.label) - 2][1]
 expect_parses(guane_rates_joint_script(guane_rates_joint_fit(d$tree, node, models = c('SharedYule', 'SharedBD'))))
 skip_if_not_installed('DDD')
 dd <- guane_dd_fit(d$tree, models = 1, res = 40, maxiter = 100, free = c('lambda', 'K'), starts = c(3, 0, 40, 1))
 expect_parses(guane_dd_script(dd, list(type = 'rates')))
})

test_that('signal scripts parse (signal, PGLS, PGLS comparison, PGLM, PGLM influence)', {
 d <- script_data()
 s <- cached('signal', guane_signal(d$tree, d$traits, 'species', 'body_mass', seed = 3, nsim = 99))
 for (type in c('tree', 'null')) expect_parses(guane_signal_script(s, type = type, lang = 'es'))
 p <- cached('pgls', guane_pgls(d$tree, d$traits, 'species', 'body_mass', c('body_length', 'temperature')))
 for (type in c('fit', 'coefficients', 'diagnostics')) expect_parses(guane_pgls_script(p, type = type, lang = 'pt'))
 expect_parses(guane_pgls_compare_script(guane_pgls_compare(d$tree, d$traits, 'species', 'body_mass', 'body_length')))
 m <- guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'body_mass', event = 'aquatic')
 expect_parses(guane_pglm_script(m))
 expect_parses(guane_pglm_script(guane_pglm(d$tree, d$traits, 'species', 'success_count', 'body_mass', method = 'binomial_GEE', trials = 'trial_count')))
 expect_parses(guane_pglm_influence_script(guane_pglm_influence(m)))
})

test_that('Pagel script parses', {
 skip_if_not_installed('phytools', minimum_version = '2.5-2')
 d <- script_data(); k <- d$tree$tip.label[1:12]
 r <- guane_pagel(ape::keep.tip(d$tree, k), d$traits[d$traits$species %in% k, ], 'species', 'habitat_binary', 'parental_care_binary', starts = 1)
 for (m in c('independent', 'dependent')) expect_parses(guane_pagel_script(r, model = m, lang = 'es'))
})

test_that('SSE scripts parse (BiSSE, MuSSE, QuaSSE, hidden-state)', {
 d <- script_data()
 b <- guane_bisse_fit(d$tree, d$traits, 'species', 'habitat_binary', 'terrestrial', models = 'Trait-independent diversification', starts = 1, slices = FALSE)
 expect_parses(guane_bisse_script(b))
 expect_parses(guane_bisse_script(b, guane_bisse_settings(type = 'tree', lang = 'es')))
 m <- guane_musse_fit(d$tree, d$traits, 'species', 'locomotion_3state', models = 'Equal diversification and transitions', starts = 1, slices = FALSE)
 expect_parses(guane_musse_script(m))
 tx <- d$traits; tx$log_mass <- log(tx$body_mass)
 q <- guane_quasse_fit(d$tree, tx, 'species', 'log_mass', error = .1, nx = 128, r = 1, starts = 1, maxit = 20, baseline = FALSE, verify = FALSE)
 expect_parses(guane_quasse_script(q))
 skip_if_not_installed('hisse')
 h <- guane_hidden_fit(d$tree, d$traits, 'species', 'habitat_binary', 'terrestrial', models = 'BiSSE (HiSSE backend)', starts = 1, verify = FALSE, maxeval = 20)
 expect_parses(guane_hidden_script(h))
})

# ---- Execution: exported scripts run in a fresh R session and reproduce the estimate -----

test_that('exported Mk script runs in a fresh session and reproduces the in-app fit', {
 d <- script_data()
 mk <- cached('mk', guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary'))
 out <- run_exported(guane_asr_mk_script(mk),
  'refitted <- do.call(guane_asr_mk, inputs); saveRDS(list(saved = result$logLik, saved_p = result$probabilities, refit = refitted$logLik, refit_p = refitted$probabilities, Q = refitted$Q), "%s")')
 expect_equal(out$saved, mk$logLik, tolerance = 1e-10)
 expect_equal(out$saved_p, mk$probabilities, tolerance = 1e-10)
 expect_equal(out$refit, mk$logLik, tolerance = 1e-6)
 expect_equal(out$refit_p, mk$probabilities, tolerance = 1e-5)
 expect_equal(out$Q, mk$Q, tolerance = 1e-4)
})

test_that('exported continuous ASR script runs in a fresh session and reproduces node estimates', {
 d <- script_data()
 ct <- cached('bm', guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass'))
 out <- run_exported(guane_asr_bm_script(ct),
  'refitted <- do.call(guane_asr_continuous, inputs); saveRDS(list(saved = result$ace, refit = refitted$ace, nodes = refitted$nodes, logLik = refitted$logLik), "%s")')
 expect_equal(out$saved, ct$ace, tolerance = 1e-10)
 expect_equal(out$refit, ct$ace, tolerance = 1e-8)
 expect_equal(out$nodes, ct$nodes, tolerance = 1e-8)
 expect_equal(out$logLik, ct$logLik, tolerance = 1e-8)
})

test_that('exported rates script runs in a fresh session and reproduces Yule/BD estimates', {
 d <- script_data()
 r <- cached('rates', guane_rates_fit(d$tree))
 out <- run_exported(guane_rates_script(r),
  'refitted <- do.call(guane_rates_fit, result$inputs); saveRDS(list(saved = result$comparison, comparison = refitted$comparison, estimates = refitted$estimates), "%s")')
 expect_equal(out$saved, r$comparison)
 expect_equal(out$comparison, r$comparison, tolerance = 1e-6)
 expect_equal(out$estimates$Estimate, r$estimates$Estimate, tolerance = 1e-5)
})

test_that('exported signal script runs in a fresh session and reproduces K, lambda and p-values', {
 d <- script_data()
 s <- cached('signal', guane_signal(d$tree, d$traits, 'species', 'body_mass', seed = 3, nsim = 99))
 # The script recomputes the analysis itself: `result <- do.call(guane_signal, inputs)`.
 out <- run_exported(guane_signal_script(s), 'saveRDS(result, "%s")')
 expect_equal(out$Estimate, s$Estimate, tolerance = 1e-8)
 expect_equal(out$P_value, s$P_value, tolerance = 1e-8)
 expect_equal(attr(out, 'randomized_K'), attr(s, 'randomized_K'), tolerance = 1e-8)
})

test_that('exported PGLS script runs in a fresh session and reproduces coefficients', {
 d <- script_data()
 p <- cached('pgls', guane_pgls(d$tree, d$traits, 'species', 'body_mass', c('body_length', 'temperature')))
 out <- run_exported(guane_pgls_script(p), 'saveRDS(result$coefficients, "%s")')
 expect_equal(out, p$coefficients, tolerance = 1e-8)
})
