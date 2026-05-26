#' Build a plain-language diagnostic report from Guane validation results.
#'
#' @param validation.result A validation object returned by
#'   `core_validate_tree_traits()` or `guane_validation_from_issues()`.
#' @param dataset.name Name shown in the report.
#'
#' @return A character string containing the diagnostic report.
#' @export
BuildDiagnosticReport <- function(validation.result,
                                  dataset.name = "Uploaded dataset") {
  report <- tryCatch(
    {
      issues <- .GetReportIssues(validation.result)

      analysis_ready <- isTRUE(validation.result$analysis_ready)
      has_errors <- isTRUE(validation.result$has_errors)
      has_warnings <- isTRUE(validation.result$has_warnings)

      result_label <- .GetValidationLabel(
        analysis_ready = analysis_ready,
        has_errors = has_errors,
        has_warnings = has_warnings
      )

      error_count <- sum(issues$severity == "error")
      warning_count <- sum(issues$severity == "warning")
      active_count <- sum(issues$status == "active")
      dismissed_count <- sum(issues$status == "dismissed")

      paste(
        "Guane Data Diagnostic Report",
        "============================",
        "",
        paste0("Dataset: ", .PlainText(dataset.name)),
        paste0("Generated on: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
        paste0("Validation result: ", result_label),
        "",
        "Summary",
        "-------",
        paste0("Errors found: ", error_count),
        paste0("Warnings found: ", warning_count),
        paste0("Active issues remaining: ", active_count),
        paste0("Dismissed warnings: ", dismissed_count),
        "",
        "Issues found",
        "------------",
        .FormatGuaneIssues(issues),
        "",
        "Strategies used to correct or handle issues",
        "-------------------------------------------",
        .FormatGuaneCorrections(issues),
        "",
        "Final data status",
        "-----------------",
        .FormatGuaneFinalStatus(
          analysis_ready = analysis_ready,
          has_errors = has_errors,
          has_warnings = has_warnings
        ),
        "",
        "Note",
        "----",
        paste(
          "This report is written for users.",
          "Technical R messages are hidden so the diagnosis remains readable."
        ),
        sep = "\n"
      )
    },
    error = function(error) {
      paste(
        "Guane Data Diagnostic Report",
        "============================",
        "",
        paste0("Dataset: ", .PlainText(dataset.name)),
        "",
        "Guane completed validation, but the diagnostic report could not be created.",
        "Please validate the data again.",
        "",
        "No technical R error message is shown to the user.",
        sep = "\n"
      )
    }
  )

  return(report)
}


#' Write a diagnostic report to disk.
#'
#' @param report.text Character string returned by `BuildDiagnosticReport()`.
#' @param file Output file path.
#'
#' @return Invisibly returns the output file path.
#' @export
WriteDiagnosticReport <- function(report.text, file) {
  utils::writeLines(report.text, con = file, useBytes = TRUE)

  return(invisible(file))
}


.GetReportIssues <- function(validation.result) {
  if (is.null(validation.result$issues)) {
    return(.EmptyGuaneIssueTable())
  }

  issues <- validation.result$issues

  if (!is.data.frame(issues)) {
    return(.EmptyGuaneIssueTable())
  }

  required_columns <- c(
    "issue_id",
    "severity",
    "category",
    "issue",
    "details",
    "n",
    "correction",
    "can_dismiss",
    "status"
  )

  for (column in required_columns) {
    if (!column %in% names(issues)) {
      issues[[column]] <- NA
    }
  }

  issues <- issues[required_columns]

  text_columns <- c(
    "issue_id",
    "severity",
    "category",
    "issue",
    "details",
    "correction",
    "status"
  )

  for (column in text_columns) {
    issues[[column]] <- vapply(
      issues[[column]],
      .PlainText,
      character(1)
    )
  }

  return(issues)
}


.EmptyGuaneIssueTable <- function() {
  return(data.frame(
    issue_id = character(),
    severity = character(),
    category = character(),
    issue = character(),
    details = character(),
    n = integer(),
    correction = character(),
    can_dismiss = logical(),
    status = character(),
    stringsAsFactors = FALSE
  ))
}


.GetValidationLabel <- function(analysis_ready, has_errors, has_warnings) {
  if (isTRUE(analysis_ready)) {
    return("READY FOR ANALYSIS")
  }

  if (isTRUE(has_errors)) {
    return("LOCKED: ERRORS MUST BE CORRECTED")
  }

  if (isTRUE(has_warnings)) {
    return("LOCKED: WARNINGS MUST BE REVIEWED")
  }

  return("NEEDS ATTENTION")
}


.FormatGuaneIssues <- function(issues) {
  if (nrow(issues) == 0) {
    return("- No issues were found. The dataset passed all validation checks.")
  }

  lines <- character()

  for (i in seq_len(nrow(issues))) {
    issue <- issues[i, ]

    line <- paste0(
      "- ",
      toupper(issue$severity),
      ": ",
      issue$issue
    )

    if (nzchar(issue$category)) {
      line <- paste0(line, " Category: ", issue$category, ".")
    }

    if (nzchar(issue$details)) {
      line <- paste0(line, " Details: ", issue$details, ".")
    }

    if (!is.na(issue$n)) {
      line <- paste0(line, " Records affected: ", issue$n, ".")
    }

    if (nzchar(issue$status)) {
      line <- paste0(line, " Status: ", issue$status, ".")
    }

    lines <- c(lines, line)
  }

  return(paste(lines, collapse = "\n"))
}


.FormatGuaneCorrections <- function(issues) {
  if (nrow(issues) == 0) {
    return("- No corrections were needed.")
  }

  corrections <- issues[nzchar(issues$correction), , drop = FALSE]

  if (nrow(corrections) == 0) {
    return("- No correction strategy was recorded.")
  }

  lines <- character()

  for (i in seq_len(nrow(corrections))) {
    issue <- corrections[i, ]

    line <- paste0(
      "- Issue: ",
      issue$issue,
      "\n  Strategy: ",
      issue$correction
    )

    if (issue$status == "dismissed") {
      line <- paste0(
        line,
        "\n  Result: The warning was dismissed voluntarily by the user."
      )
    } else if (issue$status == "active") {
      line <- paste0(
        line,
        "\n  Result: This issue is still active and must be reviewed."
      )
    } else {
      line <- paste0(
        line,
        "\n  Result: Status recorded as ",
        issue$status,
        "."
      )
    }

    lines <- c(lines, line)
  }

  return(paste(lines, collapse = "\n"))
}


.FormatGuaneFinalStatus <- function(analysis_ready, has_errors, has_warnings) {
  if (isTRUE(analysis_ready)) {
    return(paste(
      "- The dataset is ready for analysis.",
      "- No active errors or warnings remain.",
      "- Analytical modules can be unlocked.",
      sep = "\n"
    ))
  }

  if (isTRUE(has_errors)) {
    return(paste(
      "- The dataset is not ready for analysis.",
      "- Critical validation errors remain active.",
      "- The user must correct these errors before analytical modules are unlocked.",
      sep = "\n"
    ))
  }

  if (isTRUE(has_warnings)) {
    return(paste(
      "- The dataset is not ready for analysis yet.",
      "- Warnings remain active.",
      "- The user must review the warnings and dismiss only those acceptable for the analysis.",
      sep = "\n"
    ))
  }

  return(paste(
    "- The final data status could not be determined.",
    "- Please re-run validation after uploading both tree and trait data.",
    sep = "\n"
  ))
}


.PlainText <- function(x) {
  if (inherits(x, "error")) {
    return("A technical validation problem was detected.")
  }

  if (is.null(x) || length(x) == 0 || is.na(x)) {
    return("")
  }

  text <- paste(as.character(x), collapse = ", ")
  text <- gsub("\n", " ", text)
  text <- gsub("Error in [^:]+:\\s*", "", text)
  text <- gsub("<[^>]*error[^>]*>", "technical issue", text, ignore.case = TRUE)
  text <- trimws(text)

  return(text)
}
