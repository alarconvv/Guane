# Unit tests: diversification (R/core_mod_div*.R).

test_that('guane_ltt returns a lineage-through-time curve ending at the tip count', {
 d <- guane_test_data(); n <- length(d$tree$tip.label)
 l <- guane_ltt(d$tree)
 expect_named(l, c('Time', 'Lineages'))
 expect_equal(l$Lineages[1], 2)
 expect_equal(tail(l$Lineages, 1), n)
 expect_false(is.unsorted(l$Time)); expect_false(is.unsorted(l$Lineages))
 expect_equal(max(l$Time), max(ape::branching.times(d$tree)), tolerance = 1e-8)
})

test_that('guane_ltt rejects invalid trees with explicit messages', {
 d <- guane_test_data()
 expect_error(guane_ltt(list()), 'Load a phylogenetic tree.')
 nu <- d$tree; nu$edge.length[nu$edge[, 2] == 1] <- nu$edge.length[nu$edge[, 2] == 1] * 2
 expect_error(guane_ltt(nu), 'ultrametric')
 expect_error(guane_ltt(ape::unroot(d$tree)), 'rooted')
 tr <- d$tree; tr$edge.length[3] <- -1
 expect_error(guane_ltt(tr), 'finite, positive branch lengths')
 tr <- d$tree; tr$tip.label[2] <- tr$tip.label[1]
 expect_error(guane_ltt(tr), 'uniquely named tips')
 expect_error(guane_ltt(d$tree, tol = 1), 'tolerance')
 expect_error(guane_ltt(d$tree, include_stem = NA), 'Invalid stem setting.')
})

test_that('guane_ltt_run stacks named trees and guane_ltt_settings validates graphics', {
 d <- guane_test_data()
 r <- guane_ltt_run(list(A = d$tree, A = d$tree))
 expect_setequal(unique(r$Tree), c('A', 'A.1'))
 expect_equal(attr(r, 'summary')$Tips, rep(length(d$tree$tip.label), 2))
 expect_equal(r$Time_before_present, max(r$Time) - r$Time)
 expect_error(guane_ltt_run(rep(list(d$tree), 26)), 'one to 25 trees')
 expect_error(guane_ltt_settings(width = 1), 'Invalid LTT graph settings.')
 expect_error(guane_ltt_settings(palette = 'Neon'), 'Invalid LTT graph settings.')
})

test_that('guane_rates_fit estimates the analytic Yule MLE and compares Yule/BD', {
 d <- guane_test_data(); n <- length(d$tree$tip.label)
 r <- guane_rates_fit(d$tree)
 expect_equal(r$comparison$Model, c('Yule', 'BD'))
 expect_true(all(r$comparison$Converged))
 expect_equal(sum(r$comparison$Weight), 1, tolerance = 1e-12)
 yule <- r$estimates[r$estimates$Model == 'Yule' & r$estimates$Parameter == 'lambda', 'Estimate']
 # Crown-conditioned pure-birth MLE: (n - 2) / total branch length.
 expect_equal(yule, (n - 2) / sum(d$tree$edge.length), tolerance = 1e-5)
 bd <- r$estimates[r$estimates$Model == 'BD', ]
 expect_true(all(bd$Estimate[bd$Parameter %in% c('lambda', 'mu')] >= 0))
 expect_equal(bd$Estimate[bd$Parameter == 'net'], bd$Estimate[bd$Parameter == 'lambda'] - bd$Estimate[bd$Parameter == 'mu'])
 expect_true(r$comparison$LogLik[2] >= r$comparison$LogLik[1] - 1e-6)
 expect_equal(r$tips, n)
 expect_false(is.null(r$slices))
})

