core_mod_signal_PGLM <- function() list(implemented=TRUE,family=c('Bernoulli','Poisson GEE','Grouped binomial GEE'),link=c('logit','log','logit'))

# Binary or count outcomes; numeric or categorical species-level predictors, never node-level PICs.
guane_pglm <- function(tree,traits,taxon,response,predictors,event=NULL,method='logistic_MPLE',trials=NULL,categorical=character(),references=list()) {
 method<-match.arg(method,c('logistic_MPLE','logistic_IG10','poisson_GEE','binomial_GEE'))
 count<-identical(method,'poisson_GEE');grouped<-identical(method,'binomial_GEE')
 if(!inherits(tree,'phylo') || !ape::is.rooted(tree) || !ape::is.binary(tree)) stop('PGLM requires a rooted, bifurcating tree.')
 if(is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0)) stop('PGLM requires finite, positive branch lengths.')
 if(!is.data.frame(traits) || anyDuplicated(names(traits)) || length(taxon)!=1 || !taxon %in% names(traits)) stop('Select a unique taxon column in the trait table.')
 ids<-as.character(traits[[taxon]])
 if(anyNA(ids) || any(!nzchar(trimws(ids))) || anyDuplicated(ids) || anyNA(tree$tip.label) || anyDuplicated(tree$tip.label) || !setequal(ids,tree$tip.label)) stop('Match unique, nonempty taxon labels explicitly in Data before PGLM.')
 if(length(response)!=1 || !length(predictors) || anyDuplicated(predictors) || response %in% predictors || taxon %in% c(response,predictors) || !all(c(response,predictors) %in% names(traits))) stop('Select a response and distinct predictors.')
 traits<-traits[match(tree$tip.label,ids),,drop=FALSE]
 raw_response<-traits[[response]]
 if(grouped) {
  if(length(trials)!=1 || !trials %in% names(traits) || trials %in% c(taxon,response,predictors)) stop('Select a distinct total-trials column, separate from successes and predictors.')
  totals<-traits[[trials]]
  if(!is.numeric(raw_response) || !is.numeric(totals) || any(!is.finite(c(raw_response,totals))) || any(raw_response!=floor(raw_response)) || any(totals!=floor(totals)) || any(totals<=0 | raw_response<0 | raw_response>totals)) stop('Grouped binomial requires integer counts with positive trials and 0 <= successes <= trials. No rows are removed automatically.')
  if(sum(raw_response)==0 || sum(totals-raw_response)==0) stop('Grouped binomial needs at least one success and one failure across species.')
  y<-raw_response;states<-character();event<-NULL
 } else if(count) {
  if(!is.numeric(raw_response) || any(!is.finite(raw_response)) || any(raw_response<0 | raw_response!=floor(raw_response)) || length(unique(raw_response))<2) stop('Count responses must be finite, nonnegative integers with at least two different values. No rounding or row removal is automatic.')
  y<-raw_response;states<-character();event<-NULL
 } else {
  y<-as.character(raw_response);states<-sort(unique(y),method='radix')
  if(anyNA(y) || any(!nzchar(trimws(y))) || (is.numeric(raw_response) && any(!is.finite(raw_response))) || length(states)!=2 || length(event)!=1 || !event %in% states) stop('Select the event state from a response with exactly two nonmissing states.')
 }
 if(anyDuplicated(categorical) || !all(categorical %in% predictors)) stop('Categorical columns must be selected predictors.')
 numeric_predictors<-setdiff(predictors,categorical)
 if(!all(vapply(traits[numeric_predictors],function(x) is.numeric(x) && all(is.finite(x)) && length(unique(x))>1,logical(1)))) stop('PGLM predictors must be finite, numeric and nonconstant. No rows are removed automatically.')
 if(nrow(traits)<6 || nrow(traits)<=length(predictors)+2) stop('PGLM needs at least six taxa and two residual degrees of freedom.')
 if(!count && !grouped && min(table(y))<2) stop('PGLM needs at least six taxa, two observations per state and two residual degrees of freedom.')
 frame<-data.frame(.response=if(count || grouped) y else as.integer(y==event),row.names=tree$tip.label)
 coding<-data.frame(Predictor=character(),Level=character(),Reference=character(),N=integer())
 terms<-'(Intercept)';sparse<-FALSE
 for(i in seq_along(predictors)) {
  name<-predictors[i];x<-traits[[name]]
  if(name %in% categorical) {
   if(anyNA(x) || any(!nzchar(trimws(as.character(x)))) || (is.numeric(x) && any(!is.finite(x)))) stop('Categorical predictors must have nonmissing, nonempty states.')
   levels<-sort(unique(as.character(x)),method='radix')
   if(length(levels)<2) stop('Categorical predictors need at least two observed states.')
   ref<-references[[name]]
   if(length(ref)!=1 || !ref %in% levels) stop('Choose an observed reference category for every categorical predictor.')
   levels<-c(ref,setdiff(levels,ref));x<-factor(as.character(x),levels=levels)
   contrasts(x)<-stats::contr.treatment(levels,base=1)
   counts<-as.integer(table(x));sparse<-sparse || any(counts<3)
   coding<-rbind(coding,data.frame(Predictor=name,Level=levels,Reference=ref,N=counts))
   terms<-c(terms,paste0(name,' [',levels[-1],' vs ',ref,']'))
  } else terms<-c(terms,name)
  frame[[paste0('.x',i)]]<-x
 }
 if(grouped) frame$.failures<-totals-y
 formula<-stats::reformulate(paste0('.x',seq_along(predictors)),response=if(grouped) 'cbind(.response, .failures)' else '.response')
 design<-stats::model.matrix(formula,frame)
 if(nrow(design)-ncol(design)<2) stop('PGLM needs at least six taxa and two residual degrees of freedom.')
 if(qr(design)$rank<ncol(design)) stop('Predictors are collinear. Choose an independent set of predictors.')
 # Binary optimization is sensitive to parameterization. Fit a fixed coding,
 # then express the same model in the user's requested treatment contrasts.
 fit_frame<-frame
 if(!count && !grouped && length(categorical)) for(i in seq_along(predictors)) {
  if(predictors[i] %in% categorical) {
   key<-paste0('.x',i);lev<-sort(levels(frame[[key]]),method='radix')
   fit_frame[[key]]<-factor(as.character(frame[[key]]),levels=lev)
   contrasts(fit_frame[[key]])<-stats::contr.treatment(lev)
  }
 }
 warnings<-if(sparse) 'Some predictor categories contain fewer than three taxa; estimates may be unstable.' else character()
 fit<-withCallingHandlers(if(grouped) guane_pglm_grouped_fit(formula,frame,tree) else phylolm::phyloglm(formula,data=fit_frame,phy=tree,method=method,boot=0),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 if(length(fit$convergence)!=1 || !is.finite(fit$convergence) || fit$convergence!=0) stop('PGLM optimization did not converge. Review variables and model settings.')
 if(any(!is.finite(c(fit$coefficients,fit$sd,fit$vcov,if(count || grouped) fit$scale else c(fit$alpha,fit$logLik)))) || any(fit$sd<=0)) stop('PGLM returned invalid estimates or standard errors.')
 if(count && (length(fit$scale)!=1 || fit$scale<=0)) stop('PGLM returned an invalid dispersion estimate.')
 if(!count && !grouped && fit$alphaWarn!=0) warnings<-c(warnings,'Alpha is near its optimization boundary; inspect sensitivity before inference.')
 if(!count && !grouped && length(categorical)) {
  change<-qr.solve(design,stats::model.matrix(formula,fit_frame))
  fit$coefficients<-setNames(as.numeric(change %*% fit$coefficients),colnames(design))
  fit$vcov<-change %*% fit$vcov %*% t(change);fit$sd<-sqrt(diag(fit$vcov))
  fit$X<-design[rownames(fit$X),,drop=FALSE]
 }
 beta<-unname(fit$coefficients);se<-unname(fit$sd)
 coefficients<-data.frame(Term=terms,Estimate=beta,SE=se,Lower=beta-stats::qnorm(.975)*se,Upper=beta+stats::qnorm(.975)*se,P=2*stats::pnorm(-abs(beta/se)))
 if(grouped) {
  probability<-unname(fit$fitted.values)
  if(any(!is.finite(probability)) || any(probability<=1e-8 | probability>=1-1e-8)) stop('Grouped binomial fitted probabilities are at a boundary. Check separation and model complexity.')
  points<-data.frame(Taxon=tree$tip.label,Successes=y,Trials=totals,Observed=y/totals,Probability=probability,Fitted=totals*probability,Pearson=(y-totals*probability)/sqrt(totals*probability*(1-probability)))
 } else if(count) {
  # phylolm 2.6.5 stores exp(-eta) despite fitting mu=exp(eta).
  # Reconstruct the log-link mean from X beta, independently of that field.
  mu<-setNames(as.numeric(exp(fit$X %*% fit$coefficients)),rownames(fit$X))
  if(any(!is.finite(mu)) || any(mu<=0)) stop('PGLM returned invalid fitted counts.')
  fit$fitted.values<-mu;fit$residuals<-fit$y[names(mu)]-mu
  mu<-unname(mu[tree$tip.label])
  if(anyNA(mu)) stop('PGLM fitted taxa do not match the input tree.')
  points<-data.frame(Taxon=tree$tip.label,Observed=frame$.response,Fitted=mu,Pearson=(frame$.response-mu)/sqrt(mu))
 } else {
  probability<-fit$fitted.values[match(tree$tip.label,names(fit$fitted.values))]
  if(any(!is.finite(probability)) || any(probability<=0 | probability>=1)) stop('PGLM returned invalid fitted probabilities.')
  points<-data.frame(Taxon=tree$tip.label,Observed=frame$.response,Probability=unname(probability),Pearson=(frame$.response-probability)/sqrt(probability*(1-probability)))
 }

 list(fit=fit,tree=tree,traits=traits,taxon=taxon,response=response,predictors=predictors,categorical=categorical,references=references,coding=coding,event=event,trials=if(grouped) trials else NULL,reference=setdiff(states,event),method=method,coefficients=coefficients,points=points,warnings=unique(warnings))
}

