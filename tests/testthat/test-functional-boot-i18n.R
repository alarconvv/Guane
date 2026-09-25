# Functional: app boot, primary modules and EN/ES/PT language switching
# (full app in headless Chromium, background workers enabled).
source(testthat::test_path('functional-driver.R'), local = TRUE)

app <- guane_ft_app(async = TRUE, name = 'boot-i18n')
withr::defer(guane_ft_stop(app))

nav_text <- function(value) guane_ft_text_js(app, sprintf(".nav-link[data-value='%s']", value))

test_that('the full app boots without browser console errors', {
 expect_identical(app$get_value(input = 'module'), 'signal')
 expect_identical(app$get_value(input = 'lang'), 'en')
 expect_identical(app$get_js('document.title'), 'Guane')
 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
})

test_that('each of the four primary modules renders its Data tab and analysis cards', {
 cards <- list(signal = c('data', 'signal', 'PGLS', 'PagelReg', 'PGLM'),
               asr = c('data', 'continuous', 'discrete', 'poly'),
               div = c('data', 'ltt', 'rates', 'time', 'clades', 'joint', 'diversity'),
               sse = c('data', 'bisse', 'musse', 'quasse', 'hidden'))
 for (m in names(cards)) {
  guane_ft_select(app, m)
  expect_identical(app$get_value(input = 'module'), m)
  expect_true(app$get_js(sprintf("document.querySelector(\".nav-link[data-value='%s']\").classList.contains('active')", m)))
  # The module's Data tab is the default card and its controls are visible.
  expect_identical(app$get_value(input = paste0(m, '-analysis')), 'data')
  expect_true(app$get_js(sprintf("(function(){var b=document.getElementById('%s-example');return !!b && b.offsetParent!==null;})()", m)))
  expect_identical(guane_ft_text(app, paste0(m, '-example')), 'Load example data')
  expect_identical(guane_ft_text(app, paste0(m, '-activity')), 'Load your files or explore the example dataset.')
  pills <- unlist(app$get_js(sprintf("Array.from(document.querySelectorAll('#%s-analysis .nav-link')).map(function(a){return a.getAttribute('data-value');})", m)))
  expect_setequal(pills, cards[[m]])
 }
 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
})

test_that('language switching EN -> ES -> PT -> EN translates visible labels and keeps inputs', {
 guane_ft_select(app, 'asr', 'discrete')
 guane_ft_set(app, `asr-mk_nsim` = 123)
 expected <- list(
  en = c(title = 'Phylogenetic Comparative Methods', asr = 'Ancestral state reconstruction', div = 'Diversification', example = 'Load example data', match = 'Use matched taxa', run = 'Run Mk reconstruction', status = 'Choose a discrete trait and run Mk reconstruction.'),
  es = c(title = 'M\u00e9todos Comparativos Filogen\u00e9ticos', asr = 'Reconstrucci\u00f3n ancestral', div = 'Diversificaci\u00f3n', example = 'Cargar datos de ejemplo', match = 'Usar taxones coincidentes', run = 'Ejecutar reconstrucci\u00f3n Mk', status = 'Elija un rasgo discreto y ejecute la reconstrucci\u00f3n Mk.'),
  pt = c(title = 'M\u00e9todos Comparativos Filogen\u00e9ticos', asr = 'Reconstru\u00e7\u00e3o ancestral', div = 'Diversifica\u00e7\u00e3o', example = 'Carregar dados de exemplo', match = 'Usar t\u00e1xons correspondentes', run = 'Executar reconstru\u00e7\u00e3o Mk', status = 'Escolha uma caracter\u00edstica discreta e execute a reconstru\u00e7\u00e3o Mk.'))
 for (lang in c('en', 'es', 'pt', 'en')) {
  guane_ft_set(app, lang = lang)
  app$wait_for_idle(duration = 300)
  e <- expected[[lang]]
  expect_identical(app$get_js("document.documentElement.lang"), lang)
  expect_identical(guane_ft_text_js(app, '.guane-topbar h3'), e[['title']], info = lang)
  expect_identical(nav_text('asr'), e[['asr']], info = lang)
  expect_identical(nav_text('div'), e[['div']], info = lang)
  expect_identical(guane_ft_text(app, 'asr-example'), e[['example']], info = lang)
  expect_identical(guane_ft_text(app, 'asr-match'), e[['match']], info = lang)
  expect_identical(guane_ft_text(app, 'asr-mk_run'), e[['run']], info = lang)
  # Server-rendered status text follows the language input as well.
  expect_identical(guane_ft_wait_text(app, 'asr-mk_status', e[['status']]), e[['status']], info = lang)
  # Switching language is presentation-only: inputs are not rebuilt or reset.
  expect_equal(app$get_value(input = 'asr-mk_nsim'), 123)
  expect_identical(app$get_value(input = 'module'), 'asr')
  expect_identical(app$get_value(input = 'asr-analysis'), 'discrete')
 }
 errors <- guane_ft_browser_errors(app)
 expect_equal(nrow(errors), 0, info = paste(errors$message, collapse = '\n'))
})
