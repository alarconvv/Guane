server_mod_asr <- function(id, lang=function() 'en') {
 shiny::moduleServer(id,function(input,output,session) {
  data<-server_mod_asr_data(input,output,session,lang)
  analyses<-list(discrete=server_mod_asr_discrete(input,output,session,data),continuous=server_mod_asr_continuous(input,output,session,data),poly=server_mod_asr_poly(input,output,session,data))
  list(data=data,analyses=analyses)
 })
}

# Shared reactive input adapter; validation and computation remain pure core functions.
server_asr_mk_advanced <- function(input,output,session,prefix,context,lang=function()'en') {
 value<-function(key,default=NULL){x<-input[[paste0(prefix,'_',key)]];if(is.null(x))default else x}
 options<-shiny::reactive({
  root<-value('root','equal');mode<-value('rate_mode','estimate');start<-if(mode=='estimate')value('start_mode','deterministic') else 'backend'
  rec<-value('reconstruction','marginal')
  list(root=root,root_weights=if(root=='custom')value('root_weights','') else NULL,
   rate_mode=mode,fixed_Q=if(mode=='fixed')value('fixed_Q','') else NULL,
   start_mode=start,q_init=if(start=='custom')value('q_init','') else NULL,
   min_rate=if(start!='backend')value('min_rate',1e-10) else 1e-10,
   optimizer=if(start!='backend')value('optimizer','nlminb') else 'nlminb',
   logscale=if(start!='backend')value('logscale',TRUE) else TRUE,
   reconstruction=rec,joint_tol=if(rec=='joint')value('joint_tol',1e-12) else 1e-12)
 })
 maximum<-shiny::reactive(if(options()$rate_mode=='estimate' && options()$start_mode!='backend')value('max_rate',100) else 100)
 preview<-shiny::reactive(tryCatch({
  z<-context();a<-options();compare<-isTRUE(value('compare',FALSE))
  if(compare && a$rate_mode=='fixed')stop('Turn off model comparison when supplying fixed Q.')
  if(compare && a$start_mode=='custom')stop('Turn off model comparison when supplying custom starting rates.')
  model<-value('model','ER');matrices<-setNames(list(z$index),model)
  if(compare) {
   candidates<-if(prefix=='poly')unique(c(model,'ER','SYM','ARD','transient')) else unique(c(model,'ER','SYM','ARD'))
   matrices<-setNames(lapply(candidates,function(m)if(m==model)z$index else if(prefix=='poly')guane_poly_matrix(z$data$states,m) else guane_mk_matrix(z$data$states,m)),candidates)
   keys<-vapply(matrices,function(m)paste(match(as.vector(m),unique(as.vector(m))),collapse=','),character(1));matrices<-matrices[!duplicated(keys)]
  }
  code<-unlist(lapply(names(matrices),function(m)c(paste0('# Candidate: ',m),guane_mk_call_preview(z$data,matrices[[m]],maximum(),a),paste0('fits[[',deparse(m),']] <- fit'))))
  c('fits <- list()',code,paste0('fit <- fits[[',deparse(model),']]'),
   if(identical(value('framework'),'simmap'))c(paste0('set.seed(',value('seed',999),', kind="Mersenne-Twister", normal.kind="Inversion", sample.kind="Rejection")'),paste0('maps <- phytools::make.simmap(tree, x, model=fit$index.matrix, Q=phytools::as.Qmatrix(fit), pi=fit$pi, nsim=',value('nsim',100),', tol=0, message=FALSE)')))
 },error=function(e)guane_text(conditionMessage(e),lang())))
 output[[paste0(prefix,'_advanced_preview')]]<-shiny::renderText(paste(preview(),collapse='\n'))
 shiny::observeEvent(input[[paste0(prefix,'_root_fill')]],{
  z<-tryCatch(context(),error=function(e)NULL);if(is.null(z))return()
  t<-data.frame(state=z$data$states,weight=1/length(z$data$states))
  text<-paste(capture.output(utils::write.table(t,sep=',',row.names=FALSE,col.names=FALSE,quote=TRUE)),collapse='\n')
  shiny::updateTextAreaInput(session,paste0(prefix,'_root_weights'),value=text)
 })
 shiny::observeEvent(input[[paste0(prefix,'_q_fill')]],{
  z<-tryCatch(context(),error=function(e)NULL);if(is.null(z))return()
  q<-(z$index>0)*.1;dimnames(q)<-dimnames(z$index);diag(q)<- -rowSums(q)
  text<-paste(capture.output(utils::write.csv(q)),collapse='\n')
  shiny::updateTextAreaInput(session,paste0(prefix,'_fixed_Q'),value=text)
 })
 list(options=options,maximum=maximum,preview=preview)
}

