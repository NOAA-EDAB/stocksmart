#' Tests for the get_species_itis function
#'

# test null itis
test_that("get_species_itis with null itis", {
  res <- get_species_itis(stock = "Albacore")
  expect_true(nrow(res) > 0)
  expect_true(any(res$ITIS == 172419))
  expect_true("ITIS" %in% colnames(res))
  expect_true("StockName" %in% colnames(res))
  expect_true("Jurisdiction" %in% colnames(res))
  expect_true("StockID" %in% colnames(res))
})

# test stock id
test_that("get_species_itis with character stock id", {
  res <- get_species_itis(stock = "10950")
  expect_true(nrow(res) > 0)
  expect_true(any(res$ITIS == 172419))
  expect_true("ITIS" %in% colnames(res))
  expect_true("StockName" %in% colnames(res))
  expect_true("Jurisdiction" %in% colnames(res))
  expect_true("StockID" %in% colnames(res))
})

test_that("get_species_itis with numeric stock id", {
  res <- get_species_itis(stock = 10950)
  expect_true(nrow(res) > 0)
  expect_true(any(res$ITIS == 172419))
  expect_true("ITIS" %in% colnames(res))
  expect_true("StockName" %in% colnames(res))
  expect_true("Jurisdiction" %in% colnames(res))
  expect_true("StockID" %in% colnames(res))
})


# test null stock
test_that("get_species_itis with specific itis", {
  res <- get_species_itis(itis = 172419)
  expect_true(nrow(res) > 0)
  expect_true(all(grepl("Albacore", res$StockName)))
  expect_true("ITIS" %in% colnames(res))
  expect_true("StockName" %in% colnames(res))
  expect_true("Jurisdiction" %in% colnames(res))
  expect_true("StockID" %in% colnames(res))
})

# test null both argument
test_that("get_species_itis with null itis and stock", {
  expect_error(get_species_itis())
})
