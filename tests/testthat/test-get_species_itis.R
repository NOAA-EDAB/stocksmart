#' Tests for the get_species_itis function
#'

# test null itis
test_that("get_species_itis with null itis", {
  res <- get_species_itis(stock = "Albacore")
  expect_true(nrow(res) > 0)
  expect_true(any(res$itis == 172419))
  expect_true("itis" %in% colnames(res))
  expect_true("stock_name" %in% colnames(res))
  expect_true("jurisdiction" %in% colnames(res))
  expect_true("stock_id" %in% colnames(res))
})

# test stock id
test_that("get_species_itis with character stock id", {
  res <- get_species_itis(stock = "10950")
  expect_true(nrow(res) > 0)
  expect_true(any(res$itis == 172419))
  expect_true("itis" %in% colnames(res))
  expect_true("stock_name" %in% colnames(res))
  expect_true("jurisdiction" %in% colnames(res))
  expect_true("stock_id" %in% colnames(res))
})

test_that("get_species_itis with numeric stock id", {
  res <- get_species_itis(stock = 10950)
  expect_true(nrow(res) > 0)
  expect_true(any(res$itis == 172419))
  expect_true("itis" %in% colnames(res))
  expect_true("stock_name" %in% colnames(res))
  expect_true("jurisdiction" %in% colnames(res))
  expect_true("stock_id" %in% colnames(res))
})


# test null stock
test_that("get_species_itis with specific itis", {
  res <- get_species_itis(itis = 172419)
  expect_true(nrow(res) > 0)
  expect_true(all(grepl("Albacore", res$stock_name)))
  expect_true("itis" %in% colnames(res))
  expect_true("stock_name" %in% colnames(res))
  expect_true("jurisdiction" %in% colnames(res))
  expect_true("stock_id" %in% colnames(res))
})

# test null both argument
test_that("get_species_itis with null itis and stock", {
  res <- get_species_itis()
  expect_true(is.character(res))
})
