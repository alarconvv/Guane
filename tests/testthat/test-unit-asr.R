# Unit tests: ancestral state reconstruction (R/core_mod_asr*.R).

asr_cache <- new.env()
asr_mk <- function() {
 if (is.null(asr_cache$mk)) { d <- guane_test_data(); asr_cache$mk <- guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary') }
 asr_cache$mk
}

test_that('guane_mk_matrix builds ER, SYM and ARD templates', {
 s <- c('a', 'b', 'c')
 er <- guane_mk_matrix(s, 'ER')
 expect_equal(dimnames(er), list(s, s))
 expect_true(all(diag(er) == 0)); expect_true(all(er[row(er) != col(er)] == 1))
 sym <- guane_mk_matrix(s, 'SYM')
 expect_equal(sym, t(sym)); expect_equal(sort(unique(sym[upper.tri(sym)])), 1:3)
 ard <- guane_mk_matrix(s, 'ARD')
 expect_equal(sort(ard[row(ard) != col(ard)]), 1:6)
 expect_equal(max(guane_mk_matrix(letters[1:2], 'SYM')), 1)
})

test_that('guane_mk_matrix accepts valid Custom matrices from text or matrices', {
 s <- c('a', 'b', 'c')
 m <- guane_mk_matrix(s, 'Custom', '0,1,0\n2,0,1\n0,2,0')
 expect_equal(unname(m), matrix(c(0, 1, 0, 2, 0, 1, 0, 2, 0), 3, byrow = TRUE))
 expect_equal(dimnames(m), list(s, s))
 m2 <- guane_mk_matrix(s, 'Custom', matrix(c(0, 1, 0, 2, 0, 1, 0, 2, 0), 3, byrow = TRUE))
 expect_equal(m2, m)
})

test_that('guane_mk_matrix rejects invalid models and Custom matrices with explicit messages', {
 s <- c('a', 'b', 'c')
 expect_error(guane_mk_matrix(s, 'XYZ'), 'Unknown Mk model.')
 expect_error(guane_mk_matrix('a', 'ER'), '2 to 10 observed states')
 expect_error(guane_mk_matrix(letters[1:11], 'ER'), '2 to 10 observed states')
 expect_error(guane_mk_matrix(s, 'Custom', '0,1\n1,0'), 'one row and column per state')
 expect_error(guane_mk_matrix(s, 'Custom', '1,1,1\n1,0,1\n1,1,0'), 'zero diagonal')
 expect_error(guane_mk_matrix(s, 'Custom', '0,-1,1\n1,0,1\n1,1,0'), 'nonnegative integer')
 expect_error(guane_mk_matrix(s, 'Custom', '0,1.5,1\n1,0,1\n1,1,0'), 'nonnegative integer')
 expect_error(guane_mk_matrix(s, 'Custom', '0,x,1\n1,0,1\n1,1,0'), 'nonnegative integer')
 expect_error(guane_mk_matrix(s, 'Custom', '0,1,3\n1,0,1\n1,1,0'), 'consecutive')
 expect_error(guane_mk_matrix(s, 'Custom', '0,0,0\n0,0,0\n0,0,0'), 'consecutive')
 expect_error(guane_mk_matrix(s, 'Custom', '0,1,0\n0,0,0\n0,0,0'), 'No ancestral state can reach all observed states')
 named <- matrix(c(0, 1, 1, 0), 2, dimnames = list(c('b', 'a'), c('b', 'a')))
 expect_error(guane_mk_matrix(c('a', 'b'), 'Custom', named), 'names must match')
})

test_that('guane_mk_data validates trees, taxa and discrete states', {
 d <- guane_test_data()
 z <- guane_mk_data(d$tree, d$traits, 'species', 'habitat_binary')
 expect_equal(z$states, c('aquatic', 'terrestrial'))
 expect_equal(names(z$x), d$tree$tip.label)
 expect_error(guane_mk_data(d$tree, d$traits, 'species', 'resource_use_polymorphic'), 'polymorphic states are not supported')
 expect_error(guane_mk_data(d$tree, d$traits, 'species', 'body_mass'), 'continuous values are not binned')
 expect_error(guane_mk_data(d$tree, d$traits[-1, ], 'species', 'habitat_binary'), 'Match unique taxon labels')
 expect_error(guane_mk_data(d$tree, d$traits, 'species', 'species'), 'distinct taxon and discrete trait')
 expect_error(guane_mk_data(ape::unroot(d$tree), d$traits, 'species', 'habitat_binary'), 'rooted, bifurcating')
 tr <- d$tree; tr$edge.length[1] <- 0
 expect_error(guane_mk_data(tr, d$traits, 'species', 'habitat_binary'), 'positive branch lengths')
 tx <- d$traits; tx$habitat_binary[1] <- NA
 expect_error(guane_mk_data(d$tree, tx, 'species', 'habitat_binary'), 'one unambiguous state')
})

test_that('guane_asr_mk ML on habitat_binary gives valid marginal probabilities', {
 d <- guane_test_data(); r <- asr_mk()
 p <- r$probabilities
 expect_equal(nrow(p), d$tree$Nnode)
 expect_equal(rownames(p), as.character(length(d$tree$tip.label) + seq_len(d$tree$Nnode)))
 expect_equal(colnames(p), c('aquatic', 'terrestrial'))
 expect_equal(unname(rowSums(p)), rep(1, nrow(p)), tolerance = 1e-8)
 expect_true(all(p >= -1e-8 & p <= 1 + 1e-8))
 expect_true(is.finite(r$logLik))
 expect_equal(unname(rowSums(r$Q)), c(0, 0), tolerance = 1e-12)
 # ER/SYM are equivalent for two states: only one entry receives AIC weight.
 expect_setequal(r$comparison$Model, c('ER', 'ARD'))
 expect_match(r$comparison$Equivalent[r$comparison$Model == 'ER'], 'SYM')
 expect_equal(sum(r$comparison$Weight, na.rm = TRUE), 1, tolerance = 1e-12)
 # The ML fit matches phytools::fitMk directly.
 x <- setNames(factor(d$traits$habitat_binary), d$traits$species)[d$tree$tip.label]
 ref <- phytools::fitMk(d$tree, x, model = 'ER', pi = 'equal')
 expect_equal(r$logLik, ref$logLik, tolerance = 1e-5)
})

test_that('guane_asr_mk rejects incompatible settings', {
 d <- guane_test_data()
 expect_error(guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary', advanced = list(rate_mode = 'fixed')), 'Turn off model comparison when supplying fixed Q.')
 expect_error(guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary', advanced = list(start_mode = 'custom')), 'Turn off model comparison when supplying custom starting rates.')
 expect_error(guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary', compare = FALSE, advanced = list(bogus = 1)), 'Unknown advanced Mk setting.')
 expect_error(guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary', compare = FALSE, advanced = list(root = 'custom', root_weights = 'aquatic,1')), 'Root weights must name every allowed state')
})

test_that('guane_asr_mk supports fixed Q and joint reconstruction', {
 d <- guane_test_data()
 q <- 'x,aquatic,terrestrial\naquatic,-1,1\nterrestrial,1,-1'
 r <- guane_asr_mk(d$tree, d$traits, 'species', 'habitat_binary', compare = FALSE, advanced = list(rate_mode = 'fixed', fixed_Q = q, reconstruction = 'joint'))
 expect_equal(unname(r$Q), matrix(c(-1, 1, 1, -1), 2))
 expect_true(is.na(r$comparison$AIC))
 expect_true(all(r$joint$states %in% c('aquatic', 'terrestrial')))
 expect_equal(names(r$joint$states), rownames(r$probabilities))
})

test_that('guane_mk_call_preview returns parseable code without fitting', {
 d <- guane_test_data()
 z <- guane_mk_data(d$tree, d$traits, 'species', 'habitat_binary')
 code <- guane_mk_call_preview(z, guane_mk_matrix(z$states, 'ER'))
 expect_silent(parse(text = code))
 expect_true(any(grepl('phytools::ancr', code, fixed = TRUE)))
 expect_error(guane_mk_call_preview(z, guane_mk_matrix(z$states, 'ER'), advanced = list(optimizer = 'bfgs')), 'Invalid advanced Mk choice.')
})

test_that('guane_asr_map is reproducible with a fixed seed and preserves the caller RNG state', {
 r <- asr_mk()
 a <- guane_asr_map(r, nsim = 10, seed = 42)
 b <- guane_asr_map(r, nsim = 10, seed = 42)
 c <- guane_asr_map(r, nsim = 10, seed = 43)
 expect_identical(a$mapping$node_states, b$mapping$node_states)
 expect_identical(a$mapping$changes, b$mapping$changes)
 expect_false(identical(a$mapping$times, c$mapping$times))
 expect_equal(a$mapping$nsim, 10); expect_equal(a$mapping$seed, 42)
 expect_equal(unname(rowSums(a$mapping$frequencies)), rep(1, nrow(r$probabilities)))
 expect_equal(unname(rowSums(a$mapping$times)), rep(sum(r$tree$edge.length), 10), tolerance = 1e-8)

 set.seed(7); u1 <- runif(3)
 set.seed(7); guane_asr_map(r, nsim = 5, seed = 1); u2 <- runif(3)
 expect_identical(u1, u2)
})

test_that('guane_asr_map validates its settings', {
 r <- asr_mk()
 expect_error(guane_asr_map(r, nsim = 1), 'between 2 and 500')
 expect_error(guane_asr_map(r, nsim = 2.5), 'between 2 and 500')
 expect_error(guane_asr_map(r, nsim = 10, seed = -1), 'integer seed')
 bad <- r; bad$Q[1, 2] <- -1
 expect_error(guane_asr_map(bad, nsim = 10), 'valid fitted Q matrix')
})

test_that('guane_asr_continuous fastAnc gives BM ML node estimates consistent with Gaussian ML', {
 d <- guane_test_data()
 ct <- guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass')
 expect_equal(ct$engine, 'fastAnc')
 expect_equal(nrow(ct$nodes), d$tree$Nnode)
 expect_true(all(ct$nodes$Lower <= ct$nodes$Estimate & ct$nodes$Estimate <= ct$nodes$Upper))
 x <- setNames(d$traits$body_mass, d$traits$species)[d$tree$tip.label]
 expect_equal(unname(ct$ace), unname(phytools::fastAnc(d$tree, x)[names(ct$ace)]), tolerance = 1e-10)
 # The BM ML root equals the GLS mean.
 expect_equal(unname(ct$ace[1]), ct$root, tolerance = 1e-8)
 ga <- guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', engine = 'Gaussian ML')
 expect_equal(unname(ga$ace), unname(ct$ace), tolerance = 1e-6)
 expect_equal(ga$logLik, ct$logLik, tolerance = 1e-5)
 expect_equal(ga$rate, ct$rate, tolerance = 1e-4)
})

test_that('guane_asr_continuous Gaussian ML model comparison and anc.ML EB run', {
 d <- guane_test_data()
 ga <- guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', engine = 'Gaussian ML', compare = TRUE)
 expect_equal(ga$comparison$Model, c('BM', 'OU', 'EB'))
 expect_equal(sum(ga$comparison$AkaikeWeight), 1, tolerance = 1e-10)
 eb <- guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', model = 'EB')
 expect_equal(eb$engine, 'anc.ML'); expect_equal(nrow(eb$nodes), d$tree$Nnode)
 expect_true(all(is.finite(eb$nodes$Estimate)))
})

test_that('guane_asr_continuous anc.ML OU runs without node intervals', {
 d <- guane_test_data()
 ou <- guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', model = 'OU')
 expect_equal(ou$engine, 'anc.ML'); expect_equal(ou$model, 'OU')
 expect_equal(nrow(ou$nodes), d$tree$Nnode)
 expect_true(all(is.finite(ou$nodes$Estimate)))
 expect_true(all(is.na(ou$nodes$Lower)))
 expect_true(is.finite(ou$alpha) && ou$alpha > 0)
 expect_true(any(grepl('OU implementation has not been thoroughly tested', ou$warnings)))
})

test_that('guane_asr_continuous validates engine, model and trait', {
 d <- guane_test_data()
 expect_error(guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', model = 'OU', engine = 'fastAnc'), 'Choose fastAnc for BM')
 expect_error(guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', se_column = 'temperature'), 'Measurement error and model comparison require Gaussian ML.')
 expect_error(guane_asr_continuous(d$tree, d$traits, 'species', 'habitat_binary'), 'finite, nonconstant numeric trait')
 expect_error(guane_asr_continuous(d$tree, d$traits, 'species', 'body_mass', model = 'EB', maxit = 0), 'Maximum iterations')
 expect_error(guane_asr_gaussian(d$tree, d$traits, 'species', 'body_mass', model = 'OU', shape_bounds = c(-1, 1)), 'Invalid shape bounds')
 expect_error(guane_asr_gaussian(d$tree, d$traits, 'species', 'body_mass', se_column = 'habitat_binary'), 'Standard errors must be finite')
})

test_that('guane_asr_bayes (continuous) runs with tiny settings and is seed-reproducible', {
 d <- guane_test_data()
 run <- function() suppressWarnings(guane_asr_bayes(d$tree, d$traits, 'species', 'body_mass', ngen = 2000, sample = 50, burnin = 500, chains = 1, seed = 5))
 a <- utils::capture.output(ra <- run()); b <- utils::capture.output(rb <- run())
 expect_identical(ra$ace, rb$ace)
 expect_equal(nrow(ra$nodes), d$tree$Nnode)
 expect_true(nrow(ra$bayes$retained[[1]]) >= 20)
 expect_true(any(grepl('split-Rhat is unavailable', ra$warnings)))
 expect_error(guane_asr_bayes(d$tree, d$traits, 'species', 'body_mass', ngen = 2000, sample = 30), 'divisible')
 expect_error(guane_asr_bayes(d$tree, d$traits, 'species', 'body_mass', ngen = 1000, sample = 100, burnin = 900), 'at least 20 saved draws')
})

test_that('guane_asr_mk_bayes runs with tiny settings and yields posterior node probabilities', {
 d <- guane_test_data()
 utils::capture.output(r <- guane_asr_mk_bayes(d$tree, d$traits, 'species', 'habitat_binary', nsim = 20, burnin = 10, samplefreq = 5, chains = 1, seed = 1))
 expect_equal(dim(r$probabilities), c(d$tree$Nnode, 2L))
 expect_equal(unname(rowSums(r$probabilities)), rep(1, d$tree$Nnode), tolerance = 1e-6)
 expect_equal(r$bayes$chains, 1); expect_equal(nrow(r$bayes$draws), 20L)
 expect_error(guane_asr_mk_bayes(d$tree, d$traits, 'species', 'habitat_binary', nsim = 5), 'Choose 20')
 expect_error(guane_mk_bayes_parameters(matrix(c(0, 1, 1, 0), 2), 'Parameter,Shape,Rate,ProposalVariance\nq1,-1,1,1'), 'finite and positive')
})

test_that('guane_poly_data and guane_poly_matrix encode coexistence states', {
 d <- guane_test_data()
 z <- guane_poly_data(d$tree, d$traits, 'species', 'resource_use_polymorphic')
 expect_equal(z$states, c('fruit', 'insect', 'seed', 'fruit+insect', 'fruit+seed', 'insect+seed', 'fruit+insect+seed'))
 expect_equal(unname(rowSums(z$tip_likelihood)), rep(1, length(d$tree$tip.label)))
 m <- guane_poly_matrix(z$states, 'ER')
 expect_equal(m['fruit', 'fruit+seed'], 1); expect_equal(m['fruit', 'seed'], 0)
 expect_equal(m['fruit', 'fruit+insect+seed'], 0); expect_equal(m['fruit+seed', 'fruit+insect+seed'], 1)
 tr <- guane_poly_matrix(z$states, 'transient')
 expect_true(all(tr[m > 0] %in% 1:2))
 expect_error(guane_poly_matrix(z$states, 'XYZ'), 'Unknown polymorphic model.')
 expect_error(guane_poly_data(d$tree, d$traits, 'species', 'habitat_binary'), 'at least one polymorphic taxon')
 tx <- d$traits; tx$resource_use_polymorphic[1] <- 'fruit/seed'
 expect_error(guane_poly_data(d$tree, tx, 'species', 'resource_use_polymorphic'), 'Code coexisting states with \\+')
 expect_error(guane_poly_data(d$tree, d$traits, 'species', 'resource_use_polymorphic', ordered = TRUE, state_order = c('fruit', 'seed')), 'State order must contain every constituent')
})

test_that('guane_asr_poly ML on resource_use_polymorphic gives valid probabilities', {
 d <- guane_test_data()
 r <- guane_asr_poly(d$tree, d$traits, 'species', 'resource_use_polymorphic', compare = FALSE)
 expect_equal(nrow(r$probabilities), d$tree$Nnode)
 expect_equal(ncol(r$probabilities), 7L)
 expect_equal(unname(rowSums(r$probabilities)), rep(1, d$tree$Nnode), tolerance = 1e-8)
 expect_true(isTRUE(r$polymorphic))
 expect_equal(r$Q[r$index == 0 & row(r$Q) != col(r$Q)], rep(0, sum(r$index == 0) - 7))
})
