core_mod_signal_PGLS <- function() list(implemented=TRUE)

# Use internal column names to preserve arbitrary research identifiers safely.
guane_pgls <- function(tree, traits, taxon, response, predictors, model='BM', value=.5, fixed=FALSE, method='REML') {
 if(!inherits(tree,'phylo') || !ape::is.rooted(tree) || !ape::is.binary(tree)) stop('PGLS requires a rooted, bifurcating tree.')
 if(is.null(tree$edge.length) || any(!is.finite(tree$edge.length)) || any(tree$edge.length<=0)) stop('PGLS requires finite, positive branch lengths.')
 if(!ape::is.ultrametric(tree)) stop('This PGLS implementation requires an ultrametric tree.')
 if(!is.data.frame(traits) || anyDuplicated(names(traits)) || length(taxon)!=1 || !taxon %in% names(traits)) stop('Select a unique taxon column in the trait table.')
 ids<-as.character(traits[[taxon]])
 if(anyNA(ids) || any(!nzchar(trimws(ids))) || anyDuplicated(ids) || anyNA(tree$tip.label) || anyDuplicated(tree$tip.label) || !setequal(ids,tree$tip.label)) stop('Match unique, nonempty taxon labels explicitly in Data before PGLS.')
 if(length(response)!=1 || !length(predictors) || anyDuplicated(predictors) || response %in% predictors || taxon %in% c(response,predictors) || !all(c(response,predictors) %in% names(traits))) stop('Select a response and distinct numeric predictors.')
 traits<-traits[match(tree$tip.label,ids),,drop=FALSE]
 columns<-traits[c(response,predictors)]
 if(!all(vapply(columns,function(x) is.numeric(x) && all(is.finite(x)) && length(unique(x))>1,logical(1)))) stop('PGLS variables must be finite, numeric and nonconstant. No rows are removed automatically.')
 if(nrow(traits)<4 || nrow(traits)<=length(predictors)+2) stop('PGLS needs at least four taxa and at least two residual degrees of freedom.')
 model<-match.arg(model,c('BM','Grafen','Pagel','Blomberg'));method<-match.arg(method,c('ML','REML'))
 if(length(value)!=1 || !is.finite(value) || (model=='Pagel' && (value<0 || value>1)) || (model %in% c('Grafen','Blomberg') && value<=0)) stop('Use lambda between 0 and 1, or a positive rho or g.')
 frame<-data.frame(.taxon=tree$tip.label,.response=traits[[response]])
 for(i in seq_along(predictors)) frame[[paste0('.x',i)]]<-traits[[predictors[i]]]
 formula<-stats::reformulate(paste0('.x',seq_along(predictors)),response='.response')
 design<-stats::model.matrix(formula,frame)
 if(qr(design)$rank<ncol(design)) stop('Predictors are collinear. Choose an independent set of predictors.')
 correlation<-switch(model,BM=ape::corBrownian(phy=tree,form=~.taxon),
  Grafen=ape::corGrafen(value,phy=tree,form=~.taxon,fixed=fixed),
  Pagel=ape::corPagel(value,phy=tree,form=~.taxon,fixed=fixed),
  Blomberg=ape::corBlomberg(value,phy=tree,form=~.taxon,fixed=fixed))
 warnings<-character()
 fit<-withCallingHandlers(nlme::gls(formula,data=frame,correlation=correlation,method=method,na.action=stats::na.fail),warning=function(w) {warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')})
 if(!is.finite(as.numeric(stats::logLik(fit))) || !is.finite(fit$sigma) || fit$sigma<=0 || any(!is.finite(stats::coef(fit)))) stop('PGLS returned an invalid fit; inspect inputs and correlation settings.')
 parameter<-stats::coef(fit$modelStruct$corStruct,unconstrained=FALSE)
 if(model=='Pagel' && (parameter<0 || parameter>1)) stop('Estimated lambda is outside the supported interval [0, 1]. Try a fixed value or another structure.')
 if(is.character(fit$apVar)) warnings<-c(warnings,fit$apVar)
 tab<-summary(fit)$tTable
 interval<-stats::qt(.975,nrow(frame)-ncol(design))*tab[,'Std.Error']
 coefficients<-data.frame(Term=c('(Intercept)',predictors),Estimate=tab[,'Value'],SE=tab[,'Std.Error'],Lower=tab[,'Value']-interval,Upper=tab[,'Value']+interval,P=tab[,'p-value'],row.names=NULL)
 points<-data.frame(Taxon=frame$.taxon,Observed=frame$.response,Fitted=as.numeric(stats::fitted(fit)),Residual=as.numeric(stats::residuals(fit,type='normalized')))
 list(fit=fit,tree=tree,traits=traits,taxon=taxon,response=response,predictors=predictors,model=model,value=value,fixed=fixed,method=method,parameter=parameter,coefficients=coefficients,points=points,warnings=unique(warnings))
}

# Ordinary base R graphics, also embedded verbatim in editable exports.
guane_pgls_plot <- function(result, type='fit', color='#34765b', labels=FALSE, text=list(fitted='Fitted values',observed='Observed values',estimate='Coefficient estimate',interval='95% coefficient intervals',residual='Normalized residuals',quantiles='Theoretical quantiles')) {
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 d<-result$points
 if(type=='coefficients') {
  z<-result$coefficients;y<-rev(seq_len(nrow(z)))
  graphics::par(mar=c(5,min(18,max(5,max(nchar(z$Term))*.45)),3,1))
  graphics::plot(z$Estimate,y,xlim=range(c(z$Lower,z$Upper,0)),ylim=c(.5,nrow(z)+.5),yaxt='n',ylab='',xlab=text$estimate,main=text$interval,pch=19,col=color)
  graphics::axis(2,at=y,labels=z$Term,las=1,cex.axis=.85)
  graphics::abline(v=0,lty=2,col='grey65');graphics::segments(z$Lower,y,z$Upper,y,col=color,lwd=2)
 } else if(type=='diagnostics') {
  graphics::par(mfrow=c(1,2),mar=c(5,5,2,1))
  graphics::plot(d$Fitted,d$Residual,xlab=text$fitted,ylab=text$residual,pch=19,col=color)
  graphics::abline(h=0,lty=2,col='grey65')
  stats::qqnorm(d$Residual,main='',xlab=text$quantiles,ylab=text$residual,pch=19,col=color)
  stats::qqline(d$Residual,col='grey40',lty=2)
 } else {
  graphics::par(mar=c(5,5,2,2))
  limits<-range(c(d$Observed,d$Fitted))
  graphics::plot(d$Fitted,d$Observed,xlim=limits,ylim=limits,xlab=paste(text$fitted,result$response,sep=': '),ylab=paste(text$observed,result$response,sep=': '),pch=19,col=color)
  graphics::abline(a=0,b=1,lty=2,col='grey50')
  if(labels) graphics::text(d$Fitted,d$Observed,labels=d$Taxon,pos=3,cex=.7,col=color)
 }
 invisible(result$points)
}

guane_pgls_plot_text <- function(lang='en') {
 keys<-c(fitted='Fitted values',observed='Observed values',estimate='Coefficient estimate',interval='95% coefficient intervals',residual='Normalized residuals',quantiles='Theoretical quantiles')
 as.list(vapply(keys,guane_text,character(1),lang=lang))
}

guane_pgls_script <- function(result, type='fit', color='#34765b', labels=FALSE, lang='en') {
 c('# Guane PGLS: self-contained analysis and editable base R graphics.',
   '# Open in RStudio and Source. Edit plot_type, plot_color, show_taxa and plot_text below.',
   '# These are prepared species-level inputs; no PIC or additional covariance correction is applied.',
   '# Install once if needed: install.packages(c("ape", "nlme"))',
   paste0('# Export environment: R ',getRversion(),'; ape ',utils::packageVersion('ape'),'; nlme ',utils::packageVersion('nlme')),
   paste0('guane_pgls <- ',paste(deparse(guane_pgls),collapse='\n')),
   paste0('guane_pgls_plot <- ',paste(deparse(guane_pgls_plot),collapse='\n')),
   guane_r_assignment('tree',result$tree),guane_r_assignment('traits',result$traits),
   guane_r_assignment('settings',result[c('taxon','response','predictors','model','value','fixed','method')]),
   'result <- do.call(guane_pgls, c(list(tree=tree, traits=traits), settings))',
   'print(result$coefficients)', 'print(result$warnings)',
   guane_r_assignment('plot_type',type),guane_r_assignment('plot_color',color),guane_r_assignment('show_taxa',labels),guane_r_assignment('plot_text',guane_pgls_plot_text(lang)),
   'guane_pgls_plot(result, type=plot_type, color=plot_color, labels=show_taxa, text=plot_text)',
   '# Optional: pdf("guane-pgls.pdf", width=9, height=6); guane_pgls_plot(result, plot_type, plot_color, show_taxa, plot_text); dev.off()',
   'sessionInfo()')
}

# Compare covariance structures on exactly one data/formula snapshot, always ML.
guane_pgls_compare <- function(tree,traits,taxon,response,predictors,value=.5,fixed=FALSE) {
 settings<-list(tree=tree,traits=traits,taxon=taxon,response=response,predictors=predictors,value=value,fixed=fixed,method='ML')
 models<-c('BM','Grafen','Pagel','Blomberg')
 fits<-setNames(lapply(models,function(model) tryCatch(do.call(guane_pgls,c(settings,list(model=model))),error=identity)),models)
 table<-do.call(rbind,lapply(models,function(model) {
  r<-fits[[model]]
  if(inherits(r,'error')) return(data.frame(Model=model,N=NA_integer_,Parameters=NA_integer_,logLik=NA_real_,AIC=NA_real_,Delta=NA_real_,Weight=NA_real_,Message=conditionMessage(r)))
  ll<-stats::logLik(r$fit)
  data.frame(Model=model,N=nrow(r$points),Parameters=attr(ll,'df'),logLik=as.numeric(ll),AIC=stats::AIC(r$fit),Delta=NA_real_,Weight=NA_real_,Message=paste(r$warnings,collapse='; '))
 }))
 ok<-is.finite(table$AIC)
 if(sum(ok)>=2) {
  table$Delta[ok]<-table$AIC[ok]-min(table$AIC[ok]);w<-exp(-table$Delta[ok]/2);table$Weight[ok]<-w/sum(w)
 }
 list(table=table,settings=settings,fits=fits)
}
guane_pgls_compare_plot <- function(comparison,color='#34765b',lang='en') {
 old<-graphics::par(no.readonly=TRUE);on.exit(graphics::par(old))
 d<-comparison$table;d<-d[is.finite(d$Delta),]
 if(nrow(d)<2) {graphics::plot.new();graphics::text(.5,.5,guane_text('At least two valid models are needed for comparison.',lang));return(invisible(d))}
 d<-d[order(d$Delta,decreasing=TRUE),]
 graphics::par(mar=c(5,6,3,1))
 graphics::barplot(d$Delta,names.arg=d$Model,horiz=TRUE,las=1,col=color,xlab=guane_text('Delta AIC (ML)',lang),xlim=c(0,max(1,d$Delta)*1.1))
 invisible(d)
}
guane_pgls_compare_script <- function(comparison,color='#34765b',lang='en') {
 helpers<-c('guane_pgls','guane_pgls_compare','guane_pgls_compare_plot','guane_text')
 c('# Guane: same-data ML covariance comparison. No likelihood-ratio tests or model averaging.',
 '# install.packages(c("ape","nlme"))',
 vapply(helpers,function(n) paste0(n,' <- ',paste(deparse(get(n,mode='function')),collapse='\n')),character(1)),
 guane_r_assignment('settings',comparison$settings[setdiff(names(comparison$settings),'method')]),
 'comparison <- do.call(guane_pgls_compare,settings)','print(comparison$table)',
 guane_r_assignment('plot_settings',list(color=color,lang=lang)),
 'do.call(guane_pgls_compare_plot,c(list(comparison=comparison),plot_settings))','sessionInfo()')
}