test_that('guane_rates_fit validates settings and tree requirements', {
 d <- guane_test_data()
 expect_error(guane_rates_fit(d$tree, models = 'Foo'), 'Choose Yule, birth-death, or both models.')
 expect_error(guane_rates_fit(d$tree, models = character()), 'Choose Yule')
 expect_error(guane_rates_fit(d$tree, sampling = 0), 'Sampling fraction')
 expect_error(guane_rates_fit(d$tree, sampling = 1.2), 'Sampling fraction')
 expect_error(guane_rates_fit(d$tree, optimizer = 'BFGS'), 'Invalid optimizer settings.')
 expect_error(guane_rates_fit(d$tree, start_lambda = 1e6), 'Starting rates must lie inside')
 expect_error(guane_rates_fit(d$tree, survival = NA), 'Invalid rate analysis settings.')
 small <- ape::keep.tip(d$tree, d$tree$tip.label[1:3])
 expect_error(guane_rates_fit(small), 'at least four tips')
 nu <- d$tree; nu$edge.length[nu$edge[, 2] == 1] <- nu$edge.length[nu$edge[, 2] == 1] * 2
 expect_error(guane_rates_fit(nu), 'ultrametric')
})

test_that('guane_rates_fit reports an excluded stem', {
 d <- guane_test_data(); tr <- d$tree; tr$root.edge <- .3
 r <- guane_rates_fit(tr, models = 'Yule', slices = FALSE)
 expect_true(any(grepl('Supplied stem excluded', r$warnings)))
})

test_that('guane_rates_time is a CDF with a consistent inverse', {
 x <- c(.1, .5, .9)
 p <- guane_rates_time(x, lambda = 2, mu = .5, rho = 1, age = 1)
 expect_false(is.unsorted(p)); expect_true(all(p > 0 & p < 1))
 expect_equal(guane_rates_time(p, 2, .5, 1, 1, inverse = TRUE), x, tolerance = 1e-10)
 expect_equal(guane_rates_time(c(0, 1), 2, 2, 1, 1), c(0, 1))
 expect_error(guane_rates_time(x, -1, 0, 1, 1), 'Invalid simulation parameters.')
})

test_that('guane_rates_diagnose adds profiles and seeded adequacy simulations', {
 d <- guane_test_data()
 r <- guane_rates_fit(d$tree, models = 'Yule', slices = FALSE)
 a <- guane_rates_diagnose(r, profiles = TRUE, points = 21, simulate = TRUE, nsim = 20, seed = 4)
 b <- guane_rates_diagnose(r, profiles = FALSE, simulate = TRUE, nsim = 20, seed = 4)
 expect_identical(a$adequacy$draws, b$adequacy$draws)
 iv <- a$profile$intervals[a$profile$intervals$Parameter == 'lambda', ]
 expect_true(iv$Lower < iv$Estimate && iv$Estimate < iv$Upper)
 expect_error(guane_rates_adequacy(r, nsim = 5), 'Invalid simulation settings.')
 expect_error(guane_rates_profile(r, level = .5), 'Invalid profile settings.')
})

test_that('guane_rates_tv_fit nests constant-rate Yule and fits exponential speciation', {
 d <- guane_test_data()
 tv <- guane_rates_tv_fit(d$tree, models = c('Yule', 'ExpYule'))
 r <- guane_rates_fit(d$tree, models = 'Yule', slices = FALSE, intervals = FALSE)
 expect_equal(tv$comparison$LogLik[tv$comparison$Model == 'Yule'], r$comparison$LogLik, tolerance = 1e-5)
 expect_true(all(tv$comparison$Converged))
 expect_true(tv$comparison$LogLik[2] >= tv$comparison$LogLik[1] - 1e-6)
 expect_equal(tv$comparison$Beta[1], 0)
 expect_setequal(unique(tv$curves$Model), c('Yule', 'ExpYule'))
 expect_error(guane_rates_tv_fit(d$tree, models = 'Logistic'), 'Select valid time-comparison models.')
 expect_error(guane_rates_tv_fit(d$tree, models = 'ExpYule', beta_bound = 20), 'Beta start')
 expect_error(guane_rates_tv_fit(d$tree, models = 'Yule', backend = 'rk4'), 'Invalid ODE solver settings.')
})