server_asr_graphics <- function(input,output,session,prefix,result,lang) {
 value<-function(key,default=NULL){v<-input[[paste0(prefix,'_',key)]];if(is.null(v))default else v}
 defaults<-guane_asr_graphics()
 settings<-shiny::reactive({
  g<-lapply(names(defaults),function(n){v<-value(n,defaults[[n]]);if(is.numeric(defaults[[n]]))v<-as.numeric(v);v});names(g)<-names(defaults)
  if(!value('graph','')%in%c('tree','joint','frequencies'))g$layout<-'phylogram'
  tryCatch(guane_asr_graphics(g),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),lang()))))
 })
 shiny::observeEvent(result(),{
  r<-result();shiny::req(r)
  nodes<-if(is.null(r$probabilities))as.character(r$nodes$Node) else rownames(r$probabilities)
  chosen<-value('focus_node','');if(!chosen%in%nodes)chosen<-''
  shiny::updateSelectInput(session,paste0(prefix,'_focus_node'),choices=c('No highlighted node'='',setNames(nodes,nodes)),selected=chosen)
  if(!is.null(r$states)) {
   s<-value('focus_state','');if(!s%in%r$states)s<-r$states[1]
   t<-value('transition_to','');if(!t%in%r$states)t<-r$states[2]
   shiny::updateSelectInput(session,paste0(prefix,'_focus_state'),choices=r$states,selected=s)
   shiny::updateSelectInput(session,paste0(prefix,'_transition_to'),choices=r$states,selected=t)
  }
 },ignoreNULL=TRUE)
 shiny::observeEvent(input[[paste0(prefix,'_graph')]],{
  r<-result();if(is.null(r)||!identical(value('graph'),'node')||nzchar(value('focus_node','')))return()
  root<-as.character(length(r$tree$tip.label)+1L)
  shiny::updateSelectInput(session,paste0(prefix,'_focus_node'),selected=root)
 })
 shiny::observeEvent(input[[paste0(prefix,'_colors_fill')]],{
  r<-result();shiny::req(r$states)
  cols<-guane_asr_colors(r$states,value('palette','Guane'))
  text<-paste(capture.output(utils::write.table(data.frame(state=names(cols),color=unname(cols)),sep=',',col.names=FALSE,row.names=FALSE,quote=TRUE)),collapse='\n')
  shiny::updateTextAreaInput(session,paste0(prefix,'_colors'),value=text)
 })
 shiny::observeEvent(input[[paste0(prefix,'_graphics_reset')]],{
  for(n in names(defaults)) {
   v<-defaults[[n]];id<-paste0(prefix,'_',n)
   if(n=='colors')shiny::updateTextAreaInput(session,id,value='')
   else if(n=='gradient')shiny::updateTextInput(session,id,value='')
   else if(n=='support')shiny::updateSliderInput(session,id,value=v)
   else if(n%in%c('layout','direction','font','edge_type','node_style','focus_node'))shiny::updateSelectInput(session,id,selected=as.character(v))
   else if(is.logical(v))shiny::updateCheckboxInput(session,id,value=v)
   else if(is.numeric(v))shiny::updateNumericInput(session,id,value=v)
  }
  r<-result();if(!is.null(r$states)){shiny::updateSelectInput(session,paste0(prefix,'_focus_state'),selected=r$states[1]);shiny::updateSelectInput(session,paste0(prefix,'_transition_to'),selected=r$states[2])}
  shiny::updateSelectInput(session,paste0(prefix,'_palette'),selected='Guane')
  shiny::updateCheckboxInput(session,paste0(prefix,'_labels'),value=TRUE)
  shiny::updateCheckboxInput(session,paste0(prefix,'_nodes'),value=FALSE)
  shiny::updateSliderInput(session,paste0(prefix,'_label_size'),value=.7)
  if(prefix!='bm')shiny::updateSliderInput(session,paste0(prefix,'_pie_size'),value=.6)
 })
 output[[paste0(prefix,'_node_detail')]]<-shiny::renderTable({shiny::req(result(),nzchar(settings()$focus_node));t<-guane_asr_node_table(result(),settings()$focus_node);names(t)<-vapply(names(t),guane_text,character(1),lang=lang());t},digits=5)
 output[[paste0(prefix,'_node_csv')]]<-shiny::downloadHandler('guane-selected-node.csv',function(file){shiny::req(result());utils::write.csv(guane_asr_node_table(result(),settings()$focus_node),file,row.names=FALSE)})
 settings
}

server_asr_plot <- function(draw,lang) {
 tryCatch(draw(),error=function(e)shiny::validate(shiny::need(FALSE,guane_text(conditionMessage(e),lang))))
}

