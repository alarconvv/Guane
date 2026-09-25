# Stable PagelReg filenames/ID; Pagel (1994) correlated evolution of binary traits.
guane_pagel <- function(tree, traits, taxon, x_column, y_column, starts=3, max_rate=100) {
 if(!inherits(tree,'phylo') || !ape::is.rooted(tree) || !ape::is.binary(tree)) stop('Pagel requires a rooted, bifurcating tree.')
 if(is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0)) stop('Pagel requires finite, positive branch lengths.')
 if(!is.data.frame(traits) || anyDuplicated(names(traits)) || length(taxon)!=1 || !taxon %in% names(traits)) stop('Select a unique taxon column in the trait table.')
 if(length(x_column)!=1 || length(y_column)!=1 || x_column==y_column || taxon %in% c(x_column,y_column) || !all(c(x_column,y_column) %in% names(traits))) stop('Select two different binary trait columns.')
 ids<-as.character(traits[[taxon]])
 if(length(tree$tip.label)<4 || anyNA(tree$tip.label) || anyDuplicated(tree$tip.label) || anyNA(ids) || anyDuplicated(ids) || any(!nzchar(trimws(ids))) || !setequal(ids,tree$tip.label)) stop('Pagel requires at least four taxa with unique, matching labels. Review matching in Data.')
 traits<-traits[match(tree$tip.label,ids),c(taxon,x_column,y_column),drop=FALSE];rownames(traits)<-NULL
 if(any(vapply(traits[c(x_column,y_column)],function(v) is.numeric(v) && any(!is.finite(v)),logical(1)))) stop('Binary trait values must be finite and nonmissing.')
 values<-lapply(traits[c(x_column,y_column)],as.character)
 if(any(vapply(values,function(v) anyNA(v) || any(!nzchar(trimws(v))) || length(unique(v))!=2,logical(1)))) stop('Each trait must have exactly two observed, nonmissing states. No automatic binarization or row removal is performed.')
 if(length(starts)!=1 || !is.finite(starts) || starts<1 || starts>5 || starts!=floor(starts)) stop('Choose one to five optimization starts.')
 if(length(max_rate)!=1 || !is.finite(max_rate) || max_rate<=0) stop('The maximum transition rate must be positive and finite.')
 states<-lapply(values,sort,method='radix');states<-lapply(states,unique)
 x<-setNames(factor(match(values[[1]],states[[1]])-1,levels=0:1),tree$tip.label)
 y<-setNames(factor(match(values[[2]],states[[2]])-1,levels=0:1),tree$tip.label)
 mapping<-data.frame(Trait=c(x_column,y_column),Code=c('X','Y'),State0=vapply(states,`[`,character(1),1),State1=vapply(states,`[`,character(1),2),check.names=FALSE)
 initial<-pmin(max_rate*.8,10^seq(-2,0,length.out=starts)/mean(tree$edge.length))
 best<-list(independent=NULL,dependent=NULL);attempts<-list();warnings<-character()
 for(j in seq_along(initial)) {
  fit<-tryCatch(withCallingHandlers(phytools::fitPagel(tree,x,y,method='fitMk',model='ARD',dep.var='xy',pi='equal',opt.method='nlminb',q.init=initial[j],max.q=max_rate,rand_start=FALSE),warning=function(w) {warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=function(e) e)
  for(model in names(best)) {
   if(!inherits(fit,'error') && is.null(fit$mk_fits)) stop("Pagel's correlation requires phytools 2.5-2 or newer. Update phytools and run again.")
   mk<-if(inherits(fit,'error')) NULL else fit$mk_fits[[model]]
   convergence<-if(is.null(mk$opt_results$convergence)) NA_integer_ else mk$opt_results$convergence
   ll<-if(is.null(mk)) NA_real_ else as.numeric(mk$logLik)
   Q<-if(is.null(mk)) NULL else fit[[paste0(model,'.Q')]]
   valid<-!is.na(convergence) && convergence==0 && is.finite(ll) && all(is.finite(Q)) && all(is.finite(mk$rates)) && all(mk$rates>=0)
   message<-if(inherits(fit,'error')) conditionMessage(fit) else if(is.null(mk$opt_results$message)) '' else mk$opt_results$message
   attempts[[length(attempts)+1]]<-data.frame(Start=j,Initial_rate=initial[j],Model=model,LogLik=ll,Convergence=convergence,Accepted=valid,Message=message)
   if(valid && (is.null(best[[model]]) || ll>best[[model]]$logLik)) best[[model]]<-list(logLik=ll,Q=Q,rates=mk$rates,start=j)
  }
 }
 diagnostics<-do.call(rbind,attempts)
 if(any(vapply(best,is.null,logical(1)))) stop(paste('No converged fit for both models. Inspect states, branch lengths and rate bound.',paste(unique(diagnostics$Message),collapse='; ')))
 difference<-best$dependent$logLik-best$independent$logLik
 if(difference < -1e-6) stop('The dependent fit is worse than the nested independent fit. Increase starts or inspect the rate bound.')
 comparison<-data.frame(Model=c('independent','dependent'),Parameters=c(4,8),LogLik=vapply(best,`[[`,numeric(1),'logLik'),row.names=NULL)
 comparison$AIC<-2*comparison$Parameters-2*comparison$LogLik
 comparison$Delta_AIC<-comparison$AIC-min(comparison$AIC)
 test<-data.frame(LR=2*max(0,difference),df=4,P=stats::pchisq(2*max(0,difference),df=4,lower.tail=FALSE))
 counts<-as.data.frame(table(factor(paste(x,y,sep='|'),levels=c('0|0','0|1','1|0','1|1'))),stringsAsFactors=FALSE);names(counts)<-c('Joint_state','Count')
 if(any(counts$Count==0)) warnings<-c(warnings,'Some joint states are absent; rates may be poorly identified and the asymptotic test unreliable.')
 if(any(vapply(best,function(b) any(b$rates>=max_rate*.99) || any(b$rates<=1e-8),logical(1)))) warnings<-c(warnings,'A fitted rate is at or near a boundary. Inspect sensitivity to the rate bound and initial values.')
 if(any(!diagnostics$Accepted)) warnings<-c(warnings,'Some optimization attempts failed. Only converged fits were eligible for selection.')
 rates<-do.call(rbind,lapply(names(best),function(m) {
  Q<-best[[m]]$Q;ij<-which(row(Q)!=col(Q),arr.ind=TRUE)
  data.frame(Model=m,From=rownames(Q)[ij[,1]],To=colnames(Q)[ij[,2]],Rate=Q[ij],row.names=NULL)
 }))
 list(tree=tree,traits=traits,taxon=taxon,x_column=x_column,y_column=y_column,starts=starts,max_rate=max_rate,mapping=mapping,counts=counts,comparison=comparison,test=test,best=best,rates=rates,diagnostics=diagnostics,warnings=unique(warnings))
}

# Directed transitions between joint binary states; simultaneous changes are disallowed.
guane_pagel_plot <- function(result, model='dependent', palette='Guane', scale_width=TRUE, lang='en') {
 model<-match.arg(model,c('independent','dependent'))
 Q<-result$best[[model]]$Q;codes<-c('0|0','0|1','1|0','1|1');Q<-Q[codes,codes]
 xy<-rbind(c(0,1),c(1,1),c(0,0),c(1,0))
 colors<-if(palette=='Grayscale') c('#eeeeee','#cccccc','#999999','#555555') else c('#b8d8dc','#90c4a5','#e3cc80','#b7a0c5')
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old));graphics::par(mar=c(7,1,4,1))
 graphics::plot.new();graphics::plot.window(xlim=c(-.35,1.35),ylim=c(-.3,1.35),asp=1)
 maximum<-max(vapply(result$best,function(b) max(b$Q),numeric(1)))
 for(i in 1:4) for(j in 1:4) if(i!=j && sum(abs(xy[i,]-xy[j,]))==1) {
  direction<-xy[j,]-xy[i,];normal<-c(-direction[2],direction[1]);rate<-Q[i,j]
  a<-xy[i,]+direction*.15+normal*.045;b<-xy[j,]-direction*.15+normal*.045
  graphics::arrows(a[1],a[2],b[1],b[2],length=.09,lwd=if(scale_width && maximum>0) 1+3*rate/maximum else 1.5,col='#345747',lty=if(rate<1e-8) 2 else 1)
  label<-(xy[i,]+xy[j,])/2+normal*.105
  graphics::text(label[1],label[2],formatC(rate,digits=3,format='g'),cex=.8)
 }
 graphics::symbols(xy[,1],xy[,2],circles=rep(.10,4),inches=FALSE,add=TRUE,bg=colors,fg='#345747')
 graphics::text(xy[,1],xy[,2],labels=c('00','01','10','11'),cex=.95,col=c('#222222','#222222','#222222',if(palette=='Grayscale') 'white' else '#222222'))
 graphics::title(main=guane_text(if(model=='independent') 'Independent evolution' else 'Dependent evolution',lang),cex.main=1.1)
 graphics::mtext(guane_text('Rates per branch-length unit; node codes are XY.',lang),side=1,line=1,cex=.8)
 for(i in 1:2) {
  m<-result$mapping[i,];label<-paste0(m$Code, ': ', m$Trait, ' (0 = ', m$State0, '; 1 = ', m$State1, ')')
  graphics::mtext(paste(strwrap(label,width=75),collapse='\n'),side=1,line=2.7+(i-1)*1.8,cex=.75)
 }
 invisible(Q)
}

