#' Tests for the get_latest_full_assessment function
#'

# if itis is invalid return a message and empty data frame
test_that("get_latest_full_assessment with invalid itis", {
  expect_message(get_latest_full_assessment(itis = 999999))
  df <- suppressMessages(get_latest_full_assessment(itis = 999999))
  expect_type(df, "list")
  expect_s3_class(df$data, "data.frame")
  expect_true(nrow(df$data) == 0)
})

# if itis is valid return data frame
test_that("get_latest_full_assessment with valid itis", {
  df <- get_latest_full_assessment(itis = 172419)
  expect_type(df, "list")
  expect_s3_class(df$data, "data.frame")
  expect_true(nrow(df$data) > 0)
  expect_s3_class(df$summary, "data.frame")
  expect_true(nrow(df$summary) > 0)
  expect_true(all(c("ITIS", "Metric") %in% colnames(df$data)))
})
