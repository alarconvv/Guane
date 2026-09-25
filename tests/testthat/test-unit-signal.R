# Unit tests: phylogenetic signal, PGLS, PGLM and Pagel (R/core_mod_signal*.R).

test_that('guane_signal is reproducible for a fixed seed with nsim = 99', {
 d <- guane_test_data()
 a <- guane_signal(d$tree, d$traits, 'species', 'body_mass', seed = 11, nsim = 99)
 b <- guane_signal(d$tree, d$traits, 'species', 'body_mass', seed = 11, nsim = 99)
 expect_identical(a$Estimate, b$Estimate); expect_identical(a$P_value, b$P_value)
 expect_identical(attr(a, 'randomized_K'), attr(b, 'randomized_K'))
 expect_equal(a$Metric, c("Blomberg's K", "Pagel's lambda"))
 expect_length(attr(a, 'randomized_K'), 98)
 # Randomization p-value includes the observed value: a multiple of 1/nsim.
 expect_equal(a$P_value[1] * 99, round(a$P_value[1] * 99), tolerance = 1e-8)
 expect_true(all(a$P_value >= 0 & a$P_value <= 1))
 x <- setNames(d$traits$body_mass, d$traits$species)[d$tree$tip.label]
 expect_equal(a$Estimate[1], as.numeric(phytools::phylosig(d$tree, x, method = 'K')), tolerance = 1e-10)
 expect_equal(attr(a, 'snapshot')$traits$species, d$tree$tip.label)
})

test_that('guane_signal validates settings and data', {
 d <- guane_test_data()
 expect_error(guane_signal(d$tree, d$traits, 'species', 'body_mass', nsim = 98), 'Choose 99')
 expect_error(guane_signal(d$tree, d$traits, 'species', 'body_mass', nsim = 99.5), 'Choose 99')
 expect_error(guane_signal(d$tree, d$traits, 'species', 'body_mass', seed = -1, nsim = 99), 'nonnegative integer seed')
 expect_error(guane_signal(d$tree, d$traits[-1, ], 'species', 'body_mass', nsim = 99), 'Resolve data issues before running.')
 expect_error(guane_signal(d$tree, d$traits, 'species', 'habitat_binary', nsim = 99), 'Resolve data issues before running.')
})

test_that('guane_signal preserves the caller RNG state and does not depend on RNGkind', {
 d <- guane_test_data()
 set.seed(1); u1 <- runif(2)
 set.seed(1); ref <- guane_signal(d$tree, d$traits, 'species', 'temperature', seed = 11, nsim = 99); u2 <- runif(2)
 expect_identical(u1, u2)
 old <- RNGkind(); on.exit(do.call(RNGkind, as.list(old)), add = TRUE)
 suppressWarnings(RNGkind('L\'Ecuyer-CMRG', 'Box-Muller', 'Rounding'))
 # Restoring the caller's 'Rounding' sampler re-emits R's own warning about it.
 other <- suppressWarnings(guane_signal(d$tree, d$traits, 'species', 'temperature', seed = 11, nsim = 99))
 expect_identical(attr(other, 'randomized_K'), attr(ref, 'randomized_K'))
 expect_equal(RNGkind(), c("L'Ecuyer-CMRG", 'Box-Muller', 'Rounding'))
})

test_that('guane_pgls BM slope equals the independent-contrast regression slope', {
 d <- guane_test_data()
 r <- guane_pgls(d$tree, d$traits, 'species', 'body_mass', 'body_length')
 expect_equal(r$coefficients$Term, c('(Intercept)', 'body_length'))
 y <- setNames(d$traits$body_mass, d$traits$species); x <- setNames(d$traits$body_length, d$traits$species)
 slope <- unname(stats::coef(stats::lm(ape::pic(y, d$tree) ~ ape::pic(x, d$tree) - 1)))
 expect_equal(r$coefficients$Estimate[2], slope, tolerance = 1e-8)
 expect_true(all(r$coefficients$Lower < r$coefficients$Estimate & r$coefficients$Estimate < r$coefficients$Upper))
 expect_equal(r$points$Taxon, d$tree$tip.label)
 expect_equal(r$method, 'REML')
})

