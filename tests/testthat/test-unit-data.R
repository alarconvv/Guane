# Unit tests: data layer (R/core_mod_data_base.R).

example_file <- function(...) file.path(guane_resource_root(), ...)

test_that('guane_example returns the synthetic tree and trait table with the intentional Sp20 mismatch', {
 d <- guane_example()
 expect_s3_class(d$tree, 'phylo')
 expect_s3_class(d$traits, 'data.frame')
 expect_equal(length(d$tree$tip.label), 20L)
 expect_equal(nrow(d$traits), 19L)
 expect_equal(setdiff(d$tree$tip.label, d$traits$species), 'Sp20')
 expect_true(all(c('body_mass', 'habitat_binary', 'resource_use_polymorphic', 'trial_count') %in% names(d$traits)))
})

test_that('test fixture removes the mismatch and yields a matched, ultrametric, binary tree', {
 d <- guane_test_data()
 expect_setequal(d$tree$tip.label, d$traits$species)
 expect_true(ape::is.ultrametric(d$tree))
 expect_true(ape::is.binary(d$tree))
 expect_equal(nrow(guane_validate(d$tree, d$traits, 'species', 'body_mass')), 0L)
})

test_that('guane_read_tree reads Newick and NEXUS files and rejects multi-tree uploads', {
 nwk <- example_file('example_files', 'guane_test_tree.nwk')
 tr <- guane_read_tree(nwk)
 expect_s3_class(tr, 'phylo')
 expect_equal(sort(tr$tip.label), sprintf('sp_%02d', 1:12))

 nex <- tempfile(fileext = '.nex'); on.exit(unlink(nex), add = TRUE)
 ape::write.nexus(tr, file = nex)
 tr2 <- guane_read_tree(nex)
 expect_s3_class(tr2, 'phylo')
 expect_setequal(tr2$tip.label, tr$tip.label)
 expect_equal(sum(tr2$edge.length), sum(tr$edge.length), tolerance = 1e-8)

 multi <- tempfile(fileext = '.nwk'); on.exit(unlink(multi), add = TRUE)
 writeLines(c(ape::write.tree(tr), ape::write.tree(tr)), multi)
 expect_error(guane_read_tree(multi), 'Upload exactly one tree')
})

test_that('the example_files pair recommended in README_guane_examples.txt is analysis-ready', {
 tr <- guane_read_tree(example_file('example_files', 'guane_test_tree.nwk'))
 expect_true(ape::is.rooted(tr)); expect_true(ape::is.binary(tr)); expect_true(ape::is.ultrametric(tr))
 tx <- guane_read_traits(example_file('example_files', 'guane_test_traits.csv'))
 expect_equal(nrow(guane_validate(tr, tx, 'species', 'body_mass')), 0L)
})

test_that('guane_validate reports the taxon mismatch in guane_bad_traits_mismatch.csv', {
 tr <- guane_read_tree(example_file('example_files', 'guane_test_tree.nwk'))
 bad <- guane_read_traits(example_file('example_files', 'guane_bad_traits_mismatch.csv'))
 issues <- guane_validate(tr, bad, 'species', 'body_mass')
 expect_equal(issues$level, 'Error')
 expect_match(issues$message, '1 tree tips without traits; 1 table taxa outside tree', fixed = TRUE)
})

test_that('guane_validate reports missing inputs and missing columns as Required', {
 d <- guane_test_data()
 none <- guane_validate(NULL, NULL, NULL, NULL)
 expect_setequal(none$message, c('Load a phylogenetic tree.', 'Load a CSV trait table.'))
 expect_true(all(none$level == 'Required'))
 no_taxon <- guane_validate(d$tree, d$traits, 'not_a_column', 'body_mass')
 expect_true('Select the taxon column.' %in% no_taxon$message)
 no_trait <- guane_validate(d$tree, d$traits, 'species', NULL)
 expect_true('Select a numeric trait.' %in% no_trait$message)
})