# One cluster = one phylogeny. Use fixed binomial variance and model-based
# covariance only; the one-cluster sandwich estimate is not inferentially valid.
guane_pglm_grouped_fit <- function(formula,frame,tree) {
 correlation<-ape::vcv.phylo(tree,corr=TRUE)[tree$tip.label,tree$tip.label]
 if(any(!is.finite(correlation))) stop('The phylogenetic working correlation is invalid.')
 chol(correlation)
 invisible(utils::capture.output(fit<-suppressMessages(gee::gee(formula,id=rep(1,nrow(frame)),data=frame,family=stats::binomial('logit'),R=correlation,corstr='fixed',scale.fix=TRUE,scale.value=1,tol=1e-8,maxiter=100))))
 if(length(fit$error)!=1 || !is.finite(fit$error) || fit$error!=0 || fit$iterations>=100) stop('Grouped binomial GEE did not converge. Review the inputs and model complexity.')
 fit$vcov<-fit$naive.variance;fit$sd<-sqrt(diag(fit$vcov));fit$convergence<-fit$error
 fit$n<-nrow(frame);fit$d<-length(fit$coefficients)
 # Package residuals mix success counts and probabilities for matrix responses.
 fit$residuals<-frame$.response/(frame$.response+frame$.failures)-fit$fitted.values
 fit
}

