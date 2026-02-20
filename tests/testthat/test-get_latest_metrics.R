#' Tests for the get_latest_metrics function
#'

# if any metrics aren't in list error
test_that("get_latest_metrics with invalid metrics", {
  expect_error(get_latest_metrics(metrics = "invalid_metric"))
  expect_error(get_latest_metrics(
    metrics = c("Catch", "Abundance", "invalid_metric")
  ))
})

# if itis is invalid return a message and empty data frame
test_that("get_latest_metrics with invalid itis", {
  expect_message(get_latest_metrics(itis = 999999))
  df <- suppressMessages(get_latest_metrics(itis = 999999))
  expect_type(df, "list")
  expect_s3_class(df$data, "data.frame")
  expect_true(nrow(df$data) == 0)
})

# if valid itis and metrics return data frame
test_that("get_latest_metrics with valid itis and metrics", {
  df <- get_latest_metrics(itis = 172419, metrics = c("Catch", "Abundance"))
  expect_type(df, "list")
  expect_s3_class(df$data, "data.frame")
  expect_true(nrow(df$data) > 0)
  expect_s3_class(df$summary, "data.frame")
  expect_true(nrow(df$summary) > 0)
  expect_true(all(c("itis", "metric") %in% colnames(df$data)))
})