test_that('guane_validate flags duplicated and empty labels in tree and table', {
 d <- guane_test_data()
 tr <- d$tree; tr$tip.label[2] <- tr$tip.label[1]
 expect_true('Tree tip labels must be unique.' %in% guane_validate(tr, d$traits, 'species', 'body_mass')$message)
 tx <- d$traits; tx$species[2] <- tx$species[1]
 expect_true('Trait taxon labels must be unique.' %in% guane_validate(d$tree, tx, 'species', 'body_mass')$message)
 tx <- d$traits; tx$species[3] <- ' '
 expect_true('Trait table contains empty taxon labels.' %in% guane_validate(d$tree, tx, 'species', 'body_mass')$message)
})

test_that('guane_validate checks trait values, branch lengths, rooting and ultrametricity', {
 d <- guane_test_data()
 expect_true(any(grepl('finite numeric', guane_validate(d$tree, d$traits, 'species', 'habitat_binary')$message)))
 tx <- d$traits; tx$body_mass[1] <- NA
 expect_true(any(grepl('finite numeric', guane_validate(d$tree, tx, 'species', 'body_mass')$message)))
 tx <- d$traits; tx$body_mass <- 1
 expect_true('Selected trait has no variation.' %in% guane_validate(d$tree, tx, 'species', 'body_mass')$message)

 tr <- d$tree; tr$edge.length[1] <- 0
 expect_true(any(grepl('positive branch lengths', guane_validate(tr, d$traits, 'species', 'body_mass')$message)))
 tr <- d$tree; tr$edge.length <- NULL
 expect_true(any(grepl('positive branch lengths', guane_validate(tr, d$traits, 'species', 'body_mass')$message)))

 un <- ape::unroot(d$tree)
 expect_true('Root the tree before signal analysis.' %in% guane_validate(un, d$traits, 'species', 'body_mass')$message)

 nu <- d$tree; nu$edge.length[nu$edge[, 2] == 1] <- nu$edge.length[nu$edge[, 2] == 1] * 1.5
 v <- guane_validate(nu, d$traits, 'species', 'body_mass')
 expect_true('Note' %in% v$level)
 expect_false(any(v$level %in% c('Error', 'Required')))
})

test_that('guane_validate requires at least four taxa', {
 d <- guane_test_data()
 keep <- d$tree$tip.label[1:3]
 tr <- ape::keep.tip(d$tree, keep); tx <- d$traits[d$traits$species %in% keep, ]
 expect_true('At least four matched taxa are required.' %in% guane_validate(tr, tx, 'species', 'body_mass')$message)
})

test_that('guane_transform derives new columns and rejects invalid transformations', {
 d <- guane_test_data()
 z <- guane_transform(d$traits, 'body_mass', 'log')
 expect_equal(z$column, 'body_mass_log')
 expect_equal(z$traits$body_mass_log, log(d$traits$body_mass))
 expect_equal(guane_transform(d$traits, 'body_mass', 'reciprocal')$traits$body_mass_reciprocal, 1 / d$traits$body_mass)
 expect_equal(guane_transform(d$traits, 'body_mass', 'quadratic')$traits$body_mass_quadratic, d$traits$body_mass^2)
 expect_error(guane_transform(z$traits, 'body_mass', 'log'), 'derived column already exists')
 expect_error(guane_transform(d$traits, 'offspring_count', 'log'), 'Log requires positive values.')
 expect_error(guane_transform(d$traits, 'offspring_count', 'reciprocal'), 'Reciprocal requires nonzero values.')
 tx <- d$traits; tx$body_mass[1] <- NA
 expect_error(guane_transform(tx, 'body_mass', 'log'), 'Correct nonfinite values first.')
 expect_error(guane_transform(d$traits, 'body_mass', 'sqrt'), 'Transformation produced nonfinite values.')
 expect_equal(guane_transform(d$traits, 'temperature', 'exp')$traits$temperature_exp, exp(d$traits$temperature))
 tx <- d$traits; tx$big <- 1000
 expect_error(guane_transform(tx, 'big', 'exp'), 'Transformation produced nonfinite values.')
})

test_that('guane_normality and guane_distribution validate their input', {
 x <- guane_test_data()$traits$body_mass
 expect_equal(guane_normality(x)$statistic, stats::shapiro.test(x)$statistic)
 expect_error(guane_normality(c(1, 2)), 'Shapiro-Wilk')
 expect_error(guane_normality(rep(1, 10)), 'Shapiro-Wilk')
 d <- guane_distribution(c(1, NA, Inf, 3))
 expect_equal(d$values, c(1, 3)); expect_equal(d$excluded, 2L)
 expect_error(guane_distribution(letters), 'Select a numeric trait.')
})

