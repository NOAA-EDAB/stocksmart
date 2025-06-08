#' Tests for the plot_ts function
#'

# null itis
test_that("plot_ts with null itis", {
  expect_error(plot_ts(itis = NULL))
})

# metric not in list
test_that("plot_ts with metric not in list", {
  expect_error(plot_ts(itis = 180000, metric = "nonexistent_metric"))
})

# valid itis and metric
test_that("plot_ts with valid itis and metric", {
  # Assuming the function returns a ggplot object
  p <- plot_ts(itis = 172419, metric = "Catch")
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")
  #abundance
  p <- plot_ts(itis = 172419, metric = "Abundance",
               stock="Albacore - North Atlantic")
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")
  # F
  p <- plot_ts(itis = 172419, metric = "Fmort",
               stock="Albacore - North Atlantic")
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")
  # Recruitment
  p <- plot_ts(itis = 172419, metric = "Recruitment",
               stock="Albacore - North Atlantic")
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")

})

# test facetplot
test_that("plot_ts with facetplot", {
  p <- plot_ts(itis = 172419, metric = "Catch", facetplot = TRUE)
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")
  # Fmort facet
  p <- plot_ts(itis = 172419, metric = "Fmort",
               stock="Albacore - North Atlantic",
               facetplot = TRUE)
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")
  # Recruitment facet
  p <- plot_ts(itis = 172419, metric = "Recruitment",
               stock="Albacore - North Atlantic",
               facetplot = TRUE)
  expect_type(p, "list")
  expect_type(p$data, "list")
  expect_s3_class(p$plot, "gg")
})
