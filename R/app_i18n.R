# Resolve bundled resources for source-tree and installed-package launches.
guane_resource_root <- function() {
 root<-getOption('guane.resource_root')
 if(!is.null(root)) return(normalizePath(root,mustWork=TRUE))
 root<-system.file(package='guane')
 if(nzchar(root)) return(root)
 if(dir.exists('inst/www')) return(normalizePath('inst'))
 stop('Guane resources unavailable. Launch from the project or install the package.')
}

# One dictionary for R and the browser: {"English text": ["es", "pt"]}, read once per session.
guane_dictionary <- local({
 dictionary <- NULL
 function() {
  if (is.null(dictionary)) dictionary <<- jsonlite::read_json(file.path(guane_resource_root(), 'i18n', 'translations.json'), simplifyVector = TRUE)
  dictionary
 }
})

# Presentation-only translations: research values and model state remain untouched.
guane_text <- function(text, lang="en") {
 i <- match(lang, c("es","pt"))
 if (length(i) != 1 || is.na(i) || !is.character(text) || length(text) != 1) return(text)
 entry <- guane_dictionary()[[text]]
 if (is.null(entry)) text else entry[[i]]
}

# Export the same helpers with an offline dictionary, using base R only.
guane_script_helpers <- function(names) {
 c(if ('guane_text' %in% names) paste0('guane_dictionary <- local({\n',
   guane_r_assignment('dictionary', guane_dictionary()), '\nfunction() dictionary\n})'),
   vapply(names, function(n) paste0(n, ' <- ', paste(deparse(get(n, mode='function')), collapse='\n')), character(1)))
}
