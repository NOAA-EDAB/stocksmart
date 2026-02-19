.onLoad <- function(libname, pkgname) {
  makeActiveBinding(
    "stockAssessmentData",
    function() {
      lifecycle::deprecate_warn(
        when = "1.0.0",
        what = "stockAssessmentData()",
        with = "stock_assessment_data()",
        details = "The 'stockAssessmentData' dataset has been renamed to reflect best practices. Field names have changed to snake case."
      )
      # This retrieves the new dataset from the package namespace
      # so the user still gets their data back.
      get("stock_assessment_data", envir = asNamespace(pkgname))
    },
    asNamespace(pkgname)
  )
}

.onLoad <- function(libname, pkgname) {
  # 1. Handle Deprecations
  setup_deprecated_datasets(pkgname)
}

# Helper function to keep .onLoad readable
setup_deprecated_datasets <- function(pkgname) {
  # Deprecate 'assessmentData'
  makeActiveBinding(
    "stockAssessmentData",
    function() {
      lifecycle::deprecate_warn(
        when = "1.0.0",
        what = "stockAssessmentData()",
        with = "stock_assessment_data()",
        details = "The 'stockAssessmentData' dataset has been renamed to reflect best practices. Field names have changed to snake case."
      )
      # This retrieves the new dataset from the package namespace
      # so the user still gets their data back.
      get("stock_assessment_data", envir = asNamespace(pkgname))
    },
    asNamespace(pkgname)
  )

  makeActiveBinding(
    "stockAssessmentSummary",
    function() {
      lifecycle::deprecate_warn(
        when = "1.0.0",
        what = "stockAssessmentSummary()",
        with = "stock_assessment_summary()",
        details = "The 'stockAssessmentSummary' dataset has been renamed to reflect best practices. Field names have changed to snake case."
      )
      # This retrieves the new dataset from the package namespace
      # so the user still gets their data back.
      get("stock_assessment_summary", envir = asNamespace(pkgname))
    },
    asNamespace(pkgname)
  )
}
