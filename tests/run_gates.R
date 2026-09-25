# Run Guane's test gates and print a pass/fail summary.
# Usage: Rscript tests/run_gates.R [unit integration functional security]
gates <- commandArgs(TRUE); if (!length(gates)) gates <- c('unit', 'integration', 'functional', 'security')
pkgload::load_all('.', quiet = TRUE, export_all = TRUE)
summary <- list()
for (g in gates) {
 raw <- testthat::test_dir('tests/testthat', filter = paste0('^', g, '-'), load_package = 'none',
  reporter = testthat::ProgressReporter$new(show_praise = FALSE), stop_on_failure = FALSE, package = 'guane', load_helpers = TRUE)
 res <- as.data.frame(raw)
 # A test skipped because it documents a known bug keeps the gate red.
 skips <- unlist(lapply(raw, function(t) vapply(Filter(function(e) inherits(e, 'expectation_skip'), t$results), conditionMessage, character(1))))
 bugs <- sum(grepl('BUG', skips))
 failed <- res$failed > 0 | res$error
 skipped <- !failed & res$skipped
 summary[[g]] <- data.frame(gate = g, files = length(unique(res$file)), tests = nrow(res),
  passed = sum(!failed & !skipped), failed = sum(failed), skipped = sum(skipped), bug_skips = bugs)
}
out <- do.call(rbind, summary); out$status <- ifelse(out$failed == 0 & out$bug_skips == 0 & out$tests > 0, 'GREEN', 'RED')
cat('\n==== GATES ====\n'); print(out, row.names = FALSE)
quit(status = if (all(out$status == 'GREEN')) 0 else 1)
