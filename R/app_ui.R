#' Display the Guane interface.
#' @param modules Primary modules to display: signal, asr, div, or sse.
#' @param default_lang Initial interface language: en, es, or pt.
#' @param resource_root Directory containing the bundled theme, assets, and translations.
#' @export
#' 
app_ui <- function(modules=c('signal','asr','div','sse'), default_lang='en', resource_root=guane_resource_root()) {
  
 titles<-c(signal='Phylo traits',asr='Ancestral state reconstruction',div='Diversification',sse='SSE models')
 
 # Evaluate the user's original theme without modifying its source.
 theme_env<-new.env(parent=asNamespace('bslib'))
 
 theme_env$`%>%`<-function(lhs,rhs) 
 {call<-substitute(rhs);eval(as.call(c(list(call[[1]],lhs),as.list(call)[-1])),parent.frame())}
 
 sys.source(file.path(resource_root,'theme','Guane_theme.R'),envir=theme_env)
 
 addResourcePath('guane-assets',file.path(resource_root,'www'))
 
 ui<-bslib::page_fluid(theme = theme_env$guane_theme,
                       tags$head(tags$title('Guane'),
                                 # Same dictionary as guane_text(); `<\/` keeps the JSON inside its script tag.
                                 tags$script(type='application/json',id='guane-translations',
                                             HTML(gsub('</','<\\/',paste(readLines(file.path(resource_root,'i18n','translations.json'),encoding='UTF-8',warn=FALSE),collapse='\n'),fixed=TRUE))),
                                 tags$script(src='guane-assets/guane-i18n.js'),
                                 tags$link(rel='stylesheet',href='guane-assets/guane.css'),
                                 tags$style('.guane-check-panels{display:grid;grid-template-columns:minmax(180px,1fr) minmax(220px,1fr);gap:16px}.guane-check-panels pre{overflow:auto}@media(max-width:900px){.guane-check-panels{grid-template-columns:1fr}}.guane-analysis-grid{display:grid;grid-template-columns:250px minmax(300px,1fr);gap:16px;align-items:start}@media(max-width:700px){.guane-analysis-grid{display:block}}.nav.nav-pills{background:#0d5368;padding:4px;gap:4px}.guane-data-grid{display:grid;grid-template-columns:250px minmax(320px,1fr) 240px;gap:16px;align-items:start}.guane-data-bottom{display:grid;grid-template-columns:2fr 1fr;gap:16px;margin-top:16px}.guane-data-grid .shiny-input-container{max-width:100%}.guane-data-grid .tab-content{overflow:auto}.guane-topbar img{height:58px;width:auto;margin-right:16px}.guane-topbar h3{display:flex;align-items:center}.guane-data-grid .card{margin-bottom:12px}@media(max-width:1100px){.guane-data-grid{grid-template-columns:220px minmax(300px,1fr)}.guane-data-grid>div:last-child{grid-column:1/-1}}@media(max-width:700px){.guane-data-grid,.guane-data-bottom{display:block}}')),
                       
                       div(class='guane-topbar',
                           h3(tags$img(src='guane-assets/guane.png',alt='Guane logo'), 'Phylogenetic Comparative Methods'),
                           selectInput('lang',NULL,c('English'='en','Espa\u00f1ol'='es','Portugu\u00eas'='pt'), selected=default_lang,selectize=FALSE,width='150px')),
                       do.call(bslib::navset_pill,c(list(id='module'),lapply(modules,function(m) bslib::nav_panel(titles[[m]],value=m,ui_mod_family(m)))) )
 )
 ui
}