test_that('clade catalog lists internal nodes with at least four tips', {
 d <- guane_test_data()
 cat <- guane_rates_clade_catalog(d$tree)
 expect_true(all(cat$table$Tips >= 4))
 n <- length(d$tree$tip.label)
 expect_equal(cat$table$Tips[cat$table$Node == n + 1], n)
 expect_equal(length(cat$descendants[[n + 1]]), n)
})

test_that('guane_rates_clade_select and guane_rates_clade_fit validate and fit separate clades', {
 d <- guane_test_data(); cat <- guane_rates_clade_catalog(d$tree)$table
 # Pick two non-overlapping clades and one clade nested in another.
 desc <- guane_rates_clade_catalog(d$tree)$descendants
 pairs <- utils::combn(cat$Node, 2)
 overlap <- apply(pairs, 2, function(p) length(intersect(desc[[p[1]]], desc[[p[2]]])) > 0)
 disjoint <- pairs[, which(!overlap)[1]]
 nested <- pairs[, which(overlap)[1]]
 sel <- guane_rates_clade_select(d$tree, disjoint)
 expect_equal(sel$clades$Node, sort(disjoint)); expect_equal(sel$clades$Sampling, c(1, 1))
 expect_error(guane_rates_clade_select(d$tree, nested), 'overlap')
 small <- setdiff(length(d$tree$tip.label) + seq_len(d$tree$Nnode), cat$Node)[1]
 expect_error(guane_rates_clade_select(d$tree, small), 'at least four descendant tips')
 expect_error(guane_rates_clade_select(d$tree, disjoint, data.frame(Node = disjoint, Sampling = c(1, 2))), 'Sampling table')
 expect_equal(guane_rates_clade_sampling('', c(5, 6)), data.frame(Node = c(5, 6), Sampling = 1))
 fit <- guane_rates_clade_fit(d$tree, disjoint, models = 'Yule', profiles = FALSE)
 expect_equal(fit$audit$Successful_models, c(1, 1))
 for (k in names(fit$fits)) {
  sub <- fit$trees[[k]]
  est <- fit$fits[[k]]$estimates
  expect_equal(est$Estimate[est$Parameter == 'lambda'], (length(sub$tip.label) - 2) / sum(sub$edge.length), tolerance = 1e-5)
 }
 tab <- guane_rates_clade_table(fit)
 expect_setequal(unique(tab$Node), disjoint)
})

test_that('joint shift models validate nodes and nest the shared Yule model', {
 d <- guane_test_data(); n <- length(d$tree$tip.label)
 cat <- guane_rates_clade_catalog(d$tree)$table
 node <- cat$Node[cat$Node != n + 1 & cat$Tips <= n - 2][1]
 expect_error(guane_rates_joint_data(d$tree, n + 1), 'non-root shift nodes')
 expect_error(guane_rates_joint_data(d$tree, node, split_t = 1), 'split.t = Inf')
 expect_error(guane_rates_joint_map(c(0, node), 'Custom', data.frame(Region = 0, Lambda = 'l', Mu = 'm')), 'Custom constraints')
 expect_error(guane_rates_joint_map(c(0, node), 'Custom', data.frame(Region = c(0, node), Lambda = c('a', 'a'), Mu = c('a', '0'))), 'Do not share a parameter name')
 m <- guane_rates_joint_map(c(0, node), 'ShiftLambda')
 expect_setequal(m$free, c("lambda0", paste0("lambda", node), "mu"))
 j <- guane_rates_joint_fit(d$tree, node, models = c('SharedYule', 'ShiftLambda'))
 r <- guane_rates_fit(d$tree, models = 'Yule', slices = FALSE, intervals = FALSE)
 expect_equal(j$comparison$LogLik[j$comparison$Model == 'SharedYule'], r$comparison$LogLik, tolerance = 1e-5)
 expect_equal(sum(j$regions$Tips), n)
 expect_error(guane_rates_joint_fit(d$tree, node, models = 'Nope'), 'supported joint model')
})