test_that('guane_pic matches ape::pic in tree order and refuses unresolved data issues', {
 d <- guane_test_data()
 z <- guane_pic(d$tree, d$traits, 'species', 'body_mass')
 ref <- ape::pic(setNames(d$traits$body_mass, d$traits$species), d$tree)
 expect_equal(z$Contrast, as.numeric(ref))
 expect_equal(nrow(z), d$tree$Nnode)
 bad <- d$traits[-1, ]
 expect_error(guane_pic(d$tree, bad, 'species', 'body_mass'), 'Resolve data issues')
})

test_that('guane_r_assignment round-trips trees, data frames with NA and integers', {
 d <- guane_test_data()
 tx <- d$traits; tx$body_mass[2] <- NA; tx$f <- factor(tx$habitat_binary)
 for (value in list(d$tree, tx, 1:3, c(a = 1.5, b = NA), list(x = NULL, y = 'z'))) {
  code <- guane_r_assignment('obj', value)
  env <- new.env()
  eval(parse(text = code), env)
  expect_equal(env$obj, value, tolerance = 1e-14)
  expect_identical(lapply(env$obj, class), lapply(value, class))
 }
})

test_that('guane_r_assignment preserves double precision exactly', {
 d <- guane_test_data()
 for (value in list(d$tree, d$traits, c(1 / 3, pi, 0.1 + 0.2, 1e-300, .Machine$double.eps))) {
  env <- new.env(); eval(parse(text = guane_r_assignment('obj', value)), env)
  expect_identical(env$obj, value)
 }
})

test_that('preparation and editable data-plot scripts parse and run', {
 d <- guane_test_data()
 s <- guane_preparation_script(list(guane_r_assignment('tree', d$tree), guane_r_assignment('traits', d$traits)))
 expect_silent(parse(text = s))
 env <- new.env(); eval(parse(text = s[!grepl('sessionInfo', s)]), env)
 expect_identical(env$tree, d$tree); expect_identical(env$traits, d$traits)

 for (kind in c('tree', 'distribution')) {
  settings <- if (kind == 'tree') list(tree = d$tree, layout = 'phylogram', direction = 'rightwards', lengths = TRUE, labels = TRUE, font = .8, edge = 1, nodes = FALSE)
   else list(x = d$traits$body_mass, type = 'hist', bins = 10, rug = TRUE, label = 'body_mass')
  s <- guane_data_plot_script(kind, settings)
  expr <- parse(text = s)
  pdf(NULL); on.exit(grDevices::dev.off(), add = TRUE)
  env <- new.env(parent = globalenv())
  expect_no_error(for (e in expr[-length(expr)]) eval(e, env))
 }
})

with_limits <- function(opts, code) {
 old <- options(opts); on.exit(options(old), add = TRUE)
 force(code)
}

test_that('guane_limits has server defaults and honours (clamped) options', {
 with_limits(list(guane.max_tips = NULL, guane.max_rows = NULL, guane.max_columns = NULL), {
  withr_env <- Sys.getenv(c('GUANE_MAX_TIPS', 'GUANE_MAX_ROWS', 'GUANE_MAX_COLUMNS'), unset = NA)
  skip_if(any(!is.na(withr_env)), 'GUANE_MAX_* environment variables are set')
  expect_equal(guane_limits(), list(tips = 5000, rows = 50000, columns = 500))
 })
 with_limits(list(guane.max_tips = 10, guane.max_rows = 20, guane.max_columns = 3), expect_equal(guane_limits(), list(tips = 10, rows = 20, columns = 3)))
 with_limits(list(guane.max_tips = 1, guane.max_columns = 0), {
  expect_equal(guane_limits()$tips, 4); expect_equal(guane_limits()$columns, 2)
 })
})