server_asr_bayes_controls <- function(input,output,session,prefix,index,result,status) {
 id<-function(s)paste0(prefix,'_',s)
 bayes_options<-shiny::reactive({
  v<-function(n,d)if(is.null(input[[n]]))d else input[[n]]
  list(nsim=v(id('bayes_nsim'),200),burnin=v(id('bayes_burnin'),1000),samplefreq=v(id('bayes_spacing'),50),chains=v(id('bayes_chains'),2),seed=v(id('bayes_seed'),999),parameters=if(is.null(input[[id('bayes_parameters')]])||!nzchar(trimws(input[[id('bayes_parameters')]])))NULL else input[[id('bayes_parameters')]],root=v(id('bayes_root'),'equal'),root_weights=if(identical(input[[id('bayes_root')]],'custom'))input[[id('bayes_weights')]] else NULL,empirical=isTRUE(input[[id('bayes_empirical')]]))
 })
 shiny::observeEvent(input[[id('bayes_fill')]],{
  tryCatch({p<-guane_mk_bayes_parameters(index());shiny::updateTextAreaInput(session,id('bayes_parameters'),value=paste(capture.output(utils::write.csv(p,row.names=FALSE)),collapse='\n'))},error=function(e)status(conditionMessage(e)))
 })
 output[[id('bayes_index')]]<-shiny::renderTable({shiny::req(input[[id('framework')]]=='Bayes');index()},rownames=TRUE,digits=0)
 output[[id('bayes_controls')]]<-shiny::renderPrint({shiny::req(input[[id('framework')]]=='Bayes');if(!is.null(result()$bayes))return(print(result()$bayes$settings));o<-bayes_options();o$parameters<-guane_mk_bayes_parameters(index(),o$parameters);o$total_generations<-o$burnin+o$nsim*o$samplefreq;print(o)})
 bayes_options
}
server_asr_bayes_outputs <- function(input,output,session,prefix,result,settings,appearance,data,plot,script,translate_headers) {
 id<-function(s)paste0(prefix,'_',s)
 shiny::observeEvent(result(),{
  r<-result();if(is.null(r$bayes))return()
  choices<-r$bayes$diagnostics$Parameter;selected<-input[[id('bayes_parameter')]]
  shiny::updateSelectInput(session,id('bayes_parameter'),choices=choices,selected=if(!is.null(selected)&&selected%in%choices)selected else choices[1])
 })
 output[[id('bayes_diagnostics')]]<-shiny::renderTable({shiny::req(result()$bayes);translate_headers(result()$bayes$diagnostics)},digits=5)
 output[[id('bayes_node_diagnostics')]]<-shiny::renderTable({shiny::req(result()$bayes);translate_headers(result()$bayes$node_diagnostics)},digits=5)
 output[[id('bayes_draws_csv')]]<-shiny::downloadHandler(paste0('guane-',prefix,'-posterior.csv'),function(file){shiny::req(result()$bayes);utils::write.csv(result()$bayes$draws,file,row.names=FALSE)})
 output[[id('bayes_settings_csv')]]<-shiny::downloadHandler(paste0('guane-',prefix,'-priors.csv'),function(file){shiny::req(result()$bayes);utils::write.csv(result()$bayes$parameters,file,row.names=FALSE)})
 output[[id('bayes_diagnostics_csv')]]<-shiny::downloadHandler(paste0('guane-',prefix,'-chain-diagnostics.csv'),function(file){shiny::req(result()$bayes);utils::write.csv(result()$bayes$diagnostics,file,row.names=FALSE)})
 output[[id('bayes_node_csv')]]<-shiny::downloadHandler(paste0('guane-',prefix,'-node-diagnostics.csv'),function(file){shiny::req(result()$bayes);utils::write.csv(result()$bayes$node_diagnostics,file,row.names=FALSE)})
 output[[id('bayes_trace')]]<-shiny::renderPlot({server_asr_plot(function(){shiny::req(result()$bayes);s<-settings();s$type<-'trace';do.call(plot,c(list(result=result()),s))},data$lang())},width=function()appearance()$width*96,height=function()appearance()$height*96,res=96)
 output[[id('bayes_trace_pdf')]]<-shiny::downloadHandler(paste0('guane-',prefix,'-trace.pdf'),function(file){shiny::req(result()$bayes);grDevices::pdf(file,width=appearance()$width,height=appearance()$height);on.exit(grDevices::dev.off());s<-settings();s$type<-'trace';do.call(plot,c(list(result=result()),s))})
 output[[id('bayes_trace_script')]]<-shiny::downloadHandler(paste0('guane-',prefix,'-trace.R'),function(file){shiny::req(result()$bayes);s<-settings();s$type<-'trace';writeLines(do.call(script,c(list(result=result()),s)),file)})
}