guane_pglm_plot <- function(result,type='fit',color='#34765b',labels=FALSE,lang='en') {
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 txt<-function(x) guane_text(x,lang)
 d<-result$points;count<-identical(result$method,'poisson_GEE');grouped<-identical(result$method,'binomial_GEE')
 if(type=='coefficients') {
  z<-result$coefficients;y<-rev(seq_len(nrow(z)))
  term_labels<-gsub(' [','\n[',z$Term,fixed=TRUE)
  term_labels<-vapply(strsplit(term_labels,'\n',fixed=TRUE),function(parts) paste(unlist(lapply(parts,strwrap,width=24)),collapse='\n'),character(1))
  left<-min(12,max(4,max(nchar(unlist(strsplit(term_labels,'\n',fixed=TRUE))))*.36),graphics::par('din')[1]*.45/graphics::par('csi'))
  graphics::par(mar=c(5,left,3,1),cex.main=.8,cex.lab=.8)
  graphics::plot(z$Estimate,y,xlim=range(c(z$Lower,z$Upper,0)),ylim=c(.5,nrow(z)+.5),yaxt='n',ylab='',xlab=txt(if(count) 'Log-mean coefficient' else 'Log-odds coefficient'),main=txt(if(count || grouped) 'GEE 95% Wald intervals' else 'Conditional 95% Wald intervals'),pch=19,col=color)
  graphics::axis(2,at=y,labels=term_labels,las=1,cex.axis=.7)
  graphics::abline(v=0,lty=2,col='grey60');graphics::segments(z$Lower,y,z$Upper,y,col=color,lwd=2)
 } else if(type=='diagnostics') {
  graphics::par(mar=c(5,5,3,1))
  graphics::plot(if(count) d$Fitted else d$Probability,d$Pearson,xlim=if(count) range(c(0,d$Fitted)) else c(0,1),xlab=txt(if(count) 'Fitted mean count' else 'Fitted event probability'),ylab=txt('Pearson residual'),pch=19,col=color)
  graphics::abline(h=0,col='grey60',lty=2)
 } else if(grouped) {
  graphics::par(mar=c(5,5,3,1))
  graphics::plot(d$Probability,d$Observed,xlim=c(0,1),ylim=c(0,1),xlab=txt('Fitted success probability'),ylab=txt('Observed success proportion'),main=txt('Observed and fitted proportions'),pch=19,col=color)
  graphics::abline(a=0,b=1,lty=2,col='grey60')
  if(labels) graphics::text(d$Probability,d$Observed,labels=d$Taxon,pos=3,cex=.65,col=color)
 } else if(count) {
  graphics::par(mar=c(5,5,3,1))
  limits<-range(c(0,d$Fitted,d$Observed))
  graphics::plot(d$Fitted,d$Observed,xlim=limits,ylim=limits,xlab=txt('Fitted mean count'),ylab=paste(txt('Observed count'),result$response,sep=': '),main=txt('Observed and fitted counts'),pch=19,col=color)
  graphics::abline(a=0,b=1,lty=2,col='grey60')
  if(labels) graphics::text(d$Fitted,d$Observed,labels=d$Taxon,pos=3,cex=.65,col=color)
 } else {
  graphics::par(mar=c(5,5,4,1))
  graphics::plot(d$Probability,d$Observed,xlim=c(0,1),ylim=c(-.12,1.12),yaxt='n',xlab=txt('Fitted event probability'),ylab=result$response,pch=19,col=color)
  graphics::axis(2,at=0:1,labels=c(result$reference,result$event),las=1,cex.axis=.8)
  graphics::title(main=txt('Observed outcomes and fitted probabilities'))
  if(labels) graphics::text(d$Probability,d$Observed,labels=d$Taxon,pos=ifelse(d$Observed==1,1,3),cex=.65,col=color)
 }
 invisible(d)
}

