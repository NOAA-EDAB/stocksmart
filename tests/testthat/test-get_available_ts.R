#' Tests for the get_available_ts function
#'

# if itis is null expect a message
test_that("get_available_ts with null itis", {
  res <- get_available_ts(itis = NULL)
  expect_true(is.character(res))
})

# if jurisdiction is null expect a message
test_that("get_available_ts with null jurisdiction", {
  res <- get_available_ts(itis = 172419, jurisdiction = NULL)
  expect_true(is.character(res))
})

# if itis and/or jurisdiction are not null but entered incorrectly
test_that("get_available_ts with invalid itis and/or jurisdiction", {
  expect_error(get_available_ts(itis = 172419, jurisdiction = "WPFM"))
  expect_error(get_available_ts(itis = 999999, jurisdiction = "WPFMC"))
})

# if itis and jurisdiction are not null output is data frame
test_that("get_available_ts with valid itis and jurisdiction", {
  df <- get_available_ts(itis = 172419, jurisdiction = "WPFMC")
  expect_type(df, "list")
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})