guane_pagel_script <- function(result, model='dependent', palette='Guane', scale_width=TRUE, lang='en') {
 helpers<-c('guane_pagel','guane_pagel_plot','guane_text')
 c('# Guane: Pagel (1994) discrete correlation test and editable graph.',
 '# Open in RStudio and Source. Install ape and phytools if needed.',
 '# Equal root probabilities (1/4 per joint state); ARD; simultaneous changes forbidden.',
 '# The chi-squared likelihood-ratio p-value is asymptotic, not a bootstrap result.',
 paste0('# R ',getRversion(),'; phytools ',utils::packageVersion('phytools')),
 vapply(helpers,function(name) paste0(name,' <- ',paste(deparse(get(name,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('inputs',result[c('tree','traits','taxon','x_column','y_column','starts','max_rate')]),
 'result <- do.call(guane_pagel, inputs)','print(result$mapping)','print(result$comparison)','print(result$test)','print(result$diagnostics)','print(result$warnings)',
 guane_r_assignment('plot_settings',list(model=model,palette=palette,scale_width=scale_width,lang=lang)),
 'do.call(guane_pagel_plot, c(list(result=result), plot_settings))',
 '# Optional: pdf("guane-pagel.pdf", width=8, height=7)',
 '# do.call(guane_pagel_plot, c(list(result=result), plot_settings)); dev.off()',
 'sessionInfo()')
}
