test_that("core_signal_summary summarizes numeric traits", {
  result <- core_signal_summary(c(1, 2, 3, NA))

  expect_equal(result$n, 4)
  expect_equal(result$n_missing, 1)
  expect_equal(result$mean, 2)
  expect_true(is.numeric(result$sd))
})


test_that("core_signal_summary rejects non-numeric traits", {
  expect_error(
    core_signal_summary(c("small", "large")),
    "`trait` must be numeric"
  )
})
