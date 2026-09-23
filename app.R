# Development entry point; installed users call guane::run_app().
local({
 if(dir.exists(".guane-library")) .libPaths(c(normalizePath(".guane-library"),.libPaths()))
 library(shiny)
 options(guane.resource_root=normalizePath('inst'))
 for (file in list.files('R',pattern='\\.R$',full.names=TRUE)) sys.source(file,envir=environment())
 app_guane()
})