test_that('guane_pgls supports Pagel with fixed lambda and validates inputs', {
 d <- guane_test_data()
 p <- guane_pgls(d$tree, d$traits, 'species', 'body_mass', c('body_length', 'temperature'), model = 'Pagel', value = 1, fixed = TRUE, method = 'ML')
 bm <- guane_pgls(d$tree, d$traits, 'species', 'body_mass', c('body_length', 'temperature'), method = 'ML')
 expect_equal(p$coefficients$Estimate, bm$coefficients$Estimate, tolerance = 1e-8)
 expect_equal(as.numeric(stats::logLik(p$fit)), as.numeric(stats::logLik(bm$fit)), tolerance = 1e-8)

 tx <- d$traits; tx$double_length <- 2 * tx$body_length
 expect_error(guane_pgls(d$tree, tx, 'species', 'body_mass', c('body_length', 'double_length')), 'collinear')
 expect_error(guane_pgls(d$tree, d$traits, 'species', 'body_mass', 'body_mass'), 'distinct numeric predictors')
 expect_error(guane_pgls(d$tree, d$traits, 'species', 'body_mass', 'habitat_binary'), 'finite, numeric and nonconstant')
 expect_error(guane_pgls(d$tree, d$traits, 'species', 'body_mass', 'body_length', model = 'Pagel', value = 2), 'lambda between 0 and 1')
 expect_error(guane_pgls(d$tree, d$traits[-1, ], 'species', 'body_mass', 'body_length'), 'Match unique, nonempty taxon labels')
 expect_error(guane_pgls(d$tree, d$traits, 'nope', 'body_mass', 'body_length'), 'unique taxon column')
 nu <- d$tree; nu$edge.length[nu$edge[, 2] == 1] <- nu$edge.length[nu$edge[, 2] == 1] * 2
 expect_error(guane_pgls(nu, d$traits, 'species', 'body_mass', 'body_length'), 'ultrametric')
 expect_error(guane_pgls(ape::unroot(d$tree), d$traits, 'species', 'body_mass', 'body_length'), 'rooted, bifurcating')
})

test_that('guane_pgls_compare ranks covariance structures on one data snapshot with ML', {
 d <- guane_test_data()
 cmp <- guane_pgls_compare(d$tree, d$traits, 'species', 'body_mass', 'body_length')
 expect_equal(cmp$table$Model, c('BM', 'Grafen', 'Pagel', 'Blomberg'))
 expect_equal(cmp$settings$method, 'ML')
 ok <- is.finite(cmp$table$AIC)
 expect_true(sum(ok) >= 2)
 expect_equal(sum(cmp$table$Weight[ok]), 1, tolerance = 1e-12)
 expect_equal(min(cmp$table$Delta[ok]), 0)
 # Failed structures are reported with a message rather than dropped.
 expect_true(all(nzchar(cmp$table$Message[!ok])))
 bm <- guane_pgls(d$tree, d$traits, 'species', 'body_mass', 'body_length', method = 'ML')
 expect_equal(cmp$table$logLik[1], as.numeric(stats::logLik(bm$fit)), tolerance = 1e-8)
})

test_that('guane_pglm fits Bernoulli, Poisson and grouped-binomial models', {
 d <- guane_test_data()
 b <- guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'body_mass', event = 'aquatic')
 expect_equal(b$coefficients$Term, c('(Intercept)', 'body_mass'))
 expect_true(all(b$points$Probability > 0 & b$points$Probability < 1))
 expect_equal(b$points$Observed, as.integer(d$traits$habitat_binary[match(d$tree$tip.label, d$traits$species)] == 'aquatic'))
 expect_equal(b$reference, 'terrestrial')
 p <- guane_pglm(d$tree, d$traits, 'species', 'offspring_count', 'body_mass', method = 'poisson_GEE')
 expect_true(all(p$points$Fitted > 0))
 g <- guane_pglm(d$tree, d$traits, 'species', 'success_count', 'body_mass', method = 'binomial_GEE', trials = 'trial_count')
 expect_true(all(g$points$Probability > 0 & g$points$Probability < 1))
 expect_equal(g$trials, 'trial_count')
 cat <- guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', c('body_mass', 'parental_care_binary'), event = 'aquatic', categorical = 'parental_care_binary', references = list(parental_care_binary = 'absent'))
 expect_equal(cat$coefficients$Term[3], 'parental_care_binary [present vs absent]')
})