guane_pglm_script <- function(result,type='fit',color='#34765b',labels=FALSE,lang='en') {
 helpers<-c('guane_pglm','guane_pglm_grouped_fit','guane_pglm_screen','guane_text','guane_pglm_plot')
 c('# Guane PGLM: self-contained model and editable graph for RStudio.',
   '# install.packages(c("ape","phylolm","gee"))',
   if(result$method=='binomial_GEE') '# Grouped-binomial GEE: fixed tree working correlation and binomial scale=1; model-based Wald intervals, no one-cluster sandwich inference.' else if(result$method=='poisson_GEE') '# Poisson GEE/log link: scale-adjusted model-based Wald intervals, not sandwich or bootstrap intervals. No likelihood/AIC or exposure offset.' else '# Wald intervals are conditional on fitted alpha; no bootstrap is used.',
   paste0('# R ',getRversion(),'; phylolm ',utils::packageVersion('phylolm'),'; gee ',utils::packageVersion('gee')),
   vapply(helpers,function(n) paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
   guane_r_assignment('inputs',result[c('tree','traits','taxon','response','predictors','event','method','trials','categorical','references')]),
   'result <- do.call(guane_pglm,inputs)','print(result$coefficients)','print(result$points)','print(result$warnings)','print(guane_pglm_screen(result))',
   if(result$method %in% c('poisson_GEE','binomial_GEE')) 'print(result$fit$scale)' else 'print(result$fit$alpha)',
   guane_r_assignment('plot_settings',list(type=type,color=color,labels=labels,lang=lang)),
   'do.call(guane_pglm_plot,c(list(result=result),plot_settings))',
   '# Optional: pdf("guane-pglm.pdf",width=9,height=6); do.call(guane_pglm_plot,c(list(result=result),plot_settings)); dev.off()',
   'sessionInfo()')
}

# Descriptive screens, not calibrated residual or separation tests.
guane_pglm_screen <- function(result) {
 d<-result$points
 taxa<-data.frame(Taxon=d$Taxon,Pearson=d$Pearson,LargeResidual=abs(d$Pearson)>2)
 categories<-result$coding
 if(nrow(categories)) {
  categories$Sparse<-categories$N<3
  categories$OneOutcome<-vapply(seq_len(nrow(categories)),function(i) {
   rows<-as.character(result$traits[[categories$Predictor[i]]])==categories$Level[i]
   if(result$method=='poisson_GEE') return(NA)
   if(result$method=='binomial_GEE') return(sum(d$Successes[rows])==0 || sum(d$Trials[rows]-d$Successes[rows])==0)
   length(unique(d$Observed[rows]))==1
  },logical(1))
 }
 list(taxa=taxa,categories=categories)
}
# Explicit diagnostic refits on temporary copies; never mutate prepared inputs.
guane_pglm_influence <- function(result) {
 settings<-result[c('tree','traits','taxon','response','predictors','event','method','trials','categorical','references')]
 rows<-lapply(result$tree$tip.label,function(tip) {
  tryCatch({
   args<-settings;args$tree<-ape::drop.tip(settings$tree,tip)
   args$traits<-settings$traits[as.character(settings$traits[[settings$taxon]])!=tip,,drop=FALSE]
   r<-do.call(guane_pglm,args)
   if(!identical(r$coefficients$Term,result$coefficients$Term)) stop('Category coding changed after omission; coefficient shifts are unavailable.')
   shift<-abs((r$coefficients$Estimate-result$coefficients$Estimate)/result$coefficients$SE)
   data.frame(Taxon=tip,MaxShift=max(shift),Term=result$coefficients$Term[which.max(shift)],Message=paste(r$warnings,collapse='; '))
  },error=function(e) data.frame(Taxon=tip,MaxShift=NA_real_,Term='',Message=conditionMessage(e)))
 })
 list(table=data.frame(Index=seq_along(rows),do.call(rbind,rows)),settings=settings)
}
guane_pglm_influence_plot <- function(influence,color='#34765b',lang='en') {
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 d<-influence$table;ok<-is.finite(d$MaxShift)
 graphics::par(mar=c(5,5,3,1))
 if(!any(ok)) {graphics::plot.new();graphics::text(.5,.5,guane_text('No valid diagnostic refits.',lang));return(invisible(d))}
 graphics::plot(which(ok),d$MaxShift[ok],xlim=c(.5,nrow(d)+.5),ylim=c(0,max(1,d$MaxShift[ok])*1.2),pch=19,col=color,xlab=guane_text('Taxon index (see table)',lang),ylab=guane_text('Maximum coefficient shift / full-fit SE',lang),cex.lab=.8)
 top<-which(ok)[order(d$MaxShift[ok],decreasing=TRUE)[seq_len(min(3,sum(ok)))]]
 graphics::text(top,d$MaxShift[top],labels=d$Taxon[top],pos=3,cex=.65)
 invisible(d)
}
guane_pglm_influence_script <- function(influence,color='#34765b',lang='en') {
 helpers<-c('guane_pglm','guane_pglm_grouped_fit','guane_pglm_influence','guane_pglm_influence_plot','guane_text')
 c('# Guane: leave-one-taxon-out sensitivity. Temporary pruning only; no automatic data exclusions.',
 '# Descriptive coefficient shifts, not Cook distance, p-values or cross-validation.',
 '# install.packages(c("ape","phylolm","gee"))',
 vapply(helpers,function(n) paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('settings',influence$settings),
 'result <- do.call(guane_pglm,settings)','influence <- guane_pglm_influence(result)','print(influence$table)',
 guane_r_assignment('plot_settings',list(color=color,lang=lang)),
 'do.call(guane_pglm_influence_plot,c(list(influence=influence),plot_settings))','sessionInfo()')
}
