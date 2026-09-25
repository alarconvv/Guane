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