test_that('oversized trees are rejected on reading and reported by guane_validate', {
 d <- guane_test_data(); nwk <- example_file('example_files', 'guane_test_tree.nwk')
 msg <- 'This tree exceeds the maximum number of tips supported on this server. Run the exported R script locally for larger trees.'
 with_limits(list(guane.max_tips = 10), {
  expect_error(guane_read_tree(nwk), msg, fixed = TRUE)
  expect_error(guane_check_tree_size(d$tree), msg, fixed = TRUE)
  v <- guane_validate(d$tree, d$traits, 'species', 'body_mass')
  expect_true(msg %in% v$message[v$level == 'Error'])
 })
 with_limits(list(guane.max_tips = 12), {
  expect_s3_class(guane_read_tree(nwk), 'phylo')
  expect_identical(guane_check_tree_size(d$tree$edge), d$tree$edge)
 })
 expect_identical(guane_check_tree_size(d$tree), d$tree)
})

test_that('guane_read_traits enforces row and column limits', {
 csv <- example_file('example_files', 'guane_test_traits.csv')
 tx <- guane_read_traits(csv)
 expect_equal(dim(tx), c(12L, 4L))
 expect_identical(tx, utils::read.csv(csv, check.names = FALSE))
 msg <- 'This trait table exceeds the maximum size supported on this server.'
 with_limits(list(guane.max_rows = 11), expect_error(guane_read_traits(csv), msg, fixed = TRUE))
 with_limits(list(guane.max_rows = 12), expect_equal(nrow(guane_read_traits(csv)), 12L))
 with_limits(list(guane.max_columns = 3), expect_error(guane_read_traits(csv), msg, fixed = TRUE))
})

test_that('guane_ltt_read stops as soon as more than 25 trees are read', {
 tr <- guane_test_data()$tree
 f <- tempfile(fileext = '.nwk'); on.exit(unlink(f), add = TRUE)
 writeLines(rep(ape::write.tree(tr), 26), f)
 expect_error(guane_ltt_read(f, 'many'), 'Choose one to 25 trees for LTT.')
 writeLines(rep(ape::write.tree(tr), 13), f)
 expect_error(guane_ltt_read(c(f, f), c('a', 'b')), 'Choose one to 25 trees for LTT.')
 two <- guane_ltt_read(f, 'x')
 expect_length(two, 13); expect_equal(names(two)[1], 'x [1]')
 with_limits(list(guane.max_tips = 10), expect_error(guane_ltt_read(f, 'x'), 'maximum number of tips'))
})

test_that('guane_csv_safe neutralises spreadsheet formulas only in text', {
 x <- c('=SUM(A1)', '+1', '-2', '@cmd', '\tTab', '\rCR', 'safe', 'a=b', NA, '')
 expect_equal(guane_csv_safe(x), c("'=SUM(A1)", "'+1", "'-2", "'@cmd", "'\tTab", "'\rCR", 'safe', 'a=b', NA, ''))
 expect_equal(guane_csv_safe(factor('=x')), "'=x")
})

test_that('guane_write_csv protects cells, names and row names but leaves numbers untouched', {
 f <- tempfile(fileext = '.csv'); on.exit(unlink(f), add = TRUE)
 x <- data.frame(`=name` = c('=1+1', 'ok'), value = c(-1.5, 2), f = factor(c('@a', 'b')), check.names = FALSE, stringsAsFactors = FALSE)
 rownames(x) <- c('-r1', 'r2')
 guane_write_csv(x, f)
 y <- utils::read.csv(f, check.names = FALSE, stringsAsFactors = FALSE, row.names = 1)
 expect_equal(names(y), c("'=name", 'value', 'f'))
 expect_equal(y[["'=name"]], c("'=1+1", 'ok'))
 expect_equal(y$value, c(-1.5, 2))
 expect_equal(y$f, c("'@a", 'b'))
 expect_equal(rownames(y), c("'-r1", 'r2'))
 guane_write_csv(data.frame(a = c('+x', 'y')), f, row.names = FALSE)
 z <- utils::read.csv(f, stringsAsFactors = FALSE)
 expect_equal(z$a, c("'+x", 'y')); expect_equal(ncol(z), 1L)
 # Default integer row names stay numeric.
 guane_write_csv(data.frame(n = c(-3, 4)), f)
 expect_equal(utils::read.csv(f)[[1]], c(1, 2))
})
