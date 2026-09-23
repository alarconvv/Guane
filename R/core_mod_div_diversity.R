core_mod_div_diversity <- function() list(implemented=TRUE,backend='DDD::dd_ML',models=c(1,1.3,2,3,4,5))

guane_dd_numbers <- function(x,n=NULL) {
 z<-suppressWarnings(as.numeric(strsplit(gsub(' ','',x,fixed=TRUE),',',fixed=TRUE)[[1]]))
 if(!length(z)||any(!is.finite(z))||(!is.null(n)&&length(z)!=n))stop('Invalid numeric settings.')
 z
}

guane_dd_fit <- function(tree,models=c(1,3),missing=0,res=NULL,cond=1,btorph=1,
 starts=c(3,.2,40,1),free=c('lambda','mu','K'),tol=c(.001,.0001,.000001),
 tolint=c(1e-10,1e-8),maxiter=1000,cycles=1,optimizer='simplex',method='analytical',threshold=0,change=FALSE,verbose=FALSE) {
 if(!requireNamespace('DDD',quietly=TRUE))stop('Install DDD to run this analysis.')
 tree<-guane_rates_data(tree);brts<-sort(as.numeric(ape::branching.times(tree)),decreasing=TRUE)
 integer_ok<-function(x,lo)length(x)==1&&is.finite(x)&&x==floor(x)&&x>=lo
 if(!integer_ok(missing,0)||!integer_ok(maxiter,1)||!integer_ok(cycles,1))stop('Invalid numeric settings.')
 if(is.null(res))res<-10*(length(brts)+1+missing)
 if(!integer_ok(res,length(brts)+missing+2)||!length(models)||any(!models%in%core_mod_div_diversity()$models)||anyDuplicated(models)||!cond%in%0:3||!btorph%in%0:1)stop('Invalid model or likelihood settings.')
 if(length(starts)!=4||any(!is.finite(starts))||any(starts[c(1,3,4)]<=0)||starts[2]<0||!length(free)||any(!free%in%c('lambda','mu','K','r'))||anyDuplicated(free))stop('Use positive lambda, K and r and nonnegative mu starting/fixed values and select estimated parameters.')
 if(length(tol)!=3||length(tolint)!=2||any(!is.finite(c(tol,tolint)))||any(c(tol,tolint)<=0)||!is.finite(threshold)||threshold<0||threshold>1)stop('Invalid numeric settings.')
 if(!optimizer%in%c('simplex','subplex')||!method%in%c('analytical','odeint::runge_kutta_cash_karp54'))stop('Unsupported numerical method.')
 inputs<-as.list(environment())[c('models','missing','res','cond','btorph','starts','free','tol','tolint','maxiter','cycles','optimizer','method','threshold','change','verbose')]
 fits<-list();calls<-list();logs<-list();rows<-list()
 for(m in models){
  key<-as.character(m);namespars<-c('lambda','mu','K',if(m==5)'r');ids<-which(namespars%in%free);fixed<-setdiff(seq_along(namespars),ids)
  if(!length(ids))stop('Select at least one estimated parameter for each model.')
  args<-list(brts=brts,initparsopt=starts[ids],idparsopt=ids,idparsfix=fixed,parsfix=starts[fixed],res=res,ddmodel=m,missnumspec=missing,cond=cond,btorph=btorph,soc=2,tol=tol,tolint=tolint,maxiter=maxiter,num_cycles=cycles,optimmethod=optimizer,methode=method,probs_threshold=threshold,changeloglikifnoconv=change,verbose=verbose)
  calls[[key]]<-args;warnings<-character();error<-NULL
  log<-capture.output(fit<-tryCatch(withCallingHandlers(do.call(DDD::dd_ML,args),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=function(e){error<<-conditionMessage(e);NULL}))
  ok<-!is.null(fit)&&all(c('loglik','conv','df')%in%names(fit))&&is.finite(fit$loglik)&&fit$conv==0&&fit$df>=0
  fits[key]<-list(fit);logs[[key]]<-c(log,warnings,error)
  rows[[key]]<-data.frame(Model=key,LogLik=if(is.null(fit))NA_real_ else fit$loglik,Parameters=length(ids),Converged=ok,AIC=if(ok)2*length(ids)-2*fit$loglik else NA_real_,Message=paste(c(warnings,error),collapse=' | '))
 }
 comparison<-do.call(rbind,rows);rownames(comparison)<-NULL;comparison$DeltaAIC<-comparison$Weight<-NA_real_
 if(all(comparison$Converged)){comparison$DeltaAIC<-comparison$AIC-min(comparison$AIC);w<-exp(-comparison$DeltaAIC/2);comparison$Weight<-w/sum(w)}
 list(tree=tree,brts=brts,inputs=inputs,calls=calls,fits=fits,comparison=comparison,logs=logs,version=as.character(utils::packageVersion('DDD')),diagnostics=NULL)
}

guane_dd_diagnose <- function(result,factor=2) {
 if(length(factor)!=1||!is.finite(factor)||factor<=1)stop('Invalid numeric settings.')
 rows<-lapply(names(result$fits),function(k){
  f<-result$fits[[k]];if(is.null(f)||!isTRUE(result$comparison$Converged[result$comparison$Model==k]))return(NULL)
  a<-result$calls[[k]];p<-as.numeric(f[1,c('lambda','mu','K',if(k=='5')'r')]);r<-ceiling(a$res*factor)
  settings<-c(r,a$ddmodel,a$cond,a$btorph,0,a$soc,a$tol,a$maxiter,a$tolint/10,a$probs_threshold)
  value<-tryCatch(DDD::dd_loglik(p,settings,a$brts,a$missnumspec,methode=a$methode),error=function(e)NA_real_)
  data.frame(Model=k,Original=f$loglik,Refined=value,Delta=value-f$loglik,Resolution=r,Stable=is.finite(value)&&abs(value-f$loglik)<=1e-4)
 })
 result$diagnostics<-do.call(rbind,rows);result$diagnostic_factor<-factor
 if(all(result$comparison$Converged)){result$comparison$DeltaAIC<-result$comparison$AIC-min(result$comparison$AIC);w<-exp(-result$comparison$DeltaAIC/2);result$comparison$Weight<-w/sum(w)}
 if(isTRUE(result$fit_review_required)||(!is.null(result$diagnostics)&&any(!result$diagnostics$Stable))){result$comparison$Weight<-result$comparison$DeltaAIC<-NA_real_}
 result
}

guane_dd_plot <- function(result,type='rates',model=names(result$fits)[1],palette='Guane',maxdiv=100,lang='en',parameter='lambda') {
 txt<-function(x)guane_text(x,lang);col<-if(palette=='Grayscale')c('#333333','#999999') else c('#17685f','#bd6937')
 if(type%in%c('profile','robustness','bootstrap')){
  u<-result$uncertainty;if(is.null(u))stop('Run uncertainty and robustness first.')
  if(type=='profile'){
   d<-u$profile;if(is.null(d))stop('Run uncertainty and robustness first.')
   graphics::plot(d$Value,d$Deviance,type='b',col=col[1],xlab=u$settings$parameter,ylab='2 * Delta logLik',main=paste('ddmodel',u$settings$model));graphics::abline(h=stats::qchisq(u$settings$level,1),lty=2);return(invisible(d))
  }
  if(type=='robustness'){
   d<-u$robustness;if(is.null(d))stop('Run uncertainty and robustness first.')
   graphics::barplot(d$Delta,names.arg=d$Scenario,col=col[1],ylab=txt('Likelihood change'),cex.names=.8);graphics::abline(h=0,lty=2);return(invisible(d))
  }
  d<-u$bootstrap;if(is.null(d)||!parameter%in%c('lambda','mu','K','r')||!parameter%in%names(d))stop('Run uncertainty and robustness first.')
  x<-d[d$Converged,parameter];x<-x[is.finite(x)];if(length(x)<2)stop('Insufficient successful bootstrap refits.')
  graphics::hist(x,col=col[1],main=paste('ddmodel',u$settings$model),xlab=parameter,ylab=txt('Frequency'));return(invisible(d))
 }
 if(type=='comparison'){
  d<-result$comparison;if(any(!is.finite(d$DeltaAIC)))stop('Compatible converged fits are required for comparison.')
  graphics::barplot(d$DeltaAIC,names.arg=d$Model,col=col[1],ylab='Delta AIC',xlab='ddmodel');return(invisible(d))
 }
 if(type=='diagnostics'){
  d<-result$diagnostics;if(is.null(d))stop('Run numerical diagnostics first.')
  graphics::barplot(d$Delta,names.arg=d$Model,col=col[1],ylab=txt('Likelihood change'),xlab='ddmodel');graphics::abline(h=0,lty=2);return(invisible(d))
 }
 if(type=='ltt'){
  ape::ltt.plot(result$tree,main=txt('Observed reconstructed lineages'),xlab=txt('Time'),ylab=txt('Lineages'));return(invisible(result$brts))
 }
 if(!isTRUE(result$comparison$Converged[result$comparison$Model==model]))stop('Select a converged model.')
 if(length(maxdiv)!=1||!is.finite(maxdiv)||maxdiv<2||maxdiv>10000)stop('Invalid numeric settings.')
 f<-result$fits[[model]];p<-as.numeric(f[1,c('lambda','mu','K',if(model=='5')'r')]);n<-seq(1,maxdiv,length.out=300)
 # Use the installed DDD rate definition, also used by its simulator.
 rates<-vapply(n,function(z)getFromNamespace('dd_lamuN','DDD')(as.numeric(model),p,z),numeric(2))
 if(any(!is.finite(rates))||any(rates<0))stop('Rate curves are invalid over the selected diversity range.')
 graphics::matplot(n,t(rates),type='l',lty=c(1,2),col=col,lwd=2,ylim=c(0,max(rates)*1.18),xlab=txt('Species diversity'),ylab=txt('Rate per branch-length unit'),main=paste('ddmodel',model))
 graphics::legend('topright',c('lambda','mu'),col=col,lty=c(1,2),lwd=2,bty='n')
 invisible(data.frame(Diversity=n,lambda=rates[1,],mu=rates[2,]))
}

guane_dd_script <- function(result,settings) {
 c('# Guane diversity-dependent model: saved result and editable plot.', '# Requires DDD and ape. No app is needed.',
 guane_r_assignment('result',result),guane_r_assignment('settings',settings),
 paste('guane_text <-',paste(deparse(guane_text),collapse='\n')),paste('guane_dd_plot <-',paste(deparse(guane_dd_plot),collapse='\n')),
 '# Refit explicitly if desired: do.call(DDD::dd_ML, result$calls[[1]])',
 'pdf("guane-diversity.pdf",width=10,height=7)', 'do.call(guane_dd_plot,c(list(result=result),settings))','dev.off()')
}

# Refit a saved likelihood with explicit parameter starts/fixes; never mutate its data.
guane_dd_refit <- function(args) {
 warnings<-character();error<-''
 log<-capture.output(fit<-tryCatch(withCallingHandlers(do.call(DDD::dd_ML,args),warning=function(w){warnings<<-c(warnings,conditionMessage(w));invokeRestart('muffleWarning')}),error=function(e){error<<-conditionMessage(e);NULL}))
 ok<-!is.null(fit)&&isTRUE(fit$conv==0)&&is.finite(fit$loglik)&&fit$df>=0
 list(fit=fit,ok=ok,message=paste(c(error,warnings),collapse=' | '),log=log)
}
guane_dd_likelihood <- function(pars,args) {
 DDD::dd_loglik(pars,c(args$res,args$ddmodel,args$cond,args$btorph,0,args$soc,args$tol,args$maxiter,args$tolint,args$probs_threshold),args$brts,args$missnumspec,methode=args$methode)
}
guane_dd_uncertainty <- function(result,model='1',parameter='lambda',lower=.1,upper=10,points=21,level=.95,profiles=TRUE,robustness=TRUE,start_factors=c(.5,2),resolution_factor=2,bootstrap=FALSE,nsim=20,seed=999,seconds=30) {
 if(!model%in%names(result$fits)||!isTRUE(result$comparison$Converged[result$comparison$Model==model]))stop('Select a converged model.')
 a<-result$calls[[model]];namesp<-c('lambda','mu','K',if(model=='5')'r');p<-as.numeric(result$fits[[model]][1,namesp]);names(p)<-namesp;best<-result$fits[[model]]$loglik
 whole<-function(x,lo,hi)length(x)==1&&is.finite(x)&&x==floor(x)&&x>=lo&&x<=hi
 if(!whole(points,5,101)||!whole(nsim,2,500)||!whole(seed,0,2147483647)||length(level)!=1||!is.finite(level)||level<=0||level>=1||!is.finite(resolution_factor)||resolution_factor<=1||!is.finite(seconds)||seconds<=0||!length(start_factors)||any(!is.finite(start_factors))||any(start_factors<=0))stop('Invalid numeric settings.')
 if(bootstrap&&(a$missnumspec!=0||a$cond!=1||a$soc!=2))stop('Bootstrap requires complete sampling and crown-survival conditioning (cond = 1).')
 if(any(!is.finite(p)))stop('Finite estimates are required for uncertainty analysis.')
 saved<-as.list(environment())[c('model','parameter','lower','upper','points','level','profiles','robustness','start_factors','resolution_factor','bootstrap','nsim','seed','seconds')]
 u<-list(settings=saved,profile=NULL,interval=NULL,robustness=NULL,bootstrap=NULL,bootstrap_intervals=NULL,messages=character())
 if(profiles){
  j<-match(parameter,namesp)
  if(is.na(j)||!j%in%a$idparsopt)stop('Select an estimated parameter for profiling.')
  if(length(lower)!=1||length(upper)!=1||any(!is.finite(c(lower,upper)))||lower<0||(parameter!='mu'&&lower<=0)||lower>=p[j]||upper<=p[j])stop('Profile limits must bracket the saved estimate.')
  grid<-sort(unique(c(seq(lower,upper,length.out=points),p[j])))
  rows<-lapply(grid,function(v){
   z<-a;ids<-setdiff(a$idparsopt,j);z$idparsopt<-ids;z$idparsfix<-setdiff(seq_along(p),ids);q<-p;q[j]<-v;z$initparsopt<-q[ids];z$parsfix<-q[z$idparsfix]
   if(!length(ids)){ll<-tryCatch(guane_dd_likelihood(q,z),error=function(e)NA_real_);ok<-is.finite(ll);msg<-''}else{f<-guane_dd_refit(z);ok<-f$ok;ll<-if(ok)f$fit$loglik else NA_real_;msg<-f$message}
   data.frame(Value=v,LogLik=ll,Converged=ok,Message=msg)
  })
  d<-do.call(rbind,rows);d$Deviance<-2*(best-d$LogLik);cutoff<-stats::qchisq(level,1);center<-which.min(abs(d$Value-p[j]));improved<-any(d$LogLik>best+1e-4,na.rm=TRUE)
  # Only bracket crossings connected to the MLE; never bridge failed grid points.
  limit<-function(side){ix<-if(side<0)seq(center,1) else seq(center,nrow(d));prev<-center
   for(i in ix){if(!d$Converged[i]||!is.finite(d$Deviance[i]))return(list(value=NA_real_,status='Failed profile point'))
    if(d$Deviance[i]>=cutoff){v<-d$Value[prev]+(d$Value[i]-d$Value[prev])*(cutoff-d$Deviance[prev])/(d$Deviance[i]-d$Deviance[prev]);return(list(value=v,status='Grid-interpolated crossing'))};prev<-i}
   list(value=NA_real_,status='Search limit reached')}
  lo<-limit(-1);hi<-limit(1)
  if(improved){lo<-hi<-list(value=NA_real_,status='Better likelihood found');u$messages<-c(u$messages,'Better likelihood found. Refit before interpreting uncertainty.')}
  u$profile<-d;u$interval<-data.frame(Model=model,Parameter=parameter,Level=level,Estimate=p[j],Lower=lo$value,Upper=hi$value,Lower_status=lo$status,Upper_status=hi$status)
 }
 if(robustness){
  scenarios<-c(paste0('start x ',start_factors),'resolution + tolerance')
  u$robustness<-do.call(rbind,lapply(seq_along(scenarios),function(i){z<-a;z$initparsopt<-p[z$idparsopt]
   if(i<=length(start_factors))z$initparsopt<-p[z$idparsopt]*start_factors[i] else {z$res<-ceiling(a$res*resolution_factor);z$tolint<-a$tolint/10}
   f<-guane_dd_refit(z);data.frame(Scenario=scenarios[i],Converged=f$ok,LogLik=if(f$ok)f$fit$loglik else NA_real_,Delta=if(f$ok)f$fit$loglik-best else NA_real_,Resolution=z$res,Message=f$message)
  }))
  if(any(u$robustness$Delta>1e-4,na.rm=TRUE))u$messages<-c(u$messages,'Better likelihood found. Refit before interpreting uncertainty.')
 }
 if(bootstrap){
  had<-exists('.Random.seed',.GlobalEnv,inherits=FALSE);if(had)rng<-get('.Random.seed',.GlobalEnv)
  on.exit(if(had)assign('.Random.seed',rng,.GlobalEnv) else if(exists('.Random.seed',.GlobalEnv,inherits=FALSE))rm('.Random.seed',envir=.GlobalEnv),add=TRUE);set.seed(seed)
  rows<-vector('list',nsim);brts<-vector('list',nsim)
  for(i in seq_len(nsim)){
   ntips<-NA_integer_;z<-a;msg<-'';f<-NULL
   tryCatch({setTimeLimit(elapsed=seconds,transient=TRUE)
    sim<-DDD::dd_sim(unname(p),max(a$brts),ddmodel=a$ddmodel);z$brts<-sort(as.numeric(ape::branching.times(sim$tes)),decreasing=TRUE);ntips<-length(z$brts)+1L;brts[[i]]<-z$brts
    z$res<-max(a$res,ntips+10);z$initparsopt<-p[z$idparsopt];f<-guane_dd_refit(z)
   },error=function(e)msg<<-conditionMessage(e),finally=setTimeLimit(cpu=Inf,elapsed=Inf,transient=FALSE))
   ok<-!is.null(f)&&f$ok&&all(is.finite(as.numeric(f$fit[1,namesp])));if(!is.null(f)&&f$ok&&!ok)msg<-'Non-finite bootstrap parameter estimates.';values<-rep(NA_real_,length(p));names(values)<-namesp;if(ok)values<-as.numeric(f$fit[1,namesp]);names(values)<-namesp
   rows[[i]]<-cbind(data.frame(Replicate=i,Tips=ntips,Converged=ok,Resolution=z$res,Message=paste(msg,if(!is.null(f))f$message else '')),as.data.frame(as.list(values)))
  }
  b<-do.call(rbind,rows);u$bootstrap<-b;u$bootstrap_brts<-brts
  success<-sum(b$Converged)
  if(success>=20&&success/nsim>=.9){u$bootstrap_intervals<-do.call(rbind,lapply(namesp[a$idparsopt],function(n){q<-stats::quantile(b[b$Converged,n],c((1-level)/2,1-(1-level)/2),na.rm=TRUE);data.frame(Parameter=n,Level=level,Lower=q[1],Upper=q[2],Successful=success,Requested=nsim)}))}else u$messages<-c(u$messages,'Bootstrap intervals require at least 20 successful refits and 90% success.')
 }
 unstable<-!is.null(u$robustness)&&(!isTRUE(tail(u$robustness$Converged,1))||!is.finite(tail(u$robustness$Delta,1))||abs(tail(u$robustness$Delta,1))>1e-4)
 if(unstable){result$fit_review_required<-TRUE;u$messages<-c(u$messages,'Numerical instability: refine the fit before interpreting intervals.');u$bootstrap_intervals<-NULL;if(!is.null(u$interval)){u$interval$Lower<-u$interval$Upper<-NA_real_;u$interval$Lower_status<-u$interval$Upper_status<-'Numerical instability'};result$comparison$Weight<-result$comparison$DeltaAIC<-NA_real_}
 if(isTRUE(result$fit_review_required)){u$bootstrap_intervals<-NULL;if(!is.null(u$interval)){u$interval$Lower<-u$interval$Upper<-NA_real_;u$interval$Lower_status<-u$interval$Upper_status<-'Numerical instability'};u$messages<-unique(c(u$messages,'Numerical instability: refine the fit before interpreting intervals.'));result$comparison$Weight<-result$comparison$DeltaAIC<-NA_real_}
 result$uncertainty<-u
 if(length(u$messages)&&any(grepl('Better likelihood',u$messages))){result$fit_review_required<-TRUE;result$comparison$Weight<-result$comparison$DeltaAIC<-NA_real_;if(!is.null(u$interval)){result$uncertainty$interval$Lower<-result$uncertainty$interval$Upper<-NA_real_;result$uncertainty$interval$Lower_status<-result$uncertainty$interval$Upper_status<-'Better likelihood found'};result$uncertainty$bootstrap_intervals<-NULL}
 result
}
