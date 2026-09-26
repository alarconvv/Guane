# Run Guane's test gates and print a pass/fail summary.
# Usage: Rscript tests/run_gates.R [unit integration functional security]
gates <- commandArgs(TRUE); if (!length(gates)) gates <- c('unit', 'integration', 'functional', 'security')
stopifnot(all(gates %in% c('unit', 'integration', 'functional', 'security')))
Sys.setenv(NOT_CRAN = 'true')
pkgload::load_all('.', quiet = TRUE, export_all = TRUE)
summary <- list()
for (g in gates) {
 raw <- testthat::test_dir('tests/testthat', filter = paste0('^', g, '-'), load_package = 'none',
  reporter = testthat::ProgressReporter$new(show_praise = FALSE), stop_on_failure = FALSE, package = 'guane', load_helpers = TRUE)
 res <- as.data.frame(raw)
 # Green means every test ran, without failures, warnings, or skips.
 failed <- res$failed > 0 | res$error
 skipped <- !failed & res$skipped
 summary[[g]] <- data.frame(gate = g, files = length(unique(res$file)), tests = nrow(res),
  passed = sum(!failed & !skipped), failed = sum(failed), warnings = sum(res$warning), skipped = sum(skipped))
}
out <- do.call(rbind, summary); out$status <- ifelse(out$failed == 0 & out$warnings == 0 & out$skipped == 0 & out$tests > 0, 'GREEN', 'RED')
cat('\n==== GATES ====\n'); print(out, row.names = FALSE)
quit(status = if (all(out$status == 'GREEN')) 0 else 1)
