test_that("core_diagnose_tree_traits detects compatible data", {
  tree <- ape::rtree(5)

  traits <- data.frame(
    species = tree$tip.label,
    body_size = stats::rnorm(5)
  )

  result <- core_diagnose_tree_traits(
    tree = tree,
    traits = traits,
    taxon_col = "species"
  )

  expect_true(result$analysis_ready)
  expect_equal(result$n_matched_taxa, 5)
})


test_that("core_diagnose_tree_traits detects duplicated taxa", {
  tree <- ape::rtree(5)

  traits <- data.frame(
    species = tree$tip.label,
    body_size = stats::rnorm(5)
  )

  traits$species[2] <- traits$species[1]

  result <- core_diagnose_tree_traits(
    tree = tree,
    traits = traits,
    taxon_col = "species"
  )

  expect_false(result$analysis_ready)
  expect_true(any(result$issues$issue == "Duplicated taxon names in trait table"))
})