test_that('guane_pglm validates responses, predictors and settings', {
 d <- guane_test_data()
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'body_mass', event = 'marine'), 'Select the event state')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'locomotion_3state', 'body_mass', event = 'walking'), 'exactly two nonmissing states')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'body_mass', 'temperature', method = 'poisson_GEE'), 'nonnegative integers')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'success_count', 'body_mass', method = 'binomial_GEE'), 'total-trials column')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'trial_count', 'body_mass', method = 'binomial_GEE', trials = 'success_count'), '0 <= successes <= trials')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'diet_5state', event = 'aquatic'), 'finite, numeric and nonconstant')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'diet_5state', event = 'aquatic', categorical = 'diet_5state'), 'observed reference category')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'body_mass', event = 'aquatic', categorical = 'temperature'), 'Categorical columns must be selected predictors.')
 expect_error(guane_pglm(d$tree, d$traits, 'species', 'habitat_binary', 'body_mass', method = 'probit'), "'arg' should be one of")
})

test_that('guane_pagel validates binary inputs before fitting', {
 d <- guane_test_data()
 expect_error(guane_pagel(d$tree, d$traits, 'species', 'habitat_binary', 'habitat_binary'), 'two different binary trait columns')
 expect_error(guane_pagel(d$tree, d$traits, 'species', 'habitat_binary', 'locomotion_3state'), 'exactly two observed, nonmissing states')
 expect_error(guane_pagel(d$tree, d$traits, 'species', 'habitat_binary', 'parental_care_binary', starts = 0), 'one to five optimization starts')
 expect_error(guane_pagel(d$tree, d$traits, 'species', 'habitat_binary', 'parental_care_binary', max_rate = -1), 'maximum transition rate')
 expect_error(guane_pagel(d$tree, d$traits[-1, ], 'species', 'habitat_binary', 'parental_care_binary'), 'at least four taxa with unique, matching labels')
 expect_error(guane_pagel(ape::unroot(d$tree), d$traits, 'species', 'habitat_binary', 'parental_care_binary'), 'rooted, bifurcating')
 tx <- d$traits; tx$habitat_binary[2] <- NA
 expect_error(guane_pagel(d$tree, tx, 'species', 'habitat_binary', 'parental_care_binary'), 'exactly two observed')
})

# Twelve taxa: all four joint states, and enough data for the 8-rate dependent model to converge from one start.
pagel_data <- function() {
 d <- guane_test_data(); k <- d$tree$tip.label[1:12]
 list(tree = ape::keep.tip(d$tree, k), traits = d$traits[d$traits$species %in% k, ])
}

test_that('guane_pagel fits the independent and dependent models', {
 skip_if_not_installed('phytools', minimum_version = '2.5-2')
 p <- pagel_data()
 r <- guane_pagel(p$tree, p$traits, 'species', 'habitat_binary', 'parental_care_binary', starts = 1)
 expect_equal(r$comparison$Model, c('independent', 'dependent'))
 expect_equal(r$comparison$Parameters, c(4, 8))
 expect_true(r$comparison$LogLik[2] >= r$comparison$LogLik[1] - 1e-6)
 expect_equal(r$test$df, 4)
 expect_equal(r$test$LR, 2 * max(0, diff(r$comparison$LogLik)), tolerance = 1e-10)
 expect_equal(r$test$P, stats::pchisq(r$test$LR, 4, lower.tail = FALSE))
 expect_equal(r$mapping$State0, c('aquatic', 'absent'))
 expect_equal(sum(r$counts$Count), 12L)
 expect_true(all(r$rates$Rate >= 0))
 expect_true(all(r$diagnostics$Accepted))
})
