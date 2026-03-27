#' Tests for the get_species_itis function
#'

# test null itis
test_that("get_reference_points with null stock_id", {
  expect_error(get_reference_points(stock = NULL))
})

# test stock id
test_that("get_reference_points with a valid stock_id", {
  res <- get_reference_points(stock = "10509")
  expect_true(nrow(res) > 0)
})

# test stock id
test_that("get_reference_points with an invalid stock_id", {
  expect_error(get_reference_points(stock = "105093"))
})


# test null both argument
test_that("get_reference_points with invalid ref_point", {
  expect_error(get_reference_points(stock = "10509", ref_point = "hello"))
})
