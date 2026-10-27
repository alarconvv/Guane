# Unit tests: translations (R/app_i18n.R and inst/i18n/translations.json, shared with guane-i18n.js).

guane_text_dictionary <- function() jsonlite::read_json(file.path(guane_resource_root(), 'i18n', 'translations.json'), simplifyVector = TRUE)

test_that('every dictionary entry has non-empty es and pt translations and no duplicate keys', {
 raw <- readLines(file.path(guane_resource_root(), 'i18n', 'translations.json'), encoding = 'UTF-8', warn = FALSE)
 keys <- sub('^ ("(?:[^"\\\\]|\\\\.)*"):.*$', '\\1', raw[grepl('^ "', raw)], perl = TRUE)
 expect_false(anyDuplicated(keys) > 0)
 d <- guane_text_dictionary()
 expect_gt(length(d), 1000)
 expect_true(all(nzchar(names(d))))
 ok <- vapply(d, function(v) is.character(v) && length(v) == 2 && !anyNA(v) && all(nzchar(trimws(v))), logical(1))
 expect_true(all(ok), info = paste(head(names(d)[!ok]), collapse = ' | '))
})

test_that('guane_text translates known keys and returns the input otherwise', {
 d <- guane_text_dictionary()
 key <- 'Analysis running in the background. You can keep exploring other results.'
 expect_equal(guane_text(key, 'es'), d[[key]][1])
 expect_equal(guane_text(key, 'pt'), d[[key]][2])
 expect_equal(guane_text(key, 'en'), key)
 expect_equal(guane_text(key), key)
 expect_equal(guane_text('A key that does not exist 123', 'es'), 'A key that does not exist 123')
 expect_equal(guane_text(key, 'fr'), key)
 expect_equal(guane_text(NA_character_, 'es'), NA_character_)
 for (k in names(d)[seq(1, length(d), by = 97)]) {
  expect_equal(guane_text(k, 'es'), d[[k]][1])
  expect_equal(guane_text(k, 'pt'), d[[k]][2])
 }
})

test_that('app_ui embeds the dictionary for the browser without closing its script tag', {
 html <- htmltools::renderTags(app_ui('signal'))$head
 expect_match(html, '<script type="application/json" id="guane-translations">', fixed = TRUE)
 json <- sub('(?s).*<script type="application/json" id="guane-translations">(.*?)</script>.*', '\\1', html, perl = TRUE)
 expect_identical(jsonlite::fromJSON(json), guane_text_dictionary())
})

test_that('live code hides only the dictionary and exports retain offline translations', {
 helpers <- guane_script_helpers('guane_text')
 script <- c('# Analysis', helpers, 'plot_settings <- list(lang="es")', 'sessionInfo()')
 expected <- paste(c(script[1], helpers[-1], tail(script, 2)), collapse='\n')
 expect_identical(guane_code_mirror(script), expected)
 expect_identical(guane_code_mirror(paste(script, collapse='\n')), expected)
 expect_identical(guane_code_mirror(c('# Preview', 'x <- 1')), '# Preview\nx <- 1')
 offline <- new.env(parent=baseenv())
 eval(parse(text=helpers), offline)
 for (lang in c('es', 'pt'))
  expect_identical(offline$guane_text('Frequency', lang), guane_text('Frequency', lang))
})

test_that('signal mirror omits the dictionary while its download retains it', {
 withr::local_options(guane.async=FALSE)
 guane_workers_stop(); on.exit(guane_workers_stop())
 shiny::testServer(server_mod_family, args=list(id='signal'), {
  guane_test_prepare(session)
  session$setInputs(signal_trait='body_mass', nsim=99)
  d <- guane_test_data()
  session$returned$analyses$signal$result(guane_signal(d$tree, d$traits, 'species', 'body_mass', nsim=99))
  session$flushReact()
  full <- session$returned$analyses$signal$code()
  expect_match(full, 'guane_dictionary <- local', fixed=TRUE)
  expect_identical(output$code, guane_code_mirror(full))
  expect_false(grepl('guane_dictionary <- local', output$code, fixed=TRUE))
  expect_identical(paste(readLines(output$script, warn=FALSE), collapse='\n'), full)
 })
})
