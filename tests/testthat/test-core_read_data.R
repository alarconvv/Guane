test_that("core_read_tree reads a Newick tree", {
  tree <- ape::rtree(5)
  path <- tempfile(fileext = ".nwk")

  ape::write.tree(tree, file = path)

  result <- core_read_tree(path)

  expect_s3_class(result, "phylo")
  expect_equal(length(result$tip.label), 5)
})


test_that("core_read_traits reads a CSV trait table", {
  traits <- data.frame(
    species = paste0("t", 1:5),
    body_size = 1:5
  )

  path <- tempfile(fileext = ".csv")
  readr::write_csv(traits, path)

  result <- core_read_traits(path)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 5)
  expect_true("species" %in% names(result))
})
