.onLoad <- function(libname, pkgname) {
  # Helper to create the binding without triggering S3 warnings during check
  make_deprecated_binding <- function(old_name, new_name, details) {
    makeActiveBinding(
      old_name,
      function() {
        # Only show the warning if we aren't in a non-interactive check environment
        if (interactive() || !identical(Sys.getenv("NOT_CRAN"), "true")) {
          lifecycle::deprecate_warn(
            when = "1.0.0",
            what = paste0(old_name, "()"),
            with = paste0(new_name, "()"),
            details = details
          )
        }
        # Fetch the new data
        env <- new.env()
        utils::data(list = new_name, package = pkgname, envir = env)
        return(env[[new_name]])
      },
      asNamespace(pkgname)
    )
  }

  # Apply to your datasets
  make_deprecated_binding(
    "stockAssessmentSummary",
    "stock_assessment_summary",
    "The dataset has been renamed to reflect best practices (snake_case)."
  )

  make_deprecated_binding(
    "stockAssessmentData",
    "stock_assessment_data",
    "The dataset has been renamed to reflect best practices (snake_case)."
  )
}