test_that('guane_dd_numbers and guane_dd_fit validate their settings', {
 skip_if_not_installed('DDD')
 d <- guane_test_data()
 expect_equal(guane_dd_numbers('1, 2,3'), c(1, 2, 3))
 expect_error(guane_dd_numbers('1,a'), 'Invalid numeric settings.')
 expect_error(guane_dd_numbers('1,2', n = 3), 'Invalid numeric settings.')
 expect_error(guane_dd_fit(d$tree, models = 7), 'Invalid model or likelihood settings.')
 expect_error(guane_dd_fit(d$tree, missing = -1), 'Invalid numeric settings.')
 expect_error(guane_dd_fit(d$tree, starts = c(-1, .2, 40, 1)), 'Use positive lambda')
 expect_error(guane_dd_fit(d$tree, free = 'sigma'), 'Use positive lambda')
 expect_error(guane_dd_fit(d$tree, optimizer = 'nelder'), 'Unsupported numerical method.')
 expect_error(guane_dd_fit(d$tree, tol = c(1, 1)), 'Invalid numeric settings.')
})

test_that('guane_dd_fit enforces the server bounds on DDD settings', {
 skip_if_not_installed('DDD')
 d <- guane_test_data(); nb <- d$tree$Nnode
 expect_error(guane_dd_fit(d$tree, missing = max(1000, 10 * nb) + 1), 'Invalid numeric settings.')
 expect_error(guane_dd_fit(d$tree, maxiter = 1e5 + 1), 'Invalid numeric settings.')
 expect_error(guane_dd_fit(d$tree, cycles = 11), 'Invalid numeric settings.')
 expect_error(guane_dd_fit(d$tree, res = 2e4 + 1), 'Invalid model or likelihood settings.')
 expect_error(guane_dd_fit(d$tree, res = nb + 1), 'Invalid model or likelihood settings.')
})

# A cheap DDD fit: mu fixed at 0, lambda and K estimated (about 0.1 s).
dd_quick <- function(d) guane_dd_fit(d$tree, models = 1, res = 40, maxiter = 100, free = c('lambda', 'K'), starts = c(3, 0, 40, 1))

test_that('guane_dd_fit fits a tiny diversity-dependent model with DDD >= 5.2.5', {
 skip_if_not_installed('DDD', minimum_version = '5.2.5')
 d <- guane_test_data(); n <- length(d$tree$tip.label)
 r <- dd_quick(d)
 expect_equal(r$brts, sort(as.numeric(ape::branching.times(d$tree)), decreasing = TRUE))
 expect_equal(names(r$calls), '1')
 expect_true(r$comparison$Converged)
 expect_true(is.finite(r$comparison$LogLik))
 expect_equal(r$comparison$Parameters, 2)
 expect_equal(r$fits[['1']]$mu, 0)
 # With K unbounded the model collapses to Yule: lambda near (n - 2) / total branch length.
 expect_equal(r$fits[['1']]$lambda, (n - 2) / sum(d$tree$edge.length), tolerance = 1e-2)
 expect_true(all(c('tolint', 'probs_threshold') %in% names(r$calls[['1']])))
})

test_that('DDD diagnostics and uncertainty validate their numeric bounds', {
 skip_if_not_installed('DDD', minimum_version = '5.2.5')
 r <- dd_quick(guane_test_data())
 expect_error(guane_dd_diagnose(r, factor = 1), 'Invalid numeric settings.')
 expect_error(guane_dd_diagnose(r, factor = 4.5), 'Invalid numeric settings.')
 expect_error(guane_dd_uncertainty(r, model = '1', resolution_factor = 5), 'Invalid numeric settings.')
 expect_error(guane_dd_uncertainty(r, model = '1', seconds = 601), 'Invalid numeric settings.')
 expect_error(guane_dd_uncertainty(r, model = '3'), 'Select a converged model.')
})

test_that('guane_dd_fit full three-parameter model converges', {
 skip_on_cran() # about 55 s with DDD 5.2.5
 skip_if_not_installed('DDD', minimum_version = '5.2.5')
 r <- guane_dd_fit(guane_test_data()$tree, models = 1, maxiter = 200)
 expect_true(r$comparison$Converged)
})
