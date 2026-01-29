#' Tests for the get_species_stock_data function
#'

# test null itis
test_that("get_species_stock_data with null itis, stock as character", {
  res <- get_species_stock_data(stock = "Albacore")
  expect_true(is.list(res))
  expect_true(all(names(res) %in% c("stock_ts", "stock_refs")))
  expect_true(nrow(res$stock_refs) > 0)
  expect_true(nrow(res$stock_ts) > 0)
})

test_that("get_species_stock_data with null itis, stock as character ID", {
  res <- get_species_stock_data(stock = "10950")
  expect_true(is.list(res))
  expect_true(all(names(res) %in% c("stock_ts", "stock_refs")))
  expect_true(nrow(res$stock_refs) > 0)
  expect_true(nrow(res$stock_ts) > 0)
})

test_that("get_species_stock_data with null itis, stock as numeric ID", {
  res <- get_species_stock_data(stock = 10950)
  expect_true(is.list(res))
  expect_true(all(names(res) %in% c("stock_ts", "stock_refs")))
  expect_true(nrow(res$stock_refs) > 0)
  expect_true(nrow(res$stock_ts) > 0)
})

test_that("get_species_stock_data with itis as character, stock is null", {
  res <- get_species_stock_data(itis = "172419")
  expect_true(is.list(res))
  expect_true(all(names(res) %in% c("stock_ts", "stock_refs")))
  expect_true(nrow(res$stock_refs) > 0)
  expect_true(nrow(res$stock_ts) > 0)
})
test_that("get_species_stock_data with itis as numeric, stock is null", {
  res <- get_species_stock_data(itis = 172419)
  expect_true(is.list(res))
  expect_true(all(names(res) %in% c("stock_ts", "stock_refs")))
  expect_true(nrow(res$stock_refs) > 0)
  expect_true(nrow(res$stock_ts) > 0)
})

# test null both argument
test_that("get_species_stock_data with null itis and stock", {
  expect_error(get_species_stock_data())
})
